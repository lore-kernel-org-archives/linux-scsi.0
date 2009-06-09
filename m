From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
 handler
Date: Tue, 09 Jun 2009 21:46:21 +0000
Message-ID: <1244583981.12321.154.camel@mulgrave.site>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>
	 <1244575944.12321.58.camel@mulgrave.site>
	 <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com>
	 <1244580029.12321.138.camel@mulgrave.site>
	 <F368E6E3-609E-43FD-81C2-163B6650CB67@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54430 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397AbZFIVqX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:46:23 -0400
In-Reply-To: <F368E6E3-609E-43FD-81C2-163B6650CB67@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, linux-scsi@vger.kernel.org, douglas.w.styner@intel.com

On Tue, 2009-06-09 at 14:28 -0700, Giridhar Malavali wrote:
> On Jun 9, 2009, at 1:40 PM, James Bottomley wrote:
> 
> > On Tue, 2009-06-09 at 13:34 -0700, Anirban Chakraborty wrote:
> >> On Jun 9, 2009, at 12:32 PM, James Bottomley wrote:
> >>
> >>> On Tue, 2009-06-09 at 11:42 -0700, Anirban Chakraborty wrote:
> >>>> Reverted back a change from spin_lock to spin_lock_irq* that was
> >>>> causing
> >>>> the cycle times to go up.
> >>>> The patch is based on scsi-misc-2.6.
> >>>
> >>> Some more explanation of this would be greatly appreciated.  The  
> >>> cause
> >>> looks to be that holding off interrupts in the isr could potentially
> >>> reduce latency (caused by taking a different interrupt while holding
> >>> the
> >>> hardware lock) and increase the chance of coalescing (by holding off
> >>> interrupts).  However, if that's the case, possibly using an
> >>> IRQF_DISABLED isr rather than going back to spin_lock_irqsave()
> >>> would be
> >>> a better fix?
> >> The primary cause is, as you mentioned, the contention for the
> >> hardware lock in the isr.
> >> I'll check it with IRQF_DISABLED too. However, I was wondering if
> >> there is any additional savings if we use IRQF_DISABLED vs. using the
> >> spin_lock_irqsave. In the former case, probably we'd enter the isr
> >> with interrupts disabled and in the latter case it would be done upon
> >> entering the isr.
> >
> > It depends what the root cause is ... if it's really latency  
> > introduced
> > by other interrupts, then IRQF_DISABLED might be the better course.   
> > If
> > it's purely interrupt problems in the spin locked critical sections,
> > then spin_lock_irq might be the better solution ... what would be  
> > useful
> > is to have the test rig at intel which turned up the problem see what
> > happens to the results for each case.
> >
> > James
> >
> >
> Earlier, I have seen that when IRQ's are shared across multiple  
> controllers and if the first one to register (among shared  
> controllers) does not disable the IRQ with IRQF_DISABLED flag,then  
> irrespective of the IRQ registration from other controllers, the IRQ  
> will be enabled by default. With this behavior and qla2xxx sharing the  
> IRQ, just disabling the IRQ may not be sufficient.

Well, they're MSI interrupts, so unshared.  However, an equivalent trick
is just to do local_irq_disable() at the top of the interrupt routine.
There was a thread about making IRQF_DISABLED the default, which is what
made me think about it.

Anyway, I think the point is it would be interesting to see if we can
improve performance by holding off interrupts for all of the qla isr ...
if this is validated, we can move on to implementation discussions.

James


