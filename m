From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.23-rc1
Date: Sun, 29 Jul 2007 22:14:22 -0400
Message-ID: <46AD497E.8030401@garzik.org>
References: <1185720592.3434.7.camel@localhost.localdomain>	 <46AD19F7.7040905@garzik.org>	 <1185756759.3434.19.camel@localhost.localdomain>	 <46AD390B.2080400@garzik.org> <1185760909.3434.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38932 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936048AbXG3CO0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2007 22:14:26 -0400
In-Reply-To: <1185760909.3434.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2007-07-29 at 21:04 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> msleep_interruptible -> ssleep is a
>>> change with zero practical impact for this driver,
>> eh, how do you figure?
>>
>> A signal can clearly cause the abort-related functions to delay far 
>> shorter than the driver wishes.
>>
>> The msleep_interruptible() in arcmsr_wait_msgint_ready() probably isn't 
>> fatal -- unless it's there to ensure the hardware isn't pounded -- but 
>> again, a signal can cause a CPU-wasting busy loop that could last for 
>> quite a while (in CPU terms).
> 
> I didn't say the usage wasn't a bad example or couldn't cause problems
> in certain cases.  I said "zero practical effect".  This is because the
> two possible threads that enter these routines already have all user
> signals blocked.

Ah!  Understood.

	Jeff



