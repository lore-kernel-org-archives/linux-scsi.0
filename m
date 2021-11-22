Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BAFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 08:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhKVISr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 03:18:47 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4116 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhKVISq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 03:18:46 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyKnF6n26z6H7pr;
        Mon, 22 Nov 2021 16:14:41 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 09:15:38 +0100
Received: from [10.47.91.234] (10.47.91.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 22 Nov
 2021 08:15:37 +0000
Subject: Re: [PATCH v2 06/20] scsi: core: Add support for reserved tags
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-7-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4f76acb2-68ff-6f6a-775b-81efc4cf10cc@huawei.com>
Date:   Mon, 22 Nov 2021 08:15:33 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211119195743.2817-7-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.234]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/2021 19:57, Bart Van Assche wrote:
> Allow SCSI LLDs to allocate reserved tags by passing the BLK_MQ_REQ_RESERVED
> flag to blk_mq_alloc_request().
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org > ---
>   drivers/scsi/scsi_lib.c  | 4 +++-
>   include/scsi/scsi_host.h | 9 ++++++++-
>   2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 59c3c4fbcfc0..44489ddc646c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1925,6 +1925,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   {
>   	unsigned int cmd_size, sgl_size;
>   	struct blk_mq_tag_set *tag_set = &shost->tag_set;
> +	unsigned int reserved_tags = shost->hostt->reserved_tags;
>   
>   	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
>   				scsi_mq_inline_sgl_size(shost));
> @@ -1940,7 +1941,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
>   	tag_set->nr_maps = shost->nr_maps ? : 1;
> -	tag_set->queue_depth = shost->can_queue;
> +	tag_set->queue_depth = shost->can_queue + reserved_tags;
> +	tag_set->reserved_tags = reserved_tags;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = NUMA_NO_NODE;
>   	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 72e1a347baa6..ec0f7705e06a 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -367,10 +367,17 @@ struct scsi_host_template {

why no field in struct Scsi_Host?

>   	/*
>   	 * This determines if we will use a non-interrupt driven
>   	 * or an interrupt driven scheme.  It is set to the maximum number
> -	 * of simultaneous commands a single hw queue in HBA will accept.
> +	 * of simultaneous commands a single hw queue in HBA will accept. Does
> +	 * not include @reserved_tags.
>   	 */
>   	int can_queue;
>   
> +	/*
> +	 * Number of tags to reserve.


> A reserved tag can be allocated by passing
> +	 * the BLK_MQ_REQ_RESERVED flag to blk_get_request().

I don't see why we need this comment.

> +	 */
> +	unsigned reserved_tags;

I thought that unsigned int was preferred

> +
>   	/*
>   	 * In many instances, especially where disconnect / reconnect are
>   	 * supported, our host also has an ID on the SCSI bus.  If this is
> .
> 

