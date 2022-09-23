Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA9BC04A95
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiIWULv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiIWULs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:11:48 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724F4122637
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:11:47 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id t70so1230622pgc.5
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=A4TYABYz6y9/bmb65u4qFip8B05pooqnyNkuNWA8UwI=;
        b=YeCjjF9bmCzUv6kJVSuEzGu4TePA7HkL/LKJ8A03gQ+m8n6Au9oImU94qsqL0ipwf9
         CIAdhz6JdTbeK9enxQic+wJ4jmXLvx7ffYLUdqL08zLJhy4go9BSMmVmuk8BzeSXVROw
         HfyRGABbQAC5lYc+i4wmBFqyRe3u2Nm6mk1BA39z5fVDBL/FhdkwhyF16nvorHfKjoA4
         nt2vK8sk4W0Nhih37lNBqNeI9dL2MQ9dC/DdVP0U0xTj69BthaRB1btDdu1LEbB65gc0
         cnkLljR+Tu4NfpmqBn9NuGOD+yBYMVCqkB9d3ntr4kqGR1laEA8qsCaURTfqzQrixomp
         RjMg==
X-Gm-Message-State: ACrzQf0JhjpvfoLrjfkq9019XNUJpGvWLkDdJSjoYr7Qdr+7YnBE/HJy
        RBSvPuCQ4a3Ps7JIeQ1LvA3yzCwuBa4=
X-Google-Smtp-Source: AMsMyM4LE1sNvYFlnG8tK6r9fqs2fM6YK5/VTjIuaUXtL7S7LKxMteCFSp9IDvbVzF9ZNLeJ3zQzTw==
X-Received: by 2002:a63:5d48:0:b0:43a:390b:2183 with SMTP id o8-20020a635d48000000b0043a390b2183mr9052543pgm.29.1663963906813;
        Fri, 23 Sep 2022 13:11:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:11:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] scsi: core: Fix a race between scsi_done() and scsi_times_out()
Date:   Fri, 23 Sep 2022 13:11:31 -0700
Message-Id: <20220923201138.2113123-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
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

Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 065990bd198e ("scsi: set timed out out mq requests to complete")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b5fa2aad05f9..6bfb0256b4ce 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -342,19 +342,10 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 
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
+		 * If scsi_done() has already set SCMD_STATE_COMPLETE, return.
 		 */
 		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
-			return BLK_EH_RESET_TIMER;
+			return BLK_EH_DONE;
 		if (scsi_abort_command(scmd) != SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_scmd_add(scmd);
