From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 12:49:25 -0400
Message-ID: <42974F95.6010603@pobox.com>
References: <4296A2C7.4090107@pobox.com> <20050527071109.GB27256@infradead.org> <4296D0D8.6030907@pobox.com> <20050527075924.GA28608@infradead.org> <4296DC0B.9060802@pobox.com> <42974E19.9040007@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:63967 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262500AbVE0Qt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 12:49:29 -0400
In-Reply-To: <42974E19.9040007@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> On 05/27/05 04:36, Jeff Garzik wrote:
> 
>>Christoph Hellwig wrote:
>>
>>>No, hav ing the host_lock only held for ->queuecommand which doesn't
>>>need that locking doesn't make any sense.  An API like the current one
>>
>>
>>It makes a lot of sense:  LLDs are written with the assumption that 
>>paths called from ->queuecommand will not be interrupted by their own 
>>interrupt handler, whereas error handling paths are typically written 
>>with precisely the -opposite- assumption.
>>
>>Removing spin_lock_irq() from queuecommand in SCSI EH causes problems, 
>>and solves nothing.
> 
> 
> scsi_done() itself needs no explicit locking, it is completely reentrant
> and this is a good thing.
> 
> I'd like to see the same thing for queuecommand(), i.e. host_lock be gone.

We can take up that topic once I'm done with sleeping-in-EH project :)

I don't disagree...   but changing the locking for ->queuecommand() is a 
-lot- more invasive, and requires much more care.

I'm also curious to see what others think about removing the host_lock 
acquisition from ->queuecommand() calls.

	Jeff


