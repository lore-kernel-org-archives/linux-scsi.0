From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Fri, 14 Jan 2005 14:26:23 +0100
Message-ID: <20050114132623.GA7837@bogon.ms20.nix>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com> <20050113124032.GB5701@bogon.ms20.nix> <20050114002134.GA14102@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:35771 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S261723AbVANNbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 08:31:38 -0500
Content-Disposition: inline
In-Reply-To: <20050114002134.GA14102@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 13, 2005 at 04:21:34PM -0800, Patrick Mansfield wrote:
> On Thu, Jan 13, 2005 at 01:40:32PM +0100, Guido Guenther wrote:
>=20
> > No. Without any patches we had all the available devices in
> > /proc/scsi/scsi but none was marked as "claimed by the OS" (all were
> > marked with a star, but could then be "added" via "scsi
> > add-single-device ... > /proc/scsi/scsi").=20
>=20
> Oh ...  the "*" is used in the /proc/scsi/qla2xxx/N files, not
> /proc/scsi/scsi.
You're absolutely right. The above should read:

Without any patches we had all the available devices in
/proc/scsi/qla2xxx/N but none was marked as "claimed by the OS" (all
were marked with a star, but could then be "added" via "scsi
add-single-device ... > /proc/scsi/scsi").=20

Sorry for the confusion.=20

This is the target that has all the devices:
# echo "0 0 -" > /sys/class/scsi_host/host0/scan
scsi_scan_host_selected: <0:0:0:4294967295>
scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
scsi <0:0:0:0> send                  scsi0 : destination target 0, lun 0
        command =3D Inquiry 00 00 00 24 00
scsi <0:0:0:0> done SUCCESS        0 scsi0 : destination target 0, lun 0
        command =3D Inquiry 00 00 00 24 00
scsi scan: 1st INQUIRY successful with code 0x0
scsi <0:0:0:0> send                  scsi0 : destination target 0, lun 0
        command =3D Inquiry 00 00 00 95 00
scsi <0:0:0:0> done SUCCESS        0 scsi0 : destination target 0, lun 0
        command =3D Inquiry 00 00 00 95 00
scsi scan: 2nd INQUIRY successful with code 0x0
scsi scan: peripheral qualifier of 3, no device added
scsi scan: Sequential scan of host 0 channel 0 id 0

While this is an empty one:
# echo "0 1 -" > /sys/class/scsi_host/host0/scan
scsi_scan_host_selected: <0:0:1:4294967295>
scsi scan: INQUIRY to host 0 channel 0 id 1 lun 0
scsi <0:0:1:0> send                  scsi0 : destination target 1, lun 0
        command =3D Inquiry 00 00 00 24 00
scsi <0:0:1:0> done SUCCESS    10000 scsi0 : destination target 1, lun 0
        command =3D Inquiry 00 00 00 24 00
scsi scan: 1st INQUIRY failed with code 0x10000

Cheers,
 -- Guido

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB58h/n88szT8+ZCYRAo2dAJ9HXE+eldDPwCd1EOGc/uvAR1ZeGwCfZumM
plpzUnMzbh8gcQWOYpiXO+I=
=7kJk
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
