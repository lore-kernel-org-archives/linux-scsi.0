From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sdd scsi-ml event wq
Date: Fri, 28 May 2004 03:00:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B70DBC.4020400@cs.wisc.edu>
References: <40B6F16B.6070909@cs.wisc.edu> <1085732140.2782.14.camel@laptop.fenrus.com> <40B70137.70106@cs.wisc.edu> <20040528091825.GA17960@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37897 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S265881AbUE1KAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 06:00:36 -0400
In-Reply-To: <20040528091825.GA17960@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Arjan van de Ven wrote:
> On Fri, May 28, 2004 at 02:07:03AM -0700, Mike Christie wrote:
> 
>>I agree with you, and I do not have a good answer. When the system is 
>>failing
>>memory allocations it is difficult to do a lot of things. I was thinking 
>>that
>>in such an extreme situation that it would be acceptable for events to fail.
>>Would it be better to have the API set a timer and retry at a later time? I 
>>was
>>thinking you could end up with a long backlog of events that may be 
>>worthless
>>by the time the system can allocate memory - which is why I put in the
>>mempool (I know that they are not magic and will fail too though). I am open
>>to ideas.
> 
> 
> well what would suck is if userspace only sees a last "loop down"
> event but then never sees the final "loop up".

I think the kobject hotplug code will already drop events without
indication that it failed :( Look at kset_hotplug().

> The problem is that the memory allocation issue is more critical here than
> in typical code, simply because on loop down you may not be able to do IO to
> your swap device/filesystem to free memory.
> 
> Maybe we need to do a spare allocated event that is ONLY used for "eh the
> queue overflowed, assume all state is lost, rediscover everything". That way
> userland CAN know about the loss of state, and perform full
> discovery/recovery.
> 

Even if we had the spare event, the kobject hotplug code is kmallocing
memory with GFP_KERNEL and will probably fail if we are in a situation
where memory is so tight that we went to our event mempool and those reserves
failed. I am sure that could all be fixed, but we would need to extend a
priority to the hotplug code so it knows that this event is special
(Well, you would also have to go through __call_usermodehelper which could
fail too).

For the short term would it be best to harden the SCSI side of the API then
worry about the API we are using, or is the kobject_hotplug/userspace route not
looking to be the best option?


