From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: arcmsr - device going offline under 3.10.x (regression?)
Date: Mon, 6 Jan 2014 07:36:00 +0100
Message-ID: <20140106063600.GU16278@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tn/+KOyBVBGpvvUM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:47946 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaAFHCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jan 2014 02:02:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz


--tn/+KOyBVBGpvvUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

we're experiencing strange trouble with new box using areca based
RAID and 3.10.x kernel.

When I load disk subsystem (ie with fio benchmark), system seems to be
working fine, but after some time (usually next day), device seems to die:


<3>[43567.763088] EXT4-fs (dm-4): previous I/O error to superblock detected
<3>[43567.763091] sd 0:0:1:0: rejecting I/O to offline device
<2>[43567.763093] EXT4-fs error (device dm-4): __ext4_get_inode_loc:4039: i=
node #135868: block 524619: comm syslog-ng: unable to read itable block
<2>[43567.763094] EXT4-fs error (device dm-4) in ext4_reserve_inode_write:4=
962: IO failure
<3>[43567.763095] EXT4-fs (dm-4): previous I/O error to superblock detected
<3>[43567.763097] sd 0:0:1:0: rejecting I/O to offline device
<4>[43567.763099] EXT4-fs warning (device dm-4): ext4_evict_inode:258: coul=
dn't mark inode dirty (err -5)
<3>[43567.763143] sd 0:0:1:0: rejecting I/O to offline device
<3>[43567.763150] sd 0:0:1:0: rejecting I/O to offline device


Hardware is Supermicro X9DRW/X9DRW with 6 core E5-2620, 64GB RAM, running c=
entos6 + vanilla
3.10.x kernel. I tried with two different adapters (1223 and 1882). Since b=
ox uses redundant
powersupplies, I don't think it could be power issue as I found in some are=
ca FAQ. I'm using
westerdn digital raid edition SATA drives.

we've experienced this problem with 3.10.22 and 3.10.25. I wasn't able to r=
eproduce this
with 3.0.101 (yet, I'm torturing the box for ~2 days now, so I can't be sur=
e).

Since the problem takes quite long to reproduce (and I'm not sure after how=
 long I can tell
the system works fine), I'd like to ask about your oppinions before trying =
to bisect this..

any ideas?

thanks a lot in advance!

BR

nik
--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--tn/+KOyBVBGpvvUM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlLKTtAACgkQ3xdJJrLygV4XSwCgg65lg6PaohmURa5h9DyB6kdk
upEAn0pnV4CpiQH7ZyWcMHZ5QivvT1Xy
=9quM
-----END PGP SIGNATURE-----

--tn/+KOyBVBGpvvUM--
