Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2735C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 04:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A852A207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 04:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgE1EAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 00:00:00 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55403 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgE1EAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 00:00:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id EE0762041AC;
        Thu, 28 May 2020 05:59:57 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I7NcEI-Z4BzI; Thu, 28 May 2020 05:59:52 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id D372A204179;
        Thu, 28 May 2020 05:59:50 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC PATCH 0/4] scsi: use xarray for devices and targets
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>
References: <20200527141400.58087-1-hare@suse.de>
 <f1cb4faf-816e-9f71-aa74-ddf023b197f4@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <baeae4e3-967c-1b88-6c9c-4cb84ab1c0ec@interlog.com>
Date:   Wed, 27 May 2020 23:59:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f1cb4faf-816e-9f71-aa74-ddf023b197f4@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-27 12:36 p.m., Bart Van Assche wrote:
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

Bart,
You might add these:
   - sane deletion semantics
   - inbuilt locking
   - inherently safer iterations, especially if marks are used

Matthew can probably add more.

> Will we benefit from any of these advantages in the SCSI code? Hadn't
> James Bottomley already brought up that lookup by (channel, target, lun)
> only happens from some LLDs and from the procfs code?

The way that the SCSI object tree hangs together with doubly linked
lists may have been a coherent design 20 years ago when JB wrote it,
but it has been white-anted big time since then.

The current state of that code is hard to defend. I have between 10 and 20
more examples of patently stupid things the current code does. See my
exchange with JB concerning the starget iterator over its sdevs that decided
to check on _every_ sdev in that host. That is done in several places.

The redundant sdevs in a shost collection is probably the most glaring
current design flaw.

> Are there any use cases where the number of SCSI devices is large enough
> to benefit from the memory reduction?

I don't believe that overall memory usage is a problem. Fitting the sdev_s
of hot devices in a smaller number of cache lines would help. That is
where Ming Lei was looking that kicked off this exercise that has
morphed into using xarray.

Doug Gilbert

