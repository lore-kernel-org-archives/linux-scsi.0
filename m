From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/07] lpfc 8.3.29: Locking fix and Memory leak Fixes
Date: Wed, 18 Jan 2012 16:25:38 -0500
Message-ID: <1326921939.32733.14.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:33060 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969Ab2ARVZ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 16:25:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Locking fix and Memory leak Fixes

- Fix Locking code raises IRQ twice (NA)
- Fix mailbox and vpi memory leaks (126818)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c   |    8 ++++----
 lpfc_init.c      |    6 ++++++
 lpfc_nportdisc.c |    1 +
 lpfc_sli.c       |    3 ++-
 4 files changed, 13 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-01-18 11:33:56.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-01-18 11:34:10.000000000 -0500
@@ -2977,9 +2977,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 				"topology\n");
 				/* Get Loop Map information */
 		if (bf_get(lpfc_mbx_read_top_il, la)) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock(shost->host_lock);
 			vport->fc_flag |= FC_LBIT;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock(shost->host_lock);
 		}
 
 		vport->fc_myDID = bf_get(lpfc_mbx_read_top_alpa_granted, la);
@@ -3029,9 +3029,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 				phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
 		}
 		vport->fc_myDID = phba->fc_pref_DID;
-		spin_lock_irq(shost->host_lock);
+		spin_lock(shost->host_lock);
 		vport->fc_flag |= FC_LBIT;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock(shost->host_lock);
 	}
 	spin_unlock_irq(&phba->hbalock);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-01-18 11:33:56.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-01-18 11:34:10.000000000 -0500
@@ -8178,6 +8178,9 @@ lpfc_unset_hba(struct lpfc_hba *phba)
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(shost->host_lock);
 
+	kfree(phba->vpi_bmask);
+	kfree(phba->vpi_ids);
+
 	lpfc_stop_hba_timers(phba);
 
 	phba->pport->work_port_events = 0;
@@ -8710,6 +8713,9 @@ lpfc_pci_remove_one_s3(struct pci_dev *p
 	/* Final cleanup of txcmplq and reset the HBA */
 	lpfc_sli_brdrestart(phba);
 
+	kfree(phba->vpi_bmask);
+	kfree(phba->vpi_ids);
+
 	lpfc_stop_hba_timers(phba);
 	spin_lock_irq(&phba->hbalock);
 	list_del_init(&vport->listentry);
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-01-18 11:32:50.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-01-18 11:34:10.000000000 -0500
@@ -481,6 +481,7 @@ lpfc_mbx_cmpl_resume_rpi(struct lpfc_hba
 			ndlp, NULL);
 	}
 	kfree(elsiocb);
+	mempool_free(mboxq, phba->mbox_mem_pool);
 }
 
 static int
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-01-18 11:33:41.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-01-18 11:34:10.000000000 -0500
@@ -14840,7 +14840,8 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelis
 		mboxq->mbox_cmpl = cmpl;
 		mboxq->context1 = arg;
 		mboxq->context2 = ndlp;
-	}
+	} else
+		mboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	mboxq->vport = ndlp->vport;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {



