From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 10:02:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421100202.B12581@one-eyed-alien.net>
References: <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net> <20030420143546.D20891@one-eyed-alien.net> <1050942042.2269.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:64530 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261727AbTDUQuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 12:50:14 -0400
Content-Disposition: inline
In-Reply-To: <1050942042.2269.3.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Apr 21, 2003 at 11:20:40AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I happen to think that most of this needs a rewrite into a well-structured
loop.  I'm not a big fan of goto.  But hey, it works and will probably get
us where we need to go without changing the behavior enough to disturb
other SCSI elements.

Matt

On Mon, Apr 21, 2003 at 11:20:40AM -0500, James Bottomley wrote:
> On Sun, 2003-04-20 at 16:35, Matthew Dharm wrote:
> > On Sun, Apr 20, 2003 at 02:33:51PM -0700, Matthew Dharm wrote:
> > > I've tested this, and it works well.  Linus, if you'll take this I've=
 got
> > > several more patches -- ones to make usb-storage use this to cut some
> > > undesireable commands, and one to fix up the INQUIRY probing in scsi_=
scan.c
> > > to be compatible with the filter code.
> >=20
> > Here is my patch to the SCSI scanning code.  Basically, if the first
> > INQUIRY for 36 bytes works, but a later one fails because of the filter=
, we
> > should still accept the device.
> >=20
> > Linus, please apply.  I'll push the usb-storage patches via Greg K-H on=
ce
> > these are accepted.
>=20
> Actually, I'm not very keen about the levels of nested inquiry in this.=
=20
> How about the attached instead?
>=20
> James
>=20

> =3D=3D=3D=3D=3D drivers/scsi/scsi_scan.c 1.77 vs edited =3D=3D=3D=3D=3D
> --- 1.77/drivers/scsi/scsi_scan.c	Sun Apr 20 18:21:18 2003
> +++ edited/drivers/scsi/scsi_scan.c	Mon Apr 21 11:17:20 2003
> @@ -1001,6 +1001,7 @@
>  	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
>  	int possible_inq_resp_len;
> =20
> + repeat_inquiry:
>  	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
>  			" channel %d id %d lun %d\n", sdev->host->host_no,
>  			sdev->channel, sdev->id, sdev->lun));
> @@ -1067,8 +1068,14 @@
>  		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
>  				" %s with code 0x%x\n", sreq->sr_result ?
>  				"failed" : "successful", sreq->sr_result));
> -		if (sreq->sr_result)
> -			return;
> +		if (sreq->sr_result) {
> +			/* if the longer inquiry has failed, flag the device
> +			 * as only accepting 36 byte inquiries and retry the
> +			 * 36 byte inquiry */
> +			printk(KERN_INFO "scsi scan: %d byte inquiry failed with code %d.  Co=
nsider BLIST_INQUIRY_36 for this device\n", sreq->sr_result);
> +			*bflags |=3D BLIST_INQUIRY_36;
> +			goto repeat_inquiry;
> +		}
> =20
>  		/*
>  		 * The INQUIRY can change, this means the length can change.


--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pCQKIjReC7bSPZARAoRfAKCqjMT0ICAwKSao8bXKVI2Kx2Um6ACdEhWF
aX75PCgFc3GzHe9PKgrqM4s=
=S8nu
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
