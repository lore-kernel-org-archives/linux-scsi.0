From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Wed, 11 Mar 2009 11:17:33 -0500
Message-ID: <20090311161733.GF28208@beardog.cca.cpqcorp.net>
References: <20090310151738.GA18243@beardog.cca.cpqcorp.net> <1236700241.14822.4.camel@localhost.localdomain> <20090310163426.GC18243@beardog.cca.cpqcorp.net> <20090310153933.7a7fc224.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30842 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZCKQRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2009 12:17:34 -0400
Content-Disposition: inline
In-Reply-To: <20090310153933.7a7fc224.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com

On Tue, Mar 10, 2009 at 03:39:33PM -0700, Andrew Morton wrote:
> 
> Confused.
> 
> > +static int scan_thread(ctlr_info_t *h)
> > +{
> > +	int rc;
> > +	DECLARE_COMPLETION_ONSTACK(wait);
> > +	h->rescan_wait = &wait;
> > +
> > +	while (!kthread_should_stop()) {
> > +		rc = wait_for_completion_interruptible(&wait);
> > +		if (!rc)
> > +			continue;
> > +		else
> > +			rebuild_lun_table(h, 0);
> > +	}
> > +	return 0;
> > +}
> 
> afacit this thread won't ever do anything,
> 
> > +static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
> > +{
> > +	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
> > +		return 0;
> > +
> > +	switch (c->err_info->SenseInfo[12]) {
> > +	case STATE_CHANGED:
> > +		printk(KERN_WARNING "cciss%d: a state change "
> > +			"detected, command retried\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	case LUN_FAILED:
> > +		printk(KERN_WARNING "cciss%d: LUN failure "
> > +			"detected, action required\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	case REPORT_LUNS_CHANGED:
> > +		printk(KERN_WARNING "cciss%d: report LUN data "
> > +			"changed\n", h->ctlr);
> > +		if (h->rescan_wait)
> > +			complete(h->rescan_wait);
> 
> because this will cause the wait_for_completion_interruptible() to return 0.
> 
> > +		return 1;
> > +	break;
> > +	case POWER_OR_RESET:
> > +		printk(KERN_WARNING "cciss%d: a power on "
> > +			"or device reset detected\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	case UNIT_ATTENTION_CLEARED:
> > +		printk(KERN_WARNING "cciss%d: unit attention "
> > +		    "cleared by another initiator\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	default:
> > +		printk(KERN_WARNING "cciss%d: unknown "
> > +			"unit attention detected\n", h->ctlr);
> > +				return 1;
> > +	}
> > +}
> 
Changed the logic in the while loop. The thread works, whenever I change my
config the next IO to the storage returns the unit attention
LUN_DATA_CHANGED. The thread fires off and either adds or removes the
logical volume.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d2cb67b..819352c 100644
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
@@ -2657,7 +2676,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 
 	switch (cmd->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		rq->errors = evaluate_target_status(cmd);
+		rq->errors = evaluate_target_status(h, cmd, &retry_cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (blk_fs_request(cmd->rq)) {
@@ -3008,6 +3027,60 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int scan_thread(ctlr_info_t *h)
+{
+	int rc;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	h->rescan_wait = &wait;
+
+	while (!kthread_should_stop()) {
+		rc = wait_for_completion_interruptible(&wait);
+		if (!rc)
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
@@ -3600,6 +3673,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int rc;
 	int dac, return_code;
 	InquiryData_struct *inq_buff = NULL;
+	char cciss_scan[14];
 
 	if (reset_devices) {
 		/* Reset the controller with a PCI power-cycle */
@@ -3751,6 +3825,12 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	hba[i]->busy_initializing = 0;
 
 	rebuild_lun_table(hba[i], 1);
+	snprintf(cciss_scan, 14, "cciss_scan%02d", i);
+	hba[i]->cciss_scan_thread = kthread_run((void *)scan_thread, hba[i],
+				cciss_scan);
+	if (IS_ERR(hba[i]->cciss_scan_thread))
+		return PTR_ERR(hba[i]->cciss_scan_thread);
+
 	return 1;
 
 clean4:
@@ -3826,6 +3906,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		printk(KERN_ERR "cciss: Unable to remove device \n");
 		return;
 	}
+
 	tmp_ptr = pci_get_drvdata(pdev);
 	i = tmp_ptr->ctlr;
 	if (hba[i] == NULL) {
@@ -3834,6 +3915,8 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		return;
 	}
 
+	kthread_stop(hba[i]->cciss_scan_thread);
+
 	remove_proc_entry(hba[i]->devname, proc_cciss);
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
 
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 15e2b84..703e080 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -121,6 +121,8 @@ struct ctlr_info
 	struct sendcmd_reject_list scsi_rejects;
 #endif
 	unsigned char alive;
+	struct completion *rescan_wait;
+	struct task_struct *cciss_scan_thread;
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
