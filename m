From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Tue, 18 Dec 2012 15:36:06 +0200
Message-ID: <20121218133606.GC26110@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

Some comments without arguing about whether the performance
benefit is worth it.

On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index cf8adb1..39d56c4 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -7,6 +7,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/device.h>
>  #include <linux/mod_devicetable.h>
> +#include <linux/dma-direction.h>
>  #include <linux/gfp.h>
>  
>  /**
> @@ -40,6 +41,26 @@ int virtqueue_add_buf(struct virtqueue *vq,
>  		      void *data,
>  		      gfp_t gfp);
>  
> +struct virtqueue_buf {
> +	struct virtqueue *vq;
> +	struct vring_desc *indirect, *tail;

This is wrong: virtio.h does not include virito_ring.h,
and it shouldn't by design depend on it.

> +	int head;
> +};
> +

Can't we track state internally to the virtqueue?
Exposing it seems to buy us nothing since you can't
call add_buf between start and end anyway.


> +int virtqueue_start_buf(struct virtqueue *_vq,
> +			struct virtqueue_buf *buf,
> +			void *data,
> +			unsigned int count,
> +			unsigned int count_sg,
> +			gfp_t gfp);
> +
> +void virtqueue_add_sg(struct virtqueue_buf *buf,
> +		      struct scatterlist sgl[],
> +		      unsigned int count,
> +		      enum dma_data_direction dir);
> +

And idea: in practice virtio scsi seems to always call sg_init_one, no?
So how about we pass in void* or something and avoid using sg and count?
This would make it useful for -net BTW.

> +void virtqueue_end_buf(struct virtqueue_buf *buf);
> +
>  void virtqueue_kick(struct virtqueue *vq);
>  
>  bool virtqueue_kick_prepare(struct virtqueue *vq);
> -- 
> 1.7.1
> 
