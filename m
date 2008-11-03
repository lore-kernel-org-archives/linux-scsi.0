From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problems with the block-layer timeouts
Date: Mon, 3 Nov 2008 18:27:00 +0100
Message-ID: <20081103172700.GW31673@kernel.dk>
References: <Pine.LNX.4.44L0.0811031051210.2454-100000@iolanthe.rowland.org> <490F2953.30709@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:58972 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYKCR2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 12:28:20 -0500
Content-Disposition: inline
In-Reply-To: <490F2953.30709@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Tue, Nov 04 2008, Tejun Heo wrote:
> I'm trying to convert all drivers to use the same command issue model -
> elv_next_request() -> blkdev_dequeue_request() on actual issue ->
> blk_end_request().  I have first draft of the conversion patchset but
> it's gonna take me a few more days to review and test what I can as
> several drivers (mostly legacy ones) are a bit tricky.

Don't do that, please. What we need to do is ensure that the model fits
with whatever the driver wants to do there, and for some drivers it's
actually a lot easier to rely on elv_next_request() returning the same
requests again instead of keeping track of it yourself. So any patch
that enforces the model that you must dequeue before starting the
request, will get a big nak from me.

What we need to do is add a 'peek' mode only, which doesn't start the
request. Along with something to mark it started that the driver can
use, or it can just use elv_next_request() of course.

> For the time being, SCSI layer is the only block layer timeout user and
> completion w/o dequeuing is only for error cases in SCSI, so the
> inefficiency there shouldn't matter too much.

Agree, for now we are ok since it's just SCSI.

-- 
Jens Axboe

