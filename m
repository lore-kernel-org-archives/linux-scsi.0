From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 6/7] hpsa: correct handling of HBA device removal
Date: Wed, 27 Apr 2016 17:14:17 -0500
Message-ID: <146179525708.31195.3535427540480802197.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0064.outbound.protection.outlook.com ([157.56.111.64]:40419
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749AbcD0W3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:29:49 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Need to report HBA device removal faster than the
event handler polling interval.

Stop I/O to the removed disk and wait for all
I/O operations to flush before removing the device.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3f9f758..0d286e4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -294,6 +294,9 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h);
 static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
 	struct ReportExtendedLUNdata *buf, int bufsize);
 static int hpsa_luns_changed(struct ctlr_info *h);
+static bool hpsa_cmd_dev_match(struct ctlr_info *h, struct CommandList *c,
+			       struct hpsa_scsi_dev_t *dev,
+			       unsigned char *scsi3addr);
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
@@ -1745,6 +1748,51 @@ static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
 	return rc;
 }
 
+static int hpsa_find_outstanding_commands_for_dev(struct ctlr_info *h,
+						struct hpsa_scsi_dev_t *dev)
+{
+	int i;
+	int count = 0;
+
+	for (i = 0; i < h->nr_cmds; i++) {
+		struct CommandList *c = h->cmd_pool + i;
+		int refcount = atomic_inc_return(&c->refcount);
+
+		if (refcount > 1 && hpsa_cmd_dev_match(h, c, dev,
+				dev->scsi3addr)) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&h->lock, flags);	/* Implied MB */
+			if (!hpsa_is_cmd_idle(c))
+				++count;
+			spin_unlock_irqrestore(&h->lock, flags);
+		}
+
+		cmd_free(h, c);
+	}
+
+	return count;
+}
+
+static void hpsa_wait_for_outstanding_commands_for_dev(struct ctlr_info *h,
+						struct hpsa_scsi_dev_t *device)
+{
+	int cmds = 0;
+	int waits = 0;
+
+	while (1) {
+		cmds = hpsa_find_outstanding_commands_for_dev(h, device);
+		if (cmds == 0)
+			break;
+		if (++waits > 20)
+			break;
+		dev_warn(&h->pdev->dev,
+			"%s: removing device with %d outstanding commands!\n",
+			__func__, cmds);
+		msleep(1000);
+	}
+}
+
 static void hpsa_remove_device(struct ctlr_info *h,
 			struct hpsa_scsi_dev_t *device)
 {
@@ -1768,8 +1816,13 @@ static void hpsa_remove_device(struct ctlr_info *h,
 			hpsa_show_dev_msg(KERN_WARNING, h, device,
 					"didn't find device for removal.");
 		}
-	} else /* HBA */
+	} else { /* HBA */
+
+		device->removed = 1;
+		hpsa_wait_for_outstanding_commands_for_dev(h, device);
+
 		hpsa_remove_sas_device(device);
+	}
 }
 
 static void adjust_hpsa_scsi_table(struct ctlr_info *h,
@@ -2171,7 +2224,8 @@ static void hpsa_unmap_sg_chain_block(struct ctlr_info *h,
 static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 					struct CommandList *c,
 					struct scsi_cmnd *cmd,
-					struct io_accel2_cmd *c2)
+					struct io_accel2_cmd *c2,
+					struct hpsa_scsi_dev_t *dev)
 {
 	int data_len;
 	int retry = 0;
@@ -2235,8 +2289,27 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 		case IOACCEL2_STATUS_SR_NO_PATH_TO_DEVICE:
 		case IOACCEL2_STATUS_SR_INVALID_DEVICE:
 		case IOACCEL2_STATUS_SR_IOACCEL_DISABLED:
-			/* We will get an event from ctlr to trigger rescan */
-			retry = 1;
+			/*
+			 * Did an HBA disk disappear? We will eventually
+			 * get a state change event from the controller but
+			 * in the meantime, we need to tell the OS that the
+			 * HBA disk is no longer there and stop I/O
+			 * from going down. This allows the potential re-insert
+			 * of the disk to get the same device node.
+			 */
+			if (dev->physical_device && dev->expose_device) {
+				cmd->result = DID_NO_CONNECT << 16;
+				dev->removed = 1;
+				h->drv_req_rescan = 1;
+				dev_warn(&h->pdev->dev,
+					"%s: device is gone!\n", __func__);
+			} else
+				/*
+				 * Retry by sending down the RAID path.
+				 * We will get an event from ctlr to
+				 * trigger rescan regardless.
+				 */
+				retry = 1;
 			break;
 		default:
 			retry = 1;
@@ -2368,7 +2441,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		return hpsa_retry_cmd(h, c);
 	}
 
-	if (handle_ioaccel_mode2_error(h, c, cmd, c2))
+	if (handle_ioaccel_mode2_error(h, c, cmd, c2, dev))
 		return hpsa_retry_cmd(h, c);
 
 	return hpsa_cmd_free_and_done(h, c, cmd);
@@ -5263,6 +5336,12 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
+		cmd->result = NOT_READY << 16; /* host byte */
+		cmd->scsi_done(cmd);
+		return 0;
+	}
+
+	if (dev->removed) {
 		cmd->result = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index d06bb74..a1487e6 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -63,6 +63,7 @@ struct hpsa_scsi_dev_t {
 	unsigned char scsi3addr[8];	/* as presented to the HW */
 	u8 physical_device : 1;
 	u8 expose_device;
+	u8 removed : 1;			/* device is marked for death */
 #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
 	u64 sas_address;

