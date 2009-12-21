From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.7: Fix NPIV operation errors
Date: Mon, 21 Dec 2009 17:02:00 -0500
Message-ID: <1261432940.12238.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38078 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757373AbZLUWIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:08:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix NPIV operation errors:
- Fix vport not logging out of fabric when being deleted
- Fix vport fails to discover targets after devloss timeout.

Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_els.c     |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |    1 +
 drivers/scsi/lpfc/lpfc_vport.c   |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ce52270..bb2e43a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5948,8 +5948,8 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				lpfc_initial_fdisc(vport);
 			break;
 		}
-
 	} else {
+		vport->vpi_state |= LPFC_VPI_REGISTERED;
 		if (vport == phba->pport)
 			if (phba->sli_rev < LPFC_SLI_REV4)
 				lpfc_issue_fabric_reglogin(vport);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3b94244..401167d 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2260,6 +2260,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		break;
 	}
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
+	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 7d6dd83..c3a70c4 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -700,7 +700,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 			}
 			spin_unlock_irq(&phba->ndlp_lock);
 		}
-		if (vport->vpi_state != LPFC_VPI_REGISTERED)
+		if (!(vport->vpi_state & LPFC_VPI_REGISTERED))
 			goto skip_logo;
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
-- 
1.6.5.2



