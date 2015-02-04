From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Wed, 4 Feb 2015 11:20:20 +0100
Message-ID: <20150204102020.GA14325@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-6-git-send-email-nab@daterainc.com>
 <20150203235616.GF29656@ZenIV.linux.org.uk>
 <1423044680.28700.37.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964966AbbBDKUa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2015 05:20:30 -0500
Content-Disposition: inline
In-Reply-To: <1423044680.28700.37.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>

On Wed, Feb 04, 2015 at 02:11:20AM -0800, Nicholas A. Bellinger wrote:
> On Tue, 2015-02-03 at 23:56 +0000, Al Viro wrote:
> > On Tue, Feb 03, 2015 at 06:29:59AM +0000, Nicholas A. Bellinger wrote:
> > > +		 * Copy over the virtio-scsi request header, which when
> > > +		 * ANY_LAYOUT is enabled may span multiple iovecs, or a
> > > +		 * single iovec may contain both the header + outgoing
> > > +		 * WRITE payloads.
> > > +		 *
> > > +		 * copy_from_iter() is modifying the iovecs as copies over
> > > +		 * req_size bytes into req, so the returned out_iter.iov[0]
> > > +		 * will contain the correct start + offset of the outgoing
> > > +		 * WRITE payload, if DMA_TO_DEVICE is set.
> > 
> > It does no such thing.  What it does, though, is changing out_iter so
> > that subsequent copy_from_iter() will return the data you want.  Note
> > that out_iter.iov[0] will contain the correct _segment_ of that vector,
> > with the data you want at out_iter.iov_offset bytes from the beginning
> > of that segment.  .iov may come to point to subsequent segments and .iov_offset
> > keeps changing, but segments themselves are never changed.
> 
> Yes, sorry.  Updating that comment to read:
> 
>  /*
>   * Copy over the virtio-scsi request header, which for a
>   * ANY_LAYOUT enabled guest may span multiple iovecs, or a
>   * single iovec may contain both the header + outgoing
>   * WRITE payloads.
>   *
>   * copy_from_iter() copies over req_size bytes, and sets up
>   * out_iter.iov[0] + out_iter.iov_offset to contain the start
>   * of the outgoing WRITE payload, if DMA_TO_DEVICE is set.
>   */

I'm still confused wrt what this refers to.
You don't actually play with iovs directly anymore,
why bother explaining what happens to the underlying iov?
Can we just say
	copy_from_iter will advance out_iter, so that it will point
	at the start of the outgoing WRITE payload, if DMA_TO_DEVICE is
	set.

Seems clearer to me.

