Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628E9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2DA61B39
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhKSUBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:05 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:42984 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhKSUA5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:00:57 -0500
Received: by mail-pg1-f175.google.com with SMTP id t4so2205924pgn.9
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79ANoRxFCQyQSQeGrkbytlrH447uaGQEk6m/ikz4z1g=;
        b=IhTgDJVw7MGzxJ9jAu73rlDFvWTbpmLMuxidpFP5mTlpM9o6GaN+dGrOWQR8XXohM2
         XFWN92Zm+J7npKOS+RElTU/Hw2MncK1dygH4v8W+Mz9WQan0ikFtm5BgD3edX3LohraY
         894k+6z7bn+8Esz+I/lZyzqXCwxpLWn2bnA2JeL8lT9HWUKwKejJAAUn8XqKAEwg8nXa
         BqIqPkfoDQTD0VH8gcC7nwgcuhquhcRNwBlsIWtKBWodbosHXSXMVtqm93SAwyThVX4O
         qhRVpK8c+GTL0vXjlUujIwksldOr34l2GWn6XVVXzOexP1FKnttMGbcFX4hW7Oj5G3oO
         xmvw==
X-Gm-Message-State: AOAM530fDRETCNVYVPTahreA9zdfxDof9ljRkn0XYexmzYjkgEIX4yt4
        7GsjlqLAscicH7stoASv2B2FCH/hnK8=
X-Google-Smtp-Source: ABdhPJyupaaG8umPQO1XanzKaLCJHgehOPsJGkmaLGMstZ6q/vFoOqprf9PCq8QKf3KaH8SMzshX4g==
X-Received: by 2002:a63:4f42:: with SMTP id p2mr19148217pgl.381.1637351875373;
        Fri, 19 Nov 2021 11:57:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 04/20] scsi: core: Fix a race between scsi_done() and scsi_times_out()
Date:   Fri, 19 Nov 2021 11:57:27 -0800
Message-Id: <20211119195743.2817-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch restores the behavior of the following algorithm from the legacy
block layer:
- Before completing a request, test-and-set REQ_ATOM_COMPLETE atomically.
  Only call the block driver completion function if that flag was not yet
  set.
- Before calling the block driver timeout function, test-and-set
  REQ_ATOM_COMPLETE atomically. Only call the timeout handler if that flag
  was not yet set. If that flag was already set, do not restart the timer.

Cc: Keith Busch <kbusch@kernel.org>
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 065990bd198e ("scsi: set timed out out mq requests to complete")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9cb0f9df621a..cd05f2db3339 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -331,6 +331,14 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	enum blk_eh_timer_return rtn = BLK_EH_DONE;
 	struct Scsi_Host *host = scmd->device->host;
 
+	/*
+	 * scsi_done() may be called concurrently with scsi_times_out(). Only
+	 * one of these two functions should proceed. Hence return early if
+	 * scsi_done() won the race.
+	 */
+	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
+		return BLK_EH_DONE;
+
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
@@ -341,20 +349,6 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (rtn == BLK_EH_DONE) {
-		/*
-		 * Set the command to complete first in order to prevent a real
-		 * completion from releasing the command while error handling
-		 * is using it. If the command was already completed, then the
-		 * lower level driver beat the timeout handler, and it is safe
-		 * to return without escalating error recovery.
-		 *
-		 * If timeout handling lost the race to a real completion, the
-		 * block layer may ignore that due to a fake timeout injection,
-		 * so return RESET_TIMER to allow error handling another shot
-		 * at this command.
-		 */
-		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
-			return BLK_EH_RESET_TIMER;
 		if (scsi_abort_command(scmd) != SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_scmd_add(scmd);
