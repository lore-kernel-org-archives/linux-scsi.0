From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 18:47:02 -0400
Message-ID: <4297A366.3000706@pobox.com>
References: <20050526231938.GA31205@plap.qlogic.org> <1117224371.7379.21.camel@mulgrave> <20050527201831.GE16474@plap.qlogic.org> <42978372.9070607@pobox.com> <1117226305.7379.30.camel@mulgrave> <4297862D.5070500@pobox.com> <20050527220447.GA21593@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:36577 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262633AbVE0WrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 18:47:10 -0400
In-Reply-To: <20050527220447.GA21593@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> On Fri, 27 May 2005, Jeff Garzik wrote:
> 
> 
>>James Bottomley wrote:
>>
>>>On Fri, 2005-05-27 at 16:30 -0400, Jeff Garzik wrote:
>>>
>>>
>>>>The ha->hardware_lock is obtained without spin_lock_irq(), so that's 
>>>>correct.
>>>
>>>
>>>Yes, that was my confusion
>>>
>>>But ... I wish you hadn't pointed it out.  Now I look at the driver, the
>>>ha->hardware_lock is taken at interrupt level (in the interrupt
>>>routines).
>>>
>>>However, this sequence of code:
>>>
>>>	spin_unlock_irq(ha->host->host_lock);
>>>	spin_lock(&ha->hardware_lock);
>>>
>>>Enables interrupts then takes this lock.  If we ever get a qla interrupt
>>>before we drop the ha->hardware_lock again, that will be a classic
>>>deadlock.
>>
>>Agreed, this was my analysis as well.
>>
>>This driver appears to get locking -backwards-:
>>
>>it uses spin_lock_irqsave() in interrupt handler.
> 
> 
> Actually, the ISR function is used as a polling function during
> hardware initialization.  But since at that point we've never
> registered it via request_irq(), it's safe to not use the
> _irqsave()/_irqrestore() variants.

I see what's going on, thanks for explaining.

Note using _irqsave in the interrupt handler is not recommended and 
quite unusual, for performance reasons if nothing else.  The fast, 
common path [interrupt handler] should use the least expensive spinlock 
variant: spin_lock().  This implies that other [slow] paths need to be 
changed to call local_irq_save() or spin_lock_irq() or whatnot.

	Jeff


