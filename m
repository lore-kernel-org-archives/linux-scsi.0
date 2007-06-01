From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: linux-2.6.22-rc3-g3f0a6766 build #287 failed in
	drivers/scsi/aic7xxx/aic7xxx.ko
Date: Fri, 01 Jun 2007 09:23:13 -0400
Message-ID: <1180704193.3743.119.camel@mulgrave.il.steeleye.com>
References: <200705311835.50881.toralf.foerster@gmx.de>
	 <1180650175.3743.108.camel@mulgrave.il.steeleye.com>
	 <20070531165631.ee7f23d4.randy.dunlap@oracle.com>
	 <1180703269.3743.115.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45875 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754663AbXFANXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 09:23:16 -0400
In-Reply-To: <1180703269.3743.115.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Fri, 2007-06-01 at 09:07 -0400, James Bottomley wrote:
> On Thu, 2007-05-31 at 16:56 -0700, Randy Dunlap wrote:
> > On Thu, 31 May 2007 18:22:55 -0400 James Bottomley wrote:
> >=20
> > > On Thu, 2007-05-31 at 18:35 +0200, Toralf F=C3=B6rster wrote:
> > > > Hello,
> > > >=20
> > > > the build with the attached .config failed, make ends with:
> > > > ...
> > > >   CC      arch/i386/boot/compresse
> > > >   HOSTCC  arch/i386/boot/tools/build
> > > >   BUILD   arch/i386/boot/bzImage
> > > > Root device is (3, 8)
> > > > Boot sector 512 bytes.
> > > > Setup is 7178 bytes.
> > > > System is 2513 kB
> > > > Kernel: arch/i386/boot/bzImage is ready  (#1)
> > > >   Building modules, stage 2.
> > > >   MODPOST 363 modules
> > > > ERROR: "spi_dv_device" [drivers/scsi/aic7xxx/aic7xxx.ko] undefi=
ned!
> > > > ERROR: "spi_attach_transport" [drivers/scsi/aic7xxx/aic7xxx.ko]=
 undefined!
> > > > ERROR: "spi_populate_ppr_msg" [drivers/scsi/aic7xxx/aic7xxx.ko]=
 undefined!
> > > > ERROR: "spi_populate_width_msg" [drivers/scsi/aic7xxx/aic7xxx.k=
o] undefined!
> > > > ERROR: "spi_release_transport" [drivers/scsi/aic7xxx/aic7xxx.ko=
] undefined!
> > > > ERROR: "spi_display_xfer_agreement" [drivers/scsi/aic7xxx/aic7x=
xx.ko] undefined!
> > > > ERROR: "spi_populate_sync_msg" [drivers/scsi/aic7xxx/aic7xxx.ko=
] undefined!
> > > > ERROR: "spi_dv_device" [drivers/scsi/53c700.ko] undefined!
> > > > ERROR: "spi_attach_transport" [drivers/scsi/53c700.ko] undefine=
d!
> > > > ERROR: "spi_schedule_dv_device" [drivers/scsi/53c700.ko] undefi=
ned!
> > > > ERROR: "spi_release_transport" [drivers/scsi/53c700.ko] undefin=
ed!
> > > > ERROR: "spi_display_xfer_agreement" [drivers/scsi/53c700.ko] un=
defined!
> > > > ERROR: "spi_populate_sync_msg" [drivers/scsi/53c700.ko] undefin=
ed!
> > > > ERROR: "spi_print_msg" [drivers/scsi/53c700.ko] undefined!
> > > > ERROR: "ROOT_DEV" [drivers/mtd/maps/nettel.ko] undefined!
> > > > make[1]: *** [__modpost] Error 1
> > > > make: *** [modules] Error 2
> > >=20
> > > This looks like some build issue.  The symbols (except the last
> > > ROOT_DEV) are defined in scsi_transport_spi.o which should have b=
een
> > > compiled in your build log because your .config has
> > > CONFIG_SCSI_SPI_ATTRS=3Dy which should build it.
> >=20
> > Easily reproducible.  and scsi_transport_spi.o is compiled.
> > but apparently not linked.  I suppose that it's due to
> > CONFIG_SCSI=3Dm, but we still have:
> >=20
> > #
> > # SCSI Transports
> > #
> > CONFIG_SCSI_SPI_ATTRS=3Dy
> > CONFIG_SCSI_FC_ATTRS=3Dm
> > CONFIG_SCSI_ISCSI_ATTRS=3Dm
> > CONFIG_SCSI_SAS_ATTRS=3Dm
> > CONFIG_SCSI_SAS_LIBSAS=3Dm
> >=20
> > Should these modules be constrained to =3Dm when CONFIG_SCSI=3Dm ?
>=20
> Yes, they should.  If there's no SCSI module there's nothing to link
> them into.  I thought the depends SCSI directive enforced this
> requirement (as in you can't make SCSI_SPI_ATTRS y if SCSI is m and w=
e
> depend on it) ... is this incorrect?

I just tried it on my setup.  When SCSI=3Dm this is what I get:

*
* SCSI Transports
*
Parallel SCSI (SPI) Transport Attributes (SCSI_SPI_ATTRS) [M/y/?] (NEW)=
=20

Also, all the SCSI dependent device drivers are doing this too ... I'm
sure this didn't used to be the case, so I suspect we have a bug in
Kconfig somewhere.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
