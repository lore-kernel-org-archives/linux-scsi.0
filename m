Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3108C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 09:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1572065D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 09:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgGHJ3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 05:29:39 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2437 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726847AbgGHJ3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jul 2020 05:29:38 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 3D5F768536842D96E145;
        Wed,  8 Jul 2020 10:29:37 +0100 (IST)
Received: from [127.0.0.1] (10.210.171.111) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Wed, 8 Jul 2020
 10:29:36 +0100
Subject: Re: [PATCH 02/21] block: add flag for internal commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-3-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <699d432d-eb5e-a928-5391-c31643620b27@huawei.com>
Date:   Wed, 8 Jul 2020 10:27:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200703130122.111448-3-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.111]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:01, Hannes Reinecke wrote:

+linux-block

I figure that linux-block should be cc'ed here

> Some drivers require to allocate requests for internal command
> submission. These request will never be passed through the block
> layer, but nevertheless require a valid tag to avoid them clashing
> with normal I/O commands.
> This patch adds a new request flag REQ_INTERNAL to mark such
> requests and a terminates any such commands in blk_execute_rq_nowait()
> with a WARN_ON_ONCE to signal such an invalid usage.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   block/blk-exec.c          | 5 +++++
>   include/linux/blk_types.h | 2 ++
>   include/linux/blkdev.h    | 5 +++++
>   3 files changed, 12 insertions(+)
> 
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index 85324d53d072..6869877e0d21 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -55,6 +55,11 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
>   	rq->rq_disk = bd_disk;
>   	rq->end_io = done;
>   
> +	if (WARN_ON_ONCE(blk_rq_is_internal(rq))) {
> +		blk_mq_end_request(rq, BLK_STS_NOTSUPP);
> +		return;
> +	}
> +
>   	blk_account_io_start(rq);
>   
>   	/*
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index ccb895f911b1..e386c43e4d77 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -360,6 +360,7 @@ enum req_flag_bits {
>   	/* for driver use */
>   	__REQ_DRV,
>   	__REQ_SWAP,		/* swapping request. */
> +	__REQ_INTERNAL,		/* driver-internal command */
>   	__REQ_NR_BITS,		/* stops here */
>   };
>   
> @@ -384,6 +385,7 @@ enum req_flag_bits {
>   
>   #define REQ_DRV			(1ULL << __REQ_DRV)
>   #define REQ_SWAP		(1ULL << __REQ_SWAP)
> +#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)
>   
>   #define REQ_FAILFAST_MASK \
>   	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8fd900998b4e..d09210d4591e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -273,6 +273,11 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
>   	return blk_rq_is_scsi(rq) || blk_rq_is_private(rq);
>   }
>   
> +static inline bool blk_rq_is_internal(struct request *rq)
> +{
> +	return rq->cmd_flags & REQ_INTERNAL;
> +}
> +
>   static inline bool bio_is_passthrough(struct bio *bio)
>   {
>   	unsigned op = bio_op(bio);
> 

