From: markus <markus@kola.li>
Subject: Re: Slow I/O performance on SAS1064
Date: Fri, 7 Mar 2014 10:46:07 +0100
Message-ID: <20140307094607.GA13346@localhost.localdomain>
References: <20140305175036.GA23885@localhost.localdomain>
 <CAK2H+ecJKp+QLJsbGW2tquO5_DuQReJD8nKViHea9tTiJwfn-g@mail.gmail.com>
 <20140305214013.GA6287@localhost.localdomain>
 <CAK2H+eesWkK_w66e5BLcA_Ft0FHNTuNYmxF_LceMHVupX8T_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK2H+eesWkK_w66e5BLcA_Ft0FHNTuNYmxF_LceMHVupX8T_xg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 12:51:27PM -0800, Mark Knecht wrote:
> On Wed, Mar 5, 2014 at 1:40 PM, markus <markus@kola.li> wrote:
> > On Wed, Mar 05, 2014 at 10:21:07AM -0800, Mark Knecht wrote:
> >> On Wed, Mar 5, 2014 at 9:50 AM, Markus <markus@kola.li> wrote:
> >> <SNIP>
> I am not familiar with this message:
>=20
> "Device supports SMART and is Disabled"
>=20
> but there are lots of posts out there with folks asking about it.
> Possibly you can figure out what's causing smart not to turn on, get
> it turned on and get some info.
right , thats why i writing to the scsi and lsi devs , because die disk sup=
ports smart and lots of other features, but the controller driver failes to=
 enable support for this.

Now i get that the mpt driver provides /dev/sg[0-1]=20

root@outpost:~# smartctl -d scsi -x /dev/sg1
smartctl 6.2 2013-07-26 r3841 [sparc64-linux-3.13.5-mar] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x50000394e2380537
Serial number:        7365P4KNT
Device type:          disk
Local Time is:        Fri Mar  7 09:54:47 2014 CET
SMART support is:     Available - device has SMART capability.
SMART support is:     Disabled
Temperature Warning:  Disabled or Not Supported
Read Cache is:        Enabled
Writeback Cache is:   Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Health Status: OK

Error Counter logging not supported

Device does not support Self Test logging
Device does not support Background scan results logging
scsiPrintSasPhy Log Sense Failed [unsupported field in scsi command]

so i had read those posts and i tried but it won't work.

root@outpost:~/lsiutil# smartctl -r scsiioctl,3 -s on -d scsi /dev/sg1
smartctl 6.2 2013-07-26 r3841 [sparc64-linux-3.13.5-mar] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

 [inquiry: 12 01 00 01 fc 00 ]
  scsi_status=3D0x0, host_status=3D0x0, driver_status=3D0x0
  info=3D0x0  duration=3D0 milliseconds  resid=3D500
  Incoming data, len=3D8:
 00     00 00 00 04 00 80 83 89                                            =
    =20
 [inquiry: 12 00 00 00 24 00 ]
  scsi_status=3D0x0, host_status=3D0x0, driver_status=3D0x0
  info=3D0x0  duration=3D4 milliseconds  resid=3D0
  Incoming data, len=3D36:
 00     00 00 05 12 45 00 00 02  41 54 41 20 20 20 20 20                   =
    =20
 10     54 4f 53 48 49 42 41 20  4d 51 30 31 41 42 42 32                   =
    =20
 20     30 55 20 20                                                        =
    =20
=3D=3D=3D START OF ENABLE/DISABLE COMMANDS SECTION =3D=3D=3D
 [mode sense(6): 1a 00 1c 00 40 00 ]
  scsi_status=3D0x0, host_status=3D0x0, driver_status=3D0x0
  info=3D0x0  duration=3D4 milliseconds  resid=3D40
  Incoming data, len=3D24:
 00     17 00 00 08 00 00 00 00  00 00 02 00 1c 0a 08 06                   =
    =20
 10     08 00 00 00 00 00 00 00                                            =
    =20
 [mode sense(6): 1a 00 5c 00 40 00 ]
  scsi_status=3D0x0, host_status=3D0x0, driver_status=3D0x0
  info=3D0x0  duration=3D0 milliseconds  resid=3D40
  Incoming data, len=3D24:
 00     17 00 00 08 00 00 00 00  00 00 02 00 1c 0a 00 00                   =
    =20
 10     00 00 00 00 00 00 00 00                                            =
    =20
 00     00 00 00 08 00 00 00 00  00 00 02 00 1c 0a 08 06                   =
    =20
 10     08 00 00 00 00 00 00 00                                            =
    =20
 [mode select(6): 15 10 00 00 18 00 ]
  Outgoing data, len=3D24:
  scsi_status=3D0x2, host_status=3D0x0, driver_status=3D0x8
  info=3D0x1  duration=3D0 milliseconds  resid=3D24
  >>> Sense buffer, len=3D18:
 00     70 00 0b 00 00 00 00 0a  00 00 00 00 00 00 00 00                   =
    =20
 10     00 00                                                              =
    =20
  status=3D2: sense_key=3Db asc=3D0 ascq=3D0
unable to enable Exception control and warning [aborted command]


>=20
> Sorry I cannot help more.
>=20
> Good luck,
> Mark

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGZVeAAoJENNjYPi2hQIwhTcP/RlP35dm1TfB2i9cqfpG4C+U
vMRGjkk/Q7OrT+a8C55F8PcCNEQCeAFtJrzu20uf8XUJA+38NUUNFe0O8I1T6ltt
svn9+LNZYT8pVOlNh+EGjjvUvT8eFtc4RwhqqZKiI8xgUw0ZFUPNqFsgcXYdQu8o
p2vf9zlrmZNeH2pccvakfAPueLzL+eTHSqKaGf4nkzC8oFlb40DmiV07jyRyAGba
TiDNejAjuc+eM6PJDhWXhZrjwkT9sixHZKn9VqMgr14VoiI2Y1Q5OjTsqIIHy/A+
drwrCJeC7MHOdSEKyu6v/els6tTeailWbThtDBPqmHl/3gnJACqAVhwn7YwpbaZe
Yq8eI/ydBjZiQhZgvKUMnOAgC8IplOUsXKT2XgNxmsiFmNpp/EioOg7ik3Jxwohg
qH4DNq7oM+iRMWcgKgxTPKtFCrHWuS2z/oJkWHifnZeGP4mnWz5EhcqPUtb2q3Pi
GTYB/iBo7IpM33nZKfOfCG/dy3mRCuG3Nj615H4dc0kJtIUJCCBT+6O2IRNu68xu
uJvJOEHB6wj/tqdRHn70HBl7aJ0SHHAeC37rCWjwCxgjME7utmOg93vmI48kNaYw
SjKSKM0WIG07bRyxwDphd2EH6hzaySRFSR7NX2ZBJEItIRQdFwWlrBNbhsEC5uHw
7LrNDug5VKWrFvZcFM9y
=UViZ
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
