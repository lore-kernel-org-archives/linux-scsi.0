Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F174C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5A522203
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgKQQmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:42:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:47670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgKQQmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:42:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58535AC1F;
        Tue, 17 Nov 2020 16:42:52 +0000 (UTC)
Subject: Re: [PATCH V4 11/12] scsi: make sure sdev->queue_depth is <=
 max(shost->can_queue, 1024)
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
 <20201116090737.50989-12-ming.lei@redhat.com>
 <4479fc11-5c4f-e575-a253-e08c841c5cb2@suse.de> <20201117021813.GD56247@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <074ce627-127e-180a-f5d6-595eeffa65b8@suse.de>
Date:   Tue, 17 Nov 2020 17:42:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201117021813.GD56247@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/20 3:18 AM, Ming Lei wrote:
> On Mon, Nov 16, 2020 at 10:44:54AM +0100, Hannes Reinecke wrote:
>> On 11/16/20 10:07 AM, Ming Lei wrote:
>>> Limit scsi device's queue depth is less than max(host->can_queue, 1024)
>>> in scsi_change_queue_depth(), and 1024 is big enough for saturating
>>> current fast SCSI LUN(SSD, or raid volume on multiple SSDs).
>>>
>>> We need this patch for replacing sdev->device_busy with sbitmap which
>>> has to be pre-allocated with reasonable max depth.
>>>
>>> Cc: Omar Sandoval <osandov@fb.com>
>>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>>> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
>>> Cc: Ewan D. Milne <emilne@redhat.com>
>>> Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    drivers/scsi/scsi.c | 11 +++++++++++
>>>    1 file changed, 11 insertions(+)
>>>
>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>> index 24619c3bebd5..a28d48c850cf 100644
>>> --- a/drivers/scsi/scsi.c
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -214,6 +214,15 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>>>    	scsi_io_completion(cmd, good_bytes);
>>>    }
>>> +
>>> +/*
>>> + * 1024 is big enough for saturating the fast scsi LUN now
>>> + */
>>> +static int scsi_device_max_queue_depth(struct scsi_device *sdev)
>>> +{
>>> +	return max_t(int, sdev->host->can_queue, 1024);
>>> +}
>>> +
>>
>> Shouldn't this rather be initialized with scsi_host->can_queue?
> 
> Multiple queues may be used for one single LUN, so in theory we should
> return max queue depth as host->can_queue * host->nr_hw_queues, but
> this number can be too big for the sbitmap's pre-allocation.
> 
Ah, so that's the problem here.

> That is why this patch introduces one reasonable limit on this value
> of max(sdev->host->can_queue, 1024). Suppose single SSD can be saturated
> by ~128 requests, we still can saturate one LUN with 8 SSDs behind if
> the hw queue depth is set as too low.
> 
>> These 'should be enough' settings inevitable turn out to be not enough in
>> the long run ...
> 
> I have provided the theory behind this idea, not just simple 'should be
> enough'.
> 
No, it's okay now. I wasn't aware that we had a limitation on the 
sbitmap pre-allocation.

You can add my

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
