Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11810C3B187
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF195206DB
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VYb7tESd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgBKMM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:12:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728629AbgBKMM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 07:12:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B0NLt7jSWmmwehEELmRWoiWSF3chC1MReX7sLahxdAA=;
        b=VYb7tESdUvOXeMdtOaZo7rQ9FQ32viLZNeNWdYf02CRjNcq9LCQGWAuUkP95yXU1VLJwlS
        Wj8GzUeo6+upu+aewCjsj+zYKbSPeItZ5GkYCbp2uD4qdfxDYrNC094/usH/ZsXMqqXntR
        wewuWjQ7xlTIeCqXcekrURbJiNO91PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-YKnLXtlZOTuRkHIgLJyzww-1; Tue, 11 Feb 2020 07:12:54 -0500
X-MC-Unique: YKnLXtlZOTuRkHIgLJyzww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AF4D109005B;
        Tue, 11 Feb 2020 12:12:52 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 329E989F2E;
        Tue, 11 Feb 2020 12:12:50 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 08/10] blk-mq: pass budget token to dirver via blk_mq_queue_data
Date:   Tue, 11 Feb 2020 20:11:33 +0800
Message-Id: <20200211121135.30064-9-ming.lei@redhat.com>
In-Reply-To: <20200211121135.30064-1-ming.lei@redhat.com>
References: <20200211121135.30064-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass the budget token to driver via blk_mq_queue_dada before calling
.queue_rq(), and prepare for tracing SCSI's device_busy via
sbitmap_queue.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 25 +++++++++++++------------
 include/linux/blk-mq.h |  1 +
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 43ae2b973d99..013272cad500 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1235,6 +1235,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *=
q, struct list_head *list,
 		list_del_init(&rq->queuelist);
=20
 		bd.rq =3D rq;
+		bd.budget_token =3D budget_token;
=20
 		/*
 		 * Flag last if we have no more requests, or if we have more
@@ -1778,14 +1779,11 @@ static void blk_mq_bio_to_request(struct request =
*rq, struct bio *bio,
 }
=20
 static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
-					    struct request *rq,
-					    blk_qc_t *cookie, bool last)
+					    struct blk_mq_queue_data *bd,
+					    blk_qc_t *cookie)
 {
+	struct request *rq =3D bd->rq;
 	struct request_queue *q =3D rq->q;
-	struct blk_mq_queue_data bd =3D {
-		.rq =3D rq,
-		.last =3D last,
-	};
 	blk_qc_t new_cookie;
 	blk_status_t ret;
=20
@@ -1796,7 +1794,7 @@ static blk_status_t __blk_mq_issue_directly(struct =
blk_mq_hw_ctx *hctx,
 	 * Any other error (busy), just add it to our list as we
 	 * previously would have done.
 	 */
-	ret =3D q->mq_ops->queue_rq(hctx, &bd);
+	ret =3D q->mq_ops->queue_rq(hctx, bd);
 	switch (ret) {
 	case BLK_STS_OK:
 		blk_mq_update_dispatch_busy(hctx, false);
@@ -1823,7 +1821,10 @@ static blk_status_t __blk_mq_try_issue_directly(st=
ruct blk_mq_hw_ctx *hctx,
 {
 	struct request_queue *q =3D rq->q;
 	bool run_queue =3D true;
-	int budget_token;
+	struct blk_mq_queue_data bd =3D {
+		.rq =3D rq,
+		.last =3D last,
+	};
=20
 	/*
 	 * RCU or SRCU read lock is needed before checking quiesced flag.
@@ -1841,16 +1842,16 @@ static blk_status_t __blk_mq_try_issue_directly(s=
truct blk_mq_hw_ctx *hctx,
 	if (q->elevator && !bypass_insert)
 		goto insert;
=20
-	budget_token =3D blk_mq_get_dispatch_budget(hctx);
-	if (budget_token < 0)
+	bd.budget_token =3D blk_mq_get_dispatch_budget(hctx);
+	if (bd.budget_token < 0)
 		goto insert;
=20
 	if (!blk_mq_get_driver_tag(rq)) {
-		blk_mq_put_dispatch_budget(hctx, budget_token);
+		blk_mq_put_dispatch_budget(hctx, bd.budget_token);
 		goto insert;
 	}
=20
-	return __blk_mq_issue_directly(hctx, rq, cookie, last);
+	return __blk_mq_issue_directly(hctx, &bd, cookie);
 insert:
 	if (bypass_insert)
 		return BLK_STS_RESOURCE;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 6fd8d7cfe158..42b59b97bfd8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,6 +259,7 @@ struct blk_mq_tag_set {
  */
 struct blk_mq_queue_data {
 	struct request *rq;
+	int budget_token;
 	bool last;
 };
=20
--=20
2.20.1

