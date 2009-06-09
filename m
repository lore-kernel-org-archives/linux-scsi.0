From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
	handler
Date: Tue, 9 Jun 2009 15:41:27 -0600
Message-ID: <20090609214127.GP3274@parisc-linux.org>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site> <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site> <F368E6E3-609E-43FD-81C2-163B6650CB67@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52111 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZFIVlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:41:25 -0400
Content-Disposition: inline
In-Reply-To: <F368E6E3-609E-43FD-81C2-163B6650CB67@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, linux-scsi@vger.kernel.org, douglas.w.styner@intel.com, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Zijlstra <peterz@infradead.org>

On Tue, Jun 09, 2009 at 02:28:01PM -0700, Giridhar Malavali wrote:
> On Jun 9, 2009, at 1:40 PM, James Bottomley wrote:
>> It depends what the root cause is ... if it's really latency  
>> introduced
>> by other interrupts, then IRQF_DISABLED might be the better course.   
>> If
>> it's purely interrupt problems in the spin locked critical sections,
>> then spin_lock_irq might be the better solution ... what would be  
>> useful
>> is to have the test rig at intel which turned up the problem see what
>> happens to the results for each case.
>
> Earlier, I have seen that when IRQ's are shared across multiple  
> controllers and if the first one to register (among shared controllers) 
> does not disable the IRQ with IRQF_DISABLED flag,then irrespective of the 
> IRQ registration from other controllers, the IRQ will be enabled by 
> default. With this behavior and qla2xxx sharing the IRQ, just disabling 
> the IRQ may not be sufficient.

But MSI interrupts are never shared.  Also, almost every driver *should*
be using IRQF_DISABLED these days (there was a proposal to eliminate
IRQF_DISABLED and force every driver to explicitly re-enable interrupts
if it needed them on back in March).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
