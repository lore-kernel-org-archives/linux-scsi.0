From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio-scsi: two questions related with picking up queue
Date: Wed, 07 May 2014 09:10:29 +0200
Message-ID: <5369DC65.5030207@redhat.com>
References: <CACVXFVNeBbJgA6h5n1Mt7vp7_Es67N5KEpZ0en4O+9GnD6wp+A@mail.gmail.com>	<5368E0DB.5010000@redhat.com> <CACVXFVMfrfMdpM20SCcxnVZXDUuzAhtLATm9MX_Oq5p36bagUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34175 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaEGHKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 03:10:35 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so369033eek.6
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2014 00:10:34 -0700 (PDT)
In-Reply-To: <CACVXFVMfrfMdpM20SCcxnVZXDUuzAhtLATm9MX_Oq5p36bagUg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Asias He <asias@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 07/05/2014 03:07, Ming Lei ha scritto:
> Hi Paolo,
>
> On Tue, May 6, 2014 at 9:17 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Il 06/05/2014 11:26, Ming Lei ha scritto:
>>
>>> Hi Paolo and All,
>>>
>>> One question is about ACCESS_ONCE() in virtscsi_pick_vq(),
>>> looks it needn't since both reading and writing tgt->req_vq holds
>>> tgt->tgt_lock.
>>
>>
>> You're right.  It should be possible to avoid the lock in virtscsi_pick_vq
>> like this:
>>
>>         value = atomic_read(&tgt->reqs);
>
> I am wondering if atomic_read() is OK because  atomic_read()
> should be treated as a simple C statement, and it may not reflect
> the latest value of tgt->reqs.

It would be caught by cmpxchg below.

>> retry:
>>         if (value != 0) {
>>                 old_value = atomic_cmpxchg(&tgt->regs, value, value + 1)
>>                 if (old_value != value) {
>
> Maybe ' if (old_value != value && !old_value) ' is a bit better.

No, because if you have failed the cmpxchg you haven't incremented 
tgt->reqs.

>>                         value = old_value;
>>                         goto retry;
>>                 }
>>
>>                 vq = ACCESS_ONCE(tgt->req_vq);
>>         } else {
>>                 spin_lock_irqsave(&tgt->tgt_lock, flags);
>>
>>                 // tgt->reqs may not be 0 anymore, need to recheck
>>                 value = atomic_read(&tgt->reqs);
>>                 if (atomic_read(&tgt->reqs) != 0) {
>>                         spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>>                         goto retry;
>>                 }
>
> Same with above, if atomic_read() still returns zero even
> after it is increased in read path from another CPU, then
> an obsolete vq pointer might be seen in the read path.

If I understand you correctly, then the CPUs wouldn't be cache-coherent. 
  You would have bigger problems.

>>
>>                 // tgt->reqs now will remain fixed to 0.
>>                 ...
>>                 tgt->req_vq = vq = ...;
>>                 smp_wmb();
>>                 atomic_set(&tgt->reqs, 1);
>>                 spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>>         }
>>
>>         return vq;
>>
>> and then you would need the ACCESS_ONCE but I'm not sure it's worthwhile.
>>
>
> Yes, I agree, :-)
>
>>
>>> Another one is about the comment in virtscsi_req_done(), which
>>> said smp_read_barrier_depends() is needed for avoiding
>>> out of order between reading req_vq and decreasing tgt->reqs.
>>> But if I understand correctly, in virtscsi_req_done(), req_vq is
>>> read from vscsi->req_vqs[vq->index - VIRTIO_SCSI_VQ_BASE],
>>> instead of tgt->req_vq, and the former won't change wrt.
>>> inc/dec tgt->reqs, so can the barrier be removed?
>>
>>
>> Right.  The comment is obsolete and dates to before vq->index existed.
>
> OK, I will cook a patch to remove the barrier and cleanup the comment.

Thanks.  Please remove the ACCESS_ONCE too.

Paolo

