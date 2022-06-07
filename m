Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4D6CCA485
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 00:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347477AbiFHAit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 20:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392638AbiFGW6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 18:58:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A03F325258
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 13:03:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so5608888pjg.5
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jun 2022 13:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DELD8KMeXui2A7kgi36tgonOPUlj758pTn6fyp8eDBE=;
        b=SL6QMzPyvzsE2SzpCpK7uL+PyVlxU842QfV+bf4rTCP20vjfBf8Ox/5Z3HRAqrX4Wq
         Vbqf7yqC/CiB36wbqkpDw3NvfCkwOaSOTcj6VZCxYJNy7k/NPOfiCkJ0eYOwaIUE0Ubj
         26KBEPgJ1z1p/J3Mu6U2ZHqzzPntDwrafyChc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DELD8KMeXui2A7kgi36tgonOPUlj758pTn6fyp8eDBE=;
        b=KSppCR90ztvLp+cEAZyMNMHFS/XcxYY86LlTMnn8SGbx5vQYCpYEd9A3fhwbcWeuC6
         5mdmb+6GW3rG/bp8BCD0LqZgoLH7PWk199ohgT0L0VtjrJeXSyOg3H6LZN+KvzdpSaPa
         AyjIaKawUzHRwECC7PqiPdiqu0JuSs67/4nOAPji2o7Hu0NxmA/JkOgQ0w9MNeuLzbbF
         0bbQ8LGY/QagD9Q/de6vUeq6do6lIdRzDQagIm1yfCdyT1nAmqMmImOe4RLzPfEFtcnv
         TjnUOC+4HKNeF6Na7/bqE5eQ0feN58njFsT9nQienh6HTuqa4RtLW/8ZW48F7Bxvkdw0
         8VvQ==
X-Gm-Message-State: AOAM532onJ+VAsMazPiOOyIOyUfEuM7lWOK9Pvsfk91w9KoYrqn5gFJb
        d+SGECFAQRCYbXbg9B8hcnJdKJTuETcfGRxkZnFhh8dvlv1/Qp5bx/ZjTsECBfWkXgfqNj876UV
        gSjQI8ucvNHBclp0ERBsj9IKYLQgiQ+xQdW34Xc93Cf/9dQQdfxkYmGwIPtmlek4XQu50U0dN62
        eL
X-Google-Smtp-Source: ABdhPJyIM2PAG0V1wyleKN1W6m9NrVMYj5uHBzDHplsF4zr4L0wz8u8cUbWBJGFR6uBGWUW7mhITKA==
X-Received: by 2002:a17:90a:1544:b0:1e0:66c5:4080 with SMTP id y4-20020a17090a154400b001e066c54080mr69010924pja.141.1654632180095;
        Tue, 07 Jun 2022 13:03:00 -0700 (PDT)
Received: from localhost.localdomain (vpn.purestorage.com. [192.30.189.1])
        by smtp.gmail.com with ESMTPSA id a20-20020aa794b4000000b0050dc76281d9sm13734352pfl.179.2022.06.07.13.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 13:02:59 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     Brian Bunker <brian@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>
Subject: [PATCH] scsi_lib: Don't fail the path in ALUA transition state
Date:   Tue,  7 Jun 2022 13:02:54 -0700
Message-Id: <20220607200254.43822-1-brian@purestorage.com>
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

