Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608A6C433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4952720738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgGGN40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:56:26 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2434 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726805AbgGGN40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 09:56:26 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id D346FCE63AE14E4E85B7;
        Tue,  7 Jul 2020 14:56:24 +0100 (IST)
Received: from [127.0.0.1] (10.47.9.47) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 7 Jul 2020
 14:56:24 +0100
Subject: Re: [PATCH 03/21] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-4-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <59afc2bc-a5e2-89d8-0843-03b082c53bb0@huawei.com>
Date:   Tue, 7 Jul 2020 14:54:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200703130122.111448-4-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.9.47]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:01, Hannes Reinecke wrote:
> Add helper functions to allow LLDDs to allocate and free
> internal commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Not sure how Christoph feels about this now, but FWIW:
Reviewed-by: John Garry <john.garry@huawei.com>

But a couple of comments, below.

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

nit: some people like ordering local variables in reverse Christmas tree 
style when possible, but I don't really care.

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
> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd); >   extern void sdev_disable_disk_events(struct scsi_device *sdev);
>   extern void sdev_enable_disk_events(struct scsi_device *sdev);
>   extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);

If I go to delete all these externs so we can be consistent, will 
someone complain?

> 

