From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.22: Add support for PCI Adapter Failure
Date: Fri, 11 Mar 2011 16:06:12 -0500
Message-ID: <1299877586.31589.18.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23191 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754566Ab1CKVGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2011 16:06:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Periodically poll adapter registers to detect pci adapter failure
(reads return -1). On failure, take port offline, set error indicators
and wake up worker threads. Threads will take adapter offline.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |   25 ++++++--
 lpfc_attr.c |   10 ++-
 lpfc_bsg.c  |   16 ++++-
 lpfc_els.c  |    3 
 lpfc_hw.h   |    2 
 lpfc_init.c |   38 ++++++++----
 lpfc_sli.c  |  184 +++++++++++++++++++++++++++++++++++++++++++++---------------
 7 files changed, 207 insertions(+), 71 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-03-11 14:57:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-03-11 14:58:21.000000000 -0500
@@ -1224,7 +1224,10 @@ lpfc_poll_store(struct device *dev, stru
 	if (val & ENABLE_FCP_RING_POLLING) {
 		if ((val & DISABLE_FCP_RING_INT) &&
 		    !(old_val & DISABLE_FCP_RING_INT)) {
-			creg_val = readl(phba->HCregaddr);
+			if (lpfc_readl(phba->HCregaddr, &creg_val)) {
+				spin_unlock_irq(&phba->hbalock);
+				return -EINVAL;
+			}
 			creg_val &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
 			writel(creg_val, phba->HCregaddr);
 			readl(phba->HCregaddr); /* flush */
@@ -1242,7 +1245,10 @@ lpfc_poll_store(struct device *dev, stru
 		spin_unlock_irq(&phba->hbalock);
 		del_timer(&phba->fcp_poll_timer);
 		spin_lock_irq(&phba->hbalock);
-		creg_val = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &creg_val)) {
+			spin_unlock_irq(&phba->hbalock);
+			return -EINVAL;
+		}
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
 		readl(phba->HCregaddr); /* flush */
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2011-03-11 14:57:53.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2011-03-11 14:58:21.000000000 -0500
@@ -348,7 +348,10 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	dd_data->context_un.iocb.bmp = bmp;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		creg_val = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &creg_val)) {
+			rc = -EIO ;
+			goto free_cmdiocbq;
+		}
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
 		readl(phba->HCregaddr); /* flush */
@@ -599,7 +602,10 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	dd_data->context_un.iocb.ndlp = ndlp;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		creg_val = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &creg_val)) {
+			rc = -EIO;
+			goto linkdown_err;
+		}
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
 		readl(phba->HCregaddr); /* flush */
@@ -613,6 +619,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	else
 		rc = -EIO;
 
+linkdown_err:
 	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
 		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
@@ -1357,7 +1364,10 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 	dd_data->context_un.iocb.ndlp = ndlp;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		creg_val = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &creg_val)) {
+			rc = -IOCB_ERROR;
+			goto issue_ct_rsp_exit;
+		}
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
 		readl(phba->HCregaddr); /* flush */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-03-11 14:58:21.000000000 -0500
@@ -89,7 +89,8 @@ lpfc_els_chk_latt(struct lpfc_vport *vpo
 		return 0;
 
 	/* Read the HBA Host Attention Register */
-	ha_copy = readl(phba->HAregaddr);
+	if (lpfc_readl(phba->HAregaddr, &ha_copy))
+		return 1;
 
 	if (!(ha_copy & HA_LATT))
 		return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-03-11 14:57:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2011-03-11 14:58:21.000000000 -0500
@@ -897,7 +897,18 @@ lpfc_worker_wake_up(struct lpfc_hba *phb
 	return;
 }
 
-static inline void
+static inline int
+lpfc_readl(void __iomem *addr, uint32_t *data)
+{
+	uint32_t temp;
+	temp = readl(addr);
+	if (temp == 0xffffffff)
+		return -EIO;
+	*data = temp;
+	return 0;
+}
+
+static inline int
 lpfc_sli_read_hs(struct lpfc_hba *phba)
 {
 	/*
@@ -906,15 +917,17 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 	 */
 	phba->sli.slistat.err_attn_event++;
 
-	/* Save status info */
-	phba->work_hs = readl(phba->HSregaddr);
-	phba->work_status[0] = readl(phba->MBslimaddr + 0xa8);
-	phba->work_status[1] = readl(phba->MBslimaddr + 0xac);
+	/* Save status info and check for unplug error */
+	if (lpfc_readl(phba->HSregaddr, &phba->work_hs) ||
+		lpfc_readl(phba->MBslimaddr + 0xa8, &phba->work_status[0]) ||
+		lpfc_readl(phba->MBslimaddr + 0xac, &phba->work_status[1])) {
+		return -EIO;
+	}
 
 	/* Clear chip Host Attention error bit */
 	writel(HA_ERATT, phba->HAregaddr);
 	readl(phba->HAregaddr); /* flush */
 	phba->pport->stopped = 1;
 
-	return;
+	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-03-11 14:57:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-03-11 14:58:21.000000000 -0500
@@ -1344,7 +1344,7 @@ typedef struct {		/* FireFly BIU registe
 #define HS_FFER1       0x80000000	/* Bit 31 */
 #define HS_CRIT_TEMP   0x00000100	/* Bit 8  */
 #define HS_FFERM       0xFF000100	/* Mask for error bits 31:24 and 8 */
-
+#define UNPLUG_ERR     0x00000001	/* Indicate pci hot unplug */
 /* Host Control Register */
 
 #define HC_REG_OFFSET  12	/* Byte offset from register base address */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-03-11 14:57:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-03-11 14:58:21.000000000 -0500
@@ -507,7 +507,10 @@ lpfc_config_port_post(struct lpfc_hba *p
 	phba->hba_flag &= ~HBA_ERATT_HANDLED;
 
 	/* Enable appropriate host interrupts */
-	status = readl(phba->HCregaddr);
+	if (lpfc_readl(phba->HCregaddr, &status)) {
+		spin_unlock_irq(&phba->hbalock);
+		return -EIO;
+	}
 	status |= HC_MBINT_ENA | HC_ERINT_ENA | HC_LAINT_ENA;
 	if (psli->num_rings > 0)
 		status |= HC_R0INT_ENA;
@@ -1222,7 +1225,10 @@ lpfc_handle_deferred_eratt(struct lpfc_h
 	/* Wait for the ER1 bit to clear.*/
 	while (phba->work_hs & HS_FFER1) {
 		msleep(100);
-		phba->work_hs = readl(phba->HSregaddr);
+		if (lpfc_readl(phba->HSregaddr, &phba->work_hs)) {
+			phba->work_hs = UNPLUG_ERR ;
+			break;
+		}
 		/* If driver is unloading let the worker thread continue */
 		if (phba->pport->load_flag & FC_UNLOADING) {
 			phba->work_hs = 0;
@@ -5386,13 +5392,16 @@ lpfc_sli4_post_status_check(struct lpfc_
 	int i, port_error = 0;
 	uint32_t if_type;
 
+	memset(&portsmphr_reg, 0, sizeof(portsmphr_reg));
+	memset(&reg_data, 0, sizeof(reg_data));
 	if (!phba->sli4_hba.PSMPHRregaddr)
 		return -ENODEV;
 
 	/* Wait up to 30 seconds for the SLI Port POST done and ready */
 	for (i = 0; i < 3000; i++) {
-		portsmphr_reg.word0 = readl(phba->sli4_hba.PSMPHRregaddr);
-		if (bf_get(lpfc_port_smphr_perr, &portsmphr_reg)) {
+		if (lpfc_readl(phba->sli4_hba.PSMPHRregaddr,
+			&portsmphr_reg.word0) ||
+			(bf_get(lpfc_port_smphr_perr, &portsmphr_reg))) {
 			/* Port has a fatal POST error, break out */
 			port_error = -ENODEV;
 			break;
@@ -5473,9 +5482,9 @@ lpfc_sli4_post_status_check(struct lpfc_
 			break;
 		case LPFC_SLI_INTF_IF_TYPE_2:
 			/* Final checks.  The port status should be clean. */
-			reg_data.word0 =
-				readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
-			if (bf_get(lpfc_sliport_status_err, &reg_data)) {
+			if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+				&reg_data.word0) ||
+				bf_get(lpfc_sliport_status_err, &reg_data)) {
 				phba->work_status[0] =
 					readl(phba->sli4_hba.u.if_type2.
 					      ERR1regaddr);
@@ -6761,9 +6770,11 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			 * the loop again.
 			 */
 			for (rdy_chk = 0; rdy_chk < 1000; rdy_chk++) {
-				reg_data.word0 =
-					readl(phba->sli4_hba.u.if_type2.
-					      STATUSregaddr);
+				if (lpfc_readl(phba->sli4_hba.u.if_type2.
+					      STATUSregaddr, &reg_data.word0)) {
+					rc = -ENODEV;
+					break;
+				}
 				if (bf_get(lpfc_sliport_status_rdy, &reg_data))
 					break;
 				if (bf_get(lpfc_sliport_status_rn, &reg_data)) {
@@ -6784,8 +6795,11 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			}
 
 			/* Detect any port errors. */
-			reg_data.word0 = readl(phba->sli4_hba.u.if_type2.
-					       STATUSregaddr);
+			if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+				 &reg_data.word0)) {
+				rc = -ENODEV;
+				break;
+			}
 			if ((bf_get(lpfc_sliport_status_err, &reg_data)) ||
 			    (rdy_chk >= 1000)) {
 				phba->work_status[0] = readl(
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 14:57:53.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 14:58:21.000000000 -0500
@@ -3477,7 +3477,8 @@ lpfc_sli_brdready_s3(struct lpfc_hba *ph
 	int retval = 0;
 
 	/* Read the HBA Host Status Register */
-	status = readl(phba->HSregaddr);
+	if (lpfc_readl(phba->HSregaddr, &status))
+		return 1;
 
 	/*
 	 * Check status register every 100ms for 5 retries, then every
@@ -3502,7 +3503,10 @@ lpfc_sli_brdready_s3(struct lpfc_hba *ph
 			lpfc_sli_brdrestart(phba);
 		}
 		/* Read the HBA Host Status Register */
-		status = readl(phba->HSregaddr);
+		if (lpfc_readl(phba->HSregaddr, &status)) {
+			retval = 1;
+			break;
+		}
 	}
 
 	/* Check to see if any errors occurred during init */
@@ -3584,7 +3588,7 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	uint32_t __iomem *resp_buf;
 	uint32_t __iomem *mbox_buf;
 	volatile uint32_t mbox;
-	uint32_t hc_copy;
+	uint32_t hc_copy, ha_copy, resp_data;
 	int  i;
 	uint8_t hdrtype;
 
@@ -3601,12 +3605,15 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	resp_buf = phba->MBslimaddr;
 
 	/* Disable the error attention */
-	hc_copy = readl(phba->HCregaddr);
+	if (lpfc_readl(phba->HCregaddr, &hc_copy))
+		return;
 	writel((hc_copy & ~HC_ERINT_ENA), phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 	phba->link_flag |= LS_IGNORE_ERATT;
 
-	if (readl(phba->HAregaddr) & HA_ERATT) {
+	if (lpfc_readl(phba->HAregaddr, &ha_copy))
+		return;
+	if (ha_copy & HA_ERATT) {
 		/* Clear Chip error bit */
 		writel(HA_ERATT, phba->HAregaddr);
 		phba->pport->stopped = 1;
@@ -3620,11 +3627,18 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	mbox_buf = phba->MBslimaddr;
 	writel(mbox, mbox_buf);
 
-	for (i = 0;
-	     readl(resp_buf + 1) != ~(BARRIER_TEST_PATTERN) && i < 50; i++)
-		mdelay(1);
-
-	if (readl(resp_buf + 1) != ~(BARRIER_TEST_PATTERN)) {
+	for (i = 0; i < 50; i++) {
+		if (lpfc_readl((resp_buf + 1), &resp_data))
+			return;
+		if (resp_data != ~(BARRIER_TEST_PATTERN))
+			mdelay(1);
+		else
+			break;
+	}
+	resp_data = 0;
+	if (lpfc_readl((resp_buf + 1), &resp_data))
+		return;
+	if (resp_data  != ~(BARRIER_TEST_PATTERN)) {
 		if (phba->sli.sli_flag & LPFC_SLI_ACTIVE ||
 		    phba->pport->stopped)
 			goto restore_hc;
@@ -3633,13 +3647,26 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	}
 
 	((MAILBOX_t *)&mbox)->mbxOwner = OWN_HOST;
-	for (i = 0; readl(resp_buf) != mbox &&  i < 500; i++)
-		mdelay(1);
+	resp_data = 0;
+	for (i = 0; i < 500; i++) {
+		if (lpfc_readl(resp_buf, &resp_data))
+			return;
+		if (resp_data != mbox)
+			mdelay(1);
+		else
+			break;
+	}
 
 clear_errat:
 
-	while (!(readl(phba->HAregaddr) & HA_ERATT) && ++i < 500)
-		mdelay(1);
+	while (++i < 500) {
+		if (lpfc_readl(phba->HAregaddr, &ha_copy))
+			return;
+		if (!(ha_copy & HA_ERATT))
+			mdelay(1);
+		else
+			break;
+	}
 
 	if (readl(phba->HAregaddr) & HA_ERATT) {
 		writel(HA_ERATT, phba->HAregaddr);
@@ -3686,7 +3713,11 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 
 	/* Disable the error attention */
 	spin_lock_irq(&phba->hbalock);
-	status = readl(phba->HCregaddr);
+	if (lpfc_readl(phba->HCregaddr, &status)) {
+		spin_unlock_irq(&phba->hbalock);
+		mempool_free(pmb, phba->mbox_mem_pool);
+		return 1;
+	}
 	status &= ~HC_ERINT_ENA;
 	writel(status, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
@@ -3720,11 +3751,12 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 	 * 3 seconds we still set HBA_ERROR state because the status of the
 	 * board is now undefined.
 	 */
-	ha_copy = readl(phba->HAregaddr);
-
+	if (lpfc_readl(phba->HAregaddr, &ha_copy))
+		return 1;
 	while ((i++ < 30) && !(ha_copy & HA_ERATT)) {
 		mdelay(100);
-		ha_copy = readl(phba->HAregaddr);
+		if (lpfc_readl(phba->HAregaddr, &ha_copy))
+			return 1;
 	}
 
 	del_timer_sync(&psli->mbox_tmo);
@@ -4018,7 +4050,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 	uint32_t status, i = 0;
 
 	/* Read the HBA Host Status Register */
-	status = readl(phba->HSregaddr);
+	if (lpfc_readl(phba->HSregaddr, &status))
+		return -EIO;
 
 	/* Check status register to see what current state is */
 	i = 0;
@@ -4073,7 +4106,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 			lpfc_sli_brdrestart(phba);
 		}
 		/* Read the HBA Host Status Register */
-		status = readl(phba->HSregaddr);
+		if (lpfc_readl(phba->HSregaddr, &status))
+			return -EIO;
 	}
 
 	/* Check to see if any errors occurred during init */
@@ -5136,7 +5170,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 	MAILBOX_t *mb;
 	struct lpfc_sli *psli = &phba->sli;
 	uint32_t status, evtctr;
-	uint32_t ha_copy;
+	uint32_t ha_copy, hc_copy;
 	int i;
 	unsigned long timeout;
 	unsigned long drvr_flag = 0;
@@ -5202,15 +5236,17 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 		goto out_not_finished;
 	}
 
-	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT &&
-	    !(readl(phba->HCregaddr) & HC_MBINT_ENA)) {
-		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT) {
+		if (lpfc_readl(phba->HCregaddr, &hc_copy) ||
+			!(hc_copy & HC_MBINT_ENA)) {
+			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"(%d):2528 Mailbox command x%x cannot "
 				"issue Data: x%x x%x\n",
 				pmbox->vport ? pmbox->vport->vpi : 0,
 				pmbox->u.mb.mbxCommand, psli->sli_flag, flag);
-		goto out_not_finished;
+			goto out_not_finished;
+		}
 	}
 
 	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
@@ -5408,11 +5444,19 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 			word0 = le32_to_cpu(word0);
 		} else {
 			/* First read mbox status word */
-			word0 = readl(phba->MBslimaddr);
+			if (lpfc_readl(phba->MBslimaddr, &word0)) {
+				spin_unlock_irqrestore(&phba->hbalock,
+						       drvr_flag);
+				goto out_not_finished;
+			}
 		}
 
 		/* Read the HBA Host Attention Register */
-		ha_copy = readl(phba->HAregaddr);
+		if (lpfc_readl(phba->HAregaddr, &ha_copy)) {
+			spin_unlock_irqrestore(&phba->hbalock,
+						       drvr_flag);
+			goto out_not_finished;
+		}
 		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
 							     mb->mbxCommand) *
 					   1000) + jiffies;
@@ -5463,7 +5507,11 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 				word0 = readl(phba->MBslimaddr);
 			}
 			/* Read the HBA Host Attention Register */
-			ha_copy = readl(phba->HAregaddr);
+			if (lpfc_readl(phba->HAregaddr, &ha_copy)) {
+				spin_unlock_irqrestore(&phba->hbalock,
+						       drvr_flag);
+				goto out_not_finished;
+			}
 		}
 
 		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
@@ -8194,7 +8242,8 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	piocb->iocb_flag &= ~LPFC_IO_WAKE;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		creg_val = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &creg_val))
+			return IOCB_ERROR;
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
 		readl(phba->HCregaddr); /* flush */
@@ -8236,7 +8285,8 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	}
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		creg_val = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &creg_val))
+			return IOCB_ERROR;
 		creg_val &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
 		readl(phba->HCregaddr); /* flush */
@@ -8387,10 +8437,13 @@ lpfc_sli_eratt_read(struct lpfc_hba *phb
 	uint32_t ha_copy;
 
 	/* Read chip Host Attention (HA) register */
-	ha_copy = readl(phba->HAregaddr);
+	if (lpfc_readl(phba->HAregaddr, &ha_copy))
+		goto unplug_err;
+
 	if (ha_copy & HA_ERATT) {
 		/* Read host status register to retrieve error event */
-		lpfc_sli_read_hs(phba);
+		if (lpfc_sli_read_hs(phba))
+			goto unplug_err;
 
 		/* Check if there is a deferred error condition is active */
 		if ((HS_FFER1 & phba->work_hs) &&
@@ -8409,6 +8462,15 @@ lpfc_sli_eratt_read(struct lpfc_hba *phb
 		return 1;
 	}
 	return 0;
+
+unplug_err:
+	/* Set the driver HS work bitmap */
+	phba->work_hs |= UNPLUG_ERR;
+	/* Set the driver HA work bitmap */
+	phba->work_ha |= HA_ERATT;
+	/* Indicate polling handles this ERATT */
+	phba->hba_flag |= HBA_ERATT_HANDLED;
+	return 1;
 }
 
 /**
@@ -8436,8 +8498,15 @@ lpfc_sli4_eratt_read(struct lpfc_hba *ph
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
 	switch (if_type) {
 	case LPFC_SLI_INTF_IF_TYPE_0:
-		uerr_sta_lo = readl(phba->sli4_hba.u.if_type0.UERRLOregaddr);
-		uerr_sta_hi = readl(phba->sli4_hba.u.if_type0.UERRHIregaddr);
+		if (lpfc_readl(phba->sli4_hba.u.if_type0.UERRLOregaddr,
+			&uerr_sta_lo) ||
+			lpfc_readl(phba->sli4_hba.u.if_type0.UERRHIregaddr,
+			&uerr_sta_hi)) {
+			phba->work_hs |= UNPLUG_ERR;
+			phba->work_ha |= HA_ERATT;
+			phba->hba_flag |= HBA_ERATT_HANDLED;
+			return 1;
+		}
 		if ((~phba->sli4_hba.ue_mask_lo & uerr_sta_lo) ||
 		    (~phba->sli4_hba.ue_mask_hi & uerr_sta_hi)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -8456,9 +8525,15 @@ lpfc_sli4_eratt_read(struct lpfc_hba *ph
 		}
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_2:
-		portstat_reg.word0 =
-			readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
-		portsmphr = readl(phba->sli4_hba.PSMPHRregaddr);
+		if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+			&portstat_reg.word0) ||
+			lpfc_readl(phba->sli4_hba.PSMPHRregaddr,
+			&portsmphr)){
+			phba->work_hs |= UNPLUG_ERR;
+			phba->work_ha |= HA_ERATT;
+			phba->hba_flag |= HBA_ERATT_HANDLED;
+			return 1;
+		}
 		if (bf_get(lpfc_sliport_status_err, &portstat_reg)) {
 			phba->work_status[0] =
 				readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
@@ -8639,7 +8714,8 @@ lpfc_sli_sp_intr_handler(int irq, void *
 			return IRQ_NONE;
 		/* Need to read HA REG for slow-path events */
 		spin_lock_irqsave(&phba->hbalock, iflag);
-		ha_copy = readl(phba->HAregaddr);
+		if (lpfc_readl(phba->HAregaddr, &ha_copy))
+			goto unplug_error;
 		/* If somebody is waiting to handle an eratt don't process it
 		 * here. The brdkill function will do this.
 		 */
@@ -8665,7 +8741,9 @@ lpfc_sli_sp_intr_handler(int irq, void *
 		}
 
 		/* Clear up only attention source related to slow-path */
-		hc_copy = readl(phba->HCregaddr);
+		if (lpfc_readl(phba->HCregaddr, &hc_copy))
+			goto unplug_error;
+
 		writel(hc_copy & ~(HC_MBINT_ENA | HC_R2INT_ENA |
 			HC_LAINT_ENA | HC_ERINT_ENA),
 			phba->HCregaddr);
@@ -8688,7 +8766,8 @@ lpfc_sli_sp_intr_handler(int irq, void *
 				 */
 				spin_lock_irqsave(&phba->hbalock, iflag);
 				phba->sli.sli_flag &= ~LPFC_PROCESS_LA;
-				control = readl(phba->HCregaddr);
+				if (lpfc_readl(phba->HCregaddr, &control))
+					goto unplug_error;
 				control &= ~HC_LAINT_ENA;
 				writel(control, phba->HCregaddr);
 				readl(phba->HCregaddr); /* flush */
@@ -8708,7 +8787,8 @@ lpfc_sli_sp_intr_handler(int irq, void *
 			status >>= (4*LPFC_ELS_RING);
 			if (status & HA_RXMASK) {
 				spin_lock_irqsave(&phba->hbalock, iflag);
-				control = readl(phba->HCregaddr);
+				if (lpfc_readl(phba->HCregaddr, &control))
+					goto unplug_error;
 
 				lpfc_debugfs_slow_ring_trc(phba,
 				"ISR slow ring:   ctl:x%x stat:x%x isrcnt:x%x",
@@ -8741,7 +8821,8 @@ lpfc_sli_sp_intr_handler(int irq, void *
 		}
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		if (work_ha_copy & HA_ERATT) {
-			lpfc_sli_read_hs(phba);
+			if (lpfc_sli_read_hs(phba))
+				goto unplug_error;
 			/*
 			 * Check if there is a deferred error condition
 			 * is active
@@ -8872,6 +8953,9 @@ send_current_mbox:
 		lpfc_worker_wake_up(phba);
 	}
 	return IRQ_HANDLED;
+unplug_error:
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	return IRQ_HANDLED;
 
 } /* lpfc_sli_sp_intr_handler */
 
@@ -8919,7 +9003,8 @@ lpfc_sli_fp_intr_handler(int irq, void *
 		if (lpfc_intr_state_check(phba))
 			return IRQ_NONE;
 		/* Need to read HA REG for FCP ring and other ring events */
-		ha_copy = readl(phba->HAregaddr);
+		if (lpfc_readl(phba->HAregaddr, &ha_copy))
+			return IRQ_HANDLED;
 		/* Clear up only attention source related to fast-path */
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		/*
@@ -9004,7 +9089,11 @@ lpfc_sli_intr_handler(int irq, void *dev
 		return IRQ_NONE;
 
 	spin_lock(&phba->hbalock);
-	phba->ha_copy = readl(phba->HAregaddr);
+	if (lpfc_readl(phba->HAregaddr, &phba->ha_copy)) {
+		spin_unlock(&phba->hbalock);
+		return IRQ_HANDLED;
+	}
+
 	if (unlikely(!phba->ha_copy)) {
 		spin_unlock(&phba->hbalock);
 		return IRQ_NONE;
@@ -9026,7 +9115,10 @@ lpfc_sli_intr_handler(int irq, void *dev
 	}
 
 	/* Clear attention sources except link and error attentions */
-	hc_copy = readl(phba->HCregaddr);
+	if (lpfc_readl(phba->HCregaddr, &hc_copy)) {
+		spin_unlock(&phba->hbalock);
+		return IRQ_HANDLED;
+	}
 	writel(hc_copy & ~(HC_MBINT_ENA | HC_R0INT_ENA | HC_R1INT_ENA
 		| HC_R2INT_ENA | HC_LAINT_ENA | HC_ERINT_ENA),
 		phba->HCregaddr);


