From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 6/9] vhost/scsi: Set VIRTIO_F_ANY_LAYOUT +
 VIRTIO_F_VERSION_1 feature bits
Date: Tue, 3 Feb 2015 11:40:58 +0200
Message-ID: <20150203094058.GN2830@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-7-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422945003-24538-7-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 03, 2015 at 06:30:00AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Signal support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
> required for virtio-scsi 1.0 spec layout requirements.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

I'm hoping someone'll actually test this with a BE guest before
we release this though.

> ---
>  drivers/vhost/scsi.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index e1fe003..c25fdd7 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -173,7 +173,9 @@ enum {
>  /* Note: can't set VIRTIO_F_VERSION_1 yet, since that implies ANY_LAYOUT. */
>  enum {
>  	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
> -					       (1ULL << VIRTIO_SCSI_F_T10_PI)
> +					       (1ULL << VIRTIO_SCSI_F_T10_PI) |
> +					       (1ULL << VIRTIO_F_ANY_LAYOUT) |
> +					       (1ULL << VIRTIO_F_VERSION_1)
>  };
>  
>  #define VHOST_SCSI_MAX_TARGET	256
> @@ -1626,7 +1628,10 @@ static void vhost_scsi_handle_kick(struct vhost_work *work)
>  						poll.work);
>  	struct vhost_scsi *vs = container_of(vq->dev, struct vhost_scsi, dev);
>  
> -	vhost_scsi_handle_vq(vs, vq);
> +	if (vhost_has_feature(vq, VIRTIO_F_ANY_LAYOUT))
> +		vhost_scsi_handle_vqal(vs, vq);
> +	else
> +		vhost_scsi_handle_vq(vs, vq);
>  }
>  
>  static void vhost_scsi_flush_vq(struct vhost_scsi *vs, int index)
> -- 
> 1.9.1
