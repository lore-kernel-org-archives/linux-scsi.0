From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 14:43:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404240CC.5020507@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com> <156412704.1078082931@aslan.btc.adaptec.com> <40423F7B.4020102@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49871 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262120AbUB2TnV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 14:43:21 -0500
In-Reply-To: <40423F7B.4020102@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Jeff Garzik wrote:
> But queue full?  I hope you clear out the queue first and do some error 
> handling, before calling blk_start_queue()?
> 
> Normally, calling blk_start_queue() when the queue is full would be the 
> wrong thing to do :)  You call blk_stop_queue() when the queue becomes 
> full, then blk_start_queue() only when the LLD's hardware signals it has 
> completed a transaction...

Actually, thinking more about it, I guess this depends (again) on the LLD...

when does queue-full occur, when the LLD itself cannot clear the 
condition?  During an error/failure condition?

	Jeff


