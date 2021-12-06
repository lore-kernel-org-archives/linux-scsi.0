Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE05C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Dec 2021 17:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhLFRTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 12:19:06 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4215 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhLFRTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 12:19:06 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J792415g1z67TbN;
        Tue,  7 Dec 2021 01:11:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 18:15:35 +0100
Received: from [10.47.82.161] (10.47.82.161) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 6 Dec
 2021 17:15:34 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart van Assche <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
 <ddc265d3-9f31-b4d9-06c4-d205b03a566f@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2cef903a-80ec-216b-b99a-e4021511711e@huawei.com>
Date:   Mon, 6 Dec 2021 17:15:20 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <ddc265d3-9f31-b4d9-06c4-d205b03a566f@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.82.161]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/11/2021 10:36, Hannes Reinecke wrote:
>>>   * Allocates a SCSI command for internal LLDD use.
>>> + */
>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>> +    int data_direction, bool nowait)
>>> +{
>>> +    struct request *rq;
>>> +    struct scsi_cmnd *scmd;
>>> +    blk_mq_req_flags_t flags = 0;
>>> +    int op;
>>> +
>>> +    if (nowait)
>>> +        flags |= BLK_MQ_REQ_NOWAIT;
>>> +    op = (data_direction == DMA_TO_DEVICE) ?
>>> +        REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
>>> +    rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>>> +    if (IS_ERR(rq))
>>> +        return NULL;
>>> +    scmd = blk_mq_rq_to_pdu(rq);
>>> +    scmd->device = sdev;
>>> +    return scmd;
>>> +}
>>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
>> So there are a couple of generally-accepted grievances about this approach:
>> a. we're being allocated a scsi_cmnd, but not using what is being
>> allocated as a scsi_cmnd, but rather just a holder as a reference to an
>> allocated tag
>> b. we're being allocated a request, which is not being sent through the
>> block layer*
>>
> And while being true in general, it does make some assumptions:
> - Reserved commands will never being sent via the block layer
> - None of the drivers will need to use the additional 'scsi_cmnd' payload.
> 
> Here I'm not sure if this is true in general.
> While it doesn't seem to be necessary to send reserved commands via the
> block layer (ie calling 'queue_rq' on them), we shouldn't exclude the
> possibility.

Agreed

> Didn't we speak about that in the context of converting libata?
> 

We did discuss libata before, but I'm not sure on the context you mean.

One thing that I know is that libata-core has "internal" commands in 
ata_exec_internal(). I could not see how that function could be 
converted to use queue_rq. The problem is that it calls ->qc_issue() 
with IRQs disabled, which is not permitted for calling blk_execute_rq() 
instead.

> And I have some driver conversions queued (fnic in particular), which
> encapsulate everything into a scsi command.
> 
>> It just seems to me that what the block layer is providing is not suitable.
>>
>> How about these:
>> a. allow block driver to specify size of reserved request PDU separately
>> to regular requests, so we can use something like this for rsvd commands:
>> struct scsi_rsvd_cmnd {
>>       struct scsi_device *sdev;
>> }
>> And fix up SCSI iter functions and LLDs to deal with it.
> That's what Bart suggested a while back, 

I don't recall that one.

> but then we have to problem
> that the reserved tags are completed with the same interrupt routine,
> and_that_  currently assumes that everything is a scsi command.

I think that any driver which uses reserved commands needs to be thought 
that not all commands are "real" scsi commands, i.e. we don't call 
scsi_done() in the LLD ISR always. As such, they should be able to deal 
with something like struct scsi_rsvd_cmnd.

BTW, for this current series, please ensure that we can't call 
scsi_host_complete_all_commands() which could iter reserved tags, as we 
call stuff like scsi_done() there. I don't think it's an issue here, but 
just thought that it was worth mentioning.

> Trying to fix up that assumption would mean to audit the midlayer
> (scmd->device is a particular common pattern),_and_  all drivers wanting
> to make use of reserved commands.
> For me that's too high an risk to introduce errors; audits are always
> painful and error-prone.
> 
>> b. provide block layer API to provide just same as is returned from
>> blk_mq_unique_tag(), but no request is provided. This just gives what we
>> need but would be disruptive in scsi layer and LLDs.
> Having looked at the block layer and how tags are allocated I found it
> too deeply interlinked with the request queue and requests in general.

They are indeed interlinked in the block layer, but we don't need expose 
requests or anything else.

Such an interface could just be a wrapper for 
blk_mq_alloc_request()+_start_request().

> Plus I've suggested that with a previous patchset, which got vetoed by
> Bart as he couldn't use such an API for UFS.
>  >> c. as alternative to b., send all rsvd requests through the block layer,
>> but can be very difficult+disruptive for users
>>
> And, indeed, not possible when we will need to send these requests
> during error handling, where the queue might be blocked/frozen/quiesced
> precisely because we are in error handling ...

If we send for the host request queue, would it ever be 
blocked/frozen/quiesced?

> 
>> *For polling rsvd commands on a poll queue (which we will need for
>> hisi_sas driver and maybe others for poll mode support), we would need
>> to send the request through the block layer, but block layer polling
>> requires a request with a bio, which is a problem.
>>
> Allocating a bio is a relatively trivial task.

So do you suggest a dummy bio for that request? I hacked something 
locally to get it to work as a PoC, but no idea on a real solution yet.

> But as soon as we ever
> want to be able to implement polling support for reserved tags we
> essentially_have_  to use requests, 

Agreed

> and that means we'll have to use the
> provided interfaces from the block layer.

Thanks,
John
