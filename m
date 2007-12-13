From: michaelc@cs.wisc.edu
Subject: [PATCH 09/24] libiscsi: grab eh_mutex during host reset
Date: Thu, 13 Dec 2007 12:43:28 -0600
Message-ID: <11975714363904-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758807AbXLMSoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:05 -0500
In-Reply-To: <119757143673-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

I thought we may not need the eh mutex during host reset, but that is wrong
with the new shutdown code. When start_session_recovery sets the state to
terminate then drops the session lock. The scsi eh thread could then grab the
session lock see that we are terminating and then return failed to scsi-ml.
scsi-ml's eh then owns the command and will do whatever it wants
with it. But then the iscsi eh thread could grab the session lock
and want to complete the scsi commands that we in the LLD, but
it no longer owns them and kaboom.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b7a2b9a..441e351 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1079,17 +1079,19 @@ int iscsi_eh_host_reset(struct scsi_cmnd *sc)
 	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
 	struct iscsi_conn *conn = session->leadconn;
 
+	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
 failed:
 		debug_scsi("failing host reset: session terminated "
 			   "[CID %d age %d]\n", conn->id, session->age);
 		spin_unlock_bh(&session->lock);
+		mutex_unlock(&session->eh_mutex);
 		return FAILED;
 	}
 
 	spin_unlock_bh(&session->lock);
-
+	mutex_unlock(&session->eh_mutex);
 	/*
 	 * we drop the lock here but the leadconn cannot be destoyed while
 	 * we are in the scsi eh
@@ -1104,13 +1106,14 @@ failed:
 	if (signal_pending(current))
 		flush_signals(current);
 
+	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_LOGGED_IN)
 		printk(KERN_INFO "iscsi: host reset succeeded\n");
 	else
 		goto failed;
 	spin_unlock_bh(&session->lock);
-
+	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_host_reset);
-- 
1.5.1.2

