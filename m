From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Tue, 29 Jul 2008 19:36:59 +0400
Message-ID: <488F391B.5090504@vlnb.net>
References: <488E02DE.5080100@vlnb.net>	 <20080728180745.GE12762@plap4-2.qlogic.org>  <488EE3A9.8030207@vlnb.net>	 <1217342457.6103.4.camel@localhost.localdomain> <488F3393.1010907@vlnb.net> <1217345281.6103.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:58706 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751529AbYG2PhB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 11:37:01 -0400
In-Reply-To: <1217345281.6103.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net


James Bottomley wrote:
> On Tue, 2008-07-29 at 19:13 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley wrote:
>>> On Tue, 2008-07-29 at 13:32 +0400, Vladislav Bolkhovitin wrote:
>>>> Nope, taking only one that hunk from this patch isn't sufficient.
>>>> Around 
>>>> dpc_thread there is pretty simple and classical race. You can't do
>>>>
>>>> if (x != NULL)
>>>>         y = *x;
>>>>
>>>> without any protection, if x can be set to NULL by another thread. It 
>>>> can happen exactly between "if" and "*x" and hence lead to a crash,
>>>> correct?
>>> No.
>> What "No"? The above unlocked "if (x != NULL) y = *x;" is always safe 
>> now? ;)
> 
> No ... no as in your analysis based on the example is not correct to
> conclude protection is required.  We have quite a number of examples of
> this within the linux kernel (the SCSI error thread would be one).
> 
>>> Today we go to reasonable lengths to avoid additional locking.
>>> Spinlocks are nasty in most boxes because of the potential for
>>> introducing hot points and cacheline bouncing.
>>>
>>> The first question you ask is how hot is the variable ... as in how
>>> constantly changing is it?  This one is set at start of day and cleared
>>> when the thread is killed in shutdown.  Basically there's a single not
>>> NULL -> NULL transition.  Once NULL, it never goes back to not NULL.
>>>
>>> The point is that in this particular circumstance, the lock is overkill.
>>> You can either use other indicators to show that the driver is being
>>> removed (and the thread is dying) or you can simply use some type of
>>> refcounting to ensure the thread isn't killed until it's no longer
>>> needed.
>>>
>>> Even if it were a constantly changing variable, and therefore a more
>>> ideal candidate for locking, we might still look into atomics and bitops
>>> before adding a lock.
>> Sure, all you wrote above is correct, but in this *particular* case what 
>> you propose is an overkill, not use of the spinlock. Waking up DPC 
>> thread isn't on the hot path by any mean, it's quite rare event. So, all 
>> those lockfree techniques comparing to a simple single lock would 
>> introduce only additional complicated code without any measurable gain.
> 
> It's important to think about this kind of thing even in cases where it
> doesn't necessarily matter that much just so it becomes standard
> practice in cases where it does.

Agree. For example, in SCST core translation from LUN to internal device 
is done in a lockless manner. As well as commands serialization.

>> But, as I already wrote, I don't care much how this problem will be 
>> fixed. I care only that it should be fixed. So, my point was only that 
>> use from my patch only one hunk
>>
>> -		wake_up_process(ha->dpc_thread);
>> +		qla2xxx_wake_dpc(ha);
>>
>> is insufficient to fix the problem.
> 
> Yes, I agree with that ... I just want to see a better fix.

Let's see then what Andrew will say.

> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
