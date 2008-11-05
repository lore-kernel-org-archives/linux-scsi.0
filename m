From: michaelc@cs.wisc.edu
Subject: [PATCH] scsi_error regression: Fix idempotent command handling
Date: Tue,  4 Nov 2008 19:47:19 -0600
Message-ID: <1225849639-7204-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34968 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbYKEBrV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2008 20:47:21 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA51lL7s015373
	for <linux-scsi@vger.kernel.org>; Tue, 4 Nov 2008 20:47:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

Drivers want to be able to return DID_TRANSPORT_DISRUPTED and
have it do the right thing for commands like tape and passthrouh
as far as retries go. The LLDs previously used DID_BUS_BUSY or DID_ERROR
which followed the cmd->retries limit, but DID_TRANSPORT_DISRUPTED
was skipping that check so it could have caused a problem with tape
commands.

This patch has DID_TRANSPORT_DISRUPTED check the cmd->retries/cmd->allowed.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/scsi/scsi_error.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 94ed262..3863617 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1340,9 +1340,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * LLD/transport was disrupted during processing of the IO.
 		 * The transport class is now blocked/blocking,
 		 * and the transport will decide what to do with the IO
-		 * based on its timers and recovery capablilities.
+		 * based on its timers and recovery capablilities if
+		 * there are enough retries.
 		 */
-		return ADD_TO_MLQUEUE;
+		goto maybe_retry;
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely
-- 
1.5.4.3

