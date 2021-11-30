Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36F5C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbhK3Xg4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:36:56 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:35571 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhK3Xgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:36:54 -0500
Received: by mail-pg1-f182.google.com with SMTP id j11so11634762pgs.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:33:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79ANoRxFCQyQSQeGrkbytlrH447uaGQEk6m/ikz4z1g=;
        b=42ptKKzajKErzT44E8K2iaTmje2eLTMYuBzcF83UzP1zUs94t9I7RzGDewuEVqmSYN
         FCPOmcN7cS3wVdTeEhp53kvQvD9a04QVCuOXZsIzVTn9tuOq4i40CCpRjCsGomZDC2CO
         rsOMmj9tHHHOeGYtOnvKl1jOAJacidW50U4gta5lqMOcyU/VOq+6sFnU5wAKhjk0Nt44
         uzqBdjHWdiSEhcTsXwp2WNS3pTrPUnes8uk3LFcc4dkqfJSxy+ktqG2cAmGgpBLBUTjw
         VHTZOwuE28R/bKjiAzAZYwOXVtJ+ykmqA9hEZHDYu75XFqLxVJ5s/VH0H7aYJDJz4Plx
         z09w==
X-Gm-Message-State: AOAM530G3am3Qhtk1PlRZf4JO9W09Jez2dcCDnlROvRcRYy3/EpTJMmi
        ylYtu7r//4sn4Y0dImbdAuB8AMepCuc=
X-Google-Smtp-Source: ABdhPJwI1oFULDV9YKeuO1EkUc6vtVjokVMM3+vaMGYn3k5yoNw5Pes5sm+2hUWrTBYSxA4ARKCz/A==
X-Received: by 2002:a63:1016:: with SMTP id f22mr1853259pgl.566.1638315213916;
        Tue, 30 Nov 2021 15:33:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 02/17] scsi: core: Fix a race between scsi_done() and scsi_times_out()
Date:   Tue, 30 Nov 2021 15:33:09 -0800
Message-Id: <20211130233324.1402448-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
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
