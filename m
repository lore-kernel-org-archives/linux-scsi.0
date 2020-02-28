Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C847FC3F2D2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FCC92469C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4OUZhA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgB1XaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:30:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726561AbgB1XaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 18:30:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582932614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fy0lLVurOeeWBy1Pme0N9KiPrE/JtC6PTNzIax1tFi8=;
        b=W4OUZhA9H9bXoUB+FmuNZVgywr7VPrvlPxE84D+K0A+eOFrX+XqXPL/JzMp48WQ6n+74wZ
        ThXKMNkCgx1bDiH36qQY8uTeGdlaHwy9I056GHCSDCJ7PZaj2tgyuuv4wkh15KQhCTXkkQ
        91N8lbpeK2WZGLpN4aX/OmQNaKRXJro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-dv_bP4uyOSGp_c9GAdvUfw-1; Fri, 28 Feb 2020 18:30:10 -0500
X-MC-Unique: dv_bP4uyOSGp_c9GAdvUfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E51F13EA;
        Fri, 28 Feb 2020 23:30:08 +0000 (UTC)
Received: from localhost (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DBFA60BF1;
        Fri, 28 Feb 2020 23:30:03 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
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
Subject: [PATCH V2 07/10] blk-mq: return budget token from .get_budget callback
Date:   Sat, 29 Feb 2020 07:29:17 +0800
Message-Id: <20200228232920.20960-8-ming.lei@redhat.com>
In-Reply-To: <20200228232920.20960-1-ming.lei@redhat.com>
References: <20200228232920.20960-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI uses one global atomic variable to track queue depth for each
LUN/request queue.

This way doesn't scale well when there is lots of CPU cores and the
disk is very fast. It has been observed that IOPS is affected a lot
by tracking queue depth via sdev->device_busy in IO path.

Return budget token from .get_budget callback, and the budget token
can be passed to driver, so that we can replace the atomic variable
with sbitmap_queue, then the scale issue can be fixed.

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
 block/blk-mq-sched.c    | 20 ++++++++++++--------
 block/blk-mq.c          | 18 ++++++++++++------
 block/blk-mq.h          | 11 ++++++-----
 drivers/scsi/scsi_lib.c | 10 +++++-----
 include/linux/blk-mq.h  |  4 ++--
 5 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index ca22afd47b3d..38dee68ba04a 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -90,6 +90,7 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_c=
tx *hctx)
 	struct request_queue *q =3D hctx->queue;
 	struct elevator_queue *e =3D q->elevator;
 	LIST_HEAD(rq_list);
+	int budget_token;
=20
 	do {
 		struct request *rq;
@@ -97,12 +98,13 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw=
_ctx *hctx)
 		if (e->type->ops.has_work && !e->type->ops.has_work(hctx))
 			break;
=20
-		if (!blk_mq_get_dispatch_budget(hctx))
+		budget_token =3D blk_mq_get_dispatch_budget(hctx);
+		if (budget_token < 0)
 			break;
=20
 		rq =3D e->type->ops.dispatch_request(hctx);
 		if (!rq) {
-			blk_mq_put_dispatch_budget(hctx);
+			blk_mq_put_dispatch_budget(hctx, budget_token);
 			break;
 		}
=20
@@ -112,7 +114,7 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw=
_ctx *hctx)
 		 * in blk_mq_dispatch_rq_list().
 		 */
 		list_add(&rq->queuelist, &rq_list);
-	} while (blk_mq_dispatch_rq_list(q, &rq_list, true));
+	} while (blk_mq_dispatch_rq_list(q, &rq_list, budget_token));
 }
=20
 static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
@@ -136,6 +138,7 @@ static void blk_mq_do_dispatch_ctx(struct blk_mq_hw_c=
tx *hctx)
 	struct request_queue *q =3D hctx->queue;
 	LIST_HEAD(rq_list);
 	struct blk_mq_ctx *ctx =3D READ_ONCE(hctx->dispatch_from);
+	int budget_token;
=20
 	do {
 		struct request *rq;
@@ -143,12 +146,13 @@ static void blk_mq_do_dispatch_ctx(struct blk_mq_hw=
_ctx *hctx)
 		if (!sbitmap_any_bit_set(&hctx->ctx_map))
 			break;
=20
-		if (!blk_mq_get_dispatch_budget(hctx))
+		budget_token =3D blk_mq_get_dispatch_budget(hctx);
+		if (budget_token < 0)
 			break;
=20
 		rq =3D blk_mq_dequeue_from_ctx(hctx, ctx);
 		if (!rq) {
-			blk_mq_put_dispatch_budget(hctx);
+			blk_mq_put_dispatch_budget(hctx, budget_token);
 			break;
 		}
=20
@@ -162,7 +166,7 @@ static void blk_mq_do_dispatch_ctx(struct blk_mq_hw_c=
tx *hctx)
 		/* round robin for fair dispatch */
 		ctx =3D blk_mq_next_ctx(hctx, rq->mq_ctx);
=20
-	} while (blk_mq_dispatch_rq_list(q, &rq_list, true));
+	} while (blk_mq_dispatch_rq_list(q, &rq_list, budget_token));
=20
 	WRITE_ONCE(hctx->dispatch_from, ctx);
 }
@@ -206,7 +210,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_=
ctx *hctx)
 	 */
 	if (!list_empty(&rq_list)) {
 		blk_mq_sched_mark_restart_hctx(hctx);
-		if (blk_mq_dispatch_rq_list(q, &rq_list, false)) {
+		if (blk_mq_dispatch_rq_list(q, &rq_list, -1)) {
 			if (has_sched_dispatch)
 				blk_mq_do_dispatch_sched(hctx);
 			else
@@ -219,7 +223,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_=
ctx *hctx)
 		blk_mq_do_dispatch_ctx(hctx);
 	} else {
 		blk_mq_flush_busy_ctxs(hctx, &rq_list);
-		blk_mq_dispatch_rq_list(q, &rq_list, false);
+		blk_mq_dispatch_rq_list(q, &rq_list, -1);
 	}
 }
=20
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 76a5e919c336..43ae2b973d99 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1182,13 +1182,14 @@ static void blk_mq_update_dispatch_busy(struct bl=
k_mq_hw_ctx *hctx, bool busy)
  * Returns true if we did some work AND can potentially do more.
  */
 bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *=
list,
-			     bool got_budget)
+			     int budget_token)
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct request *rq, *nxt;
 	bool no_tag =3D false;
 	int errors, queued;
 	blk_status_t ret =3D BLK_STS_OK;
+	bool got_budget =3D budget_token >=3D 0;
=20
 	if (list_empty(list))
 		return false;
@@ -1205,8 +1206,11 @@ bool blk_mq_dispatch_rq_list(struct request_queue =
*q, struct list_head *list,
 		rq =3D list_first_entry(list, struct request, queuelist);
=20
 		hctx =3D rq->mq_hctx;
-		if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
-			break;
+		if (!got_budget) {
+			budget_token =3D blk_mq_get_dispatch_budget(hctx);
+			if (budget_token < 0)
+				break;
+		}
=20
 		if (!blk_mq_get_driver_tag(rq)) {
 			/*
@@ -1217,7 +1221,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *=
q, struct list_head *list,
 			 * we'll re-run it below.
 			 */
 			if (!blk_mq_mark_tag_wait(hctx, rq)) {
-				blk_mq_put_dispatch_budget(hctx);
+				blk_mq_put_dispatch_budget(hctx, budget_token);
 				/*
 				 * For non-shared tags, the RESTART check
 				 * will suffice.
@@ -1819,6 +1823,7 @@ static blk_status_t __blk_mq_try_issue_directly(str=
uct blk_mq_hw_ctx *hctx,
 {
 	struct request_queue *q =3D rq->q;
 	bool run_queue =3D true;
+	int budget_token;
=20
 	/*
 	 * RCU or SRCU read lock is needed before checking quiesced flag.
@@ -1836,11 +1841,12 @@ static blk_status_t __blk_mq_try_issue_directly(s=
truct blk_mq_hw_ctx *hctx,
 	if (q->elevator && !bypass_insert)
 		goto insert;
=20
-	if (!blk_mq_get_dispatch_budget(hctx))
+	budget_token =3D blk_mq_get_dispatch_budget(hctx);
+	if (budget_token < 0)
 		goto insert;
=20
 	if (!blk_mq_get_driver_tag(rq)) {
-		blk_mq_put_dispatch_budget(hctx);
+		blk_mq_put_dispatch_budget(hctx, budget_token);
 		goto insert;
 	}
=20
diff --git a/block/blk-mq.h b/block/blk-mq.h
index eaaca8fc1c28..1c82d89791c0 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -40,7 +40,7 @@ struct blk_mq_ctx {
 void blk_mq_exit_queue(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
-bool blk_mq_dispatch_rq_list(struct request_queue *, struct list_head *,=
 bool);
+bool blk_mq_dispatch_rq_list(struct request_queue *, struct list_head *,=
 int);
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 				bool kick_requeue_list);
 void blk_mq_flush_busy_ctxs(struct blk_mq_hw_ctx *hctx, struct list_head=
 *list);
@@ -179,21 +179,22 @@ unsigned int blk_mq_in_flight(struct request_queue =
*q, struct hd_struct *part);
 void blk_mq_in_flight_rw(struct request_queue *q, struct hd_struct *part=
,
 			 unsigned int inflight[2]);
=20
-static inline void blk_mq_put_dispatch_budget(struct blk_mq_hw_ctx *hctx=
)
+static inline void blk_mq_put_dispatch_budget(struct blk_mq_hw_ctx *hctx=
,
+					      int budget_token)
 {
 	struct request_queue *q =3D hctx->queue;
=20
 	if (q->mq_ops->put_budget)
-		q->mq_ops->put_budget(hctx);
+		q->mq_ops->put_budget(hctx, budget_token);
 }
=20
-static inline bool blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx=
)
+static inline int blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q =3D hctx->queue;
=20
 	if (q->mq_ops->get_budget)
 		return q->mq_ops->get_budget(hctx);
-	return true;
+	return 0;
 }
=20
 static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..c8eb555b3ce8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1619,7 +1619,7 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
 }
=20
-static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
+static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx, int budget_to=
ken)
 {
 	struct request_queue *q =3D hctx->queue;
 	struct scsi_device *sdev =3D q->queuedata;
@@ -1627,17 +1627,17 @@ static void scsi_mq_put_budget(struct blk_mq_hw_c=
tx *hctx)
 	atomic_dec(&sdev->device_busy);
 }
=20
-static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
+static int scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q =3D hctx->queue;
 	struct scsi_device *sdev =3D q->queuedata;
=20
 	if (scsi_dev_queue_ready(q, sdev))
-		return true;
+		return 0;
=20
 	if (atomic_read(&sdev->device_busy) =3D=3D 0 && !scsi_device_blocked(sd=
ev))
 		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
-	return false;
+	return -1;
 }
=20
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
@@ -1701,7 +1701,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
 	if (scsi_target(sdev)->can_queue > 0)
 		atomic_dec(&scsi_target(sdev)->target_busy);
 out_put_budget:
-	scsi_mq_put_budget(hctx);
+	scsi_mq_put_budget(hctx, 0);
 	switch (ret) {
 	case BLK_STS_OK:
 		break;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 11cfd6470b1a..6fd8d7cfe158 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -265,8 +265,8 @@ struct blk_mq_queue_data {
 typedef blk_status_t (queue_rq_fn)(struct blk_mq_hw_ctx *,
 		const struct blk_mq_queue_data *);
 typedef void (commit_rqs_fn)(struct blk_mq_hw_ctx *);
-typedef bool (get_budget_fn)(struct blk_mq_hw_ctx *);
-typedef void (put_budget_fn)(struct blk_mq_hw_ctx *);
+typedef int (get_budget_fn)(struct blk_mq_hw_ctx *);
+typedef void (put_budget_fn)(struct blk_mq_hw_ctx *, int);
 typedef enum blk_eh_timer_return (timeout_fn)(struct request *, bool);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int)=
;
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
--=20
2.20.1

