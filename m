From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
Date: Wed, 28 Sep 2011 02:47:23 +0200
Message-ID: <20110928004722.GA27421@kernel.dk>
References: <201109221318.p8MDIXPP020015@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201109221318.p8MDIXPP020015@pentland.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 22 2011, Hannes Reinecke wrote:
> 
> A kernel crash is observed when a mounted ext3/ext4 filesystem
> is physically removed.
> The problem is that blk_cleanup_queue() frees up some resources
> eg by calling elevator_exit(), which are not checked for in
> normal operation.
> So we should rather move these calls to the destructor function
> blk_release_queue() as at that point all remaining references
> are gone.
> However, in doing so we have to ensure that any externally
> supplied queue_lock is disconnected as the driver might
> free up the lock after the call of blk_cleanup_queue(),

Do we have acks from the people who saw this oops, that this really does
fix it for them? I ask since this fix is vastly cleaner than the other
patch floating around, so I'd much rather pull this one in.

-- 
Jens Axboe
