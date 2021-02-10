Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51522C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 22:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC0464EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 22:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhBJWg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 17:36:28 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44078 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbhBJWgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 17:36:11 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 8CBF62A94E;
        Wed, 10 Feb 2021 17:34:46 -0500 (EST)
Date:   Thu, 11 Feb 2021 09:34:51 +1100 (AEDT)
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
In-Reply-To: <13c414b9bd7940caa5e1df810356dcfd@hisilicon.com>
Message-ID: <221cb29-53a8-fd1-4232-360655f28f3@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <88d26bd86c314e5483ec596952054be7@hisilicon.com> <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au> <00c06b19e87a425fa3a4b6aaecc66d49@hisilicon.com> <9611728-3e7-3954-cfee-f3d3cf45df6@telegraphics.com.au>
 <13c414b9bd7940caa5e1df810356dcfd@hisilicon.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811774-653018509-1612996491=:23"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-653018509-1612996491=:23
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:
> >=20
> > > >
> > > > There is no warning from m68k builds. That's because=20
> > > > arch_irqs_disabled() returns true when the IPL is non-zero.
> > >
> > > So for m68k, the case is
> > > arch_irqs_disabled() is true, but interrupts can still come?
> > >
> > > Then it seems it is very confusing. If prioritized interrupts can=20
> > > still come while arch_irqs_disabled() is true,
> >=20
> > Yes, on m68k CPUs, an IRQ having a priority level higher than the=20
> > present priority mask will get serviced.
> >=20
> > Non-Maskable Interrupt (NMI) is not subject to this rule and gets=20
> > serviced regardless.
> >=20
> > > how could spin_lock_irqsave() block the prioritized interrupts?
> >=20
> > It raises the the mask level to 7. Again, please see=20
> > arch/m68k/include/asm/irqflags.h
>=20
> Hi Finn,
> Thanks for your explanation again.
>=20
> TBH, that is why m68k is so confusing. irqs_disabled() on m68k should=20
> just reflect the status of all interrupts have been disabled except NMI.
>=20
> irqs_disabled() should be consistent with the calling of APIs such as=20
> local_irq_disable, local_irq_save, spin_lock_irqsave etc.
>=20

When irqs_disabled() returns true, we cannot infer that=20
arch_local_irq_disable() was called. But I have not yet found driver code=
=20
or core kernel code attempting that inference.

> >=20
> > > Isn't arch_irqs_disabled() a status reflection of irq disable API?
> > >
> >=20
> > Why not?
>=20
> If so, arch_irqs_disabled() should mean all interrupts have been masked=
=20
> except NMI as NMI is unmaskable.
>=20

Can you support that claim with a reference to core kernel code or=20
documentation? (If some arch code agrees with you, that's neither here nor=
=20
there.)

> >=20
> > Are all interrupts (including NMI) masked whenever=20
> > arch_irqs_disabled() returns true on your platforms?
>=20
> On my platform, once irqs_disabled() is true, all interrupts are masked=
=20
> except NMI. NMI just ignore spin_lock_irqsave or local_irq_disable.
>=20
> On ARM64, we also have high-priority interrupts, but they are running as
> PESUDO_NMI:
> https://lwn.net/Articles/755906/
>=20

A glance at the ARM GIC specification suggests that your hardware works=20
much like 68000 hardware.

   When enabled, a CPU interface takes the highest priority pending=20
   interrupt for its connected processor and determines whether the=20
   interrupt has sufficient priority for it to signal the interrupt=20
   request to the processor. [...]

   When the processor acknowledges the interrupt at the CPU interface, the=
=20
   Distributor changes the status of the interrupt from pending to either=
=20
   active, or active and pending. At this point the CPU interface can=20
   signal another interrupt to the processor, to preempt interrupts that=20
   are active on the processor. If there is no pending interrupt with=20
   sufficient priority for signaling to the processor, the interface=20
   deasserts the interrupt request signal to the processor.

https://developer.arm.com/documentation/ihi0048/b/

Have you considered that Linux/arm might benefit if it could fully exploit=
=20
hardware features already available, such as the interrupt priority=20
masking feature in the GIC in existing arm systems?

> On m68k, it seems you mean=EF=BC=9A
> irq_disabled() is true, but high-priority interrupts can still come;
> local_irq_disable() can disable high-priority interrupts, and at that
> time, irq_disabled() is also true.
>=20
> TBH, this is wrong and confusing on m68k.
>=20

Like you, I was surprised when I learned about it. But that doesn't mean=20
it's wrong. The fact that it works should tell you something.

Things could always be made simpler. But discarding features isn't=20
necessarily an improvement.

> >=20
> > > Thanks
> > > Barry
> > >
>=20
> Thanks
> Barry
>=20
---1463811774-653018509-1612996491=:23--
