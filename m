Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45A0C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8458E238EB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbhAOQSN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 11:18:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:36502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbhAOQSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Jan 2021 11:18:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6957B73E;
        Fri, 15 Jan 2021 16:17:30 +0000 (UTC)
Subject: Re: [PATCH v13 43/45] sg: no_dxfer: move to/from kernel buffers
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-44-dgilbert@interlog.com>
 <c8f449c2-9a69-2fb7-a1fa-a309b4d8b768@suse.de>
 <d15aa6a1-f889-8c5f-f80e-c680a42bb8c4@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6abb445c-87cb-2409-8d5a-51294b639a64@suse.de>
Date:   Fri, 15 Jan 2021 17:17:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <d15aa6a1-f889-8c5f-f80e-c680a42bb8c4@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/14/21 6:11 PM, Douglas Gilbert wrote:
> On 2021-01-14 2:30 a.m., Hannes Reinecke wrote:
>> On 1/13/21 11:45 PM, Douglas Gilbert wrote:
>>> When the NO_DXFER flag is use on a command/request, the data-in
>>> and data-out buffers (if present) should not be ignored. Add
>>> sg_rq_map_kern() function to handle this. Uses a single bio with
>>> multiple bvec_s usually each holding multiple pages, if necessary.
>>> The driver default element size is 32 KiB so if PAGE_SIZE is 4096
>>> then get_order()==3 .
>>>
>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>> ---
>>>   drivers/scsi/sg.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 59 insertions(+)
>>>
>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>>> index a00f488ee5e2..ad97f0756a9c 100644
>>> --- a/drivers/scsi/sg.c
>>> +++ b/drivers/scsi/sg.c
>>> @@ -2865,6 +2865,63 @@ exit_sg(void)
>>>       idr_destroy(&sg_index_idr);
>>>   }
>>> +static struct bio *
>>> +sg_mk_kern_bio(int bvec_cnt)
>>> +{
>>> +    struct bio *biop;
>>> +
>>> +    if (bvec_cnt > BIO_MAX_PAGES)
>>> +        return NULL;
>>> +    biop = bio_alloc(GFP_ATOMIC, bvec_cnt);
>>> +    if (!biop)
>>> +        return NULL;
>>> +    biop->bi_end_io = bio_put;
>>
>> Huh? That is the default action, is it not?
>> So why specify it separately?
> 
> I'll check. That code snippet is copied from NVMe which has equivalent
> code: moving storage data to/from _kernel_ buffers. Later in the driver
> rewrite, bios are re-used, so if any earlier path puts a different
> value in biop->bi_end_io, I'm screwed without that line. So I assumed
> the NVMe code did it for a good reason.
> 
Re-used? Uh-oh.
But okay, then it kinda makes sense.

[ .. ]
>> Why do you need to do the additional mapping?
> 
> I don't understand this question.
> 
>> And doens't the 'NO_DXFER' flag indicate that _no_ data should be 
>> transferred?
> 
> NO, it absolutely does not mean that! With indirect IO (i.e. the 
> default) there
> are two transfers, taking a READ operation is an example:
>     1) transfer user data from the device (a LU) to the internal buffer 
> allocated
>        by the sg driver. LLD arranges that transfer.
>     2) transfer that user data from the internal buffer to the user 
> space as
>        indicated by the call to ioctl(SG_IO) or its alternatives. This 
> transfer
>        is driven by the sg driver using copy_to_user().
> 
> The SG_FLAG_NO_DXFER flag skips step 2) _not_ 1) .
> 
> The SG_FLAG_NO_DXFER flag has been in the sg driver since 1998. Sometime 
> between
> 2010 and now that functionality was quietly dropped. Tony Battersby for one
> seemed quite peeved when I told him that functionality had been silently
> dropped.
> 
Ah. Now that makes sense. Data transfer with not data transfer.
You should've said :-)

I'll have another look with that in mind.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
