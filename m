Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC42C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 13:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA1660249
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 13:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhFWNu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 09:50:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50678 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFWNuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 09:50:55 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 596EA1FD36;
        Wed, 23 Jun 2021 13:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624456117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d65mfcz5CYN6VOkI+Z06g8jljxhK3fUc01dX1YSkIw8=;
        b=QKtBtyLycoCCffSeA7obMVFiN73z+svQvAaW7/WPn0oDaxtKpBqZRa98nz75jJD4i/XQjy
        OiiulsncjFuktG4wsoBBz4dpFJvjDGxZMmvvA+fFHdC2eeF44Ca+kgaVeBNkAq+6BsqhFH
        iYzV4CPAh5KHmzc11Acl9eGE6lSZRMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624456117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d65mfcz5CYN6VOkI+Z06g8jljxhK3fUc01dX1YSkIw8=;
        b=N/FM+6faDZCR1HCoqWbfLm4C7BwHE3Pcu67TItNLmUv0Sx/b+whOWXi/VOCVai7ktEm6Ae
        HeQGogdyfDrZMxAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 2382C11A97;
        Wed, 23 Jun 2021 13:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624456117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d65mfcz5CYN6VOkI+Z06g8jljxhK3fUc01dX1YSkIw8=;
        b=QKtBtyLycoCCffSeA7obMVFiN73z+svQvAaW7/WPn0oDaxtKpBqZRa98nz75jJD4i/XQjy
        OiiulsncjFuktG4wsoBBz4dpFJvjDGxZMmvvA+fFHdC2eeF44Ca+kgaVeBNkAq+6BsqhFH
        iYzV4CPAh5KHmzc11Acl9eGE6lSZRMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624456117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d65mfcz5CYN6VOkI+Z06g8jljxhK3fUc01dX1YSkIw8=;
        b=N/FM+6faDZCR1HCoqWbfLm4C7BwHE3Pcu67TItNLmUv0Sx/b+whOWXi/VOCVai7ktEm6Ae
        HeQGogdyfDrZMxAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 8WQTB7U702DnRwAALh3uQQ
        (envelope-from <hare@suse.de>); Wed, 23 Jun 2021 13:48:37 +0000
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de>
 <d9c7f79f-f0ec-a420-517c-d6ca83d99ef9@acm.org>
 <e2b24fd6-fe1b-ac5e-e370-93900d98ac90@suse.de>
 <4ba63914-e308-ca62-8562-c0779a7ed05c@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8f6b1d3c-0119-b8f4-e630-2599c4b9fc26@suse.de>
Date:   Wed, 23 Jun 2021 15:48:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <4ba63914-e308-ca62-8562-c0779a7ed05c@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:57 PM, John Garry wrote:
> On 04/05/2021 07:12, Hannes Reinecke wrote:
>> On 5/4/21 4:21 AM, Bart Van Assche wrote:
>>> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>>>> +/**
>>>> + * scsi_get_internal_cmd - allocate an internal SCSI command
>>>> + * @sdev: SCSI device from which to allocate the command
>>>> + * @op: operation (REQ_OP_SCSI_IN or REQ_OP_SCSI_OUT)
>>>> + * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
>>>> + *
>>>> + * Allocates a SCSI command for internal LLDD use.
>>>> + */
>>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>>> +    unsigned int op, blk_mq_req_flags_t flags)
>>>> +{
>>>> +    struct request *rq;
>>>> +    struct scsi_cmnd *scmd;
>>>> +
>>>> +    WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
>>>> +             ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
>>>> +    rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>>>> +    if (IS_ERR(rq))
>>>> +        return NULL;
>>>> +    scmd = blk_mq_rq_to_pdu(rq);
>>>> +    scmd->request = rq;
>>>> +    scmd->device = sdev;
>>>> +    return scmd;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
>>>
>>> Multiple fields that are initialized by the regular command submission
>>> path are not initialized by the above function, e.g. scmd->tag. Has it
>>> been considered to call scsi_init_command() instead of adding yet
>>> another code path that initializes scmd->request?
>>>
>> Hmm. No, I don't think it's a good idea.
>> Basic idea is that the SCSI request serves as a container for 
>> (non-SCSI) management commands, _and_ that they are submitted directly 
>> from within the driver, ie never ever enter ->queue_rq().
>> As such we don't need an initialisation vie scsi_init_request(), and 
>> it would actually be counter-productive as we would be setting up 
>> fields which we'll never need anyway, and might need to tear down 
>> afterwards.
> 
> I will note that we also bypass the queue budgeting in 
> blk_mq_ops.{get,put}_budget. I figure that is not an issue...
> 
> BTW, any chance of a new version?
> 
I have _so_ no idea.

The review from Christoph to patch 07/18 he (apparently) changed his 
mind for the current implementation of using scsi_get_host_dev(), citing 
an approach I had been implemented for v2 (and which got changed due to 
his reviews for v2).
So no I'm not sure if he retracted on his earlier review, or if he just 
had forgotten about it.
And before I get clarification from him I can't really move forward, as 
both reviews contradict each other.

Christoph?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
