From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: [RFC] add transfer request length?
Date: Wed, 29 May 2002 23:00:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020529230047.D26782@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'd like to add another field to the Scsi_Cmnd structure.  At least, I
think I need another field to accomplish what I want....

Right now, a low-level SCSI driver (i.e. HBA) can't actually tell in
advance how much data will be moved by a command.  The driver can see the
buffer and the buffer length, and can enforce that the transfer length does
not exceed that buffer length, but we can't actually algorithmically
determine the amount of data we expect to move....

For example, imagine an INQUIRY for 36 bytes issued with a buffer for 256
bytes.  This actually does happen.

In this case, it's easy to figure out how much data is requested by reading
the command.  However, block device commands talk in 'number of blocks',
which is something that the HBAs shouldn't have to keep track of.

The worst device is the OnStream driver, which makes allocations in page
sizes and then transfers a strange number of bytes (n * 4096 + 512 bytes).

drivers/usb/storage/scsiglue.c has some code to try to figure out how much
data should be transfered.  This is important for emulated SCSI devices
(sbp2, usb, etc.).

So, I'd like to add a field so that high-level drivers (sd, sr, sg, etc.)
can tell us how many bytes they intend to move.  sg already collects this
information, but the HBA can't see it.

Comments?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Ye gods! I have feet??!
					-- Dust Puppy
User Friendly, 12/4/1997

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE89cAPIjReC7bSPZARAoSQAJ9G514KjEOXmpYS8nlknX/JygVy1QCeOdnd
2yt8SvDs2NV3yVk41XdFgOU=
=ESku
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
