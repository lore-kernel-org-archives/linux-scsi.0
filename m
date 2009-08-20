From: Christoph Hellwig <hch@infradead.org>
Subject: O_DIRECT and barriers
Date: Thu, 20 Aug 2009 18:12:21 -0400
Message-ID: <20090820221221.GA14440@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Btw, something semi-related I've been looking at recently:

Currently O_DIRECT writes bypass all kernel caches, but there they do
use the disk caches.  We currenly don't have any barrier support for
them at all, which is really bad for data integrity in virtualized
environments.  I've started thinking about how to implement this.

The simplest scheme would be to mark the last request of each
O_DIRECT write as barrier requests.  This works nicely from the FS
perspective and works with all hardware supporting barriers.  It's
massive overkill though - we really only need to flush the cache
after our request, and not before.  And for SCSI we would be much
better just setting the FUA bit on the commands and not require a
full cache flush at all.

The next scheme would be to simply always do a cache flush after
the direct I/O write has completed, but given that blkdev_issue_flush
blocks until the command is done that would a) require everyone to
use the end_io callback and b) spend a lot of time in that workque.
This only requires one full cache flush, but it's still suboptimal.

I have prototypes this for XFS, but I don't really like it.

The best scheme would be to get some highlevel FUA request in the
block layer which gets emulated by a post-command cache flush.
