From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH] bsg : Add support for io vectors in bsg
Date: Thu, 10 Jan 2008 16:46:05 -0500
Message-ID: <20080110214605.GD1928@osc.edu>
References: <Pine.LNX.4.64.0801042137350.7836@localhost> <200801050501.m0551LFB030667@mbox.iij4u.or.jp> <20080108220918.GA9484@osc.edu> <20080109091118N.fujita.tomonori@lab.ntt.co.jp> <20080110204325.GC1928@osc.edu> <1199998531.3141.96.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:41340 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbYAJVqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 16:46:07 -0500
Content-Disposition: inline
In-Reply-To: <1199998531.3141.96.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, deepakrc@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James.Bottomley@HansenPartnership.com wrote on Thu, 10 Jan 2008 14:55 -0600:
> On Thu, 2008-01-10 at 15:43 -0500, Pete Wyckoff wrote:
> > fujita.tomonori@lab.ntt.co.jp wrote on Wed, 09 Jan 2008 09:11 +0900:
> > > On Tue, 8 Jan 2008 17:09:18 -0500
> > > Pete Wyckoff <pw@osc.edu> wrote:
> > > > I took another look at the compat approach, to see if it is feasible
> > > > to keep the compat handling somewhere else, without the use of #ifdef
> > > > CONFIG_COMPAT and size-comparison code inside bsg.c.  I don't see how.
> > > > The use of iovec is within a write operation on a char device.  It's
> > > > not amenable to a compat_sys_ or a .compat_ioctl approach.
> > > > 
> > > > I'm partial to #1 because the use of architecture-independent fields
> > > > matches the rest of struct sg_io_v4.  But if you don't want to have
> > > > another iovec type in the kernel, could we do #2 but just return
> > > > -EINVAL if the need for compat is detected?  I.e. change
> > > > dout_iovec_count to dout_iovec_length and do the math?
> > > 
> > > If you are ok with removing the write/read interface and just have
> > > ioctl, we could can handle comapt stuff like others do. But I think
> > > that you (OSD people) really want to keep the write/read
> > > interface. Sorry, I think that there is no workaround to support iovec
> > > in bsg.
> > 
> > I don't care about read/write in particular.  But we do need some
> > way to launch asynchronous SCSI commands, and currently read/write
> > are the only way to do that in bsg.  The reason is to keep multiple
> > spindles busy at the same time.
> 
> Won't multi-threading the ioctl calls achieve the same effect?  Or do
> you trip over BKL there?

There's no BKL on (new) ioctls anymore, at least.  A thread per
device would be feasible perhaps.  But if you want any sort of
pipelining out of the device, esp. in the remote iSCSI case, you
need to have a good number of commands outstanding to each device.
So a thread per command per device.  Typical iSCSI queue depth of
128 times 16 devices for a small setup is a lot of threads.

The pthread/pipe latency overhead is not insignificant for fast
storage networks too.

> > How about these new ioctls instead of read/write:
> > 
> >     SG_IO_SUBMIT - start a new blk_execute_rq_nowait()
> >     SG_IO_TEST   - complete and return a previous req
> >     SG_IO_WAIT   - wait for a req to finish, interruptibly
> > 
> > Then old write users will instead do ioctl SUBMIT.  Read users will
> > do TEST for non-blocking fd, or WAIT for blocking.  And SG_IO could
> > be implemented as SUBMIT + WAIT.
> > 
> > Then we can do compat_ioctl and convert up iovecs out-of-line before
> > calling the normal functions.
> > 
> > Let me know if you want a patch for this.
> 
> Really, the thought of re-inventing yet another async I/O interface
> isn't very appealing.

I'm fine with read/write, except Tomo is against handling iovecs
because of the compat complexity with struct iovec being different
on 32- vs 64-bit.  There is a standard way to do "compat" ioctl that
hides this handling in a different file (not bsg.c), which is the
only reason I'm even considering these ioctls.  I don't care about
compat setups per se.

Is there another async I/O mechanism?  Userspace builds the CDBs,
just needs some way to drop them in SCSI ML.  BSG is almost perfect
for this, but doesn't do iovec, leading to lots of memcpy.

		-- Pete
