From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: 04 Feb 2003 19:53:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044410039.3485.61.camel@mulgrave>
References: <20030204162326.A30755@lst.de>
	<20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de>
	<20030204091955.A24785@beaverton.ibm.com>
	<1044383605.2014.23.camel@mulgrave> <20030204202935.A325@lst.de>
	<1044399797.3484.15.camel@mulgrave>
	<20030204172505.A28812@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id RAA21224
	for <linux-scsi@vger.kernel.org>; Tue, 4 Feb 2003 17:54:04 -0800
In-Reply-To: <20030204172505.A28812@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-04 at 19:25, Patrick Mansfield wrote:
> But if we have a lot of prepped commands around we will be allocating
> memory that is not (currently) needed, we could end up using an equal
> number of scsi_cmnd's as we have blk requests. I would rather we not
> allocate or hold onto scsi_cmnd in such cases. (And generally in all
> cases, but that goes beyond.)

But that's not how the block queue works: prep is actually called from
elv_next_request().  Therefore, if you plug the queue in the request
function when you're over the queue limit, you only get a single fully
prepped request waiting in the queue, which, I think, is the desired
behaviour.  Even if the queue is restarted because of I/O pressure, it
will begin with the prepped request and re-block.

> We are still missing single_lun checking.

And the slave_{alloc,configure,destroy} needs fixing too.

> I would like to see the patch in a tree before 2.5.60 (probably already
> too late), and then we can take care of these other issues. I think some
> systems/disks will barf if they are flooded with QUEUE FULLs.

OK, I concur, we can't do without throttling. I'll put it in and we can
try to fix up around it.

James


