From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Mon, 25 May 2009 12:49:08 +0200
Message-ID: <20090525104908.GV11363@kernel.dk>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com> <20090525074124.GA31746@infradead.org> <20090525074647.GK11363@kernel.dk> <20090525075008.GA23413@infradead.org> <4A1A7406.5060106@panasas.com> <20090525104215.GA3191@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:54925 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZEYKtH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2009 06:49:07 -0400
Content-Disposition: inline
In-Reply-To: <20090525104215.GA3191@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Mon, May 25 2009, Christoph Hellwig wrote:
> On Mon, May 25, 2009 at 01:33:42PM +0300, Boaz Harrosh wrote:
> > 1. If we have a machine with few type of hosts active each with it's own
> > cmnd_slab we end up with many more slabs then today. Even though at the
> > end they all happen to be of the same size. (With the pool reserves it
> > can get big also).
> 
> Note that this should be optional.  Device not having their own
> per-command structure would continue using the global pools.  Those
> that have their own per-command structures already have their own pools
> anyway.

The multiple pools of the same size "issue" can also easily be resolved
by having SCSI provide a way to setup/destroy these pools. Then it can
just reuse an existing pool, if it has the same size.

However, I doubt that this is really a real life issue that's worth
worrying about.

-- 
Jens Axboe

