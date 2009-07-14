From: michaelc@cs.wisc.edu
Subject: [PATCH 1/6] libiscsi: disable bh in and abort handler.
Date: Mon, 13 Jul 2009 22:24:03 -0500
Message-ID: <1247541848-30412-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZGNDYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2009 23:24:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The session lock can be held in the scsi eh thread or the completion
paths run from the net softirq. This disables bhs in iscsi_eh_abort when
taking the session lock.

Patch was made over scsi-rc-fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 716cc34..a751f62 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1974,10 +1974,10 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 * good and have never sent us a successful tmf response
 		 * then sent more data for the cmd.
 		 */
-		spin_lock(&session->lock);
+		spin_lock_bh(&session->lock);
 		fail_scsi_task(task, DID_ABORT);
 		conn->tmf_state = TMF_INITIAL;
-		spin_unlock(&session->lock);
+		spin_unlock_bh(&session->lock);
 		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
-- 
1.6.2.2

