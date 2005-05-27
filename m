From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 03:48:40 -0400
Message-ID: <4296D0D8.6030907@pobox.com>
References: <4296A2C7.4090107@pobox.com> <20050527071109.GB27256@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:51677 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261965AbVE0Hso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 03:48:44 -0400
In-Reply-To: <20050527071109.GB27256@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Fri, May 27, 2005 at 12:32:07AM -0400, Jeff Garzik wrote:
> 
>>SCSI EH processing already serializes things during EH, so this spinlock 
>>isn't really needed.
>>
>>Removing the spinlock outright would break drivers that surround logic 
>>with spin_unlock_irq()..spin_lock_irq(), so I introduced ->unlocked_eh 
>>option.
> 
> 
> Linus has vetoed such conditional locking in the past.  However if you do
> it don't make it EH specific but introduce a ->concurrent flag that disables
> taking host_lock for ->queuecommand aswell.

Such a 'concurrent' flag violates Linus credo "do what you must, and no 
more."  It's also silly and much too invasive.

Removing the locking from the EH routines (only), and fixing up all 
necessary drivers, is much more appealing.

	Jeff


