From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: linux-2.6.22-rc3-g3f0a6766 build #287 failed in
	drivers/scsi/aic7xxx/aic7xxx.ko
Date: Fri, 01 Jun 2007 09:07:49 -0400
Message-ID: <1180703269.3743.115.camel@mulgrave.il.steeleye.com>
References: <200705311835.50881.toralf.foerster@gmx.de>
	 <1180650175.3743.108.camel@mulgrave.il.steeleye.com>
	 <20070531165631.ee7f23d4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39313 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754673AbXFANHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 09:07:50 -0400
In-Reply-To: <20070531165631.ee7f23d4.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Thu, 2007-05-31 at 16:56 -0700, Randy Dunlap wrote:
> On Thu, 31 May 2007 18:22:55 -0400 James Bottomley wrote:
>=20
> > On Thu, 2007-05-31 at 18:35 +0200, Toralf F=C3=B6rster wrote:
> > > Hello,
> > >=20
> > > the build with the attached .config failed, make ends with:
> > > ...
> > >   CC      arch/i386/boot/compresse
> > >   HOSTCC  arch/i386/boot/tools/build
> > >   BUILD   arch/i386/boot/bzImage
> > > Root device is (3, 8)
> > > Boot sector 512 bytes.
> > > Setup is 7178 bytes.
> > > System is 2513 kB
> > > Kernel: arch/i386/boot/bzImage is ready  (#1)
> > >   Building modules, stage 2.
> > >   MODPOST 363 modules
> > > ERROR: "spi_dv_device" [drivers/scsi/aic7xxx/aic7xxx.ko] undefine=
d!
> > > ERROR: "spi_attach_transport" [drivers/scsi/aic7xxx/aic7xxx.ko] u=
ndefined!
> > > ERROR: "spi_populate_ppr_msg" [drivers/scsi/aic7xxx/aic7xxx.ko] u=
ndefined!
> > > ERROR: "spi_populate_width_msg" [drivers/scsi/aic7xxx/aic7xxx.ko]=
 undefined!
> > > ERROR: "spi_release_transport" [drivers/scsi/aic7xxx/aic7xxx.ko] =
undefined!
> > > ERROR: "spi_display_xfer_agreement" [drivers/scsi/aic7xxx/aic7xxx=
=2Eko] undefined!
> > > ERROR: "spi_populate_sync_msg" [drivers/scsi/aic7xxx/aic7xxx.ko] =
undefined!
> > > ERROR: "spi_dv_device" [drivers/scsi/53c700.ko] undefined!
> > > ERROR: "spi_attach_transport" [drivers/scsi/53c700.ko] undefined!
> > > ERROR: "spi_schedule_dv_device" [drivers/scsi/53c700.ko] undefine=
d!
> > > ERROR: "spi_release_transport" [drivers/scsi/53c700.ko] undefined=
!
> > > ERROR: "spi_display_xfer_agreement" [drivers/scsi/53c700.ko] unde=
fined!
> > > ERROR: "spi_populate_sync_msg" [drivers/scsi/53c700.ko] undefined=
!
> > > ERROR: "spi_print_msg" [drivers/scsi/53c700.ko] undefined!
> > > ERROR: "ROOT_DEV" [drivers/mtd/maps/nettel.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > make: *** [modules] Error 2
> >=20
> > This looks like some build issue.  The symbols (except the last
> > ROOT_DEV) are defined in scsi_transport_spi.o which should have bee=
n
> > compiled in your build log because your .config has
> > CONFIG_SCSI_SPI_ATTRS=3Dy which should build it.
>=20
> Easily reproducible.  and scsi_transport_spi.o is compiled.
> but apparently not linked.  I suppose that it's due to
> CONFIG_SCSI=3Dm, but we still have:
>=20
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=3Dy
> CONFIG_SCSI_FC_ATTRS=3Dm
> CONFIG_SCSI_ISCSI_ATTRS=3Dm
> CONFIG_SCSI_SAS_ATTRS=3Dm
> CONFIG_SCSI_SAS_LIBSAS=3Dm
>=20
> Should these modules be constrained to =3Dm when CONFIG_SCSI=3Dm ?

Yes, they should.  If there's no SCSI module there's nothing to link
them into.  I thought the depends SCSI directive enforced this
requirement (as in you can't make SCSI_SPI_ATTRS y if SCSI is m and we
depend on it) ... is this incorrect?

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
