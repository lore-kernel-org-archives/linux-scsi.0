From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH v2] bsg: iovec support with compat
Date: Wed, 21 Mar 2007 11:34:51 -0400
Message-ID: <20070321153451.GC7686@osc.edu>
References: <45FE987D.5070908@torque.net> <20070319232113N.fujita.tomonori@lab.ntt.co.jp> <20070319180727.GB32043@osc.edu> <20070320032246M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:35482 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbXCUPex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2007 11:34:53 -0400
Content-Disposition: inline
In-Reply-To: <20070320032246M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

fujita.tomonori@lab.ntt.co.jp wrote on Tue, 20 Mar 2007 03:22 +0900:
> From: Pete Wyckoff <pw@osc.edu>
> Subject: [PATCH v2] bsg: iovec support with compat
> Date: Mon, 19 Mar 2007 14:07:27 -0400
> 
> > Adding a new bsg_write_compat would be bad.  There is lots of
> > parsing and setup before we even get to the possibility of iovec
> > data mapping.  Reusing just sg_build_ioctl from compat_ioctl.c is
> > also suboptimal as this function is built around the idea of a
> > contiguous sg_io_hdr + iovec in userspace.  The function is small
> > enough that splitting it into a generic + ioctl-specific part would
> > add too much abstraction to be worth it.
> > 
> > Here is the patch to use sg_iovec, with its userspace void * and
> > size_t, and the CONFIG_COMPAT code to fixup 32-bit userspace.  I'm
> > not fond of having __u64 for non-iovec buffer representations, and
> > void * for iovec buffer representations, but it saves having to
> > build an sg_iovec just to call into the existing blk_rq_map_user_iov.
> > 
> > Comments?
> 
> The compat code should not go to bsg.c.

Agreed.  I dislike the entire approach of reusing sg_iovec in bsg,
but thought I'd work it through to see what it is like.

The compat code cannot go in compat_ioctl.c or similar, as explained
above.  And it seems wrong to leave it out and silently break on
compat-requiring setups.

Using sg_iovec with bsg is bad from a user perspective too.
sg_iovec pointers are (void *).  sg_io_v4 pointers are __u64.
sg_iovec lengths are size_t (64-bit).  sg_io_v4 lengths are __u32.

Please consider instead the original proposal of a new iovec
type for bsg.  It is less complex than using existing sg_iovec.
http://article.gmane.org/gmane.linux.scsi/30461

There is exactly one user of blk_rq_map_user_iov() in the tree:
sg_io() in scsi_ioctl.c.  I could convert that to sg_v4_iovec now
too.  The helper function bio_map_user_iov() is only used by
blk_rq_map_user_iov() and can also be fixed.  The only use we have
for struct sg_iovec is this one sg_io() caller, and sg.c.  Let's
migrate to sg_v4_iovec at the same time we switch from sgv3 to sgv4.

		-- Pete
