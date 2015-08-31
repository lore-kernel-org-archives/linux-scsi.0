From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 11/14] lpfc: Fix for discovery failure in PT2PT when
 FLOGI's ELS ACC response gets aborted
Date: Mon, 31 Aug 2015 16:48:18 -0400
Message-ID: <55e4bd92.KegerC79Wj93PQSl%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36626 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbbHaUsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:35 -0400
Received: by qgeb6 with SMTP id b6so73668912qge.3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:34 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id 139sm1709033qhh.32.2015.08.31.13.48.33
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix for discovery failure in PT2PT when FLOGI's ELS ACC response gets aborted

Change login state machine to:
- Restart FLOGI if prior is ABTS'd
- Reject incoming FLOGIs if we have one pending

The above ensures that we always finish FLOGI processing, regardless
of who initated FLOGI, before processing PLOGI's.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 598313d..759fa9b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5850,6 +5850,13 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		return 1;
 	}
 
+	/* send our FLOGI first */
+	if (vport->port_state < LPFC_FLOGI) {
+		vport->fc_myDID = 0;
+		lpfc_initial_flogi(vport);
+		vport->fc_myDID = Fabric_DID;
+	}
+
 	/* Send back ACC */
 	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
 
@@ -7324,6 +7331,15 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 "Data: x%x x%x x%x x%x\n",
 			cmd, did, vport->port_state, vport->fc_flag,
 			vport->fc_myDID, vport->fc_prevDID);
+
+	/* reject till our FLOGI completes */
+	if ((vport->port_state < LPFC_FABRIC_CFG_LINK) &&
+		(cmd != ELS_CMD_FLOGI)) {
+		rjt_err = LSRJT_UNABLE_TPC;
+		rjt_exp = LSEXP_NOTHING_MORE;
+		goto lsrjt;
+	}
+
 	switch (cmd) {
 	case ELS_CMD_PLOGI:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -7361,20 +7377,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				rjt_exp = LSEXP_NOTHING_MORE;
 				break;
 			}
-			/* We get here, and drop thru, if we are PT2PT with
-			 * another NPort and the other side has initiated
-			 * the PLOGI before responding to our FLOGI.
-			 */
-			if (phba->sli_rev == LPFC_SLI_REV4 &&
-			    (phba->fc_topology_changed ||
-			     vport->fc_myDID != vport->fc_prevDID)) {
-				lpfc_unregister_fcf_prep(phba);
-				spin_lock_irq(shost->host_lock);
-				vport->fc_flag &= ~FC_VFI_REGISTERED;
-				spin_unlock_irq(shost->host_lock);
-				phba->fc_topology_changed = 0;
-				lpfc_issue_reg_vfi(vport);
-			}
 		}
 
 		spin_lock_irq(shost->host_lock);
@@ -7605,6 +7607,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		break;
 	}
 
+lsrjt:
 	/* check if need to LS_RJT received ELS cmd */
 	if (rjt_err) {
 		memset(&stat, 0, sizeof(stat));
-- 
1.7.11.7

