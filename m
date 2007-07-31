From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: Re: build #308 failed for 2.6.23-rc1-gd941cf5 in linux/./drivers/scsi/libsas/sas_ata.c
Date: Tue, 31 Jul 2007 16:13:24 +0200
Message-ID: <200707311613.24709.toralf.foerster@gmx.de>
References: <200707271253.27881.toralf.foerster@gmx.de> <1185635256.11492.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8725779.tOrR8i27W9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42006 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758435AbXGaON1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 10:13:27 -0400
In-Reply-To: <1185635256.11492.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org

--nextPart8725779.tOrR8i27W9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag, 28. Juli 2007 17:07 schrieb James Bottomley:
> On Fri, 2007-07-27 at 12:53 +0200, Toralf F=C3=B6rster wrote:
> > Hello,
> >=20
> > the build with the attached .config failed, make ends with:
> > ...
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `sas_queuecommand':
> > (.text+0x932af): undefined reference to `ata_sas_queuecmd'
> > drivers/built-in.o: In function `sas_slave_configure':
> > (.text+0x934a4): undefined reference to `ata_sas_slave_configure'
> > drivers/built-in.o: In function `sas_target_destroy':
> > (.text+0x92317): undefined reference to `ata_sas_port_destroy'
> > drivers/built-in.o: In function `sas_ioctl':
> > (.text+0x92fa4): undefined reference to `ata_scsi_ioctl'
> > drivers/built-in.o: In function `sas_slave_destroy':
> > (.text+0x92fcd): undefined reference to `ata_port_disable'
> > drivers/built-in.o: In function `sas_slave_alloc':
> > (.text+0x9307f): undefined reference to `ata_sas_port_init'
> > drivers/built-in.o: In function `sas_ata_init_host_and_port':
> > (.text+0x942c6): undefined reference to `ata_host_init'
> > drivers/built-in.o: In function `sas_ata_init_host_and_port':
> > (.text+0x942d4): undefined reference to `ata_sas_port_alloc'
> > drivers/built-in.o: In function `sas_ata_qc_issue':
> > sas_ata.c:(.text+0x9445d): undefined reference to `ata_tf_to_fis'
> > drivers/built-in.o: In function `sas_ata_task_done':
> > sas_ata.c:(.text+0x9473c): undefined reference to `ata_tf_from_fis'
> > sas_ata.c:(.text+0x9479b): undefined reference to `ata_qc_complete'
> > drivers/built-in.o:(.data+0xafc0): undefined reference to `ata_port_dis=
able'
> > drivers/built-in.o:(.data+0xafe8): undefined reference to `ata_noop_dev=
_select'
> > drivers/built-in.o:(.data+0xb008): undefined reference to `ata_noop_qc_=
prep'
> > drivers/built-in.o:(.data+0xb044): undefined reference to `ata_sas_port=
_start'
> > drivers/built-in.o:(.data+0xb048): undefined reference to `ata_sas_port=
_stop'
> > make: *** [.tmp_vmlinux1] Error 1
>=20
> This is a Kconfig cockup.  If you have the libsas with ATA support, it
> needs libata to function.  The problem is that if you compile in libsas,
> you can't build libata as a module (however, vice versa you can).
>=20
> About the only way I can think to code this in current Kconfig is the
> attached rather ugly code.
>=20
> James
>=20
> diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
> index 3a3c1ac..c01a40d 100644
> --- a/drivers/scsi/libsas/Kconfig
> +++ b/drivers/scsi/libsas/Kconfig
> @@ -32,7 +32,8 @@ config SCSI_SAS_LIBSAS
> =20
>  config SCSI_SAS_ATA
>  	bool "ATA support for libsas (requires libata)"
> -	depends on SCSI_SAS_LIBSAS && ATA
> +	depends on SCSI_SAS_LIBSAS
> +	depends on ATA =3D y || ATA =3D SCSI_SAS_LIBSAS
>  	help
>  		Builds in ATA support into libsas.  Will necessitate
>  		the loading of libata along with libsas.
>=20
>=20
This patch works fine, the build now finishes succesfully with that .config=
 file.
=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster

--nextPart8725779.tOrR8i27W9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGr0OEhyrlCH22naMRAowRAKCMziuKH0oIu2qgEhSq6iR/x4wtHQCeIBmi
NCIa6QbcShN32WLWR05wpuI=
=fnpW
-----END PGP SIGNATURE-----

--nextPart8725779.tOrR8i27W9--
