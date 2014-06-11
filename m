From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/6] virtio-scsi: avoid cancelling uninitialized work
 items
Date: Wed, 11 Jun 2014 05:47:31 -0700
Message-ID: <20140611124731.GA16990@infradead.org>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
 <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

Can I get a second review on this one from anyone?

On Wed, Jun 04, 2014 at 01:34:56PM +0200, Paolo Bonzini wrote:
> Calling the workqueue interface on uninitialized work items isn't a
> good idea even if they're zeroed. It's not failing catastrophically only
> through happy accidents.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index f0b4cdbfceb0..d66c4ee2c774 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -253,6 +253,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
>  	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
>  };
>  
> +static void virtscsi_handle_event(struct work_struct *work);
> +
>  static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  			       struct virtio_scsi_event_node *event_node)
>  {
> @@ -260,6 +262,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  	struct scatterlist sg;
>  	unsigned long flags;
>  
> +	INIT_WORK(&event_node->work, virtscsi_handle_event);
>  	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>  
>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> @@ -377,7 +380,6 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
>  {
>  	struct virtio_scsi_event_node *event_node = buf;
>  
> -	INIT_WORK(&event_node->work, virtscsi_handle_event);
>  	schedule_work(&event_node->work);
>  }
>  
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
