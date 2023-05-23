Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824EBC7EE2E
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 20:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbjEWUY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 16:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbjEWUY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 16:24:56 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016A4129;
        Tue, 23 May 2023 13:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684873472; i=deller@gmx.de;
        bh=2kEL5Dvnd1+2zbMBSC2c9hvepYwfnHhDy1edLyedfDs=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=LZQeCcU2fqY/tfblu74/xTXb4P06zZTgADhRPt2PlDb2dMoZVzr6ghpmhTlGKw3J8
         ylLwKX0D5zmt3BObVdR/9Sh8Xt8GbItCqP+dT+KlclEjmz5lPNf0pS8R5/diC2mbnN
         +z3w3JIHRCb7uqvjTEv48TvVi1bG8rj1sNpmAJ2QCKKj1DRs7u40t7tEtOwC4kyJtP
         nuh24wXfhR+k7UZpYDp8VViMWuTCmk20Xs4q0ELa60y7HVb4FJQkcFkLH0zp78c7+r
         zS3yle4lr2GQE57OIX6Gfm7LkiL3gdAZobrNm0rHXH7kwoR9k4A+mfLydzlhUIG6XZ
         bo8vP0gC+MRGw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([94.134.145.169]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M3DJl-1pxzen2okn-003cCf; Tue, 23
 May 2023 22:24:32 +0200
Date:   Tue, 23 May 2023 22:24:30 +0200
From:   Helge Deller <deller@gmx.de>
To:     Helge Deller <deller@gmx.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: spinlock recursion in aio_complete()
Message-ID: <ZG0g/lNdsfLAPv15@p100>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
 <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
 <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
 <ZGyawdtBhNnvvTv3@shell.armlinux.org.uk>
 <ZG0bkNJ5jQC1a3pY@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ZG0bkNJ5jQC1a3pY@p100>
X-Provags-ID: V03:K1:lmIYwKLwvr2gie/jntN6+MGDwTWp114p2fpu7nKOiJaa6oxZl0j
 oksvo41zJCmC9PLT+nvNkRCM806u9TDW76k3OsONqgkMuBZTFqdWi5s74KXjz7yKVB5urqK
 U30p4570yXPmVQhuUX70FCXim4Tis1h0N+SnrAUMvas6uUoVtPWTm/0WUEurYBD/uN6Cqu2
 SF3nucF5C0DQAEDeKgLaw==
UI-OutboundReport: notjunk:1;M01:P0:48iNxykj62g=;bcKhvR+pMRtkckgWzK+hR6FEAxh
 9vvsbJ0xZ6zEzMiei8K08MvKQ0PhMiwbGE6P+mX3czQho+TAG9ni6NuL5yb7fHCECDxpjKy6P
 CmIUxqGrKsf5owmxykcIpxfdOBRAm9WZh0C80C0B8zpFncbxqAJPeo0ovxaL20lXdge1fgVcR
 QyAwctukGQHIW3Iizqr1FYKVmJXL+ey9TFv4y7aF5gz2SaMPXCpVlJl0ukZhA/HbC2uIXGM76
 gwj/gtBXaOGsRNOTyULaQLKtO2RHbPfdYTlkz4hu7ECEb70d6sAmlbNv3sA0yeXph7lR5+Kl8
 LwTVvxjPGaTszAyud5/srU6WlEdZakkl7TA7AfT57ZUgFek7LotWK9b73N/ZDZd3NOGOceL8R
 wFQ58wKRDMlsVOFdEoxrdYkLboik4FuKCFQ1aqbWGiACeMmLAWLnEj2IBx1bh9NVUHqKBqxjx
 heSDyGBflPLIunzIaSWNdWMfKvuIaf1qk+Tsmqb4taWVagYEpYkOf2brVZ1bA445lfDs4lzoN
 X4zhoQF8oBOpCNfp3Y/iafliLfYHOP5x1x9dfiU+xh6nP/XxaATybnMrEbEzPkLMbXiM/AyDe
 pNDUmoPz5zgFSslgBKe33dNWZvI/pAtG3f2BLbqDhHt9FG2yZib1nabLx7/r2IOhkyAP2vaFW
 FnWdbMMzlSZSuDKRPYpQHkG/3UaF5dUOtlp641z/1bNsHhTE1/VCK60xQ7fz4t8fT4SzIK+Z0
 gg1mAk/ahouBO1EzC1glzCj3PxazmXMllqn4Z0p+AlZrV3OzhsE8wp51Pb/wearpRqLxOtkvN
 IrCOJjoes4+zqDPoR3Z06Z1R6hva7fxx4k9N+ghmuCNEzDs/2at0Jy3alhc9kaVCxNR7jvusx
 PpUnIGAg6v3Uoalv1/e4eF7t2NGqXSuNfs7fXm/VA+PPAufKDyjRA/7cTcFRL8uJ/z7Ga65XO
 92XNe1sFffowy/L/gE8Xq/JxtFA=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Helge Deller <deller@gmx.de>:
> * Russell King (Oracle) <linux@armlinux.org.uk>:
> > On Tue, May 23, 2023 at 12:24:04PM +0200, Helge Deller wrote:
> > > On 5/22/23 23:22, Helge Deller wrote:
> > > > > > It hangs in fs/aio.c:1128, function aio_complete(), in this ca=
ll:
> > > > > > =A0=A0=A0=A0=A0spin_lock_irqsave(&ctx->completion_lock, flags)=
;
> > > > >
> > > > > All code that I found and that obtains ctx->completion_lock disa=
bles IRQs.
> > > > > It is not clear to me how this spinlock can be locked recursivel=
y? Is it
> > > > > sure that the "spinlock recursion" report is correct?
> > > >
> > > > Yes, it seems correct.
> > > > [...]
> > >
> > > Bart, thanks to your suggestions I was able to narrow down the probl=
em!
> > >
> > > I got LOCKDEP working on parisc, which then reports:
> > > 	raw_local_irq_restore() called with IRQs enabled
> > > for the spin_unlock_irqrestore() in function aio_complete(), which s=
houldn't happen.
> > >
> > > Finally, I found that parisc's flush_dcache_page() re-enables the IR=
Qs
> > > which leads to the spinlock hang in aio_complete().
> > >
> > > So, this is NOT a bug in aio or scsci, but we need fix in the the ar=
ch code.
> >
> > You can find some of the background to this at:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commi=
t/?id=3D16ceff2d5dc9f0347ab5a08abff3f4647c2fee04
> >
> > which introduced flush_dcache_mmap_lock(). It looks like Hugh had
> > questions over whether this should be _irqsave() rather than _irq()
> > but I guess at the time all callers had interrupts enabled, and
> > it's only recently that someone came up with the idea of calling
> > flush_dcache_page() with interrupts disabled.
> >
> > Adding another arg to flush_dcache_mmap_lock() to save the flags
> > may be doable, but requires a patch that touches not only architecture=
s
> > that have a private implementation, but also various code in mm/.
>
> I've tested the attached patch on parisc, and it solves the issue.
> I've not compile-tested it on arm and nios2, both seem to be
> the only other affected platforms.

For your convenience, here is the hunk I used to trigger the bug.
It triggers immediately at bootup when starting userspace.

Helge

diff --git a/fs/aio.c b/fs/aio.c
index b0b17bd098bb..6076b0ab5580 100644
=2D-- a/fs/aio.c
+++ b/fs/aio.c
@@ -1127,6 +1127,7 @@ static void aio_complete(struct aio_kiocb *iocb)
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);

+	BUG_ON(!arch_irqs_disabled());
 	tail =3D ctx->tail;
 	pos =3D tail + AIO_EVENTS_OFFSET;

@@ -1139,7 +1140,10 @@ static void aio_complete(struct aio_kiocb *iocb)
 	*event =3D iocb->ki_res;

 	kunmap_atomic(ev_page);
+	BUG_ON(!arch_irqs_disabled());
+	/* the next flush_dcache_page() should keep IRQs disabled */
 	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	BUG_ON(!arch_irqs_disabled());

 	pr_debug("%p[%u]: %p: %p %Lx %Lx %Lx\n", ctx, tail, iocb,
 		 (void __user *)(unsigned long)iocb->ki_res.obj,


