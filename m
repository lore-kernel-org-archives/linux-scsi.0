From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Drop work-around for legacy GlobalSAN initiator
Date: Sun,  2 Apr 2017 21:21:23 +0000
Message-ID: <1491168083-31878-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58826 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdDBVVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2017 17:21:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Svec <martin.svec@zoner.cz>, Himanshu Madhani <Himanshu.Madhani@cavium.com>, Arun Easi <arun.easi@cavium.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Once upon a time back in 2009, a work-around was added to support
the GlobalSAN iSCSI initiator v3.3 for MacOSX, which during login
did not propose nor respond to MaxBurstLength, FirstBurstLength,
DefaultTime2Wait and DefaultTime2Retain keys.

The work-around in iscsi_check_proposer_for_optional_reply()
allowed the missing keys to be proposed, but did not require
waiting for a response before moving to full feature phase
operation.  This allowed GlobalSAN v3.3 to work out-of-the
box, and for many years we didn't run into login interopt
issues with any other initiators..

Until recently, when Martin tried a QLogic 57840S iSCSI Offload
HBA on Windows 2016 which completed login, but subsequently
failed with:

    Got unknown iSCSI OpCode: 0x43

The issue was QLogic MSFT side did not propose DefaultTime2Wait +
DefaultTime2Retain, so LIO proposes them itself, and immediately
transitions to full feature phase because of the GlobalSAN hack.
However, the QLogic MSFT side still attempts to respond to
DefaultTime2Retain + DefaultTime2Wait, even though LIO has set
ISCSI_FLAG_LOGIN_NEXT_STAGE3 + ISCSI_FLAG_LOGIN_TRANSIT
in last login response.

So while the QLogic MSFT side should have been proposing these
two keys to start, it was doing the correct thing per RFC-3720
attempting to respond to proposed keys before transitioning to
full feature phase.

All that said, recent versions of GlobalSAN iSCSI (v5.3.0.541)
does correctly propose the four keys during login, making the
original work-around moot.

So in order to allow QLogic MSFT to run unmodified as-is, go
ahead and drop this long standing work-around.

Reported-by: Martin Svec <martin.svec@zoner.cz>
Cc: Martin Svec <martin.svec@zoner.cz>
Cc: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Arun Easi <arun.easi@cavium.com>
Cc: stable@vger.kernel.org # 3.1+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index e65bf78..fce6276 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -782,22 +782,6 @@ static void iscsi_check_proposer_for_optional_reply(struct iscsi_param *param)
 		if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH))
 			SET_PSTATE_REPLY_OPTIONAL(param);
 		/*
-		 * The GlobalSAN iSCSI Initiator for MacOSX does
-		 * not respond to MaxBurstLength, FirstBurstLength,
-		 * DefaultTime2Wait or DefaultTime2Retain parameter keys.
-		 * So, we set them to 'reply optional' here, and assume the
-		 * the defaults from iscsi_parameters.h if the initiator
-		 * is not RFC compliant and the keys are not negotiated.
-		 */
-		if (!strcmp(param->name, MAXBURSTLENGTH))
-			SET_PSTATE_REPLY_OPTIONAL(param);
-		if (!strcmp(param->name, FIRSTBURSTLENGTH))
-			SET_PSTATE_REPLY_OPTIONAL(param);
-		if (!strcmp(param->name, DEFAULTTIME2WAIT))
-			SET_PSTATE_REPLY_OPTIONAL(param);
-		if (!strcmp(param->name, DEFAULTTIME2RETAIN))
-			SET_PSTATE_REPLY_OPTIONAL(param);
-		/*
 		 * Required for gPXE iSCSI boot client
 		 */
 		if (!strcmp(param->name, MAXCONNECTIONS))
-- 
1.9.1
