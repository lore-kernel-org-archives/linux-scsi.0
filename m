From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH] bsg : Add support for io vectors in bsg
Date: Thu, 10 Jan 2008 15:43:25 -0500
Message-ID: <20080110204325.GC1928@osc.edu>
References: <Pine.LNX.4.64.0801042137350.7836@localhost> <200801050501.m0551LFB030667@mbox.iij4u.or.jp> <20080108220918.GA9484@osc.edu> <20080109091118N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:46785 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375AbYAJUn1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 15:43:27 -0500
Content-Disposition: inline
In-Reply-To: <20080109091118N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, deepakrc@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

fujita.tomonori@lab.ntt.co.jp wrote on Wed, 09 Jan 2008 09:11 +0900:
> On Tue, 8 Jan 2008 17:09:18 -0500
> Pete Wyckoff <pw@osc.edu> wrote:
> > I took another look at the compat approach, to see if it is feasible
> > to keep the compat handling somewhere else, without the use of #ifdef
> > CONFIG_COMPAT and size-comparison code inside bsg.c.  I don't see how.
> > The use of iovec is within a write operation on a char device.  It's
> > not amenable to a compat_sys_ or a .compat_ioctl approach.
> > 
> > I'm partial to #1 because the use of architecture-independent fields
> > matches the rest of struct sg_io_v4.  But if you don't want to have
> > another iovec type in the kernel, could we do #2 but just return
> > -EINVAL if the need for compat is detected?  I.e. change
> > dout_iovec_count to dout_iovec_length and do the math?
> 
> If you are ok with removing the write/read interface and just have
> ioctl, we could can handle comapt stuff like others do. But I think
> that you (OSD people) really want to keep the write/read
> interface. Sorry, I think that there is no workaround to support iovec
> in bsg.

I don't care about read/write in particular.  But we do need some
way to launch asynchronous SCSI commands, and currently read/write
are the only way to do that in bsg.  The reason is to keep multiple
spindles busy at the same time.

How about these new ioctls instead of read/write:

    SG_IO_SUBMIT - start a new blk_execute_rq_nowait()
    SG_IO_TEST   - complete and return a previous req
    SG_IO_WAIT   - wait for a req to finish, interruptibly

Then old write users will instead do ioctl SUBMIT.  Read users will
do TEST for non-blocking fd, or WAIT for blocking.  And SG_IO could
be implemented as SUBMIT + WAIT.

Then we can do compat_ioctl and convert up iovecs out-of-line before
calling the normal functions.

Let me know if you want a patch for this.

		-- Pete
