From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
Date: Wed, 07 May 2014 17:50:39 +0200
Message-ID: <536A564F.3060605@redhat.com>
References: <1399473279-24871-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbaEGPvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 11:51:04 -0400
In-Reply-To: <1399473279-24871-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 07/05/2014 16:34, Ming Lei ha scritto:
>   *
> - * An interesting effect of this policy is that only writes to req_vq need to
> - * take the tgt_lock.  Read can be done outside the lock because:
> - *
> - * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
> - *   In that case, no other CPU is reading req_vq: even if they were in
> - *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
> - *
> - * - reads of req_vq only occur when the target is not idle (reqs != 0).
> - *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.
> + * tgt_lock is held to serialize reading and writing req_vq. Reading req_vq
> + * could be done locklessly, but we do not do it yet.
>   *
>   * Similarly, decrements of reqs are never concurrent with writes of req_vq.
>   * Thus they can happen outside the tgt_lock, provided of course we make reqs

The part you deleted explains _why_ decrements of reqs are never 
concurrent with writes of req_vq.  Perhaps:

 * An interesting effect of this policy is that only increments to reqs and writes
 * to req_vq need to take the tgt_lock.  Reads of req_vq and decrements or req_vq
 * can be done outside the lock because:
 *
 * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
 *   In that case, no other CPU is reading req_vq: even if they were in
 *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
 *
 * - reads of req_vq only occur when the target is not idle (reqs != 0).
 *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.
 *
 * - likewise, decrements of reqs only occur when reqs != 0.  If the decremented
 *   value is zero, the first CPU that enters virtscsi_queuecommand_multi will
 *   modify req_vq and the others will spin on tgt_lock.
 *
 * We do not try to read req_vq locklessly for simplicity, so tgt_lock is used
 * to serialize reads of req_vq too.

Paolo
