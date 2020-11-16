Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8DAC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7DA22225E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgKPI5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:57:11 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2105 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgKPI5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 03:57:10 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CZNFj50WQz67Dh3;
        Mon, 16 Nov 2020 16:55:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 16 Nov 2020 09:57:08 +0100
Received: from [10.47.84.113] (10.47.84.113) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 16 Nov
 2020 08:57:08 +0000
Subject: Re: [PATCH 03/21] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>, chenxiang <chenxiang66@hisilicon.com>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-4-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <5b9e5684-2235-7ba7-f81f-6dc46ee141e9@huawei.com>
Date:   Mon, 16 Nov 2020 08:56:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200703130122.111448-4-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.113]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:01, Hannes Reinecke wrote:
> Add helper functions to allow LLDDs to allocate and free
> internal commands.

Hi Hannes,

Is there any way to ensure that the request allocated is associated with 
some determined HW queue here?

The reason for this requirement is that sometimes the LLDD must submit 
some internal IO (for which we allocate an "internal command") on a 
specific HW queue. An example of this is internal abort IO commands, 
which should be submitted on the same queue as the IO which we are 
attempting to abort was submitted.

So, for sure, the LLDD does not have to honor the hwq associated with 
the request and submit on the desired queue, but then we lose the blk-mq 
CPU hotplug protection. And maybe other problems.

One way to achieve this is to run scsi_get_internal_cmd() on a CPU 
associated with the desired HW queue, but that's a bit hacky. Not sure 
of another way.

Thanks,
John


> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_lib.c    | 45 +++++++++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h |  4 ++++
>   2 files changed, 49 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0ba7a65e7c8d..1d5c1b9a1203 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1903,6 +1903,51 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
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
> +	blk_mq_free_request(rq);
> +}
> +EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
> +
>   /**
>    * scsi_device_from_queue - return sdev associated with a request_queue
>    * @q: The request queue to return the sdev from
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index bc5909033d13..2759a538adae 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -8,6 +8,7 @@
>   #include <linux/blkdev.h>
>   #include <scsi/scsi.h>
>   #include <linux/atomic.h>
> +#include <linux/dma-direction.h>
>   
>   struct device;
>   struct request_queue;
> @@ -460,6 +461,9 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
>   	return scsi_execute(sdev, cmd, data_direction, buffer,
>   		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
>   }
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	enum dma_data_direction data_direction, int op_flags);
> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
>   extern void sdev_disable_disk_events(struct scsi_device *sdev);
>   extern void sdev_enable_disk_events(struct scsi_device *sdev);
>   extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
> 

