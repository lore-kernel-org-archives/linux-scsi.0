From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 14:37:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40423F7B.4020102@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com> <156412704.1078082931@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16589 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262119AbUB2Thp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 14:37:45 -0500
In-Reply-To: <156412704.1078082931@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Justin T. Gibbs wrote:
>>>You just need to schedule a timer to do the blk_start_queue() call.
>>>The point of doing this is so that the delay is deterministic.
>>
>>
>>Now that I understand what Jens is referring to...  this depends on the LLD.
> 
> 
> Exactly.  The block layer shouldn't be involved in this at all.  In the
> particular case I was talking about, busy or queue full with no I/O pending,
> you need to schedule a timer to unfreeze the queue since there is no
> other event that can be used to give you a deterministic delay.

Agreed for busy.

But queue full?  I hope you clear out the queue first and do some error 
handling, before calling blk_start_queue()?

Normally, calling blk_start_queue() when the queue is full would be the 
wrong thing to do :)  You call blk_stop_queue() when the queue becomes 
full, then blk_start_queue() only when the LLD's hardware signals it has 
completed a transaction...

	Jeff



