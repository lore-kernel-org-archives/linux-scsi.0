From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 12:28:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <156412704.1078082931@aslan.btc.adaptec.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:31128 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262114AbUB2T27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 14:28:59 -0500
In-Reply-To: <404236C1.5000001@pobox.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

>> You just need to schedule a timer to do the blk_start_queue() call.
>> The point of doing this is so that the delay is deterministic.
> 
> 
> Now that I understand what Jens is referring to...  this depends on the LLD.

Exactly.  The block layer shouldn't be involved in this at all.  In the
particular case I was talking about, busy or queue full with no I/O pending,
you need to schedule a timer to unfreeze the queue since there is no
other event that can be used to give you a deterministic delay.

--
Justin

