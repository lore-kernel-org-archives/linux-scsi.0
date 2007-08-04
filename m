From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fw-sbp2: add support for multiple logical
	units per target
Date: Sat, 4 Aug 2007 15:54:58 +0200 (CEST)
Message-ID: <tkrat.128b6cd04d78e9ad@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixes "New firewire stack only recognizing half of a chain of drives",
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242254

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This replaces the patches
 "firewire: remove unused macros"
 "firewire: fw-sbp2: use one Scsi_Host for all targets"
 "firewire: fw-sbp2: split logical unit data from target data"
 "firewire: fw-sbp2: add support for multiple logical units per target"
 "firewire: fw-sbp2: remove some log messages"

 drivers/firewire/fw-device.h |    5 
 drivers/firewire/fw-sbp2.c   |  577 +++++++++++++++++++----------------
 2 files changed, 325 insertions(+), 257 deletions(-)

Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -102,11 +102,6 @@ fw_unit(struct device *dev)
 #define CSR_INSTANCE		0x18
 #define CSR_DIRECTORY_ID	0x20
 
-#define SBP2_COMMAND_SET_SPECIFIER	0x38
-#define SBP2_COMMAND_SET		0x39
-#define SBP2_COMMAND_SET_REVISION	0x3b
-#define SBP2_FIRMWARE_REVISION		0x3c
-
 struct fw_csr_iterator {
 	u32 *p;
 	u32 *end;
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -41,7 +41,6 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
@@ -66,31 +65,49 @@ typedef void (*scsi_done_fn_t)(struct sc
 
 static const char sbp2_driver_name[] = "sbp2";
 
-struct sbp2_device {
-	struct kref kref;
-	struct fw_unit *unit;
+/*
+ * We create one struct sbp2_logical_unit per SBP-2 Logical Unit Number Entry
+ * and one struct scsi_device per sbp2_logical_unit.
+ */
+struct sbp2_logical_unit {
+	struct sbp2_target *tgt;
+	struct list_head link;
+	struct scsi_device *sdev;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
-	u64 management_agent_address;
+
 	u64 command_block_agent_address;
-	u32 workarounds;
+	u16 lun;
 	int login_id;
 
 	/*
-	 * We cache these addresses and only update them once we've
-	 * logged in or reconnected to the sbp2 device.  That way, any
-	 * IO to the device will automatically fail and get retried if
-	 * it happens in a window where the device is not ready to
-	 * handle it (e.g. after a bus reset but before we reconnect).
+	 * The generation is updated once we've logged in or reconnected
+	 * to the logical unit.  Thus, I/O to the device will automatically
+	 * fail and get retried if it happens in a window where the device
+	 * is not ready, e.g. after a bus reset but before we reconnect.
 	 */
-	int node_id;
-	int address_high;
 	int generation;
-
 	int retries;
 	struct delayed_work work;
 };
 
+/*
+ * We create one struct sbp2_target per IEEE 1212 Unit Directory
+ * and one struct Scsi_Host per sbp2_target.
+ */
+struct sbp2_target {
+	struct kref kref;
+	struct fw_unit *unit;
+
+	u64 management_agent_address;
+	int directory_id;
+	int node_id;
+	int address_high;
+
+	unsigned workarounds;
+	struct list_head lu_list;
+};
+
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 #define SBP2_MAX_SECTORS		255	/* Max sectors supported */
 #define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
@@ -101,10 +118,9 @@ struct sbp2_device {
 #define SBP2_DIRECTION_FROM_MEDIA	0x1
 
 /* Unit directory keys */
-#define SBP2_COMMAND_SET_SPECIFIER	0x38
-#define SBP2_COMMAND_SET		0x39
-#define SBP2_COMMAND_SET_REVISION	0x3b
-#define SBP2_FIRMWARE_REVISION		0x3c
+#define SBP2_CSR_FIRMWARE_REVISION	0x3c
+#define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
+#define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
 
 /* Flags for detected oddities and brokeness */
 #define SBP2_WORKAROUND_128K_MAX_TRANS	0x1
@@ -218,7 +234,7 @@ struct sbp2_command_orb {
 	} request;
 	struct scsi_cmnd *cmd;
 	scsi_done_fn_t done;
-	struct fw_unit *unit;
+	struct sbp2_logical_unit *lu;
 
 	struct sbp2_pointer page_table[SG_ALL] __attribute__((aligned(8)));
 	dma_addr_t page_table_bus;
@@ -286,7 +302,7 @@ sbp2_status_write(struct fw_card *card, 
 		  unsigned long long offset,
 		  void *payload, size_t length, void *callback_data)
 {
-	struct sbp2_device *sd = callback_data;
+	struct sbp2_logical_unit *lu = callback_data;
 	struct sbp2_orb *orb;
 	struct sbp2_status status;
 	size_t header_size;
@@ -310,7 +326,7 @@ sbp2_status_write(struct fw_card *card, 
 
 	/* Lookup the orb corresponding to this status write. */
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(orb, &sd->orb_list, link) {
+	list_for_each_entry(orb, &lu->orb_list, link) {
 		if (STATUS_GET_ORB_HIGH(status) == 0 &&
 		    STATUS_GET_ORB_LOW(status) == orb->request_bus &&
 		    orb->rcode == RCODE_COMPLETE) {
@@ -320,7 +336,7 @@ sbp2_status_write(struct fw_card *card, 
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (&orb->link != &sd->orb_list)
+	if (&orb->link != &lu->orb_list)
 		orb->callback(orb, &status);
 	else
 		fw_error("status write for unknown orb\n");
@@ -345,11 +361,10 @@ complete_transaction(struct fw_card *car
 }
 
 static void
-sbp2_send_orb(struct sbp2_orb *orb, struct fw_unit *unit,
+sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
 	      int node_id, int generation, u64 offset)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	unsigned long flags;
 
 	orb->pointer.high = 0;
@@ -357,7 +372,7 @@ sbp2_send_orb(struct sbp2_orb *orb, stru
 	fw_memcpy_to_be32(&orb->pointer, &orb->pointer, sizeof(orb->pointer));
 
 	spin_lock_irqsave(&device->card->lock, flags);
-	list_add_tail(&orb->link, &sd->orb_list);
+	list_add_tail(&orb->link, &lu->orb_list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
 	fw_send_request(device->card, &orb->t, TCODE_WRITE_BLOCK_REQUEST,
@@ -366,10 +381,9 @@ sbp2_send_orb(struct sbp2_orb *orb, stru
 			complete_transaction, orb);
 }
 
-static int sbp2_cancel_orbs(struct fw_unit *unit)
+static int sbp2_cancel_orbs(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_orb *orb, *next;
 	struct list_head list;
 	unsigned long flags;
@@ -377,7 +391,7 @@ static int sbp2_cancel_orbs(struct fw_un
 
 	INIT_LIST_HEAD(&list);
 	spin_lock_irqsave(&device->card->lock, flags);
-	list_splice_init(&sd->orb_list, &list);
+	list_splice_init(&lu->orb_list, &list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
 	list_for_each_entry_safe(orb, next, &list, link) {
@@ -404,11 +418,11 @@ complete_management_orb(struct sbp2_orb 
 }
 
 static int
-sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
-			 int function, int lun, void *response)
+sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
+			 int generation, int function, int lun_or_login_id,
+			 void *response)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_management_orb *orb;
 	int retval = -ENOMEM;
 
@@ -428,12 +442,12 @@ sbp2_send_management_orb(struct fw_unit 
 	orb->request.misc =
 		MANAGEMENT_ORB_NOTIFY |
 		MANAGEMENT_ORB_FUNCTION(function) |
-		MANAGEMENT_ORB_LUN(lun);
+		MANAGEMENT_ORB_LUN(lun_or_login_id);
 	orb->request.length =
 		MANAGEMENT_ORB_RESPONSE_LENGTH(sizeof(orb->response));
 
-	orb->request.status_fifo.high = sd->address_handler.offset >> 32;
-	orb->request.status_fifo.low  = sd->address_handler.offset;
+	orb->request.status_fifo.high = lu->address_handler.offset >> 32;
+	orb->request.status_fifo.low  = lu->address_handler.offset;
 
 	if (function == SBP2_LOGIN_REQUEST) {
 		orb->request.misc |=
@@ -452,14 +466,14 @@ sbp2_send_management_orb(struct fw_unit 
 	if (dma_mapping_error(orb->base.request_bus))
 		goto fail_mapping_request;
 
-	sbp2_send_orb(&orb->base, unit,
-		      node_id, generation, sd->management_agent_address);
+	sbp2_send_orb(&orb->base, lu, node_id, generation,
+		      lu->tgt->management_agent_address);
 
 	wait_for_completion_timeout(&orb->done,
 				    msecs_to_jiffies(SBP2_ORB_TIMEOUT));
 
 	retval = -EIO;
-	if (sbp2_cancel_orbs(unit) == 0) {
+	if (sbp2_cancel_orbs(lu) == 0) {
 		fw_error("orb reply timed out, rcode=0x%02x\n",
 			 orb->base.rcode);
 		goto out;
@@ -504,10 +518,9 @@ complete_agent_reset_write(struct fw_car
 	kfree(t);
 }
 
-static int sbp2_agent_reset(struct fw_unit *unit)
+static int sbp2_agent_reset(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct fw_transaction *t;
 	static u32 zero;
 
@@ -516,181 +529,260 @@ static int sbp2_agent_reset(struct fw_un
 		return -ENOMEM;
 
 	fw_send_request(device->card, t, TCODE_WRITE_QUADLET_REQUEST,
-			sd->node_id, sd->generation, device->max_speed,
-			sd->command_block_agent_address + SBP2_AGENT_RESET,
+			lu->tgt->node_id, lu->generation, device->max_speed,
+			lu->command_block_agent_address + SBP2_AGENT_RESET,
 			&zero, sizeof(zero), complete_agent_reset_write, t);
 
 	return 0;
 }
 
-static void sbp2_reconnect(struct work_struct *work);
-static struct scsi_host_template scsi_driver_template;
-
-static void release_sbp2_device(struct kref *kref)
+static void sbp2_release_target(struct kref *kref)
 {
-	struct sbp2_device *sd = container_of(kref, struct sbp2_device, kref);
-	struct Scsi_Host *host =
-		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
-
-	scsi_remove_host(host);
-	sbp2_send_management_orb(sd->unit, sd->node_id, sd->generation,
-				 SBP2_LOGOUT_REQUEST, sd->login_id, NULL);
-	fw_core_remove_address_handler(&sd->address_handler);
-	fw_notify("removed sbp2 unit %s\n", sd->unit->device.bus_id);
-	put_device(&sd->unit->device);
-	scsi_host_put(host);
+	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
+	struct sbp2_logical_unit *lu, *next;
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+
+	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
+		if (lu->sdev)
+			scsi_remove_device(lu->sdev);
+
+		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+		fw_core_remove_address_handler(&lu->address_handler);
+		list_del(&lu->link);
+		kfree(lu);
+	}
+	scsi_remove_host(shost);
+	fw_notify("released %s\n", tgt->unit->device.bus_id);
+
+	put_device(&tgt->unit->device);
+	scsi_host_put(shost);
 }
 
+static void sbp2_reconnect(struct work_struct *work);
+
 static void sbp2_login(struct work_struct *work)
 {
-	struct sbp2_device *sd =
-		container_of(work, struct sbp2_device, work.work);
-	struct Scsi_Host *host =
-		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu =
+		container_of(work, struct sbp2_logical_unit, work.work);
+	struct Scsi_Host *shost =
+		container_of((void *)lu->tgt, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
+	struct scsi_lun eight_bytes_lun = {{ 0, }};
+	struct fw_unit *unit = lu->tgt->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_login_response response;
-	int generation, node_id, local_node_id, lun, retval;
-
-	/* FIXME: Make this work for multi-lun devices. */
-	lun = 0;
+	int generation, node_id, local_node_id;
 
 	generation    = device->card->generation;
 	node_id       = device->node->node_id;
 	local_node_id = device->card->local_node->node_id;
 
-	if (sbp2_send_management_orb(unit, node_id, generation,
-				     SBP2_LOGIN_REQUEST, lun, &response) < 0) {
-		if (sd->retries++ < 5) {
-			schedule_delayed_work(&sd->work, DIV_ROUND_UP(HZ, 5));
+	if (sbp2_send_management_orb(lu, node_id, generation,
+				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
+		if (lu->retries++ < 5) {
+			schedule_delayed_work(&lu->work, DIV_ROUND_UP(HZ, 5));
 		} else {
-			fw_error("failed to login to %s\n",
-				 unit->device.bus_id);
-			kref_put(&sd->kref, release_sbp2_device);
+			fw_error("failed to login to %s LUN %04x\n",
+				 unit->device.bus_id, lu->lun);
+			kref_put(&lu->tgt->kref, sbp2_release_target);
 		}
 		return;
 	}
 
-	sd->generation   = generation;
-	sd->node_id      = node_id;
-	sd->address_high = local_node_id << 16;
+	lu->generation        = generation;
+	lu->tgt->node_id      = node_id;
+	lu->tgt->address_high = local_node_id << 16;
 
 	/* Get command block agent offset and login id. */
-	sd->command_block_agent_address =
+	lu->command_block_agent_address =
 		((u64) (response.command_block_agent.high & 0xffff) << 32) |
 		response.command_block_agent.low;
-	sd->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
+	lu->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
 
-	fw_notify("logged in to sbp2 unit %s (%d retries)\n",
-		  unit->device.bus_id, sd->retries);
-	fw_notify(" - management_agent_address:    0x%012llx\n",
-		  (unsigned long long) sd->management_agent_address);
-	fw_notify(" - command_block_agent_address: 0x%012llx\n",
-		  (unsigned long long) sd->command_block_agent_address);
-	fw_notify(" - status write address:        0x%012llx\n",
-		  (unsigned long long) sd->address_handler.offset);
+	fw_notify("logged in to %s LUN %04x (%d retries)\n",
+		  unit->device.bus_id, lu->lun, lu->retries);
 
 #if 0
 	/* FIXME: The linux1394 sbp2 does this last step. */
 	sbp2_set_busy_timeout(scsi_id);
 #endif
 
-	PREPARE_DELAYED_WORK(&sd->work, sbp2_reconnect);
-	sbp2_agent_reset(unit);
+	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
+	sbp2_agent_reset(lu);
 
-	/* FIXME: Loop over luns here. */
-	lun = 0;
-	retval = scsi_add_device(host, 0, 0, lun);
-	if (retval < 0) {
-		sbp2_send_management_orb(unit, sd->node_id, sd->generation,
-					 SBP2_LOGOUT_REQUEST, sd->login_id,
-					 NULL);
+	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
+	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;
+	sdev = __scsi_add_device(shost, 0, 0,
+				 scsilun_to_int(&eight_bytes_lun), lu);
+	if (IS_ERR(sdev)) {
+		sbp2_send_management_orb(lu, node_id, generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 		/*
 		 * Set this back to sbp2_login so we fall back and
 		 * retry login on bus reset.
 		 */
-		PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+		PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+	} else {
+		lu->sdev = sdev;
+		scsi_device_put(sdev);
 	}
-	kref_put(&sd->kref, release_sbp2_device);
+	kref_put(&lu->tgt->kref, sbp2_release_target);
 }
 
-static int sbp2_probe(struct device *dev)
+static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
+{
+	struct sbp2_logical_unit *lu;
+
+	lu = kmalloc(sizeof(*lu), GFP_KERNEL);
+	if (!lu)
+		return -ENOMEM;
+
+	lu->address_handler.length           = 0x100;
+	lu->address_handler.address_callback = sbp2_status_write;
+	lu->address_handler.callback_data    = lu;
+
+	if (fw_core_add_address_handler(&lu->address_handler,
+					&fw_high_memory_region) < 0) {
+		kfree(lu);
+		return -ENOMEM;
+	}
+
+	lu->tgt  = tgt;
+	lu->sdev = NULL;
+	lu->lun  = lun_entry & 0xffff;
+	lu->retries = 0;
+	INIT_LIST_HEAD(&lu->orb_list);
+	INIT_DELAYED_WORK(&lu->work, sbp2_login);
+
+	list_add_tail(&lu->link, &tgt->lu_list);
+	return 0;
+}
+
+static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt, u32 *directory)
 {
-	struct fw_unit *unit = fw_unit(dev);
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd;
 	struct fw_csr_iterator ci;
-	struct Scsi_Host *host;
-	int i, key, value, err;
-	u32 model, firmware_revision;
+	int key, value;
 
-	err = -ENOMEM;
-	host = scsi_host_alloc(&scsi_driver_template, sizeof(*sd));
-	if (host == NULL)
-		goto fail;
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value))
+		if (key == SBP2_CSR_LOGICAL_UNIT_NUMBER &&
+		    sbp2_add_logical_unit(tgt, value) < 0)
+			return -ENOMEM;
+	return 0;
+}
 
-	sd = (struct sbp2_device *) host->hostdata;
-	unit->device.driver_data = sd;
-	sd->unit = unit;
-	INIT_LIST_HEAD(&sd->orb_list);
-	kref_init(&sd->kref);
-
-	sd->address_handler.length = 0x100;
-	sd->address_handler.address_callback = sbp2_status_write;
-	sd->address_handler.callback_data = sd;
-
-	err = fw_core_add_address_handler(&sd->address_handler,
-					  &fw_high_memory_region);
-	if (err < 0)
-		goto fail_host;
-
-	err = fw_device_enable_phys_dma(device);
-	if (err < 0)
-		goto fail_address_handler;
-
-	err = scsi_add_host(host, &unit->device);
-	if (err < 0)
-		goto fail_address_handler;
+static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
+			      u32 *model, u32 *firmware_revision)
+{
+	struct fw_csr_iterator ci;
+	int key, value;
 
-	/*
-	 * Scan unit directory to get management agent address,
-	 * firmware revison and model.  Initialize firmware_revision
-	 * and model to values that wont match anything in our table.
-	 */
-	firmware_revision = 0xff000000;
-	model = 0xff000000;
-	fw_csr_iterator_init(&ci, unit->directory);
+	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
 		switch (key) {
+
 		case CSR_DEPENDENT_INFO | CSR_OFFSET:
-			sd->management_agent_address =
-				0xfffff0000000ULL + 4 * value;
+			tgt->management_agent_address =
+					CSR_REGISTER_BASE + 4 * value;
 			break;
-		case SBP2_FIRMWARE_REVISION:
-			firmware_revision = value;
+
+		case CSR_DIRECTORY_ID:
+			tgt->directory_id = value;
 			break;
+
 		case CSR_MODEL:
-			model = value;
+			*model = value;
+			break;
+
+		case SBP2_CSR_FIRMWARE_REVISION:
+			*firmware_revision = value;
+			break;
+
+		case SBP2_CSR_LOGICAL_UNIT_NUMBER:
+			if (sbp2_add_logical_unit(tgt, value) < 0)
+				return -ENOMEM;
+			break;
+
+		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
+			if (sbp2_scan_logical_unit_dir(tgt, ci.p + value) < 0)
+				return -ENOMEM;
 			break;
 		}
 	}
+	return 0;
+}
+
+static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
+				  u32 firmware_revision)
+{
+	int i;
+
+	tgt->workarounds = 0;
+	firmware_revision &= 0xffffff00;
 
 	for (i = 0; i < ARRAY_SIZE(sbp2_workarounds_table); i++) {
+
 		if (sbp2_workarounds_table[i].firmware_revision !=
-		    (firmware_revision & 0xffffff00))
+		    firmware_revision)
 			continue;
+
 		if (sbp2_workarounds_table[i].model != model &&
 		    sbp2_workarounds_table[i].model != ~0)
 			continue;
-		sd->workarounds |= sbp2_workarounds_table[i].workarounds;
+
+		tgt->workarounds |= sbp2_workarounds_table[i].workarounds;
 		break;
 	}
 
-	if (sd->workarounds)
-		fw_notify("Workarounds for node %s: 0x%x "
+	if (tgt->workarounds)
+		fw_notify("Workarounds for %s: 0x%x "
 			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
-			  unit->device.bus_id,
-			  sd->workarounds, firmware_revision, model);
+			  tgt->unit->device.bus_id,
+			  tgt->workarounds, firmware_revision, model);
+}
+
+static struct scsi_host_template scsi_driver_template;
+
+static int sbp2_probe(struct device *dev)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_target *tgt;
+	struct sbp2_logical_unit *lu;
+	struct Scsi_Host *shost;
+	u32 model, firmware_revision;
+
+	shost = scsi_host_alloc(&scsi_driver_template, sizeof(*tgt));
+	if (shost == NULL)
+		return -ENOMEM;
+
+	tgt = (struct sbp2_target *)shost->hostdata;
+	unit->device.driver_data = tgt;
+	tgt->unit = unit;
+	kref_init(&tgt->kref);
+	INIT_LIST_HEAD(&tgt->lu_list);
+
+	if (fw_device_enable_phys_dma(device) < 0)
+		goto fail_shost_put;
+
+	if (scsi_add_host(shost, &unit->device) < 0)
+		goto fail_shost_put;
+
+	/* Initialize to values that won't match anything in our table. */
+	firmware_revision = 0xff000000;
+	model = 0xff000000;
+
+	/* implicit directory ID */
+	tgt->directory_id = ((unit->directory - device->config_rom) * 4
+			     + CSR_CONFIG_ROM) & 0xffffff;
+
+	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
+			       &firmware_revision) < 0)
+		goto fail_tgt_put;
+
+	sbp2_init_workarounds(tgt, model, firmware_revision);
 
 	get_device(&unit->device);
 
@@ -699,35 +791,34 @@ static int sbp2_probe(struct device *dev
 	 * reschedule retries. Always get the ref before scheduling
 	 * work.
 	 */
-	INIT_DELAYED_WORK(&sd->work, sbp2_login);
-	if (schedule_delayed_work(&sd->work, 0))
-		kref_get(&sd->kref);
-
+	list_for_each_entry(lu, &tgt->lu_list, link)
+		if (schedule_delayed_work(&lu->work, 0))
+			kref_get(&tgt->kref);
 	return 0;
 
- fail_address_handler:
-	fw_core_remove_address_handler(&sd->address_handler);
- fail_host:
-	scsi_host_put(host);
- fail:
-	return err;
+ fail_tgt_put:
+	kref_put(&tgt->kref, sbp2_release_target);
+	return -ENOMEM;
+
+ fail_shost_put:
+	scsi_host_put(shost);
+	return -ENOMEM;
 }
 
 static int sbp2_remove(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
-	struct sbp2_device *sd = unit->device.driver_data;
-
-	kref_put(&sd->kref, release_sbp2_device);
+	struct sbp2_target *tgt = unit->device.driver_data;
 
+	kref_put(&tgt->kref, sbp2_release_target);
 	return 0;
 }
 
 static void sbp2_reconnect(struct work_struct *work)
 {
-	struct sbp2_device *sd =
-		container_of(work, struct sbp2_device, work.work);
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu =
+		container_of(work, struct sbp2_logical_unit, work.work);
+	struct fw_unit *unit = lu->tgt->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
@@ -735,40 +826,49 @@ static void sbp2_reconnect(struct work_s
 	node_id       = device->node->node_id;
 	local_node_id = device->card->local_node->node_id;
 
-	if (sbp2_send_management_orb(unit, node_id, generation,
+	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,
-				     sd->login_id, NULL) < 0) {
-		if (sd->retries++ >= 5) {
+				     lu->login_id, NULL) < 0) {
+		if (lu->retries++ >= 5) {
 			fw_error("failed to reconnect to %s\n",
 				 unit->device.bus_id);
 			/* Fall back and try to log in again. */
-			sd->retries = 0;
-			PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+			lu->retries = 0;
+			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
-		schedule_delayed_work(&sd->work, DIV_ROUND_UP(HZ, 5));
+		schedule_delayed_work(&lu->work, DIV_ROUND_UP(HZ, 5));
 		return;
 	}
 
-	sd->generation   = generation;
-	sd->node_id      = node_id;
-	sd->address_high = local_node_id << 16;
-
-	fw_notify("reconnected to unit %s (%d retries)\n",
-		  unit->device.bus_id, sd->retries);
-	sbp2_agent_reset(unit);
-	sbp2_cancel_orbs(unit);
-	kref_put(&sd->kref, release_sbp2_device);
+	lu->generation        = generation;
+	lu->tgt->node_id      = node_id;
+	lu->tgt->address_high = local_node_id << 16;
+
+	fw_notify("reconnected to %s LUN %04x (%d retries)\n",
+		  unit->device.bus_id, lu->lun, lu->retries);
+
+	sbp2_agent_reset(lu);
+	sbp2_cancel_orbs(lu);
+
+	kref_put(&lu->tgt->kref, sbp2_release_target);
 }
 
 static void sbp2_update(struct fw_unit *unit)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct sbp2_target *tgt = unit->device.driver_data;
+	struct sbp2_logical_unit *lu;
 
-	sd->retries = 0;
-	fw_device_enable_phys_dma(device);
-	if (schedule_delayed_work(&sd->work, 0))
-		kref_get(&sd->kref);
+	fw_device_enable_phys_dma(fw_device(unit->device.parent));
+
+	/*
+	 * Fw-core serializes sbp2_update() against sbp2_remove().
+	 * Iteration over tgt->lu_list is therefore safe here.
+	 */
+	list_for_each_entry(lu, &tgt->lu_list, link) {
+		lu->retries = 0;
+		if (schedule_delayed_work(&lu->work, 0))
+			kref_get(&tgt->kref);
+	}
 }
 
 #define SBP2_UNIT_SPEC_ID_ENTRY	0x0000609e
@@ -838,13 +938,12 @@ complete_command_orb(struct sbp2_orb *ba
 {
 	struct sbp2_command_orb *orb =
 		container_of(base_orb, struct sbp2_command_orb, base);
-	struct fw_unit *unit = orb->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct fw_device *device = fw_device(orb->lu->tgt->unit->device.parent);
 	int result;
 
 	if (status != NULL) {
 		if (STATUS_GET_DEAD(*status))
-			sbp2_agent_reset(unit);
+			sbp2_agent_reset(orb->lu);
 
 		switch (STATUS_GET_RESPONSE(*status)) {
 		case SBP2_STATUS_REQUEST_COMPLETE:
@@ -889,12 +988,10 @@ complete_command_orb(struct sbp2_orb *ba
 	kfree(orb);
 }
 
-static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
+static int
+sbp2_map_scatterlist(struct sbp2_command_orb *orb, struct fw_device *device,
+		     struct sbp2_logical_unit *lu)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)orb->cmd->device->host->hostdata;
-	struct fw_unit *unit = sd->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
 	struct scatterlist *sg;
 	int sg_len, l, i, j, count;
 	dma_addr_t sg_addr;
@@ -913,10 +1010,9 @@ static int sbp2_command_orb_map_scatterl
 	 * tables.
 	 */
 	if (count == 1 && sg_dma_len(sg) < SBP2_MAX_SG_ELEMENT_LENGTH) {
-		orb->request.data_descriptor.high = sd->address_high;
+		orb->request.data_descriptor.high = lu->tgt->address_high;
 		orb->request.data_descriptor.low  = sg_dma_address(sg);
-		orb->request.misc |=
-			COMMAND_ORB_DATA_SIZE(sg_dma_len(sg));
+		orb->request.misc |= COMMAND_ORB_DATA_SIZE(sg_dma_len(sg));
 		return 0;
 	}
 
@@ -960,7 +1056,7 @@ static int sbp2_command_orb_map_scatterl
 	 * initiator (i.e. us), but data_descriptor can refer to data
 	 * on other nodes so we need to put our ID in descriptor.high.
 	 */
-	orb->request.data_descriptor.high = sd->address_high;
+	orb->request.data_descriptor.high = lu->tgt->address_high;
 	orb->request.data_descriptor.low  = orb->page_table_bus;
 	orb->request.misc |=
 		COMMAND_ORB_PAGE_TABLE_PRESENT |
@@ -979,10 +1075,8 @@ static int sbp2_command_orb_map_scatterl
 
 static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
-	struct fw_unit *unit = sd->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_logical_unit *lu = cmd->device->hostdata;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
 	unsigned max_payload;
 
@@ -1000,13 +1094,13 @@ static int sbp2_scsi_queuecommand(struct
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL) {
 		fw_notify("failed to alloc orb\n");
-		goto fail_alloc;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Initialize rcode to something not RCODE_COMPLETE. */
 	orb->base.rcode = -1;
 
-	orb->unit = unit;
+	orb->lu   = lu;
 	orb->done = done;
 	orb->cmd  = cmd;
 
@@ -1032,8 +1126,8 @@ static int sbp2_scsi_queuecommand(struct
 		orb->request.misc |=
 			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA);
 
-	if (scsi_sg_count(cmd) && sbp2_command_orb_map_scatterlist(orb) < 0)
-		goto fail_mapping;
+	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
+		goto fail;
 
 	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));
 
@@ -1046,48 +1140,48 @@ static int sbp2_scsi_queuecommand(struct
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
 	if (dma_mapping_error(orb->base.request_bus))
-		goto fail_mapping;
+		goto fail;
 
-	sbp2_send_orb(&orb->base, unit, sd->node_id, sd->generation,
-		      sd->command_block_agent_address + SBP2_ORB_POINTER);
+	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, lu->generation,
+		      lu->command_block_agent_address + SBP2_ORB_POINTER);
 
 	return 0;
-
- fail_mapping:
+ fail:
 	kfree(orb);
- fail_alloc:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
 static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->allow_restart = 1;
 
-	if (sd->workarounds & SBP2_WORKAROUND_INQUIRY_36)
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
+
 	return 0;
 }
 
 static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->use_10_for_rw = 1;
 
 	if (sdev->type == TYPE_ROM)
 		sdev->use_10_for_ms = 1;
+
 	if (sdev->type == TYPE_DISK &&
-	    sd->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
+	    lu->tgt->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
 		sdev->skip_ms_page_8 = 1;
-	if (sd->workarounds & SBP2_WORKAROUND_FIX_CAPACITY) {
-		fw_notify("setting fix_capacity for %s\n", unit->device.bus_id);
+
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
-	}
-	if (sd->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
+
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
+
 	return 0;
 }
 
@@ -1097,13 +1191,11 @@ static int sbp2_scsi_slave_configure(str
  */
 static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 
 	fw_notify("sbp2_scsi_abort\n");
-	sbp2_agent_reset(unit);
-	sbp2_cancel_orbs(unit);
+	sbp2_agent_reset(lu);
+	sbp2_cancel_orbs(lu);
 
 	return SUCCESS;
 }
@@ -1120,37 +1212,18 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 			    char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct sbp2_device *sd;
-	struct fw_unit *unit;
+	struct sbp2_logical_unit *lu;
 	struct fw_device *device;
-	u32 directory_id;
-	struct fw_csr_iterator ci;
-	int key, value, lun;
 
 	if (!sdev)
 		return 0;
-	sd = (struct sbp2_device *)sdev->host->hostdata;
-	unit = sd->unit;
-	device = fw_device(unit->device.parent);
-
-	/* implicit directory ID */
-	directory_id = ((unit->directory - device->config_rom) * 4
-			+ CSR_CONFIG_ROM) & 0xffffff;
-
-	/* explicit directory ID, overrides implicit ID if present */
-	fw_csr_iterator_init(&ci, unit->directory);
-	while (fw_csr_iterator_next(&ci, &key, &value))
-		if (key == CSR_DIRECTORY_ID) {
-			directory_id = value;
-			break;
-		}
 
-	/* FIXME: Make this work for multi-lun devices. */
-	lun = 0;
+	lu = sdev->hostdata;
+	device = fw_device(lu->tgt->unit->device.parent);
 
 	return sprintf(buf, "%08x%08x:%06x:%04x\n",
 			device->config_rom[3], device->config_rom[4],
-			directory_id, lun);
+			lu->tgt->directory_id, lu->lun);
 }
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);

-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
