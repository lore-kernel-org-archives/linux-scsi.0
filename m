Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66CBC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 05:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B936B20714
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 05:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e9NWSUkn";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e9NWSUkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgGZF6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 01:58:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45804 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgGZF6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 01:58:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8B9468EE100;
        Sat, 25 Jul 2020 22:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1595743093;
        bh=pJmubbLb3oIxZWNS8+6h1DwP9BNFFr9nuo2r0MyE+jQ=;
        h=Subject:From:To:Cc:Date:From;
        b=e9NWSUknzkpbQYWdaA+arAOQNI3ozz0y3rVo7XJ+Dp3AgiYfntBCMY4/c3HR5yrEW
         3JTQ+l3T/5Dd3koaAsK2zHkazyUgHRFGXcqmu1BdxZ2DPdH+U7ikj7HWGiUUUuWmz5
         i2YceBvwE0ILmnzTZQXJgA5q9F21xkLZNgwAtC0Q=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RXshDeMSfpyj; Sat, 25 Jul 2020 22:58:13 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 026528EE0EA;
        Sat, 25 Jul 2020 22:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1595743093;
        bh=pJmubbLb3oIxZWNS8+6h1DwP9BNFFr9nuo2r0MyE+jQ=;
        h=Subject:From:To:Cc:Date:From;
        b=e9NWSUknzkpbQYWdaA+arAOQNI3ozz0y3rVo7XJ+Dp3AgiYfntBCMY4/c3HR5yrEW
         3JTQ+l3T/5Dd3koaAsK2zHkazyUgHRFGXcqmu1BdxZ2DPdH+U7ikj7HWGiUUUuWmz5
         i2YceBvwE0ILmnzTZQXJgA5q9F21xkLZNgwAtC0Q=
Message-ID: <1595743091.22874.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.8-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 25 Jul 2020 22:58:11 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Small core patch to fix a corner case bug: we forgot to run the queues
to handle starvation in the error exit from the scsi_queue_rq routine,
which can lead to hangs on error conditions.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ming Lei (1):
      scsi: core: Run queue in case of I/O resource contention failure

And the diffstat:

 drivers/scsi/scsi_lib.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0ba7a65e7c8d..06056e9ec333 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -547,6 +547,15 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	scsi_uninit_cmd(cmd);
 }
 
+static void scsi_run_queue_async(struct scsi_device *sdev)
+{
+	if (scsi_target(sdev)->single_lun ||
+	    !list_empty(&sdev->host->starved_list))
+		kblockd_schedule_work(&sdev->requeue_work);
+	else
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 /* Returns false when no more bytes to process, true if there are more */
 static bool scsi_end_request(struct request *req, blk_status_t error,
 		unsigned int bytes)
@@ -591,11 +600,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 
 	__blk_mq_end_request(req, error);
 
-	if (scsi_target(sdev)->single_lun ||
-	    !list_empty(&sdev->host->starved_list))
-		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(q, true);
+	scsi_run_queue_async(sdev);
 
 	percpu_ref_put(&q->q_usage_counter);
 	return false;
@@ -1702,6 +1707,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 */
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
+		scsi_run_queue_async(sdev);
 		break;
 	}
 	return ret;
