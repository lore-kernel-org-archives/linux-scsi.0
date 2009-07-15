From: michaelc@cs.wisc.edu
Subject: [PATCH 1/6] libiscsi: disable bh in and abort handler.
Date: Wed, 15 Jul 2009 15:02:57 -0500
Message-ID: <1247688182-15764-2-git-send-email-michaelc@cs.wisc.edu>
References: <1247688182-15764-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbZGOUDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 16:03:08 -0400
In-Reply-To: <1247688182-15764-1-git-send-email-michaelc@cs.wisc.edu>
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
1.6.0.6

