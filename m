From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sat, 28 Feb 2004 18:50:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4041292C.3090700@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2221 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261945AbUB1XuR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 18:50:17 -0500
In-Reply-To: <20040228092512.GD923@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Jens Axboe wrote:
> The only nasty right now is that you cannot unconditionally call
> blk_stop_queue(), it requires a manual blk_start_queue() on io
> completion which will only happen if io is pending of course. I just got
> an idea on how to do that properly, I'll make sure it works in any case.

hmmm...  I thought the model was to call blk_stop_queue() when you can 
accept no more requests, and call blk_start_queue() once you can start 
accepting more requests.

That would imply that blk_start_queue() is OK when there is no more I/O 
pending...

	Jeff



