From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] BNX2I: Fixed kernel panic due to illegal usage of sc->request->cpu
Date: Thu, 14 Jul 2011 02:20:09 -0500
Message-ID: <4E1E98A9.8070907@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1310408095-11882-1-git-send-email-eddie.wai@broadcom.com> <4E1B56F3.20507@cs.wisc.edu> <1310625223.3678.130.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36437 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1GNHRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 03:17:44 -0400
In-Reply-To: <1310625223.3678.130.camel@ltirv-waie-lx1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <jbottomley@parallels.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On 07/14/2011 01:33 AM, Eddie Wai wrote:
> 
> On Mon, 2011-07-11 at 13:02 -0700, Mike Christie wrote:
>> On 07/11/2011 01:14 PM, Eddie Wai wrote:
>>> A kernel panic was observed when passing the sc->request->cpu = -1 to
>>> retrieve the per_cpu variable pointer:
>>>  #0 [ffff880011203960] machine_kexec at ffffffff81022bc3
>>>  #1 [ffff8800112039b0] crash_kexec at ffffffff81088630
>>>  #2 [ffff880011203a80] __die at ffffffff8139ea20
>>>  #3 [ffff880011203aa0] no_context at ffffffff8102f3a7
>>>  #4 [ffff880011203ae0] __bad_area_nosemaphore at ffffffff8102f665
>>>  #5 [ffff880011203ba0] retint_signal at ffffffff8139dd1f
>>>  #6 [ffff880011203cc8] bnx2i_indicate_kcqe at ffffffffa03dc4f2
>>>  #7 [ffff880011203da8] service_kcqes at ffffffffa03cb04f
>>>  #8 [ffff880011203e68] cnic_service_bnx2x_kcq at ffffffffa03cb14a
>>>  #9 [ffff880011203e88] cnic_service_bnx2x_bh at ffffffffa03cb1b3
>>>
>>> The problem lies in the sg_io (and perhaps sg_scsi_ioctl) call to
>>> blk_get_request->get_request/wait->blk_alloc_request->blk_rq_init which
>>> re-initializes the request->cpu to -1.  There is no assignment for cpu from
>>> that to the request_fn call to low level drivers.
>>>
>>> When this happens, the sc->request->cpu will be using the init value of
>>> -1.  This will create a kernel panic when it hits bnx2i because the code
>>> refers it to get the per_cpu variables ptr.
>>>
>>> This change is to put in a guard against that and also for cases when
>>> CONFIG_SMP/BIO_CPU_AFFINE is not enabled.  In those cases, the cpu
>>> affinitization code would not get run in __make_request either; hence
>>> the request->cpu will remain a -1 also.
>>>
>>
>>
>>>
>>> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>> index 5c55a75..622383d 100644
>>> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>> @@ -1225,6 +1225,10 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
>>>  	if (!sc)
>>>  		return bnx2i_mtask_xmit(conn, task);
>>>  
>>> +	if (!blk_rq_cpu_valid(sc->request)) {
>>> +		sc->request->cpu = get_cpu();
>>> +		put_cpu();
>>> +	}
>>
>>
>> If I understand you right, then I think this needs to get fixed in the
>> block or scsi layer instead of each LLD.
> 
> Absolutely, but this bnx2i fix is still applicable alongside the fixes I'm
> proposing in the block layer below.
> 
> I think the whole idea behind the tracking of the blk req->cpu is so that the blk completion
> can be fired off from the same CPU to take advantage of the CPU's llc.  However, this is only being
> done when the queue is defined with the QUEUE_FLAG_SAME_COMP queue_flag enabled.  In the case
> when the queue is defined without this enforced, it would then be up to the blk completion
> code to complete the blk request with the current CPU of the thread.
> 
> The same analogy should apply to the iSCSI LLD for cmd completion as well.  So if the
> sc->request->cpu is left at -1, the LLD should then decide how it wants the cmd completion
> to take place.  For all the other cases, the request->cpu id should be used instead.  
> For bnx2i, if the blk layer didn't set the request->cpu, we would want to align and complete
> the cmd against the task_xmit issuer's CPU id unconditionally; hence the explicit get_cpu call.

I actually think all this should go in the block layer. We should not
have driver specific setting/interfaces for this. The driver should be
able to just have the block layer complete all the IO on some soft
irq/thread and do the right thing. Then we can have one interface in the
block layer too.

We do not want to end up with every driver adding some sysfs/modparm
interfaces to control if we are going to complete the IO on the same
cpu, round robin cpus, etc.

I think we need to change the blkio poll code so it is usefull to
everyone. It does not make sense for every driver to want to do some
completion processing in a thread/softirq then have every driver create
their own threading and completing code/policies. From there we can have
a common interface to control the cpu completion polciy.

It will be really strange to tell users that in one case we use the
block layer policy but in another case we use the LLD policy interface.

I think right now we are ending up with a mess where someone can set the
rq_affinity, the LLD will ignore this and do round robin completion on
its own threads, then when the block layer soft irq completion code runs
it will complete on the cpu set by the rq_affinity code.

> 
> In the current block code, this CPU affinity code is only being called in the __make_request
> code path. I believe the same code needs to be executed in all the other code paths where
> the blk request is being added to the queue for execution.  This change will then properly
> place the desired CPU to the request->cpu when the queue is defined with QUEUE_FLAG_SAME_COMP.
> Otherwise, the request->cpu will assume the init value of -1.
> 

I am not disagreeing with that.
