From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio-scsi: two questions related with picking up queue
Date: Tue, 06 May 2014 15:17:15 +0200
Message-ID: <5368E0DB.5010000@redhat.com>
References: <CACVXFVNeBbJgA6h5n1Mt7vp7_Es67N5KEpZ0en4O+9GnD6wp+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaEFNRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2014 09:17:36 -0400
In-Reply-To: <CACVXFVNeBbJgA6h5n1Mt7vp7_Es67N5KEpZ0en4O+9GnD6wp+A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Asias He <asias@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 06/05/2014 11:26, Ming Lei ha scritto:
> Hi Paolo and All,
>
> One question is about ACCESS_ONCE() in virtscsi_pick_vq(),
> looks it needn't since both reading and writing tgt->req_vq holds
> tgt->tgt_lock.

You're right.  It should be possible to avoid the lock in 
virtscsi_pick_vq like this:

	value = atomic_read(&tgt->reqs);
retry:
	if (value != 0) {
		old_value = atomic_cmpxchg(&tgt->regs, value, value + 1)
		if (old_value != value) {
			value = old_value;
			goto retry;
		}

		smp_mb__after_atomic_cmpxchg(); // you get the idea :)
		vq = ACCESS_ONCE(tgt->req_vq);
	} else {
	        spin_lock_irqsave(&tgt->tgt_lock, flags);

		// tgt->reqs may not be 0 anymore, need to recheck
		value = atomic_read(&tgt->reqs);
		if (atomic_read(&tgt->reqs) != 0) {
		        spin_unlock_irqrestore(&tgt->tgt_lock, flags);
			goto retry;
		}

		// tgt->reqs now will remain fixed to 0.
		...
		tgt->req_vq = vq = ...;
		smp_wmb();
		atomic_set(&tgt->reqs, 1);
	        spin_unlock_irqrestore(&tgt->tgt_lock, flags);
	}

	return vq;

and then you would need the ACCESS_ONCE but I'm not sure it's worthwhile.

> Another one is about the comment in virtscsi_req_done(), which
> said smp_read_barrier_depends() is needed for avoiding
> out of order between reading req_vq and decreasing tgt->reqs.
> But if I understand correctly, in virtscsi_req_done(), req_vq is
> read from vscsi->req_vqs[vq->index - VIRTIO_SCSI_VQ_BASE],
> instead of tgt->req_vq, and the former won't change wrt.
> inc/dec tgt->reqs, so can the barrier be removed?

Right.  The comment is obsolete and dates to before vq->index existed.

Paolo

> Any comments about the above?
>
> Thanks,
>

