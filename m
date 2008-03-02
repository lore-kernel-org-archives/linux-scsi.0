From: michaelc@cs.wisc.edu
Subject: [PATCH 8/9] lpfc: convert to use fc helper and SCSI_MLQUEUE_TARGET_BUSY
Date: Sun,  2 Mar 2008 03:03:21 -0600
Message-ID: <1204448602-5435-8-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbYCBJEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:10 -0500
In-Reply-To: <1204448602-5435-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
causes a requeue and then possibly (if under recursion limits)
a queuecommand call.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 70255c1..a7810f4 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -949,12 +949,11 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err;
 
-	err = fc_remote_port_chkready(rport);
-	if (err) {
-		cmnd->result = err;
+	err = fc_remote_port_queue_ready(rport, cmnd);
+	if (err)
+		goto out_busy;
+	if (cmnd->result)
 		goto out_fail_command;
-	}
-
 	/*
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
@@ -970,7 +969,8 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "0707 driver's buffer pool is empty, "
 				 "IO busied\n");
-		goto out_host_busy;
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		goto out_busy;
 	}
 
 	/*
@@ -1003,10 +1003,11 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	return 0;
 
  out_host_busy_free_buf:
+	err = SCSI_MLQUEUE_HOST_BUSY;
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
- out_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
+ out_busy:
+	return err;
 
  out_fail_command:
 	done(cmnd);
-- 
1.5.4.1

