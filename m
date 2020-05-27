Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E64C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25BC120787
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgE0Q71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 12:59:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbgE0Q71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 May 2020 12:59:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 87599ACAE;
        Wed, 27 May 2020 16:59:28 +0000 (UTC)
Subject: Re: [RFC PATCH 0/4] scsi: use xarray for devices and targets
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200527141400.58087-1-hare@suse.de>
 <f1cb4faf-816e-9f71-aa74-ddf023b197f4@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6bfb4925-b714-80da-e8f5-9e2093fc14e5@suse.de>
Date:   Wed, 27 May 2020 18:59:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f1cb4faf-816e-9f71-aa74-ddf023b197f4@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/27/20 6:36 PM, Bart Van Assche wrote:
> On 2020-05-27 07:13, Hannes Reinecke wrote:
>> Hi all,
>>
>> based on the ideas from Doug Gilbert here's now my take on using
>> xarrays for devices and targets.
>> It revolves around two ideas:
>> - 'channel' and 'id' are never ever used to the full 32 bit range;
>>    'channels' are well below 10, and no driver is using more than
>>    16 bits for the id. So we can reduce the type of 'channel' and
>>    'id' to 16 bits, and use the 32 bit value 'channel << 16 | id'
>>    as the index into the target xarray.
>> - Most SCSI LUNs are below 256 (to ensure compability with older
>>    systems). So there we can use the LUN number as the index into
>>    the xarray; for larger LUN numbers we'll allocate a separate
>>    index.
>>
>> With these change we can implement an efficient lookup mechanism,
>> devolving into direct lookup for most cases.
>> And iteration should be as efficient as the current, list-based,
>> approach.
>>
>> This is compile-tested only, to give you an impression of the
>> overall idea and to get the discussion rolling.
> 
> Hi Hannes,
> 
> My understanding of the xarray concept is that it provides two
> advantages over using linked lists:
> - Faster lookups.
> - Requires less memory.
> 
> Will we benefit from any of these advantages in the SCSI code? Hadn't
> James Bottomley already brought up that lookup by (channel, target, lun)
> only happens from some LLDs and from the procfs code?
> 
It's not only lookup, it's iteration in general.
Which affects scanning and device removal; especially the latter is 
_very_ error prone (just look at scsi_target_reap etc), so any reduction 
in complexity is a good thing in general methinks.

> Are there any use cases where the number of SCSI devices is large enough
> to benefit from the memory reduction?
> 
I would assume that we're seeing benefits as soon as we're in the range 
of tens to hundreds of devices; then list lookup will be eating up more 
time and space as xarrays.

And the big benefit of using xarrays is that we will be alerted if an 
element with the same indices is being added; we've already had issues 
in the past here which are notoriously difficult to track down.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
