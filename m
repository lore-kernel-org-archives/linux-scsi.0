From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
Date: Thu, 8 May 2014 00:03:04 +0800
Message-ID: <CACVXFVO_hg52+5U_njExbX1GtY1456HS_wsK0uyB-9fj+BFDpw@mail.gmail.com>
References: <1399473279-24871-1-git-send-email-tom.leiming@gmail.com>
	<536A564F.3060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:44613 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaEGQDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 12:03:07 -0400
Received: by mail-ve0-f173.google.com with SMTP id pa12so1566959veb.32
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2014 09:03:05 -0700 (PDT)
In-Reply-To: <536A564F.3060605@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

On Wed, May 7, 2014 at 11:50 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 07/05/2014 16:34, Ming Lei ha scritto:
>>   *
>> - * An interesting effect of this policy is that only writes to req_vq need to
>> - * take the tgt_lock.  Read can be done outside the lock because:
>> - *
>> - * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
>> - *   In that case, no other CPU is reading req_vq: even if they were in
>> - *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
>> - *
>> - * - reads of req_vq only occur when the target is not idle (reqs != 0).
>> - *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.
>> + * tgt_lock is held to serialize reading and writing req_vq. Reading req_vq
>> + * could be done locklessly, but we do not do it yet.
>>   *
>>   * Similarly, decrements of reqs are never concurrent with writes of req_vq.
>>   * Thus they can happen outside the tgt_lock, provided of course we make reqs
>
> The part you deleted explains _why_ decrements of reqs are never
> concurrent with writes of req_vq.  Perhaps:

The below part might not need, since the 1st paragraph has
explained the basic principle, also looks current virtscsi_pick_vq()
isn't very difficult to understand.

>
>  * An interesting effect of this policy is that only increments to reqs and writes
>  * to req_vq need to take the tgt_lock.  Reads of req_vq and decrements or req_vq
>  * can be done outside the lock because:
>  *
>  * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
>  *   In that case, no other CPU is reading req_vq: even if they were in
>  *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
>  *
>  * - reads of req_vq only occur when the target is not idle (reqs != 0).
>  *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.

The above two parts should be very clear from current code in
virtscsi_pick_vq(), so I am not sure if we need the description.

>  *
>  * - likewise, decrements of reqs only occur when reqs != 0.  If the decremented
>  *   value is zero, the first CPU that enters virtscsi_queuecommand_multi will
>  *   modify req_vq and the others will spin on tgt_lock.

The fact should be obvious too, :-)

>  *
>  * We do not try to read req_vq locklessly for simplicity, so tgt_lock is used
>  * to serialize reads of req_vq too.

Maybe it is better to just mention it isn't done yet, and maybe someone
will figure out simple way to support lockless reading req_vq.


Thanks,
-- 
Ming Lei
