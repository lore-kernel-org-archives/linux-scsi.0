From: Nathan Scott <nathans@sgi.com>
Subject: Re: ST alloc failures
Date: Tue, 6 Apr 2004 18:48:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406084858.GA752@frodo>
References: <20040402051355.GA1604@frodo> <20040402073207.A31736@infradead.org> <Pine.LNX.4.58.0404030958510.7955@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:8105 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S263656AbUDFHuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 03:50:22 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0404030958510.7955@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, linux-xfs@oss.sgi.com

Hi there,

On Sat, Apr 03, 2004 at 10:19:51AM +0300, Kai Makisara wrote:
> On Fri, 2 Apr 2004, Christoph Hellwig wrote:
> 
> > [linux-scsi is the right list for st problems, moving the thread there]
> > 
> > On Fri, Apr 02, 2004 at 03:13:55PM +1000, Nathan Scott wrote:
> > > Hi all,
> > > 
> > > I'm seeing a bunch of large allocation attempts failing from
> > > the SCSI tape driver when doing dumps and restores ... (this
> > > is with a stock 2.6.4 kernel).
> > > 
> > > xfsdump: page allocation failure. order:8, mode:0xd0
> > > Call Trace:
> > >  [<c013982b>] __alloc_pages+0x33b/0x3d0
> > >  [<c03805ac>] enlarge_buffer+0xdc/0x1b0
> > >  [<c03819a3>] st_map_user_pages+0x33/0x90
> > >  [<c037cf24>] setup_buffering+0xb4/0x160
> > 
> > This looks like the driver tries to pin down the userpages first
> > (st_map_user_pages) but then fails and needs to use an inkernel
> > buffer.  Can you put some debug printks into st_map_user_pages
> > to see why it fails?

Apologies for the delay; after whacking in some printk's it looks
like the point st decides to not pin down the user pages for me is
here in sgl_map_user_pages:

	/* Too big */
	if (nr_pages > max_pages) {
		return -ENOMEM;
	}

In my cases nr_pages is always 256 and max_pages is always 96 (I
see this printk a fair few times, and its always from this point).

> Pinning down pages should not fail with most modern hardware except for 
> the following three cases:
> 
> 1) A change in 2.6.4 (*) mandates st (and sg) not to use direct transfers 
> unless the user buffer is aligned at 512 byte boundary. This means, for 
> instance, that in most cases transfers from/to malloced/calloced buffers 
> are forced to use bounce buffers (alignment at 8 or 16 byte boundaries).
> 
> 2) There is a bug in checking the allowed address range. Most SCSI 
> adapters support 64-bit addresses and so even lots of memory should not 
> prevent using direct transfers.

I guess its not either of these two, from the printk?

> 3) Some resource shortage that happened just now. This is not a bug.

Hmm... I see this alot, but I have a fair bit of memory in the machine
(its during stress and regression testing that I hit this, so not sure
about the exact memory usage at each particular printk I see).

Is this something we should be tuning in xfsdump/xfsrestore, Kai?
(to make smaller requests?)

cheers.

-- 
Nathan
