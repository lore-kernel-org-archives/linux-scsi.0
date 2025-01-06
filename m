Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B873D80027;
	Mon,  6 Jan 2025 11:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161345; cv=none; b=Pcl7JBVf/aSNkPOF6wRBvEe+Ic7Hef1xM8RpSYcaXYdweXOy+2ok02tyLf1RXmSeH/8SmRQ71w68H7/r+bmc1AlzGuQySs3y2VXPX2T95wgZgYkeLccy19ErwB20bv3oEN2d8a76FbTagL8J4LT27F3gCdLt+XKArjYdsdqGDv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161345; c=relaxed/simple;
	bh=v0kkjTd65B0NBvThBIC3VGYrJjwX674KAVP7ZBGCe9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CEi1CiekcLFKEPJrxXFDYqEZBN4gFZuI+n8tfe95+OkLsa+RBme3MvA4JQ9FPtHVFZ9wrrDq2Vb3N4oFFH14elkcU3esIbiDnXhtIVVZW5JmlczgNCo3StaY0hAGyir468o79gr/d85SYEssmFogguveG4AM94xeahxO7VsOrgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AiDSX83l; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AiDSX83l"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50685XwV025170;
	Mon, 6 Jan 2025 11:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LYZStV
	LN02Fvci1m/Vn1rsv8xGuw05U92gOyr+mRsfE=; b=AiDSX83l/71hKWEfuzpw42
	zION2JEFCOqZm+yjM1GDiSg54yKAYdUBqJsFiqytzhjN6dZ+mZRUCvlrHoAp43h9
	9Tr42XEeWzn96N6YWunBo/zFCgCIPG2aI7Cv5Ghz90XVwGE6FQ6kXpWJhNtc+ipe
	LzJ0edO0m/jsli0SRwd4+5ecjaLMYgyMQ0aK53uMSj+EG6dfmn5PxaDiND9SF+9n
	wQhQHQZ7gDrhYTgfMlUc05VwUNBChUPdNjwm6SWOjUQG3CO1etPC/vMZM5xBsjiZ
	w67O5FUNpc35bG5w3LoUScWXrfsJN52FgFP7UEBkefTZyj0+KObf/kstK1m/YnDw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440bc2gmn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 11:01:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5069nu2N008866;
	Mon, 6 Jan 2025 11:01:28 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfpyngpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 11:01:28 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 506B1SLV4326064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Jan 2025 11:01:28 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 842F758059;
	Mon,  6 Jan 2025 11:01:28 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 276CC58058;
	Mon,  6 Jan 2025 11:01:25 +0000 (GMT)
Received: from [9.171.85.164] (unknown [9.171.85.164])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Jan 2025 11:01:24 +0000 (GMT)
Message-ID: <4addcb5e-fc88-4a86-a464-cc25d8674267@linux.ibm.com>
Date: Mon, 6 Jan 2025 16:31:23 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, virtualization@lists.linux.dev,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-6-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250106100645.850445-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BJ6qKJdHHh_qTZLqEPnlC1SDJpZkAyhs
X-Proofpoint-ORIG-GUID: BJ6qKJdHHh_qTZLqEPnlC1SDJpZkAyhs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501060097



On 1/6/25 3:36 PM, Christoph Hellwig wrote:
> When __blk_mq_update_nr_hw_queues changes the number of tag sets, it
> might have to disable poll queues.  Currently it does so by adjusting
> the BLK_FEAT_POLL, which is a bit against the intent of features that
> describe hardware / driver capabilities, but more importantly causes
> nasty lock order problems with the broadly held freeze when updating the
> number of hardware queues and the limits lock.  Fix this by leaving
> BLK_FEAT_POLL alone, and instead check for the number of sets and poll
> queues in the bio submission and poll handler.  While this adds extra
> work to the fast path, the variables are in cache lines used by these
> operations anyway, so it should be cheap enough.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c | 14 +++++++++++---
>  block/blk-mq.c   | 19 +------------------
>  block/blk-mq.h   |  6 ++++++
>  3 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 666efe8fa202..483c14a50d9f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -753,6 +753,15 @@ static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
>  	return BLK_STS_OK;
>  }
>  
> +static bool bdev_can_poll(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (queue_is_mq(q))
> +		return blk_mq_can_poll(q->tag_set);
> +	return q->limits.features & BLK_FEAT_POLL;
> +}
> +

Should we make bdev_can_poll() inline ?

>  /**
>   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
>   * @bio:  The bio describing the location in memory and on the device.
> @@ -805,8 +814,7 @@ void submit_bio_noacct(struct bio *bio)
>  		}
>  	}
>  
> -	if (!(q->limits.features & BLK_FEAT_POLL) &&
> -			(bio->bi_opf & REQ_POLLED)) {
> +	if ((bio->bi_opf & REQ_POLLED) && !bdev_can_poll(bdev)) {
>  		bio_clear_polled(bio);
>  		goto not_supported;
>  	}
> @@ -935,7 +943,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
>  		return 0;
>  
>  	q = bdev_get_queue(bdev);
> -	if (cookie == BLK_QC_T_NONE || !(q->limits.features & BLK_FEAT_POLL))
> +	if (cookie == BLK_QC_T_NONE || !bdev_can_poll(bdev))
>  		return 0;
>  
>  	blk_flush_plug(current->plug, false);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 17f10683d640..0a7f059735fa 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -4321,12 +4321,6 @@ void blk_mq_release(struct request_queue *q)
>  	blk_mq_sysfs_deinit(q);
>  }
>  
> -static bool blk_mq_can_poll(struct blk_mq_tag_set *set)
> -{
> -	return set->nr_maps > HCTX_TYPE_POLL &&
> -		set->map[HCTX_TYPE_POLL].nr_queues;
> -}
> -
>  struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
>  		struct queue_limits *lim, void *queuedata)
>  {
> @@ -4336,9 +4330,7 @@ struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
>  
>  	if (!lim)
>  		lim = &default_lim;
> -	lim->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
> -	if (blk_mq_can_poll(set))
> -		lim->features |= BLK_FEAT_POLL;
> +	lim->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
>  
>  	q = blk_alloc_queue(lim, set->numa_node);
>  	if (IS_ERR(q))
> @@ -5025,8 +5017,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
>  fallback:
>  	blk_mq_update_queue_map(set);
>  	list_for_each_entry(q, &set->tag_list, tag_set_list) {
> -		struct queue_limits lim;
> -
>  		blk_mq_realloc_hw_ctxs(set, q);
>  
>  		if (q->nr_hw_queues != set->nr_hw_queues) {
> @@ -5040,13 +5030,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
>  			set->nr_hw_queues = prev_nr_hw_queues;
>  			goto fallback;
>  		}
> -		lim = queue_limits_start_update(q);
> -		if (blk_mq_can_poll(set))
> -			lim.features |= BLK_FEAT_POLL;
> -		else
> -			lim.features &= ~BLK_FEAT_POLL;
> -		if (queue_limits_commit_update(q, &lim) < 0)
> -			pr_warn("updating the poll flag failed\n");
>  		blk_mq_map_swqueue(q);
>  	}
>  
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 89a20fffa4b1..ecd7bd7ec609 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -111,6 +111,12 @@ static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
>  	return ctx->hctxs[blk_mq_get_hctx_type(opf)];
>  }
>  
> +static inline bool blk_mq_can_poll(struct blk_mq_tag_set *set)
> +{
> +	return set->nr_maps > HCTX_TYPE_POLL &&
> +		set->map[HCTX_TYPE_POLL].nr_queues;
> +}
> +
>  /*
>   * sysfs helpers
>   */

