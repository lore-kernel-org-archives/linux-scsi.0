From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6] lpfc 8.3.9: Fix locking and memory issues
Date: Fri, 12 Feb 2010 14:43:01 -0500
Message-ID: <1266003801.2939.18.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49989 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756634Ab0BLTnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:43:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Use the hbalock when changing the fc_flag.
- Use the host_lock when changeing the sli_flag.
- Prevent NULL pointer dereference after dma_alloc_coherent failure.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   33 +++++++++++++++++++++++----------
 lpfc_init.c    |    8 ++++----
 lpfc_mbox.c    |    3 ++-
 lpfc_vport.c   |    5 +++--
 4 files changed, 32 insertions(+), 17 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-12 10:53:44.000000000 -0500
@@ -757,11 +757,13 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_SCAN_DONE);
+	spin_unlock_irq(&phba->hbalock);
 	if (phba->link_state > LPFC_LINK_DOWN) {
 		phba->link_state = LPFC_LINK_DOWN;
+		spin_lock_irq(shost->host_lock);
 		phba->pport->fc_flag &= ~FC_LBIT;
+		spin_unlock_irq(shost->host_lock);
 	}
-	spin_unlock_irq(&phba->hbalock);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
@@ -1802,6 +1804,8 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba
 {
 	struct lpfc_vport *vport = mboxq->vport;
 	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
 	if (mboxq->u.mb.mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR,
 				LOG_MBOX,
@@ -1811,9 +1815,9 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		return;
 	}
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_INIT_VPI;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(shost->host_lock);
 
 	/* If this port is physical port or FDISC is done, do reg_vpi */
 	if ((phba->pport == vport) || (vport->port_state == LPFC_FDISC)) {
@@ -1924,6 +1928,7 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 {
 	struct lpfc_dmabuf *dmabuf = mboxq->context1;
 	struct lpfc_vport *vport = mboxq->vport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	if (mboxq->u.mb.mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
@@ -1941,10 +1946,11 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 		goto fail_free_mem;
 	}
 	/* The VPI is implicitly registered when the VFI is registered */
+	spin_lock_irq(shost->host_lock);
 	vport->vpi_state |= LPFC_VPI_REGISTERED;
 	vport->fc_flag |= FC_VFI_REGISTERED;
-
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(shost->host_lock);
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
 		lpfc_start_fdiscs(phba);
@@ -2269,10 +2275,12 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	}
 
 	phba->fc_eventTag = la->eventTag;
+	spin_lock_irq(&phba->hbalock);
 	if (la->mm)
 		phba->sli.sli_flag |= LPFC_MENLO_MAINT;
 	else
 		phba->sli.sli_flag &= ~LPFC_MENLO_MAINT;
+	spin_unlock_irq(&phba->hbalock);
 
 	phba->link_events++;
 	if (la->attType == AT_LINK_UP && (!la->mm)) {
@@ -2401,10 +2409,10 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba 
 				 mb->mbxStatus);
 		break;
 	}
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(shost->host_lock);
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(shost->host_lock);
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
 	/*
@@ -2462,8 +2470,10 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *p
 		goto out;
 	}
 
+	spin_lock_irq(shost->host_lock);
 	vport->vpi_state |= LPFC_VPI_REGISTERED;
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(shost->host_lock);
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
 	if (vport->fc_npr_cnt)
@@ -4620,6 +4630,7 @@ lpfc_unregister_fcf_prep(struct lpfc_hba
 	LPFC_MBOXQ_t *mbox;
 	struct lpfc_vport **vports;
 	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host *shost;
 	int i, rc;
 
 	/* Unregister RPIs */
@@ -4638,10 +4649,11 @@ lpfc_unregister_fcf_prep(struct lpfc_hba
 			if (ndlp)
 				lpfc_cancel_retry_delay_tmo(vports[i], ndlp);
 			lpfc_mbx_unreg_vpi(vports[i]);
-			spin_lock_irq(&phba->hbalock);
+			shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irq(shost->host_lock);
 			vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irq(shost->host_lock);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
@@ -4671,9 +4683,10 @@ lpfc_unregister_fcf_prep(struct lpfc_hba
 		return -EIO;
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	shost = lpfc_shost_from_vport(phba->pport);
+	spin_lock_irq(shost->host_lock);
 	phba->pport->fc_flag &= ~FC_VFI_REGISTERED;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(shost->host_lock);
 
 	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:53:25.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:53:44.000000000 -0500
@@ -2363,6 +2363,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
 	struct lpfc_vport **vports;
+	struct Scsi_Host *shost;
 	int i;
 
 	if (vport->fc_flag & FC_OFFLINE_MODE)
@@ -2376,13 +2377,14 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-			struct Scsi_Host *shost;
-
 			if (vports[i]->load_flag & FC_UNLOADING)
 				continue;
+			shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irq(shost->host_lock);
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
 			vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			vports[i]->fc_flag &= ~FC_VFI_REGISTERED;
+			spin_unlock_irq(shost->host_lock);
 
 			shost =	lpfc_shost_from_vport(vports[i]);
 			list_for_each_entry_safe(ndlp, next_ndlp,
@@ -2789,8 +2791,6 @@ lpfc_stop_port_s4(struct lpfc_hba *phba)
 	lpfc_stop_hba_timers(phba);
 	phba->pport->work_port_events = 0;
 	phba->sli4_hba.intr_enable = 0;
-	/* Hard clear it for now, shall have more graceful way to wait later */
-	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-12 10:53:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-12 10:53:44.000000000 -0500
@@ -1707,7 +1707,8 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 				alloc_len - sizeof(union  lpfc_sli4_cfg_shdr);
 	}
 	/* The sub-header is in DMA memory, which needs endian converstion */
-	lpfc_sli_pcimem_bcopy(cfg_shdr, cfg_shdr,
+	if (cfg_shdr)
+		lpfc_sli_pcimem_bcopy(cfg_shdr, cfg_shdr,
 			      sizeof(union  lpfc_sli4_cfg_shdr));
 
 	return alloc_len;
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-02-11 17:26:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-02-12 10:53:44.000000000 -0500
@@ -505,6 +505,7 @@ enable_vport(struct fc_vport *fc_vport)
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	if ((phba->link_state < LPFC_LINK_UP) ||
 	    (phba->fc_topology == TOPOLOGY_LOOP)) {
@@ -512,10 +513,10 @@ enable_vport(struct fc_vport *fc_vport)
 		return VPORT_OK;
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(shost->host_lock);
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(shost->host_lock);
 
 	/* Use the Physical nodes Fabric NDLP to determine if the link is
 	 * up and ready to FDISC.


