Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03671C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 01:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A388D6146D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 01:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBKBMa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 20:12:30 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48776 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBKBM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 20:12:28 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id DAF3F2A81C;
        Wed, 10 Feb 2021 20:11:43 -0500 (EST)
Date:   Thu, 11 Feb 2021 12:11:49 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
cc:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
 for SCSI drivers
In-Reply-To: <3ec7cb32aa754a59b894d048873132cf@hisilicon.com>
Message-ID: <9d248ea6-f861-850-ba71-ac2cdd5596ff@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <88d26bd86c314e5483ec596952054be7@hisilicon.com> <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au> <00c06b19e87a425fa3a4b6aaecc66d49@hisilicon.com> <9611728-3e7-3954-cfee-f3d3cf45df6@telegraphics.com.au> <13c414b9bd7940caa5e1df810356dcfd@hisilicon.com>
 <221cb29-53a8-fd1-4232-360655f28f3@telegraphics.com.au> <3ec7cb32aa754a59b894d048873132cf@hisilicon.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811774-1889743738-1613005844=:6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-1889743738-1613005844=:6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:
> >=20
> > > > On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:
> > > >
> > > > > > There is no warning from m68k builds. That's because=20
> > > > > > arch_irqs_disabled() returns true when the IPL is non-zero.
> > > > >
> > > > > So for m68k, the case is arch_irqs_disabled() is true, but=20
> > > > > interrupts can still come?
> > > > >
> > > > > Then it seems it is very confusing. If prioritized interrupts=20
> > > > > can still come while arch_irqs_disabled() is true,
> > > >
> > > > Yes, on m68k CPUs, an IRQ having a priority level higher than the=
=20
> > > > present priority mask will get serviced.
> > > >
> > > > Non-Maskable Interrupt (NMI) is not subject to this rule and gets=
=20
> > > > serviced regardless.
> > > >
> > > > > how could spin_lock_irqsave() block the prioritized interrupts?
> > > >
> > > > It raises the the mask level to 7. Again, please see=20
> > > > arch/m68k/include/asm/irqflags.h
> > >
> > > Hi Finn,
> > > Thanks for your explanation again.
> > >
> > > TBH, that is why m68k is so confusing. irqs_disabled() on m68k=20
> > > should just reflect the status of all interrupts have been disabled=
=20
> > > except NMI.
> > >
> > > irqs_disabled() should be consistent with the calling of APIs such=20
> > > as local_irq_disable, local_irq_save, spin_lock_irqsave etc.
> > >
> >=20
> > When irqs_disabled() returns true, we cannot infer that=20
> > arch_local_irq_disable() was called. But I have not yet found driver=20
> > code or core kernel code attempting that inference.
> >=20
> > > >
> > > > > Isn't arch_irqs_disabled() a status reflection of irq disable=20
> > > > > API?
> > > > >
> > > >
> > > > Why not?
> > >
> > > If so, arch_irqs_disabled() should mean all interrupts have been=20
> > > masked except NMI as NMI is unmaskable.
> > >
> >=20
> > Can you support that claim with a reference to core kernel code or=20
> > documentation? (If some arch code agrees with you, that's neither here=
=20
> > nor there.)
>=20
> I think those links I share you have supported this. Just you don't=20
> believe :-)
>=20

Your links show that the distinction between fast and slow handlers was=20
removed. Your links don't support your claim that "arch_irqs_disabled()=20
should mean all interrupts have been masked". Where is the code that makes=
=20
that inference? Where is the documentation that supports your claim?

> >=20
> > > >
> > > > Are all interrupts (including NMI) masked whenever=20
> > > > arch_irqs_disabled() returns true on your platforms?
> > >
> > > On my platform, once irqs_disabled() is true, all interrupts are=20
> > > masked except NMI. NMI just ignore spin_lock_irqsave or=20
> > > local_irq_disable.
> > >
> > > On ARM64, we also have high-priority interrupts, but they are=20
> > > running as PESUDO_NMI:
> > > https://lwn.net/Articles/755906/
> > >
> >=20
> > A glance at the ARM GIC specification suggests that your hardware=20
> > works much like 68000 hardware.
> >=20
> >    When enabled, a CPU interface takes the highest priority pending=20
> >    interrupt for its connected processor and determines whether the=20
> >    interrupt has sufficient priority for it to signal the interrupt=20
> >    request to the processor. [...]
> >=20
> >    When the processor acknowledges the interrupt at the CPU interface,=
=20
> >    the Distributor changes the status of the interrupt from pending to=
=20
> >    either active, or active and pending. At this point the CPU=20
> >    interface can signal another interrupt to the processor, to preempt=
=20
> >    interrupts that are active on the processor. If there is no pending=
=20
> >    interrupt with sufficient priority for signaling to the processor,=
=20
> >    the interface deasserts the interrupt request signal to the=20
> >    processor.
> >=20
> > https://developer.arm.com/documentation/ihi0048/b/
> >=20
> > Have you considered that Linux/arm might benefit if it could fully=20
> > exploit hardware features already available, such as the interrupt=20
> > priority masking feature in the GIC in existing arm systems?
>=20
> I guess no:-) there are only two levels: IRQ and NMI. Injecting a=20
> high-prio IRQ level between them makes no sense.
>=20
> To me, arm64's design is quite clear and has no any confusion.
>=20

Are you saying that the ARM64 hardware design is confusing because it=20
implements a priority mask, and that's why you had to simplify it with a=20
pseudo-nmi scheme in software?

> >=20
> > > On m68k, it seems you mean=EF=BC=9A
> > > irq_disabled() is true, but high-priority interrupts can still come;
> > > local_irq_disable() can disable high-priority interrupts, and at that
> > > time, irq_disabled() is also true.
> > >
> > > TBH, this is wrong and confusing on m68k.
> > >
> >=20
> > Like you, I was surprised when I learned about it. But that doesn't mea=
n
> > it's wrong. The fact that it works should tell you something.
> >=20
>=20
> The fact is that m68k lets arch_irq_disabled() return true to pretend=20
> all IRQs are disabled while high-priority IRQ is still open, thus "pass"=
=20
> all sanitizing check in genirq and kernel core.
>=20

The fact is that m68k has arch_irq_disabled() return false when all IRQs=20
are enabled. So there is no bug.

> > Things could always be made simpler. But discarding features isn't=20
> > necessarily an improvement.
>=20
> This feature could be used by calling local_irq_enable_in_hardirq() in=20
> those IRQ handlers who hope high-priority interrupts to preempt it for a=
=20
> while.
>=20

So, if one handler is sensitive to interrupt latency, all other handlers=20
should be modified? I don't think that's workable.

In anycase, what you're describing is a completely different nested=20
interrupt scheme that would defeat the priority level mechanism that the=20
hardware provides us with.

> It shouldn't hide somewhere and make confusion.
>=20

The problem is hiding so well that no-one has found it! I say it doesn't=20
exist.

> On the other hand, those who care about realtime should use threaded IRQ=
=20
> and let IRQ threads preempt each other.
>=20

Yes. And those threads also have priority levels.

> Thanks
> Barry
>=20
>=20
---1463811774-1889743738-1613005844=:6--
