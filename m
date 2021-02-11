Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29289C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7A6064E4A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBKX6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:58:47 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52920 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBKX6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:58:42 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id A43F92ADA4;
        Thu, 11 Feb 2021 18:57:57 -0500 (EST)
Date:   Fri, 12 Feb 2021 10:58:04 +1100 (AEDT)
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
In-Reply-To: <4646dd5cb26d4e1195951228c46fbff6@hisilicon.com>
Message-ID: <8296cd-85d0-6b2e-3291-9a73db553ad8@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <88d26bd86c314e5483ec596952054be7@hisilicon.com> <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au> <00c06b19e87a425fa3a4b6aaecc66d49@hisilicon.com> <9611728-3e7-3954-cfee-f3d3cf45df6@telegraphics.com.au> <13c414b9bd7940caa5e1df810356dcfd@hisilicon.com>
 <221cb29-53a8-fd1-4232-360655f28f3@telegraphics.com.au> <3ec7cb32aa754a59b894d048873132cf@hisilicon.com> <9d248ea6-f861-850-ba71-ac2cdd5596ff@telegraphics.com.au> <4646dd5cb26d4e1195951228c46fbff6@hisilicon.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811774-827468299-1613084310=:6"
Content-ID: <78e7903f-6cc5-33d7-349a-13c12c8ea@telegraphics.com.au>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-827468299-1613084310=:6
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <989b9068-7be-9a98-58d-73ad484bb9c0@telegraphics.com.au>

On Thu, 11 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:
> >=20
> > > > On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:
> > > >
> > > > > TBH, that is why m68k is so confusing. irqs_disabled() on m68k=20
> > > > > should just reflect the status of all interrupts have been=20
> > > > > disabled except NMI.
> > > > >
> > > > > irqs_disabled() should be consistent with the calling of APIs=20
> > > > > such as local_irq_disable, local_irq_save, spin_lock_irqsave=20
> > > > > etc.
> > > > >
> > > >
> > > > When irqs_disabled() returns true, we cannot infer that=20
> > > > arch_local_irq_disable() was called. But I have not yet found=20
> > > > driver code or core kernel code attempting that inference.
> > > >
> > > > > >
> > > > > > > Isn't arch_irqs_disabled() a status reflection of irq=20
> > > > > > > disable API?
> > > > > > >
> > > > > >
> > > > > > Why not?
> > > > >
> > > > > If so, arch_irqs_disabled() should mean all interrupts have been=
=20
> > > > > masked except NMI as NMI is unmaskable.
> > > > >
> > > >
> > > > Can you support that claim with a reference to core kernel code or=
=20
> > > > documentation? (If some arch code agrees with you, that's neither=
=20
> > > > here nor there.)
> > >
> > > I think those links I share you have supported this. Just you don't=
=20
> > > believe :-)
> > >
> >=20
> > Your links show that the distinction between fast and slow handlers=20
> > was removed. Your links don't support your claim that=20
> > "arch_irqs_disabled() should mean all interrupts have been masked".=20
> > Where is the code that makes that inference? Where is the=20
> > documentation that supports your claim?
>=20
> (1)
> https://lwn.net/Articles/380931/
> Looking at all these worries, one might well wonder if a system which=20
> *disabled interrupts for all handlers* would function well at all. So it=
=20
> is interesting to note one thing: any system which has the lockdep=20
> locking checker enabled has been running all handlers that way for some=
=20
> years now. Many developers and testers run lockdep-enabled kernels, and=
=20
> they are available for some of the more adventurous distributions=20
> (Rawhide, for example) as well. So we have quite a bit of test coverage=
=20
> for this mode of operation already.
>=20

IIUC, your claim is that CONFIG_LOCKDEP involves code that contains the=20
inference, "arch_irqs_disabled() means all interrupts have been masked".

Unfortunately, m68k lacks CONFIG_LOCKDEP support so I can't easily confirm=
=20
this. I suppose there may be other architectures that support both LOCKDEP=
=20
and nested interrupts (?)

Anyway, if you would point to the code that contains said inference, that=
=20
would help a lot.

> (2)
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Db738a50a
>=20
> "We run all handlers *with interrupts disabled* and expect them not to
> enable them. Warn when we catch one who does."
>=20

Again, you don't see that warning because irqs_disabled() correctly=20
returns true. You can confirm this fact in QEMU or Aranym if you are=20
interested.

> (3)=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3De58aa3d2d0cc
> genirq: Run irq handlers *with interrupts disabled*
>=20
> Running interrupt handlers with interrupts enabled can cause stack=20
> overflows. That has been observed with multiqueue NICs delivering all=20
> their interrupts to a single core. We might band aid that somehow by=20
> checking the interrupt stacks, but the real safe fix is to *run the irq=
=20
> handlers with interrupts disabled*.
>=20

Again, the stack overflow issue is not applicable. 68000 uses a priority=20
mask, like ARM GIC. So there's no arbitrary nesting of interrupt handlers.=
=20

In practice stack overflows simply don't occur on m68k. Please do try it.

>=20
> All these documents say we are running irq handler with interrupts
> disabled. but it seems you think high-prio interrupts don't belong
> to "interrupts" in those documents :-)
>=20
> that is why we can't get agreement. I think "interrupts" mean all except=
=20
> NMI in these documents, but you insist high-prio IRQ is an exception.
>=20

We can't get agreement because you seek to remove functionality without=20
justification.

> > > >
> > > > > >
> > > > > > Are all interrupts (including NMI) masked whenever=20
> > > > > > arch_irqs_disabled() returns true on your platforms?
> > > > >
> > > > > On my platform, once irqs_disabled() is true, all interrupts are=
=20
> > > > > masked except NMI. NMI just ignore spin_lock_irqsave or=20
> > > > > local_irq_disable.
> > > > >
> > > > > On ARM64, we also have high-priority interrupts, but they are
> > > > > running as PESUDO_NMI:
> > > > > https://lwn.net/Articles/755906/
> > > > >
> > > >
> > > > A glance at the ARM GIC specification suggests that your hardware=
=20
> > > > works much like 68000 hardware.
> > > >
> > > >    When enabled, a CPU interface takes the highest priority=20
> > > >    pending interrupt for its connected processor and determines=20
> > > >    whether the interrupt has sufficient priority for it to signal=
=20
> > > >    the interrupt request to the processor. [...]
> > > >
> > > >    When the processor acknowledges the interrupt at the CPU=20
> > > >    interface, the Distributor changes the status of the interrupt=
=20
> > > >    from pending to either active, or active and pending. At this=20
> > > >    point the CPU interface can signal another interrupt to the=20
> > > >    processor, to preempt interrupts that are active on the=20
> > > >    processor. If there is no pending interrupt with sufficient=20
> > > >    priority for signaling to the processor, the interface=20
> > > >    deasserts the interrupt request signal to the processor.
> > > >
> > > > https://developer.arm.com/documentation/ihi0048/b/
> > > >
> > > > Have you considered that Linux/arm might benefit if it could fully=
=20
> > > > exploit hardware features already available, such as the interrupt=
=20
> > > > priority masking feature in the GIC in existing arm systems?
> > >
> > > I guess no:-) there are only two levels: IRQ and NMI. Injecting a=20
> > > high-prio IRQ level between them makes no sense.
> > >
> > > To me, arm64's design is quite clear and has no any confusion.
> > >
> >=20
> > Are you saying that the ARM64 hardware design is confusing because it=
=20
> > implements a priority mask, and that's why you had to simplify it with=
=20
> > a pseudo-nmi scheme in software?
>=20
> No, I was not saying this. I think both m68k and arm64 have good=20
> hardware design. Just Linux's implementation is running irq-handlers=20
> with interrupts disabled. So ARM64's pseudo-nmi is adapted to Linux=20
> better.
>=20

So, a platform should do what all the other platforms do because to=20
deviate would be too dangerous?

> > > >
> > > > > On m68k, it seems you mean=EF=BC=9A
> > > > > irq_disabled() is true, but high-priority interrupts can still=20
> > > > > come; local_irq_disable() can disable high-priority interrupts,=
=20
> > > > > and at that time, irq_disabled() is also true.
> > > > >
> > > > > TBH, this is wrong and confusing on m68k.
> > > > >
> > > >
> > > > Like you, I was surprised when I learned about it. But that=20
> > > > doesn't mean it's wrong. The fact that it works should tell you=20
> > > > something.
> > > >
> > >
> > > The fact is that m68k lets arch_irq_disabled() return true to=20
> > > pretend all IRQs are disabled while high-priority IRQ is still open,=
=20
> > > thus "pass" all sanitizing check in genirq and kernel core.
> > >
> >=20
> > The fact is that m68k has arch_irq_disabled() return false when all=20
> > IRQs are enabled. So there is no bug.
>=20
> But it has arch_irq_disabled() return true while some interrupts(not=20
> NMI) are still open.
>=20
> >=20
> > > > Things could always be made simpler. But discarding features isn't=
=20
> > > > necessarily an improvement.
> > >
> > > This feature could be used by calling local_irq_enable_in_hardirq()=
=20
> > > in those IRQ handlers who hope high-priority interrupts to preempt=20
> > > it for a while.
> > >
> >=20
> > So, if one handler is sensitive to interrupt latency, all other=20
> > handlers should be modified? I don't think that's workable.
>=20
> I think we just enable preempt_rt or force threaded_irq, and then=20
> improve the priority of the irq thread who is sensitive to latency. No=20
> need to touch all threads.
>=20
> I also understand your point, we let one high-prio interrupt preempt low=
=20
> priority interrupt, then we don't need to change the whole system. But I=
=20
> think Linux prefers the method of threaded_irq or preempt_rt for this=20
> kind of problems.
>=20

So, some interrupt (or exception) processing happens atomically and the=20
rest is deferred to a different execution context. (Not a new idea.)

If you introduce latency in the former context you can't win it back in=20
the latter. Your solution fails because it adds latency to high priority=20
handlers.

> >=20
> > In anycase, what you're describing is a completely different nested=20
> > interrupt scheme that would defeat the priority level mechanism that=20
> > the hardware provides us with.
>=20
> Yes. Indeed.
>=20
> >=20
> > > It shouldn't hide somewhere and make confusion.
> > >
> >=20
> > The problem is hiding so well that no-one has found it! I say it=20
> > doesn't exist.
>=20
> Long long ago(before 2.6.38), we had a kernel supporting IRQF_DISABLED=20
> and nested interrupts were widely supported, but system also ran well in=
=20
> most cases. That means nested interrupts don't really matter in most=20
> cases. That is why m68k is also running well even though it is still=20
> nesting.
>=20

No, m68k runs well because it uses priority masking. It is not because=20
some cases are untested.

Your hardware may not have been around for 4 decades but it implements the=
=20
same capability because the design is known to work.

> >=20
> > > On the other hand, those who care about realtime should use threaded=
=20
> > > IRQ and let IRQ threads preempt each other.
> > >
> >=20
> > Yes. And those threads also have priority levels.
>=20
> Finn, I am not a m68k guy, would you help check if this could activate a
> warning on m68k. maybe we can discuss this question in genirq maillist fr=
om
> this warning if you are happy. Thanks very much.
>=20
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 7c9d6a2d7e90..b8ca27555c76 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -32,6 +32,7 @@ static __always_inline void rcu_irq_enter_check_tick(vo=
id)
>   */
>  #define __irq_enter()                                  \
>         do {                                            \
> +               WARN_ONCE(in_hardirq() && irqs_disabled(), "nested interr=
upts\n"); \
>                 preempt_count_add(HARDIRQ_OFFSET);      \
>                 lockdep_hardirq_enter();                \
>                 account_hardirq_enter(current);         \
> @@ -44,6 +45,7 @@ static __always_inline void rcu_irq_enter_check_tick(vo=
id)
>   */
>  #define __irq_enter_raw()                              \
>         do {                                            \
> +               WARN_ONCE(in_hardirq() && irqs_disabled(), "nested interr=
upts\n"); \
>                 preempt_count_add(HARDIRQ_OFFSET);      \
>                 lockdep_hardirq_enter();                \
>         } while (0)
>=20

If you think that lockdep or some other code somewhere should be protected=
=20
in this way, perhaps you can point to that code. Otherwise, your patch=20
seems to lack any justification.

> Best Regards
> Barry
>=20
>=20
---1463811774-827468299-1613084310=:6--
