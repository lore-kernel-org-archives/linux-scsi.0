From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix oops in blk_run_queue()
Date: Wed, 25 May 2011 13:28:41 +0200
Message-ID: <4DDCE7E9.5090107@kernel.dk>
References: <bug-35282-11613@https.bugzilla.kernel.org/>	 <201105191944.p4JJiVVm029690@demeter1.kernel.org> <1306257531.10201.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56030 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1EYL2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2011 07:28:45 -0400
In-Reply-To: <1306257531.10201.20.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 2011-05-24 19:18, James Bottomley wrote:
> Bugzilla report is here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=35682
> 
> The problem occurs if blk_run_queue() or its variants is called after
> blk_cleanup_queue() is called.  The run checks should have a state guard
> for QUEUE_FLAG_DEAD.  Since a DEAD queue is always STOPPED, just fold it
> into the blk_queue_stopped() test.
> 
> Signed-off-by: James Bottomley <jbottomley@parallels.com>
> 
> ---
> 
> Jens, can you look at this, please ... would you prefer a separate DEAD
> test instead?  Incidentally, this is in addition to the other DEAD test
> you still haven't applied ...

Seems a bit of a mixup. Would be cleaner to set STOPPED when it is
marked dead, but I suspect that will kill erroring out IO when the
device goes away unless we add some logic to ensure that happens without
the drivers help.

-- 
Jens Axboe

