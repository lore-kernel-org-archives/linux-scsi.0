From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH 0/3] Resend: Handle PQ3 devs better
Date: Mon, 1 May 2006 02:44:57 +0200
Message-ID: <20060501004457.GC8728@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:27293 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750824AbWEAApG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 20:45:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

resending the patches ...
Changes since last posting:
- I reversed the order of patches 2 and 3, as one patch (now 3)
  refers to a blacklist flag introduced in the other.
- Andrew Morton has merged the patches into -mm and fixed up compiler
  warnings that happened if CONFIG_SCSI_LOGGING was disabled.
  I merged that into patch 3.
- The blist flag 0x800000 has been consumed by BLIST_MAX_512, so
  go for 0x1000000 instead.

Description of the patchset:

The trouble is that there are devices that report a LUN with
peripheral qualifier 3 on LUN0.
We currently don't handle this well yet:
- Blacklist flags are not used to do special handling if needed.
- If the device does NOT support the REPORT_LUNS scan, we won't
  see any LUN at all, as we don't even look for LUN 1 then.

Yes, such devices do exist, actually, see PATCH2 ..

The patches do:
- Unconditionally at least look for LUN 1 if LUN 0 was a PQ3
  device (but abort scanning there is SPARSELUN is not set
  and no device can be attached to LUN 1)
- Return the blacklist flags for further usage even if LUN 0
  was a PQ3 device.
- Introduce a blacklist flag BLIST_ATTACH_PQ3 that allows
  a PQ3 device to be registered with the OS and thus sg can
  attach to it. Add two devices to the list.
  (One could argue that this should be default, but who knows
   what virtual scsi driver will break then ...)
- Improve the scsi logging information for the the user about
  the PQ3 issue.

Patches are agains 2.6.17rc3, please consider merging for 2.6.17/18.

Best,
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEVVoJxmLh6hyYd04RApc+AKDCvaIpKzYvv+eAJgFgeW65tHnxzQCfeTaD
tUCzrnevNGAW/micZeCF2rA=
=JnAr
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
