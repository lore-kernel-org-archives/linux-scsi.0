Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F21EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 08:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhKVJBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:01:16 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4118 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhKVJBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 04:01:16 -0500
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyLkv4nvMz6GDBG;
        Mon, 22 Nov 2021 16:57:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 09:58:07 +0100
Received: from [10.47.91.234] (10.47.91.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 22 Nov
 2021 08:58:07 +0000
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-6-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
Date:   Mon, 22 Nov 2021 08:58:02 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211119195743.2817-6-bvanassche@acm.org>
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
> +/**
> + * scsi_get_internal_cmd - Allocate an internal SCSI command
> + * @q: request queue from which to allocate the command. This request queue may
> + *	but does not have to be associated with a SCSI device. This request
> + *	queue must be associated with a SCSI tag set. See also
> + *	scsi_mq_setup_tags().
> + * @data_direction: Data direction for the allocated command.
> + * @flags: Zero or more BLK_MQ_REQ_* flags.
> + *
> + * Allocates a request for driver-internal use. The tag of the returned SCSI
> + * command is guaranteed to be unique.
> + */
> +struct scsi_cmnd *scsi_get_internal_cmd(struct request_queue *q,
> +					enum dma_data_direction data_direction,
> +					blk_mq_req_flags_t flags)

I'd pass the Scsi_Host or scsi_device rather than a request q, so maybe:

struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev, ..)
struct scsi_cmnd *scsi_host_get_internal_cmd(struct Scsi_Host *shost, ..)

> +{
> +	unsigned int opf = REQ_INTERNAL;
> +	struct request *rq;
> +
> +	opf |= data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
> +	rq = blk_mq_alloc_request(q, opf, flags);
> +	if (IS_ERR(rq))
> +		return ERR_CAST(rq);

I think that Christoph suggested elsewhere that we should poison all the 
scsi_cmnd

> +	return blk_mq_rq_to_pdu(rq);
> +}
> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);

