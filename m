From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
Date: Wed, 07 May 2014 18:12:23 +0200
Message-ID: <536A5B67.8030502@redhat.com>
References: <1399473279-24871-1-git-send-email-tom.leiming@gmail.com>	<536A564F.3060605@redhat.com> <CACVXFVO_hg52+5U_njExbX1GtY1456HS_wsK0uyB-9fj+BFDpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaEGQMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 12:12:39 -0400
In-Reply-To: <CACVXFVO_hg52+5U_njExbX1GtY1456HS_wsK0uyB-9fj+BFDpw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 07/05/2014 18:03, Ming Lei ha scritto:
>>  *
>>  * - likewise, decrements of reqs only occur when reqs != 0.  If the decremented
>>  *   value is zero, the first CPU that enters virtscsi_queuecommand_multi will
>>  *   modify req_vq and the others will spin on tgt_lock.
>
> The fact should be obvious too,

Perhaps, but in your patch you're leaving a "Similarly" that doesn't 
apply anymore.

> >  * We do not try to read req_vq locklessly for simplicity, so tgt_lock is used
> >  * to serialize reads of req_vq too.
>
> Maybe it is better to just mention it isn't done yet, and maybe someone
> will figure out simple way to support lockless reading req_vq.

The one I sketched is not too hard.

Paolo
