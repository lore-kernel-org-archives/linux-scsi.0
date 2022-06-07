Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB02CCA482
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 03:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiFHDgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 23:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiFHDc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 23:32:29 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AF81D30EC
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 14:12:01 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id s6so30176012lfo.13
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jun 2022 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=yj4Xh9MSBlghRVtBmO7RMyttUbHWlgilMETrV8oTCrU=;
        b=VVHPsnGzaCPYmkZm11oXz5uuPyYBPgG6G8RMBSgwe3ngD4rakjU51JclhwySSTvFJp
         URkexzQ9po5J0RtWNF/9SbtF3EKVjFLiDZ+wG4zEomV0gMB+DwGSXgD/38CDsHnQ4iRk
         kZlHigzzZQYWaJ1Mc7V1uocNTm2GUcOEa9iUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yj4Xh9MSBlghRVtBmO7RMyttUbHWlgilMETrV8oTCrU=;
        b=P9wBeLaEvgU8fbMSWmPwLOIm+Ijicq0SWiqC4isBpFD4U/utYIxcutw5uId4z++YSo
         pFbXfxCfximM2NtzgdfXnu8PqeG6s0TubEvdSWhjF/bU4eZTKDQmYYF1KA22VjDIn8FA
         JP2Yo7s+6X7segX/ofiWsHzEnZO2OsN0JLbUuI7rGDTFZVFM7RRcscgr/S71YLYkLL0t
         lmVGgbCbYEaWCaQsCUQEFrYnuDoc5RBXnH536tVo+kj7mgdxV97bn0LKbrOKxljLeebc
         dNq/2XC0McPirOMZonpiTPx/RupuEnEMG2OOCVi9NV44Elc9V/VzeCXib7ecdzKE2+ji
         2OOQ==
X-Gm-Message-State: AOAM531CyQw5puyVNImDw3UgdFozi1VpN1c2wE+CI42GDb7g01S3SHK/
        aXWmYF4wzVrCW+dzToKDak6ZllUD1h188OHOoOIj0Mx/5tMd2A==
X-Google-Smtp-Source: ABdhPJyH2yNOh+/jZbqFdFBOVONlQjrfgx34q1zbgXtPIcY+NWAKRZAL8z0li3BelbTQb0ceRnKvAHAqpmei79PGJok=
X-Received: by 2002:a19:6917:0:b0:478:fe4c:5b6f with SMTP id
 e23-20020a196917000000b00478fe4c5b6fmr20628635lfc.29.1654636319402; Tue, 07
 Jun 2022 14:11:59 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Tue, 7 Jun 2022 14:11:48 -0700
Message-ID: <CAHZQxyKHeiZkceJgKRYhXFihwTnLa-1pWqicukk7JyV2aBgSNQ@mail.gmail.com>
Subject: [PATCH] scsi_lib: Don't fail the path in ALUA transition state
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error path for the SCSI check condition of not ready, target in
ALUA state transition, will result in the failure of that path after
the retries are exhausted. In most cases that is well ahead of the
transition timeout established in the SCSI ALUA device handler.

Instead, reprep the command and re-add it to the queue after a 1 second
delay. This will allow the handler to take care of the timeout and
only fail the path in the transition state if the target has exceeded
the transition timeout (default 60 seconds).

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
-       blk_mq_requeue_request(rq, true);
+
+       if (msecs) {
+               blk_mq_requeue_request(rq, false);
+               blk_mq_delay_kick_requeue_list(rq->q, msecs);
+       } else
+               blk_mq_requeue_request(rq, true);
 }

 /**
@@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const
struct request *rq)
        return bytes;
 }

-/* Helper for scsi_io_completion() when "reprep" action required. */
-static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
-                                     struct request_queue *q)
-{
-       /* A new command will be prepared and issued. */
-       scsi_mq_requeue_cmd(cmd);
-}
-
 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 {
        struct request *req = scsi_cmd_to_rq(cmd);
@@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct
scsi_cmnd *cmd)
        return false;
 }

+/*
+ * When ALUA transition state is returned, reprep the cmd to
+ * use the ALUA handlers transition timeout. Delay the reprep
+ * 1 sec to avoid aggressive retries of the target in that
+ * state.
+ */
+#define ALUA_TRANSITION_REPREP_DELAY   1000
+
 /* Helper for scsi_io_completion() when special action required. */
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
-       struct request_queue *q = cmd->device->request_queue;
        struct request *req = scsi_cmd_to_rq(cmd);
        int level = 0;
-       enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-             ACTION_DELAYED_RETRY} action;
+       enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
+             ACTION_RETRY, ACTION_DELAYED_RETRY} action;
        struct scsi_sense_hdr sshdr;
        bool sense_valid;
        bool sense_current = true;      /* false implies "deferred sense" */
@@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
                                        action = ACTION_DELAYED_RETRY;
                                        break;
                                case 0x0a: /* ALUA state transition */
-                                       blk_stat = BLK_STS_TRANSPORT;
-                                       fallthrough;
+                                       action = ACTION_DELAYED_REPREP;
+                                       break;
                                default:
                                        action = ACTION_FAIL;
                                        break;
@@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
                        return;
                fallthrough;
        case ACTION_REPREP:
-               scsi_io_completion_reprep(cmd, q);
+               scsi_mq_requeue_cmd(cmd, 0);
+               break;
+       case ACTION_DELAYED_REPREP:
+               scsi_mq_requeue_cmd(cmd, ALUA_TRANSITION_REPREP_DELAY);
                break;
        case ACTION_RETRY:
                /* Retry the same command immediately */
@@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct
scsi_cmnd *cmd, int result,
  * command block will be released and the queue function will be goosed. If we
  * are not done then we have to figure out what to do next:
  *
- *   a) We can call scsi_io_completion_reprep().  The request will be
+ *   a) We can call scsi_mq_requeue_cmd().  The request will be
  *     unprepared and put back on the queue.  Then a new command will
  *     be created for it.  This should be used if we made forward
  *     progress, or if we want to switch from READ(10) to READ(6) for
@@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct
scsi_cmnd *cmd, int result,
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
        int result = cmd->result;
-       struct request_queue *q = cmd->device->request_queue;
        struct request *req = scsi_cmd_to_rq(cmd);
        blk_status_t blk_stat = BLK_STS_OK;

@@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
         * request just queue the command up again.
         */
        if (likely(result == 0))
-               scsi_io_completion_reprep(cmd, q);
+               scsi_mq_requeue_cmd(cmd, 0);
        else
                scsi_io_completion_action(cmd, result);
 }
-- 

Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
