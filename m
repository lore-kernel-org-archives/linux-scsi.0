From: Asias He <asias@redhat.com>
Subject: Re: [PATCH V6 1/5] virtio-scsi: redo allocation of target data
Date: Wed, 20 Mar 2013 15:33:30 +0800
Message-ID: <20130320073330.GA23497@hj.localdomain>
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363762884-11000-2-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1363762884-11000-2-git-send-email-gaowanlong@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, James Bottomley <James.Bottomley@HansenPartnership.com>, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 20, 2013 at 03:01:20PM +0800, Wanlong Gao wrote:
> virtio_scsi_target_state is now empty.  We will find new uses for it in
> the next few patches, so this patch does not drop it completely.
> 
> And as James suggested, we use entries target_alloc and target_destroy
> in the host template to allocate and destroy the virtio_scsi_target_state
> of each target, attach this struct to scsi_target->hostdata. Now
> we can get at it from the sdev with scsi_target(sdev)->hostdata.
> No messing around with fixed size arrays and bulk memory allocation
> and no need to pass in the maximum target size as a parameter because
> everything should now happen dynamically.
> 
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Reviewed-by: Asias He <asias@redhat.com>

> ---
>  drivers/scsi/virtio_scsi.c | 71 ++++++++++++++++------------------------------
>  1 file changed, 25 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index b53ba9e..ffa03e8 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -75,8 +75,6 @@ struct virtio_scsi {
>  
>  	/* Get some buffers ready for event vq */
>  	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
> -
> -	struct virtio_scsi_target_state *tgt[];
>  };
>  
>  static struct kmem_cache *virtscsi_cmd_cache;
> @@ -530,6 +528,25 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>  	return virtscsi_tmf(vscsi, cmd);
>  }
>  
> +static int virtscsi_target_alloc(struct scsi_target *starget)
> +{
> +	struct virtio_scsi_target_state *tgt =
> +				kmalloc(sizeof(*tgt), GFP_KERNEL);
> +	if (!tgt)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&tgt->tgt_lock);
> +
> +	starget->hostdata = tgt;
> +	return 0;
> +}
> +
> +static void virtscsi_target_destroy(struct scsi_target *starget)
> +{
> +	struct virtio_scsi_target_state *tgt = starget->hostdata;
> +	kfree(tgt);
> +}
> +
>  static struct scsi_host_template virtscsi_host_template = {
>  	.module = THIS_MODULE,
>  	.name = "Virtio SCSI HBA",
> @@ -542,6 +559,8 @@ static struct scsi_host_template virtscsi_host_template = {
>  	.can_queue = 1024,
>  	.dma_boundary = UINT_MAX,
>  	.use_clustering = ENABLE_CLUSTERING,
> +	.target_alloc = virtscsi_target_alloc,
> +	.target_destroy = virtscsi_target_destroy,
>  };
>  
>  #define virtscsi_config_get(vdev, fld) \
> @@ -568,20 +587,6 @@ static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>  	virtscsi_vq->vq = vq;
>  }
>  
> -static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
> -	struct virtio_device *vdev)
> -{
> -	struct virtio_scsi_target_state *tgt;
> -	gfp_t gfp_mask = GFP_KERNEL;
> -
> -	tgt = kmalloc(sizeof(*tgt), gfp_mask);
> -	if (!tgt)
> -		return NULL;
> -
> -	spin_lock_init(&tgt->tgt_lock);
> -	return tgt;
> -}
> -
>  static void virtscsi_scan(struct virtio_device *vdev)
>  {
>  	struct Scsi_Host *shost = (struct Scsi_Host *)vdev->priv;
> @@ -591,28 +596,17 @@ static void virtscsi_scan(struct virtio_device *vdev)
>  
>  static void virtscsi_remove_vqs(struct virtio_device *vdev)
>  {
> -	struct Scsi_Host *sh = virtio_scsi_host(vdev);
> -	struct virtio_scsi *vscsi = shost_priv(sh);
> -	u32 i, num_targets;
> -
>  	/* Stop all the virtqueues. */
>  	vdev->config->reset(vdev);
>  
> -	num_targets = sh->max_id;
> -	for (i = 0; i < num_targets; i++) {
> -		kfree(vscsi->tgt[i]);
> -		vscsi->tgt[i] = NULL;
> -	}
> -
>  	vdev->config->del_vqs(vdev);
>  }
>  
>  static int virtscsi_init(struct virtio_device *vdev,
> -			 struct virtio_scsi *vscsi, int num_targets)
> +			 struct virtio_scsi *vscsi)
>  {
>  	int err;
>  	struct virtqueue *vqs[3];
> -	u32 i;
>  
>  	vq_callback_t *callbacks[] = {
>  		virtscsi_ctrl_done,
> @@ -640,18 +634,6 @@ static int virtscsi_init(struct virtio_device *vdev,
>  	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
>  		virtscsi_kick_event_all(vscsi);
>  
> -	for (i = 0; i < num_targets; i++) {
> -		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev);
> -		if (!vscsi->tgt[i]) {
> -			err = -ENOMEM;
> -			goto out;
> -		}
> -	}
> -	err = 0;
> -
> -out:
> -	if (err)
> -		virtscsi_remove_vqs(vdev);
>  	return err;
>  }
>  
> @@ -663,12 +645,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	u32 sg_elems, num_targets;
>  	u32 cmd_per_lun;
>  
> -	/* Allocate memory and link the structs together.  */
>  	num_targets = virtscsi_config_get(vdev, max_target) + 1;
> -	shost = scsi_host_alloc(&virtscsi_host_template,
> -		sizeof(*vscsi)
> -		+ num_targets * sizeof(struct virtio_scsi_target_state));
>  
> +	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
>  	if (!shost)
>  		return -ENOMEM;
>  
> @@ -678,7 +657,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	vscsi->vdev = vdev;
>  	vdev->priv = shost;
>  
> -	err = virtscsi_init(vdev, vscsi, num_targets);
> +	err = virtscsi_init(vdev, vscsi);
>  	if (err)
>  		goto virtscsi_init_failed;
>  
> @@ -735,7 +714,7 @@ static int virtscsi_restore(struct virtio_device *vdev)
>  	struct Scsi_Host *sh = virtio_scsi_host(vdev);
>  	struct virtio_scsi *vscsi = shost_priv(sh);
>  
> -	return virtscsi_init(vdev, vscsi, sh->max_id);
> +	return virtscsi_init(vdev, vscsi);
>  }
>  #endif
>  
> -- 
> 1.8.2.rc2
> 

-- 
Asias
