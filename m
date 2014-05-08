From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
Date: Thu, 08 May 2014 10:47:33 +0200
Message-ID: <536B44A5.7090007@redhat.com>
References: <1399533826-29217-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaEHIr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2014 04:47:57 -0400
In-Reply-To: <1399533826-29217-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 08/05/2014 09:23, Ming Lei ha scritto:
> Access to tgt->req_vq is strictly serialized by spin_lock
> of tgt->tgt_lock, so the ACCESS_ONCE() isn't necessary.
>
> smp_read_barrier_depends() in virtscsi_req_done was introduced
> to order reading req_vq and decreasing tgt->reqs, but it isn't
> needed now because req_vq is read from
> scsi->req_vqs[vq->index - VIRTIO_SCSI_VQ_BASE] instead of
> tgt->req_vq, so remove the unnecessary barrier.
>
> Also remove related comment about the barrier.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
> v2:
> 	- take Paolo's comment on decrements of reqs
>
> v1:
> 	- fix comment on decrements of reqs with writing of req_vq
> 	as suggested by Paolo
>
>  drivers/scsi/virtio_scsi.c |   53 +++++---------------------------------------
>  1 file changed, 6 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 16bfd50..13dd500 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -73,17 +73,12 @@ struct virtio_scsi_vq {
>   * queue, and also lets the driver optimize the IRQ affinity for the virtqueues
>   * (each virtqueue's affinity is set to the CPU that "owns" the queue).
>   *
> - * An interesting effect of this policy is that only writes to req_vq need to
> - * take the tgt_lock.  Read can be done outside the lock because:
> + * tgt_lock is held to serialize reading and writing req_vq. Reading req_vq
> + * could be done locklessly, but we do not do it yet.
>   *
> - * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
> - *   In that case, no other CPU is reading req_vq: even if they were in
> - *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
> - *
> - * - reads of req_vq only occur when the target is not idle (reqs != 0).
> - *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.
> - *
> - * Similarly, decrements of reqs are never concurrent with writes of req_vq.
> + * Decrements of reqs are never concurrent with writes of req_vq: before the
> + * decrement reqs will be != 0; after the decrement the virtqueue completion
> + * routine will not use the req_vq so it can be changed by a new request.
>   * Thus they can happen outside the tgt_lock, provided of course we make reqs
>   * an atomic_t.
>   */
> @@ -238,38 +233,6 @@ static void virtscsi_req_done(struct virtqueue *vq)
>  	int index = vq->index - VIRTIO_SCSI_VQ_BASE;
>  	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
>
> -	/*
> -	 * Read req_vq before decrementing the reqs field in
> -	 * virtscsi_complete_cmd.
> -	 *
> -	 * With barriers:
> -	 *
> -	 * 	CPU #0			virtscsi_queuecommand_multi (CPU #1)
> -	 * 	------------------------------------------------------------
> -	 * 	lock vq_lock
> -	 * 	read req_vq
> -	 * 	read reqs (reqs = 1)
> -	 * 	write reqs (reqs = 0)
> -	 * 				increment reqs (reqs = 1)
> -	 * 				write req_vq
> -	 *
> -	 * Possible reordering without barriers:
> -	 *
> -	 * 	CPU #0			virtscsi_queuecommand_multi (CPU #1)
> -	 * 	------------------------------------------------------------
> -	 * 	lock vq_lock
> -	 * 	read reqs (reqs = 1)
> -	 * 	write reqs (reqs = 0)
> -	 * 				increment reqs (reqs = 1)
> -	 * 				write req_vq
> -	 * 	read (wrong) req_vq
> -	 *
> -	 * We do not need a full smp_rmb, because req_vq is required to get
> -	 * to tgt->reqs: tgt is &vscsi->tgt[sc->device->id], where sc is stored
> -	 * in the virtqueue as the user token.
> -	 */
> -	smp_read_barrier_depends();
> -
>  	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
>  };
>
> @@ -560,12 +523,8 @@ static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
>
>  	spin_lock_irqsave(&tgt->tgt_lock, flags);
>
> -	/*
> -	 * The memory barrier after atomic_inc_return matches
> -	 * the smp_read_barrier_depends() in virtscsi_req_done.
> -	 */
>  	if (atomic_inc_return(&tgt->reqs) > 1)
> -		vq = ACCESS_ONCE(tgt->req_vq);
> +		vq = tgt->req_vq;
>  	else {
>  		queue_num = smp_processor_id();
>  		while (unlikely(queue_num >= vscsi->num_queues))
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
