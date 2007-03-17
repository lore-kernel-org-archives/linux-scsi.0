From: Pete Wyckoff <pw@osc.edu>
Subject: Re: SCSI Generic version 4 interface, release 1.2
Date: Sat, 17 Mar 2007 17:15:11 -0400
Message-ID: <20070317211511.GA19316@osc.edu>
References: <45F82048.6020401@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:43985 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbXCQVPP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Mar 2007 17:15:15 -0400
Content-Disposition: inline
In-Reply-To: <45F82048.6020401@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com

dougg@torque.net wrote on Wed, 14 Mar 2007 12:18 -0400:
> After reviewing this post by Pete Wyckoff:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=117278879816029&w=2
> 
> I decided to update my sg v4 interface document originally
> posted 20061106 which I will now call release 1.1 :
> http://lwn.net/Articles/208082/
> 
> Pete was proposing to put back din_iovec_count and
> dout_iovec_count that had been dropped out of bsg but
> had been in release 1.1 . Hmm.
> 
> Some other items have been picked up from the bsg
> implementation plus the suggestion from LSF'07 to
> add dout_resid.
> 
> See the attachment, comments welcome.

Do you want to define the iovec format too?  As I commented in my
patch, v3 sg_iovec has pointers with 32/64-bit issues.  Would be
nice to see you declare v4 sg_iovec as pure u64.  (By the way, don't
use the patch:  casting from the new to the old can put junk in the
top half of the 64-bit sg_iovec.iov_len).

Another issue I wonder about is queue DMA alignment.  In bsg,
blk_rq_map_user will use a bounce buffer if the user-supplied start
and end addresses are not aligned.  sg will happily map user pages
at any offset without checking, although I haven't checked if Mike's
patches change this.  ll_rw_blk.c says regarding blk_rq_map_user:

    We don't allow misaligned data like bio_map_user() does.  If the
    user is using sg, they're expected to know the alignment
    constraints and respect them accordingly.

Should this still be true for both iovec and non-iovec uses of sgv4?
I modified bsg to use iovec and ignore alignment issues, just like
sg, but left in the bounce buffer for non-iovec usage.  Seems
awkward.  scsi_ioctl's sg_io has the same odd situation:  non-iovec
is bounced, iovec must be aligned by user.

		-- Pete

