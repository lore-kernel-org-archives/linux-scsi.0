From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 16:42:21 -0400
Message-ID: <4297862D.5070500@pobox.com>
References: <20050526231938.GA31205@plap.qlogic.org>	 <1117224371.7379.21.camel@mulgrave>	 <20050527201831.GE16474@plap.qlogic.org>  <42978372.9070607@pobox.com> <1117226305.7379.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:53984 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262585AbVE0UmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:42:25 -0400
In-Reply-To: <1117226305.7379.30.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2005-05-27 at 16:30 -0400, Jeff Garzik wrote:
> 
>>The ha->hardware_lock is obtained without spin_lock_irq(), so that's 
>>correct.
> 
> 
> Yes, that was my confusion
> 
> But ... I wish you hadn't pointed it out.  Now I look at the driver, the
> ha->hardware_lock is taken at interrupt level (in the interrupt
> routines).
> 
> However, this sequence of code:
> 
> 	spin_unlock_irq(ha->host->host_lock);
> 	spin_lock(&ha->hardware_lock);
> 
> Enables interrupts then takes this lock.  If we ever get a qla interrupt
> before we drop the ha->hardware_lock again, that will be a classic
> deadlock.

Agreed, this was my analysis as well.

This driver appears to get locking -backwards-:

it uses spin_lock_irqsave() in interrupt handler.
it does not use spin_lock_irqsave() outside interrupt handler.

IMO this is a 2.6.12-rc issue...

	Jeff



