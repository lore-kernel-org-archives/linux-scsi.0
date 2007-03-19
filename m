From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] bsg: iovec support with compat
Date: Tue, 20 Mar 2007 03:22:46 +0900
Message-ID: <20070320032246M.fujita.tomonori@lab.ntt.co.jp>
References: <45FE987D.5070908@torque.net>
	<20070319232113N.fujita.tomonori@lab.ntt.co.jp>
	<20070319180727.GB32043@osc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:53853 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbXCSSWI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 14:22:08 -0400
In-Reply-To: <20070319180727.GB32043@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pw@osc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, dougg@torque.net, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH v2] bsg: iovec support with compat
Date: Mon, 19 Mar 2007 14:07:27 -0400

> fujita.tomonori@lab.ntt.co.jp wrote on Mon, 19 Mar 2007 23:21 +0900:
> > From: Douglas Gilbert <dougg@torque.net>
> > Subject: Re: [PATCH] bsg: iovec support
> > Date: Mon, 19 Mar 2007 10:04:45 -0400
> > 
> > > >> Pete is also suggesting (shown above) a revised sg_io_vec
> > > >> structure that uses a uint64_t for the pointer to simplify
> > > >> 32, 64 bit thunking.
> > > > 
> > > > All I said is that it would be better to use the existing compat
> > > > infrastructure (sg_build_iovec, sg_ioctl_trans, etc in
> > > > fs/compat_ioctl.c) instead of adding another compat code.
> > > 
> > > Won't sg v4 make this even a bigger mess, at least
> > > initially anyway?
> > 
> > Inventing a new iovec structure like sg_io_v4_vec and something like
> > blk_rq_map_user_iov_sgv4 sounds a mess.
> 
> It is sort of a mess to have new blk mapping routine for a new iovec
> type.  But I very much did not want to introduce the need for
> another compat conversion.  But, I took a look at how it would be to
> pass the existing sg_iovec into bsg.
> 
> Adding a new bsg_write_compat would be bad.  There is lots of
> parsing and setup before we even get to the possibility of iovec
> data mapping.  Reusing just sg_build_ioctl from compat_ioctl.c is
> also suboptimal as this function is built around the idea of a
> contiguous sg_io_hdr + iovec in userspace.  The function is small
> enough that splitting it into a generic + ioctl-specific part would
> add too much abstraction to be worth it.
> 
> Here is the patch to use sg_iovec, with its userspace void * and
> size_t, and the CONFIG_COMPAT code to fixup 32-bit userspace.  I'm
> not fond of having __u64 for non-iovec buffer representations, and
> void * for iovec buffer representations, but it saves having to
> build an sg_iovec just to call into the existing blk_rq_map_user_iov.
> 
> Comments?

The compat code should not go to bsg.c.
