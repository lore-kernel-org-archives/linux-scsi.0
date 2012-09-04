From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 04 Sep 2012 08:46:12 +0200
Message-ID: <5045A3B4.2030101@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346725294.4162.79.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Il 04/09/2012 04:21, Nicholas A. Bellinger ha scritto:
>> @@ -112,6 +118,9 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>>  	struct virtio_scsi_cmd *cmd = buf;
>>  	struct scsi_cmnd *sc = cmd->sc;
>>  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
>> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
>> +
>> +	atomic_dec(&tgt->reqs);
>>  
> 
> As tgt->tgt_lock is taken in virtscsi_queuecommand_multi() before the
> atomic_inc_return(tgt->reqs) check, it seems like using atomic_dec() w/o
> smp_mb__after_atomic_dec or tgt_lock access here is not using atomic.h
> accessors properly, no..?

No, only a single "thing" is being accessed, and there is no need to
order the decrement with respect to preceding or subsequent accesses to
other locations.

In other words, tgt->reqs is already synchronized with itself, and that
is enough.

(Besides, on x86 smp_mb__after_atomic_dec is a nop).

>> +static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
>> +				       struct scsi_cmnd *sc)
>> +{
>> +	struct virtio_scsi *vscsi = shost_priv(sh);
>> +	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
>> +	unsigned long flags;
>> +	u32 queue_num;
>> +
>> +	/* Using an atomic_t for tgt->reqs lets the virtqueue handler
>> +	 * decrement it without taking the spinlock.
>> +	 */
>> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
>> +	if (atomic_inc_return(&tgt->reqs) == 1) {
>> +		queue_num = smp_processor_id();
>> +		while (unlikely(queue_num >= vscsi->num_queues))
>> +			queue_num -= vscsi->num_queues;
>> +		tgt->req_vq = &vscsi->req_vqs[queue_num];
>> +	}
>> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>> +	return virtscsi_queuecommand(vscsi, tgt, sc);
>> +}
>> +
> 
> The extra memory barriers to get this right for the current approach are
> just going to slow things down even more for virtio-scsi-mq..

virtio-scsi multiqueue has a performance benefit up to 20% (for a single
LUN) or 40% (on overall bandwidth across multiple LUNs).  I doubt that a
single memory barrier can have that much impact. :)

The way to go to improve performance even more is to add new virtio APIs
for finer control of the usage of the ring.  These should let us avoid
copying the sg list and almost get rid of the tgt_lock; even though the
locking is quite efficient in virtio-scsi (see how tgt_lock and vq_lock
are "pipelined" so as to overlap the preparation of two requests), it
should give a nice improvement and especially avoid a kmalloc with small
requests.  I may have some time for it next month.

> Jen's approach is what we will ultimately need to re-architect in SCSI
> core if we're ever going to move beyond the issues of legacy host_lock,
> so I'm wondering if maybe this is the direction that virtio-scsi-mq
> needs to go in as well..?

We can see after the block layer multiqueue work goes in...  I also need
to look more closely at Jens's changes.

Have you measured the host_lock to be a bottleneck in high-iops
benchmarks, even for a modern driver that does not hold it in
queuecommand?  (Certainly it will become more important as the
virtio-scsi queuecommand becomes thinner and thinner).  If so, we can
start looking at limiting host_lock usage in the fast path.

BTW, supporting this in tcm-vhost should be quite trivial, as all the
request queues are the same and all serialization is done in the
virtio-scsi driver.

Paolo
