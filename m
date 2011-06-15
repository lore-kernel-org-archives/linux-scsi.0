From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Wed, 15 Jun 2011 11:53:11 -0700
Message-ID: <BANLkTimp4SzKkLK=3wK5KMphPRRhVGoMow@mail.gmail.com>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
 <1308157596.20109.28.camel@haakon2.linux-iscsi.org> <BANLkTimM-=fGphT_okWuMYY1LgDk=XQzow@mail.gmail.com>
 <1308158714.20109.33.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51923 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab1FOSxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 14:53:31 -0400
In-Reply-To: <1308158714.20109.33.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:25 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Actually, it's only two places: =A0core_tmr_release_req() and
> core_tmr_lun_reset()
>
>> Presumably se_tmr_lock is taken from process context sometimes?
>> So we would need to convert all those spin_lock()s to spin_lock_irq(=
)
>> (or irqsave I guess).
>
> Correct, both of the above are only every called from process context=
,
> so a simple conversion to spin_lock_irq() for these two, and
> spin_lock_irqsave() in transport_lookup_tmr_lun() should by sufficent=
=2E.

Looking at this...

core_tmr_lun_reset() uses _irqsave locking for cmd->t_state_lock...
is that not needed, or can it actually be called from a context where
we can't just use spin_lock_irq?  (eg because some caller might have
already disabled interrupts)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
