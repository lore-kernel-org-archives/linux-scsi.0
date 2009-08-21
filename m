From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 13:40:10 +0200
Message-ID: <20090821114010.GG12579@kernel.dk>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:36671 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZHULkJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 07:40:09 -0400
Content-Disposition: inline
In-Reply-To: <20090820221221.GA14440@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Aug 20 2009, Christoph Hellwig wrote:
> Btw, something semi-related I've been looking at recently:
> 
> Currently O_DIRECT writes bypass all kernel caches, but there they do
> use the disk caches.  We currenly don't have any barrier support for
> them at all, which is really bad for data integrity in virtualized
> environments.  I've started thinking about how to implement this.
> 
> The simplest scheme would be to mark the last request of each
> O_DIRECT write as barrier requests.  This works nicely from the FS
> perspective and works with all hardware supporting barriers.  It's
> massive overkill though - we really only need to flush the cache
> after our request, and not before.  And for SCSI we would be much
> better just setting the FUA bit on the commands and not require a
> full cache flush at all.
> 
> The next scheme would be to simply always do a cache flush after
> the direct I/O write has completed, but given that blkdev_issue_flush
> blocks until the command is done that would a) require everyone to
> use the end_io callback and b) spend a lot of time in that workque.
> This only requires one full cache flush, but it's still suboptimal.
> 
> I have prototypes this for XFS, but I don't really like it.
> 
> The best scheme would be to get some highlevel FUA request in the
> block layer which gets emulated by a post-command cache flush.

I've talked to Chris about this in the past too, but I never got around
to benchmarking FUA for O_DIRECT. It should be pretty easy to wire up
without making too many changes, and we do have FUA support on most SATA
drives too. Basically just a check in the driver for whether the
request is O_DIRECT and a WRITE, ala:

        if (rq_data_dir(rq) == WRITE && rq_is_sync(rq))
                WRITE_FUA;

I know that FUA is used by that other OS, so I think we should be golden
on the hw support side.

-- 
Jens Axboe

