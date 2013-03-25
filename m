From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V7 4/5] virtio-scsi: introduce multiqueue support
Date: Mon, 25 Mar 2013 08:25:58 +0100
Message-ID: <514FFC06.9030703@acm.org>
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1364038124-32479-5-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1364038124-32479-5-git-send-email-gaowanlong@cn.fujitsu.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 03/23/13 12:28, Wanlong Gao wrote:
> +static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
> +					       struct virtio_scsi_target_state *tgt)
> +{
> +	struct virtio_scsi_vq *vq;
> +	unsigned long flags;
> +	u32 queue_num;
> +
> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
> +
> +	/*
> +	 * The memory barrier after atomic_inc_return matches
> +	 * the smp_read_barrier_depends() in virtscsi_req_done.
> +	 */
> +	if (atomic_inc_return(&tgt->reqs) > 1)
> +		vq = ACCESS_ONCE(tgt->req_vq);
> +	else {
> +		queue_num = smp_processor_id();
> +		while (unlikely(queue_num >= vscsi->num_queues))
> +			queue_num -= vscsi->num_queues;
> +
> +		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
> +	}
> +
> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> +	return vq;
> +}

Is there any reason why the smp_processor_id() % vscsi->num_queues 
computation in virtscsi_pick_vq() has been implemented as a loop instead 
of as an arithmetic operation ? If so, I would appreciate it if that 
could be explained in a comment.

Thanks,

Bart.
