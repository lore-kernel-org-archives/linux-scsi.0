From: yanh <yanh@lemote.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Sat, 23 May 2009 15:11:42 +0800
Message-ID: <1243062702.8509.7.camel@localhost.localdomain>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <a998340033c8f89ec028b354ebe2956239144049.1242855716.git.wuzhangjin@gmail.com>
	 <200905222032.55869.bzolnier@gmail.com>
Reply-To: yanh@lemote.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200905222032.55869.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
List-Id: linux-scsi@vger.kernel.org

=E5=9C=A8 2009-05-22=E4=BA=94=E7=9A=84 20:32 +0200=EF=BC=8CBartlomiej Z=
olnierkiewicz=E5=86=99=E9=81=93=EF=BC=9A
> On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> >=20
> > This is originally from the to-mips branch from
> > http://dev.lemote.com/code/linux_loongson
>=20
> Sadly, the patch description lacks all the important information.
>=20
> What is the original problem that this fixup tries to address?
>=20
> Is it limited to amd74xx controllers?

In loongson2f yeeloong machines, the ide controller is AMD cs5536, or
say  amd74xx, and the hard drives is Fujistu.=20
While debuging the hard disk suspned and resume, the ide irq can not be
cleared. I guess this is a fake interrupt, hence the clear irq action
can not be finished.=20
This patch is to fix this issue. Maybe other controller and drives also
have this issue, but I am not sure.

Thanks for your reply. =20
>=20
> [ We are generalizing quirk_drives handling currently... ]
>=20
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > ---
> >  drivers/ide/amd74xx.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
> > index 77267c8..8f488b8 100644
> > --- a/drivers/ide/amd74xx.c
> > +++ b/drivers/ide/amd74xx.c
> > @@ -23,6 +23,11 @@
> > =20
> >  #define DRV_NAME "amd74xx"
> > =20
> > +static const char *am74xx_quirk_drives[] =3D {
> > +	"FUJITSU MHZ2160BH G2",
> > +	NULL
> > +};
> > +
> >  enum {
> >  	AMD_IDE_CONFIG		=3D 0x41,
> >  	AMD_CABLE_DETECT	=3D 0x42,
> > @@ -112,6 +117,19 @@ static void amd_set_pio_mode(ide_drive_t *driv=
e, const u8 pio)
> >  	amd_set_drive(drive, XFER_PIO_0 + pio);
> >  }
> > =20
> > +static void amd_quirkproc(ide_drive_t *drive)
> > +{
> > +	const char **list, *m =3D (char *)&drive->id[ATA_ID_PROD];
> > +
> > +	for (list =3D am74xx_quirk_drives; *list !=3D NULL; list++)
> > +			if (strstr(m, *list) !=3D NULL) {
> > +				drive->quirk_list =3D 2;
> > +				return;
> > +			}
> > +
> > +	drive->quirk_list =3D 0;
> > +}
> > +
> >  static void amd7409_cable_detect(struct pci_dev *dev)
> >  {
> >  	/* no host side cable detection */
> > @@ -194,6 +212,7 @@ static void __devinit init_hwif_amd74xx(ide_hwi=
f_t *hwif)
> >  static const struct ide_port_ops amd_port_ops =3D {
> >  	.set_pio_mode		=3D amd_set_pio_mode,
> >  	.set_dma_mode		=3D amd_set_drive,
> > +	.quirkproc		=3D amd_quirkproc,
> >  	.cable_detect		=3D amd_cable_detect,
> >  };
>=20

