From: Daniel Kreling <kreling@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] ipr: Reboot speed improvements
Date: Tue, 31 Mar 2015 10:43:23 -0300
Message-ID: <551AA47B.4020204@linux.vnet.ibm.com>
References: <201503261623.t2QGNpVl021088@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38166 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbbCaNnd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Mar 2015 09:43:33 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <kreling@linux.vnet.ibm.com>;
	Tue, 31 Mar 2015 09:43:32 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 13E8A6E8053
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 09:35:16 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2VDhQ0O7274730
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 13:43:26 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2VDhPhK003981
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 09:43:25 -0400
In-Reply-To: <201503261623.t2QGNpVl021088@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

** Adding Reviewed-by tag **

--
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

Signed-off-by: Brian King
Reviewed-by: Daniel Kreling
---

  drivers/scsi/ipr.c |  160=20
++++++++++++++++++++++++++++++++++++++++++++++++++---
  drivers/scsi/ipr.h |    6 +
  2 files changed, 157 insertions(+), 9 deletions(-)


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff -puN drivers/scsi/ipr.c~ipr_cancel_hcams3 drivers/scsi/ipr.c

--- linux/drivers/scsi/ipr.c~ipr_cancel_hcams3	2015-03-26=20
11:14:37.041812306 -0500

+++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 11:14:37.051812240 -050=
0

@@ -99,5 +99,6 @@

static=B7unsigned=B7int=B7ipr_debug=B7=3D=B70;
static=B7unsigned=B7int=B7ipr_max_devs=B7=3D=B7IPR_DEFAULT_SIS64_DEVS;
static=B7unsigned=B7int=B7ipr_dual_ioa_raid=B7=3D=B71;
static=B7unsigned=B7int=B7ipr_number_of_msix=B7=3D=B72;
+static=B7unsigned=B7int=B7ipr_fast_reboot;
static=B7DEFINE_SPINLOCK(ipr_driver_lock);


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

-		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds) {
+		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds ||
+		    (ipr_fast_reboot && event =3D=3D SYS_RESTART && ioa_cfg->sis64))=
 {
  			spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
  			continue;
  		}
diff -puN drivers/scsi/ipr.h~ipr_cancel_hcams3 drivers/scsi/ipr.h

--- linux/drivers/scsi/ipr.h~ipr_cancel_hcams3	2015-03-26=20
11:14:37.044812286 -0500

+++ linux-bjking1/drivers/scsi/ipr.h	2015-03-26 11:14:37.059812188 -050=
0

@@ -196,6 +196,8 @@

/*
=B7*=B7Adapter=B7Commands
=B7*/
+#define=B7IPR_CANCEL_REQUEST=BB =BB =BB =BB 0xC0
+#define=BBIPR_CANCEL_64BIT_IOARCB=BB=BB =BB 0x01
#define=B7IPR_QUERY_RSRC_STATE=BB =BB =BB =BB 0xC2
#define=B7IPR_RESET_DEVICE=BB =BB =BB =BB 0xC3
#define=BBIPR_RESET_TYPE_SELECT=BB =BB =BB =BB 0x80

@@ -222,6 +224,7 @@

#define=B7IPR_ABBREV_SHUTDOWN_TIMEOUT=BB =BB (10=B7*=B7HZ)
#define=B7IPR_DUAL_IOA_ABBR_SHUTDOWN_TO=BB (2=B7*=B760=B7*=B7HZ)
#define=B7IPR_DEVICE_RESET_TIMEOUT=BB =BB (ipr_fastfail=B7?=B710=B7*=B7=
HZ=B7:=B730=B7*=B7HZ)
+#define=B7IPR_CANCEL_TIMEOUT=BB =BB =BB (ipr_fastfail=B7?=B710=B7*=B7H=
Z=B7:=B730=B7*=B7HZ)
#define=B7IPR_CANCEL_ALL_TIMEOUT=BB =BB (ipr_fastfail=B7?=B710=B7*=B7HZ=
=B7:=B730=B7*=B7HZ)
#define=B7IPR_ABORT_TASK_TIMEOUT=BB =BB (ipr_fastfail=B7?=B710=B7*=B7HZ=
=B7:=B730=B7*=B7HZ)
#define=B7IPR_INTERNAL_TIMEOUT=BB =BB =BB (ipr_fastfail=B7?=B710=B7*=B7=
HZ=B7:=B730=B7*=B7HZ)

@@ -1402,6 +1405,7 @@

enum=B7ipr_shutdown_type=B7{
=BB IPR_SHUTDOWN_NORMAL=B7=3D=B70x00,
=BB IPR_SHUTDOWN_PREPARE_FOR_NORMAL=B7=3D=B70x40,
=BB IPR_SHUTDOWN_ABBREV=B7=3D=B70x80,
-=BB IPR_SHUTDOWN_NONE=B7=3D=B70x100
+=BB IPR_SHUTDOWN_NONE=B7=3D=B70x100,
+=BB IPR_SHUTDOWN_QUIESCE=B7=3D=B70x101,
};

  /* This table describes the differences between DMA controller chips =
*/
@@ -221,6 +222,8 @@ MODULE_PARM_DESC(max_devs, "Specify the
  		 "[Default=3D" __stringify(IPR_DEFAULT_SIS64_DEVS) "]");
  module_param_named(number_of_msix, ipr_number_of_msix, int, 0);
  MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX=20
interrupts to use on capable adapters (1 - 16).  (default:2)");
+module_param_named(fast_reboot, ipr_fast_reboot, int, S_IRUGO | S_IWUS=
R);
+MODULE_PARM_DESC(fast_reboot, "Skip adapter shutdown during reboot. Se=
t=20
to 1 to enable. (default: 0)");
  MODULE_LICENSE("GPL");
  MODULE_VERSION(IPR_DRIVER_VERSION);
@@ -1462,7 +1465,8 @@ static void ipr_process_ccn(struct ipr_c
  	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
  	if (ioasc) {
-		if (ioasc !=3D IPR_IOASC_IOA_WAS_RESET)
+		if (ioasc !=3D IPR_IOASC_IOA_WAS_RESET &&
+		    ioasc !=3D IPR_IOASC_ABORTED_CMD_TERM_BY_HOST)
  			dev_err(&ioa_cfg->pdev->dev,
  				"Host RCB failed with IOASC: 0x%08X\n", ioasc);
@@ -2566,7 +2570,8 @@ static void ipr_process_error(struct ipr
  		ipr_handle_log_data(ioa_cfg, hostrcb);
  		if (fd_ioasc =3D=3D IPR_IOASC_NR_IOA_RESET_REQUIRED)
  			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
-	} else if (ioasc !=3D IPR_IOASC_IOA_WAS_RESET) {
+	} else if (ioasc !=3D IPR_IOASC_IOA_WAS_RESET &&
+		   ioasc !=3D IPR_IOASC_ABORTED_CMD_TERM_BY_HOST) {
  		dev_err(&ioa_cfg->pdev->dev,
  			"Host RCB failed with IOASC: 0x%08X\n", ioasc);
  	}
@@ -5379,9 +5384,6 @@ static irqreturn_t ipr_handle_other_inte
  	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
  		/* Mask the interrupt */
  		writel(IPR_PCII_IOA_TRANS_TO_OPER,=20
ioa_cfg->regs.set_interrupt_mask_reg);
-
-		/* Clear the interrupt */
-		writel(IPR_PCII_IOA_TRANS_TO_OPER, ioa_cfg->regs.clr_interrupt_reg);
  		int_reg =3D readl(ioa_cfg->regs.sense_interrupt_reg);
  		list_del(&ioa_cfg->reset_cmd->queue);
@@ -8480,6 +8482,122 @@ static int ipr_reset_alert(struct ipr_cm
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
+	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
+
+	ENTER;
+	ipr_cmd->job_step =3D ipr_ioa_bringdown_done;
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
+	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
+	struct ipr_cmnd *loop_cmd;
+	struct ipr_hrr_queue *hrrq;
+	int rc =3D IPR_RC_JOB_CONTINUE;
+	int count =3D 0;
+
+	ENTER;
+	ipr_cmd->job_step =3D ipr_reset_quiesce_done;
+
+	for_each_hrrq(hrrq, ioa_cfg) {
+		spin_lock(&hrrq->_lock);
+		list_for_each_entry(loop_cmd, &hrrq->hrrq_pending_q, queue) {
+			count++;
+			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+			list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
+			rc =3D IPR_RC_JOB_RETURN;
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
+	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
+	int rc =3D IPR_RC_JOB_CONTINUE;
+	struct ipr_cmd_pkt *cmd_pkt;
+	struct ipr_cmnd *hcam_cmd;
+	struct ipr_hrr_queue *hrrq =3D &ioa_cfg->hrrq[IPR_INIT_HRRQ];
+
+	ENTER;
+	ipr_cmd->job_step =3D ipr_reset_cancel_hcam_done;
+
+	if (!hrrq->ioa_is_dead) {
+		if (!list_empty(&ioa_cfg->hostrcb_pending_q)) {
+			list_for_each_entry(hcam_cmd, &hrrq->hrrq_pending_q, queue) {
+				if (hcam_cmd->ioarcb.cmd_pkt.cdb[0] !=3D IPR_HOST_CONTROLLED_ASYNC=
)
+					continue;
+
+				ipr_cmd->ioarcb.res_handle =3D cpu_to_be32(IPR_IOA_RES_HANDLE);
+				ipr_cmd->ioarcb.cmd_pkt.request_type =3D IPR_RQTYPE_IOACMD;
+				cmd_pkt =3D &ipr_cmd->ioarcb.cmd_pkt;
+				cmd_pkt->request_type =3D IPR_RQTYPE_IOACMD;
+				cmd_pkt->cdb[0] =3D IPR_CANCEL_REQUEST;
+				cmd_pkt->cdb[1] =3D IPR_CANCEL_64BIT_IOARCB;
+				cmd_pkt->cdb[10] =3D ((u64) hcam_cmd->dma_addr >> 56) & 0xff;
+				cmd_pkt->cdb[11] =3D ((u64) hcam_cmd->dma_addr >> 48) & 0xff;
+				cmd_pkt->cdb[12] =3D ((u64) hcam_cmd->dma_addr >> 40) & 0xff;
+				cmd_pkt->cdb[13] =3D ((u64) hcam_cmd->dma_addr >> 32) & 0xff;
+				cmd_pkt->cdb[2] =3D ((u64) hcam_cmd->dma_addr >> 24) & 0xff;
+				cmd_pkt->cdb[3] =3D ((u64) hcam_cmd->dma_addr >> 16) & 0xff;
+				cmd_pkt->cdb[4] =3D ((u64) hcam_cmd->dma_addr >> 8) & 0xff;
+				cmd_pkt->cdb[5] =3D ((u64) hcam_cmd->dma_addr) & 0xff;
+
+				ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
+					   IPR_CANCEL_TIMEOUT);
+
+				rc =3D IPR_RC_JOB_RETURN;
+				ipr_cmd->job_step =3D ipr_reset_cancel_hcam;
+				break;
+			}
+		}
+	} else
+		ipr_cmd->job_step =3D ipr_reset_alert;
+
+	LEAVE;
+	return rc;
+}
+
+/**
   * ipr_reset_ucode_download_done - Microcode download completion
   * @ipr_cmd:	ipr command struct
   *
@@ -8561,7 +8679,9 @@ static int ipr_reset_shutdown_ioa(struct
  	int rc =3D IPR_RC_JOB_CONTINUE;
  	ENTER;
-	if (shutdown_type !=3D IPR_SHUTDOWN_NONE &&
+	if (shutdown_type =3D=3D IPR_SHUTDOWN_QUIESCE)
+		ipr_cmd->job_step =3D ipr_reset_cancel_hcam;
+	else if (shutdown_type !=3D IPR_SHUTDOWN_NONE &&
  			!ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
  		ipr_cmd->ioarcb.res_handle =3D cpu_to_be32(IPR_IOA_RES_HANDLE);
  		ipr_cmd->ioarcb.cmd_pkt.request_type =3D IPR_RQTYPE_IOACMD;
@@ -10036,6 +10156,7 @@ static void ipr_shutdown(struct pci_dev
  {
  	struct ipr_ioa_cfg *ioa_cfg =3D pci_get_drvdata(pdev);
  	unsigned long lock_flags =3D 0;
+	enum ipr_shutdown_type shutdown_type =3D IPR_SHUTDOWN_NORMAL;
  	int i;
  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -10051,9 +10172,31 @@ static void ipr_shutdown(struct pci_dev
  		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
  	}
-	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
+	if (ipr_fast_reboot && system_state =3D=3D SYSTEM_RESTART && ioa_cfg-=
>sis64)
+		shutdown_type =3D IPR_SHUTDOWN_QUIESCE;
+
+	ipr_initiate_ioa_bringdown(ioa_cfg, shutdown_type);
  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
  	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+	if (ipr_fast_reboot && system_state =3D=3D SYSTEM_RESTART && ioa_cfg-=
>sis64) {
+		if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSI ||
+		    ioa_cfg->intr_flag =3D=3D IPR_USE_MSIX) {
+			int i;
+			for (i =3D 0; i < ioa_cfg->nvectors; i++)
+				free_irq(ioa_cfg->vectors_info[i].vec,
+					 &ioa_cfg->hrrq[i]);
+		}
+
+		if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSI) {
+			pci_disable_msi(ioa_cfg->pdev);
+			ioa_cfg->intr_flag &=3D ~IPR_USE_MSI;
+		} else if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSIX) {
+			pci_disable_msix(ioa_cfg->pdev);
+			ioa_cfg->intr_flag &=3D ~IPR_USE_MSIX;
+		}
+
+		pci_disable_device(ioa_cfg->pdev);
+	}
  }
  static struct pci_device_id ipr_pci_table[] =3D {
@@ -10211,7 +10354,8 @@ static int ipr_halt(struct notifier_bloc
  	list_for_each_entry(ioa_cfg, &ipr_ioa_head, queue) {
  		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
  struct ipr_trace_entry {
_

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
