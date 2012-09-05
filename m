From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Wed, 05 Sep 2012 09:03:53 +0200
Message-ID: <5046F959.8020500@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com>
	<1346789466.4162.181.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346789466.4162.181.camel@haakon2.linux-iscsi.org>
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

Il 04/09/2012 22:11, Nicholas A. Bellinger ha scritto:
>>> As tgt->tgt_lock is taken in virtscsi_queuecommand_multi() before the
>>> atomic_inc_return(tgt->reqs) check, it seems like using atomic_dec() w/o
>>> smp_mb__after_atomic_dec or tgt_lock access here is not using atomic.h
>>> accessors properly, no..?
>>
>> No, only a single "thing" is being accessed, and there is no need to
>> order the decrement with respect to preceding or subsequent accesses to
>> other locations.
>>
>> In other words, tgt->reqs is already synchronized with itself, and that
>> is enough.
>>
> 
> However, it's still my understanding that the use of atomic_dec() in the
> completion path mean that smp_mb__after_atomic_dec() is a requirement to
> be proper portable atomic.hcode, no..?  Otherwise tgt->regs should be
> using something other than an atomic_t, right..?

Memory barriers aren't _always_ requested, only when you need to order
accesses to multiple locations.

In this case, there is no other location that the
queuecommand/completion handlers needs to synchronize against, so no
barrier is required.  You can see plenty of atomic_inc/atomic_dec in the
code without a barrier afterwards (the typical case is the opposite as
in this patch: a refcount increment needs no barrier, a refcount
decrement uses atomic_dec_return).

>> virtio-scsi multiqueue has a performance benefit up to 20% (for a single
>> LUN) or 40% (on overall bandwidth across multiple LUNs).  I doubt that a
>> single memory barrier can have that much impact. :)
>>
> 
> I've no doubt that this series increases the large block high bandwidth
> for virtio-scsi, but historically that has always been the easier
> workload to scale.  ;)

This is with a mixed workload (random 4k-64k) and tmpfs backend on the host.

> Yes, I think Jen's new approach is providing some pretty significant
> gains for raw block drivers with extremly high packet (small block
> random I/O) workloads, esp with hw block drivers that support genuine mq
> with hw num_queues > 1.

I need to look into it, to understand how the queue steering here can be
adapted to his code.

>> Have you measured the host_lock to be a bottleneck in high-iops
>> benchmarks, even for a modern driver that does not hold it in
>> queuecommand?  (Certainly it will become more important as the
>> virtio-scsi queuecommand becomes thinner and thinner).
> 
> This is exactly why it would make such a good vehicle to re-architect
> SCSI core.  I'm thinking it can be the first sw LLD we attempt to get
> running on an (currently) future scsi-mq prototype.

Agreed.

Paolo
