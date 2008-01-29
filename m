From: Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 11:10:24 -0800
Message-ID: <20080129191024.GO14375@one-eyed-alien.net>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VLAOICcq5m4DWEYr"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080129183910.GI15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--VLAOICcq5m4DWEYr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2008 at 07:39:11PM +0100, Jens Axboe wrote:
> On Tue, Jan 29 2008, Jens Axboe wrote:
> > On Tue, Jan 29 2008, Oliver Neukum wrote:
> > > Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle=
.com> wrote:
> > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > >> Greg KH wrote:
> > > =20
> > > > > > No difference, still just a lot of resets.
> > > > > >=20
> > > > > Where you able to figure out which usb storage transport is used?
> > > > >=20
> > > > > in drivers/usb/storage/usb.c you have get_protocol() and get_tran=
sport()
> > > > > functions. I'm not sure if these get stored in sysfs perhaps. Thi=
s will
> > > > > pinpoint better where to look. Let me research a bit.=20
> > > >=20
> > > > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' =
and
> > > > transport is 'Bulk'
> > >=20
> > > You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAG=
E_DEBUG
> > > That should tell the reason for the resets.
> >=20
> > Sure, I'll do that. Will post the results tonight.
>=20
> OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> in the device, waited 10 seconds or so and pulled it out. These are the
> messages.
>=20
> It all looks good until the MODE_SENSE command, where it only transfers
> 4 of 192 bytes.

No, that's not the problem.  This is the problem:
=20
> usb-storage: *** thread awakened.
> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage:  00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0xd L 0 F 0 Trg 0 LUN 1 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=3D0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result =3D 0
> usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: Bulk Command S 0x43425355 T 0xe L 18 F 128 Trg 0 LUN 1 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=3D0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
> usb-storage: usb_sg_init returned -22
> usb-storage: Bulk data transfer result 0x4
> usb-storage: -- auto-sense failure
> usb-storage: storage_pre_reset
> ehci_hcd 0000:00:1d.7: port 1 high speed
> ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=3Dse0 PE =
CONNECT
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> ehci_hcd 0000:00:1d.7: port 1 high speed
> ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=3Dse0 PE =
CONNECT
> usb-storage: storage_post_reset
> usb-storage: usb_reset_composite_device returns 0
> usb-storage: scsi cmd done, result=3D0x70000
> usb-storage: *** thread sleeping.

For some reason, usb_sg_init is boned during auto-sense.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--VLAOICcq5m4DWEYr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHn3ogHL9iwnUZqnkRAtE7AJ9r7JsQ+hvBOO7u5sfJA6Pu8SlmVwCePHWe
mguggEvYLuxxVzU1AocRqec=
=LBk4
-----END PGP SIGNATURE-----

--VLAOICcq5m4DWEYr--
