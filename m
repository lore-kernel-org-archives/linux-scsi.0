Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA2FC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 14:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C67E20780
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 14:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgFWOXh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 10:23:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:53622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732830AbgFWOXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 10:23:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EDC01B012;
        Tue, 23 Jun 2020 14:23:33 +0000 (UTC)
Subject: Re: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, bvanassche@acm.org, hare@suse.com,
        hch@lst.de, shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590>
 <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
 <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
Date:   Tue, 23 Jun 2020 16:23:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com>
Content-Type: multipart/mixed;
 boundary="------------87FA99FADADEA3EE2B4E056B"
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------87FA99FADADEA3EE2B4E056B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/23/20 1:25 PM, John Garry wrote:
> On 11/06/2020 09:26, John Garry wrote:
>> On 11/06/2020 03:57, Ming Lei wrote:
>>> On Thu, Jun 11, 2020 at 01:29:09AM +0800, John Garry wrote:
>>>> From: Hannes Reinecke <hare@suse.de>
>>>>
>>>> The function does not set the depth, but rather transitions from
>>>> shared to non-shared queues and vice versa.
>>>> So rename it to blk_mq_update_tag_set_shared() to better reflect
>>>> its purpose.
>>>
>>> It is fine to rename it for me, however:
>>>
>>> This patch claims to rename blk_mq_update_tag_set_shared(), but also
>>> change blk_mq_init_bitmap_tags's signature.
>>
>> I was going to update the commit message here, but forgot again...
>>
>>>
>>> So suggest to split this patch into two or add comment log on changing
>>> blk_mq_init_bitmap_tags().
>>
>> I think I'll just split into 2x commits.
> 
> Hi Hannes,
> 
> Do you have any issue with splitting the undocumented changes into 
> another patch as so:
> 
No, that's perfectly fine.

Kashyap, I've also attached an updated patch for the elevator_count 
patch; if you agree John can include it in the next version.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

--------------87FA99FADADEA3EE2B4E056B
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-elevator-count-requests-per-hctx-to-improve-performa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-elevator-count-requests-per-hctx-to-improve-performa.pa";
 filename*1="tch"

From d50b5f773713070208c405f7c7056eb1afed896a Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 23 Jun 2020 16:18:40 +0200
Subject: [PATCH] elevator: count requests per hctx to improve performance

Add a 'elevator_queued' count to the hctx to avoid triggering
the elevator even though there are no requests queued.

Suggested-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/bfq-iosched.c    | 5 +++++
 block/blk-mq.c         | 1 +
 block/mq-deadline.c    | 5 +++++
 include/linux/blk-mq.h | 4 ++++
 4 files changed, 15 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a1123d4d586d..3d63b35f6121 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4640,6 +4640,9 @@ static bool bfq_has_work(struct blk_mq_hw_ctx *hctx)
 {
 	struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
 
+	if (!atomic_read(&hctx->elevator_queued))
+		return false;
+
 	/*
 	 * Avoiding lock: a race on bfqd->busy_queues should cause at
 	 * most a call to dispatch for nothing
@@ -5554,6 +5557,7 @@ static void bfq_insert_requests(struct blk_mq_hw_ctx *hctx,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		bfq_insert_request(hctx, rq, at_head);
+		atomic_inc(&hctx->elevator_queued)
 	}
 }
 
@@ -5933,6 +5937,7 @@ static void bfq_finish_requeue_request(struct request *rq)
 
 		bfq_completed_request(bfqq, bfqd);
 		bfq_finish_requeue_request_body(bfqq);
+		atomic_dec(&rq->mq_hctx->elevator_queued);
 
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	} else {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e06e8c9f326f..f5403fc97572 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2542,6 +2542,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
 		goto free_hctx;
 
 	atomic_set(&hctx->nr_active, 0);
+	atomic_set(&hctx->elevator_queued, 0);
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 	hctx->numa_node = node;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index b57470e154c8..9d753745e6be 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -533,6 +533,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		dd_insert_request(hctx, rq, at_head);
+		atomic_inc(&hctx->elevator_queued);
 	}
 	spin_unlock(&dd->lock);
 }
@@ -573,12 +574,16 @@ static void dd_finish_request(struct request *rq)
 			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
 	}
+	atomic_dec(&rq->mq_hctx->elevator_queued);
 }
 
 static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 {
 	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
 
+	if (!atomic_read(&hctx->elevator_queued))
+		return false;
+
 	return !list_empty_careful(&dd->dispatch) ||
 		!list_empty_careful(&dd->fifo_list[0]) ||
 		!list_empty_careful(&dd->fifo_list[1]);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 66711c7234db..a18c506b14e7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -139,6 +139,10 @@ struct blk_mq_hw_ctx {
 	 * shared across request queues.
 	 */
 	atomic_t		nr_active;
+	/**
+	 * @elevator_queued: Number of queued requests on hctx.
+	 */
+	atomic_t                elevator_queued;
 
 	/** @cpuhp_online: List to store request if CPU is going to die */
 	struct hlist_node	cpuhp_online;
-- 
2.26.2


--------------87FA99FADADEA3EE2B4E056B--
