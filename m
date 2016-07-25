From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] SCSI-aic94xx: Delete unnecessary checks before the
 function call "kmem_cache_destroy"
Date: Mon, 25 Jul 2016 10:53:52 +0200
Message-ID: <CAMGffEmvtLX4rGGn4r+kB9KjMKaPwqNxjk-MfOGTsbukWaTy2A@mail.gmail.com>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <564AD586.5040606@users.sourceforge.net> <4962c98f-b21b-8a28-7c35-9df9cb28c857@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35025 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbcGYIyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2016 04:54:12 -0400
Received: by mail-oi0-f51.google.com with SMTP id l72so243200482oig.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 01:54:12 -0700 (PDT)
In-Reply-To: <4962c98f-b21b-8a28-7c35-9df9cb28c857@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

On Sun, Jul 24, 2016 at 1:51 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Tue, 17 Nov 2015 08:14:52 +0100
> >
> > The kmem_cache_destroy() function tests whether its argument is NUL=
L
> > and then returns immediately. Thus the test around the calls is not=
 needed.
> >
> > This issue was detected by using the Coccinelle software.
> >
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  drivers/scsi/aic94xx/aic94xx_init.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic=
94xx/aic94xx_init.c
> > index 662b232..ab93049 100644
> > --- a/drivers/scsi/aic94xx/aic94xx_init.c
> > +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> > @@ -660,12 +660,9 @@ Err:
> >
> >  static void asd_destroy_global_caches(void)
> >  {
> > -     if (asd_dma_token_cache)
> > -             kmem_cache_destroy(asd_dma_token_cache);
> > +     kmem_cache_destroy(asd_dma_token_cache);
> >       asd_dma_token_cache =3D NULL;
> > -
> > -     if (asd_ascb_cache)
> > -             kmem_cache_destroy(asd_ascb_cache);
> > +     kmem_cache_destroy(asd_ascb_cache);
> >       asd_ascb_cache =3D NULL;
> >  }
> >
> >
>
> How do you think about to integrate this update suggestion
> into another source code repository?
>
> Regards,
> Markus


Looks good to me!
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

PS: resend to fix mal-format rejection, sorry!
--=20

Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
