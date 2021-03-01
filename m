Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E91EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C17264E3F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCAHyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:54:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:41780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232623AbhCAHyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:54:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 42582AD29;
        Mon,  1 Mar 2021 07:30:08 +0000 (UTC)
Subject: Re: [PATCH v3 4/4] scsi: set shost as hctx driver_data
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
References: <20210201051619.19909-1-kashyap.desai@broadcom.com>
 <20210201051619.19909-5-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <49b9ac79-422b-8b08-86fe-91ceda46b5ba@suse.de>
Date:   Mon, 1 Mar 2021 08:30:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201051619.19909-5-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/21 6:16 AM, Kashyap Desai wrote:
> hctx->driver_data is not set for SCSI currently.
> Separately set hctx->driver_data = shost.
> 
> Suggested-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c | 19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8c29bf0e4cfd..f661c50f3b88 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1792,9 +1792,7 @@ static void scsi_mq_exit_request(struct blk_mq_tag_set *set, struct request *rq,
>   
>   static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
>   {
> -	struct request_queue *q = hctx->queue;
> -	struct scsi_device *sdev = q->queuedata;
> -	struct Scsi_Host *shost = sdev->host;
> +	struct Scsi_Host *shost = hctx->driver_data;
>   
>   	if (shost->hostt->mq_poll)
>   		return shost->hostt->mq_poll(shost, hctx->queue_num);
> @@ -1802,6 +1800,15 @@ static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
>   	return 0;
>   }
>   
> +static int scsi_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			  unsigned int hctx_idx)
> +{
> +	struct Scsi_Host *shost = data;
> +
> +	hctx->driver_data = shost;
> +	return 0;
> +}
> +
>   static int scsi_map_queues(struct blk_mq_tag_set *set)
>   {
>   	struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
> @@ -1869,15 +1876,14 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>   	.cleanup_rq	= scsi_cleanup_rq,
>   	.busy		= scsi_mq_lld_busy,
>   	.map_queues	= scsi_map_queues,
> +	.init_hctx	= scsi_init_hctx,
>   	.poll		= scsi_mq_poll,
>   };
>   
>   
>   static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
>   {
> -	struct request_queue *q = hctx->queue;
> -	struct scsi_device *sdev = q->queuedata;
> -	struct Scsi_Host *shost = sdev->host;
> +	struct Scsi_Host *shost = hctx->driver_data;
>   
>   	shost->hostt->commit_rqs(shost, hctx->queue_num);
>   }
> @@ -1898,6 +1904,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
>   	.cleanup_rq	= scsi_cleanup_rq,
>   	.busy		= scsi_mq_lld_busy,
>   	.map_queues	= scsi_map_queues,
> +	.init_hctx	= scsi_init_hctx,
>   	.poll		= scsi_mq_poll,
>   };
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
