From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6] lpfc 8.3.7: Fix discovery failures.
Date: Mon, 21 Dec 2009 17:03:15 -0500
Message-ID: <1261433015.12238.16.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38078 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757351AbZLUWIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:08:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix discovery failures:
- Move all accesses to the fc_flag field inside the host lock.
- Restore link state after going through linkdown processing for FCF DEAD event.

Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_els.c     |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |    6 ++++++
 drivers/scsi/lpfc/lpfc_init.c    |    6 +++++-
 drivers/scsi/lpfc/lpfc_vport.c   |    2 ++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index bb2e43a..2cc3968 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4142,8 +4142,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	spin_lock_irq(shost->host_lock);
 	if (vport->fc_rscn_flush) {
 		/* Another thread is walking fc_rscn_id_list on this vport */
-		spin_unlock_irq(shost->host_lock);
 		vport->fc_flag |= FC_RSCN_DISCOVERY;
+		spin_unlock_irq(shost->host_lock);
 		/* Send back ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 		return 0;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 1c27372..2445e39 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1708,7 +1708,9 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		return;
 	}
+	spin_lock_irq(&phba->hbalock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_INIT_VPI;
+	spin_unlock_irq(&phba->hbalock);
 
 	if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
 		lpfc_initial_fdisc(vport);
@@ -2269,8 +2271,10 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				 mb->mbxStatus);
 		break;
 	}
+	spin_lock_irq(&phba->hbalock);
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(&phba->hbalock);
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
 	/*
@@ -4486,8 +4490,10 @@ lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
 		(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			lpfc_mbx_unreg_vpi(vports[i]);
+			spin_lock_irq(&phba->hbalock);
 			vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
+			spin_unlock_irq(&phba->hbalock);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 974ea6d..b8eb1b6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3006,6 +3006,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 	struct lpfc_vport *vport;
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host  *shost;
+	uint32_t link_state;
 
 	phba->fc_eventTag = acqe_fcoe->event_tag;
 	phba->fcoe_eventtag = acqe_fcoe->event_tag;
@@ -3052,9 +3053,12 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 			break;
 		/*
 		 * Currently, driver support only one FCF - so treat this as
-		 * a link down.
+		 * a link down, but save the link state because we don't want
+		 * it to be changed to Link Down unless it is already down.
 		 */
+		link_state = phba->link_state;
 		lpfc_linkdown(phba);
+		phba->link_state = link_state;
 		/* Unregister FCF if no devices connected to it */
 		lpfc_unregister_unused_fcf(phba);
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index c3a70c4..e3c7fa6 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -512,8 +512,10 @@ enable_vport(struct fc_vport *fc_vport)
 		return VPORT_OK;
 	}
 
+	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(&phba->hbalock);
 
 	/* Use the Physical nodes Fabric NDLP to determine if the link is
 	 * up and ready to FDISC.
-- 
1.6.5.2



