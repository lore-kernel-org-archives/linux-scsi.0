From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Wed, 04 Feb 2015 02:11:20 -0800
Message-ID: <1423044680.28700.37.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <1422945003-24538-6-git-send-email-nab@daterainc.com>
	 <20150203235616.GF29656@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59245 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbbBDKLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 05:11:22 -0500
In-Reply-To: <20150203235616.GF29656@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>

On Tue, 2015-02-03 at 23:56 +0000, Al Viro wrote:
> On Tue, Feb 03, 2015 at 06:29:59AM +0000, Nicholas A. Bellinger wrote:
> > +		 * Copy over the virtio-scsi request header, which when
> > +		 * ANY_LAYOUT is enabled may span multiple iovecs, or a
> > +		 * single iovec may contain both the header + outgoing
> > +		 * WRITE payloads.
> > +		 *
> > +		 * copy_from_iter() is modifying the iovecs as copies over
> > +		 * req_size bytes into req, so the returned out_iter.iov[0]
> > +		 * will contain the correct start + offset of the outgoing
> > +		 * WRITE payload, if DMA_TO_DEVICE is set.
> 
> It does no such thing.  What it does, though, is changing out_iter so
> that subsequent copy_from_iter() will return the data you want.  Note
> that out_iter.iov[0] will contain the correct _segment_ of that vector,
> with the data you want at out_iter.iov_offset bytes from the beginning
> of that segment.  .iov may come to point to subsequent segments and .iov_offset
> keeps changing, but segments themselves are never changed.

Yes, sorry.  Updating that comment to read:

 /*
  * Copy over the virtio-scsi request header, which for a
  * ANY_LAYOUT enabled guest may span multiple iovecs, or a
  * single iovec may contain both the header + outgoing
  * WRITE payloads.
  *
  * copy_from_iter() copies over req_size bytes, and sets up
  * out_iter.iov[0] + out_iter.iov_offset to contain the start
  * of the outgoing WRITE payload, if DMA_TO_DEVICE is set.
  */
> 
> > +		 */
> > +		iov_iter_init(&out_iter, READ, &vq->iov[0], out,
> 					 ^^^^ WRITE, please - as in "this is
> the source of some write, we'll be copying _from_ it".  READ would be
> "destination of some read, we'll be copying into it".
> 

Ahh, missed that iov_iter_get_pages() is already doing the write bit
inversion of get_user_pages_fast() for in_iter -> DMA_FROM_DEVICE.

Fixed to use correct i->type assignments.

> > +			     (data_direction == DMA_TO_DEVICE) ?
> > +			      req_size + exp_data_len : req_size);
> > +
> > +		ret = copy_from_iter(req, req_size, &out_iter);
> 
> ...
> 
> > +		/*
> > +		 * Determine start of T10_PI or data payload iovec in ANY_LAYOUT
> > +		 * mode based upon data_direction.
> > +		 *
> > +		 * For DMA_TO_DEVICE, this is iov_out from copy_from_iter()
> > +		 * with the already recalculated iov_base + iov_len.
> 
> ITYM "this is out_iter, which is already pointing to the right place"
> 

Updated.

> AFAICS, the actual use is correct, it's just that the comments are confused.

Thanks for your review.

--nab

