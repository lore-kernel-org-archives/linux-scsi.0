From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling finished
Date: Mon, 24 Jun 2013 21:56:41 -0500
Message-ID: <86B43C4C-A982-4367-82C5-27C910970854@cs.wisc.edu>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org> <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com> <51C8A668.3060700@cs.wisc.edu> <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com> <51C8FFDB.70800@cs.wisc.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58968 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FYC5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 22:57:07 -0400
In-Reply-To: <51C8FFDB.70800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On Jun 24, 2013, at 9:26 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 06/24/2013 05:27 PM, James Bottomley wrote:
>>>> However, what's the reasoning behind wanting to do this?  In theory all
>>>> necessary resources for the eh thread should only be freed in the
>>>> release callback.  That means they aren't freed until all error recovery
>>>> completes.
>>> 
>>> I think it makes it easier to handle cleanup of driver resources
>>> needed
>>> for aborts/resets for some drivers. If after host removal, the scsi eh
>>> can call into the driver after scsi_remove_host is called then we have
>>> to set some internal bits to fail future eh callback calls and handle
>>> waiting on or flushing running eh operations. If we know that after
>>> scsi_host_remove is called the eh callbacks will not be running and
>>> will
>>> not be called we can just free the driver resources.
>>> 
>>> For iscsi and I think drivers that do scsi_remove_target it would be
>>> helpful to have something similar at the target level.
>> 
>> I'm wary of this because it combines two models: a definite state model
>> (where we move from state to state waiting for the completions) with an
>> event driven one (in theory the current one); such combinations rarely
>> lead to good things because you get a mixture of actions causing state
>> transitions some of which are waited for and some of which have an async
>> transition and that ends up confusing the heck out of everybody no
>> matter how carefully documented.  Can you give me some use cases of what
>> you're trying to achieve?  Could it be as simple as an event that fires
>> on release?
> 
> 
> The problem that we hit in iscsi is that we will call scsi_remove_target
> (we used to call scsi_remove_host when we always did a host per target
> so we hit the problem at that level before). That will complete, but the
> scsi eh might still be trying to abort/reset devices accessed through
> that target. To avoid freeing resources that the iscsi scsi eh might be
> using, we set internal state bits and wait on host_busy to go to zero
> before we tear down the iscsi session, conn and task structs.
> 
> I think Bart was hitting a similar issue but a level up in the host
> removal case, because srp always does a host per target and so it just
> does a scsi_remove_host..

I take this back. I don't think it is a issue anymore and I think I can remove the iscsi hack. With the blk_cleanup_queue/blk_drain_queue code I think the target and the removal of its devices will not complete until the scsi eh is completed. The blk_drain_queue code will now wait for the eh to complete because the rq counters will be incremented.