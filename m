Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5305BC6FA86
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiI0Snk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiI0Snf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:43:35 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA791C459A
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:32 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id lx7so3703491pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=O1DkugD4gXENlmzbEb7gYt3Fi1wxgizUir5A5yiHk7Y=;
        b=LY0JYF1Buv56FpiP2AvWpn3fkKLXgGOXvQzdURrfKVNbCb4UBYaiEOJ69BoTfSNpBa
         9NstcVBd+cO4z4YOAS0BtcU+JYKmQCvD/gcE0u2JJCe+vtgsPS86yZfRzs7Bt2mH5Y94
         83C6arju/oIelKr0JbLsPwMxGzosLGKRFIExlNTgqGg75P8yRu7edrYzc41Nb8cZkWse
         14+TcmlpvTycX8vlINDmg8pgTSYvXy3d7jGnzbGHWYtW0jONN/MPQLQa1N7b+aAvEC2D
         gdg0H5nCh44TCC/OPYshGOVJ0dCMr8pvd9Un7EAIC0XsBh/P2jWTUYXUO0wPQ8a5oLU5
         Wmxw==
X-Gm-Message-State: ACrzQf3fw/n77/vDurqewZpnITao3mF5ljAii8divrXhP8x5q1/KYUt+
        TOhKZkDTFqREt8kha5OcLFc=
X-Google-Smtp-Source: AMsMyM7Rpj1KjW5fT+rxWZaZfcbW8tUw6BvhYdKXGwM5tBu38xA+1UuryTDWoL4CElbkJOFVTw4wQg==
X-Received: by 2002:a17:90a:3806:b0:202:880e:81d with SMTP id w6-20020a17090a380600b00202880e081dmr5948805pjb.161.1664304211132;
        Tue, 27 Sep 2022 11:43:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:43:30 -0700 (PDT)
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
Subject: [PATCH v2 1/8] scsi: core: Fix a race between scsi_done() and scsi_timeout()
Date:   Tue, 27 Sep 2022 11:43:02 -0700
Message-Id: <20220927184309.2223322-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
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
