From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH] bsg : Add support for io vectors in bsg
Date: Tue, 8 Jan 2008 17:09:18 -0500
Message-ID: <20080108220918.GA9484@osc.edu>
References: <Pine.LNX.4.64.0801042137350.7836@localhost> <200801050501.m0551LFB030667@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:45464 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYAHWJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jan 2008 17:09:19 -0500
Content-Disposition: inline
In-Reply-To: <200801050501.m0551LFB030667@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: deepakrc@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

tomof@acm.org wrote on Sat, 05 Jan 2008 14:01 +0900:
> From: Deepak Colluru <deepakrc@gmail.com>
> Subject: [PATCH] bsg : Add support for io vectors in bsg
> Date: Fri, 4 Jan 2008 21:47:34 +0530 (IST)
> 
> > From: Deepak Colluru <deepakrc@gmail.com>
> > 
> > Add support for io vectors in bsg.
> > 
> > Signed-off-by: Deepak Colluru <deepakrc@gmail.com>
> > ---
> >   bsg.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
> >   1 file changed, 49 insertions(+), 3 deletions(-)
> 
> Thanks, but I have to NACK this.
> 
> You can find the discussion about bsg io vector support and a similar
> patch in linux-scsi archive. I have no plan to support it since it
> needs the compat hack.

You may recall this is one of the patches I need to use bsg with OSD
devices.  OSDs overload the SCSI buffer model to put mulitple fields
in dataout and datain.  Some is user data, but some is more
logically created by a library.  Memcpying in userspace to wedge all
the segments into a single buffer is painful, and is required both
on outgoing and incoming data buffers.

There are two approaches to add iovec to bsg.

1.  Define a new sg_iovec_v4 that uses constant width types.  Both
    32- and 64-bit userspace would hand arrays of this to the kernel.

    struct sg_v4_iovec {
	    __u64 iov_base;
	    __u32 iov_len;
	    __u32 __pad1;
    };

    Old patch here:  http://article.gmane.org/gmane.linux.scsi/30461/


2.  Do as Deepak has done, using the existing sg_iovec, but then
    also work around the compat issue.  Old v3 sg_iovec is:

    typedef struct sg_iovec /* same structure as used by readv() Linux system */
    {                       /* call. It defines one scatter-gather element. */
	void __user *iov_base;      /* Starting address  */
	size_t iov_len;             /* Length in bytes  */
    } sg_iovec_t;

    Old patch here:  http://article.gmane.org/gmane.linux.scsi/30460/

I took another look at the compat approach, to see if it is feasible
to keep the compat handling somewhere else, without the use of #ifdef
CONFIG_COMPAT and size-comparison code inside bsg.c.  I don't see how.
The use of iovec is within a write operation on a char device.  It's
not amenable to a compat_sys_ or a .compat_ioctl approach.

I'm partial to #1 because the use of architecture-independent fields
matches the rest of struct sg_io_v4.  But if you don't want to have
another iovec type in the kernel, could we do #2 but just return
-EINVAL if the need for compat is detected?  I.e. change
dout_iovec_count to dout_iovec_length and do the math?

		-- Pete
