From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Wed, 15 Dec 2010 16:47:11 +0100
Message-ID: <4D08E2FF.5090605@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org> <1292382245.19511.56.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292382245.19511.56.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello James,

On 12/15/2010 04:04 AM, James Bottomley wrote:
>> Hmmm, I'm confused.  How does it drop the reference then?
> 
> Um, the same way it does in your new code: inside the executed function.

Okay, it wouldn't work that way.  They both are broken then.  It's
basically like trying put the last module reference from inside the
module.

>> Something outside of the callback should wait for its completion
>> and drop the reference as otherwise nothing can guarantee that the
>> modules doesn't go away between the reference drop and the actual
>> completion of the callback.
> 
> Well, if that's an actual problem, your patch doesn't solve it.  In both
> cases the work structure is part of the object that will be released.
> The way it should happen is that workqueues dequeue the work (so now no
> refs) and execute the callback with the data, so the callback is OK to
> free the work structure.  As long as it still does that, there's no
> problem in either case.

The workqueue code doesn't know anything about the specific work.  It
can't do that.  The work should be flushed from outside.

>>>> Compelling reason for it to exist.  Why not just use work when you
>>>> need execution context and the caller might or might not have one?
>>>
>>> Because it's completely lame to have user context and not use it.
>>
>> It may be lame but I think it's better than having an optimization
>> interface which is incomplete and, more importantly, unnecessary.
> 
> But you're thinking of it as a workqueue issue ... it isn't, it's an API
> which says "just make sure I have user context".  The workqueue is just
> the implementation detail.

Sure, yes, I understand what you're saying, but like everything else
it is a matter of tradeoff.

* It currently is incomplete in that it doesn't have a proper
  synchronization interface, and it isn't true that it's a simple
  interface which doesn't require synchronization.  No, it's not any
  simpler than directly using a workqueue.  How could it be?  It
  conditionally uses workqueue.  It needs the same level of
  synchronization.

* Which is all fine and dandy if it's something which brings actual
  benefits other than the perceived conceptual difference or avoidance
  of the feeling of lameness, but it doesn't.  At least not in the
  current users.  Even if you simply schedule work for the current
  users, nobody would notice.

* It existed for quite some time but failed to grow any new user.  It
  may be conceptually different but apparently there aren't many
  people looking for it.

The logical conclusion is to remove it and conver to work items in the
current few users and use the provided synchronization constructs to
fix the unlikely but still existing race condition.

>>> I really don't think the open coding is a good idea.  It's complex and
>>> error prone; exactly the type of thing that should be in an API.
>>
>> Yeah, just schedule work like everyone else.
> 
> As I said: the required open coding then becomes error prone.

No, don't open code atomicity test.  That's an unnecessary
optimization.  Schedule work directly whether you have context or not.
It just doesn't matter and isn't more complex than the current code.

One way or the other, the current code is racy.  The module can go
away while the work is still running.  We'll have to add sync
interface for ew's, which conceptually is fine but is unnecessary with
the current code base.  Let's do it when it actually is necessary.

I can refresh the patchset so that the relevant works are properly
flushed before the release of the relevant data structures.  Would
that be agreeable?

Thanks.

-- 
tejun
