Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD3AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Dec 2021 17:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhLFRuT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 12:50:19 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34550 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLFRuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 12:50:19 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7A08B21B47;
        Mon,  6 Dec 2021 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638812809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtSVsG7qzYF+rSASI95AZa/Ax8zdCF30XJg7s1DDq7k=;
        b=NFcEtAp4D9i2C9B7ePIay3wvXXLWIdq97KSx2/N32iI8/yCoIE1VKegPvb7uU+JcHdH+n+
        Gzb8iEdK5Wvg9AJWkFhsJ91vWVhVPr8H/9pM/Hsc3Cd4AKprb1Deuh3CgoSP4GPEAYyOBN
        ZnQ+7V5lOj02EQ/WZxyn4xk09NQORwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638812809;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtSVsG7qzYF+rSASI95AZa/Ax8zdCF30XJg7s1DDq7k=;
        b=PZWdMhuVKrrkMbON+583cTBFHjng9P4XJnmC9uWZQniylB+Fy1qpHIXr4LefWcplol0sQi
        tcO+gNHeS7HOcZCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4E89113C52;
        Mon,  6 Dec 2021 17:46:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VYhQEolMrmHsEgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 06 Dec 2021 17:46:49 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart van Assche <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
 <ddc265d3-9f31-b4d9-06c4-d205b03a566f@suse.de>
 <2cef903a-80ec-216b-b99a-e4021511711e@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bd45ddc5-6865-59dc-0809-b6901dccd1bb@suse.de>
Date:   Mon, 6 Dec 2021 18:46:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2cef903a-80ec-216b-b99a-e4021511711e@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/21 6:15 PM, John Garry wrote:
> On 28/11/2021 10:36, Hannes Reinecke wrote:
>>>>   * Allocates a SCSI command for internal LLDD use.
>>>> + */
>>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>>> +    int data_direction, bool nowait)
>>>> +{
>>>> +    struct request *rq;
>>>> +    struct scsi_cmnd *scmd;
>>>> +    blk_mq_req_flags_t flags = 0;
>>>> +    int op;
>>>> +
>>>> +    if (nowait)
>>>> +        flags |= BLK_MQ_REQ_NOWAIT;
>>>> +    op = (data_direction == DMA_TO_DEVICE) ?
>>>> +        REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
>>>> +    rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>>>> +    if (IS_ERR(rq))
>>>> +        return NULL;
>>>> +    scmd = blk_mq_rq_to_pdu(rq);
>>>> +    scmd->device = sdev;
>>>> +    return scmd;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
>>> So there are a couple of generally-accepted grievances about this 
>>> approach:
>>> a. we're being allocated a scsi_cmnd, but not using what is being
>>> allocated as a scsi_cmnd, but rather just a holder as a reference to an
>>> allocated tag
>>> b. we're being allocated a request, which is not being sent through the
>>> block layer*
>>>
>> And while being true in general, it does make some assumptions:
>> - Reserved commands will never being sent via the block layer
>> - None of the drivers will need to use the additional 'scsi_cmnd' 
>> payload.
>>
>> Here I'm not sure if this is true in general.
>> While it doesn't seem to be necessary to send reserved commands via the
>> block layer (ie calling 'queue_rq' on them), we shouldn't exclude the
>> possibility.
> 
> Agreed
> 
>> Didn't we speak about that in the context of converting libata?
>>
> 
> We did discuss libata before, but I'm not sure on the context you mean.
> 
> One thing that I know is that libata-core has "internal" commands in 
> ata_exec_internal(). I could not see how that function could be 
> converted to use queue_rq. The problem is that it calls ->qc_issue() 
> with IRQs disabled, which is not permitted for calling blk_execute_rq() 
> instead.
> 

We're conflating two issues here.

The one issue is to use 'reserved' tags (as defined by the block layer) 
to allocate commands which are internal within some drivers (like hpsa 
etc). That is what my patchset does.
As these commands are internal within specific drivers these commands 
will never show up in the upper layers, precisely because they are internal.

The other issue is to allow these 'reserved' tags (and the attached 
requests/commands) to be routed via the normal block-layer execution 
path. This is _not_ part of the above patchset, as that just deals with 
driver internal commands and will never execute ->queue_rq.
For that we would need an additional patchset, on top of the first one.

>> And I have some driver conversions queued (fnic in particular), which
>> encapsulate everything into a scsi command.
>>
>>> It just seems to me that what the block layer is providing is not 
>>> suitable.
>>>
>>> How about these:
>>> a. allow block driver to specify size of reserved request PDU separately
>>> to regular requests, so we can use something like this for rsvd 
>>> commands:
>>> struct scsi_rsvd_cmnd {
>>>       struct scsi_device *sdev;
>>> }
>>> And fix up SCSI iter functions and LLDs to deal with it.
>> That's what Bart suggested a while back, 
> 
> I don't recall that one.
> 
>> but then we have to problem
>> that the reserved tags are completed with the same interrupt routine,
>> and_that_  currently assumes that everything is a scsi command.
> 
> I think that any driver which uses reserved commands needs to be thought 
> that not all commands are "real" scsi commands, i.e. we don't call 
> scsi_done() in the LLD ISR always. As such, they should be able to deal 
> with something like struct scsi_rsvd_cmnd.
> 
See above. My patchset is strictly for driver internal commands, which 
will never be send nor completed like 'real' commands.
And the main point (well, the 'other' main point aside from not having 
to allocate a tag yourself) is that the driver can be _simplified_, as 
now every tag references to the _same_ structure.
If we start using different structure we'll lose that ability 
completely, and really haven't gained that much.

> BTW, for this current series, please ensure that we can't call 
> scsi_host_complete_all_commands() which could iter reserved tags, as we 
> call stuff like scsi_done() there. I don't think it's an issue here, but 
> just thought that it was worth mentioning.
> 
See above. These are driver internal commands, for which scsi_done() is 
never called.

I deliberately did _not_ add checks to scsi_done() or queue_rq(), as 
there presumably will be an additional patch which allows precisely 
this, eg when converting libsas.

>> Trying to fix up that assumption would mean to audit the midlayer
>> (scmd->device is a particular common pattern),_and_  all drivers wanting
>> to make use of reserved commands.
>> For me that's too high an risk to introduce errors; audits are always
>> painful and error-prone.
>>
>>> b. provide block layer API to provide just same as is returned from
>>> blk_mq_unique_tag(), but no request is provided. This just gives what we
>>> need but would be disruptive in scsi layer and LLDs.
>> Having looked at the block layer and how tags are allocated I found it
>> too deeply interlinked with the request queue and requests in general.
> 
> They are indeed interlinked in the block layer, but we don't need expose 
> requests or anything else.
> 
Correct. And this is one of the drawbacks of this approach, in that 
we're always allocating a 'struct request' and a 'struct scsi_cmnd' 
payload even if we don't actually use them.
But then again, we _currently_ don't use them.
If we ever want to sent these 'reserved' commands via queue_rqs() and be 
able to call 'scsi_done()' on them (again, the libsas case) then we need 
these payloads.

> Such an interface could just be a wrapper for 
> blk_mq_alloc_request()+_start_request().
> 
I do agree that currently I don't start requests, and consequently they 
won't show up in any iterators.
But then (currently) it doesn't matter, as none of the iterators in any 
of the drivers I've been converting needed to look at those requests.

>> Plus I've suggested that with a previous patchset, which got vetoed by
>> Bart as he couldn't use such an API for UFS.
>>  >> c. as alternative to b., send all rsvd requests through the block 
>> layer,
>>> but can be very difficult+disruptive for users
>>>
>> And, indeed, not possible when we will need to send these requests
>> during error handling, where the queue might be blocked/frozen/quiesced
>> precisely because we are in error handling ...
> 
> If we send for the host request queue, would it ever be 
> blocked/frozen/quiesced?
> 
Possibly not. But be aware that 'reserved' tags is actually independent 
on the host request queue; it's perfectly possible to use 'reserved' 
tags without a host request queue. Again, fnic is such an example.

>>
>>> *For polling rsvd commands on a poll queue (which we will need for
>>> hisi_sas driver and maybe others for poll mode support), we would need
>>> to send the request through the block layer, but block layer polling
>>> requires a request with a bio, which is a problem.
>>>
>> Allocating a bio is a relatively trivial task.
> 
> So do you suggest a dummy bio for that request? I hacked something 
> locally to get it to work as a PoC, but no idea on a real solution yet.
> 
We're allocating bios for all kind of purposes, even 'dummy' bios in the 
case of bio_clone() or bio_split(). So that's nothing new, and should be 
relatively easy.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
