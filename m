From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Sat, 11 Oct 2014 04:05:05 -0700
Message-ID: <20141011110505.GA2928@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaJKLFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Oct 2014 07:05:13 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On Fri, Oct 10, 2014 at 11:32:26PM +0000, Elliott, Robert (Server Storage) wrote:
> Problem
> =======
> If you run sg_reset --device concurrently to multiple
> devices on the same host, then some of them will run
> into tmf_in_progress and have scsi_nonblockable_ioctl
> return -ENODEV.  This causes sd_ioctl to send the ioctl
> request to the LLD's ioctl function, where it gets
> rejected as unsupported with -ENOTTY.  sg_reset ends
> up displaying:
> 	sg_reset: SG_SCSI_RESET failed: Inappropriate ioctl for device
> 
> Any suggestions for how to fix this?  

The who cascading through the different ioctl handlers is a mess.  I
think we'll need to rework it entirely, and i'll try to come up with
something for it ASAP.

> Is the check of scsi_host_in_recovery, which includes
> tmf_in_progress, too strong?  Most LLDs are not parallel
> SCSI where you can just have one TMF on the bus at a
> time anymore.

I suspect we could relax this, but that's a different issue
from the incorrect error handling in the ioctl handler cascade.

> Is returning -ENODEV if the host is in recovery the
> wrong code?  There might be a device there...it's
> just that access is temporarily blocked.

It's an odd error return, but it's long established.  I don't think
we can still change it.

> Also, should scsi_nonblockable_ioctl return -ENOTTY rather
> than -ENODEV if cmd is unsupported?  There's not really
> a no-device problem.

It should - or even better we should kill off scsi_nonblockable_ioctl
entirely.  Stay tuned.

