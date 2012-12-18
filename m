From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 18 Dec 2012 15:57:36 +0200
Message-ID: <20121218135736.GF26110@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-6-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1355833972-20319-6-git-send-email-pbonzini@redhat.com>
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

On Tue, Dec 18, 2012 at 01:32:52PM +0100, Paolo Bonzini wrote:
> This patch adds queue steering to virtio-scsi.  When a target is sent
> multiple requests, we always drive them to the same queue so that FIFO
> processing order is kept.  However, if a target was idle, we can choose
> a queue arbitrarily.  In this case the queue is chosen according to the
> current VCPU, so the driver expects the number of request queues to be
> equal to the number of VCPUs.  This makes it easy and fast to select
> the queue, and also lets the driver optimize the IRQ affinity for the
> virtqueues (each virtqueue's affinity is set to the CPU that "owns"
> the queue).
> 
> The speedup comes from improving cache locality and giving CPU affinity
> to the virtqueues, which is why this scheme was selected.  Assuming that
> the thread that is sending requests to the device is I/O-bound, it is
> likely to be sleeping at the time the ISR is executed, and thus executing
> the ISR on the same processor that sent the requests is cheap.
> 
> However, the kernel will not execute the ISR on the "best" processor
> unless you explicitly set the affinity.  This is because in practice
> you will have many such I/O-bound processes and thus many otherwise
> idle processors.  Then the kernel will execute the ISR on a random
> processor, rather than the one that is sending requests to the device.
> 
> The alternative to per-CPU virtqueues is per-target virtqueues.  To
> achieve the same locality, we could dynamically choose the virtqueue's
> affinity based on the CPU of the last task that sent a request.  This
> is less appealing because we do not set the affinity directly---we only
> provide a hint to the irqbalanced running in userspace.  Dynamically
> changing the affinity only works if the userspace applies the hint
> fast enough.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	v1->v2: improved comments and commit messages, added memory barriers
> 
>  drivers/scsi/virtio_scsi.c |  234 +++++++++++++++++++++++++++++++++++++------
>  1 files changed, 201 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 4f6c6a3..ca9d29d 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -26,6 +26,7 @@
>  
>  #define VIRTIO_SCSI_MEMPOOL_SZ 64
>  #define VIRTIO_SCSI_EVENT_LEN 8
> +#define VIRTIO_SCSI_VQ_BASE 2
>  
>  /* Command queue element */
>  struct virtio_scsi_cmd {
> @@ -57,24 +58,57 @@ struct virtio_scsi_vq {
>  	struct virtqueue *vq;
>  };
>  
> -/* Per-target queue state */
> +/*
> + * Per-target queue state.
> + *
> + * This struct holds the data needed by the queue steering policy.  When a
> + * target is sent multiple requests, we need to drive them to the same queue so
> + * that FIFO processing order is kept.  However, if a target was idle, we can
> + * choose a queue arbitrarily.  In this case the queue is chosen according to
> + * the current VCPU, so the driver expects the number of request queues to be
> + * equal to the number of VCPUs.  This makes it easy and fast to select the
> + * queue, and also lets the driver optimize the IRQ affinity for the virtqueues
> + * (each virtqueue's affinity is set to the CPU that "owns" the queue).
> + *
> + * An interesting effect of this policy is that only writes to req_vq need to
> + * take the tgt_lock.  Read can be done outside the lock because:
> + *
> + * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
> + *   In that case, no other CPU is reading req_vq: even if they were in
> + *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
> + *
> + * - reads of req_vq only occur when the target is not idle (reqs != 0).
> + *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.
> + *
> + * Similarly, decrements of reqs are never concurrent with writes of req_vq.
> + * Thus they can happen outside the tgt_lock, provided of course we make reqs
> + * an atomic_t.
> + */
>  struct virtio_scsi_target_state {
> -	/* Never held at the same time as vq_lock.  */
> +	/* This spinlock ever held at the same time as vq_lock.  */
>  	spinlock_t tgt_lock;
> +
> +	/* Count of outstanding requests.  */
> +	atomic_t reqs;
> +
> +	/* Currently active virtqueue for requests sent to this target.  */
> +	struct virtio_scsi_vq *req_vq;
>  };
>  
>  /* Driver instance state */
>  struct virtio_scsi {
>  	struct virtio_device *vdev;
>  
> -	struct virtio_scsi_vq ctrl_vq;
> -	struct virtio_scsi_vq event_vq;
> -	struct virtio_scsi_vq req_vq;
> -
>  	/* Get some buffers ready for event vq */
>  	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
>  
>  	struct virtio_scsi_target_state *tgt;
> +
> +	u32 num_queues;
> +
> +	struct virtio_scsi_vq ctrl_vq;
> +	struct virtio_scsi_vq event_vq;
> +	struct virtio_scsi_vq req_vqs[];
>  };
>  
>  static struct kmem_cache *virtscsi_cmd_cache;
> @@ -109,6 +143,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  	struct virtio_scsi_cmd *cmd = buf;
>  	struct scsi_cmnd *sc = cmd->sc;
>  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
>  
>  	dev_dbg(&sc->device->sdev_gendev,
>  		"cmd %p response %u status %#02x sense_len %u\n",
> @@ -163,6 +198,8 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  
>  	mempool_free(cmd, virtscsi_cmd_pool);
>  	sc->scsi_done(sc);
> +
> +	atomic_dec(&tgt->reqs);
>  }
>  
>  static void virtscsi_vq_done(struct virtio_scsi *vscsi, struct virtqueue *vq,
> @@ -182,11 +219,45 @@ static void virtscsi_req_done(struct virtqueue *vq)
>  {
>  	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
>  	struct virtio_scsi *vscsi = shost_priv(sh);
> +	int index = vq->index - VIRTIO_SCSI_VQ_BASE;
> +	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
> +	/*
> +	 * Read req_vq before decrementing the reqs field in
> +	 * virtscsi_complete_cmd.
> +	 *
> +	 * With barriers:
> +	 *
> +	 * 	CPU #0			virtscsi_queuecommand_multi (CPU #1)
> +	 * 	------------------------------------------------------------
> +	 * 	lock vq_lock
> +	 * 	read req_vq
> +	 * 	read reqs (reqs = 1)
> +	 * 	write reqs (reqs = 0)
> +	 * 				increment reqs (reqs = 1)
> +	 * 				write req_vq
> +	 *
> +	 * Possible reordering without barriers:
> +	 *
> +	 * 	CPU #0			virtscsi_queuecommand_multi (CPU #1)
> +	 * 	------------------------------------------------------------
> +	 * 	lock vq_lock
> +	 * 	read reqs (reqs = 1)
> +	 * 	write reqs (reqs = 0)
> +	 * 				increment reqs (reqs = 1)
> +	 * 				write req_vq
> +	 * 	read (wrong) req_vq
> +	 *
> +	 * We do not need a full smp_rmb, because req_vq is required to get
> +	 * to tgt->reqs: tgt is &vscsi->tgt[sc->device->id], where sc is stored
> +	 * in the virtqueue as the user token.
> +	 */
> +	smp_read_barrier_depends();
> +
> +	spin_lock_irqsave(&req_vq->vq_lock, flags);
>  	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
> -	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
> +	spin_unlock_irqrestore(&req_vq->vq_lock, flags);
>  };
>  
>  static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
> @@ -424,11 +495,12 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
>  	return ret;
>  }
>  
> -static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> +static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
> +				 struct virtio_scsi_target_state *tgt,
> +				 struct scsi_cmnd *sc)
>  {
> -	struct virtio_scsi *vscsi = shost_priv(sh);
> -	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
>  	struct virtio_scsi_cmd *cmd;
> +	struct virtio_scsi_vq *req_vq;
>  	int ret;
>  
>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> @@ -461,7 +533,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
>  
> -	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
> +	req_vq = ACCESS_ONCE(tgt->req_vq);

This ACCESS_ONCE without a barrier looks strange to me.
Can req_vq change? Needs a comment.

> +	if (virtscsi_kick_cmd(tgt, req_vq, cmd,
>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
>  			      GFP_ATOMIC) == 0)
>  		ret = 0;
> @@ -472,6 +545,48 @@ out:
>  	return ret;
>  }
>  
> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
> +					struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> +
> +	atomic_inc(&tgt->reqs);

And here we don't have barrier after atomic? Why? Needs a comment.

> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> +}
> +
> +static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
> +				       struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> +	unsigned long flags;
> +	u32 queue_num;
> +
> +	/*
> +	 * Using an atomic_t for tgt->reqs lets the virtqueue handler
> +	 * decrement it without taking the spinlock.
> +	 *
> +	 * We still need a critical section to prevent concurrent submissions
> +	 * from picking two different req_vqs.
> +	 */
> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
> +	if (atomic_inc_return(&tgt->reqs) == 1) {
> +		queue_num = smp_processor_id();
> +		while (unlikely(queue_num >= vscsi->num_queues))
> +			queue_num -= vscsi->num_queues;
> +
> +		/*
> +		 * Write reqs before writing req_vq, matching the
> +		 * smp_read_barrier_depends() in virtscsi_req_done.
> +		 */
> +		smp_wmb();
> +		tgt->req_vq = &vscsi->req_vqs[queue_num];
> +	}
> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> +}
> +
>  static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  {
>  	DECLARE_COMPLETION_ONSTACK(comp);
> @@ -541,12 +656,26 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>  	return virtscsi_tmf(vscsi, cmd);
>  }
>  
> -static struct scsi_host_template virtscsi_host_template = {
> +static struct scsi_host_template virtscsi_host_template_single = {
>  	.module = THIS_MODULE,
>  	.name = "Virtio SCSI HBA",
>  	.proc_name = "virtio_scsi",
> -	.queuecommand = virtscsi_queuecommand,
>  	.this_id = -1,
> +	.queuecommand = virtscsi_queuecommand_single,
> +	.eh_abort_handler = virtscsi_abort,
> +	.eh_device_reset_handler = virtscsi_device_reset,
> +
> +	.can_queue = 1024,
> +	.dma_boundary = UINT_MAX,
> +	.use_clustering = ENABLE_CLUSTERING,
> +};
> +
> +static struct scsi_host_template virtscsi_host_template_multi = {
> +	.module = THIS_MODULE,
> +	.name = "Virtio SCSI HBA",
> +	.proc_name = "virtio_scsi",
> +	.this_id = -1,
> +	.queuecommand = virtscsi_queuecommand_multi,
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
>  
> @@ -572,16 +701,27 @@ static struct scsi_host_template virtscsi_host_template = {
>  				  &__val, sizeof(__val)); \
>  	})
>  
> +
>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
> -			     struct virtqueue *vq)
> +			     struct virtqueue *vq, bool affinity)
>  {
>  	spin_lock_init(&virtscsi_vq->vq_lock);
>  	virtscsi_vq->vq = vq;
> +	if (affinity)
> +		virtqueue_set_affinity(vq, vq->index - VIRTIO_SCSI_VQ_BASE);

I've been thinking about how set_affinity
interacts with online/offline CPUs.
Any idea?


>  }
>  
> -static void virtscsi_init_tgt(struct virtio_scsi_target_state *tgt)
> +static void virtscsi_init_tgt(struct virtio_scsi *vscsi, int i)
>  {
> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[i];
>  	spin_lock_init(&tgt->tgt_lock);
> +	atomic_set(&tgt->reqs, 0);
> +
> +	/*
> +	 * The default is unused for multiqueue, but with a single queue
> +	 * or target we use it in virtscsi_queuecommand.
> +	 */
> +	tgt->req_vq = &vscsi->req_vqs[0];
>  }
>  
>  static void virtscsi_scan(struct virtio_device *vdev)
> @@ -609,28 +749,41 @@ static int virtscsi_init(struct virtio_device *vdev,
>  			 struct virtio_scsi *vscsi, int num_targets)
>  {
>  	int err;
> -	struct virtqueue *vqs[3];
>  	u32 i, sg_elems;
> +	u32 num_vqs;
> +	vq_callback_t **callbacks;
> +	const char **names;
> +	struct virtqueue **vqs;
>  
> -	vq_callback_t *callbacks[] = {
> -		virtscsi_ctrl_done,
> -		virtscsi_event_done,
> -		virtscsi_req_done
> -	};
> -	const char *names[] = {
> -		"control",
> -		"event",
> -		"request"
> -	};
> +	num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
> +	vqs = kmalloc(num_vqs * sizeof(struct virtqueue *), GFP_KERNEL);
> +	callbacks = kmalloc(num_vqs * sizeof(vq_callback_t *), GFP_KERNEL);
> +	names = kmalloc(num_vqs * sizeof(char *), GFP_KERNEL);
> +
> +	if (!callbacks || !vqs || !names) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	callbacks[0] = virtscsi_ctrl_done;
> +	callbacks[1] = virtscsi_event_done;
> +	names[0] = "control";
> +	names[1] = "event";
> +	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++) {
> +		callbacks[i] = virtscsi_req_done;
> +		names[i] = "request";
> +	}
>  
>  	/* Discover virtqueues and write information to configuration.  */
> -	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
> +	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
>  	if (err)
>  		return err;
>  
> -	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
> -	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
> -	virtscsi_init_vq(&vscsi->req_vq, vqs[2]);
> +	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
> +	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
> +	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
> +		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
> +				 vqs[i], vscsi->num_queues > 1);

So affinity is true if >1 vq? I am guessing this is not
going to do the right thing unless you have at least
as many vqs as CPUs.

>  
>  	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
>  	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
> @@ -647,11 +800,14 @@ static int virtscsi_init(struct virtio_device *vdev,
>  		goto out;
>  	}
>  	for (i = 0; i < num_targets; i++)
> -		virtscsi_init_tgt(&vscsi->tgt[i]);
> +		virtscsi_init_tgt(vscsi, i);
>  
>  	err = 0;
>  
>  out:
> +	kfree(names);
> +	kfree(callbacks);
> +	kfree(vqs);
>  	if (err)
>  		virtscsi_remove_vqs(vdev);
>  	return err;
> @@ -664,11 +820,22 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
>  	int err;
>  	u32 sg_elems, num_targets;
>  	u32 cmd_per_lun;
> +	u32 num_queues;
> +	struct scsi_host_template *hostt;
> +
> +	/* We need to know how many queues before we allocate.  */
> +	num_queues = virtscsi_config_get(vdev, num_queues) ?: 1;
>  
>  	/* Allocate memory and link the structs together.  */
>  	num_targets = virtscsi_config_get(vdev, max_target) + 1;
> -	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
>  
> +	if (num_queues == 1)
> +		hostt = &virtscsi_host_template_single;
> +	else
> +		hostt = &virtscsi_host_template_multi;
> +
> +	shost = scsi_host_alloc(hostt,
> +		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
>  	if (!shost)
>  		return -ENOMEM;
>  
> @@ -676,6 +843,7 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
>  	shost->sg_tablesize = sg_elems;
>  	vscsi = shost_priv(shost);
>  	vscsi->vdev = vdev;
> +	vscsi->num_queues = num_queues;
>  	vdev->priv = shost;
>  
>  	err = virtscsi_init(vdev, vscsi, num_targets);
> -- 
> 1.7.1
