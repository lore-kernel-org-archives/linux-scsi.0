From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Fri, 25 Feb 2005 10:19:01 +0100
Message-ID: <1109323141.5896.124.camel@ilfb02.ilsb.tuwien.ac.at>
References: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
	 <Pine.LNX.4.61.0502242246420.9332@kai.makisara.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q7Q28459e2boxMtJ8J+J"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:37051 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S262655AbVBYJTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 04:19:15 -0500
In-Reply-To: <Pine.LNX.4.61.0502242246420.9332@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: scsi <linux-scsi@vger.kernel.org>


--=-Q7Q28459e2boxMtJ8J+J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-02-24 at 23:00 +0200, Kai Makisara wrote:

> >=20
> Sounds strange but the following things come into my mind:
> - Check from the dmesg output and/or system logs what SCSI transfer=20
> settings the tape drive and the SCSI adapter negotiate. The speed should=20
> not change when you add the Megaraid controller. If you don't find the=20
> value before adding it, you can check that the current value is at least=20
> 40 MB/s (probably more).
Not so easy. The megaraid driver doesn't tell you that

cat /sys/bus/scsi/devices/0:0:6:0/scsi_level
4
(to be SCSI_3 in scsi.h)

> - Enable debugging in the st driver (change DEBUG to 1 in st.c, recompile=
,=20
> reload the module). In the normal case st should not print many debugging=
=20
> message (some when the device is opened at some when it is closed).

Now the full story:

st: Version 20050213, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi0, channel 0, id 6, lun 0
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA
4294967295
program stinit is using a deprecated SCSI ioctl, please convert it to
SG_IO
st0: Block limits 1 - 16777215 bytes.
st: Unloaded.
st: Version 20050213, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi0, channel 0, id 6, lun 0
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA
4294967295
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 0, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 4096 (1 blocks).
program stinit is using a deprecated SCSI ioctl, please convert it to
SG_IO
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 0, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 4096 (1 blocks).
st0: Drive buffer default set to 1
st0: Setting drive buffer code to 1.
st0: Mode 0 options: buffer writes: 1, async writes: 1, read ahead: 1
st0:    can bsr: 1, two FMs: 0, fast mteom: 0, auto lock: 1,
st0:    defs for wr: 0, no block limits: 0, partitions: 0, s2 log: 1
st0:    sysv: 0 nowait: 0
st0:    debugging: 1
st0: Default block size set to 0 bytes.
st0: Density default set to 0
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 0, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 4096 (1 blocks).
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 0, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 4096 (1 blocks).
st0: Rewinding tape.
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 0, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 4096 (1 blocks).
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 0, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 4096 (1 blocks).
st0: Locking drive door.
st0: Number of r/w requests 127685, dio used in 127685, pages 383055
(0).
st0: File length 0 bytes.
st0: Async write waits 0, finished 0.
st0: Buffer flushed, 1 EOF(s) written
st0: Unlocking drive door.

> - Back out the tape patches and see if that improves the situation (these=
=20
> patches should not have any effect on speed and they did not in my tests=20
> but changes may contain bugs that show up in other environments ...)
>=20
It was BEFORE adding the patches - I tried to incorporate existing
patches..

Nothing strange for me..

A question that seems to be for Sekomann :

Can there be a hidden Write Policy setting in the megaraid tape driver?
For the disks the megaraid adapter is setting Write back per default,
not Write thru. The OS (Linux) doesn't know about it.
But read performance is not better, so I seem to be wrong..


                                       Gerhard Schneider

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-Q7Q28459e2boxMtJ8J+J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCHu2FE6e53f4wQG4RAqwzAJ9WK4w/EfItYuODqKlNS2JJT4Q/yQCfTvKD
pY3WC1nVrNUGb+087G39zN8=
=37lM
-----END PGP SIGNATURE-----

--=-Q7Q28459e2boxMtJ8J+J--

