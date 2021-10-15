Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22B6C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 998526120A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbhJOPQh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:16:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50778 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240840AbhJOPQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 11:16:36 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634310868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w48GmUtrByyn7yHGg7JhSjj9SDZrPX8KgOLSu7dqDTM=;
        b=EzbhwnV8RyW75gNK2HAUscKuXOCZZPQNOwZaYAVjP0XyY1AlTUdNbKDmZkOLqwaeI5EXJe
        1VdUJvQ6wh3Oi5PWK7J/QEVr2YeSsP2jTY5AsMUmFYmZls41idZDdd4PvcIIC5bh2XR+DX
        sZKPN5uR+ae2YQgGwP3BV7gfeMcTbv9ziKhFa7Jb7LCToKtmDvPGQIMQUcSvykCICVeuG0
        9FlVL+KOWI4Q0l0sDKnxahXJfWsfAGRNB1cLMMh64ggIThcyDe9Z9iO6G11c5E4CFGmpRB
        mHq6qA5ZedHzFSOuwDYsdZ4Hl8sHZrtEv5gd0hfY0Ac1Fbo5b7htaM1kiO/KOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634310868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w48GmUtrByyn7yHGg7JhSjj9SDZrPX8KgOLSu7dqDTM=;
        b=5sFeCDNOTqoUw5PGCg7hYbUv1xXyRpcer3II/ar1BKldck5BlKSOQy/ut4BED0W0gI6mNM
        EFmC0P5oAXY1lcDg==
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 2/3] mmc: core: Use blk_mq_complete_request_direct().
Date:   Fri, 15 Oct 2021 17:14:11 +0200
Message-Id: <20211015151412.3229037-3-bigeasy@linutronix.de>
In-Reply-To: <20211015151412.3229037-1-bigeasy@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The completion callback for the sdhci-pci device is invoked from a
kworker.
I couldn't identify in which context is mmc_blk_mq_req_done() invoke but
the remaining caller are from invoked from preemptible context. Here it
would make sense to complete the request directly instead scheduling
ksoftirqd for its completion.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/mmc/core/block.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 431af5e8be2f8..16b4ea0e92c4b 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2051,7 +2051,8 @@ static void mmc_blk_mq_dec_in_flight(struct mmc_queue=
 *mq, struct request *req)
 		mmc_put_card(mq->card, &mq->ctx);
 }
=20
-static void mmc_blk_mq_post_req(struct mmc_queue *mq, struct request *req)
+static void mmc_blk_mq_post_req(struct mmc_queue *mq, struct request *req,
+				bool can_sleep)
 {
 	struct mmc_queue_req *mqrq =3D req_to_mmc_queue_req(req);
 	struct mmc_request *mrq =3D &mqrq->brq.mrq;
@@ -2065,8 +2066,12 @@ static void mmc_blk_mq_post_req(struct mmc_queue *mq=
, struct request *req)
 	 */
 	if (mq->in_recovery)
 		mmc_blk_mq_complete_rq(mq, req);
-	else if (likely(!blk_should_fake_timeout(req->q)))
-		blk_mq_complete_request(req);
+	else if (likely(!blk_should_fake_timeout(req->q))) {
+		if (can_sleep)
+			blk_mq_complete_request_direct(req);
+		else
+			blk_mq_complete_request(req);
+	}
=20
 	mmc_blk_mq_dec_in_flight(mq, req);
 }
@@ -2087,7 +2092,7 @@ void mmc_blk_mq_recovery(struct mmc_queue *mq)
=20
 	mmc_blk_urgent_bkops(mq, mqrq);
=20
-	mmc_blk_mq_post_req(mq, req);
+	mmc_blk_mq_post_req(mq, req, true);
 }
=20
 static void mmc_blk_mq_complete_prev_req(struct mmc_queue *mq,
@@ -2106,7 +2111,7 @@ static void mmc_blk_mq_complete_prev_req(struct mmc_q=
ueue *mq,
 	if (prev_req)
 		*prev_req =3D mq->complete_req;
 	else
-		mmc_blk_mq_post_req(mq, mq->complete_req);
+		mmc_blk_mq_post_req(mq, mq->complete_req, true);
=20
 	mq->complete_req =3D NULL;
=20
@@ -2178,7 +2183,8 @@ static void mmc_blk_mq_req_done(struct mmc_request *m=
rq)
 	mq->rw_wait =3D false;
 	wake_up(&mq->wait);
=20
-	mmc_blk_mq_post_req(mq, req);
+	/* context unknown */
+	mmc_blk_mq_post_req(mq, req, false);
 }
=20
 static bool mmc_blk_rw_wait_cond(struct mmc_queue *mq, int *err)
@@ -2238,7 +2244,7 @@ static int mmc_blk_mq_issue_rw_rq(struct mmc_queue *m=
q,
 	err =3D mmc_start_request(host, &mqrq->brq.mrq);
=20
 	if (prev_req)
-		mmc_blk_mq_post_req(mq, prev_req);
+		mmc_blk_mq_post_req(mq, prev_req, true);
=20
 	if (err)
 		mq->rw_wait =3D false;
--=20
2.33.0

