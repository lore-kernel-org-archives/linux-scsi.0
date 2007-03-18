From: Pete Wyckoff <pw@osc.edu>
Subject: Re: SCSI Generic version 4 interface, release 1.2
Date: Sun, 18 Mar 2007 13:48:31 -0400
Message-ID: <20070318174831.GA21027@osc.edu>
References: <45F82048.6020401@torque.net> <20070317211511.GA19316@osc.edu> <45FC7623.8080305@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:46276 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbXCRRse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Mar 2007 13:48:34 -0400
Content-Disposition: inline
In-Reply-To: <45FC7623.8080305@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com

michaelc@cs.wisc.edu wrote on Sat, 17 Mar 2007 18:13 -0500:
> Pete Wyckoff wrote:
> > dougg@torque.net wrote on Wed, 14 Mar 2007 12:18 -0400:
> >> After reviewing this post by Pete Wyckoff:
> >> http://marc.theaimsgroup.com/?l=linux-scsi&m=117278879816029&w=2
> >>
> >> I decided to update my sg v4 interface document originally
> >> posted 20061106 which I will now call release 1.1 :
> >> http://lwn.net/Articles/208082/
> >>
> >> Pete was proposing to put back din_iovec_count and
> >> dout_iovec_count that had been dropped out of bsg but
> >> had been in release 1.1 . Hmm.
> >>
> >> Some other items have been picked up from the bsg
> >> implementation plus the suggestion from LSF'07 to
> >> add dout_resid.
> >>
> >> See the attachment, comments welcome.
> > 
> > Do you want to define the iovec format too?  As I commented in my
> > patch, v3 sg_iovec has pointers with 32/64-bit issues.  Would be
> > nice to see you declare v4 sg_iovec as pure u64.  (By the way, don't
> > use the patch:  casting from the new to the old can put junk in the
> > top half of the 64-bit sg_iovec.iov_len).
> > 
> > Another issue I wonder about is queue DMA alignment.  In bsg,
> > blk_rq_map_user will use a bounce buffer if the user-supplied start
> > and end addresses are not aligned.  sg will happily map user pages
> > at any offset without checking, although I haven't checked if Mike's
> > patches change this.  ll_rw_blk.c says regarding blk_rq_map_user:
> 
> Currently and before any of my patches, sg checked the start
>         if (((unsigned long)hp->dxferp &
>                         queue_dma_alignment(sdev->request_queue)) != 0)
> It did not check the start and end like blk_rq_map_user.
> 
> With my updated patches, blk_rq_map_user is just checking the start.
> There was a thread about not checking the end on linux-scsi. I will try
> to dig it up. A couple kernels ago the bio map helpers were modified to
> only check the start.

Oh, I missed that.  There's this thread about USB needing end
alignment too, on all but the last iovec entry:

    http://thread.gmane.org/gmane.linux.usb.devel/16230/focus=16409

		-- Pete
