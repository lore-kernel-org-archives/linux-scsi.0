Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07F41E4AF
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2024 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705590449; cv=none; b=G4AiKhQlPFlLI8lg0//mnVB30kcskyfrtaUgl3dC0E7rLkIwdeoTHqhd6lP3fk5pXd9tOZrb3e955imRzR3wRWJ4IkGUruNftw8gDvH70Wy8wsnpJam6uaGrbPPYMoI0JXNHRf5QKQJZUEoiLx4yfblAGQJsuL2+pN6d+EvzcHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705590449; c=relaxed/simple;
	bh=7zf0+zAKqiJp+22qIes8RaFgFYtBaUXEp5bz92sRYPU=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=n6/2pSFcuo8Shgqt++8HfdkK69duf7Z7+kTiOUNY7NN2gzGZ6TNOFs2mN7cuEO+8td/3RODJHbuRv77aro3qlGKMdd9hMxsMb7iUg6HcYOcEWAyxHog5UP9AhDS9PuADrbvRBcWHkerXrt+4u5abB9o7Uqjz2AIkyTF2iq+jBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CWDaNpfR; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CWDaNpfR"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-36191ee7be4so3141435ab.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2024 07:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705590445; x=1706195245; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ePBCEOHv3j3ct5lqsC9iWrX0ypOQ2Cybc71ZL2WdJ4=;
        b=CWDaNpfRwRAxtv/0kOZ5onmXXgWJS67esp0MSYPJemns4q4B8APw8nS61jshn0s0Ug
         HSFoXDAtN5Wst5UgYbfh5YyQIKTxlELxP7DW6Je+XlFMM2hxwRO0uuiYAM5BIgP8E5oZ
         ujF9vwW0VcEiBgxi1QSd5EIxXM/hHRJ7scYB9FdDP8HCfb4oYtqCEoSzvjen17ghm5+u
         wL8m8lTF2z336EWtKCh7uLRoBUtAVUdXswggls5GNJ/URkLPz3FRMrLtYBUMpQSpUi/P
         n3+NyrYLD2qh8PnkDuSHfYQwW6kRNigBnMABJMb7yriVqDGgn3oW2Gz4z3rvmmwl1bGA
         giIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705590445; x=1706195245;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ePBCEOHv3j3ct5lqsC9iWrX0ypOQ2Cybc71ZL2WdJ4=;
        b=X0p3eOUux6869ZIFL0lwjgLyPeOfIYZSgcoom7NML7qc1M37qmPVEL3o3cJi4CK+vv
         8FZHRIFzIn0BJmPQ2uzt28z8MR5sjLnnr+os4W6QW40XKNXH8CYLx6ILeITYLm36AIbm
         2rCap0teHiEZiQBA4qt9ABWs9Iq2/CngU9YlI0KOQZg77vIyguvG/BuY+R2TvwfPAw00
         43uWcmxk5P/dsab4zHj6Xd7Ox73nxVO3wRPiK9bcmZRjmVDMUB9VzPm+vT078CQ9mIQM
         ExDHQt0W1UO7pDyYDno++Bq6IJgLPA0pEpPDlaQhnmtXm9j23oUC1PgeNp0Fd/EQSaLp
         eLFw==
X-Gm-Message-State: AOJu0YxPH6ZGC/eCSb+eY3xaiZf042uUFhtEgyOdbhl2wLazMq/hWVoG
	j0YB4kVhRs/1kxAUwsi4QQV/P9hSfAkYI8XUuF18TBQFx/yAwwfm7mMXpaHyMWU=
X-Google-Smtp-Source: AGHT+IFkvKGZcOMGjGeFZdC/rUf2SsGFRtNw+3qaWPDhOxwWZPbqK9RAAN0zSoxGCk2Ea3zzhQ9oAw==
X-Received: by 2002:a05:6e02:1a23:b0:35f:fa79:644 with SMTP id g3-20020a056e021a2300b0035ffa790644mr2274538ile.3.1705590444774;
        Thu, 18 Jan 2024 07:07:24 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dp1-20020a0566381c8100b0046923df89easm1005887jab.158.2024.01.18.07.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 07:07:24 -0800 (PST)
Message-ID: <2ac88048-3aff-4dc4-a8a9-8ba38792533b@kernel.dk>
Date: Thu, 18 Jan 2024 08:07:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
 <c6dfb4f5-10f9-461e-8743-b730a8384f95@acm.org>
 <e19746ce-fdea-4372-bc26-1ee7b1a9a22d@kernel.dk>
 <0853691b-0b70-48c5-825a-4b709d066e20@acm.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0853691b-0b70-48c5-825a-4b709d066e20@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 5:54 PM, Bart Van Assche wrote:
> On 1/17/24 16:42, Jens Axboe wrote:
>> On 1/17/24 5:38 PM, Bart Van Assche wrote:
>>> On 1/17/24 10:43, Jens Axboe wrote:
>>>> Do we care? Maybe not, if we accept that an IO scheduler is just for
>>>> "slower devices". But let's not go around spouting some 200K number as
>>>> if it's gospel, when it depends on so many factors like IO workload,
>>>> system used, etc.
>>> I've never seen more than 200K IOPS in a single-threaded test. Since
>>> your tests report higher IOPS numbers, I assume that you are submitting
>>> I/O from multiple CPU cores at the same time.
>>
>> Single core, using mq-deadline (with the poc patch, but number without
>> you can already find in a previous reply):
>>
>> axboe@7950x ~/g/fio (master)> cat /sys/block/nvme0n1/queue/scheduler
>> none [mq-deadline]
>> axboe@7950x ~/g/fio (master)> sudo t/io_uring -p1 -d128 -b512 -s32 -c32 -F1 -B1 -R1 -X1 -n1 /dev/nvme0n1
>>
>> submitter=0, tid=1957, file=/dev/nvme0n1, node=-1
>> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> IOPS=5.10M, BW=2.49GiB/s, IOS/call=32/31
>> IOPS=5.10M, BW=2.49GiB/s, IOS/call=32/32
>> IOPS=5.10M, BW=2.49GiB/s, IOS/call=31/31
>>
>> Using non-polled IO, the number is around 4M.
> 
> A correction: my tests ran with 72 fio jobs instead of 1. I used
> fio + io_uring + null_blk in my tests. I see about 1100 K IOPS with
> a single fio job and about 150 K IOPS with 72 fio jobs. This shows
> how I measured mq-deadline performance:
> 
> modprobe null_blk
> fio --bs=4096 --group_reporting=1 --gtod_reduce=1 --invalidate=1 \
>     --ioengine=io_uring --ioscheduler=mq-deadline --norandommap \
>     --runtime=60 --rw=randread --thread --time_based=1 --buffered=0 \
>     --numjobs=72 --iodepth=128 --iodepth_batch_submit=64 \
>     --iodepth_batch_complete=64 --name=/dev/nullb0 --filename=/dev/nullb0

I don't think you're testing what you think you are testing here. Queue
depth of > 9000, you are going to be sleeping basically all of the time.
Hardly a realistic workload, you'll spend a lot of time on that and also
make the internal data structures much slower.

Since I still have the box booted with my patch, here's what I see:

Jobs	Queue depth	IOPS
============================
1	128		3090K
32	4		1313K

and taking a quick peek, we're spending a lot of time trying to merge.
Disabling expensive merges, and I get:

Jobs	Queue depth	IOPS
============================
32	4		1980K

which is more reasonable. I used 32 jobs as I have 32 threads in this
box, and QD=4 to keep the same overall queue depth.

All the contention from the numjobs=32 case is insertion at that point,
in fact that's 50% of the time! Well add a quick hack that makes that a
bit better, see below, it's folded in with the previous one. That brings
it to 2300K, and queue lock contention is 18%, down from 50% before.

As before, don't take this patch as gospel, it's just a proof of concept
that it would indeed be possible to make this work. 2300K isn't 3100K,
but it's not terrible scaling for a) all CPUs in the system hammering on
the device, b) a single queue device, and c) using an IO scheduler.


diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..46814b5ed1c9 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -79,7 +79,30 @@ struct dd_per_prio {
 	struct io_stats_per_prio stats;
 };
 
+#define DD_CPU_BUCKETS		32
+#define DD_CPU_BUCKETS_MASK	(DD_CPU_BUCKETS - 1)
+
+struct dd_bucket_list {
+	struct list_head list;
+	spinlock_t lock;
+} ____cacheline_aligned_in_smp;
+
+enum {
+	DD_DISPATCHING	= 0,
+	DD_INSERTING	= 1,
+};
+
 struct deadline_data {
+	struct {
+		spinlock_t lock;
+		spinlock_t zone_lock;
+	} ____cacheline_aligned_in_smp;
+
+	unsigned long run_state;
+
+	atomic_t insert_seq;
+	struct dd_bucket_list bucket_lists[DD_CPU_BUCKETS];
+
 	/*
 	 * run time data
 	 */
@@ -100,9 +123,6 @@ struct deadline_data {
 	int front_merges;
 	u32 async_depth;
 	int prio_aging_expire;
-
-	spinlock_t lock;
-	spinlock_t zone_lock;
 };
 
 /* Maps an I/O priority class to a deadline scheduler priority. */
@@ -600,6 +620,10 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	struct request *rq;
 	enum dd_prio prio;
 
+	if (test_bit(DD_DISPATCHING, &dd->run_state) ||
+	    test_and_set_bit(DD_DISPATCHING, &dd->run_state))
+		return NULL;
+
 	spin_lock(&dd->lock);
 	rq = dd_dispatch_prio_aged_requests(dd, now);
 	if (rq)
@@ -616,6 +640,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	}
 
 unlock:
+	clear_bit(DD_DISPATCHING, &dd->run_state);
 	spin_unlock(&dd->lock);
 
 	return rq;
@@ -694,7 +719,7 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
 	struct deadline_data *dd;
 	struct elevator_queue *eq;
 	enum dd_prio prio;
-	int ret = -ENOMEM;
+	int i, ret = -ENOMEM;
 
 	eq = elevator_alloc(q, e);
 	if (!eq)
@@ -706,6 +731,11 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	eq->elevator_data = dd;
 
+	for (i = 0; i < DD_CPU_BUCKETS; i++) {
+		INIT_LIST_HEAD(&dd->bucket_lists[i].list);
+		spin_lock_init(&dd->bucket_lists[i].lock);
+	}
+
 	for (prio = 0; prio <= DD_PRIO_MAX; prio++) {
 		struct dd_per_prio *per_prio = &dd->per_prio[prio];
 
@@ -724,6 +754,7 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
 	dd->prio_aging_expire = prio_aging_expire;
 	spin_lock_init(&dd->lock);
 	spin_lock_init(&dd->zone_lock);
+	atomic_set(&dd->insert_seq, 0);
 
 	/* We dispatch from request queue wide instead of hw queue */
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
@@ -789,6 +820,22 @@ static bool dd_bio_merge(struct request_queue *q, struct bio *bio,
 	return ret;
 }
 
+static void dd_dispatch_from_buckets(struct deadline_data *dd,
+				     struct list_head *list)
+{
+	int i;
+
+	for (i = 0; i < DD_CPU_BUCKETS; i++) {
+		struct dd_bucket_list *bucket = &dd->bucket_lists[i];
+
+		if (list_empty_careful(&bucket->list))
+			continue;
+		spin_lock(&bucket->lock);
+		list_splice_init(&bucket->list, list);
+		spin_unlock(&bucket->lock);
+	}
+}
+
 /*
  * add rq to rbtree and fifo
  */
@@ -868,8 +915,29 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 	struct request_queue *q = hctx->queue;
 	struct deadline_data *dd = q->elevator->elevator_data;
 	LIST_HEAD(free);
+	int seq, new_seq;
 
-	spin_lock(&dd->lock);
+	seq = atomic_inc_return(&dd->insert_seq);
+	if (!spin_trylock(&dd->lock)) {
+		if (!test_bit(DD_INSERTING, &dd->run_state)) {
+			spin_lock(&dd->lock);
+		} else {
+			struct dd_bucket_list *bucket;
+			int cpu = get_cpu();
+
+			bucket = &dd->bucket_lists[cpu & DD_CPU_BUCKETS_MASK];
+			spin_lock(&bucket->lock);
+			list_splice_init(list, &bucket->list);
+			spin_unlock(&bucket->lock);
+			put_cpu();
+			if (test_bit(DD_INSERTING, &dd->run_state))
+				return;
+			spin_lock(&dd->lock);
+		}
+	}
+
+	set_bit(DD_INSERTING, &dd->run_state);
+retry:
 	while (!list_empty(list)) {
 		struct request *rq;
 
@@ -877,7 +945,16 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 		list_del_init(&rq->queuelist);
 		dd_insert_request(hctx, rq, flags, &free);
 	}
+
+	new_seq = atomic_read(&dd->insert_seq);
+	if (seq != new_seq) {
+		seq = new_seq;
+		dd_dispatch_from_buckets(dd, list);
+		goto retry;
+	}
+
 	spin_unlock(&dd->lock);
+	clear_bit(DD_INSERTING, &dd->run_state);
 
 	blk_mq_free_requests(&free);
 }

-- 
Jens Axboe

