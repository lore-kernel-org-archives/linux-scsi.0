From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: don't do bogus retries
Date: Tue, 30 Sep 2008 10:39:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809301034020.2451-100000@iolanthe.rowland.org>
References: <20080930.101418.74753689.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43362 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752520AbYI3Ojx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 10:39:53 -0400
In-Reply-To: <20080930.101418.74753689.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 30 Sep 2008, Kiyoshi Ueda wrote:

> I think you should use blk_end_request(req, -EIO, blk_rq_bytes(rq))
> here instead of end_dequeued_request(req, -EIO).
> 
> end_dequeued_request() needs to be called with queue lock held,
> but I can't see any queue lock in your patches.
> Also, if you add the queue lock and still use end_dequeued_request(),
> __end_that_request_first(), which completes BIOs in the request,
> is called with the queue lock held, though it doesn't require queue
> lock actually.  So that might cause some performance regressions.

Thanks for your comments.

It sure would be nice if the locking requirements of the block layer
were documented properly!  The only description appears to be in a
comment in include/linux/blkdev.h, and it is woefully incomplete.

(There also appear to be far too many redundant entry points, but never 
mind that...)

I'll update the patch as you suggest.

Alan Stern

