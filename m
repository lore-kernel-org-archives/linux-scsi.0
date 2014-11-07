From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] tmscsim: fix spinlock usage in isr
Date: Fri, 07 Nov 2014 14:16:01 +0100
Message-ID: <545CC611.6050703@suse.de>
References: <1415364584-28951-1-git-send-email-hare@suse.de> <1415365740.27625.14.camel@jarvis.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaKGNQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 08:16:02 -0500
In-Reply-To: <1415365740.27625.14.camel@jarvis.quadriga.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>

On 11/07/2014 02:09 PM, James Bottomley wrote:
> On Fri, 2014-11-07 at 13:49 +0100, Hannes Reinecke wrote:
>> Loading the tmscsim driver would result in kernel splat as
>> the interrupt service routine would only use spin_lock_irq,
>> not spin_lock_irqsave.
>=20
> I don't understand the reasoning ... what kernel splat?
>

This one:
kernel: [   13.748186] ------------[ cut here ]------------
kernel: [   13.748195] WARNING: CPU: 0 PID: 214 at
kernel/irq/handle.c:147 handle_irq_event_percpu+0x18b/0x1a0()
kernel: [   13.748200] irq 20 handler do_DC390_Interrupt+0x0/0x9d0
[tmscsim] enabled interrupts
kernel: [   13.748214] Modules linked in: crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
glue_helper bochs_drm(+) ttm ablk_helper drm_kms_helper pvpanic
pcspkr cryptd drm tmscsim(+) serio_raw i2c_i801 syscopyarea
sysfillrect lpc_ich mfd_core igbvf sysimgblt 8250_fintek processor
thermal_sys button dm_mod efivarfs sr_mod cdrom btrfs xor raid6_pq
sd_mod crc32c_intel ahci libahci libata megaraid_sas floppy sg autofs4
kernel: [   13.748216] CPU: 0 PID: 214 Comm: kworker/0:1H Not
tainted 3.18.0-rc2-default+ #104

> Linux runs interrupt routines with interrupts enabled, so you know th=
e
> irq state on entry; that's why you can do spin_lock_irq ... because y=
ou
> know it was enabled before and now it's disabled.  It only saves a
> couple of instructions, so there's no real point using a different
> pattern, but there's no reason to change it either, because it's
> harmless when done correctly.
>=20

Well, apparently it's not done correctly, then :-)
I must admit is got the 'solution' off google, so I cannot vouch for
the correctness here. The only thing I know is that with switching
to the irqsave/irqrestore version the warning went away.

>> And while we're at it there is not need to release the
>> spin lock when calling udelay; it's implemented via a
>> processor counter, not via interrupts.
>=20
> That looks a bit incorrect:  The potential timeout is jiffies + HZ, i=
=2Ee.
> up to 1 second of udelay.  If it didn't drop and retake the lock (and
> enable interrupts), it would spin with interrupts disabled for up to =
a
> second ... with all the badness that would result from that.
>=20
Hmm. I could put them back in, but for completeness one would have
to pass the irq flags taken in the outer routine to avoid lock
imbalancing.

Unless we manage to figure out the real reason for the above kernel
splat, in which case we can leave things in.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
