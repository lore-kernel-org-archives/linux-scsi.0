From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v1] virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
Date: Thu, 8 May 2014 15:25:04 +0800
Message-ID: <CACVXFVN8BW=ADkDHTkkZoyWpf+6r+Ey=Q2-2s4SNLqjWOBMxmg@mail.gmail.com>
References: <1399526692-3417-1-git-send-email-tom.leiming@gmail.com>
	<536B2CAC.50203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:35218 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaEHHZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 03:25:05 -0400
Received: by mail-vc0-f178.google.com with SMTP id hu19so2761793vcb.37
        for <linux-scsi@vger.kernel.org>; Thu, 08 May 2014 00:25:05 -0700 (PDT)
In-Reply-To: <536B2CAC.50203@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

On Thu, May 8, 2014 at 3:05 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:

>
>
> Decrements of reqs are never concurrent with writes of req_vq: before the
> decrement reqs will be != 0; after the decrement the virtqueue completion
> routine will not use the req_vq so it can be changed by a new request.  Thus
> they can happen outside the tgt_lock, provided of course we make reqs an
> atomic_t.

OK, will take above comment in V2.

> Otherwise looks good.

Thanks for your review.

Thanks,
-- 
Ming Lei
