From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RFC: split scsi passthrough fields out of struct request
Date: Wed, 11 Jan 2017 17:41:42 -0500
Message-ID: <20170111224142.GA19238@redhat.com>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbdAKWln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 17:41:43 -0500
Content-Disposition: inline
In-Reply-To: <1484060780-15592-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Tue, Jan 10 2017 at 10:06am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> this series splits the support for SCSI passthrough commands from the
> main struct request used all over the block layer into a separate
> scsi_request structure that drivers that want to support SCSI passthough
> need to embedded as the first thing into their request-private data,
> similar to how we handle NVMe passthrough commands.
> 
> To support this I've added support for that the private data after
> request structure to the legacy request path instead, so that it can
> be treated the same way as the blk-mq path.  Compare to the current
> scsi_cmnd allocator that actually is a major simplification.
> 
> There is one major show-stopper for the series as-is:  Request-based
> device mapper currently allocate the request structures in the stacking
> driver without a knowledge of the queue it's going to be submitte on
> for the legacy request path.  It managed to avoid that issue for the
> blk-mq path, but that currently can't be used on legacy request devices
> for reasons I don't fully understand.  We'll need to figure out how
> sort this out, but maybe that's a good opportunity to drop one or two
> of the three different dm-mpath I/O paths? :)

Ah, should've read the 0th patch earlier..

I removed blk-mq on request_fn paths support because it was one of the
permutations that I felt least useful/stable (see commit c5248f79f3 "dm:
remove support for stacking dm-mq on .request_fn device(s)")

As for all of the different IO paths.  I've always liked the idea of
blk-mq ruling the world.  With Jens' blk-mq IO scheduling advances maybe
we're closer!
