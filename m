From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 4 Sep 2012 11:46:28 +0300
Message-ID: <20120904084628.GA8437@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <5045A3B4.2030101@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 04, 2012 at 08:46:12AM +0200, Paolo Bonzini wrote:
> Il 04/09/2012 04:21, Nicholas A. Bellinger ha scritto:
> >> @@ -112,6 +118,9 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
> >>  	struct virtio_scsi_cmd *cmd = buf;
> >>  	struct scsi_cmnd *sc = cmd->sc;
> >>  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
> >> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
> >> +
> >> +	atomic_dec(&tgt->reqs);
> >>  
> > 
> > As tgt->tgt_lock is taken in virtscsi_queuecommand_multi() before the
> > atomic_inc_return(tgt->reqs) check, it seems like using atomic_dec() w/o
> > smp_mb__after_atomic_dec or tgt_lock access here is not using atomic.h
> > accessors properly, no..?
> 
> No, only a single "thing" is being accessed, and there is no need to
> order the decrement with respect to preceding or subsequent accesses to
> other locations.
>
> In other words, tgt->reqs is already synchronized with itself, and that
> is enough.

I think your logic is correct and barrier is not needed,
but this needs better documentation.

> (Besides, on x86 smp_mb__after_atomic_dec is a nop).
> >> +static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
> >> +				       struct scsi_cmnd *sc)
> >> +{
> >> +	struct virtio_scsi *vscsi = shost_priv(sh);
> >> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
> >> +	unsigned long flags;
> >> +	u32 queue_num;
> >> +
> >> +	/* Using an atomic_t for tgt->reqs lets the virtqueue handler
> >> +	 * decrement it without taking the spinlock.
> >> +	 */

Above comment is not really helpful - reader can be safely assumed to
know what atomic_t is.

Please delete, and replace with the text from commit log
that explains the heuristic used to select req_vq.

Also please add a comment near 'reqs' definition.
Something like "number of outstanding requests - used to detect idle
target".


> >> +	spin_lock_irqsave(&tgt->tgt_lock, flags);

Looks like this lock can be removed - req_vq is only
modified when target is idle and only used when it is
not idle.

> >> +	if (atomic_inc_return(&tgt->reqs) == 1) {
> >> +		queue_num = smp_processor_id();
> >> +		while (unlikely(queue_num >= vscsi->num_queues))
> >> +			queue_num -= vscsi->num_queues;
> >> +		tgt->req_vq = &vscsi->req_vqs[queue_num];
> >> +	}
> >> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> >> +	return virtscsi_queuecommand(vscsi, tgt, sc);
> >> +}
> >> +
> >> +

.....

> >> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
> >> +                                       struct scsi_cmnd *sc)
> >> +{
> >> +       struct virtio_scsi *vscsi = shost_priv(sh);
> >> +       struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
> >> +
> >> +       atomic_inc(&tgt->reqs);
> >> +       return virtscsi_queuecommand(vscsi, tgt, sc);
> >> +}
> >> +

Here, reqs is unused - why bother incrementing it?
A branch on completion would be cheaper IMHO.


>virtio-scsi multiqueue has a performance benefit up to 20%

To be fair, you could be running in single queue mode.
In that case extra atomics and indirection that this code
brings will just add overhead without benefits.
I don't know how significant would that be.

-- 
MST
