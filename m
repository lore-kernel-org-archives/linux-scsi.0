From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] PATCH: change START_STOP to TEST_UNIT_READY
Date: Mon, 28 Oct 2002 13:10:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028131045.C20115@one-eyed-alien.net>
References: <0FA2250F5A23D64FBD983956F9B286430146019F@royntex01.iomegacorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0FA2250F5A23D64FBD983956F9B286430146019F@royntex01.iomegacorp.com>; from LAVARRE@iomega.com on Mon, Oct 28, 2002 at 02:03:25PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <LAVARRE@iomega.com>
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hrm... looking more closely at the code, I'm starting to wonder if there is
a problem here...

While the Jaz will report NOT_READY, it is removeble.  Thus it won't get a
spinup command...

So, why do we only try to spinup non-removeable devices?  We should  try to
spin up anything that shows 0x2/0x4/0x0 or 0x2/0x4/0x2.

Matt

On Mon, Oct 28, 2002 at 02:03:25PM -0700, Pat LaVarre wrote:
> > Drives that auto spin down. eg iomega jaz 1G, will
> > be started by sd_spinup_disk() from
> > sd_init_onedisk(), which happens whenever
> > sd_revalidate() is called.
>=20
> Can anyone quickly explain Why an "iomega" "jaz 1GB"
> will get an op x1B Start when needed?
>=20
> I got lost in the "whenever sd_revalidate() is called":
> http://lxr.linux.no/ident?v=3D2.5.39&i=3Dsd_revalidate
> http://lxr.linux.no/source/drivers/scsi/sd.c?v=3D2.5.39#L587
>=20
> Rumour tells me that 1995 device does Not get a Start
> in Win NT/ 2K/ XP, because it encodes "separate spinup
> required else impatient host will timeout read/write"
> as SK ASC ASCQ =3D x 2 04 00 rather than x 2 04 02.
>=20
> "IOMEGA" "ZIP"... devices, by contrast, spin up
> quickly enough that they make no distinction between
> spun up and auto spun down (except in vendor-specific
> commands, and of course in response time).
>=20
> Curiously yours in breathtaking ignorance, Pat LaVarre
>=20
> ---
>   =20
> From: Matthew Dharm [mdharm-scsi@one-eyed-alien.net] Sent: Sun 10/27/2002=
 1:43 AM=20
> To: Linux SCSI list=20
> Cc: Greg KH; USB Storage List=20
> Subject: [usb-storage] PATCH: change START_STOP to TEST_UNIT_READY=20
> Attachments: =20
> =20
> View As Web Page=20
> This patch changes a use of START_STOP to TEST_UNIT_READY in the function
> to check for a media change.
>=20
> This is required for emulated SCSI busses (IEEE1394 sbp2 and usb-storage),
> as none of the 'popular' OSes will send a START_STOP unless the target
> requests it (via sense data that indicates a startup command is needed).
> Thus, lots of device firmware out there will crash or do something equally
> bad when a START_STOP is sent.
>=20
> Yeah, busted devices, I know.  But, in the end, people just want it to
> work, and there is no reason why we can't use TEST_UNIT_READY here instea=
d.
> As the comments indicate, devices that need a spinup will get one anyway.
>=20
> Will one of the SCSI gurus please send this to Linus?
>=20
> Matt
>=20
> # This is a BitKeeper generated patch for the following project:
> # Project Name: greg k-h's linux 2.5 USB kernel tree
> # This patch format is intended for GNU patch command version 2.5 or high=
er.
> # This patch includes the following deltas:
> #                  ChangeSet    1.561.1.395 -> 1.636=20
> #       drivers/usb/storage/initializers.c      1.2.1.2 -> 1.5  =20
> #       drivers/usb/storage/transport.h 1.7.1.5 -> 1.13 =20
> #       drivers/usb/core/message.c      1.20.1.3 -> 1.22 =20
> #            kernel/signal.c    1.23.1.6 -> 1.29 =20
> #       drivers/usb/storage/datafab.c   1.8.1.5 -> 1.14 =20
> #       drivers/usb/storage/protocol.c  1.7.1.3 -> 1.9  =20
> #       drivers/usb/storage/usb.h       1.5.1.19 -> 1.26 =20
> #       drivers/usb/storage/isd200.c    1.8.1.10 -> 1.19 =20
> #       drivers/usb/storage/raw_bulk.h  1.1.1.3 -> 1.5  =20
> #       drivers/usb/storage/jumpshot.c  1.10.1.6 -> 1.17 =20
> #       drivers/usb/storage/debug.h     1.1.1.4 -> 1.6  =20
> #       drivers/usb/storage/sddr55.c    1.3.1.6 -> 1.9  =20
> #       drivers/usb/storage/shuttle_usbat.c     1.9.1.8 -> 1.18 =20
> #       drivers/usb/storage/raw_bulk.c  1.1.1.10 -> 1.13 =20
> #       drivers/usb/storage/sddr09.c    1.12.1.8 -> 1.21 =20
> #       drivers/usb/storage/scsiglue.h  1.1.1.2 -> 1.4  =20
> #       drivers/usb/storage/debug.c     1.8.1.2 -> 1.10 =20
> #          drivers/scsi/sd.c    1.22.1.13 -> 1.36 =20
> #       drivers/usb/storage/scsiglue.c  1.11.1.19 -> 1.30 =20
> #       drivers/usb/storage/transport.c 1.17.1.37 -> 1.57 =20
> #       drivers/scsi/scsi_scan.c        1.9.1.11 -> 1.16 =20
> #       drivers/usb/storage/freecom.c   1.6.1.10 -> 1.17 =20
> #       drivers/usb/storage/usb.c       1.16.1.33 -> 1.53 =20
> #
> # The following is the BitKeeper ChangeSet Log
> # --------------------------------------------
> # 02/10/26      mdharm@zen.san.one-eyed-alien.net       1.631.1.1
> # Merge bk://linuxusb.bkbits.net/usb-2.5
> # into zen.san.one-eyed-alien.net:/home/mdharm/linux-usb/greg-tree
> # --------------------------------------------
> # 02/10/26      mdharm@zen.san.one-eyed-alien.net       1.635
> # Merge
> # --------------------------------------------
> # 02/10/26      mdharm@zen.san.one-eyed-alien.net       1.636
> # Changed comments to match code.
> # --------------------------------------------
> #
> diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c Sat Oct 26 18:29:11 2002
> +++ b/drivers/scsi/sd.c Sat Oct 26 18:29:11 2002
> @@ -733,15 +733,17 @@
>                                  * check_disk_change */
>         }
>=20
> -       /* Using Start/Stop enables differentiation between drive with
> +       /* Using TEST_UNIT_READY enables differentiation between drive wi=
th
>          * no cartridge loaded - NOT READY, drive with changed cartridge -
>          * UNIT ATTENTION, or with same cartridge - GOOD STATUS.
> -        * This also handles drives that auto spin down. eg iomega jaz 1GB
> -        * as this will spin up the drive.
> +        *
> +        * Drives that auto spin down. eg iomega jaz 1G, will be started
> +        * by sd_spinup_disk() from sd_init_onedisk(), which happens when=
ever
> +        * sd_revalidate() is called.
>          */
>         retval =3D -ENODEV;
>         if (scsi_block_when_processing_errors(sdp))
> -               retval =3D scsi_ioctl(sdp, SCSI_IOCTL_START_UNIT, NULL);
> +               retval =3D scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NU=
LL);
>=20
>         if (retval) {           /* Unable to test, unit probably not read=
y.
>                                  * This usually means there is no disc in=
 the
> --
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alie=
n.net
> Maintainer, Linux USB Mass Storage Driver
>=20
> Dudes! May the Open Source be with you.
>                                         -- Eric S. Raymond
> User Friendly, 12/3/1998
>=20
> =20
>=20
> -------------------------------------------------------------------------=
-------
>=20
> << ATT182031.dat >>=20
> =20
>=20
>=20
> =20
> _______________________________________________
> usb-storage mailing list
> usb-storage@one-eyed-alien.net
> http://www2.one-eyed-alien.net/mailman/listinfo/usb-storage

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9vafVIjReC7bSPZARAsVBAJwMdpDxflqaRbp+KNzL72Vq2zW74ACgiKkF
prIuj+q09EpctKuvV9JooYg=
=foAB
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
