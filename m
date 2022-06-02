Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E54C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 15:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiFBPKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 11:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbiFBPKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 11:10:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972B324F973
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 08:10:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id a15so8276572lfb.9
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jun 2022 08:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=6NfkW5JMaVICtv/C0jimSKQK8dl9VxjPHhVbMHjyNJY=;
        b=j2RhTGzUr+OH1cmGnu7Rbsd9iqNqZb5HHquym7srNxBlGGMJM74YaNPh9VWV+onkoQ
         G6zNSDIq5F1FJ4nRqqXeokv2e2K4OzMg2fV7PFC1QxMy0TMzv981rQYM2iaYnEPG2/m6
         sg4cQlb6m+dm+X2ro71OGczlY1Wt8EZ8KkO9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6NfkW5JMaVICtv/C0jimSKQK8dl9VxjPHhVbMHjyNJY=;
        b=5viPAt+pFqeOO2W7FrK+tIpxmJw8VQJddfFaqwoqcMb3EWxssEKk6IWRD+UR16lS+J
         kc4DWACm8m7NzsSONVVRS4/4ZKhYl+qJ7EYRQl5K4/1zGZxbgoIyiRxtnOfN6YnYuyeZ
         QXCS9HwdMaO79//nMy+P1NBT517XKfVTXjhm9vDH2OnY0u7B0guDNf4pgWsYpuvmjjVG
         frJTb1v+21xtUNhKYysKm1N498/S+3/vI6hBNWLxQ7OgfP9M60cDtpr+1pkh1YqiwzuZ
         D+9LSW8M2jDEEPQawmRRHUHJ6A35AbJc77LYWdLxy1kT0Dawc8a/yoKhdsajyVaihp7i
         YPfA==
X-Gm-Message-State: AOAM530349+O4Yi00Nc1vBwy2A/wrZXpcrMyyvtr9eQiKLKERr4cX3M+
        pRsGjh+jij/21Qv9PzQ+f3uLc9RmYDgKsFt/iNSVTtJPsZVQ8Q==
X-Google-Smtp-Source: ABdhPJxgHD0UAucMkZA5Br5Zp3lc3Keyq/friEqnbQhkY+kaspFGHjcg6/oXemQLPMMDHVl/Cy5n8NgexYnTcdW0jhA=
X-Received: by 2002:a05:6512:318b:b0:478:eddd:8c6b with SMTP id
 i11-20020a056512318b00b00478eddd8c6bmr4004571lfe.324.1654182639497; Thu, 02
 Jun 2022 08:10:39 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Thu, 2 Jun 2022 08:10:28 -0700
Message-ID: <CAHZQxyKMcCaquQ9n8pJ9tNb3HRZ2e14iXXojYS3C4=dB6NpUKQ@mail.gmail.com>
Subject: [PATCH] scsi_lib: allow the ALUA transitioning state time to complete
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Don't fail the path in ALUA transition state

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
___

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9db7da0c79c..2a75f740914c 100644
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
@@ -660,10 +665,10 @@ static unsigned int scsi_rq_err_bytes(const
struct request *rq)

 /* Helper for scsi_io_completion() when "reprep" action required. */
 static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
-                                     struct request_queue *q)
+                                     struct request_queue *q,
unsigned long msecs)
 {
        /* A new command will be prepared and issued. */
-       scsi_mq_requeue_cmd(cmd);
+       scsi_mq_requeue_cmd(cmd, msecs);
 }

 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
@@ -683,14 +688,22 @@ static bool scsi_cmd_runtime_exceeced(struct
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
        struct request_queue *q = cmd->device->request_queue;
        struct request *req = scsi_cmd_to_rq(cmd);
        int level = 0;
-       enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-             ACTION_DELAYED_RETRY} action;
+       enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
+             ACTION_RETRY, ACTION_DELAYED_RETRY} action;
        struct scsi_sense_hdr sshdr;
        bool sense_valid;
        bool sense_current = true;      /* false implies "deferred sense" */
@@ -779,8 +792,8 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
                                        action = ACTION_DELAYED_RETRY;
                                        break;
                                case 0x0a: /* ALUA state transition */
-                                       blk_stat = BLK_STS_AGAIN;
-                                       fallthrough;
+                                       action = ACTION_DELAYED_REPREP;
+                                       break;
                                default:
                                        action = ACTION_FAIL;
                                        break;
@@ -839,7 +852,10 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
                        return;
                fallthrough;
        case ACTION_REPREP:
-               scsi_io_completion_reprep(cmd, q);
+               scsi_io_completion_reprep(cmd, q, 0);
+               break;
+       case ACTION_DELAYED_REPREP:
+               scsi_io_completion_reprep(cmd, q, ALUA_TRANSITION_REPREP_DELAY);
                break;
        case ACTION_RETRY:
                /* Retry the same command immediately */
@@ -986,7 +1002,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
         * request just queue the command up again.
         */
        if (likely(result == 0))
-               scsi_io_completion_reprep(cmd, q);
+               scsi_io_completion_reprep(cmd, q, 0);
        else
                scsi_io_completion_action(cmd, result);
 }

-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
