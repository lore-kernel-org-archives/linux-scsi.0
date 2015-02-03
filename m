From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Tue, 3 Feb 2015 23:56:16 +0000
Message-ID: <20150203235616.GF29656@ZenIV.linux.org.uk>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422945003-24538-6-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 03, 2015 at 06:29:59AM +0000, Nicholas A. Bellinger wrote:
> +		 * Copy over the virtio-scsi request header, which when
> +		 * ANY_LAYOUT is enabled may span multiple iovecs, or a
> +		 * single iovec may contain both the header + outgoing
> +		 * WRITE payloads.
> +		 *
> +		 * copy_from_iter() is modifying the iovecs as copies over
> +		 * req_size bytes into req, so the returned out_iter.iov[0]
> +		 * will contain the correct start + offset of the outgoing
> +		 * WRITE payload, if DMA_TO_DEVICE is set.

It does no such thing.  What it does, though, is changing out_iter so
that subsequent copy_from_iter() will return the data you want.  Note
that out_iter.iov[0] will contain the correct _segment_ of that vector,
with the data you want at out_iter.iov_offset bytes from the beginning
of that segment.  .iov may come to point to subsequent segments and .iov_offset
keeps changing, but segments themselves are never changed.

> +		 */
> +		iov_iter_init(&out_iter, READ, &vq->iov[0], out,
					 ^^^^ WRITE, please - as in "this is
the source of some write, we'll be copying _from_ it".  READ would be
"destination of some read, we'll be copying into it".

> +			     (data_direction == DMA_TO_DEVICE) ?
> +			      req_size + exp_data_len : req_size);
> +
> +		ret = copy_from_iter(req, req_size, &out_iter);

...

> +		/*
> +		 * Determine start of T10_PI or data payload iovec in ANY_LAYOUT
> +		 * mode based upon data_direction.
> +		 *
> +		 * For DMA_TO_DEVICE, this is iov_out from copy_from_iter()
> +		 * with the already recalculated iov_base + iov_len.

ITYM "this is out_iter, which is already pointing to the right place"

AFAICS, the actual use is correct, it's just that the comments are confused.
