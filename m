From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: ST alloc failures
Date: Tue, 6 Apr 2004 22:09:22 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404062129450.1088@kai.makisara.local>
References: <20040402051355.GA1604@frodo> <20040402073207.A31736@infradead.org>
 <Pine.LNX.4.58.0404030958510.7955@kai.makisara.local> <20040406084858.GA752@frodo>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep07-0.kolumbus.fi ([193.229.0.51]:32178 "EHLO
	fep07-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S263969AbUDFTJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 15:09:25 -0400
In-Reply-To: <20040406084858.GA752@frodo>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Scott <nathans@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-xfs@oss.sgi.com

On Tue, 6 Apr 2004, Nathan Scott wrote:

> Hi there,
> 
> On Sat, Apr 03, 2004 at 10:19:51AM +0300, Kai Makisara wrote:
> > On Fri, 2 Apr 2004, Christoph Hellwig wrote:
> > 
> > > [linux-scsi is the right list for st problems, moving the thread there]
> > > 
> > > On Fri, Apr 02, 2004 at 03:13:55PM +1000, Nathan Scott wrote:
> > > > Hi all,
> > > > 
> > > > I'm seeing a bunch of large allocation attempts failing from
> > > > the SCSI tape driver when doing dumps and restores ... (this
> > > > is with a stock 2.6.4 kernel).
> > > > 
> > > > xfsdump: page allocation failure. order:8, mode:0xd0
> > > > Call Trace:
> > > >  [<c013982b>] __alloc_pages+0x33b/0x3d0
> > > >  [<c03805ac>] enlarge_buffer+0xdc/0x1b0
> > > >  [<c03819a3>] st_map_user_pages+0x33/0x90
> > > >  [<c037cf24>] setup_buffering+0xb4/0x160
> > > 
> > > This looks like the driver tries to pin down the userpages first
> > > (st_map_user_pages) but then fails and needs to use an inkernel
> > > buffer.  Can you put some debug printks into st_map_user_pages
> > > to see why it fails?
> 
> Apologies for the delay; after whacking in some printk's it looks
> like the point st decides to not pin down the user pages for me is
> here in sgl_map_user_pages:
> 
> 	/* Too big */
> 	if (nr_pages > max_pages) {
> 		return -ENOMEM;
> 	}
> 
> In my cases nr_pages is always 256 and max_pages is always 96 (I
> see this printk a fair few times, and its always from this point).
> 
OK. max_pages is the maximum number of scatter/gather segments supported 
by the SCSI adapter.

> > Pinning down pages should not fail with most modern hardware except for 
> > the following three cases:
> > 
> > 1) A change in 2.6.4 (*) mandates st (and sg) not to use direct transfers 
> > unless the user buffer is aligned at 512 byte boundary. This means, for 
> > instance, that in most cases transfers from/to malloced/calloced buffers 
> > are forced to use bounce buffers (alignment at 8 or 16 byte boundaries).
> > 
> > 2) There is a bug in checking the allowed address range. Most SCSI 
> > adapters support 64-bit addresses and so even lots of memory should not 
> > prevent using direct transfers.
> 
> I guess its not either of these two, from the printk?
> 
Correct. 1) was something that would have explained why you see this 
starting from 2.6.4. I am happy that it is not 2 :-)

> > 3) Some resource shortage that happened just now. This is not a bug.
> 
> Hmm... I see this alot, but I have a fair bit of memory in the machine
> (its during stress and regression testing that I hit this, so not sure
> about the exact memory usage at each particular printk I see).
> 
Having a lot of memory does not help because it gets fragmented, too. st 
is trying to allocate big chunks so that it can satisfy the user requests 
with the available number of s/g segments even when the user successively 
requests bigger and bigger block sizes. Usually smaller than maximum 
chunks can be used if the user just uses the same block size for 
subsequent requests. The driver tries to allocate smaller chunks if 
allocation of big chunks fails and the smaller chunks are big enough for 
the current user request. This is what happens in your case now. Earlier 
allocations with the big chunk size have succeeded and no error messages 
have been written.

> Is this something we should be tuning in xfsdump/xfsrestore, Kai?
> (to make smaller requests?)
> 
There are actually two problems. As Christoph said, the messages you see 
are harmless. I have already sent to linux-scsi a patch that adds 
__GFP_NOWARN to the allocation. This should remove these error messages.

The other problem is that you probably would like to use direct transfers 
between the xfsdump/xfsrestore buffer and the drive instead of using the 
"bounce" buffer in the driver. This is not possible unless the tape 
requests are small enough for the SCSI adapter. In your case the limit is 
96 pages. You can try to increase this limit but it is not a general 
solution.

I would recommend xfsdump/xfsrestore to use smaller requests if possible. 
64 pages of 4 kB would make 256 kB. Using this request size should not 
limit throughput even with the fastest tape drives.

I would like to make st somehow tell the users when it is using the driver 
buffer instead of direct transfers. Some users would probably like to know 
this because it limits throughput in some cases. The best idea I have so 
far is to log a message once for each open if this happens. Even this 
may be too much. Good ideas are welcome.

-- 
Kai
