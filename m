Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23881C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 10:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376629AbhKZKEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 05:04:12 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4169 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376436AbhKZKCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 05:02:11 -0500
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J0qv15ybfz67xX7;
        Fri, 26 Nov 2021 17:58:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 10:58:57 +0100
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 09:58:56 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Bart van Assche" <bvanassche@acm.org>,
        chenxiang <chenxiang66@hisilicon.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
Date:   Fri, 26 Nov 2021 09:58:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211125151048.103910-3-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml749-chm.china.huawei.com (10.201.108.199) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/11/2021 15:10, Hannes Reinecke wrote:
> +/**
> + * scsi_get_internal_cmd - allocate an internal SCSI command
> + * @sdev: SCSI device from which to allocate the command
> + * @data_direction: Data direction for the allocated command
> + * @nowait: do not wait for command allocation to succeed.
> + *
> + * Allocates a SCSI command for internal LLDD use.
> + */
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	int data_direction, bool nowait)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	blk_mq_req_flags_t flags = 0;
> +	int op;
> +
> +	if (nowait)
> +		flags |= BLK_MQ_REQ_NOWAIT;
> +	op = (data_direction == DMA_TO_DEVICE) ?
> +		REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
> +	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->device = sdev;
> +	return scmd;
> +}
> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);

So there are a couple of generally-accepted grievances about this approach:
a. we're being allocated a scsi_cmnd, but not using what is being 
allocated as a scsi_cmnd, but rather just a holder as a reference to an 
allocated tag
b. we're being allocated a request, which is not being sent through the 
block layer*

It just seems to me that what the block layer is providing is not suitable.

How about these:
a. allow block driver to specify size of reserved request PDU separately 
to regular requests, so we can use something like this for rsvd commands:
struct scsi_rsvd_cmnd {
	struct scsi_device *sdev;
}
And fix up SCSI iter functions and LLDs to deal with it.
b. provide block layer API to provide just same as is returned from 
blk_mq_unique_tag(), but no request is provided. This just gives what we 
need but would be disruptive in scsi layer and LLDs.
c. as alternative to b., send all rsvd requests through the block layer, 
but can be very difficult+disruptive for users

*For polling rsvd commands on a poll queue (which we will need for 
hisi_sas driver and maybe others for poll mode support), we would need 
to send the request through the block layer, but block layer polling 
requires a request with a bio, which is a problem.

Thanks,
John
