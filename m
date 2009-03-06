From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/2] resubmit cciss: kernel thread to detect changes on MSA2012
Date: Fri, 6 Mar 2009 12:16:03 -0600
Message-ID: <20090306181603.GA30801@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39535 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZCFSQF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 13:16:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, coldwell@redhat.com, mikem@beardog.cca.cpqcorp.net, james.bottomley@hansenpartnership.com

Patch 1 of 2

This is a resubmission of yesterdays patch to detect changes on the MSA2012.
I hope I've addressed all concerns. This patch rearranges some of the code
so we also have coverage in the sg and the ioctl paths as well as the main
data path.

The MSA2012 cannot inform the driver of configuration changes since all
management is out of band. This is a departure from any storage we have
supported in the past. We need some way to detect changes on the topology so
we implement this kernel thread. In some instances there's nothing we can do
from the driver (like LUN failure) so just print out a message. In the case
where logical volumes are added or deleted we call rebuild_lun_table to
refreash the driver's view of the world.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d2cb67b..f51545e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -51,6 +51,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
 #include <linux/scatterlist.h>
+#include <linux/kthread.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
@@ -186,6 +187,8 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			   __u8 page_code, int cmd_type);
 
 static void fail_all_cmds(unsigned long ctlr);
+static int scan_thread(ctlr_info_t *h);
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -735,6 +738,12 @@ static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static void check_ioctl_unit_attention(ctlr_info_t *host, CommandList_struct *c)
+{
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
+		(void)check_for_unit_attention(host, c);
+}
 /*
  * ioctl
  */
@@ -1029,6 +1038,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 					 iocommand.buf_size,
 					 PCI_DMA_BIDIRECTIONAL);
 
+			check_ioctl_unit_attention(host, c);
+
 			/* Copy the error information out */
 			iocommand.error_info = *(c->err_info);
 			if (copy_to_user
@@ -1180,6 +1191,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 					(dma_addr_t) temp64.val, buff_size[i],
 					PCI_DMA_BIDIRECTIONAL);
 			}
+			check_ioctl_unit_attention(host, c);
 			/* Copy the error information out */
 			ioc->error_info = *(c->err_info);
 			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -2585,12 +2597,14 @@ static inline unsigned int make_status_bytes(unsigned int scsi_status_byte,
 		((driver_byte & 0xff) << 24);
 }
 
-static inline int evaluate_target_status(CommandList_struct *cmd)
+static inline int evaluate_target_status(ctlr_info_t *h,
+			CommandList_struct *cmd, int *retry_cmd)
 {
 	unsigned char sense_key;
 	unsigned char status_byte, msg_byte, host_byte, driver_byte;
 	int error_value;
 
+	*retry_cmd = 0;
 	/* If we get in here, it means we got "target status", that is, scsi status */
 	status_byte = cmd->err_info->ScsiStatus;
 	driver_byte = DRIVER_OK;
@@ -2618,6 +2632,11 @@ static inline int evaluate_target_status(CommandList_struct *cmd)
 	if (((sense_key == 0x0) || (sense_key == 0x1)) && !blk_pc_request(cmd->rq))
 		error_value = 0;
 
+	if (check_for_unit_attention(h, cmd)) {
+		*retry_cmd = !blk_pc_request(cmd->rq);
+		return 0;
+	}
+
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
 		if (error_value != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
@@ -2647,6 +2666,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	int retry_cmd = 0;
 	struct request *rq = cmd->rq;
 
+
 	rq->errors = 0;
 
 	if (timeout)
@@ -2657,7 +2677,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 
 	switch (cmd->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		rq->errors = evaluate_target_status(cmd);
+		rq->errors = evaluate_target_status(h, cmd, &retry_cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (blk_fs_request(cmd->rq)) {
@@ -3008,6 +3028,62 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int scan_thread(ctlr_info_t *h)
+{
+	int rc;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	h->rescan_wait = &wait;
+
+	while (!kthread_should_stop()) {
+		rc = wait_for_completion_timeout(&wait, 300 * HZ);
+		if (!rc)
+			continue;
+		else
+			rebuild_lun_table(h, 0);
+	}
+	return 0;
+}
+
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
+{
+	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
+		return 0;
+
+	switch (c->err_info->SenseInfo[12]) {
+	case STATE_CHANGED:
+		printk(KERN_WARNING "cciss%d: a state change "
+			"detected, command retried\n", h->ctlr);
+		return 1;
+	break;
+	case LUN_FAILED:
+		printk(KERN_WARNING "cciss%d: LUN failure "
+			"detected, action required\n", h->ctlr);
+		return 1;
+	break;
+	case REPORT_LUNS_CHANGED:
+		printk(KERN_WARNING "cciss%d: report LUN data "
+			"changed\n", h->ctlr);
+		if (h->rescan_wait)
+			complete(h->rescan_wait);
+		return 1;
+	break;
+	case POWER_OR_RESET:
+		printk(KERN_WARNING "cciss%d: a power on "
+			"or device reset detected\n", h->ctlr);
+		return 1;
+	break;
+	case UNIT_ATTENTION_CLEARED:
+		printk(KERN_WARNING "cciss%d: unit attention "
+		    "cleared by another initiator\n", h->ctlr);
+		return 1;
+	break;
+	default:
+		printk(KERN_WARNING "cciss%d: unknown "
+			"unit attention detected\n", h->ctlr);
+				return 1;
+	}
+}
+
 /*
  *  We cannot read the structure directly, for portability we must use
  *   the io functions.
@@ -3600,6 +3685,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int rc;
 	int dac, return_code;
 	InquiryData_struct *inq_buff = NULL;
+	struct task_struct *cciss_scan_thread;
 
 	if (reset_devices) {
 		/* Reset the controller with a PCI power-cycle */
@@ -3751,6 +3837,11 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	hba[i]->busy_initializing = 0;
 
 	rebuild_lun_table(hba[i], 1);
+	cciss_scan_thread = kthread_run((void *)scan_thread, hba[i],
+				"scan_thread");
+	if (IS_ERR(cciss_scan_thread))
+		return PTR_ERR(cciss_scan_thread);
+
 	return 1;
 
 clean4:
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 15e2b84..c85783f 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -121,6 +121,7 @@ struct ctlr_info
 	struct sendcmd_reject_list scsi_rejects;
 #endif
 	unsigned char alive;
+	struct completion *rescan_wait;
 };
 
 /*  Defining the diffent access_menthods */
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 24e22de..40b1b92 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -25,6 +25,29 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
+/* Unit Attentions ASC's as defined for the MSA2012sa */
+#define POWER_OR_RESET			0x29
+#define STATE_CHANGED			0x2a
+#define UNIT_ATTENTION_CLEARED		0x2f
+#define LUN_FAILED			0x3e
+#define REPORT_LUNS_CHANGED		0x3f
+
+/* Unit Attentions ASCQ's as defined for the MSA2012sa */
+
+	/* These ASCQ's defined for ASC = POWER_OR_RESET */
+#define POWER_ON_RESET			0x00
+#define POWER_ON_REBOOT			0x01
+#define SCSI_BUS_RESET			0x02
+#define MSA_TARGET_RESET		0x03
+#define CONTROLLER_FAILOVER		0x04
+#define TRANSCEIVER_SE			0x05
+#define TRANSCEIVER_LVD			0x06
+
+	/* These ASCQ's defined for ASC = STATE_CHANGED */
+#define RESERVATION_PREEMPTED		0x03
+#define ASYM_ACCESS_CHANGED		0x06
+#define LUN_CAPACITY_CHANGED		0x09
+
 //transfer direction
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
