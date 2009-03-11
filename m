From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: linux-next: NCR_700_detect warnings
Date: Wed, 11 Mar 2009 09:59:09 +0800
Message-ID: <d82e647a0903101859p1cc2adf6s375b389907a31b82@mail.gmail.com>
References: <Pine.LNX.4.64.0903102139150.20676@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:58011 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZCKB7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 21:59:11 -0400
In-Reply-To: <Pine.LNX.4.64.0903102139150.20676@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, David Brownell <dbrownell@users.sourceforge.net>, linux-next@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>

2009/3/11 Geert Uytterhoeven <geert@linux-m68k.org>:
> commit 76afea5b078d36ec080a75c29ff5a3fbc5774fee
> Author: Ming Lei <tom.leiming@gmail.com>
> Date: =A0 Fri Feb 6 23:40:12 2009 +0800
>
> =A0 =A0platform driver: fix incorrect use of 'platform_bus_type' with=
 'struct devic
>
> =A0 =A0This patch fixes the bug reported in
> =A0 =A0 =A0 =A0http://bugzilla.kernel.org/show_bug.cgi?id=3D11681.
>
> =A0 =A0"Lots of device drivers register a 'struct device_driver' with
> =A0 =A0the '.bus' member set to '&platform_bus_type'. This is wrong,
> =A0 =A0since the platform_bus functions expect the 'struct device_dri=
ver'
> =A0 =A0to be wrapped up in a 'struct platform_driver' which provides
> =A0 =A0some additional callbacks (like suspend_late, resume_early).
> =A0 =A0The effect may be that platform_suspend_late() uses bogus data
> =A0 =A0outside the device_driver struct as a pointer pointer to the
> =A0 =A0device driver's suspend_late() function or other hard to
> =A0 =A0reproduce failures."(Lothar Wassmann)
>
> =A0 =A0Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> =A0 =A0Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> =A0 =A0Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> =A0 =A0Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> This introduced the following warnings on m68k, as `dev' is now a
> `struct platform_device *' instead of a `struct device *':
>
> | drivers/scsi/a4000t.c:64: warning: passing argument 3 of 'NCR_700_d=
etect' from incompatible pointer type
> | drivers/scsi/mvme16x_scsi.c:67: warning: passing argument 3 of 'NCR=
_700_detect' from incompatible pointer type
> | drivers/scsi/bvme6000_scsi.c:61: warning: passing argument 3 of 'NC=
R_700_detect' from incompatible pointer type
>
> I think the below is missing (untested on real hardware)?

Yes, you are correct. It is really missed.
Thanks!

>
> diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
> index 6d25aca..61af3d9 100644
> --- a/drivers/scsi/a4000t.c
> +++ b/drivers/scsi/a4000t.c
> @@ -61,7 +61,8 @@ static int __devinit a4000t_probe(struct platform_d=
evice *dev)
> =A0 =A0 =A0 =A0hostdata->dcntl_extra =3D EA_710;
>
> =A0 =A0 =A0 =A0/* and register the chip */
> - =A0 =A0 =A0 host =3D NCR_700_detect(&a4000t_scsi_driver_template, h=
ostdata, dev);
> + =A0 =A0 =A0 host =3D NCR_700_detect(&a4000t_scsi_driver_template, h=
ostdata,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &dev->dev);
> =A0 =A0 =A0 =A0if (!host) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "a4000t-scsi: No host =
detected; "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"board=
 configuration problem?\n");
> diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scs=
i.c
> index 9e9a82b..5799cb5 100644
> --- a/drivers/scsi/bvme6000_scsi.c
> +++ b/drivers/scsi/bvme6000_scsi.c
> @@ -58,7 +58,8 @@ bvme6000_probe(struct platform_device *dev)
> =A0 =A0 =A0 =A0hostdata->ctest7_extra =3D CTEST7_TT1;
>
> =A0 =A0 =A0 =A0/* and register the chip */
> - =A0 =A0 =A0 host =3D NCR_700_detect(&bvme6000_scsi_driver_template,=
 hostdata, dev);
> + =A0 =A0 =A0 host =3D NCR_700_detect(&bvme6000_scsi_driver_template,=
 hostdata,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &dev->dev);
> =A0 =A0 =A0 =A0if (!host) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "bvme6000-scsi: No hos=
t detected; "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"board=
 configuration problem?\n");
> diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.=
c
> index 7794fc1..b5fbfd6 100644
> --- a/drivers/scsi/mvme16x_scsi.c
> +++ b/drivers/scsi/mvme16x_scsi.c
> @@ -64,7 +64,8 @@ mvme16x_probe(struct platform_device *dev)
> =A0 =A0 =A0 =A0hostdata->ctest7_extra =3D CTEST7_TT1;
>
> =A0 =A0 =A0 =A0/* and register the chip */
> - =A0 =A0 =A0 host =3D NCR_700_detect(&mvme16x_scsi_driver_template, =
hostdata, dev);
> + =A0 =A0 =A0 host =3D NCR_700_detect(&mvme16x_scsi_driver_template, =
hostdata,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &dev->dev);
> =A0 =A0 =A0 =A0if (!host) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "mvme16x-scsi: No host=
 detected; "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"board=
 configuration problem?\n");
>
> Gr{oetje,eeting}s,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linu=
x-m68k.org
>
> In personal conversations with technical people, I call myself a hack=
er. But
> when I'm talking to journalists I just say "programmer" or something =
like that.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-- Linus Torvalds
>



--=20
Lei Ming
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
