Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EE4C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJRUaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJRUaK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:30:10 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F595AC45
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:07 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id q9so14304179pgq.8
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sI/dzcGREmlHCkC0OWnt5bTDUYQNzGOxqc0FBR07cM=;
        b=bJSM5WluKstECC24mxNeO8I7B3OS2zqQ9IftlDz8oFYqC+Od/UC++Qg3aSpyjInSNE
         wkR6bLuQWAOn1VybBFLCGrR8GewM97KY8jN/cnGSydHzBcFwD5YoI03d0H2HPTpVAuMu
         yo/Mo7xFcCl55fLEIi69Jk2gOinHBEh5w8Z4LW8v0ySuJZUF+vsCc1btkcg8Af2QTE7J
         kqJhK//iVPgEc184v8oYf2lwuwa8x+V2fabNAqMamKBsLmySZeIMc4VzfsePX2Z/mCsn
         u0q92/W/1NItWG42qrEvUvUAgWJn7Y1iM9X6bDQ+5Y4Ib5gR+LhtWw8y1uwQCp84MiIu
         9fZA==
X-Gm-Message-State: ACrzQf2uNK8g21mYo2DoNpA67HqbFpiNxKqUBR9pigUz7sV4swkvuAdt
        nVqVeOo1aZnzw9n7ImjED7Y=
X-Google-Smtp-Source: AMsMyM6E7zBMb5Jp2LIpJykBYYxNxIOu+gD8zLfAf78ZCi8ciN4+RWgxYbrtJnNTuXpmhymeIpMpQw==
X-Received: by 2002:a63:5a05:0:b0:434:23a5:a5ca with SMTP id o5-20020a635a05000000b0043423a5a5camr4118237pgb.515.1666125006452;
        Tue, 18 Oct 2022 13:30:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:30:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daniel Wagner <dwagner@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4 01/10] scsi: core: Fix a race between scsi_done() and scsi_timeout()
Date:   Tue, 18 Oct 2022 13:29:49 -0700
Message-Id: <20221018202958.1902564-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If there is a race between scsi_done() and scsi_timeout() and if
scsi_timeout() loses the race, scsi_timeout() should not reset the
request timer. Hence change the return value for this case from
BLK_EH_RESET_TIMER into BLK_EH_DONE.

Although the block layer holds a reference on a request (req->ref) while
calling a timeout handler, restarting the timer (blk_add_timer()) while
a request is being completed is racy.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 15f73f5b3e59 ("blk-mq: move failure injection out of blk_mq_complete_request")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6995c8979230..02520f912306 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -343,19 +343,11 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 
 	if (rtn == BLK_EH_DONE) {
 		/*
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
+		 * If scsi_done() has already set SCMD_STATE_COMPLETE, do not
+		 * modify *scmd.
 		 */
 		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
-			return BLK_EH_RESET_TIMER;
+			return BLK_EH_DONE;
 		if (scsi_abort_command(scmd) != SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_scmd_add(scmd);
