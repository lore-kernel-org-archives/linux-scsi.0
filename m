Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ED4C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA82B20757
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEDGnM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 02:43:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgEDGnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 May 2020 02:43:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C1314ABBD;
        Mon,  4 May 2020 06:43:11 +0000 (UTC)
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de> <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590> <20200501174505.GC23795@lst.de>
 <20200502031115.GB1013372@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9453394e-3ef5-eab0-1ddf-94f170057e32@suse.de>
Date:   Mon, 4 May 2020 08:43:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200502031115.GB1013372@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/20 5:11 AM, Ming Lei wrote:
> On Fri, May 01, 2020 at 07:45:05PM +0200, Christoph Hellwig wrote:
>> On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
>>>> We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
>>>> which seems to relate to a hardware setting.
>>>>
>>>> But I can see to update the reserved command functionality for allowing to
>>>> fetch commands from the normal I/O tag pool; in the case of LUN reset it
>>>> shouldn't make much of a difference as the all I/O is quiesced anyway.
>>>
>>> It isn't related with reset.
>>>
>>> This patch reduces active IO queue depth by 1 anytime no matter there is reset
>>> or not, and this way may cause performance regression.
>>
>> But isn't it the right thing to do?  How else do we guarantee that
>> there always is a tag available for the LU reset?
> 
> If that is case, some of these patches should be bug-fix, but nothing
> about this kind of comment is provided. If it is true, please update
> the commit log and explain the current issue in detail, such as,
> what is the side-effect of 'overwriting the original command'?
> 
> And we might need to backport it to stable tree because storage error
> recovery is very key function.
>  > Even though it is true, still not sure if this patch is the correct
> way to fix the issue cause IO performance drop might be caused.
> 
You can't have it both ways.

The underlying problem is this:
The csiostor driver (and several others, too) require a valid hardware 
tag to send a LU reset command. Currently it tries to allocate a tag 
from the pool of free hardware tags.
However, experience shows that the majority of cases (in my personal 
experience _all_ of the cases) where we ever entered the error handler 
are due to command timeouts. If now all commands timed out, the tag 
space is full and we cannot get a free tag to send the LU reset command.
Hence LU reset will currently fail in this case.
With the patchset we will always ensure to have at least one free tag
such that we can send the LU reset command. But, as correctly noted,
it will reduce the available tagspace and possibly reduce the performance.
But you really can have it both ways. Either you go for max performance 
and have the risk of starving the error handler, or you go for 
reliability and accept a (slightly) lower performance.
And, btw, I'm not sure if one could even measure the performance impact.
csiostor has 2048 tags per HBA with a 10G FCoE link. So it would require 
a latency of less than 8us with 4k I/O to saturate the HBA; for 
everything slower we wouldn't be seeing anything.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
