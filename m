From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Mon, 03 Sep 2012 19:21:34 -0700
Message-ID: <1346725294.4162.79.camel@haakon2.linux-iscsi.org>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-08-28 at 13:54 +0200, Paolo Bonzini wrote:
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
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Hey Paolo & Co,

I've not had a chance to try this with tcm_vhost just yet, but noticed
one thing wrt to assumptions about virtio_scsi_target_state->reqs access
below..

>  drivers/scsi/virtio_scsi.c |  162 +++++++++++++++++++++++++++++++++++---------
>  1 files changed, 130 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 6414ea0..0c4b096 100644
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
> @@ -59,9 +60,13 @@ struct virtio_scsi_vq {
>  
>  /* Per-target queue state */
>  struct virtio_scsi_target_state {
> -	/* Protects sg.  Lock hierarchy is tgt_lock -> vq_lock.  */
> +	/* Protects sg, req_vq.  Lock hierarchy is tgt_lock -> vq_lock.  */
>  	spinlock_t tgt_lock;
>  
> +	struct virtio_scsi_vq *req_vq;
> +
> +	atomic_t reqs;
> +
>  	/* For sglist construction when adding commands to the virtqueue.  */
>  	struct scatterlist sg[];
>  };
> @@ -70,14 +75,15 @@ struct virtio_scsi_target_state {
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
> +	u32 num_queues;
>  	struct virtio_scsi_target_state **tgt;
> +
> +	struct virtio_scsi_vq ctrl_vq;
> +	struct virtio_scsi_vq event_vq;
> +	struct virtio_scsi_vq req_vqs[];
>  };
>  
>  static struct kmem_cache *virtscsi_cmd_cache;
> @@ -112,6 +118,9 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  	struct virtio_scsi_cmd *cmd = buf;
>  	struct scsi_cmnd *sc = cmd->sc;
>  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
> +
> +	atomic_dec(&tgt->reqs);
>  

As tgt->tgt_lock is taken in virtscsi_queuecommand_multi() before the
atomic_inc_return(tgt->reqs) check, it seems like using atomic_dec() w/o
smp_mb__after_atomic_dec or tgt_lock access here is not using atomic.h
accessors properly, no..?

>  	dev_dbg(&sc->device->sdev_gendev,
>  		"cmd %p response %u status %#02x sense_len %u\n",
> @@ -185,11 +194,13 @@ static void virtscsi_req_done(struct virtqueue *vq)
>  {
>  	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
>  	struct virtio_scsi *vscsi = shost_priv(sh);
> +	int index = virtqueue_get_queue_index(vq) - VIRTIO_SCSI_VQ_BASE;
> +	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
> +	spin_lock_irqsave(&req_vq->vq_lock, flags);
>  	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
> -	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
> +	spin_unlock_irqrestore(&req_vq->vq_lock, flags);
>  };
>  
>  static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
> @@ -429,10 +440,10 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
>  	return ret;
>  }
>  
> -static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> +static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
> +				 struct virtio_scsi_target_state *tgt,
> +				 struct scsi_cmnd *sc)
>  {
> -	struct virtio_scsi *vscsi = shost_priv(sh);
> -	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
>  	struct virtio_scsi_cmd *cmd;
>  	int ret;
>  
> @@ -466,7 +477,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
>  
> -	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
> +	if (virtscsi_kick_cmd(tgt, tgt->req_vq, cmd,
>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
>  			      GFP_ATOMIC) >= 0)
>  		ret = 0;
> @@ -475,6 +486,38 @@ out:
>  	return ret;
>  }
>  
> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
> +					struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
> +
> +	atomic_inc(&tgt->reqs);
> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> +}
> +

...

> +static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
> +				       struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
> +	unsigned long flags;
> +	u32 queue_num;
> +
> +	/* Using an atomic_t for tgt->reqs lets the virtqueue handler
> +	 * decrement it without taking the spinlock.
> +	 */
> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
> +	if (atomic_inc_return(&tgt->reqs) == 1) {
> +		queue_num = smp_processor_id();
> +		while (unlikely(queue_num >= vscsi->num_queues))
> +			queue_num -= vscsi->num_queues;
> +		tgt->req_vq = &vscsi->req_vqs[queue_num];
> +	}
> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> +}
> +

The extra memory barriers to get this right for the current approach are
just going to slow things down even more for virtio-scsi-mq..

After hearing Jen's blk-mq talk last week in San Diego + having a look
at the new code in linux-block.git/new-queue, the approach of using a
per-cpu lock-less-list  hw -> sw queue that uses IPI + numa_node hints
to make smart decisions for the completion path is making alot of sense.

Jen's approach is what we will ultimately need to re-architect in SCSI
core if we're ever going to move beyond the issues of legacy host_lock,
so I'm wondering if maybe this is the direction that virtio-scsi-mq
needs to go in as well..?

--nab
