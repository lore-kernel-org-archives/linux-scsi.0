From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 12:28:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4042214F.90705@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <40421190.2030008@pobox.com> <20040229163922.GE31904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:715 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262081AbUB2R3B
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 12:29:01 -0500
In-Reply-To: <20040229163922.GE31904@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Jens Axboe wrote:
> On Sun, Feb 29 2004, Jeff Garzik wrote:
>>If you call blk_start_queue() from io completion -- as you should -- 
>>then it gets called unconditionally, regardless of whether there is IO 
>>pending or not.  The LLD should only care if it can accept more 
>>requests.  The opportunity seems to be there, to me...
> 
> 
> You are still assuming you have io pending when you call
> blk_stop_queue(). If some condition prevents you from queueing the first
> request, you call blk_stop_queue() without having anything to start the
> queue again.

ok, I got it.  I thought your "io pending" was referring to requests in 
the request_queue, not requests active in the LLD.

Still, this is the responsibility of the LLD, right?  For example, 
before any requests are ever sent to the request_queue, the LLD may 
choose to call blk_stop_queue() to prevent queueing while it probes or 
resets the bus.  That would be a case where there is no io pending, for 
both definitions of the phrase :)  And it would be up to the LLD to call 
blk_start_queue() again.  Right?

	Jeff


