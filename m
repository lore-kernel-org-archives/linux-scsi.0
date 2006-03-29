From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH 0/3] SCSI scanning for PQ3 devs
Date: Wed, 29 Mar 2006 22:10:20 +0200
Message-ID: <20060329201020.GG7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HHGSYth2upt+0nQt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36321 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750913AbWC2UJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 15:09:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>


--HHGSYth2upt+0nQt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

solving some SCSI scanning problems that have been reported to us,
I came up with the followin patch set.

The trouble is that there are devices that report a LUN with
peripheral qualifier on LUN0.
We currently don't handle this well yet:
- Blacklist flags are not used to do special handling if needed.
- If the device does NOT support the REPORT_LUNS scan, we won't
  see any LUN at all, as we don't even look for LUN 1 then.

Yes, such devices do exist, actually, see PATCH3 ..

The patches do:
- Unconditionally at least look for LUN 1 if LUN 0 was a PQ3
  device (but abort scanning there is SPARSELUN is not set
  and no device can be attached to LUN 1)
- Return the blacklist flags for further usage even if LUN 0
  was a PQ3 device.
- Improve the scsi logging information for the the user about
  the PQ3 issue.
- Introduce a blacklist flag BLIST_ATTACH_PQ3 that allows
  a PQ3 device to be registered with the OS and thus sg can
  attach to it. Add two devices to the list.
  (One could argue that this should be default, but who knows
   what virtual scsi driver will break then ...)

Patches are agains 2.6.16, please consider merging for 2.6.17
or shoot back feedback to me.

Best,
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--HHGSYth2upt+0nQt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEKumsxmLh6hyYd04RAlAnAKCZiW0sBX5WCbypazRK4FyA6Dc5MgCghuAj
C0SCPBwCL3VqzRdT6q+VjCM=
=7jUZ
-----END PGP SIGNATURE-----

--HHGSYth2upt+0nQt--
