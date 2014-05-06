From: Ming Lei <tom.leiming@gmail.com>
Subject: virtio-scsi: two questions related with picking up queue
Date: Tue, 6 May 2014 17:26:15 +0800
Message-ID: <CACVXFVNeBbJgA6h5n1Mt7vp7_Es67N5KEpZ0en4O+9GnD6wp+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:41515 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaEFJ0Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2014 05:26:16 -0400
Received: by mail-ve0-f182.google.com with SMTP id sa20so4038572veb.27
        for <linux-scsi@vger.kernel.org>; Tue, 06 May 2014 02:26:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Asias He <asias@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>

Hi Paolo and All,

One question is about ACCESS_ONCE() in virtscsi_pick_vq(),
looks it needn't since both reading and writing tgt->req_vq holds
tgt->tgt_lock.

Another one is about the comment in virtscsi_req_done(), which
said smp_read_barrier_depends() is needed for avoiding
out of order between reading req_vq and decreasing tgt->reqs.
But if I understand correctly, in virtscsi_req_done(), req_vq is
read from vscsi->req_vqs[vq->index - VIRTIO_SCSI_VQ_BASE],
instead of tgt->req_vq, and the former won't change wrt.
inc/dec tgt->reqs, so can the barrier be removed?

Any comments about the above?

Thanks,
-- 
Ming Lei
