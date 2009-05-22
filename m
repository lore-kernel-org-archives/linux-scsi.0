From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 12/17] lpfc 8.3.2 : Addition of SLI4 Interface - Mailbox
	handling
Date: Fri, 22 May 2009 14:52:52 -0400
Message-ID: <1243018372.7729.61.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42186 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbZEVSwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:54 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIqu16029909
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Mailbox handling

The mailbox commands themselves are the same, or very similar to
their SLI3 counterparts. This patch genericizes mailbox command 
handling and adds support for the new SLI4 mailbox queue.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c      |   47 ++--
 lpfc_crtn.h      |    1 
 lpfc_els.c       |    6 
 lpfc_hbadisc.c   |   22 -
 lpfc_init.c      |   22 +
 lpfc_mbox.c      |  632 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 lpfc_nportdisc.c |   13 -
 lpfc_sli.c       |  505 +++++++++++++++++++++++++++++++++++++++----
 8 files changed, 1101 insertions(+), 147 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 13:16:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 13:18:37.000000000 -0400
@@ -507,12 +507,14 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 		return -ENOMEM;
 
 	memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
-	pmboxq->mb.mbxCommand = MBX_DOWN_LINK;
-	pmboxq->mb.mbxOwner = OWN_HOST;
+	pmboxq->u.mb.mbxCommand = MBX_DOWN_LINK;
+	pmboxq->u.mb.mbxOwner = OWN_HOST;
 
 	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, LPFC_MBOX_TMO * 2);
 
-	if ((mbxstatus == MBX_SUCCESS) && (pmboxq->mb.mbxStatus == 0)) {
+	if ((mbxstatus == MBX_SUCCESS) &&
+	    (pmboxq->u.mb.mbxStatus == 0 ||
+	     pmboxq->u.mb.mbxStatus == MBXERR_LINK_DOWN)) {
 		memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 		lpfc_init_link(phba, pmboxq, phba->cfg_topology,
 			       phba->cfg_link_speed);
@@ -791,7 +793,8 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mrpi, uint32_t *arpi,
 		  uint32_t *mvpi, uint32_t *avpi)
 {
-	struct lpfc_sli   *psli = &phba->sli;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_mbx_read_config *rd_config;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
 	int rc = 0;
@@ -813,7 +816,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		return 0;
 	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 
-	pmb = &pmboxq->mb;
+	pmb = &pmboxq->u.mb;
 	pmb->mbxCommand = MBX_READ_CONFIG;
 	pmb->mbxOwner = OWN_HOST;
 	pmboxq->context1 = NULL;
@@ -3247,7 +3250,7 @@ sysfs_mbox_write(struct kobject *kobj, s
 		}
 	}
 
-	memcpy((uint8_t *) & phba->sysfs_mbox.mbox->mb + off,
+	memcpy((uint8_t *) &phba->sysfs_mbox.mbox->u.mb + off,
 	       buf, count);
 
 	phba->sysfs_mbox.offset = off + count;
@@ -3289,6 +3292,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	int rc;
+	MAILBOX_t *pmb;
 
 	if (off > MAILBOX_CMD_SIZE)
 		return -ERANGE;
@@ -3313,8 +3317,8 @@ sysfs_mbox_read(struct kobject *kobj, st
 	if (off == 0 &&
 	    phba->sysfs_mbox.state  == SMBOX_WRITING &&
 	    phba->sysfs_mbox.offset >= 2 * sizeof(uint32_t)) {
-
-		switch (phba->sysfs_mbox.mbox->mb.mbxCommand) {
+		pmb = &phba->sysfs_mbox.mbox->u.mb;
+		switch (pmb->mbxCommand) {
 			/* Offline only */
 		case MBX_INIT_LINK:
 		case MBX_DOWN_LINK:
@@ -3331,7 +3335,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 			if (!(vport->fc_flag & FC_OFFLINE_MODE)) {
 				printk(KERN_WARNING "mbox_read:Command 0x%x "
 				       "is illegal in on-line state\n",
-				       phba->sysfs_mbox.mbox->mb.mbxCommand);
+				       pmb->mbxCommand);
 				sysfs_mbox_idle(phba);
 				spin_unlock_irq(&phba->hbalock);
 				return -EPERM;
@@ -3367,13 +3371,13 @@ sysfs_mbox_read(struct kobject *kobj, st
 		case MBX_CONFIG_PORT:
 		case MBX_RUN_BIU_DIAG:
 			printk(KERN_WARNING "mbox_read: Illegal Command 0x%x\n",
-			       phba->sysfs_mbox.mbox->mb.mbxCommand);
+			       pmb->mbxCommand);
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(&phba->hbalock);
 			return -EPERM;
 		default:
 			printk(KERN_WARNING "mbox_read: Unknown Command 0x%x\n",
-			       phba->sysfs_mbox.mbox->mb.mbxCommand);
+			       pmb->mbxCommand);
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(&phba->hbalock);
 			return -EPERM;
@@ -3383,14 +3387,14 @@ sysfs_mbox_read(struct kobject *kobj, st
 		 * or RESTART mailbox commands until the HBA is restarted.
 		 */
 		if (phba->pport->stopped &&
-		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_DUMP_MEMORY &&
-		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_RESTART &&
-		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_WRITE_VPARMS &&
-		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_WRITE_WWN)
+		    pmb->mbxCommand != MBX_DUMP_MEMORY &&
+		    pmb->mbxCommand != MBX_RESTART &&
+		    pmb->mbxCommand != MBX_WRITE_VPARMS &&
+		    pmb->mbxCommand != MBX_WRITE_WWN)
 			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
 					"1259 mbox: Issued mailbox cmd "
 					"0x%x while in stopped state.\n",
-					phba->sysfs_mbox.mbox->mb.mbxCommand);
+					pmb->mbxCommand);
 
 		phba->sysfs_mbox.mbox->vport = vport;
 
@@ -3416,8 +3420,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 			spin_unlock_irq(&phba->hbalock);
 			rc = lpfc_sli_issue_mbox_wait (phba,
 						       phba->sysfs_mbox.mbox,
-				lpfc_mbox_tmo_val(phba,
-				    phba->sysfs_mbox.mbox->mb.mbxCommand) * HZ);
+				lpfc_mbox_tmo_val(phba, pmb->mbxCommand) * HZ);
 			spin_lock_irq(&phba->hbalock);
 		}
 
@@ -3439,7 +3442,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 		return -EAGAIN;
 	}
 
-	memcpy(buf, (uint8_t *) & phba->sysfs_mbox.mbox->mb + off, count);
+	memcpy(buf, (uint8_t *) &pmb + off, count);
 
 	phba->sysfs_mbox.offset = off + count;
 
@@ -3711,14 +3714,14 @@ lpfc_get_stats(struct Scsi_Host *shost)
 		return NULL;
 	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 
-	pmb = &pmboxq->mb;
+	pmb = &pmboxq->u.mb;
 	pmb->mbxCommand = MBX_READ_STATUS;
 	pmb->mbxOwner = OWN_HOST;
 	pmboxq->context1 = NULL;
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -3817,7 +3820,7 @@ lpfc_reset_stats(struct Scsi_Host *shost
 		return;
 	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 
-	pmb = &pmboxq->mb;
+	pmb = &pmboxq->u.mb;
 	pmb->mbxCommand = MBX_READ_STATUS;
 	pmb->mbxOwner = OWN_HOST;
 	pmb->un.varWords[0] = 0x1; /* reset request */
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-05-22 13:16:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-05-22 13:18:37.000000000 -0400
@@ -209,6 +209,7 @@ void lpfc_sli_release_iocbq(struct lpfc_
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba *, struct lpfc_iocbq *);
 void lpfc_sli_cancel_iocbs(struct lpfc_hba *, struct list_head *, uint32_t,
 			   uint32_t);
+void lpfc_sli_wake_mbox_wait(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void lpfc_reset_barrier(struct lpfc_hba * phba);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:16:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:18:37.000000000 -0400
@@ -4277,7 +4277,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 			lpfc_init_link(phba, mbox,
 				       phba->cfg_topology,
 				       phba->cfg_link_speed);
-			mbox->mb.un.varInitLnk.lipsr_AL_PA = 0;
+			mbox->u.mb.un.varInitLnk.lipsr_AL_PA = 0;
 			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			mbox->vport = vport;
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
@@ -4426,7 +4426,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 	uint16_t xri, status;
 	uint32_t cmdsize;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 
 	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	xri = (uint16_t) ((unsigned long)(pmb->context1));
@@ -5755,7 +5755,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:16:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:18:37.000000000 -0400
@@ -879,7 +879,7 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_sli   *psli = &phba->sli;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	uint32_t control;
 
 	/* Since we don't do discovery right now, turn these off here */
@@ -942,7 +942,7 @@ lpfc_mbx_cmpl_local_config_link(struct l
 {
 	struct lpfc_vport *vport = pmb->vport;
 
-	if (pmb->mb.mbxStatus)
+	if (pmb->u.mb.mbxStatus)
 		goto out;
 
 	mempool_free(pmb, phba->mbox_mem_pool);
@@ -970,7 +970,7 @@ out:
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 			 "0306 CONFIG_LINK mbxStatus error x%x "
 			 "HBA state x%x\n",
-			 pmb->mb.mbxStatus, vport->port_state);
+			 pmb->u.mb.mbxStatus, vport->port_state);
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	lpfc_linkdown(phba);
@@ -1202,7 +1202,7 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	READ_LA_VAR *la;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 
 	/* Unblock ELS traffic */
@@ -1217,7 +1217,7 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 		goto lpfc_mbx_cmpl_read_la_free_mbuf;
 	}
 
-	la = (READ_LA_VAR *) & pmb->mb.un.varReadLA;
+	la = (READ_LA_VAR *) &pmb->u.mb.un.varReadLA;
 
 	memcpy(&phba->alpa_map[0], mp->virt, 128);
 
@@ -1355,7 +1355,7 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 static void
 lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 
@@ -1408,7 +1408,7 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *p
 {
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 
 	switch (mb->mbxStatus) {
 	case 0x0011:
@@ -2279,7 +2279,7 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 
 	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
 	if ((mb = phba->sli.mbox_active)) {
-		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
 			mb->context2 = NULL;
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -2288,7 +2288,7 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
-		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		    (ndlp == (struct lpfc_nodelist *) mb->context2)) {
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
@@ -2970,7 +2970,7 @@ restart_disc:
 		lpfc_linkdown(phba);
 		lpfc_init_link(phba, initlinkmbox, phba->cfg_topology,
 			       phba->cfg_link_speed);
-		initlinkmbox->mb.un.varInitLnk.lipsr_AL_PA = 0;
+		initlinkmbox->u.mb.un.varInitLnk.lipsr_AL_PA = 0;
 		initlinkmbox->vport = vport;
 		initlinkmbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		rc = lpfc_sli_issue_mbox(phba, initlinkmbox, MBX_NOWAIT);
@@ -3069,7 +3069,7 @@ restart_disc:
 void
 lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf   *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 	struct lpfc_vport    *vport = pmb->vport;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:17:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:18:37.000000000 -0400
@@ -108,7 +108,7 @@ lpfc_config_port_prep(struct lpfc_hba *p
 		return -ENOMEM;
 	}
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	phba->link_state = LPFC_INIT_MBX_CMDS;
 
 	if (lpfc_is_LC_HBA(phba->pcidev->device)) {
@@ -221,6 +221,11 @@ lpfc_config_port_prep(struct lpfc_hba *p
 					mb->mbxCommand, mb->mbxStatus);
 			mb->un.varDmp.word_cnt = 0;
 		}
+		/* dump mem may return a zero when finished or we got a
+		 * mailbox error, either way we are done.
+		 */
+		if (mb->un.varDmp.word_cnt == 0)
+			break;
 		if (mb->un.varDmp.word_cnt > DMP_VPD_SIZE - offset)
 			mb->un.varDmp.word_cnt = DMP_VPD_SIZE - offset;
 		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
@@ -249,7 +254,7 @@ out_free_mbox:
 static void
 lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 {
-	if (pmboxq->mb.mbxStatus == MBX_SUCCESS)
+	if (pmboxq->u.mb.mbxStatus == MBX_SUCCESS)
 		phba->temp_sensor_support = 1;
 	else
 		phba->temp_sensor_support = 0;
@@ -276,7 +281,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_
 	/* character array used for decoding dist type. */
 	char dist_char[] = "nabx";
 
-	if (pmboxq->mb.mbxStatus != MBX_SUCCESS) {
+	if (pmboxq->u.mb.mbxStatus != MBX_SUCCESS) {
 		mempool_free(pmboxq, phba->mbox_mem_pool);
 		return;
 	}
@@ -284,7 +289,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_
 	prg = (struct prog_id *) &prog_id_word;
 
 	/* word 7 contain option rom version */
-	prog_id_word = pmboxq->mb.un.varWords[7];
+	prog_id_word = pmboxq->u.mb.un.varWords[7];
 
 	/* Decode the Option rom version word to a readable string */
 	if (prg->dist < 4)
@@ -341,7 +346,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 		phba->link_state = LPFC_HBA_ERROR;
 		return -ENOMEM;
 	}
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 
 	/* Get login parameters for NID.  */
 	lpfc_read_sparam(phba, pmb, 0);
@@ -476,17 +481,18 @@ lpfc_config_port_post(struct lpfc_hba *p
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
 					"0352 Config MSI mailbox command "
 					"failed, mbxCmd x%x, mbxStatus x%x\n",
-					pmb->mb.mbxCommand, pmb->mb.mbxStatus);
+					pmb->u.mb.mbxCommand,
+					pmb->u.mb.mbxStatus);
 			mempool_free(pmb, phba->mbox_mem_pool);
 			return -EIO;
 		}
 	}
 
+	spin_lock_irq(&phba->hbalock);
 	/* Initialize ERATT handling flag */
 	phba->hba_flag &= ~HBA_ERATT_HANDLED;
 
 	/* Enable appropriate host interrupts */
-	spin_lock_irq(&phba->hbalock);
 	status = readl(phba->HCregaddr);
 	status |= HC_MBINT_ENA | HC_ERINT_ENA | HC_LAINT_ENA;
 	if (psli->num_rings > 0)
@@ -2201,7 +2207,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	lpfc_sli_flush_mbox_queue(phba);
+	lpfc_sli_mbox_sys_shutdown(phba);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-05-22 13:16:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2009-05-22 13:18:37.000000000 -0400
@@ -60,7 +60,7 @@ lpfc_dump_mem(struct lpfc_hba * phba, LP
 	MAILBOX_t *mb;
 	void *ctx;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	ctx = pmb->context2;
 
 	/* Setup to dump VPD region */
@@ -92,7 +92,7 @@ lpfc_dump_wakeup_param(struct lpfc_hba *
 	MAILBOX_t *mb;
 	void *ctx;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	/* Save context so that we can restore after memset */
 	ctx = pmb->context2;
 
@@ -127,7 +127,7 @@ lpfc_read_nv(struct lpfc_hba * phba, LPF
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_READ_NV;
 	mb->mbxOwner = OWN_HOST;
@@ -153,7 +153,7 @@ lpfc_config_async(struct lpfc_hba * phba
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_ASYNCEVT_ENABLE;
 	mb->un.varCfgAsyncEvent.ring = ring;
@@ -179,7 +179,7 @@ lpfc_heart_beat(struct lpfc_hba * phba, 
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_HEARTBEAT;
 	mb->mbxOwner = OWN_HOST;
@@ -213,7 +213,7 @@ lpfc_read_la(struct lpfc_hba * phba, LPF
 	struct lpfc_sli *psli;
 
 	psli = &phba->sli;
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	INIT_LIST_HEAD(&mp->list);
@@ -250,7 +250,7 @@ lpfc_clear_la(struct lpfc_hba * phba, LP
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->un.varClearLA.eventTag = phba->fc_eventTag;
@@ -277,7 +277,7 @@ void
 lpfc_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
 	struct lpfc_vport  *vport = phba->pport;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	/* NEW_FEATURE
@@ -323,7 +323,7 @@ lpfc_config_link(struct lpfc_hba * phba,
 int
 lpfc_config_msi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	uint32_t attentionConditions[2];
 
 	/* Sanity check */
@@ -407,7 +407,7 @@ lpfc_init_link(struct lpfc_hba * phba,
 	struct lpfc_sli *psli;
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	psli = &phba->sli;
@@ -494,7 +494,7 @@ lpfc_read_sparam(struct lpfc_hba *phba, 
 	struct lpfc_sli *psli;
 
 	psli = &phba->sli;
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->mbxOwner = OWN_HOST;
@@ -517,7 +517,7 @@ lpfc_read_sparam(struct lpfc_hba *phba, 
 	mb->un.varRdSparm.un.sp64.tus.f.bdeSize = sizeof (struct serv_parm);
 	mb->un.varRdSparm.un.sp64.addrHigh = putPaddrHigh(mp->phys);
 	mb->un.varRdSparm.un.sp64.addrLow = putPaddrLow(mp->phys);
-	mb->un.varRdSparm.vpi = vpi;
+	mb->un.varRdSparm.vpi = vpi + phba->vpi_base;
 
 	/* save address for completion */
 	pmb->context1 = mp;
@@ -546,10 +546,12 @@ lpfc_unreg_did(struct lpfc_hba * phba, u
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->un.varUnregDID.did = did;
+	if (vpi != 0xffff)
+		vpi += phba->vpi_base;
 	mb->un.varUnregDID.vpi = vpi;
 
 	mb->mbxCommand = MBX_UNREG_D_ID;
@@ -575,7 +577,7 @@ lpfc_read_config(struct lpfc_hba * phba,
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->mbxCommand = MBX_READ_CONFIG;
@@ -600,7 +602,7 @@ lpfc_read_lnk_stat(struct lpfc_hba * phb
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->mbxCommand = MBX_READ_LNK_STAT;
@@ -609,7 +611,7 @@ lpfc_read_lnk_stat(struct lpfc_hba * phb
 }
 
 /**
- * lpfc_reg_login - Prepare a mailbox command for registering remote login
+ * lpfc_reg_rpi - Prepare a mailbox command for registering remote login
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @did: remote port identifier.
@@ -633,17 +635,23 @@ lpfc_read_lnk_stat(struct lpfc_hba * phb
  *    1 - DMA memory allocation failed
  **/
 int
-lpfc_reg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
+lpfc_reg_rpi(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
 	       uint8_t *param, LPFC_MBOXQ_t *pmb, uint32_t flag)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	uint8_t *sparam;
 	struct lpfc_dmabuf *mp;
 
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->un.varRegLogin.rpi = 0;
-	mb->un.varRegLogin.vpi = vpi;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		mb->un.varRegLogin.rpi = lpfc_sli4_alloc_rpi(phba);
+		if (mb->un.varRegLogin.rpi == LPFC_RPI_ALLOC_ERROR)
+			return 1;
+	}
+
+	mb->un.varRegLogin.vpi = vpi + phba->vpi_base;
 	mb->un.varRegLogin.did = did;
 	mb->un.varWords[30] = flag;	/* Set flag to issue action on cmpl */
 
@@ -699,15 +707,16 @@ lpfc_unreg_login(struct lpfc_hba *phba, 
 {
 	MAILBOX_t *mb;
 
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->un.varUnregLogin.rpi = (uint16_t) rpi;
 	mb->un.varUnregLogin.rsvd1 = 0;
-	mb->un.varUnregLogin.vpi = vpi;
+	mb->un.varUnregLogin.vpi = vpi + phba->vpi_base;
 
 	mb->mbxCommand = MBX_UNREG_LOGIN;
 	mb->mbxOwner = OWN_HOST;
+
 	return;
 }
 
@@ -727,15 +736,15 @@ lpfc_unreg_login(struct lpfc_hba *phba, 
  * This routine prepares the mailbox command for registering a virtual N_Port.
  **/
 void
-lpfc_reg_vpi(struct lpfc_hba *phba, uint16_t vpi, uint32_t sid,
-	     LPFC_MBOXQ_t *pmb)
+lpfc_reg_vpi(struct lpfc_vport *vport, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
-	mb->un.varRegVpi.vpi = vpi;
-	mb->un.varRegVpi.sid = sid;
+	mb->un.varRegVpi.vpi = vport->vpi + vport->phba->vpi_base;
+	mb->un.varRegVpi.sid = vport->fc_myDID;
+	mb->un.varRegVpi.vfi = vport->vfi + vport->phba->vfi_base;
 
 	mb->mbxCommand = MBX_REG_VPI;
 	mb->mbxOwner = OWN_HOST;
@@ -762,10 +771,10 @@ lpfc_reg_vpi(struct lpfc_hba *phba, uint
 void
 lpfc_unreg_vpi(struct lpfc_hba *phba, uint16_t vpi, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
-	mb->un.varUnregVpi.vpi = vpi;
+	mb->un.varUnregVpi.vpi = vpi + phba->vpi_base;
 
 	mb->mbxCommand = MBX_UNREG_VPI;
 	mb->mbxOwner = OWN_HOST;
@@ -854,7 +863,7 @@ lpfc_config_pcb_setup(struct lpfc_hba * 
 void
 lpfc_read_rev(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 	mb->un.varRdRev.cv = 1;
 	mb->un.varRdRev.v3req = 1; /* Request SLI3 info */
@@ -947,7 +956,7 @@ lpfc_config_hbq(struct lpfc_hba *phba, u
 		uint32_t hbq_entry_index, LPFC_MBOXQ_t *pmb)
 {
 	int i;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct config_hbq_var *hbqmb = &mb->un.varCfgHbq;
 
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
@@ -1022,7 +1031,7 @@ void
 lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 {
 	int i;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 
@@ -1077,7 +1086,7 @@ void
 lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	MAILBOX_t __iomem *mb_slim = (MAILBOX_t __iomem *) phba->MBslimaddr;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	dma_addr_t pdma_addr;
 	uint32_t bar_low, bar_high;
 	size_t offset;
@@ -1101,21 +1110,22 @@ lpfc_config_port(struct lpfc_hba *phba, 
 
 	/* If HBA supports SLI=3 ask for it */
 
-	if (phba->sli_rev == 3 && phba->vpd.sli3Feat.cerbm) {
+	if (phba->sli_rev == LPFC_SLI_REV3 && phba->vpd.sli3Feat.cerbm) {
 		if (phba->cfg_enable_bg)
 			mb->un.varCfgPort.cbg = 1; /* configure BlockGuard */
+		mb->un.varCfgPort.cdss = 1; /* Configure Security */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
 		mb->un.varCfgPort.cinb = 1; /* Interrupt Notification Block */
 		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
-			mb->un.varCfgPort.max_vpi = phba->max_vpi;
+			mb->un.varCfgPort.max_vpi = LPFC_MAX_VPI;
 			mb->un.varCfgPort.cmv = 1;
 		} else
 			mb->un.varCfgPort.max_vpi = phba->max_vpi = 0;
 	} else
-		phba->sli_rev = 2;
+		phba->sli_rev = LPFC_SLI_REV2;
 	mb->un.varCfgPort.sli_mode = phba->sli_rev;
 
 	/* Now setup pcb */
@@ -1247,7 +1257,7 @@ lpfc_config_port(struct lpfc_hba *phba, 
 void
 lpfc_kill_board(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_KILL_BOARD;
@@ -1307,29 +1317,98 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 }
 
 /**
+ * __lpfc_mbox_cmpl_put - Put mailbox cmd into mailbox cmd complete list
+ * @phba: pointer to lpfc hba data structure.
+ * @mbq: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine put the completed mailbox command into the mailbox command
+ * complete list. This is the unlocked version of the routine. The mailbox
+ * complete list is used by the driver worker thread to process mailbox
+ * complete callback functions outside the driver interrupt handler.
+ **/
+void
+__lpfc_mbox_cmpl_put(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbq)
+{
+	list_add_tail(&mbq->list, &phba->sli.mboxq_cmpl);
+}
+
+/**
  * lpfc_mbox_cmpl_put - Put mailbox command into mailbox command complete list
  * @phba: pointer to lpfc hba data structure.
  * @mbq: pointer to the driver internal queue element for mailbox command.
  *
  * This routine put the completed mailbox command into the mailbox command
- * complete list. This routine is called from driver interrupt handler
- * context.The mailbox complete list is used by the driver worker thread
- * to process mailbox complete callback functions outside the driver interrupt
- * handler.
+ * complete list. This is the locked version of the routine. The mailbox
+ * complete list is used by the driver worker thread to process mailbox
+ * complete callback functions outside the driver interrupt handler.
  **/
 void
-lpfc_mbox_cmpl_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
+lpfc_mbox_cmpl_put(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbq)
 {
 	unsigned long iflag;
 
 	/* This function expects to be called from interrupt context */
 	spin_lock_irqsave(&phba->hbalock, iflag);
-	list_add_tail(&mbq->list, &phba->sli.mboxq_cmpl);
+	__lpfc_mbox_cmpl_put(phba, mbq);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
 
 /**
+ * lpfc_mbox_cmd_check - Check the validality of a mailbox command
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine is to check whether a mailbox command is valid to be issued.
+ * This check will be performed by both the mailbox issue API when a client
+ * is to issue a mailbox command to the mailbox transport.
+ *
+ * Return 0 - pass the check, -ENODEV - fail the check
+ **/
+int
+lpfc_mbox_cmd_check(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	/* Mailbox command that have a completion handler must also have a
+	 * vport specified.
+	 */
+	if (mboxq->mbox_cmpl && mboxq->mbox_cmpl != lpfc_sli_def_mbox_cmpl &&
+	    mboxq->mbox_cmpl != lpfc_sli_wake_mbox_wait) {
+		if (!mboxq->vport) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_VPORT,
+					"1814 Mbox x%x failed, no vport\n",
+					mboxq->u.mb.mbxCommand);
+			dump_stack();
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
+/**
+ * lpfc_mbox_dev_check - Check the device state for issuing a mailbox command
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to check whether the HBA device is ready for posting a
+ * mailbox command. It is used by the mailbox transport API at the time the
+ * to post a mailbox command to the device.
+ *
+ * Return 0 - pass the check, -ENODEV - fail the check
+ **/
+int
+lpfc_mbox_dev_check(struct lpfc_hba *phba)
+{
+	/* If the PCI channel is in offline state, do not issue mbox */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return -ENODEV;
+
+	/* If the HBA is in error state, do not issue mbox */
+	if (phba->link_state == LPFC_HBA_ERROR)
+		return -ENODEV;
+
+	return 0;
+}
+
+/**
  * lpfc_mbox_tmo_val - Retrieve mailbox command timeout value
  * @phba: pointer to lpfc hba data structure.
  * @cmd: mailbox command code.
@@ -1352,6 +1431,475 @@ lpfc_mbox_tmo_val(struct lpfc_hba *phba,
 	case MBX_WRITE_WWN:     /* 0x98 */
 	case MBX_LOAD_EXP_ROM:	/* 0x9C */
 		return LPFC_MBOX_TMO_FLASH_CMD;
+	case MBX_SLI4_CONFIG:	/* 0x9b */
+		return LPFC_MBOX_SLI4_CONFIG_TMO;
 	}
 	return LPFC_MBOX_TMO;
 }
+
+/**
+ * lpfc_sli4_mbx_sge_set - Set a sge entry in non-embedded mailbox command
+ * @mbox: pointer to lpfc mbox command.
+ * @sgentry: sge entry index.
+ * @phyaddr: physical address for the sge
+ * @length: Length of the sge.
+ *
+ * This routine sets up an entry in the non-embedded mailbox command at the sge
+ * index location.
+ **/
+void
+lpfc_sli4_mbx_sge_set(struct lpfcMboxq *mbox, uint32_t sgentry,
+		      dma_addr_t phyaddr, uint32_t length)
+{
+	struct lpfc_mbx_nembed_cmd *nembed_sge;
+
+	nembed_sge = (struct lpfc_mbx_nembed_cmd *)
+				&mbox->u.mqe.un.nembed_cmd;
+	nembed_sge->sge[sgentry].pa_lo = putPaddrLow(phyaddr);
+	nembed_sge->sge[sgentry].pa_hi = putPaddrHigh(phyaddr);
+	nembed_sge->sge[sgentry].length = length;
+}
+
+/**
+ * lpfc_sli4_mbx_sge_get - Get a sge entry from non-embedded mailbox command
+ * @mbox: pointer to lpfc mbox command.
+ * @sgentry: sge entry index.
+ *
+ * This routine gets an entry from the non-embedded mailbox command at the sge
+ * index location.
+ **/
+void
+lpfc_sli4_mbx_sge_get(struct lpfcMboxq *mbox, uint32_t sgentry,
+		      struct lpfc_mbx_sge *sge)
+{
+	struct lpfc_mbx_nembed_cmd *nembed_sge;
+
+	nembed_sge = (struct lpfc_mbx_nembed_cmd *)
+				&mbox->u.mqe.un.nembed_cmd;
+	sge->pa_lo = nembed_sge->sge[sgentry].pa_lo;
+	sge->pa_hi = nembed_sge->sge[sgentry].pa_hi;
+	sge->length = nembed_sge->sge[sgentry].length;
+}
+
+/**
+ * lpfc_sli4_mbox_cmd_free - Free a sli4 mailbox command
+ * @phba: pointer to lpfc hba data structure.
+ * @mbox: pointer to lpfc mbox command.
+ *
+ * This routine frees SLI4 specific mailbox command for sending IOCTL command.
+ **/
+void
+lpfc_sli4_mbox_cmd_free(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
+{
+	struct lpfc_mbx_sli4_config *sli4_cfg;
+	struct lpfc_mbx_sge sge;
+	dma_addr_t phyaddr;
+	uint32_t sgecount, sgentry;
+
+	sli4_cfg = &mbox->u.mqe.un.sli4_config;
+
+	/* For embedded mbox command, just free the mbox command */
+	if (bf_get(lpfc_mbox_hdr_emb, &sli4_cfg->header.cfg_mhdr)) {
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return;
+	}
+
+	/* For non-embedded mbox command, we need to free the pages first */
+	sgecount = bf_get(lpfc_mbox_hdr_sge_cnt, &sli4_cfg->header.cfg_mhdr);
+	/* There is nothing we can do if there is no sge address array */
+	if (unlikely(!mbox->sge_array)) {
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return;
+	}
+	/* Each non-embedded DMA memory was allocated in the length of a page */
+	for (sgentry = 0; sgentry < sgecount; sgentry++) {
+		lpfc_sli4_mbx_sge_get(mbox, sgentry, &sge);
+		phyaddr = getPaddr(sge.pa_hi, sge.pa_lo);
+		dma_free_coherent(&phba->pcidev->dev, PAGE_SIZE,
+				  mbox->sge_array->addr[sgentry], phyaddr);
+	}
+	/* Free the sge address array memory */
+	kfree(mbox->sge_array);
+	/* Finally, free the mailbox command itself */
+	mempool_free(mbox, phba->mbox_mem_pool);
+}
+
+/**
+ * lpfc_sli4_config - Initialize the  SLI4 Config Mailbox command
+ * @phba: pointer to lpfc hba data structure.
+ * @mbox: pointer to lpfc mbox command.
+ * @subsystem: The sli4 config sub mailbox subsystem.
+ * @opcode: The sli4 config sub mailbox command opcode.
+ * @length: Length of the sli4 config mailbox command.
+ *
+ * This routine sets up the header fields of SLI4 specific mailbox command
+ * for sending IOCTL command.
+ *
+ * Return: the actual length of the mbox command allocated (mostly useful
+ *         for none embedded mailbox command).
+ **/
+int
+lpfc_sli4_config(struct lpfc_hba *phba, struct lpfcMboxq *mbox,
+		 uint8_t subsystem, uint8_t opcode, uint32_t length, bool emb)
+{
+	struct lpfc_mbx_sli4_config *sli4_config;
+	union lpfc_sli4_cfg_shdr *cfg_shdr = NULL;
+	uint32_t alloc_len;
+	uint32_t resid_len;
+	uint32_t pagen, pcount;
+	void *viraddr;
+	dma_addr_t phyaddr;
+
+	/* Set up SLI4 mailbox command header fields */
+	memset(mbox, 0, sizeof(*mbox));
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_SLI4_CONFIG);
+
+	/* Set up SLI4 ioctl command header fields */
+	sli4_config = &mbox->u.mqe.un.sli4_config;
+
+	/* Setup for the embedded mbox command */
+	if (emb) {
+		/* Set up main header fields */
+		bf_set(lpfc_mbox_hdr_emb, &sli4_config->header.cfg_mhdr, 1);
+		sli4_config->header.cfg_mhdr.payload_length =
+					LPFC_MBX_CMD_HDR_LENGTH + length;
+		/* Set up sub-header fields following main header */
+		bf_set(lpfc_mbox_hdr_opcode,
+			&sli4_config->header.cfg_shdr.request, opcode);
+		bf_set(lpfc_mbox_hdr_subsystem,
+			&sli4_config->header.cfg_shdr.request, subsystem);
+		sli4_config->header.cfg_shdr.request.request_length = length;
+		return length;
+	}
+
+	/* Setup for the none-embedded mbox command */
+	pcount = (PAGE_ALIGN(length))/PAGE_SIZE;
+	pcount = (pcount > LPFC_SLI4_MBX_SGE_MAX_PAGES) ?
+				LPFC_SLI4_MBX_SGE_MAX_PAGES : pcount;
+	/* Allocate record for keeping SGE virtual addresses */
+	mbox->sge_array = kmalloc(sizeof(struct lpfc_mbx_nembed_sge_virt),
+				  GFP_KERNEL);
+	if (!mbox->sge_array)
+		return 0;
+
+	for (pagen = 0, alloc_len = 0; pagen < pcount; pagen++) {
+		/* The DMA memory is always allocated in the length of a
+		 * page even though the last SGE might not fill up to a
+		 * page, this is used as a priori size of PAGE_SIZE for
+		 * the later DMA memory free.
+		 */
+		viraddr = dma_alloc_coherent(&phba->pcidev->dev, PAGE_SIZE,
+					     &phyaddr, GFP_KERNEL);
+		/* In case of malloc fails, proceed with whatever we have */
+		if (!viraddr)
+			break;
+		mbox->sge_array->addr[pagen] = viraddr;
+		/* Keep the first page for later sub-header construction */
+		if (pagen == 0)
+			cfg_shdr = (union lpfc_sli4_cfg_shdr *)viraddr;
+		resid_len = length - alloc_len;
+		if (resid_len > PAGE_SIZE) {
+			lpfc_sli4_mbx_sge_set(mbox, pagen, phyaddr,
+					      PAGE_SIZE);
+			alloc_len += PAGE_SIZE;
+		} else {
+			lpfc_sli4_mbx_sge_set(mbox, pagen, phyaddr,
+					      resid_len);
+			alloc_len = length;
+		}
+	}
+
+	/* Set up main header fields in mailbox command */
+	sli4_config->header.cfg_mhdr.payload_length = alloc_len;
+	bf_set(lpfc_mbox_hdr_sge_cnt, &sli4_config->header.cfg_mhdr, pagen);
+
+	/* Set up sub-header fields into the first page */
+	if (pagen > 0) {
+		bf_set(lpfc_mbox_hdr_opcode, &cfg_shdr->request, opcode);
+		bf_set(lpfc_mbox_hdr_subsystem, &cfg_shdr->request, subsystem);
+		cfg_shdr->request.request_length =
+				alloc_len - sizeof(union  lpfc_sli4_cfg_shdr);
+	}
+	/* The sub-header is in DMA memory, which needs endian converstion */
+	lpfc_sli_pcimem_bcopy(cfg_shdr, cfg_shdr,
+			      sizeof(union  lpfc_sli4_cfg_shdr));
+
+	return alloc_len;
+}
+
+/**
+ * lpfc_sli4_mbox_opcode_get - Get the opcode from a sli4 mailbox command
+ * @phba: pointer to lpfc hba data structure.
+ * @mbox: pointer to lpfc mbox command.
+ *
+ * This routine gets the opcode from a SLI4 specific mailbox command for
+ * sending IOCTL command. If the mailbox command is not MBX_SLI4_CONFIG
+ * (0x9B) or if the IOCTL sub-header is not present, opcode 0x0 shall be
+ * returned.
+ **/
+uint8_t
+lpfc_sli4_mbox_opcode_get(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
+{
+	struct lpfc_mbx_sli4_config *sli4_cfg;
+	union lpfc_sli4_cfg_shdr *cfg_shdr;
+
+	if (mbox->u.mb.mbxCommand != MBX_SLI4_CONFIG)
+		return 0;
+	sli4_cfg = &mbox->u.mqe.un.sli4_config;
+
+	/* For embedded mbox command, get opcode from embedded sub-header*/
+	if (bf_get(lpfc_mbox_hdr_emb, &sli4_cfg->header.cfg_mhdr)) {
+		cfg_shdr = &mbox->u.mqe.un.sli4_config.header.cfg_shdr;
+		return bf_get(lpfc_mbox_hdr_opcode, &cfg_shdr->request);
+	}
+
+	/* For non-embedded mbox command, get opcode from first dma page */
+	if (unlikely(!mbox->sge_array))
+		return 0;
+	cfg_shdr = (union lpfc_sli4_cfg_shdr *)mbox->sge_array->addr[0];
+	return bf_get(lpfc_mbox_hdr_opcode, &cfg_shdr->request);
+}
+
+/**
+ * lpfc_request_features: Configure SLI4 REQUEST_FEATURES mailbox
+ * @mboxq: pointer to lpfc mbox command.
+ *
+ * This routine sets up the mailbox for an SLI4 REQUEST_FEATURES
+ * mailbox command.
+ **/
+void
+lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
+{
+	/* Set up SLI4 mailbox command header fields */
+	memset(mboxq, 0, sizeof(LPFC_MBOXQ_t));
+	bf_set(lpfc_mqe_command, &mboxq->u.mqe, MBX_SLI4_REQ_FTRS);
+
+	/* Set up host requested features. */
+	bf_set(lpfc_mbx_rq_ftr_rq_fcpi, &mboxq->u.mqe.un.req_ftrs, 1);
+
+	/* Virtual fabrics and FIPs are not supported yet. */
+	bf_set(lpfc_mbx_rq_ftr_rq_ifip, &mboxq->u.mqe.un.req_ftrs, 0);
+
+	/* Enable DIF (block guard) only if configured to do so. */
+	if (phba->cfg_enable_bg)
+		bf_set(lpfc_mbx_rq_ftr_rq_dif, &mboxq->u.mqe.un.req_ftrs, 1);
+
+	/* Enable NPIV only if configured to do so. */
+	if (phba->max_vpi && phba->cfg_enable_npiv)
+		bf_set(lpfc_mbx_rq_ftr_rq_npiv, &mboxq->u.mqe.un.req_ftrs, 1);
+
+	return;
+}
+
+/**
+ * lpfc_init_vfi - Initialize the INIT_VFI mailbox command
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @vport: Vport associated with the VF.
+ *
+ * This routine initializes @mbox to all zeros and then fills in the mailbox
+ * fields from @vport. INIT_VFI configures virtual fabrics identified by VFI
+ * in the context of an FCF. The driver issues this command to setup a VFI
+ * before issuing a FLOGI to login to the VSAN. The driver should also issue a
+ * REG_VFI after a successful VSAN login.
+ **/
+void
+lpfc_init_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport)
+{
+	struct lpfc_mbx_init_vfi *init_vfi;
+
+	memset(mbox, 0, sizeof(*mbox));
+	init_vfi = &mbox->u.mqe.un.init_vfi;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_INIT_VFI);
+	bf_set(lpfc_init_vfi_vr, init_vfi, 1);
+	bf_set(lpfc_init_vfi_vt, init_vfi, 1);
+	bf_set(lpfc_init_vfi_vfi, init_vfi, vport->vfi + vport->phba->vfi_base);
+	bf_set(lpfc_init_vfi_fcfi, init_vfi, vport->phba->fcf.fcfi);
+}
+
+/**
+ * lpfc_reg_vfi - Initialize the REG_VFI mailbox command
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @vport: vport associated with the VF.
+ * @phys: BDE DMA bus address used to send the service parameters to the HBA.
+ *
+ * This routine initializes @mbox to all zeros and then fills in the mailbox
+ * fields from @vport, and uses @buf as a DMAable buffer to send the vport's
+ * fc service parameters to the HBA for this VFI. REG_VFI configures virtual
+ * fabrics identified by VFI in the context of an FCF.
+ **/
+void
+lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
+{
+	struct lpfc_mbx_reg_vfi *reg_vfi;
+
+	memset(mbox, 0, sizeof(*mbox));
+	reg_vfi = &mbox->u.mqe.un.reg_vfi;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_VFI);
+	bf_set(lpfc_reg_vfi_vp, reg_vfi, 1);
+	bf_set(lpfc_reg_vfi_vfi, reg_vfi, vport->vfi + vport->phba->vfi_base);
+	bf_set(lpfc_reg_vfi_fcfi, reg_vfi, vport->phba->fcf.fcfi);
+	bf_set(lpfc_reg_vfi_vpi, reg_vfi, vport->vpi + vport->phba->vpi_base);
+	reg_vfi->bde.addrHigh = putPaddrHigh(phys);
+	reg_vfi->bde.addrLow = putPaddrLow(phys);
+	reg_vfi->bde.tus.f.bdeSize = sizeof(vport->fc_sparam);
+	reg_vfi->bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+	bf_set(lpfc_reg_vfi_nport_id, reg_vfi, vport->fc_myDID);
+}
+
+/**
+ * lpfc_init_vpi - Initialize the INIT_VPI mailbox command
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @vpi: VPI to be initialized.
+ *
+ * The INIT_VPI mailbox command supports virtual N_Ports. The driver uses the
+ * command to activate a virtual N_Port. The HBA assigns a MAC address to use
+ * with the virtual N Port.  The SLI Host issues this command before issuing a
+ * FDISC to connect to the Fabric. The SLI Host should issue a REG_VPI after a
+ * successful virtual NPort login.
+ **/
+void
+lpfc_init_vpi(struct lpfcMboxq *mbox, uint16_t vpi)
+{
+	memset(mbox, 0, sizeof(*mbox));
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_INIT_VPI);
+	bf_set(lpfc_init_vpi_vpi, &mbox->u.mqe.un.init_vpi, vpi);
+}
+
+/**
+ * lpfc_unreg_vfi - Initialize the UNREG_VFI mailbox command
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @vfi: VFI to be unregistered.
+ *
+ * The UNREG_VFI mailbox command causes the SLI Host to put a virtual fabric
+ * (logical NPort) into the inactive state. The SLI Host must have logged out
+ * and unregistered all remote N_Ports to abort any activity on the virtual
+ * fabric. The SLI Port posts the mailbox response after marking the virtual
+ * fabric inactive.
+ **/
+void
+lpfc_unreg_vfi(struct lpfcMboxq *mbox, uint16_t vfi)
+{
+	memset(mbox, 0, sizeof(*mbox));
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_UNREG_VFI);
+	bf_set(lpfc_unreg_vfi_vfi, &mbox->u.mqe.un.unreg_vfi, vfi);
+}
+
+/**
+ * lpfc_dump_fcoe_param - Dump config region 23 to get FCoe parameters.
+ * @phba: pointer to the hba structure containing.
+ * @mbox: pointer to lpfc mbox command to initialize.
+ *
+ * This function create a SLI4 dump mailbox command to dump FCoE
+ * parameters stored in region 23.
+ **/
+int
+lpfc_dump_fcoe_param(struct lpfc_hba *phba,
+		struct lpfcMboxq *mbox)
+{
+	struct lpfc_dmabuf *mp = NULL;
+	MAILBOX_t *mb;
+
+	memset(mbox, 0, sizeof(*mbox));
+	mb = &mbox->u.mb;
+
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (mp)
+		mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+
+	if (!mp || !mp->virt) {
+		kfree(mp);
+		/* dump_fcoe_param failed to allocate memory */
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+			"2569 lpfc_dump_fcoe_param: memory"
+			" allocation failed \n");
+		return 1;
+	}
+
+	memset(mp->virt, 0, LPFC_BPL_SIZE);
+	INIT_LIST_HEAD(&mp->list);
+
+	/* save address for completion */
+	mbox->context1 = (uint8_t *) mp;
+
+	mb->mbxCommand = MBX_DUMP_MEMORY;
+	mb->un.varDmp.type = DMP_NV_PARAMS;
+	mb->un.varDmp.region_id = DMP_REGION_FCOEPARAM;
+	mb->un.varDmp.sli4_length = DMP_FCOEPARAM_RGN_SIZE;
+	mb->un.varWords[3] = putPaddrLow(mp->phys);
+	mb->un.varWords[4] = putPaddrHigh(mp->phys);
+	return 0;
+}
+
+/**
+ * lpfc_reg_fcfi - Initialize the REG_FCFI mailbox command
+ * @phba: pointer to the hba structure containing the FCF index and RQ ID.
+ * @mbox: pointer to lpfc mbox command to initialize.
+ *
+ * The REG_FCFI mailbox command supports Fibre Channel Forwarders (FCFs). The
+ * SLI Host uses the command to activate an FCF after it has acquired FCF
+ * information via a READ_FCF mailbox command. This mailbox command also is used
+ * to indicate where received unsolicited frames from this FCF will be sent. By
+ * default this routine will set up the FCF to forward all unsolicited frames
+ * the the RQ ID passed in the @phba. This can be overridden by the caller for
+ * more complicated setups.
+ **/
+void
+lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
+{
+	struct lpfc_mbx_reg_fcfi *reg_fcfi;
+
+	memset(mbox, 0, sizeof(*mbox));
+	reg_fcfi = &mbox->u.mqe.un.reg_fcfi;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_FCFI);
+	bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi, phba->sli4_hba.hdr_rq->queue_id);
+	bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
+	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
+	bf_set(lpfc_reg_fcfi_info_index, reg_fcfi, phba->fcf.fcf_indx);
+	/* reg_fcf addr mode is bit wise inverted value of fcf addr_mode */
+	bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
+		(~phba->fcf.addr_mode) & 0x3);
+	if (phba->fcf.fcf_flag & FCF_VALID_VLAN) {
+		bf_set(lpfc_reg_fcfi_vv, reg_fcfi, 1);
+		bf_set(lpfc_reg_fcfi_vlan_tag, reg_fcfi, phba->fcf.vlan_id);
+	}
+}
+
+/**
+ * lpfc_unreg_fcfi - Initialize the UNREG_FCFI mailbox command
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @fcfi: FCFI to be unregistered.
+ *
+ * The UNREG_FCFI mailbox command supports Fibre Channel Forwarders (FCFs).
+ * The SLI Host uses the command to inactivate an FCFI.
+ **/
+void
+lpfc_unreg_fcfi(struct lpfcMboxq *mbox, uint16_t fcfi)
+{
+	memset(mbox, 0, sizeof(*mbox));
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_UNREG_FCFI);
+	bf_set(lpfc_unreg_fcfi, &mbox->u.mqe.un.unreg_fcfi, fcfi);
+}
+
+/**
+ * lpfc_resume_rpi - Initialize the RESUME_RPI mailbox command
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @ndlp: The nodelist structure that describes the RPI to resume.
+ *
+ * The RESUME_RPI mailbox command is used to restart I/O to an RPI after a
+ * link event.
+ **/
+void
+lpfc_resume_rpi(struct lpfcMboxq *mbox, struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_mbx_resume_rpi *resume_rpi;
+
+	memset(mbox, 0, sizeof(*mbox));
+	resume_rpi = &mbox->u.mqe.un.resume_rpi;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_RESUME_RPI);
+	bf_set(lpfc_resume_rpi_rpi, resume_rpi, ndlp->nlp_rpi);
+	bf_set(lpfc_resume_rpi_vpi, resume_rpi,
+	       ndlp->vport->vpi + ndlp->vport->phba->vpi_base);
+	bf_set(lpfc_resume_rpi_vfi, resume_rpi,
+	       ndlp->vport->vfi + ndlp->vport->phba->vfi_base);
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-05-22 13:16:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-05-22 13:18:37.000000000 -0400
@@ -1192,7 +1192,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 
 	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
 	if ((mb = phba->sli.mbox_active)) {
-		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
 			lpfc_nlp_put(ndlp);
 			mb->context2 = NULL;
@@ -1202,7 +1202,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
-		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
@@ -1253,7 +1253,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	uint32_t did  = mb->un.varWords[1];
 
 	if (mb->mbxStatus) {
@@ -1880,11 +1880,12 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 			    void *arg, uint32_t evt)
 {
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
-	MAILBOX_t    *mb = &pmb->mb;
+	MAILBOX_t    *mb = &pmb->u.mb;
 
-	if (!mb->mbxStatus)
+	if (!mb->mbxStatus) {
 		ndlp->nlp_rpi = mb->un.varWords[0];
-	else {
+		ndlp->nlp_flag |= NLP_RPI_VALID;
+	} else {
 		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
 			lpfc_drop_node(vport, ndlp);
 			return NLP_STE_FREED_NODE;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:37.000000000 -0400
@@ -43,24 +43,7 @@
 #include "lpfc_logmsg.h"
 #include "lpfc_compat.h"
 #include "lpfc_debugfs.h"
-
-/*
- * Define macro to log: Mailbox command x%x cannot issue Data
- * This allows multiple uses of lpfc_msgBlk0311
- * w/o perturbing log msg utility.
- */
-#define LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag) \
-			lpfc_printf_log(phba, \
-				KERN_INFO, \
-				LOG_MBOX | LOG_SLI, \
-				"(%d):0311 Mailbox command x%x cannot " \
-				"issue Data: x%x x%x x%x\n", \
-				pmbox->vport ? pmbox->vport->vpi : 0, \
-				pmbox->mb.mbxCommand,		\
-				phba->pport->port_state,	\
-				psli->sli_flag,	\
-				flag)
-
+#include "lpfc_vport.h"
 
 /* There are only four IOCB completion types. */
 typedef enum _lpfc_iocb_type {
@@ -843,7 +826,7 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
 	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb)
 		return -ENOMEM;
-	pmbox = &pmb->mb;
+	pmbox = &pmb->u.mb;
 	phba->link_state = LPFC_INIT_MBX_CMDS;
 	for (i = 0; i < psli->num_rings; i++) {
 		lpfc_config_ring(phba, i, pmb);
@@ -1652,6 +1635,15 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_HEARTBEAT:
 	case MBX_PORT_CAPABILITIES:
 	case MBX_PORT_IOV_CONTROL:
+	case MBX_SLI4_CONFIG:
+	case MBX_SLI4_REQ_FTRS:
+	case MBX_REG_FCFI:
+	case MBX_UNREG_FCFI:
+	case MBX_REG_VFI:
+	case MBX_UNREG_VFI:
+	case MBX_INIT_VPI:
+	case MBX_INIT_VFI:
+	case MBX_RESUME_RPI:
 		ret = mbxCommand;
 		break;
 	default:
@@ -1672,7 +1664,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
  * will wake up thread waiting on the wait queue pointed by context1
  * of the mailbox.
  **/
-static void
+void
 lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	wait_queue_head_t *pdone_q;
@@ -1706,7 +1698,7 @@ void
 lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_dmabuf *mp;
-	uint16_t rpi;
+	uint16_t rpi, vpi;
 	int rc;
 
 	mp = (struct lpfc_dmabuf *) (pmb->context1);
@@ -1716,24 +1708,30 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 		kfree(mp);
 	}
 
+	if ((pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) &&
+	    (phba->sli_rev == LPFC_SLI_REV4))
+		lpfc_sli4_free_rpi(phba, pmb->u.mb.un.varUnregLogin.rpi);
+
 	/*
 	 * If a REG_LOGIN succeeded  after node is destroyed or node
 	 * is in re-discovery driver need to cleanup the RPI.
 	 */
 	if (!(phba->pport->load_flag & FC_UNLOADING) &&
-	    pmb->mb.mbxCommand == MBX_REG_LOGIN64 &&
-	    !pmb->mb.mbxStatus) {
-
-		rpi = pmb->mb.un.varWords[0];
-		lpfc_unreg_login(phba, pmb->mb.un.varRegLogin.vpi, rpi, pmb);
+	    pmb->u.mb.mbxCommand == MBX_REG_LOGIN64 &&
+	    !pmb->u.mb.mbxStatus) {
+		rpi = pmb->u.mb.un.varWords[0];
+		vpi = pmb->u.mb.un.varRegLogin.vpi - phba->vpi_base;
+		lpfc_unreg_login(phba, vpi, rpi, pmb);
 		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
 		if (rc != MBX_NOT_FINISHED)
 			return;
 	}
 
-	mempool_free(pmb, phba->mbox_mem_pool);
-	return;
+	if (bf_get(lpfc_mqe_command, &pmb->u.mqe) == MBX_SLI4_CONFIG)
+		lpfc_sli4_mbox_cmd_free(phba, pmb);
+	else
+		mempool_free(pmb, phba->mbox_mem_pool);
 }
 
 /**
@@ -1770,7 +1768,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 		if (pmb == NULL)
 			break;
 
-		pmbox = &pmb->mb;
+		pmbox = &pmb->u.mb;
 
 		if (pmbox->mbxCommand != MBX_HEARTBEAT) {
 			if (pmb->vport) {
@@ -1799,9 +1797,10 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 			/* Unknow mailbox command compl */
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 					"(%d):0323 Unknown Mailbox command "
-					"%x Cmpl\n",
+					"x%x (x%x) Cmpl\n",
 					pmb->vport ? pmb->vport->vpi : 0,
-					pmbox->mbxCommand);
+					pmbox->mbxCommand,
+					lpfc_sli4_mbox_opcode_get(phba, pmb));
 			phba->link_state = LPFC_HBA_ERROR;
 			phba->work_hs = HS_FFER3;
 			lpfc_handle_eratt(phba);
@@ -1816,29 +1815,29 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 						LOG_MBOX | LOG_SLI,
 						"(%d):0305 Mbox cmd cmpl "
 						"error - RETRYing Data: x%x "
-						"x%x x%x x%x\n",
+						"(x%x) x%x x%x x%x\n",
 						pmb->vport ? pmb->vport->vpi :0,
 						pmbox->mbxCommand,
+						lpfc_sli4_mbox_opcode_get(phba,
+									  pmb),
 						pmbox->mbxStatus,
 						pmbox->un.varWords[0],
 						pmb->vport->port_state);
 				pmbox->mbxStatus = 0;
 				pmbox->mbxOwner = OWN_HOST;
-				spin_lock_irq(&phba->hbalock);
-				phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-				spin_unlock_irq(&phba->hbalock);
 				rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-				if (rc == MBX_SUCCESS)
+				if (rc != MBX_NOT_FINISHED)
 					continue;
 			}
 		}
 
 		/* Mailbox cmd <cmd> Cmpl <cmpl> */
 		lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-				"(%d):0307 Mailbox cmd x%x Cmpl x%p "
+				"(%d):0307 Mailbox cmd x%x (x%x) Cmpl x%p "
 				"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x\n",
 				pmb->vport ? pmb->vport->vpi : 0,
 				pmbox->mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, pmb),
 				pmb->mbox_cmpl,
 				*((uint32_t *) pmbox),
 				pmbox->un.varWords[0],
@@ -3377,10 +3376,10 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 	}
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	psli->mbox_active = NULL;
 	phba->link_flag &= ~LS_IGNORE_ERATT;
 	spin_unlock_irq(&phba->hbalock);
 
-	psli->mbox_active = NULL;
 	lpfc_hba_down_post(phba);
 	phba->link_state = LPFC_HBA_ERROR;
 
@@ -3790,7 +3789,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 	if (!pmb)
 		return -ENOMEM;
 
-	pmbox = &pmb->mb;
+	pmbox = &pmb->u.mb;
 
 	/* Initialize the struct lpfc_sli_hbq structure for each hbq */
 	phba->link_state = LPFC_INIT_MBX_CMDS;
@@ -3917,33 +3916,43 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0442 Adapter failed to init, mbxCmd x%x "
 				"CONFIG_PORT, mbxStatus x%x Data: x%x\n",
-				pmb->mb.mbxCommand, pmb->mb.mbxStatus, 0);
+				pmb->u.mb.mbxCommand, pmb->u.mb.mbxStatus, 0);
 			spin_lock_irq(&phba->hbalock);
-			phba->sli.sli_flag &= ~LPFC_SLI2_ACTIVE;
+			phba->sli.sli_flag &= ~LPFC_SLI_ACTIVE;
 			spin_unlock_irq(&phba->hbalock);
 			rc = -ENXIO;
-		} else
+		} else {
+			/* Allow asynchronous mailbox command to go through */
+			spin_lock_irq(&phba->hbalock);
+			phba->sli.sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
+			spin_unlock_irq(&phba->hbalock);
 			done = 1;
+		}
 	}
 	if (!done) {
 		rc = -EINVAL;
 		goto do_prep_failed;
 	}
-	if (pmb->mb.un.varCfgPort.sli_mode == 3) {
-		if (!pmb->mb.un.varCfgPort.cMA) {
+	if (pmb->u.mb.un.varCfgPort.sli_mode == 3) {
+		if (!pmb->u.mb.un.varCfgPort.cMA) {
 			rc = -ENXIO;
 			goto do_prep_failed;
 		}
-		if (phba->max_vpi && pmb->mb.un.varCfgPort.gmv) {
+		if (phba->max_vpi && pmb->u.mb.un.varCfgPort.gmv) {
 			phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
-			phba->max_vpi = pmb->mb.un.varCfgPort.max_vpi;
+			phba->max_vpi = pmb->u.mb.un.varCfgPort.max_vpi;
+			phba->max_vports = (phba->max_vpi > phba->max_vports) ?
+				phba->max_vpi : phba->max_vports;
+
 		} else
 			phba->max_vpi = 0;
-		if (pmb->mb.un.varCfgPort.gerbm)
+		if (pmb->u.mb.un.varCfgPort.gdss)
+			phba->sli3_options |= LPFC_SLI3_DSS_ENABLED;
+		if (pmb->u.mb.un.varCfgPort.gerbm)
 			phba->sli3_options |= LPFC_SLI3_HBQ_ENABLED;
-		if (pmb->mb.un.varCfgPort.gcrp)
+		if (pmb->u.mb.un.varCfgPort.gcrp)
 			phba->sli3_options |= LPFC_SLI3_CRP_ENABLED;
-		if (pmb->mb.un.varCfgPort.ginb) {
+		if (pmb->u.mb.un.varCfgPort.ginb) {
 			phba->sli3_options |= LPFC_SLI3_INB_ENABLED;
 			phba->hbq_get = phba->mbox->us.s3_inb_pgp.hbq_get;
 			phba->port_gp = phba->mbox->us.s3_inb_pgp.port;
@@ -3959,7 +3968,7 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 		}
 
 		if (phba->cfg_enable_bg) {
-			if (pmb->mb.un.varCfgPort.gbg)
+			if (pmb->u.mb.un.varCfgPort.gbg)
 				phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
 			else
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -4054,8 +4063,9 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 		if (rc)
 			goto lpfc_sli_hba_setup_error;
 	}
-
+	spin_lock_irq(&phba->hbalock);
 	phba->sli.sli_flag |= LPFC_PROCESS_LA;
+	spin_unlock_irq(&phba->hbalock);
 
 	rc = lpfc_config_port_post(phba);
 	if (rc)
@@ -4596,7 +4606,7 @@ void
 lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *pmbox = phba->sli.mbox_active;
-	MAILBOX_t *mb = &pmbox->mb;
+	MAILBOX_t *mb = &pmbox->u.mb;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 
@@ -6414,6 +6424,52 @@ lpfc_sli_queue_setup(struct lpfc_hba *ph
 }
 
 /**
+ * lpfc_sli_mbox_sys_flush - Flush mailbox command sub-system
+ * @phba: Pointer to HBA context object.
+ *
+ * This routine flushes the mailbox command subsystem. It will unconditionally
+ * flush all the mailbox commands in the three possible stages in the mailbox
+ * command sub-system: pending mailbox command queue; the outstanding mailbox
+ * command; and completed mailbox command queue. It is caller's responsibility
+ * to make sure that the driver is in the proper state to flush the mailbox
+ * command sub-system. Namely, the posting of mailbox commands into the
+ * pending mailbox command queue from the various clients must be stopped;
+ * either the HBA is in a state that it will never works on the outstanding
+ * mailbox command (such as in EEH or ERATT conditions) or the outstanding
+ * mailbox command has been completed.
+ **/
+static void
+lpfc_sli_mbox_sys_flush(struct lpfc_hba *phba)
+{
+	LIST_HEAD(completions);
+	struct lpfc_sli *psli = &phba->sli;
+	LPFC_MBOXQ_t *pmb;
+	unsigned long iflag;
+
+	/* Flush all the mailbox commands in the mbox system */
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	/* The pending mailbox command queue */
+	list_splice_init(&phba->sli.mboxq, &completions);
+	/* The outstanding active mailbox command */
+	if (psli->mbox_active) {
+		list_add_tail(&psli->mbox_active->list, &completions);
+		psli->mbox_active = NULL;
+		psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	}
+	/* The completed mailbox command queue */
+	list_splice_init(&phba->sli.mboxq_cmpl, &completions);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+
+	/* Return all flushed mailbox commands with MBX_NOT_FINISHED status */
+	while (!list_empty(&completions)) {
+		list_remove_head(&completions, pmb, LPFC_MBOXQ_t, list);
+		pmb->u.mb.mbxStatus = MBX_NOT_FINISHED;
+		if (pmb->mbox_cmpl)
+			pmb->mbox_cmpl(phba, pmb);
+	}
+}
+
+/**
  * lpfc_sli_host_down - Vport cleanup function
  * @vport: Pointer to virtual port object.
  *
@@ -6506,9 +6562,11 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *buf_ptr;
-	LPFC_MBOXQ_t *pmb;
-	int i;
 	unsigned long flags = 0;
+	int i;
+
+	/* Shutdown the mailbox command sub-system */
+	lpfc_sli_mbox_sys_shutdown(phba);
 
 	lpfc_hba_down_prep(phba);
 
@@ -7773,7 +7831,7 @@ lpfc_sli_sp_intr_handler(int irq, void *
 
 		if ((work_ha_copy & HA_MBATT) && (phba->sli.mbox_active)) {
 			pmb = phba->sli.mbox_active;
-			pmbox = &pmb->mb;
+			pmbox = &pmb->u.mb;
 			mbox = phba->mbox;
 			vport = pmb->vport;
 
@@ -8170,6 +8228,183 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 }
 
 /**
+ * lpfc_sli4_sp_handle_async_event - Handle an asynchroous event
+ * @phba: Pointer to HBA context object.
+ * @cqe: Pointer to mailbox completion queue entry.
+ *
+ * This routine process a mailbox completion queue entry with asynchrous
+ * event.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_async_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
+{
+	struct lpfc_cq_event *cq_event;
+	unsigned long iflags;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"0392 Async Event: word0:x%x, word1:x%x, "
+			"word2:x%x, word3:x%x\n", mcqe->word0,
+			mcqe->mcqe_tag0, mcqe->mcqe_tag1, mcqe->trailer);
+
+	/* Allocate a new internal CQ_EVENT entry */
+	cq_event = lpfc_sli4_cq_event_alloc(phba);
+	if (!cq_event) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0394 Failed to allocate CQ_EVENT entry\n");
+		return false;
+	}
+
+	/* Move the CQE into an asynchronous event entry */
+	memcpy(&cq_event->cqe, mcqe, sizeof(struct lpfc_mcqe));
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	list_add_tail(&cq_event->list, &phba->sli4_hba.sp_asynce_work_queue);
+	/* Set the async event flag */
+	phba->hba_flag |= ASYNC_EVENT;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	return true;
+}
+
+/**
+ * lpfc_sli4_sp_handle_mbox_event - Handle a mailbox completion event
+ * @phba: Pointer to HBA context object.
+ * @cqe: Pointer to mailbox completion queue entry.
+ *
+ * This routine process a mailbox completion queue entry with mailbox
+ * completion event.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
+{
+	uint32_t mcqe_status;
+	MAILBOX_t *mbox, *pmbox;
+	struct lpfc_mqe *mqe;
+	struct lpfc_vport *vport;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_dmabuf *mp;
+	unsigned long iflags;
+	LPFC_MBOXQ_t *pmb;
+	bool workposted = false;
+	int rc;
+
+	/* If not a mailbox complete MCQE, out by checking mailbox consume */
+	if (!bf_get(lpfc_trailer_completed, mcqe))
+		goto out_no_mqe_complete;
+
+	/* Get the reference to the active mbox command */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	pmb = phba->sli.mbox_active;
+	if (unlikely(!pmb)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"1832 No pending MBOX command to handle\n");
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		goto out_no_mqe_complete;
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	mqe = &pmb->u.mqe;
+	pmbox = (MAILBOX_t *)&pmb->u.mqe;
+	mbox = phba->mbox;
+	vport = pmb->vport;
+
+	/* Reset heartbeat timer */
+	phba->last_completion_time = jiffies;
+	del_timer(&phba->sli.mbox_tmo);
+
+	/* Move mbox data to caller's mailbox region, do endian swapping */
+	if (pmb->mbox_cmpl && mbox)
+		lpfc_sli_pcimem_bcopy(mbox, mqe, sizeof(struct lpfc_mqe));
+	/* Set the mailbox status with SLI4 range 0x4000 */
+	mcqe_status = bf_get(lpfc_mcqe_status, mcqe);
+	if (mcqe_status != MB_CQE_STATUS_SUCCESS)
+		bf_set(lpfc_mqe_status, mqe,
+		       (LPFC_MBX_ERROR_RANGE | mcqe_status));
+
+	if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
+		pmb->mbox_flag &= ~LPFC_MBX_IMED_UNREG;
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_MBOX_VPORT,
+				      "MBOX dflt rpi: status:x%x rpi:x%x",
+				      mcqe_status,
+				      pmbox->un.varWords[0], 0);
+		if (mcqe_status == MB_CQE_STATUS_SUCCESS) {
+			mp = (struct lpfc_dmabuf *)(pmb->context1);
+			ndlp = (struct lpfc_nodelist *)pmb->context2;
+			/* Reg_LOGIN of dflt RPI was successful. Now lets get
+			 * RID of the PPI using the same mbox buffer.
+			 */
+			lpfc_unreg_login(phba, vport->vpi,
+					 pmbox->un.varWords[0], pmb);
+			pmb->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;
+			pmb->context1 = mp;
+			pmb->context2 = ndlp;
+			pmb->vport = vport;
+			rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+			if (rc != MBX_BUSY)
+				lpfc_printf_log(phba, KERN_ERR, LOG_MBOX |
+						LOG_SLI, "0385 rc should "
+						"have been MBX_BUSY\n");
+			if (rc != MBX_NOT_FINISHED)
+				goto send_current_mbox;
+		}
+	}
+	spin_lock_irqsave(&phba->pport->work_port_lock, iflags);
+	phba->pport->work_port_events &= ~WORKER_MBOX_TMO;
+	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflags);
+
+	/* There is mailbox completion work to do */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	__lpfc_mbox_cmpl_put(phba, pmb);
+	phba->work_ha |= HA_MBATT;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	workposted = true;
+
+send_current_mbox:
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	/* Release the mailbox command posting token */
+	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	/* Setting active mailbox pointer need to be in sync to flag clear */
+	phba->sli.mbox_active = NULL;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	/* Wake up worker thread to post the next pending mailbox command */
+	lpfc_worker_wake_up(phba);
+out_no_mqe_complete:
+	if (bf_get(lpfc_trailer_consumed, mcqe))
+		lpfc_sli4_mq_release(phba->sli4_hba.mbx_wq);
+	return workposted;
+}
+
+/**
+ * lpfc_sli4_sp_handle_mcqe - Process a mailbox completion queue entry
+ * @phba: Pointer to HBA context object.
+ * @cqe: Pointer to mailbox completion queue entry.
+ *
+ * This routine process a mailbox completion queue entry, it invokes the
+ * proper mailbox complete handling or asynchrous event handling routine
+ * according to the MCQE's async bit.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_mcqe(struct lpfc_hba *phba, struct lpfc_cqe *cqe)
+{
+	struct lpfc_mcqe mcqe;
+	bool workposted;
+
+	/* Copy the mailbox MCQE and convert endian order as needed */
+	lpfc_sli_pcimem_bcopy(cqe, &mcqe, sizeof(struct lpfc_mcqe));
+
+	/* Invoke the proper event handling routine */
+	if (!bf_get(lpfc_trailer_async, &mcqe))
+		workposted = lpfc_sli4_sp_handle_mbox_event(phba, &mcqe);
+	else
+		workposted = lpfc_sli4_sp_handle_async_event(phba, &mcqe);
+	return workposted;
+}
+
+/**
  * lpfc_sli4_sp_handle_els_wcqe - Handle els work-queue completion event
  * @phba: Pointer to HBA context object.
  * @wcqe: Pointer to work-queue completion queue entry.
@@ -9247,6 +9482,112 @@ out:
 }
 
 /**
+ * lpfc_mq_create - Create a mailbox Queue on the HBA
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @mq: The queue structure to use to create the mailbox queue.
+ *
+ * This function creates a mailbox queue, as detailed in @mq, on a port,
+ * described by @phba by sending a MQ_CREATE mailbox command to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @cq struct
+ * is used to get the entry count and entry size that are necessary to
+ * determine the number of pages to allocate and use for this queue. This
+ * function will send the MQ_CREATE mailbox command to the HBA to setup the
+ * mailbox queue. This function is asynchronous and will wait for the mailbox
+ * command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return ENOMEM. If the queue create mailbox command
+ * fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
+	       struct lpfc_queue *cq, uint32_t subtype)
+{
+	struct lpfc_mbx_mq_create *mq_create;
+	struct lpfc_dmabuf *dmabuf;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_mq_create) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_MQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	mq_create = &mbox->u.mqe.un.mq_create;
+	bf_set(lpfc_mbx_mq_create_num_pages, &mq_create->u.request,
+		    mq->page_count);
+	bf_set(lpfc_mq_context_cq_id, &mq_create->u.request.context,
+		    cq->queue_id);
+	bf_set(lpfc_mq_context_valid, &mq_create->u.request.context, 1);
+	switch (mq->entry_count) {
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0362 Unsupported MQ count. (%d)\n",
+				mq->entry_count);
+		if (mq->entry_count < 16)
+			return -EINVAL;
+		/* otherwise default to smallest count (drop through) */
+	case 16:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_16);
+		break;
+	case 32:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_32);
+		break;
+	case 64:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_64);
+		break;
+	case 128:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_128);
+		break;
+	}
+	list_for_each_entry(dmabuf, &mq->page_list, list) {
+		mq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+					putPaddrLow(dmabuf->phys);
+		mq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+	}
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &mq_create->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2502 MQ_CREATE mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+		goto out;
+	}
+	mq->queue_id = bf_get(lpfc_mbx_mq_create_q_id, &mq_create->u.response);
+	if (mq->queue_id == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+	mq->type = LPFC_MQ;
+	mq->subtype = subtype;
+	mq->host_index = 0;
+	mq->hba_index = 0;
+
+	/* link the mq onto the parent cq child list */
+	list_add_tail(&mq->list, &cq->child_list);
+out:
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	return status;
+}
+
+/**
  * lpfc_wq_create - Create a Work Queue on the HBA
  * @phba: HBA structure that indicates port to create a queue on.
  * @wq: The queue structure to use to create the work queue.
@@ -9615,6 +9956,60 @@ lpfc_cq_destroy(struct lpfc_hba *phba, s
 }
 
 /**
+ * lpfc_mq_destroy - Destroy a Mailbox Queue on the HBA
+ * @qm: The queue structure associated with the queue to destroy.
+ *
+ * This function destroys a queue, as detailed in @mq by sending an mailbox
+ * command, specific to the type of queue, to the HBA.
+ *
+ * The @mq struct is used to get the queue ID of the queue to destroy.
+ *
+ * On success this function will return a zero. If the queue destroy mailbox
+ * command fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (!mq)
+		return -ENODEV;
+	mbox = mempool_alloc(mq->phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_mq_destroy) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_MQ_DESTROY,
+			 length, LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_mq_destroy_q_id, &mbox->u.mqe.un.mq_destroy.u.request,
+	       mq->queue_id);
+	mbox->vport = mq->phba->pport;
+	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	rc = lpfc_sli_issue_mbox(mq->phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.mq_destroy.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2507 MQ_DESTROY mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+	}
+	/* Remove mq from any list */
+	list_del_init(&mq->list);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, mq->phba->mbox_mem_pool);
+	return status;
+}
+
+/**
  * lpfc_wq_destroy - Destroy a Work Queue on the HBA
  * @wq: The queue structure associated with the queue to destroy.
  *


