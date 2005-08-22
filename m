From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Mon, 22 Aug 2005 12:33:45 -0400
Message-ID: <4309FE69.3020905@adaptec.com>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>	<1124680540.5068.37.camel@mulgrave> <20050821205214.2a75b3cf.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:51177 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751096AbVHVU4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 16:56:30 -0400
In-Reply-To: <20050821205214.2a75b3cf.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, jim.houston@ccur.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davej@redhat.com, jgarzik@pobox.com

On 08/21/05 23:52, Andrew Morton wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
>>Since you won't post the usage code, just answer this: how does what
>> you're doing with idr differ from its originally designed consumer: the
>> posix timers which also do the idr_remove() in IRQ context?
> 
> 
> erp.  posix_timers has its own irq-safe lock, so we're doing extra,
> unneeded locking in that code path.
> 
> I think providing locking inside idr.c was always a mistake - generally we
> rely on caller-provided locking for such things.

Ahhh, *THANK YOU* Andrew for your common sense!

Yes, James is unaware that 3 out of the 4 major entrances into IDR
_must_ be synchronized with respect to each other, depending
on your context (irq or not) *and* that that synchronization is
external.  If *one* of those 3 is done in IRQ context, then
all three should be, since they should be synchnornized wrt
each other.

Only idr_pre_get() should not be called from IRQ context.

*BUT* since idr_pre_get() and those other 3 may end up
in the same _internally_ locked region, _that_ internally
locked region should have the lowest common denominator lock,
_because_ of the other 3 which have to be syncrhonised wrt each other.

It is _this_ reason that the internal locking of IDR should use
use the lowest common denominator because of the context of
those other 3 which the _caller_ is responsible for synchronizing
depending on the caller's context.

Now James can we move on, please.

Andrew, please integrate this patch.

Thanks,
	Luben

