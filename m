Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59035C3E8C5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 00:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CAA220756
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 00:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgK3AQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 19:16:34 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47282 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgK3AQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 19:16:34 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id B00112AA82;
        Sun, 29 Nov 2020 19:15:46 -0500 (EST)
Date:   Mon, 30 Nov 2020 11:15:46 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Michael Schmitz <schmitzmic@gmail.com>
cc:     Andreas Schwab <schwab@linux-m68k.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
In-Reply-To: <3bf3baef-ea46-a9c3-10e9-7705650d07a6@gmail.com>
Message-ID: <alpine.LNX.2.23.453.2011301115360.6@nippy.intranet>
References: <20201126132952.2287996-1-bigeasy@linutronix.de> <20201126132952.2287996-13-bigeasy@linutronix.de> <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet> <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet> <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
 <3bf3baef-ea46-a9c3-10e9-7705650d07a6@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811774-52110738-1606695331=:6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-52110738-1606695331=:6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 29 Nov 2020, Michael Schmitz wrote:

> Am 28.11.20 um 10:48 schrieb Finn Thain:
> > On Sat, 28 Nov 2020, Finn Thain wrote:
> >
> >> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> >> index d654a6cc4162..739def70cffb 100644
> >> --- a/drivers/scsi/NCR5380.c
> >> +++ b/drivers/scsi/NCR5380.c
> >> @@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_=
hostdata *hostdata,
> >>  =09=09cpu_relax();
> >>  =09} while (n--);
> >> =20
> >> -=09if (irqs_disabled() || in_interrupt())
> >> +=09/* We can't sleep when local irqs are disabled and callers ensure
> >> +=09 * that local irqs are disabled whenever we can't sleep.
> >> +=09 */
> >> +=09if (irqs_disabled())
> >>  =09=09return -ETIMEDOUT;
> >> =20
> >>  =09/* Repeatedly sleep for 1 ms until deadline */
> >>
> > Michael, Andreas, would you please confirm that this is workable on=20
> > Atari? The driver could sleep when IPL =3D=3D 2 because=20
> > arch_irqs_disabled_flags() would return false (on Atari). I'm=20
> > wondering whether that would deadlock.
>=20
> Pretty sure this would deadlock when in interrupt context here.

When in interrupt context, irqs_disabled() is true due to=20
spinlock_irqsave/restore() in NCR5380_intr().

My question was really about what would happen if we sleep with IPL =3D=3D =
2.

> Otherwise, IPL 2 is perfectly OK (which is why=20
> arch_irqs_disabled_flags() returns false in that case).
>=20
> If you want to be 100% certain, I can give this one a spin.
>=20

Please only test it if you think it will work.

> Cheers,
>=20
> =C2=A0=C2=A0=C2=A0 Michael
>=20
>=20
---1463811774-52110738-1606695331=:6--
