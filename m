From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 14:00:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404236C1.5000001@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41420 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262107AbUB2TAb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 14:00:31 -0500
In-Reply-To: <137982704.1078081053@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Justin T. Gibbs wrote:
>>>That would imply that blk_start_queue() is OK when there is no more I/O 
>>>pending...
>>
>>That is the model. The problem is that you don't have an opportunitty to
>>call blk_start_queue() if there's no more IO pending (you typicall do it
>>from io completion). There's no problem with doing that.
> 
> 
> You just need to schedule a timer to do the blk_start_queue() call.
> The point of doing this is so that the delay is deterministic.


Now that I understand what Jens is referring to...  this depends on the 
LLD.  In network drivers (from which the model I speak of originated) 
and in the upcoming block-level SATA drivers, a delay not needed.  The 
LLD calls blk_start_queue() when it is ready to receive requests -- 
which is not a time-based constraint.

	Jeff



