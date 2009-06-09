From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt handler
Date: Tue, 9 Jun 2009 14:28:01 -0700
Message-ID: <F368E6E3-609E-43FD-81C2-163B6650CB67@qlogic.com>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site> <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:44677 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbZFIV17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:27:59 -0400
In-Reply-To: <1244580029.12321.138.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: linux-scsi@vger.kernel.org, douglas.w.styner@intel.com, James Bottomley <James.Bottomley@HansenPartnership.com>


On Jun 9, 2009, at 1:40 PM, James Bottomley wrote:

> On Tue, 2009-06-09 at 13:34 -0700, Anirban Chakraborty wrote:
>> On Jun 9, 2009, at 12:32 PM, James Bottomley wrote:
>>
>>> On Tue, 2009-06-09 at 11:42 -0700, Anirban Chakraborty wrote:
>>>> Reverted back a change from spin_lock to spin_lock_irq* that was
>>>> causing
>>>> the cycle times to go up.
>>>> The patch is based on scsi-misc-2.6.
>>>
>>> Some more explanation of this would be greatly appreciated.  The  
>>> cause
>>> looks to be that holding off interrupts in the isr could potentially
>>> reduce latency (caused by taking a different interrupt while holding
>>> the
>>> hardware lock) and increase the chance of coalescing (by holding off
>>> interrupts).  However, if that's the case, possibly using an
>>> IRQF_DISABLED isr rather than going back to spin_lock_irqsave()
>>> would be
>>> a better fix?
>> The primary cause is, as you mentioned, the contention for the
>> hardware lock in the isr.
>> I'll check it with IRQF_DISABLED too. However, I was wondering if
>> there is any additional savings if we use IRQF_DISABLED vs. using the
>> spin_lock_irqsave. In the former case, probably we'd enter the isr
>> with interrupts disabled and in the latter case it would be done upon
>> entering the isr.
>
> It depends what the root cause is ... if it's really latency  
> introduced
> by other interrupts, then IRQF_DISABLED might be the better course.   
> If
> it's purely interrupt problems in the spin locked critical sections,
> then spin_lock_irq might be the better solution ... what would be  
> useful
> is to have the test rig at intel which turned up the problem see what
> happens to the results for each case.
>
> James
>
>
Earlier, I have seen that when IRQ's are shared across multiple  
controllers and if the first one to register (among shared  
controllers) does not disable the IRQ with IRQF_DISABLED flag,then  
irrespective of the IRQ registration from other controllers, the IRQ  
will be enabled by default. With this behavior and qla2xxx sharing the  
IRQ, just disabling the IRQ may not be sufficient.

Giridhar.M.B



> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

