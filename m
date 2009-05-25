From: yanh <yanh@lemote.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Mon, 25 May 2009 13:45:39 +0800
Message-ID: <1243230339.9819.18.camel@localhost.localdomain>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <200905222032.55869.bzolnier@gmail.com>
	 <1243062702.8509.7.camel@localhost.localdomain>
	 <200905231347.34717.bzolnier@gmail.com>
Reply-To: yanh@lemote.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [222.92.8.141] ([222.92.8.141]:59452 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZEYFqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2009 01:46:04 -0400
In-Reply-To: <200905231347.34717.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>

=E5=9C=A8 2009-05-23=E5=85=AD=E7=9A=84 13:47 +0200=EF=BC=8CBartlomiej Z=
olnierkiewicz=E5=86=99=E9=81=93=EF=BC=9A
> On Saturday 23 May 2009 09:11:42 yanh wrote:
> > =E5=9C=A8 2009-05-22=E4=BA=94=E7=9A=84 20:32 +0200=EF=BC=8CBartlomi=
ej Zolnierkiewicz=E5=86=99=E9=81=93=EF=BC=9A
> > > On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
> > > > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > > >=20
> > > > This is originally from the to-mips branch from
> > > > http://dev.lemote.com/code/linux_loongson
> > >=20
> > > Sadly, the patch description lacks all the important information.
> > >=20
> > > What is the original problem that this fixup tries to address?
> > >=20
> > > Is it limited to amd74xx controllers?
> >=20
> > In loongson2f yeeloong machines, the ide controller is AMD cs5536, =
or
> > say  amd74xx, and the hard drives is Fujistu.=20
>=20
> Then it should use the new & shiny :) native cs5536 IDE host driver
> instead of legacy support in amd74xx...
>=20
> > While debuging the hard disk suspned and resume, the ide irq can no=
t be
> > cleared. I guess this is a fake interrupt, hence the clear irq acti=
on
> > can not be finished.=20
>=20
> AFAICS the only change that the fixup would cause for suspend/resume =
paths
> is the one in ide_config_drive_speed() which is called during resume =
to set
> transfer mode on the drive:
>=20
>        tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);
>=20
>         memset(&tf, 0, sizeof(tf));
>         tf.feature =3D SETFEATURES_XFER;
>         tf.nsect   =3D speed;
>=20
>         tp_ops->tf_load(drive, &tf, IDE_VALID_FEATURE | IDE_VALID_NSE=
CT);
>=20
>         tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
> --->
>         if (drive->quirk_list =3D=3D 2)
>                 tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);

> --->
>         error =3D __ide_wait_stat(drive, drive->ready_stat,
>                                 ATA_BUSY | ATA_DRQ | ATA_ERR,
>                                 WAIT_CMD, &stat);
>=20
> Please tell me I if understand the issue correctly: if the above quir=
k is
> not executed we end up with spurious IRQs, right?
right.
>=20
> > This patch is to fix this issue. Maybe other controller and drives =
also
> > have this issue, but I am not sure.
>=20
> Probably moving it to a generic quirk_drives list later will be usefu=
l...
>=20
> Anyway this fixup needs to be ported to / verified with cs5536 first.
the cs5536 pata driver have some geode platform dependent codes. We can
just ignore it, but the performance is poor(using hdparm to test it),
which only get 22+ MB/s. we find it only use udma2. However if using
amd74xx driver, it can set udma5, and the speed can reach to 50+ MB/s.=20

we will test whether this driver is working well without this patch.

Anyway, thanks your advice.
>=20
> Thanks.
> Bart
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
