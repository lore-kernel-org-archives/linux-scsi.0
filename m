From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sdd scsi-ml event wq
Date: Fri, 28 May 2004 02:07:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B70137.70106@cs.wisc.edu>
References: <40B6F16B.6070909@cs.wisc.edu> <1085732140.2782.14.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34569 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S265970AbUE1JHM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 05:07:12 -0400
In-Reply-To: <1085732140.2782.14.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Arjan van de Ven wrote:
> On Fri, 2004-05-28 at 09:59, Mike Christie wrote:
> 
>>The attached patch just adds a scsi-ml work queue to handle all
>>events. It also converts the transport_scsi_fc class to use it,
>>so drivers using that class do not have to worry about calling
>>the event functions from a process context.
> 
> 
> question: it seems you allow only a limited number of outstanding
> events, fair enough. 

I am not sure I know what you mean. You are referring to when memory
allocations fail, right?

However, how are users of this API supposed to
> handle failure? I see you pass the error nicely all the way down, yet I
> don't quite understand how a driver (the consumer of the API) is
> supposed to handle failure. Queue the event itself? Sounds ugly/wrong to
> me. I'm just wondering if the cleanup you propose doesn't just mean that
> the uglyness gets pushed to correct users of the API.. which isn't quite
> a nett win (under the assumption that there are more than one users of a
> subsystem function)

I agree with you, and I do not have a good answer. When the system is failing
memory allocations it is difficult to do a lot of things. I was thinking that
in such an extreme situation that it would be acceptable for events to fail.
Would it be better to have the API set a timer and retry at a later time? I was
thinking you could end up with a long backlog of events that may be worthless
by the time the system can allocate memory - which is why I put in the
mempool (I know that they are not magic and will fail too though). I am open
to ideas.

