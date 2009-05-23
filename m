From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Sat, 23 May 2009 13:47:34 +0200
Message-ID: <200905231347.34717.bzolnier@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com> <200905222032.55869.bzolnier@gmail.com> <1243062702.8509.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1243062702.8509.7.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: yanh@lemote.com
Cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
List-Id: linux-scsi@vger.kernel.org

On Saturday 23 May 2009 09:11:42 yanh wrote:
> =E5=9C=A8 2009-05-22=E4=BA=94=E7=9A=84 20:32 +0200=EF=BC=8CBartlomiej=
 Zolnierkiewicz=E5=86=99=E9=81=93=EF=BC=9A
> > On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
> > > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > >=20
> > > This is originally from the to-mips branch from
> > > http://dev.lemote.com/code/linux_loongson
> >=20
> > Sadly, the patch description lacks all the important information.
> >=20
> > What is the original problem that this fixup tries to address?
> >=20
> > Is it limited to amd74xx controllers?
>=20
> In loongson2f yeeloong machines, the ide controller is AMD cs5536, or
> say  amd74xx, and the hard drives is Fujistu.=20

Then it should use the new & shiny :) native cs5536 IDE host driver
instead of legacy support in amd74xx...

> While debuging the hard disk suspned and resume, the ide irq can not =
be
> cleared. I guess this is a fake interrupt, hence the clear irq action
> can not be finished.=20

AFAICS the only change that the fixup would cause for suspend/resume pa=
ths
is the one in ide_config_drive_speed() which is called during resume to=
 set
transfer mode on the drive:

       tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);

        memset(&tf, 0, sizeof(tf));
        tf.feature =3D SETFEATURES_XFER;
        tf.nsect   =3D speed;

        tp_ops->tf_load(drive, &tf, IDE_VALID_FEATURE | IDE_VALID_NSECT=
);

        tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
--->
        if (drive->quirk_list =3D=3D 2)
                tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
--->
        error =3D __ide_wait_stat(drive, drive->ready_stat,
                                ATA_BUSY | ATA_DRQ | ATA_ERR,
                                WAIT_CMD, &stat);

Please tell me I if understand the issue correctly: if the above quirk =
is
not executed we end up with spurious IRQs, right?

> This patch is to fix this issue. Maybe other controller and drives al=
so
> have this issue, but I am not sure.

Probably moving it to a generic quirk_drives list later will be useful.=
=2E.

Anyway this fixup needs to be ported to / verified with cs5536 first.

Thanks.
Bart
