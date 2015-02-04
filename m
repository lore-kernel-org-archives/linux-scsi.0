From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Wed, 4 Feb 2015 14:16:56 +0100
Message-ID: <20150204131656.GD15443@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-6-git-send-email-nab@daterainc.com>
 <20150203101436.GO2830@redhat.com>
 <1423042825.28700.26.camel@haakon3.risingtidesystems.com>
 <20150204094252.GI9920@redhat.com>
 <1423046467.28700.48.camel@haakon3.risingtidesystems.com>
 <1423047312.28700.51.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423047312.28700.51.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 04, 2015 at 02:55:12AM -0800, Nicholas A. Bellinger wrote:
> On Wed, 2015-02-04 at 02:41 -0800, Nicholas A. Bellinger wrote:
> > On Wed, 2015-02-04 at 10:42 +0100, Michael S. Tsirkin wrote:
> > > On Wed, Feb 04, 2015 at 01:40:25AM -0800, Nicholas A. Bellinger wrote:
> > > > > > +		/*
> > > > > > +		 * Any associated T10_PI bytes for the outgoing / incoming
> > > > > > +		 * payloads are included in calculation of exp_data_len here.
> > > > > > +		 */
> > > > > > +		if (out_size > req_size) {
> > > > > > +			data_direction = DMA_TO_DEVICE;
> > > > > > +			exp_data_len = out_size - req_size;
> > > > > > +		} else if (in_size > rsp_size) {
> > > > > > +			data_direction = DMA_FROM_DEVICE;
> > > > > > +			exp_data_len = in_size - rsp_size;
> > > > > > +		} else {
> > > > > > +			data_direction = DMA_NONE;
> > > > > > +			exp_data_len = 0;
> > > > > > +		}
> > > > > 
> > > > > We must validate this doesn't cause exp_data_len to be negative.
> > > > > 
> > > > 
> > > > AFAICT, exp_data_len is always >= 0 here.
> > > 
> > > What guarantees out_size > req_size and in_size > rsp_size,
> > > respectively?
> > > 
> > 
> > Mmm, point taken.
> > 
> > So moving this part after copy_from_iter() ensures that at least
> > req_size bytes exists of out_size.  Making this change now.
> > 
> > For in_size > rsp_size there is no guarantee, and falls back to
> > data_direction = DMA_NONE + exp_data_len = 0;
> > 
> > Is this what you had in mind..?
> > 
> 
> Something akin to:
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index f72fc56..daf10b7 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1047,30 +1047,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  			target = &v_req.lun[1];
>  		}
>  		/*
> -		 * Determine data_direction by calculating the total outgoing
> -		 * iovec sizes / incoming iovec sizes vs. virtio-scsi request /
> -		 * response headers respectively.
> -		 *
>  		 * FIXME: Not correct for BIDI operation
>  		 */
>  		out_size = iov_length(vq->iov, out);
>  		in_size = iov_length(&vq->iov[out], in);
>  
>  		/*
> -		 * Any associated T10_PI bytes for the outgoing / incoming
> -		 * payloads are included in calculation of exp_data_len here.
> -		 */
> -		if (out_size > req_size) {
> -			data_direction = DMA_TO_DEVICE;
> -			exp_data_len = out_size - req_size;
> -		} else if (in_size > rsp_size) {
> -			data_direction = DMA_FROM_DEVICE;
> -			exp_data_len = in_size - rsp_size;
> -		} else {
> -			data_direction = DMA_NONE;
> -			exp_data_len = 0;
> -		}
> -		/*
>  		 * Copy over the virtio-scsi request header, which for a
>  		 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
>  		 * single iovec may contain both the header + outgoing
> @@ -1102,8 +1084,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  			continue;
>  		}
>  		/*
> -		 * Determine start of T10_PI or data payload iovec based upon
> -		 * data_direction.
> +		 * Determine data_direction by calculating the total outgoing
> +		 * iovec sizes + incoming iovec sizes vs. virtio-scsi request +
> +		 * response headers respectively.
>  		 *
>  		 * For DMA_TO_DEVICE this is out_iter, which is already pointing
>  		 * to the right place.
> @@ -1111,16 +1094,27 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  		 * For DMA_FROM_DEVICE, the iovec will be just past the end
>  		 * of the virtio-scsi response header in either the same
>  		 * or immediately following iovec.
> +		 *
> +		 * Any associated T10_PI bytes for the outgoing / incoming
> +		 * payloads are included in calculation of exp_data_len here.
>  		 */
>  		prot_bytes = 0;
>  
> -		if (data_direction == DMA_TO_DEVICE) {
> +		if (out_size > req_size) {
> +			data_direction = DMA_TO_DEVICE;
> +			exp_data_len = out_size - req_size;
>  			data_iter = out_iter;
> -		} else if (data_direction == DMA_FROM_DEVICE) {
> +		} else if (in_size > rsp_size) {
> +			data_direction = DMA_FROM_DEVICE;
> +			exp_data_len = in_size - rsp_size;
> +
>  			iov_iter_init(&in_iter, READ, &vq->iov[out], in,
>  				      rsp_size + exp_data_len);
>  			iov_iter_advance(&in_iter, rsp_size);
>  			data_iter = in_iter;
> +		} else {
> +			data_direction = DMA_NONE;
> +			exp_data_len = 0;
>  		}
>  		/*
>  		 * If T10_PI header + payload is present, setup prot_iter values

Looks good to me.
