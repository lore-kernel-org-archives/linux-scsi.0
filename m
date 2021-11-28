Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C856CC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Nov 2021 10:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357176AbhK1Klw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Nov 2021 05:41:52 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:40808 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357103AbhK1Kjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Nov 2021 05:39:52 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D8376212BB;
        Sun, 28 Nov 2021 10:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638095795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ywsDTALh2eqYDCQ/oiLenibdscGM7xV7U58MIMbYA8=;
        b=CFXaEli1QBa4S5JsS5sl91yNcKa7SDqi6e0Kwbx9ZvDqmayXF9xC5dejB2DlncLaC61awK
        3fli5Pon0fPSSmoOWid0Z9IqfnWM1a2NHaQMu3RZ4HPJuZDFiXRYDVZd6ZmewCR8VRQb1o
        TjFOddYHNZvRKwK3xLSyI1wqh9wvZwo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638095795;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ywsDTALh2eqYDCQ/oiLenibdscGM7xV7U58MIMbYA8=;
        b=IoFQzcHHPbbS2fGuK9BLKJJo47wnxRitA04IW2C+WNKK8JgbxkoaABAJPmqCVPajegOvHN
        QFTYspBIYiCGvTCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AC2FC133D1;
        Sun, 28 Nov 2021 10:36:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +Io5KLNbo2HSRwAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 28 Nov 2021 10:36:35 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        chenxiang <chenxiang66@hisilicon.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ddc265d3-9f31-b4d9-06c4-d205b03a566f@suse.de>
Date:   Sun, 28 Nov 2021 11:36:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/21 10:58 AM, John Garry wrote:
> On 25/11/2021 15:10, Hannes Reinecke wrote:
>> +/**
>> + * scsi_get_internal_cmd - allocate an internal SCSI command
>> + * @sdev: SCSI device from which to allocate the command
>> + * @data_direction: Data direction for the allocated command
>> + * @nowait: do not wait for command allocation to succeed.
>> + *
>> + * Allocates a SCSI command for internal LLDD use.
>> + */
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>> +    int data_direction, bool nowait)
>> +{
>> +    struct request *rq;
>> +    struct scsi_cmnd *scmd;
>> +    blk_mq_req_flags_t flags = 0;
>> +    int op;
>> +
>> +    if (nowait)
>> +        flags |= BLK_MQ_REQ_NOWAIT;
>> +    op = (data_direction == DMA_TO_DEVICE) ?
>> +        REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
>> +    rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>> +    if (IS_ERR(rq))
>> +        return NULL;
>> +    scmd = blk_mq_rq_to_pdu(rq);
>> +    scmd->device = sdev;
>> +    return scmd;
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
> 
> So there are a couple of generally-accepted grievances about this approach:
> a. we're being allocated a scsi_cmnd, but not using what is being 
> allocated as a scsi_cmnd, but rather just a holder as a reference to an 
> allocated tag
> b. we're being allocated a request, which is not being sent through the 
> block layer*
> 
And while being true in general, it does make some assumptions:
- Reserved commands will never being sent via the block layer
- None of the drivers will need to use the additional 'scsi_cmnd' payload.

Here I'm not sure if this is true in general.
While it doesn't seem to be necessary to send reserved commands via the 
block layer (ie calling 'queue_rq' on them), we shouldn't exclude the 
possibility.
Didn't we speak about that in the context of converting libata?

And I have some driver conversions queued (fnic in particular), which 
encapsulate everything into a scsi command.

> It just seems to me that what the block layer is providing is not suitable.
> 
> How about these:
> a. allow block driver to specify size of reserved request PDU separately 
> to regular requests, so we can use something like this for rsvd commands:
> struct scsi_rsvd_cmnd {
>      struct scsi_device *sdev;
> }
> And fix up SCSI iter functions and LLDs to deal with it.

That's what Bart suggested a while back, but then we have to problem 
that the reserved tags are completed with the same interrupt routine, 
and _that_ currently assumes that everything is a scsi command.
Trying to fix up that assumption would mean to audit the midlayer 
(scmd->device is a particular common pattern), _and_ all drivers wanting 
to make use of reserved commands.
For me that's too high an risk to introduce errors; audits are always 
painful and error-prone.

> b. provide block layer API to provide just same as is returned from 
> blk_mq_unique_tag(), but no request is provided. This just gives what we 
> need but would be disruptive in scsi layer and LLDs.

Having looked at the block layer and how tags are allocated I found it 
too deeply interlinked with the request queue and requests in general.
Plus I've suggested that with a previous patchset, which got vetoed by 
Bart as he couldn't use such an API for UFS.

> c. as alternative to b., send all rsvd requests through the block layer, 
> but can be very difficult+disruptive for users
> 
And, indeed, not possible when we will need to send these requests 
during error handling, where the queue might be blocked/frozen/quiesced 
precisely because we are in error handling ...

> *For polling rsvd commands on a poll queue (which we will need for 
> hisi_sas driver and maybe others for poll mode support), we would need 
> to send the request through the block layer, but block layer polling 
> requires a request with a bio, which is a problem.
> 
Allocating a bio is a relatively trivial task. But as soon as we ever 
want to be able to implement polling support for reserved tags we 
essentially _have_ to use requests, and that means we'll have to use the 
provided interfaces from the block layer.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
