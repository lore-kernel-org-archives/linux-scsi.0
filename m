Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE85CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 12:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDA264E4B
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 12:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhBXMPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 07:15:19 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2601 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhBXMPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 07:15:18 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DlvrV3jgrz67rny;
        Wed, 24 Feb 2021 20:10:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Feb 2021 13:14:36 +0100
Received: from [10.47.6.193] (10.47.6.193) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 24 Feb
 2021 12:14:35 +0000
Subject: Re: [PATCH 02/31] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-3-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e72c3d4a-a532-3d0f-172e-f323475ac0f1@huawei.com>
Date:   Wed, 24 Feb 2021 12:12:48 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210222132405.91369-3-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.6.193]
X-ClientProxiedBy: lhreml723-chm.china.huawei.com (10.201.108.74) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2021 13:23, Hannes Reinecke wrote:
> Add helper functions to allow LLDDs to allocate and free
> internal commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

same comments as v6 apply :)

As does RB tag

> ---
>   drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h |  4 ++++
>   2 files changed, 49 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d0ae586565f8..5cb464972682 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1934,6 +1934,51 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>   	blk_mq_free_tag_set(&shost->tag_set);
>   }
>   
> +/**
> + * scsi_get_internal_cmd - allocate an internal SCSI command
> + * @sdev: SCSI device from which to allocate the command
> + * @data_direction: Data direction for the allocated command
> + * @op_flags: request allocation flags
> + *
> + * Allocates a SCSI command for internal LLDD use.
> + */
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	enum dma_data_direction data_direction, int op_flags)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	blk_mq_req_flags_t flags = 0;
> +	unsigned int op = REQ_INTERNAL | op_flags;
> +
> +	op |= (data_direction == DMA_TO_DEVICE) ?
> +		REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
> +	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->request = rq;
> +	scmd->device = sdev;
> +	return scmd;
> +}
> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
> +
> +/**
> + * scsi_put_internal_cmd - free an internal SCSI command
> + * @scmd: SCSI command to be freed
> + *
> + * Check if @scmd is an internal command, and call
> + * blk_mq_free_request() if true.
> + */
> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = blk_mq_rq_from_pdu(scmd);
> +
> +	if (WARN_ON(!blk_rq_is_internal(rq)))
> +		return;

Still not sure if we need this.... best cc jens on series in future for 
view on complete changes
