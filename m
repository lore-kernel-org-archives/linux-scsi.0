From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 18 Dec 2012 17:03:27 +0200
Message-ID: <20121218150327.GB27400@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-6-git-send-email-pbonzini@redhat.com>
	<20121218135736.GF26110@redhat.com> <50D078C8.208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <50D078C8.208@redhat.com>
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

On Tue, Dec 18, 2012 at 03:08:08PM +0100, Paolo Bonzini wrote:
> Il 18/12/2012 14:57, Michael S. Tsirkin ha scritto:
> >> -static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >> +static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
> >> +				 struct virtio_scsi_target_state *tgt,
> >> +				 struct scsi_cmnd *sc)
> >>  {
> >> -	struct virtio_scsi *vscsi = shost_priv(sh);
> >> -	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> >>  	struct virtio_scsi_cmd *cmd;
> >> +	struct virtio_scsi_vq *req_vq;
> >>  	int ret;
> >>  
> >>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> >> @@ -461,7 +533,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
> >>  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
> >>  
> >> -	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
> >> +	req_vq = ACCESS_ONCE(tgt->req_vq);
> > 
> > This ACCESS_ONCE without a barrier looks strange to me.
> > Can req_vq change? Needs a comment.
> 
> Barriers are needed to order two things.  Here I don't have the second thing
> to order against, hence no barrier.
> 
> Accessing req_vq lockless is safe, and there's a comment about it, but you
> still want ACCESS_ONCE to ensure the compiler doesn't play tricks.

That's just it.
Why don't you want compiler to play tricks?

ACCESS_ONCE is needed if the value can change
while you access it, this helps ensure
a consistent value is evalutated.

If it can you almost always need a barrier. If it doesn't
you don't need ACCESS_ONCE.

>  It
> shouldn't be necessary, because the critical section of
> virtscsi_queuecommand_multi will already include the appropriate
> compiler barriers,

So if there's a barrier then pls add a comment saying where
it is.

> but it is actually clearer this way to me. :)

No barriers are needed I think because
when you queue command req is incremented to req_vq
can not change. But this also means ACCESS_ONCE
is not needed either.

> >> +	if (virtscsi_kick_cmd(tgt, req_vq, cmd,
> >>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
> >>  			      GFP_ATOMIC) == 0)
> >>  		ret = 0;
> >> @@ -472,6 +545,48 @@ out:
> >>  	return ret;
> >>  }
> >>  
> >> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
> >> +					struct scsi_cmnd *sc)
> >> +{
> >> +	struct virtio_scsi *vscsi = shost_priv(sh);
> >> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> >> +
> >> +	atomic_inc(&tgt->reqs);
> > 
> > And here we don't have barrier after atomic? Why? Needs a comment.
> 
> Because we don't write req_vq, so there's no two writes to order.  Barrier
> against what?

Between atomic update and command. Once you queue command it
can complete and decrement reqs, if this happens before
increment reqs can become negative even.

> >> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> >> +}
> >> +
> >> +static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
> >> +				       struct scsi_cmnd *sc)
> >> +{
> >> +	struct virtio_scsi *vscsi = shost_priv(sh);
> >> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> >> +	unsigned long flags;
> >> +	u32 queue_num;
> >> +
> >> +	/*
> >> +	 * Using an atomic_t for tgt->reqs lets the virtqueue handler
> >> +	 * decrement it without taking the spinlock.
> >> +	 *
> >> +	 * We still need a critical section to prevent concurrent submissions
> >> +	 * from picking two different req_vqs.
> >> +	 */
> >> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
> >> +	if (atomic_inc_return(&tgt->reqs) == 1) {
> >> +		queue_num = smp_processor_id();
> >> +		while (unlikely(queue_num >= vscsi->num_queues))
> >> +			queue_num -= vscsi->num_queues;
> >> +
> >> +		/*
> >> +		 * Write reqs before writing req_vq, matching the
> >> +		 * smp_read_barrier_depends() in virtscsi_req_done.
> >> +		 */
> >> +		smp_wmb();
> >> +		tgt->req_vq = &vscsi->req_vqs[queue_num];
> >> +	}
> >> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> >> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> >> +}
> >> +
> >>  static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
> >>  {
> >>  	DECLARE_COMPLETION_ONSTACK(comp);
> >> @@ -541,12 +656,26 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
> >>  	return virtscsi_tmf(vscsi, cmd);
> >>  }
> >>  
> >> -static struct scsi_host_template virtscsi_host_template = {
> >> +static struct scsi_host_template virtscsi_host_template_single = {
> >>  	.module = THIS_MODULE,
> >>  	.name = "Virtio SCSI HBA",
> >>  	.proc_name = "virtio_scsi",
> >> -	.queuecommand = virtscsi_queuecommand,
> >>  	.this_id = -1,
> >> +	.queuecommand = virtscsi_queuecommand_single,
> >> +	.eh_abort_handler = virtscsi_abort,
> >> +	.eh_device_reset_handler = virtscsi_device_reset,
> >> +
> >> +	.can_queue = 1024,
> >> +	.dma_boundary = UINT_MAX,
> >> +	.use_clustering = ENABLE_CLUSTERING,
> >> +};
> >> +
> >> +static struct scsi_host_template virtscsi_host_template_multi = {
> >> +	.module = THIS_MODULE,
> >> +	.name = "Virtio SCSI HBA",
> >> +	.proc_name = "virtio_scsi",
> >> +	.this_id = -1,
> >> +	.queuecommand = virtscsi_queuecommand_multi,
> >>  	.eh_abort_handler = virtscsi_abort,
> >>  	.eh_device_reset_handler = virtscsi_device_reset,
> >>  
> >> @@ -572,16 +701,27 @@ static struct scsi_host_template virtscsi_host_template = {
> >>  				  &__val, sizeof(__val)); \
> >>  	})
> >>  
> >> +
> >>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
> >> -			     struct virtqueue *vq)
> >> +			     struct virtqueue *vq, bool affinity)
> >>  {
> >>  	spin_lock_init(&virtscsi_vq->vq_lock);
> >>  	virtscsi_vq->vq = vq;
> >> +	if (affinity)
> >> +		virtqueue_set_affinity(vq, vq->index - VIRTIO_SCSI_VQ_BASE);
> > 
> > I've been thinking about how set_affinity
> > interacts with online/offline CPUs.
> > Any idea?
> 
> No, I haven't tried.

We need a TODO, for -net too.

> >>  
> >>  	/* Discover virtqueues and write information to configuration.  */
> >> -	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
> >> +	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
> >>  	if (err)
> >>  		return err;
> >>  
> >> -	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
> >> -	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
> >> -	virtscsi_init_vq(&vscsi->req_vq, vqs[2]);
> >> +	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
> >> +	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
> >> +	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
> >> +		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
> >> +				 vqs[i], vscsi->num_queues > 1);
> > 
> > So affinity is true if >1 vq? I am guessing this is not
> > going to do the right thing unless you have at least
> > as many vqs as CPUs.
> 
> Yes, and then you're not setting up the thing correctly.

Why not just check instead of doing the wrong thing?

> Isn't the same thing true for virtio-net mq?
> 
> Paolo

Last I looked it checked vi->max_queue_pairs == num_online_cpus().
This is even too aggressive I think, max_queue_pairs >=
num_online_cpus() should be enough.

-- 
MST
