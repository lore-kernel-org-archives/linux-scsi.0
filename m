From: Kurt Garloff <garloff@suse.de>
Subject: rep lun scan if LUN 0 not connected
Date: Sat, 18 Sep 2004 00:05:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040917220558.GA5764@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56299 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S269063AbUIQWID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 18:08:03 -0400
Received: from hermes.suse.de (hermes-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id 372BEC136EA
	for <linux-scsi@vger.kernel.org>; Sat, 18 Sep 2004 00:06:07 +0200 (CEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

is there any special reason for this code in scsi_scan_target() ?

	/*
	 * Scan LUN 0, if there is some response, scan further. Ideally, we
	 * would not configure LUN 0 until all LUNs are scanned.
	 */
	res =3D scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev,
				     rescan);
	if (res =3D=3D SCSI_SCAN_LUN_PRESENT) {
		if (scsi_report_lun_scan(sdev, bflags, rescan) !=3D 0)
			/*
			 * The REPORT LUN did not scan the target,
			 * do a sequential scan.
			 */
			scsi_sequential_lun_scan(shost, channel, id, bflags,
				       	res, sdev->scsi_level, rescan);
	} else if (res =3D=3D SCSI_SCAN_TARGET_PRESENT) {
		/*
		 * There's a target here, but lun 0 is offline so we
		 * can't use the report_lun scan.  Fall back to a
		 * sequential lun scan with a bflags of SPARSELUN and
		 * a default scsi level of SCSI_2
		 */
		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
	}

The return values from scsi_probe_and_add_lun() are
 *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
 *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
 *         attached at the LUN
 *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initializ=
ed

I don't see a reason not to try scsi_report_lun_scan() if the target
is present, but does not report to support a unit at LUN number 0.=20

Is there anything I overlooked in SPC3? Or any devices which behave
in strange ways?

I have come across a device recently (HITACHI F500F) that does report
PQ/PDevTp 3/0x1f on LUN 0, and does return a perfectly sensible answer
(*) on REPORT_LUNS sent down to the target LUN 0. Actually, the raid=20
storage devs I came across all react reasonably to REPORT_LUNS despite=20
their behaviour on LUN 0 was varying. PQ/PDevTp =3D 0/3, 1/3 were the=20
other popular answers.=20

(*) Some devs sent strange LUN formats that Linux does not reasonably
 convert to a 32bit integer. We should move on to using opaque 8byte
 LUN handles some day.

So I would suggest to remove the special case for
SCSI_SCAN_TARGET_PRESENT and just use
	if (res !=3D SCSI_SCAN_NO_RESPONSE) {
		if (scsi_report_lun_scan(sdev, bflags, rescan) !=3D 0)


Flames? Patch wanted?
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG / Novell, Nuernberg, DE               Director SUSE Labs

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBS1/GxmLh6hyYd04RAs3tAKCteNaxx+rCAzEuv91kQ+SQ+XenfQCggExQ
tm4cJER8OYzu/27I0/0kBQQ=
=uYiL
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
