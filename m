Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DB2C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 14:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69EF761153
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 14:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbhHSOkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 10:40:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240264AbhHSOkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Aug 2021 10:40:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JEX3OG120898;
        Thu, 19 Aug 2021 10:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=dLi2hRo4O+JVKoA0F0tdJZOhApPflq7puJZPbXDVEp4=;
 b=i8FaDcdysIfUgTabER2IH3m8pfvNB4ldqp5aNCjH2CtW85FiNPPtUo2/9j2SMlshqJng
 hMNR1M59d/8r3wcDvl5xu3bRuwWf/ezs9Zkqtm1nXnwowg7UsAefNbeBtwI+MHouwZMv
 p4lTbop6uKq+AE7KPo5wllTAp6VXaURq76DKqee7WljZuPM4f+LWHcIRK2P8Y4WyMZhD
 TYQHn7hb2sjqUDrgueyPPB/gcFA9sIiwhVlij0KRpM0kCEEC/haH4tYLPMW/dXQokk10
 L0WBJtznNHbxaBe+bZv93KxlMTzWgvue4GC7DWppDacM3XJ0qAOYtS9in0R4lNArxRKj 3g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahjgbcgan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:39:16 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JEcb09018488;
        Thu, 19 Aug 2021 14:39:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ae5f8gdpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 14:39:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JEdAZb42205454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 14:39:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEB2F42042;
        Thu, 19 Aug 2021 14:39:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7163A4204D;
        Thu, 19 Aug 2021 14:39:09 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 19 Aug 2021 14:39:09 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 9/9] block: add an explicit ->disk backpointer to the
 request_queue
References: <20210816131910.615153-1-hch@lst.de>
        <20210816134624.GA24234@lst.de>
Date:   Thu, 19 Aug 2021 16:39:08 +0200
In-Reply-To: <20210816134624.GA24234@lst.de> (Christoph Hellwig's message of
        "Mon, 16 Aug 2021 15:46:24 +0200")
Message-ID: <yt9deeaph52r.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _N-CUgVmjorFG-bIOOWhpOJvdBLsaQjc
X-Proofpoint-GUID: _N-CUgVmjorFG-bIOOWhpOJvdBLsaQjc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_04:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190085
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Replace the magic lookup through the kobject tree with an explicit
> backpointer, given that the device model links are set up and torn
> down at times when I/O is still possible, leading to potential
> NULL or invalid pointer dereferences.
>
> Fixes: edb0872f44ec ("block: move the bdi from the request_queue to the gendisk")
> Reported-by: syzbot <syzbot+aa0801b6b32dca9dda82@syzkaller.appspotmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bfq-iosched.c          |  2 +-
>  block/blk-cgroup.c           |  4 ++--
>  block/blk-mq.c               |  2 +-
>  block/blk-settings.c         |  8 ++++----
>  block/blk-sysfs.c            | 13 ++++++-------
>  block/blk-wbt.c              | 10 +++++-----
>  block/genhd.c                |  2 ++
>  include/linux/blkdev.h       |  5 ++---
>  include/trace/events/kyber.h |  6 +++---
>  9 files changed, 26 insertions(+), 26 deletions(-)
>
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index e4a61eda2d0f..6ccab91a6336 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -5269,7 +5269,7 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
>  	switch (ioprio_class) {
>  	default:
>  		pr_err("bdi %s: bfq: bad prio class %d\n",
> -			bdi_dev_name(queue_to_disk(bfqq->bfqd->queue)->bdi),
> +			bdi_dev_name(bfqq->bfqd->queue->disk->bdi),
>  			ioprio_class);
>  		fallthrough;
>  	case IOPRIO_CLASS_NONE:
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index db034e35ae20..a032536a298d 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -489,9 +489,9 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
>  
>  const char *blkg_dev_name(struct blkcg_gq *blkg)
>  {
> -	if (!queue_has_disk(blkg->q) || !queue_to_disk(blkg->q)->bdi->dev)
> +	if (!blkg->q->disk || !blkg->q->disk->bdi->dev)
>  		return NULL;
> -	return bdi_dev_name(queue_to_disk(blkg->q)->bdi);
> +	return bdi_dev_name(blkg->q->disk->bdi);
>  }
>  
>  /**
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2ca7e7c94b18..0a33d16a7298 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -525,7 +525,7 @@ void blk_mq_free_request(struct request *rq)
>  		__blk_mq_dec_active_requests(hctx);
>  
>  	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
> -		laptop_io_completion(queue_to_disk(q)->bdi);
> +		laptop_io_completion(q->disk->bdi);
>  
>  	rq_qos_done(q, rq);
>  
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 3613d2cc0688..a7c857ad7d10 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -141,9 +141,9 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
>  				 limits->logical_block_size >> SECTOR_SHIFT);
>  	limits->max_sectors = max_sectors;
>  
> -	if (!queue_has_disk(q))
> +	if (!q->disk)
>  		return;
> -	queue_to_disk(q)->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
> +	q->disk->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
>  }
>  EXPORT_SYMBOL(blk_queue_max_hw_sectors);
>  
> @@ -475,9 +475,9 @@ EXPORT_SYMBOL(blk_limits_io_opt);
>  void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
>  {
>  	blk_limits_io_opt(&q->limits, opt);
> -	if (!queue_has_disk(q))
> +	if (!q->disk)
>  		return;
> -	queue_to_disk(q)->bdi->ra_pages =
> +	q->disk->bdi->ra_pages =
>  		max(queue_io_opt(q) * 2 / PAGE_SIZE, VM_READAHEAD_PAGES);
>  }
>  EXPORT_SYMBOL(blk_queue_io_opt);
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 586507a5b8c2..7fd99487300c 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -90,9 +90,9 @@ static ssize_t queue_ra_show(struct request_queue *q, char *page)
>  {
>  	unsigned long ra_kb;
>  
> -	if (!queue_has_disk(q))
> +	if (!q->disk)
>  		return -EINVAL;
> -	ra_kb = queue_to_disk(q)->bdi->ra_pages << (PAGE_SHIFT - 10);
> +	ra_kb = q->disk->bdi->ra_pages << (PAGE_SHIFT - 10);
>  	return queue_var_show(ra_kb, page);
>  }
>  
> @@ -102,12 +102,12 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
>  	unsigned long ra_kb;
>  	ssize_t ret;
>  
> -	if (!queue_has_disk(q))
> +	if (!q->disk)
>  		return -EINVAL;
>  	ret = queue_var_store(&ra_kb, page, count);
>  	if (ret < 0)
>  		return ret;
> -	queue_to_disk(q)->bdi->ra_pages = ra_kb >> (PAGE_SHIFT - 10);
> +	q->disk->bdi->ra_pages = ra_kb >> (PAGE_SHIFT - 10);
>  	return ret;
>  }
>  
> @@ -254,9 +254,8 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
>  
>  	spin_lock_irq(&q->queue_lock);
>  	q->limits.max_sectors = max_sectors_kb << 1;
> -	if (queue_has_disk(q))
> -		queue_to_disk(q)->bdi->io_pages =
> -			max_sectors_kb >> (PAGE_SHIFT - 10);
> +	if (q->disk)
> +		q->disk->bdi->io_pages = max_sectors_kb >> (PAGE_SHIFT - 10);
>  	spin_unlock_irq(&q->queue_lock);
>  
>  	return ret;
> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index 31086afaad9c..874c1c37bf0c 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -97,7 +97,7 @@ static void wb_timestamp(struct rq_wb *rwb, unsigned long *var)
>   */
>  static bool wb_recent_wait(struct rq_wb *rwb)
>  {
> -	struct bdi_writeback *wb = &queue_to_disk(rwb->rqos.q)->bdi->wb;
> +	struct bdi_writeback *wb = &rwb->rqos.q->disk->bdi->wb;
>  
>  	return time_before(jiffies, wb->dirty_sleep + HZ);
>  }
> @@ -234,7 +234,7 @@ enum {
>  
>  static int latency_exceeded(struct rq_wb *rwb, struct blk_rq_stat *stat)
>  {
> -	struct backing_dev_info *bdi = queue_to_disk(rwb->rqos.q)->bdi;
> +	struct backing_dev_info *bdi = rwb->rqos.q->disk->bdi;
>  	struct rq_depth *rqd = &rwb->rq_depth;
>  	u64 thislat;
>  
> @@ -287,7 +287,7 @@ static int latency_exceeded(struct rq_wb *rwb, struct blk_rq_stat *stat)
>  
>  static void rwb_trace_step(struct rq_wb *rwb, const char *msg)
>  {
> -	struct backing_dev_info *bdi = queue_to_disk(rwb->rqos.q)->bdi;
> +	struct backing_dev_info *bdi = rwb->rqos.q->disk->bdi;
>  	struct rq_depth *rqd = &rwb->rq_depth;
>  
>  	trace_wbt_step(bdi, msg, rqd->scale_step, rwb->cur_win_nsec,
> @@ -359,8 +359,8 @@ static void wb_timer_fn(struct blk_stat_callback *cb)
>  
>  	status = latency_exceeded(rwb, cb->stat);
>  
> -	trace_wbt_timer(queue_to_disk(rwb->rqos.q)->bdi, status,
> -			rqd->scale_step, inflight);
> +	trace_wbt_timer(rwb->rqos.q->disk->bdi, status, rqd->scale_step,
> +			inflight);
>  
>  	/*
>  	 * If we exceeded the latency target, step down. If we did not,
> diff --git a/block/genhd.c b/block/genhd.c
> index 6294517cebe6..02cd9ec93e52 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1078,6 +1078,7 @@ static void disk_release(struct device *dev)
>  	disk_release_events(disk);
>  	kfree(disk->random);
>  	xa_destroy(&disk->part_tbl);
> +	disk->queue->disk = NULL;
>  	blk_put_queue(disk->queue);
>  	iput(disk->part0->bd_inode);	/* frees the disk */
>  }
> @@ -1276,6 +1277,7 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
>  	device_initialize(disk_to_dev(disk));
>  	inc_diskseq(disk);
>  	disk->queue = q;
> +	q->disk = disk;
>  	lockdep_init_map(&disk->lockdep_map, "(bio completion)", lkclass, 0);
>  #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
>  	INIT_LIST_HEAD(&disk->slave_bdevs);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index df404c1fb087..22b5b8502d2a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -421,6 +421,8 @@ struct request_queue {
>  
>  	spinlock_t		queue_lock;
>  
> +	struct gendisk		*disk;
> +
>  	/*
>  	 * queue kobject
>  	 */
> @@ -661,9 +663,6 @@ extern void blk_clear_pm_only(struct request_queue *q);
>  	dma_map_page_attrs(dev, (bv)->bv_page, (bv)->bv_offset, (bv)->bv_len, \
>  	(dir), (attrs))
>  
> -#define queue_has_disk(q)	((q)->kobj.parent != NULL)
> -#define queue_to_disk(q)	(dev_to_disk(kobj_to_dev((q)->kobj.parent)))
> -
>  static inline bool queue_is_mq(struct request_queue *q)
>  {
>  	return q->mq_ops;
> diff --git a/include/trace/events/kyber.h b/include/trace/events/kyber.h
> index f9802562edf6..491098a0d8ed 100644
> --- a/include/trace/events/kyber.h
> +++ b/include/trace/events/kyber.h
> @@ -30,7 +30,7 @@ TRACE_EVENT(kyber_latency,
>  	),
>  
>  	TP_fast_assign(
> -		__entry->dev		= disk_devt(queue_to_disk(q));
> +		__entry->dev		= disk_devt(q->disk);
>  		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
>  		strlcpy(__entry->type, type, sizeof(__entry->type));
>  		__entry->percentile	= percentile;
> @@ -59,7 +59,7 @@ TRACE_EVENT(kyber_adjust,
>  	),
>  
>  	TP_fast_assign(
> -		__entry->dev		= disk_devt(queue_to_disk(q));
> +		__entry->dev		= disk_devt(q->disk);
>  		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
>  		__entry->depth		= depth;
>  	),
> @@ -81,7 +81,7 @@ TRACE_EVENT(kyber_throttled,
>  	),
>  
>  	TP_fast_assign(
> -		__entry->dev		= disk_devt(queue_to_disk(q));
> +		__entry->dev		= disk_devt(q->disk);
>  		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
>  	),

Tested-by: Sven Schnelle <svens@linux.ibm.com>
