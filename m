Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26DCC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D0E461435
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhDVGaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:30:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:42994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhDVGaR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 02:30:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C7A83B01F;
        Thu, 22 Apr 2021 06:29:31 +0000 (UTC)
Subject: Re: [PATCH 02/42] scsi_ioctl: return error code when
 blk_rq_map_kern() fails
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-3-hare@suse.de>
 <cf3e301e-e4f7-9def-e66b-c0a3eaa838a2@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2dfd7a08-07b2-dde1-efc6-f1ee1b285371@suse.de>
Date:   Thu, 22 Apr 2021 08:29:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <cf3e301e-e4f7-9def-e66b-c0a3eaa838a2@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 11:01 PM, Bart Van Assche wrote:
> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>> The callers of sg_scsi_ioctl() already check for negative
>> return values, so we can drop the usage of DRIVER_ERROR
>> and return the error from blk_rq_map_kern() instead.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   block/scsi_ioctl.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>> index 6599bac0a78c..99d58786e0d5 100644
>> --- a/block/scsi_ioctl.c
>> +++ b/block/scsi_ioctl.c
>> @@ -488,9 +488,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct 
>> gendisk *disk, fmode_t mode,
>>           break;
>>       }
>> -    if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO)) {
>> -        err = DRIVER_ERROR << 24;
>> -        goto error;
>> +    if (bytes) {
>> +        err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO);
>> +        if (err)
>> +            goto error;
>>       }
>>       blk_execute_rq(disk, rq, 0);
> 
> Is this perhaps a backwards-incompatible user space ABI change since the 
> sg_scsi_ioctl() return value is reported to user space?
> 
Possibly; but we're dealing with semantics here.
All callers to sg_scsi_ioctl() _must_ be prepared to handle negative
values already, so userspace should not break.
We arguably _do_ return a different error here, but experience showed 
that basically no-one checks for driver byte values (except for 
DRIVER_SENSE, that is).
So I don't think it really matters; we do return an error, and for 
userspace it doesn't matter as this command cannot be retried either way.

So while this arguably is a change visible to userspace, I doubt it 
matters in the end.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
