Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169FBC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiI2WAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiI2WAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:00:34 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD336127CA1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:32 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id w2so2637292pfb.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=O1DkugD4gXENlmzbEb7gYt3Fi1wxgizUir5A5yiHk7Y=;
        b=mic6a+Wbe5skutpCKjjL5gy6bLrZ8pxGXmb2tt6qwdvPPkSw1TbwnjvopEn8yUJqTQ
         ji2wNCbwux6+esy4SgmQ0k4ycJo3ng4c0Y7VWnipHxbl17zQ6yl/t77YuA4wCgCVGEGi
         zY//279xot2kVfHz2jqzfQJ6wMe8xQ7HXgIQfO4+qilKHQFJBuO5dyhqdMB5U69vxpYd
         EoxI79NUF96iZ2uJSCJgkrsPJEDpqFcO/IAWm0RPgRNmFdZ/uGx1ignMa4BG1V0kwU7N
         +XSkNueCl1aHB3bwroBG/xgCdi3GWzS2Zx3zXiXRavhJv3O/80mmTQDSiSnvIICGvvC6
         wp0Q==
X-Gm-Message-State: ACrzQf0gBB+go4l8Bf8lG77zs8HDh+3yyoe9Y8z3xpXdtvcMRzZDl/yV
        7BTLCvTqlQTGHI8G9T+5JSw=
X-Google-Smtp-Source: AMsMyM5NKjE3bUIhlGXD2N/Qq/BBfxHvzw/L7OpBIaFlZWU9JtYrWnq0ckLpQtxpaHXzrlCCckHOlg==
X-Received: by 2002:a63:83c7:0:b0:440:4261:44ab with SMTP id h190-20020a6383c7000000b00440426144abmr4741165pge.266.1664488831746;
        Thu, 29 Sep 2022 15:00:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:00:31 -0700 (PDT)
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
Subject: [PATCH v3 1/8] scsi: core: Fix a race between scsi_done() and scsi_timeout()
Date:   Thu, 29 Sep 2022 15:00:14 -0700
Message-Id: <20220929220021.247097-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_error.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 16bd0adc2339..d1b07ff64a96 100644
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
