From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 11:57:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <137982704.1078081053@aslan.btc.adaptec.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:55686 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262115AbUB2S5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 13:57:44 -0500
In-Reply-To: <20040229091350.GC3149@suse.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

>> That would imply that blk_start_queue() is OK when there is no more I/O 
>> pending...
> 
> That is the model. The problem is that you don't have an opportunitty to
> call blk_start_queue() if there's no more IO pending (you typicall do it
> from io completion). There's no problem with doing that.

You just need to schedule a timer to do the blk_start_queue() call.
The point of doing this is so that the delay is deterministic.

--
Justin

