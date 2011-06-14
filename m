From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Tue, 14 Jun 2011 08:58:57 -0700
Message-ID: <BANLkTin9U47ej2eR2ns7-=T-QHrRw=-t_Q@mail.gmail.com>
References: <1308023045-5257-1-git-send-email-roland@kernel.org> <20110614081259.GA10379@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52207 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1FNP7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2011 11:59:19 -0400
In-Reply-To: <20110614081259.GA10379@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, Jun 14, 2011 at 1:12 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
>> transport_lookup_cmd_lun() may be called from interrupt context (eg
>> tcm_loop_allocate_core_cmd() calls it, and it has a comment that say=
s,
>> "Can be called from interrupt context"), so it needs to use
>> spin_lock_irqsave() instead of spin_lock_irq() to avoid enabling
>> interrupts at the wrong time.

> It currently is, but I think we'd better be off stopping to call it f=
rom
> IRQ context. =A0Soon after we offload the work to thread context anyw=
ay.
> By moving the point of offloading a little earlier we can simply the
> calling conventions a lot, and keep the amount of code that needs
> IRQ-safe locking minimal.

=46air enough... however that seems like a much more major project,
as eg the qla2xxx code does a fair bit from interrupt context.

Also it seems even if we are running from thread context it would
be legitimate for a target driver to do

    spin_lock_irq(&internal_target_lock);
    ...
    transport_lookup_cmd_lun();
    ...
    spin_unlock_irq

and so transport_lookup_cmd_lun() shouldn't be reenabling IRQs
unconditionally.

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
