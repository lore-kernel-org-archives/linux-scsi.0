From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: DPC vs tasklet
Date: Thu, 20 May 2004 13:08:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40ACE612.8020800@pobox.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63367 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265171AbUETRIt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 13:08:49 -0400
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Infante, Jon wrote:
> Christoph,
> 
> I was going to take your advice:
> "usage of tasklet itself is questionable, you probably want a kernel-thread"
> 
> and redo our driver bottom half discovery handler to use a DPC. I just
> wanted to get your opinion of why usage of a tasklet is questionable. Some
> of the LINUX documentation I've read states "tasklets are the preferred
> mechanism with which to implement your bottom half for a normal hardware
> device". I can see, as you stated, being in user context will help with
> things like allowing the use of GFP_KERNEL for memory allocations or safe
> calling of del_timer_sync(); but its not real clear to me what all the
> tradeoffs are and why some people think tasklets are the preferred
> mechanism. Can you shed some more light on this or direct me to some URLs
> with more info.


There are tradeoffs.  Using a kernel thread increases latency, and is 
not always the best choice.

It really depends on how much "work" you need to do in the interrupt 
handling and bottom-half phases.

If we are talking per-irq or per-IO, kernel thread is a poor choice.

	Jeff



