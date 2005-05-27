From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 16:30:42 -0400
Message-ID: <42978372.9070607@pobox.com>
References: <20050526231938.GA31205@plap.qlogic.org> <1117224371.7379.21.camel@mulgrave> <20050527201831.GE16474@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:49120 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262575AbVE0Uas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:30:48 -0400
In-Reply-To: <20050527201831.GE16474@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> On Fri, 27 May 2005, James Bottomley wrote:
> 
> 
>>On Thu, 2005-05-26 at 16:19 -0700, Andrew Vasquez wrote:
>>
>>>Please apply, this should go in before 2.6.12 is released.
>>
>>I've got it in the rc-fixes tree for scsi.  However:
>>
>>
>>>+	spin_unlock(&ha->hardware_lock);
>>
>>Should be spin_unlock_irq(&ha->hardware_lock); shouldn't it?  Otherwise
>>we could sleep with interrupts disabled and the kernel now squeaks about
>>that.

The ha->hardware_lock is obtained without spin_lock_irq(), so that's 
correct.

The statement immediately following that one is spin_lock_irq(host_lock)


> Yes, with the latest changes being proposed/implemented by Jeff G.,
> there would need to be some additional massaging of the driver's
> eh_*() routines.

No, I think James was under the impression that ha->hardware_lock was 
obtained with spin_lock_irq()


> Jeff, could you drop the qla2xxx driver from your scrubing
> host_lock-free changes.  I'll go ahead and post an updated patch
> following the patches in my queue.

I'll filter them out appropriately.  It's easier to leave in ATM, since 
the changes are off on an unofficial dev branch noone cares about.

	Jeff


