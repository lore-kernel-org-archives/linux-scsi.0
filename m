From: Doug Ledford <dledford@redhat.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Thu, 29 Aug 2002 12:25:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020829122535.C31625@redhat.com>
References: <OF9C38FD78.07E54601-ON87256C24.0056B509@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF9C38FD78.07E54601-ON87256C24.0056B509@boulder.ibm.com>; from hbryan@us.ibm.com on Thu, Aug 29, 2002 at 08:59:50AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, patman@beaverton.ibm.com

On Thu, Aug 29, 2002 at 08:59:50AM -0700, Bryan Henderson wrote:
> 
> Incidentally, I've had to explain GFP_ATOMIC to many people, and I believe
> the reason for its incorrect usage is that people know it's supposed to be
> called by processes that can't wait, and they think that means "I can't
> wait for this memory, so be sure you give it to me _now_."  Simple
> explanations of GFP_ATOMIC give you the impression that it's just a higher
> priority request than GFP_KERNEL.

OK, then clarification time ;-)  GFP_KERNEL means give me memory that is 
kernel addressable, and we are allowed to block while writing stuff out to 
disk if necessary.  GFP_ATOMIC doesn't really mean give me memory now, but 
it does mean make your decision now and either give me my memory or give 
me an error condition immediately because I can't be blocked.  Of note, 
GFP_KERNEL allocations are not allowed to succeed if the amount of free 
RAM falls below free pages lo.  Instead they must block until we have 
freed up some ram (enough to get the number of free pages up above free 
pages high).  Atomic allocations will steal memory out the machine well 
below free pages low.  In fact, it's specifically for these atomic 
allocations that we keep that free pages high number of free memory 
around, and this memory pool is used to satisfy atomic allocations long 
after normal GFP_KERNEL allocations have started to block.

> One thing about GFP_ATOMIC that is often overlooked is that what it really
> means is that the caller, instead of VM, is responsible for doing the
> waiting and retrying and whatever to deal with memory allocation failure.
> Failing some operation permanently because a kmalloc(GFP_ATOMIC) it did
> failed is usually the wrong thing to do.

This depends on context.  Failing an atomic allocation in your interrupt 
handler shouldn't result in waiting or retries.  And, since we can't allow 
ourselves to block in an interrupt handler, atomic allocations are the 
only correct method of allocating in an interrupt handler (the scsi 
devices don't typically do this, but lots of network drivers do).  

Now, additionally, if we are failing an allocation in an interrupt 
handler, then often the only thing we can do is bail on the operation.  
So, IMHO, when you see places that truly need atomic allocations, then you 
should also see a place where if the allocations fails then we should 
bail immediately instead of blocking on RAM.

> Again, many people have just the opposite impression.  One person told me
> he used GFP_ATOMIC instead of GFP_KERNEL because he needed to be guaranteed
> the allocation wouldn't fail.

GFP_KERNEL == most likely to succeed, eventually
GFP_ATOMIC == most likely to succeed, right now.  

In fact, atomic allocations *will* succeed as long as there are enough
free pages to satisfy the request.  Regardless of the result, the call 
returns without any delay.  No sleeping is allowed in these allocations.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
