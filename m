From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: iovec support
Date: Mon, 19 Mar 2007 22:34:35 +0900 (JST)
Message-ID: <20070319184305U.fujita.tomonori@lab.ntt.co.jp>
References: <20070301222908.GC20922@osc.edu>
	<20070319194116S.fujita.tomonori@lab.ntt.co.jp>
	<45FE8887.8040901@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:51104 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbXCSNfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 09:35:36 -0400
In-Reply-To: <45FE8887.8040901@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, pw@osc.edu, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] bsg: iovec support
Date: Mon, 19 Mar 2007 08:56:39 -0400

> FUJITA Tomonori wrote:
> > From: Pete Wyckoff <pw@osc.edu>
> > Subject: [PATCH] bsg: iovec support
> > Date: Thu, 1 Mar 2007 17:29:08 -0500
> > 
> >> Support vectored IO as in SGv3.  The iovec structure uses explicit
> >> sizes to avoid the need for compat conversion.
> >>
> >> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> >> ---
> >>
> >> My application definitely can take advantage of scatter/gather IO,
> >> which is supported in sgv3 but not in the bsg implementation of sgv4.
> >> I understand Tomo's concerns about code bloat and the need for
> >> 32/64 compat translations, but this will make things much easier on
> >> users of bsg who read or write out of multiple buffers in a single
> >> SCSI operation.
> > 
> > (snip)
> > 
> >> + * Vector of address/length pairs, used when dout_iovec_count (or din_)
> >> + * is non-zero.  In that case, dout_xferp is a list of struct sg_io_v4_vec
> >> + * and dout_iovec_count is the number of entries in that list.  dout_xfer_len
> >> + * is the total length of the list.  Note the use of u64 instead of a
> >> + * native pointer to avoid compat issues, and padding to avoid structure
> >> + * alignment problems.
> >> + */
> >> +struct sg_io_v4_vec {
> >> +	__u64 iov_base;
> >> +	__u32 iov_len;
> >> +	__u32 __pad1;
> >> +};
> > 
> > I don't think that it's a good idea to add a new scatter/gather
> > structure and export it to user space.
> 
> User space scatter gather is not a new feature.
> It is defined and works in sg v3.
> 
> It was also partially defined in sg v4 and dropped
> out in the bsg implementation. I agree with Pete that
> it should be put back.

I'm fine with supporting iovec (though I don't like it).


> Pete is also suggesting (shown above) a revised sg_io_vec
> structure that uses a uint64_t for the pointer to simplify
> 32, 64 bit thunking.

All I said is that it would be better to use the existing compat
infrastructure (sg_build_iovec, sg_ioctl_trans, etc in
fs/compat_ioctl.c) instead of adding another compat code.
