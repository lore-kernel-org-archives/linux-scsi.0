From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: virtio-scsi: two questions related with picking up queue
Date: Thu, 8 May 2014 22:00:40 +0800
Message-ID: <CACVXFVNs7gaUFUGcU2EjMG9_W-j9TLLM1y5D==B8-M+SPeYXWg@mail.gmail.com>
References: <CACVXFVNeBbJgA6h5n1Mt7vp7_Es67N5KEpZ0en4O+9GnD6wp+A@mail.gmail.com>
	<5368E0DB.5010000@redhat.com>
	<20140508002437.0dd549e8@tom-ThinkPad-T410>
	<536A62C1.6000905@redhat.com>
	<20140508184403.793719bd@tom-ThinkPad-T410>
	<536B75C9.6090402@redhat.com>
	<CACVXFVNC73fM4Wx-QqOxFPqKL2xG68simVjbHTjqtg=FjCkOaA@mail.gmail.com>
	<536B84EB.9070805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:64584 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaEHOAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 10:00:41 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so3265907veb.26
        for <linux-scsi@vger.kernel.org>; Thu, 08 May 2014 07:00:40 -0700 (PDT)
In-Reply-To: <536B84EB.9070805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>

On Thu, May 8, 2014 at 9:21 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 08/05/2014 14:55, Ming Lei ha scritto:
>
>> On Thu, May 8, 2014 at 8:17 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>
>>> Il 08/05/2014 12:44, Ming Lei ha scritto:
>>>>
>>>>
>>>> On Wed, 07 May 2014 18:43:45 +0200
>>>> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>
>>>>>
>>>>> Per-CPU spinlocks have bad scalability problems, especially if you're
>>>>> overcommitting.  Writing req_vq is not at all rare.
>>>>
>>>>
>>>>
>>>> OK, thought about it further, and I believe seqcount may
>>>> be a match for the case, could you take a look at below patch?
>>>>
>>>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>>>> index 13dd500..1adbad7 100644
>>>> --- a/drivers/scsi/virtio_scsi.c
>>>> +++ b/drivers/scsi/virtio_scsi.c
>>>> @@ -26,6 +26,7 @@
>>>>  #include <scsi/scsi_host.h>
>>>>  #include <scsi/scsi_device.h>
>>>>  #include <scsi/scsi_cmnd.h>
>>>> +#include <linux/seqlock.h>
>>>>
>>>>  #define VIRTIO_SCSI_MEMPOOL_SZ 64
>>>>  #define VIRTIO_SCSI_EVENT_LEN 8
>>>> @@ -73,18 +74,16 @@ struct virtio_scsi_vq {
>>>>   * queue, and also lets the driver optimize the IRQ affinity for the
>>>> virtqueues
>>>>   * (each virtqueue's affinity is set to the CPU that "owns" the queue).
>>>>   *
>>>> - * tgt_lock is held to serialize reading and writing req_vq. Reading
>>>> req_vq
>>>> - * could be done locklessly, but we do not do it yet.
>>>> + * tgt_seq is held to serialize reading and writing req_vq.
>>>>   *
>>>>   * Decrements of reqs are never concurrent with writes of req_vq:
>>>> before
>>>> the
>>>>   * decrement reqs will be != 0; after the decrement the virtqueue
>>>> completion
>>>>   * routine will not use the req_vq so it can be changed by a new
>>>> request.
>>>> - * Thus they can happen outside the tgt_lock, provided of course we
>>>> make
>>>> reqs
>>>> + * Thus they can happen outside the tgt_seq, provided of course we make
>>>> reqs
>>>>   * an atomic_t.
>>>>   */
>>>>  struct virtio_scsi_target_state {
>>>> -       /* This spinlock never held at the same time as vq_lock. */
>>>> -       spinlock_t tgt_lock;
>>>> +       seqcount_t tgt_seq;
>>>>
>>>>         /* Count of outstanding requests. */
>>>>         atomic_t reqs;
>>>> @@ -521,19 +520,33 @@ static struct virtio_scsi_vq
>>>> *virtscsi_pick_vq(struct virtio_scsi *vscsi,
>>>>         unsigned long flags;
>>>>         u32 queue_num;
>>>>
>>>> -       spin_lock_irqsave(&tgt->tgt_lock, flags);
>>>> +       local_irq_save(flags);
>>>> +       if (atomic_inc_return(&tgt->reqs) > 1) {
>>>> +               unsigned long seq;
>>>> +
>>>> +               do {
>>>> +                       seq = read_seqcount_begin(&tgt->tgt_seq);
>>>> +                       vq = tgt->req_vq;
>>>> +               } while (read_seqcount_retry(&tgt->tgt_seq, seq));
>>>> +       } else {
>>>> +               /* no writes can be concurrent because of atomic_t */
>>>> +               write_seqcount_begin(&tgt->tgt_seq);
>>>> +
>>>> +               /* keep previous req_vq if there is reader found */
>>>> +               if (unlikely(atomic_read(&tgt->reqs) > 1)) {
>>>> +                       vq = tgt->req_vq;
>>>> +                       goto unlock;
>>>> +               }
>>>>
>>>>                 queue_num = smp_processor_id();
>>>>                 while (unlikely(queue_num >= vscsi->num_queues))
>>>>                         queue_num -= vscsi->num_queues;
>>>>                 tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
>>>> + unlock:
>>>> +               write_seqcount_end(&tgt->tgt_seq);
>>>>         }
>>>> +       local_irq_restore(flags);
>>>
>>>
>>>
>>> I find this harder to think about than the double-check with a
>>> spin_lock_irqsave in the middle,
>>
>>
>> Sorry, could you explain it a bit? With seqcount, spin_lock
>> isn't needed, which should have been used for serialize
>> read and write.
>
>
> Yes, the spin lock is not needed but you are still potentially spinning on
> the read side.

IMO, anyway the spinning is required because a consistent req_vq is
needed, and the spinning only happens if there is in-progressing
writer, and it is very short surely.

>
>
>>> and the read side is not lock free anymore.
>>
>>
>> It is still lock free, because reader won't block reader, and
>> both read_seqcount_begin and read_seqcount_retry only
>> checks if there is writer in progress or being completed,
>> and the two helpers are very cheap.
>
>
> Lock-free has a precise meaning, which is that the system will progress
> regardless of scheduling.  In this case, readers won't progress while the
> writer is preempted between write_seqcount_begin and write_seqcount_end.

The writer won't be preempted, since local irq is disabled.

> My cmpxchg example had a lock-free read-side and a blocking write-side,
> while your code is the opposite, the write-side is lock-free and the
> read-side is blocking.

The read-side isn't blocking and it just waits for completion of writing,
and it should be inevitable for concurrent readers and writer, and
your cmpxchag example is still 'blocking' if there are readers, which
should be worse because it is easier to see concurrent readers.

Actually all blocking writers in your example are still readers because
only one writer does write req_vq, and others will degenerate to readers,
and it should be worse because all these writers need to spin on
spin_lock.

>
> I'm not sure which is better.  You can try both and the current code, and

Actually I just figure out the lockless solution for fun because comment
said readers should have been lockless, and don't have strong appetite
for merging this patch, :-)

> show that some benchmarks improve.  Otherwise, it's better to leave the
> current code.  Simple code is better that complex code that was never
> benchmarked (which is why in the end I and Wanlong Gao settled for the
> simple spinlock).

But I still like to do / see if the lockless readers can improve benchmarks.


Thanks,
-- 
Ming Lei
