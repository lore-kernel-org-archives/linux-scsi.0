From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: Reboot speed improvements
Date: Fri, 30 Jan 2015 16:30:58 -0600
Message-ID: <201501302230.t0UMUxTa006718@d03av05.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:32981 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbbA3WbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2015 17:31:04 -0500
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 30 Jan 2015 15:31:03 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CD4E119D8041
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 15:22:10 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0UMV6w117301572
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 15:31:06 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0UMUx7B006788
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 15:31:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Currently when performing a reboot with an ipr adapter,
the adapter gets shutdown completely, flushing all write
cache, as well as performing a full hardware reset of the card
during the shutdown phase of the old kernel. This ensures
the adapter is in a fully quiesced state across the reboot.

There are scenarios, however, such as when performing
kexec, where this full adapter shutdown is not required
and not desired, since it can make the reboot process take
noticeably longer.

This patch adds a module parameter to allow for skipping the
full shutdown during reboot. Rather than performing a full
adapter shutdown and reset, we simply cancel any outstanding
error buffers, place the adapter into a state where it has no
memory of any DMA addresses from the old kernel, then disable
the device. This significantly speeds up kexec boot, particularly
in configurations with multiple ipr adapters.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  160 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ipr.h |    6 +
 2 files changed, 157 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_cancel_hcams3 drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_cancel_hcams3	2015-01-30 16:28:13.534983070 -0600
+++ linux-bjking1/drivers/scsi/ipr.c	2015-01-30 16:28:13.549982974 -0600
@@ -99,6 +99,7 @@ static unsigned int ipr_debug = 0;
 static unsigned int ipr_max_devs = IPR_DEFAULT_SIS64_DEVS;
 static unsigned int ipr_dual_ioa_raid = 1;
 static unsigned int ipr_number_of_msix = 2;
+static unsigned int ipr_fast_reboot;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -221,6 +222,8 @@ MODULE_PARM_DESC(max_devs, "Specify the 
 		 "[Default=" __stringify(IPR_DEFAULT_SIS64_DEVS) "]");
 module_param_named(number_of_msix, ipr_number_of_msix, int, 0);
 MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX interrupts to use on capable adapters (1 - 16).  (default:2)");
+module_param_named(fast_reboot, ipr_fast_reboot, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fast_reboot, "Skip adapter shutdown during reboot. Set to 1 to enable. (default: 0)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -1462,7 +1465,8 @@ static void ipr_process_ccn(struct ipr_c
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 
 	if (ioasc) {
-		if (ioasc != IPR_IOASC_IOA_WAS_RESET)
+		if (ioasc != IPR_IOASC_IOA_WAS_RESET &&
+		    ioasc != IPR_IOASC_ABORTED_CMD_TERM_BY_HOST)
 			dev_err(&ioa_cfg->pdev->dev,
 				"Host RCB failed with IOASC: 0x%08X\n", ioasc);
 
@@ -2566,7 +2570,8 @@ static void ipr_process_error(struct ipr
 		ipr_handle_log_data(ioa_cfg, hostrcb);
 		if (fd_ioasc == IPR_IOASC_NR_IOA_RESET_REQUIRED)
 			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
-	} else if (ioasc != IPR_IOASC_IOA_WAS_RESET) {
+	} else if (ioasc != IPR_IOASC_IOA_WAS_RESET &&
+		   ioasc != IPR_IOASC_ABORTED_CMD_TERM_BY_HOST) {
 		dev_err(&ioa_cfg->pdev->dev,
 			"Host RCB failed with IOASC: 0x%08X\n", ioasc);
 	}
@@ -5379,9 +5384,6 @@ static irqreturn_t ipr_handle_other_inte
 	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
 		/* Mask the interrupt */
 		writel(IPR_PCII_IOA_TRANS_TO_OPER, ioa_cfg->regs.set_interrupt_mask_reg);
-
-		/* Clear the interrupt */
-		writel(IPR_PCII_IOA_TRANS_TO_OPER, ioa_cfg->regs.clr_interrupt_reg);
 		int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
 
 		list_del(&ioa_cfg->reset_cmd->queue);
@@ -8479,6 +8481,122 @@ static int ipr_reset_alert(struct ipr_cm
 }
 
 /**
+ * ipr_reset_quiesce_done - Complete IOA disconnect
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: Freeze the adapter to complete quiesce processing
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE
+ **/
+static int ipr_reset_quiesce_done(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	ENTER;
+	ipr_cmd->job_step = ipr_ioa_bringdown_done;
+	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
+	LEAVE;
+	return IPR_RC_JOB_CONTINUE;
+}
+
+/**
+ * ipr_reset_cancel_hcam_done - Check for outstanding commands
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: Ensure nothing is outstanding to the IOA and
+ *			proceed with IOA disconnect. Otherwise reset the IOA.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_RETURN / IPR_RC_JOB_CONTINUE
+ **/
+static int ipr_reset_cancel_hcam_done(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ipr_cmnd *loop_cmd;
+	struct ipr_hrr_queue *hrrq;
+	int rc = IPR_RC_JOB_CONTINUE;
+	int count = 0;
+
+	ENTER;
+	ipr_cmd->job_step = ipr_reset_quiesce_done;
+
+	for_each_hrrq(hrrq, ioa_cfg) {
+		spin_lock(&hrrq->_lock);
+		list_for_each_entry(loop_cmd, &hrrq->hrrq_pending_q, queue) {
+			count++;
+			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+			list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
+			rc = IPR_RC_JOB_RETURN;
+			break;
+		}
+		spin_unlock(&hrrq->_lock);
+
+		if (count)
+			break;
+	}
+
+	LEAVE;
+	return rc;
+}
+
+/**
+ * ipr_reset_cancel_hcam - Cancel outstanding HCAMs
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: Cancel any oustanding HCAMs to the IOA.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_cancel_hcam(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	int rc = IPR_RC_JOB_CONTINUE;
+	struct ipr_cmd_pkt *cmd_pkt;
+	struct ipr_cmnd *hcam_cmd;
+	struct ipr_hrr_queue *hrrq = &ioa_cfg->hrrq[IPR_INIT_HRRQ];
+
+	ENTER;
+	ipr_cmd->job_step = ipr_reset_cancel_hcam_done;
+
+	if (!hrrq->ioa_is_dead) {
+		if (!list_empty(&ioa_cfg->hostrcb_pending_q)) {
+			list_for_each_entry(hcam_cmd, &hrrq->hrrq_pending_q, queue) {
+				if (hcam_cmd->ioarcb.cmd_pkt.cdb[0] != IPR_HOST_CONTROLLED_ASYNC)
+					continue;
+
+				ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
+				ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
+				cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
+				cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
+				cmd_pkt->cdb[0] = IPR_CANCEL_REQUEST;
+				cmd_pkt->cdb[1] = IPR_CANCEL_64BIT_IOARCB;
+				cmd_pkt->cdb[10] = ((u64) hcam_cmd->dma_addr >> 56) & 0xff;
+				cmd_pkt->cdb[11] = ((u64) hcam_cmd->dma_addr >> 48) & 0xff;
+				cmd_pkt->cdb[12] = ((u64) hcam_cmd->dma_addr >> 40) & 0xff;
+				cmd_pkt->cdb[13] = ((u64) hcam_cmd->dma_addr >> 32) & 0xff;
+				cmd_pkt->cdb[2] = ((u64) hcam_cmd->dma_addr >> 24) & 0xff;
+				cmd_pkt->cdb[3] = ((u64) hcam_cmd->dma_addr >> 16) & 0xff;
+				cmd_pkt->cdb[4] = ((u64) hcam_cmd->dma_addr >> 8) & 0xff;
+				cmd_pkt->cdb[5] = ((u64) hcam_cmd->dma_addr) & 0xff;
+
+				ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
+					   IPR_CANCEL_TIMEOUT);
+
+				rc = IPR_RC_JOB_RETURN;
+				ipr_cmd->job_step = ipr_reset_cancel_hcam;
+				break;
+			}
+		}
+	} else
+		ipr_cmd->job_step = ipr_reset_alert;
+
+	LEAVE;
+	return rc;
+}
+
+/**
  * ipr_reset_ucode_download_done - Microcode download completion
  * @ipr_cmd:	ipr command struct
  *
@@ -8560,7 +8678,9 @@ static int ipr_reset_shutdown_ioa(struct
 	int rc = IPR_RC_JOB_CONTINUE;
 
 	ENTER;
-	if (shutdown_type != IPR_SHUTDOWN_NONE &&
+	if (shutdown_type == IPR_SHUTDOWN_QUIESCE)
+		ipr_cmd->job_step = ipr_reset_cancel_hcam;
+	else if (shutdown_type != IPR_SHUTDOWN_NONE &&
 			!ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
 		ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
 		ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
@@ -10035,6 +10155,7 @@ static void ipr_shutdown(struct pci_dev 
 {
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 	unsigned long lock_flags = 0;
+	enum ipr_shutdown_type shutdown_type = IPR_SHUTDOWN_NORMAL;
 	int i;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -10050,9 +10171,31 @@ static void ipr_shutdown(struct pci_dev 
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	}
 
-	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
+	if (ipr_fast_reboot && system_state == SYSTEM_RESTART && ioa_cfg->sis64)
+		shutdown_type = IPR_SHUTDOWN_QUIESCE;
+
+	ipr_initiate_ioa_bringdown(ioa_cfg, shutdown_type);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+	if (ipr_fast_reboot && system_state == SYSTEM_RESTART && ioa_cfg->sis64) {
+		if (ioa_cfg->intr_flag == IPR_USE_MSI ||
+		    ioa_cfg->intr_flag == IPR_USE_MSIX) {
+			int i;
+			for (i = 0; i < ioa_cfg->nvectors; i++)
+				free_irq(ioa_cfg->vectors_info[i].vec,
+					 &ioa_cfg->hrrq[i]);
+		}
+
+		if (ioa_cfg->intr_flag == IPR_USE_MSI) {
+			pci_disable_msi(ioa_cfg->pdev);
+			ioa_cfg->intr_flag &= ~IPR_USE_MSI;
+		} else if (ioa_cfg->intr_flag == IPR_USE_MSIX) {
+			pci_disable_msix(ioa_cfg->pdev);
+			ioa_cfg->intr_flag &= ~IPR_USE_MSIX;
+		}
+
+		pci_disable_device(ioa_cfg->pdev);
+	}
 }
 
 static struct pci_device_id ipr_pci_table[] = {
@@ -10210,7 +10353,8 @@ static int ipr_halt(struct notifier_bloc
 
 	list_for_each_entry(ioa_cfg, &ipr_ioa_head, queue) {
 		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds) {
+		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds ||
+		    (ipr_fast_reboot && event == SYS_RESTART && ioa_cfg->sis64)) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 			continue;
 		}
diff -puN drivers/scsi/ipr.h~ipr_cancel_hcams3 drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_cancel_hcams3	2015-01-30 16:28:13.540983034 -0600
+++ linux-bjking1/drivers/scsi/ipr.h	2015-01-30 16:28:13.554982944 -0600
@@ -196,6 +196,8 @@
 /*
  * Adapter Commands
  */
+#define IPR_CANCEL_REQUEST				0xC0
+#define	IPR_CANCEL_64BIT_IOARCB			0x01
 #define IPR_QUERY_RSRC_STATE				0xC2
 #define IPR_RESET_DEVICE				0xC3
 #define	IPR_RESET_TYPE_SELECT				0x80
@@ -222,6 +224,7 @@
 #define IPR_ABBREV_SHUTDOWN_TIMEOUT		(10 * HZ)
 #define IPR_DUAL_IOA_ABBR_SHUTDOWN_TO	(2 * 60 * HZ)
 #define IPR_DEVICE_RESET_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
+#define IPR_CANCEL_TIMEOUT			(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_CANCEL_ALL_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_ABORT_TASK_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_INTERNAL_TIMEOUT			(ipr_fastfail ? 10 * HZ : 30 * HZ)
@@ -1402,7 +1405,8 @@ enum ipr_shutdown_type {
 	IPR_SHUTDOWN_NORMAL = 0x00,
 	IPR_SHUTDOWN_PREPARE_FOR_NORMAL = 0x40,
 	IPR_SHUTDOWN_ABBREV = 0x80,
-	IPR_SHUTDOWN_NONE = 0x100
+	IPR_SHUTDOWN_NONE = 0x100,
+	IPR_SHUTDOWN_QUIESCE = 0x101,
 };
 
 struct ipr_trace_entry {
_

