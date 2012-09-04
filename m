From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 04 Sep 2012 12:25:03 +0200
Message-ID: <5045D6FF.5020801@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com> <20120904084628.GA8437@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120904084628.GA8437@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Il 04/09/2012 10:46, Michael S. Tsirkin ha scritto:
>>>> +static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
>>>> +				       struct scsi_cmnd *sc)
>>>> +{
>>>> +	struct virtio_scsi *vscsi = shost_priv(sh);
>>>> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
>>>> +	unsigned long flags;
>>>> +	u32 queue_num;
>>>> +
>>>> +	/* Using an atomic_t for tgt->reqs lets the virtqueue handler
>>>> +	 * decrement it without taking the spinlock.
>>>> +	 */
> 
> Above comment is not really helpful - reader can be safely assumed to
> know what atomic_t is.

Sure, the comment explains that we use an atomic because _elsewhere_ the
tgt_lock is not held while modifying reqs.

> Please delete, and replace with the text from commit log
> that explains the heuristic used to select req_vq.

Ok.

> Also please add a comment near 'reqs' definition.
> Something like "number of outstanding requests - used to detect idle
> target".

Ok.

> 
>>>> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
> 
> Looks like this lock can be removed - req_vq is only
> modified when target is idle and only used when it is
> not idle.

If you have two incoming requests at the same time, req_vq is also
modified when the target is not idle; that's the point of the lock.

Suppose tgt->reqs = 0 initially, and you have two processors/queues.
Initially tgt->req_vq is queue #1.  If you have this:

    queuecommand on CPU #0         queuecommand #2 on CPU #1
  --------------------------------------------------------------
    atomic_inc_return(...) == 1
                                   atomic_inc_return(...) == 2
                                   virtscsi_queuecommand to queue #1
    tgt->req_vq = queue #0
    virtscsi_queuecommand to queue #0

then two requests are issued to different queues without a quiescent
point in the middle.

>>>> +	if (atomic_inc_return(&tgt->reqs) == 1) {
>>>> +		queue_num = smp_processor_id();
>>>> +		while (unlikely(queue_num >= vscsi->num_queues))
>>>> +			queue_num -= vscsi->num_queues;
>>>> +		tgt->req_vq = &vscsi->req_vqs[queue_num];
>>>> +	}
>>>> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>>>> +	return virtscsi_queuecommand(vscsi, tgt, sc);
>>>> +}
>>>> +
>>>> +
> 
> .....
> 
>>>> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
>>>> +                                       struct scsi_cmnd *sc)
>>>> +{
>>>> +       struct virtio_scsi *vscsi = shost_priv(sh);
>>>> +       struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
>>>> +
>>>> +       atomic_inc(&tgt->reqs);
>>>> +       return virtscsi_queuecommand(vscsi, tgt, sc);
>>>> +}
>>>> +
> 
> Here, reqs is unused - why bother incrementing it?
> A branch on completion would be cheaper IMHO.

Well, I could also let tgt->reqs go negative, but it would be a bit untidy.

Another alternative is to access the target's target_busy field with
ACCESS_ONCE, and drop reqs altogether.  Too tricky to do this kind of
micro-optimization so early, though.

>> virtio-scsi multiqueue has a performance benefit up to 20%
> 
> To be fair, you could be running in single queue mode.
> In that case extra atomics and indirection that this code
> brings will just add overhead without benefits.
> I don't know how significant would that be.

Not measurable in my experiments.

Paolo
