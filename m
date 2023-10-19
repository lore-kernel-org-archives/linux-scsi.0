Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1E2CDB47E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 00:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjJSAPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 20:15:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8AA119;
        Wed, 18 Oct 2023 17:15:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2C6C433C8;
        Thu, 19 Oct 2023 00:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697674513;
        bh=za4ERhTBMaBikZmJUpGYnyH3Cm4WwlpTpeRBqZaj4kA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eCw+5PdId35n0330no/fkXgruo2AcPAZsgDBLW5rY7SQ/hg1vpzYymt36Ul5vL0Fy
         Wb4RTxojK/Hmm7A9PWj+JvOC+ldUL5XTwUs4sCgzg/j4FgF1bcwwD0FVPWzYwS5y1g
         H0481avUi0/Zrm7zTIbELC1TY1MBI7RhMgwQWr0tcEXbUGXu3DFyP81AiuU9DI44sM
         mswM6/OF85XWlbdcL3/euk/grI6HjBE0ChzhdnBIEPGIQgJOPrfx5q3lU8Mu6oigsL
         85zGm7WJzTbjDTsmYbd1q6c8h0CLHhxmZHF/WciASKjdp066SVqV3ZHwSZ6wsAvUdq
         TpFiFmcfQlMCQ==
Message-ID: <5a58c56f-5558-43d5-adc4-bc379f87ddbf@kernel.org>
Date:   Thu, 19 Oct 2023 09:15:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 03/18] block: Preserve the order of requeued zoned
 writes
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-4-bvanassche@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231018175602.2148415-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/23 02:54, Bart Van Assche wrote:
> blk_mq_requeue_work() inserts requeued requests in front of other
> requests. This is fine for all request types except for sequential zoned
> writes. Hence this patch.
> 
> Note: moving this functionality into the mq-deadline I/O scheduler is
> not an option because we want to be able to use zoned storage without
> I/O scheduler.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-mq.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 502dafa76716..ce6ddb249959 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1485,7 +1485,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  			blk_mq_request_bypass_insert(rq, 0);
>  		} else {
>  			list_del_init(&rq->queuelist);
> -			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
> +			blk_mq_insert_request(rq,
> +					      !blk_rq_is_seq_zoned_write(rq) ?
> +					      BLK_MQ_INSERT_AT_HEAD : 0);

Something like:

		} else {
			blk_insert_t flags = BLK_MQ_INSERT_AT_HEAD;

			if (blk_rq_is_seq_zoned_write(rq))
				flags = 0;
			blk_mq_insert_request(rq, flags);
		}

would be a lot easier to read in my opinion.

-- 
Damien Le Moal
Western Digital Research

