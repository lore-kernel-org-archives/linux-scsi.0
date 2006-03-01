From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 7/9] lpfc 8.1.3: Fix polling mode panic
Date: Tue, 28 Feb 2006 22:33:12 -0500
Message-ID: <20060301033312.GA21621@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:18898 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750866AbWCADdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:13 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213XCO8021628
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:12 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213XC0N021626
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix polling mode panic

Cause: Race between interrupt driven and polling path in harvesting iocbs
from
the response ring.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -467,6 +467,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	sdev = cmd->device;
 	cmd->scsi_done(cmd);
 
+	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+		return;
+	}
+
 	if (!result && pnode != NULL &&
 	   ((jiffies - pnode->last_ramp_up_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1154,12 +1154,17 @@ lpfc_sli_handle_fast_ring_event(struct l
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
 			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
-				spin_unlock_irqrestore(
-				       phba->host->host_lock, iflag);
-				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
-						      &rspiocbq);
-				spin_lock_irqsave(phba->host->host_lock,
-						  iflag);
+				if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+							      &rspiocbq);
+				} else {
+					spin_unlock_irqrestore(
+						phba->host->host_lock, iflag);
+					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+							      &rspiocbq);
+					spin_lock_irqsave(phba->host->host_lock,
+							  iflag);
+				}
 			}
 			break;
 		default:
