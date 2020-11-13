Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02127C56202
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 12:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B107C2224C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 12:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgKMMMO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:12:14 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2102 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgKMMMN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2020 07:12:13 -0500
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CXcFT3rnKz67Grs;
        Fri, 13 Nov 2020 19:49:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 13 Nov 2020 12:51:16 +0100
Received: from [10.47.88.104] (10.47.88.104) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 13 Nov
 2020 11:51:15 +0000
Subject: Re: [PATCH v1 1/3] add io_uring with IOPOLL support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     <sumit.saxena@broadcom.com>, <chandrakanth.patil@broadcom.com>,
        <linux-block@vger.kernel.org>
References: <20201015133633.61836-1-kashyap.desai@broadcom.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0531d781-38ed-0098-d5b8-727a3e143dde@huawei.com>
Date:   Fri, 13 Nov 2020 11:51:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201015133633.61836-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.104]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/10/2020 14:36, Kashyap Desai wrote:
> io_uring with IOPOLL is not currently supported in scsi mid layer.
> Outside of that everything else should work and no extra support in the driver is needed.
> Currently io_uring with IOPOLL support is only available in block layer.
> This patch is to extend support of mq_poll in scsi layer. >
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sumit.saxena@broadcom.com
> Cc: chandrakanth.patil@broadcom.com
> Cc: linux-block@vger.kernel.org
> 
> ---
>   drivers/scsi/scsi_lib.c  | 16 ++++++++++++++++
>   include/scsi/scsi_cmnd.h |  1 +
>   include/scsi/scsi_host.h | 11 +++++++++++
>   3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 72b12102f777..5a3c383a2bb3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1766,6 +1766,19 @@ static void scsi_mq_exit_request(struct blk_mq_tag_set *set, struct request *rq,
>   			       cmd->sense_buffer);
>   }
>   
> +
> +static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
> +{
> +	struct request_queue *q = hctx->queue;
> +	struct scsi_device *sdev = q->queuedata;
> +	struct Scsi_Host *shost = sdev->host;

could we separately set hctx->driver_data = shost or similar for a 
quicker lookup? I don't see hctx->driver_data set for SCSI currently. 
Going through the scsi_device looks strange - I know that it is done in 
scsi_commit_rqs.

> +
> +	if (shost->hostt->mq_poll)

to avoid this check, could we reject if .mq_poll is not set and 
HCTX_TYPE_POLL is?

> +		return shost->hostt->mq_poll(shost, hctx->queue_num);
> +
> +	return 0;
> +}
> +
>   static int scsi_map_queues(struct blk_mq_tag_set *set)
>   {
>   	struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
> @@ -1833,6 +1846,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>   	.cleanup_rq	= scsi_cleanup_rq,
>   	.busy		= scsi_mq_lld_busy,
>   	.map_queues	= scsi_map_queues,
> +	.poll		= scsi_mq_poll,
>   };
>   
>   
> @@ -1861,6 +1875,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
>   	.cleanup_rq	= scsi_cleanup_rq,
>   	.busy		= scsi_mq_lld_busy,
>   	.map_queues	= scsi_map_queues,
> +	.poll		= scsi_mq_poll,
>   };
>   
>   struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
> @@ -1893,6 +1908,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   	else
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
> +	tag_set->nr_maps = shost->nr_maps ? : 1;
>   	tag_set->queue_depth = shost->can_queue;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = NUMA_NO_NODE;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index e76bac4d14c5..5844374a85b1 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -9,6 +9,7 @@
>   #include <linux/types.h>
>   #include <linux/timer.h>
>   #include <linux/scatterlist.h>
> +#include <scsi/scsi_host.h>

can we maintain alphabetic ordering?

>   #include <scsi/scsi_device.h>
>   #include <scsi/scsi_request.h>
>   
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 701f178b20ae..905ee6b00c55 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -270,6 +270,16 @@ struct scsi_host_template {
>   	 */
>   	int (* map_queues)(struct Scsi_Host *shost);
>   
> +	/*
> +	 * SCSI interface of blk_poll - poll for IO completions.
> +	 * Possible interface only if scsi LLD expose multiple h/w queues.
> +	 *
> +	 * Return values: Number of completed entries found.

/s/values/value/

> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	int (* mq_poll)(struct Scsi_Host *shost, unsigned int queue_num);
> +
>   	/*
>   	 * Check if scatterlists need to be padded for DMA draining.
>   	 *
> @@ -610,6 +620,7 @@ struct Scsi_Host {
>   	 * the total queue depth is can_queue.
>   	 */
>   	unsigned nr_hw_queues;
> +	unsigned nr_maps; >   	unsigned active_mode:2;
>   	unsigned unchecked_isa_dma:1;
>   
> 

