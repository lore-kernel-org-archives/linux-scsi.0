From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Actually using the sg table/chain code
Date: Tue, 15 Jan 2008 14:14:44 -0600
Message-ID: <1200428084.9273.55.camel@localhost.localdomain>
References: <1200412337.9273.28.camel@localhost.localdomain>
	 <478D0EE0.4070208@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40552 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYAOUOt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 15:14:49 -0500
In-Reply-To: <478D0EE0.4070208@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>


On Tue, 2008-01-15 at 14:52 -0500, Jeff Garzik wrote:
> James Bottomley wrote:
> > 	if (BLK_DEF_MAX_SECTORS > max_sectors)
> > 		q->max_hw_sectors = q->max_sectors = max_sectors;
> >  	else {
> > 		q->max_sectors = BLK_DEF_MAX_SECTORS;
> > 		q->max_hw_sectors = max_sectors;
> > 	}
> > }
> > 
> > So it imposes a maximum possible setting of BLK_DEF_MAX_SECTORS which is
> > defined in blkdev.h to .... 1024, thus also forcing the queue down to
> > 128 scatterlist entries.
> > 
> > Once I raised this limit as well, I was able to transfer over 128
> > scatterlist elements during benchmark test runs of normal I/O (actually
> > kernel compiles seem best, they hit 608 scatterlist entries).
> > 
> > So my question, is there any reason not to raise this limit to something
> > large (like 65536) or even eliminate it altogether?
> 
> ISTR a thread long ago, perhaps including Andrea A (as well as Jens), 
> where 1024 sectors was arrived upon as a reasonable balance between 
> tying up gobs of VM memory on a single command (multiplied, then, across 
> N commands), and getting decent per-command throughput.
> 
> Jens probably recalls better than I...  but I'm pretty sure that the 
> 1024 limit played into "being nice with the VM" somehow.

There's certainly the writeout deadlock avoidance issue.  1024 sectors
is 128 scatterlist entries (at minimum physical merging), is currently
the maximum SCSI scatterlist from the mempools, so would always have a
logically provable forward progress clear path.  Once we go over this,
we start to get into corner cases where we have to hope that having deep
enough mempools makes the issue magically disappear.

The question is, how should we police all of this?  Should be block
layer really be blindly enforcing the 1024 sector limit ... particularly
now the default allocator won't begin chaining until we get 2048 sectors
or higher?

James


