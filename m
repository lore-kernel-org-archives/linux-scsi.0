From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 04/41] hpsa: clean up aborts
Date: Fri, 06 Mar 2015 17:46:08 -0600
Message-ID: <20150306234608.29973.30251.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:39437 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbbCFXri (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:47:38 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Do not send aborts to logical devices that do not support aborts

Instead of relying on what the Smart Array claims for supporting logical
drives, simply try an abort and see how it responds at device discovery
time.  This way devices that do support aborts (e.g. MSA2000) can work
and we do not waste time trying to send aborts to logical drives that do
not support them (important for high IOPS devices.)

While rescanning devices only test whether devices support aborts
the first time we encounter a device rather than every time.

Some Smart Arrays required aborts to be sent with tags in
the wrong endian byte order.  To avoid having to know about
this, we would send two aborts with tags with each endian order.
On high IOPS devices, this turns out to be not such a hot idea.
So we now have a list of the devices that got the tag backwards,
and we only send it one way.

If all available commands are outstanding and the abort handler
is invoked, the abort handler may not be able to allocate a command
and may busy-wait excessivly.  Reserve a small number of commands
for the abort handler and limit the number of concurrent abort
requests to the number of reserved commands.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  176 +++++++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/hpsa.h |    4 +
 2 files changed, 147 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ee5c1b8..ca3a860 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -428,7 +428,7 @@ static ssize_t host_show_hp_ssd_smart_path_status(struct device *dev,
 /* List of controllers which cannot be hard reset on kexec with reset_devices */
 static u32 unresettable_controller[] = {
 	0x324a103C, /* Smart Array P712m */
-	0x324b103C, /* SmartArray P711m */
+	0x324b103C, /* Smart Array P711m */
 	0x3223103C, /* Smart Array P800 */
 	0x3234103C, /* Smart Array P400 */
 	0x3235103C, /* Smart Array P400i */
@@ -470,24 +470,32 @@ static u32 soft_unresettable_controller[] = {
 	0x409D0E11, /* Smart Array 6400 EM */
 };
 
-static int ctlr_is_hard_resettable(u32 board_id)
+static u32 needs_abort_tags_swizzled[] = {
+	0x323D103C, /* Smart Array P700m */
+	0x324a103C, /* Smart Array P712m */
+	0x324b103C, /* SmartArray P711m */
+};
+
+static int board_id_in_array(u32 a[], int nelems, u32 board_id)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(unresettable_controller); i++)
-		if (unresettable_controller[i] == board_id)
-			return 0;
-	return 1;
+	for (i = 0; i < nelems; i++)
+		if (a[i] == board_id)
+			return 1;
+	return 0;
 }
 
-static int ctlr_is_soft_resettable(u32 board_id)
+static int ctlr_is_hard_resettable(u32 board_id)
 {
-	int i;
+	return !board_id_in_array(unresettable_controller,
+			ARRAY_SIZE(unresettable_controller), board_id);
+}
 
-	for (i = 0; i < ARRAY_SIZE(soft_unresettable_controller); i++)
-		if (soft_unresettable_controller[i] == board_id)
-			return 0;
-	return 1;
+static int ctlr_is_soft_resettable(u32 board_id)
+{
+	return !board_id_in_array(soft_unresettable_controller,
+			ARRAY_SIZE(soft_unresettable_controller), board_id);
 }
 
 static int ctlr_is_resettable(u32 board_id)
@@ -496,6 +504,12 @@ static int ctlr_is_resettable(u32 board_id)
 		ctlr_is_soft_resettable(board_id);
 }
 
+static int ctlr_needs_abort_tags_swizzled(u32 board_id)
+{
+	return board_id_in_array(needs_abort_tags_swizzled,
+			ARRAY_SIZE(needs_abort_tags_swizzled), board_id);
+}
+
 static ssize_t host_show_resettable(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
@@ -2841,6 +2855,50 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 	return 0;
 }
 
+/*
+ * Find out if a logical device supports aborts by simply trying one.
+ * Smart Array may claim not to support aborts on logical drives, but
+ * if a MSA2000 * is connected, the drives on that will be presented
+ * by the Smart Array as logical drives, and aborts may be sent to
+ * those devices successfully.  So the simplest way to find out is
+ * to simply try an abort and see how the device responds.
+ */
+static int hpsa_device_supports_aborts(struct ctlr_info *h,
+					unsigned char *scsi3addr)
+{
+	struct CommandList *c;
+	struct ErrorInfo *ei;
+	int rc = 0;
+
+	u64 tag = (u64) -1; /* bogus tag */
+
+	/* Assume that physical devices support aborts */
+	if (!is_logical_dev_addr_mode(scsi3addr))
+		return 1;
+
+	c = cmd_alloc(h);
+	if (!c)
+		return -ENOMEM;
+	(void) fill_cmd(c, HPSA_ABORT_MSG, h, &tag, 0, 0, scsi3addr, TYPE_MSG);
+	(void) hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	/* no unmap needed here because no data xfer. */
+	ei = c->err_info;
+	switch (ei->CommandStatus) {
+	case CMD_INVALID:
+		rc = 0;
+		break;
+	case CMD_UNABORTABLE:
+	case CMD_ABORT_FAILED:
+		rc = 1;
+		break;
+	default:
+		rc = 0;
+		break;
+	}
+	cmd_free(h, c);
+	return rc;
+}
+
 static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
 	unsigned char *is_OBDR_device)
@@ -2907,7 +2965,6 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 					strncmp(obdr_sig, OBDR_TAPE_SIG,
 						OBDR_SIG_LEN) == 0);
 	}
-
 	kfree(inq_buff);
 	return 0;
 
@@ -2916,6 +2973,31 @@ bail_out:
 	return 1;
 }
 
+static void hpsa_update_device_supports_aborts(struct ctlr_info *h,
+			struct hpsa_scsi_dev_t *dev, u8 *scsi3addr)
+{
+	unsigned long flags;
+	int rc, entry;
+	/*
+	 * See if this device supports aborts.  If we already know
+	 * the device, we already know if it supports aborts, otherwise
+	 * we have to find out if it supports aborts by trying one.
+	 */
+	spin_lock_irqsave(&h->devlock, flags);
+	rc = hpsa_scsi_find_entry(dev, h->dev, h->ndevices, &entry);
+	if ((rc == DEVICE_SAME || rc == DEVICE_UPDATED) &&
+		entry >= 0 && entry < h->ndevices) {
+		dev->supports_aborts = h->dev[entry]->supports_aborts;
+		spin_unlock_irqrestore(&h->devlock, flags);
+	} else {
+		spin_unlock_irqrestore(&h->devlock, flags);
+		dev->supports_aborts =
+				hpsa_device_supports_aborts(h, scsi3addr);
+		if (dev->supports_aborts < 0)
+			dev->supports_aborts = 0;
+	}
+}
+
 static unsigned char *ext_target_model[] = {
 	"MSA2012",
 	"MSA2024",
@@ -3021,6 +3103,7 @@ static int add_ext_target_dev(struct ctlr_info *h,
 	(*n_ext_target_devs)++;
 	hpsa_set_bus_target_lun(this_device,
 				tmpdevice->bus, tmpdevice->target, 0);
+	hpsa_update_device_supports_aborts(h, this_device, scsi3addr);
 	set_bit(tmpdevice->target, lunzerobits);
 	return 1;
 }
@@ -3275,6 +3358,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 							&is_OBDR))
 			continue; /* skip it if we can't talk to it. */
 		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
+		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
 		this_device = currentsd[ncurrent];
 
 		/*
@@ -4586,7 +4670,7 @@ static void hpsa_get_tag(struct ctlr_info *h,
 }
 
 static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
-	struct CommandList *abort, int swizzle, int reply_queue)
+	struct CommandList *abort, int reply_queue)
 {
 	int rc = IO_OK;
 	struct CommandList *c;
@@ -4600,9 +4684,9 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	}
 
 	/* fill_cmd can't fail here, no buffer to map */
-	(void) fill_cmd(c, HPSA_ABORT_MSG, h, abort,
+	(void) fill_cmd(c, HPSA_ABORT_MSG, h, &abort->Header.tag,
 		0, 0, scsi3addr, TYPE_MSG);
-	if (swizzle)
+	if (h->needs_abort_tags_swizzled)
 		swizzle_abort_tag(&c->Request.CDB[4]);
 	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
@@ -4708,12 +4792,6 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 	return rc; /* success */
 }
 
-/* Some Smart Arrays need the abort tag swizzled, and some don't.  It's hard to
- * tell which kind we're dealing with, so we send the abort both ways.  There
- * shouldn't be any collisions between swizzled and unswizzled tags due to the
- * way we construct our tags but we check anyway in case the assumptions which
- * make this true someday become false.
- */
 static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	unsigned char *scsi3addr, struct CommandList *abort, int reply_queue)
 {
@@ -4725,9 +4803,7 @@ static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	if (abort->cmd_type == CMD_IOACCEL2)
 		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr,
 							abort, reply_queue);
-
-	return hpsa_send_abort(h, scsi3addr, abort, 0, reply_queue) &&
-			hpsa_send_abort(h, scsi3addr, abort, 1, reply_queue);
+	return hpsa_send_abort(h, scsi3addr, abort, reply_queue);
 }
 
 /* Find out which reply queue a command was meant to return on */
@@ -4739,6 +4815,18 @@ static int hpsa_extract_reply_queue(struct ctlr_info *h,
 	return c->Header.ReplyQueue;
 }
 
+/*
+ * Limit concurrency of abort commands to prevent
+ * over-subscription of commands
+ */
+static inline int wait_for_available_abort_cmd(struct ctlr_info *h)
+{
+#define ABORT_CMD_WAIT_MSECS 5000
+	return !wait_event_timeout(h->abort_cmd_wait_queue,
+			atomic_dec_if_positive(&h->abort_cmds_available) >= 0,
+			msecs_to_jiffies(ABORT_CMD_WAIT_MSECS));
+}
+
 /* Send an abort for the specified command.
  *	If the device and controller support it,
  *		send a task abort request.
@@ -4756,10 +4844,12 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	__le32 tagupper, taglower;
 	int refcount, reply_queue;
 
+	if (sc->device == NULL)
+		return FAILED;
+
 	/* Find the controller of the command to be aborted */
 	h = sdev_to_hba(sc->device);
-	if (WARN(h == NULL,
-			"ABORT REQUEST FAILED, Controller lookup failed.\n"))
+	if (h == NULL)
 		return FAILED;
 
 	/* If controller locked up, we can guarantee command won't complete */
@@ -4810,6 +4900,14 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		cmd_free(h, abort);
 		return SUCCESS;
 	}
+
+	/* Don't bother trying the abort if we know it won't work. */
+	if (abort->cmd_type != CMD_IOACCEL2 &&
+		abort->cmd_type != CMD_IOACCEL1 && !dev->supports_aborts) {
+		cmd_free(h, abort);
+		return FAILED;
+	}
+
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	reply_queue = hpsa_extract_reply_queue(h, abort);
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
@@ -4826,7 +4924,15 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 * by the firmware (but not to the scsi mid layer) but we can't
 	 * distinguish which.  Send the abort down.
 	 */
+	if (wait_for_available_abort_cmd(h)) {
+		dev_warn(&h->pdev->dev,
+			"Timed out waiting for an abort command to become available.\n");
+		cmd_free(h, abort);
+		return FAILED;
+	}
 	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort, reply_queue);
+	atomic_inc(&h->abort_cmds_available);
+	wake_up_all(&h->abort_cmd_wait_queue);
 	if (rc != 0) {
 		dev_warn(&h->pdev->dev, "scsi %d:%d:%d:%d %s\n",
 			h->scsi_host->host_no,
@@ -5398,7 +5504,7 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	int cmd_type)
 {
 	int pci_dir = XFER_NONE;
-	struct CommandList *a; /* for commands to be aborted */
+	u64 tag; /* for commands to be aborted */
 
 	c->cmd_type = CMD_IOCTL_PEND;
 	c->Header.ReplyQueue = 0;
@@ -5514,10 +5620,10 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.CDB[7] = 0x00;
 			break;
 		case  HPSA_ABORT_MSG:
-			a = buff;       /* point to command to be aborted */
+			memcpy(&tag, buff, sizeof(tag));
 			dev_dbg(&h->pdev->dev,
-				"Abort Tag:0x%016llx request Tag:0x%016llx",
-				a->Header.tag, c->Header.tag);
+				"Abort Tag:0x%016llx using rqst Tag:0x%016llx",
+				tag, c->Header.tag);
 			c->Request.CDBLen = 16;
 			c->Request.type_attr_dir =
 					TYPE_ATTR_DIR(cmd_type,
@@ -5528,8 +5634,7 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.CDB[2] = 0x00; /* reserved */
 			c->Request.CDB[3] = 0x00; /* reserved */
 			/* Tag to abort goes in CDB[4]-CDB[11] */
-			memcpy(&c->Request.CDB[4], &a->Header.tag,
-				sizeof(a->Header.tag));
+			memcpy(&c->Request.CDB[4], &tag, sizeof(tag));
 			c->Request.CDB[12] = 0x00; /* reserved */
 			c->Request.CDB[13] = 0x00; /* reserved */
 			c->Request.CDB[14] = 0x00; /* reserved */
@@ -6486,6 +6591,9 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	h->product_name = products[prod_index].product_name;
 	h->access = *(products[prod_index].access);
 
+	h->needs_abort_tags_swizzled =
+		ctlr_needs_abort_tags_swizzled(h->board_id);
+
 	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
 			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 
@@ -7100,6 +7208,7 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->offline_device_lock);
 	spin_lock_init(&h->scan_lock);
 	atomic_set(&h->passthru_cmds_avail, HPSA_MAX_CONCURRENT_PASSTHRUS);
+	atomic_set(&h->abort_cmds_available, HPSA_CMDS_RESERVED_FOR_ABORTS);
 
 	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
 	if (!h->rescan_ctlr_wq) {
@@ -7157,6 +7266,7 @@ reinit_after_soft_reset:
 	if (hpsa_allocate_sg_chain_blocks(h))
 		goto clean4;
 	init_waitqueue_head(&h->scan_wait_queue);
+	init_waitqueue_head(&h->abort_cmd_wait_queue);
 	h->scan_finished = 1; /* no scan currently in progress */
 
 	pci_set_drvdata(pdev, h);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 58f3315..df2468c 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -69,6 +69,7 @@ struct hpsa_scsi_dev_t {
 	 * devices in order to honor physical device queue depth limits.
 	 */
 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
+	int supports_aborts;
 #define HPSA_DO_NOT_EXPOSE	0x0
 #define HPSA_SG_ATTACH		0x1
 #define HPSA_ULD_ATTACH		0x2
@@ -257,8 +258,11 @@ struct ctlr_info {
 	struct list_head offline_device_list;
 	int	acciopath_status;
 	int	raid_offload_debug;
+	int	needs_abort_tags_swizzled;
 	struct workqueue_struct *resubmit_wq;
 	struct workqueue_struct *rescan_ctlr_wq;
+	atomic_t abort_cmds_available;
+	wait_queue_head_t abort_cmd_wait_queue;
 };
 
 struct offline_device_entry {

