Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C80C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 21:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiG2VlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 17:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbiG2VlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 17:41:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3158C3D1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 14:41:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso239624pjl.4
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 14:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=4rTyUk4rzkhdd27Nh2tUOvjaUOrE65xi8d3nqqfb3Aw=;
        b=PIssbtnzoV6AgMaTr3RvyJI20Nzqr3M3GO6B6rLBBpfurY/ndQ5x2qBQwzfWHrsytt
         st8ya03NQAD+GJIdrdw3AF0qjmITmGn6MiiD89JrtaSWvq7L4jWIqr2//r7SpiJvVWjM
         iMWKeE3jE9xefPsK0tFaKP+MjVk1zQEEgwfxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=4rTyUk4rzkhdd27Nh2tUOvjaUOrE65xi8d3nqqfb3Aw=;
        b=ue5dtyhwleHd34aFO1LLyln5J5rvHV9oRxJiSCjtLe/Nd0VE4ylneiWITs0CUWHkdA
         Iroj7LK8/qdPFDYFwumU+loSKbwVsZCXoX5Cja+duyqE/gBm1CHEbXxXhOByvWbU8N2m
         B3K+S5ULZWHFGuPvkQLZRD571L7cqAmO13GQglJn1gsUFxoMuhKSOXBmZgK7LZ8/SeNA
         Rrb9sT8RzBLwR7bkw4mXb4iJKdeItfCE4ScxoI0T9ouX6WKXYGTJQjkacoRIJXN72HPD
         clXePxVlVDhfqR6ZpJenWJCJwRO4lCcIYnayS44NF9xfBPTYvTcBNGUl/StDrEBd9NyD
         fcOQ==
X-Gm-Message-State: ACgBeo1u8olnebMuYCP0H1JS6ixohwEFZhGhAPS/i3BnwR+56cEIV9Dl
        NQQr16ov/TD+C0+C/iVcJZDAxc0SPzOl2QmTbkKtcd6ru9Oe8R7BnlMTrhUtYKdltgs4XZYUqiF
        ZD5P2UE+H8oTR1IP7jlbk070QT8i13CnLPSBWIacWb82BB6LCk9KF6UrmdmxkM6w0IsggNa6Gnu
        yj
X-Google-Smtp-Source: AA6agR4XicTQk4K8u4XjEHNvEhfe50qsd56kcy3abjc+VjU0vRhxrwzz89p895GymtRsFDsWWR2l6A==
X-Received: by 2002:a17:90b:1d83:b0:1f4:cc3a:8cba with SMTP id pf3-20020a17090b1d8300b001f4cc3a8cbamr1464919pjb.173.1659130876382;
        Fri, 29 Jul 2022 14:41:16 -0700 (PDT)
Received: from localhost.localdomain (vpn.purestorage.com. [192.30.189.1])
        by smtp.gmail.com with ESMTPSA id y5-20020aa79425000000b0052ab7985e18sm3466860pfo.61.2022.07.29.14.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 14:41:15 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     Brian Bunker <brian@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>
Subject: [PATCH] scsi_lib: Allow the ALUA transitioning state enough time
Date:   Fri, 29 Jul 2022 14:41:10 -0700
Message-Id: <20220729214110.58576-1-brian@purestorage.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error path for the SCSI check condition of not ready, target in
ALUA state transition, will result in the failure of that path after
the retries are exhausted. In most cases that is well ahead of the
transition timeout established in the SCSI ALUA device handler.

Instead, reprep the command and re-add it to the queue after a 1 second
delay. This will allow the handler to take care of the timeout and
only fail the path if the target has exceeded the transition expiry
timeout (default 60 seconds). If the expiry timeout is exceeded, the
handler will change the path state from transitioning to standby
leading to a path failure eliminating the potential of this re-prep
to continue endlessly. In most cases the target will exit the
transitioning state well before the expiry timeout but after the
retries are exhausted as mentioned.

Additionally remove the scsi_io_completion_reprep function which
provides little value.

Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_lib.c | 44 +++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6ffc9e4258a8..1afb267ff9a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 	}
 }
 
-static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
+static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long msecs)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
 
@@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 	} else {
 		WARN_ON_ONCE(true);
 	}
-	blk_mq_requeue_request(rq, true);
+
+	if (msecs) {
+		blk_mq_requeue_request(rq, false);
+		blk_mq_delay_kick_requeue_list(rq->q, msecs);
+	} else
+		blk_mq_requeue_request(rq, true);
 }
 
 /**
@@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const struct request *rq)
 	return bytes;
 }
 
-/* Helper for scsi_io_completion() when "reprep" action required. */
-static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
-				      struct request_queue *q)
-{
-	/* A new command will be prepared and issued. */
-	scsi_mq_requeue_cmd(cmd);
-}
-
 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 {
 	struct request *req = scsi_cmd_to_rq(cmd);
@@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 	return false;
 }
 
+/*
+ * When ALUA transition state is returned, reprep the cmd to
+ * use the ALUA handlers transition timeout. Delay the reprep
+ * 1 sec to avoid aggressive retries of the target in that
+ * state.
+ */
+#define ALUA_TRANSITION_REPREP_DELAY	1000
+
 /* Helper for scsi_io_completion() when special action required. */
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = scsi_cmd_to_rq(cmd);
 	int level = 0;
-	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-	      ACTION_DELAYED_RETRY} action;
+	enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
+	      ACTION_RETRY, ACTION_DELAYED_RETRY} action;
 	struct scsi_sense_hdr sshdr;
 	bool sense_valid;
 	bool sense_current = true;      /* false implies "deferred sense" */
@@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
-					blk_stat = BLK_STS_TRANSPORT;
-					fallthrough;
+					action = ACTION_DELAYED_REPREP;
+					break;
 				default:
 					action = ACTION_FAIL;
 					break;
@@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			return;
 		fallthrough;
 	case ACTION_REPREP:
-		scsi_io_completion_reprep(cmd, q);
+		scsi_mq_requeue_cmd(cmd, 0);
+		break;
+	case ACTION_DELAYED_REPREP:
+		scsi_mq_requeue_cmd(cmd, ALUA_TRANSITION_REPREP_DELAY);
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
@@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
  * command block will be released and the queue function will be goosed. If we
  * are not done then we have to figure out what to do next:
  *
- *   a) We can call scsi_io_completion_reprep().  The request will be
+ *   a) We can call scsi_mq_requeue_cmd().  The request will be
  *	unprepared and put back on the queue.  Then a new command will
  *	be created for it.  This should be used if we made forward
  *	progress, or if we want to switch from READ(10) to READ(6) for
@@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = scsi_cmd_to_rq(cmd);
 	blk_status_t blk_stat = BLK_STS_OK;
 
@@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * request just queue the command up again.
 	 */
 	if (likely(result == 0))
-		scsi_io_completion_reprep(cmd, q);
+		scsi_mq_requeue_cmd(cmd, 0);
 	else
 		scsi_io_completion_action(cmd, result);
 }
-- 
2.33.1

