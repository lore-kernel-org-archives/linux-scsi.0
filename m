From: Martin Pitt <martin.pitt@ubuntu.com>
Subject: [PATCH 0/1] Option for scsi_debug to fake removable devices
Date: Thu, 6 Sep 2012 12:03:07 +0200
Message-ID: <20120906100307.GC2864@piware.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello all,

I already re-sent this 1.5 months ago, but did not get any answer back
then; I guess it got lost in the noise by now. So, patiently retrying
again.

For the purposes of automatically testing udisks and gvfs automounting
I would like to add a parameter to scsi_debug to control the
"removable" attribute of the created block device. With that, we can
test system-internal and removable drives, as well as CD-ROMs (which
scsi_debug can already emulate). udisks requires different privileges
for mounting system-internal drives vs.  removable/hotpluggable
drives. This will also allow us to write system integration tests for
gvfs, which will exercise the whole stack including the actual polkit
configuration in a VM.

I wrote a simple kernel patch for this (against linux-next), and
tested this quite thoroughly.

I ran the style checker, and it reports two problems:

------------ 8< --------------
WARNING: line over 80 characters
#109: FILE: drivers/scsi/scsi_debug.c:3255:
+       ret |=3D driver_create_file(&sdebug_driverfs_driver, &driver_attr_r=
emovable);

WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
#126: FILE: drivers/scsi/scsi_debug.c:3353:
+               printk(KERN_ERR "scsi_debug_init: removable must be 0 or 1\=
n");
------------ 8< --------------

But as the existing code uses this style in the adjacent lines, I
favored consistency over fixing those. If the latter is desired, I'd
rather send a separate patch with just the style cleanup for the whole
file.

I got an ack from David Zeuthen (the primary udisks maintainer)
already, noted so in the patch.

Thank you in advance for considering,

Martin

--=20
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJQSHTbAAoJEPmIJawmtHufUsIQAJoMJMD+ZoEThv/TShPNH5BS
DG4rUSNdxQMZmtbaBrjoZvvIpsaY0W0WAq6HcaAn8u4htXn7ZH4OE4Z054xWD7xR
HPi3qhEmumKzsveC4MBfhOj7RLGveTi2tp7rhZkEWZRObSsPHBXpsox7p8bpuRuM
ZVj6oVBuylUJiMFPNOoytQU1+Jr+m9TUbpzh6rJwsrfrn+vRg0lrD4w9sHueio/T
mkqpGQLtD8mnMtaUKCXLQgXDaVqJck3MXSgGaFF3K062wOO/qObLq4b7qE20SyA/
KmwJtv0t6b44HlAaMmAXskknhvTmxCRvTq2yhey64mPsIUQh9oRZ89c/X+MN1wET
Sevy4syMGkhAqxq5xMO8DUzxHuR02FcK/t0ZL6C8aMrKR09J8hDws2wlgQ2Kil6i
dgILk7OF2tonk/hugEXjNndTmXg5dMU5Yhiz/Smsk86xKYsEK0iDpgiG1ZTCnF1/
FQTOeOD9tLiHmGEdOGmdf5Ape6cGhOdq6sSwSpkpp8km4VxPCt216HxTw6JZVZlS
4/eISdqHk+TZbG67cG0VHe3cQLABG2Pmx6DqQsngVV313sz2+D5epvuCIhk05bqh
3dPKHY5gVLEv9fD+AcTXfPskZEML2M2WeQuqAfHgoqdu6uU7ul1FihEU9jGzPO0w
NMMIRmsO7fu399PkDmUH
=uO88
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
