From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 21:28:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F168846.90902@cyberone.com.au>
References: <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de> <3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080706030708000009010607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dyn-ctb-210-9-246-41.webone.com.au ([210.9.246.41]:18958 "EHLO
	chimp.local.net") by vger.kernel.org with ESMTP id S271422AbTGQLN1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 07:13:27 -0400
In-Reply-To: <20030717111059.GI833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, markh@osdl.org
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, cliffw@osdl.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080706030708000009010607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



Jens Axboe wrote:

>On Thu, Jul 17 2003, Nick Piggin wrote:
>

snip

>>
>>Jens, this is exactly right. Would you be OK with this? Everyone else?
>>
>
>I'm happy with it.
>

OK, Mark, please try the following patch in combination with Jens'
previous. Untested due to not being able to exercise the requeue
path, so it might blow up.

--------------080706030708000009010607
Content-Type: text/plain;
 name="as-requeue"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="as-requeue"

--- linux-2.6/drivers/block/as-iosched.c.orig	2003-07-17 21:13:55.000000000 +1000
+++ linux-2.6/drivers/block/as-iosched.c	2003-07-17 21:24:07.000000000 +1000
@@ -1307,6 +1307,66 @@ static void as_add_request(struct as_dat
 	as_update_arq(ad, arq); /* keep state machine up to date */
 }
 
+/*
+ * requeue the request. The request has not been completed, nor is it a
+ * new request, so don't touch accounting.
+ */
+static void as_requeue_request(request_queue_t *q, struct request *rq)
+{
+	struct as_data *ad = q->elevator.elevator_data;
+	struct as_rq *arq = RQ_DATA(rq);
+	int data_dir;
+
+	if (unlikely(rq->flags & REQ_HARDBARRIER)) {
+		AS_INVALIDATE_HASH(ad);
+		q->last_merge = NULL;
+
+		while (ad->next_arq[REQ_SYNC])
+			as_move_to_dispatch(ad, ad->next_arq[REQ_SYNC]);
+
+		while (ad->next_arq[REQ_ASYNC])
+			as_move_to_dispatch(ad, ad->next_arq[REQ_ASYNC]);
+	}
+
+	if (unlikely(!blk_fs_request(rq))) {
+		list_add(&rq->queuelist, ad->dispatch->prev);
+
+		/* Stop anticipating - let this request get through */
+		if (!list_empty(ad->dispatch)
+			&& (ad->antic_status == ANTIC_WAIT_REQ
+				|| ad->antic_status == ANTIC_WAIT_NEXT))
+			as_antic_stop(ad);
+
+		return;
+	}
+
+	if (rq_mergeable(rq)) {
+		as_add_arq_hash(ad, arq);
+
+		if (!q->last_merge)
+			q->last_merge = &rq->queuelist;
+	}
+
+
+	if (rq_data_dir(arq->request) == READ
+			|| current->flags&PF_SYNCWRITE)
+		arq->is_sync = 1;
+	else
+		arq->is_sync = 0;
+	data_dir = arq->is_sync;
+
+	as_add_arq_rb(ad, arq);
+
+	/*
+	 * set expire time (only used for reads) and add to fifo list
+	 */
+	arq->expires = jiffies + ad->fifo_expire[data_dir];
+	list_add_tail(&arq->fifo, &ad->fifo_list[data_dir]);
+	arq->state = AS_RQ_QUEUED;
+	as_update_arq(ad, arq); /* keep state machine up to date */
+
+}
+
 static void
 as_insert_request(request_queue_t *q, struct request *rq,
 			struct list_head *insert_here)
@@ -1822,6 +1882,7 @@ elevator_t iosched_as = {
 	.elevator_next_req_fn =		as_next_request,
 	.elevator_add_req_fn =		as_insert_request,
 	.elevator_remove_req_fn =	as_remove_request,
+	.elevator_requeue_req_fn = 	as_requeue_request,
 	.elevator_queue_empty_fn =	as_queue_empty,
 	.elevator_completed_req_fn =	as_completed_request,
 	.elevator_former_req_fn =	as_former_request,

--------------080706030708000009010607--

