From: michaelc@cs.wisc.edu
Subject: [PATCH 10/13] libiscsi: don't let io sit in queue when session has failed
Date: Wed, 13 May 2009 17:57:47 -0500
Message-ID: <12422554753201-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
 <12422554742374-git-send-email-michaelc@cs.wisc.edu>
 <12422554743206-git-send-email-michaelc@cs.wisc.edu>
 <12422554752623-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51869 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762061AbZEMW55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:57 -0400
In-Reply-To: <12422554752623-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the session is failed, but we have not yet fully transitioned
to the recovery stage we were still queueuing IO. The idea is
that for some failures we can recvover at the command level
and still continue to execute other IO. Well, we never have
added the recovery within a command code, so queueing up IO here
just creates the possibility that it might time time out so
this just has us requeue the IO the scsi layer for now.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a9d7e52..57eb3af 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1390,13 +1390,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto fault;
 	}
 
-	/*
-	 * ISCSI_STATE_FAILED is a temp. state. The recovery
-	 * code will decide what is best to do with command queued
-	 * during this time
-	 */
-	if (session->state != ISCSI_STATE_LOGGED_IN &&
-	    session->state != ISCSI_STATE_FAILED) {
+	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
 		 * to handle the race between when we set the recovery state
 		 * and block the session we requeue here (commands could
@@ -1404,12 +1398,15 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		 * up because the block code is not locked)
 		 */
 		switch (session->state) {
+		case ISCSI_STATE_FAILED:
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			goto reject;
+			sc->result = DID_IMM_RETRY << 16;
+			break;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
-			goto reject;
+			sc->result = DID_IMM_RETRY << 16;
+			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
 			sc->result = DID_TRANSPORT_FAILFAST << 16;
-- 
1.5.2.1

