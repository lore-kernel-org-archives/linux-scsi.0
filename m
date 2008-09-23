From: michaelc@cs.wisc.edu
Subject: [PATCH] scsi_error: Fix idempotent command handling
Date: Tue, 23 Sep 2008 15:31:58 -0500
Message-ID: <1222201918-6753-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbYIWUcD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 16:32:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Drivers want to be able to return DID_TRANSPORT_DISRUPTED and
have it do the right thing for commands like tape and passthrouh
as far as retries go. The LLDs previously used DID_BUS_BUSY or DID_ERROR
which followed the cmd->retries limit, but DID_TRANSPORT_DISRUPTED
was skipping that check so it could have caused a problem with tape
commands.

This patch has DID_TRANSPORT_DISRUPTED check the cmd->retries/cmd->allowed.
It also removes the target blocking behavior for now because it is not needed
as drivers are checking for this scenario.

The patch was made over scsi-post and Mike Anderson's patchset:
"[PATCH 0/13] scsi: scsi_decide_disposition update"
http://marc.info/?l=linux-scsi&m=122210133628085&w=2

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |    5 +++--
 include/scsi/scsi.h       |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 32a624c..6e8034e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1294,9 +1294,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * LLD/transport was disrupted during processing of the IO.
 		 * The transport class is now blocked/blocking,
 		 * and the transport will decide what to do with the IO
-		 * based on its timers and recovery capablilities.
+		 * based on its timers and recovery capablilities if
+		 * cmd->retries permits.
 		 */
-		return SCSI_MLQUEUE_TARGET_BUSY;
+		return SCSI_MLQUEUE_TARGET_COM_ERR;
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 2d8f00e..255f5ee 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -446,6 +446,8 @@ enum {
 	SCSI_MLQUEUE_IMM_RETRY		= (0x08 << SCSI_MLQUEUE_BUSY_SHIFT) |
 		SCSI_MLQUEUE_DIS_RETRY | SCSI_IGN_BLK_FAILFAST |
 		SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_TARGET_COM_ERR	= (0x10 << SCSI_MLQUEUE_BUSY_SHIFT) |
+		SCSI_MLQUEUE_DIS_RETRY | SCSI_IGN_BLK_FAILFAST,
 };
 
 #define scsi_disposition_finish(dis) (dis & SCSI_MLQUEUE_DIS_FINISH)
-- 
1.5.4.1

