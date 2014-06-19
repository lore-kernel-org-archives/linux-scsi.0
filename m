From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: scheduling while atomic in blk_mq codepath?
Date: Fri, 20 Jun 2014 08:38:20 +1000
Message-ID: <20140619223820.GN4453@dastard>
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
 <20140619160801.GB4907@thunk.org>
 <20140619162144.GC4907@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:44424 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbaFSWiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2014 18:38:24 -0400
Content-Disposition: inline
In-Reply-To: <20140619162144.GC4907@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 19, 2014 at 12:21:44PM -0400, Theodore Ts'o wrote:
> On Thu, Jun 19, 2014 at 12:08:01PM -0400, Theodore Ts'o wrote:
> > > The other issue, not sure, not a lot of detail. It may be fixed by the pull
> > > request I sent out yesterday. You can try pulling in:
> > > 
> > > git://git.kernel.dk/linux-block.git for-linus
> > 
> > Thanks, I'll give that a try.
> 
> I tried merging in your for-linus branch in v3.16-rc1, and I'm seeing
> the following.  On a 32-bit x86 3.15 kernel, run: "mke2fs -t ext3
> /dev/vdc" where /dev/vdc is a 5 gig virtio partition.

Short reads are more likely a bug in all the iovec iterator stuff
that got merged in from the vfs tree. ISTR a 32 bit-only bug in that
stuff go past in to do with not being able to partition a 32GB block
dev on a 32 bit system due to a 32 bit size_t overflow somewhere....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
