From: Markus <markus@kola.li>
Subject: Slow I/O performance on SAS1064
Date: Wed, 5 Mar 2014 18:50:37 +0100
Message-ID: <20140305175036.GA23885@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I have problem with SATA disks at my Sunfire v245 and its lsi controller th=
ey are very slow.

So I test it with dd and while dd in a nother terminal i see dstat results =
of sda:


Copy from ramdisk to sda.
=3D=3D=3D Test ext4 =3D=3D=3D
DD

root@outpost:/ramdisk# dd if=3Ddebian-7.4.0-sparc-netinst.iso of=3D/root/te=
st.dd
353344+0 records in
353344+0 records out
180912128 bytes (181 MB) copied, 24.6384 s, 7.3 MB/s

Dstat:

----total-cpu-usage---- --dsk/sda-- ---io/sda--
usr sys idl wai hiq siq| read  writ| read  writ
  1   0 100   0   0   0|   0     0 |   0     0=20
  0   0 100   0   0   0|   0     0 |   0     0=20
  2   1  97   0   0   0|   0     0 |   0     0=20
  1   5  94   0   0   0|   0     0 |   0     0=20
  7  43  50   0   0   0|   0     0 |   0     0=20
  7  43  50   0   0   0|   0     0 |   0     0=20
 10  40  50   0   0   0|   0     0 |   0     0=20
 12  45  41   3   0   0|   0     0 |   0     0=20
  6  42  36  17   0   1|   0   512k|   0  1.00=20
  0   0   0  99   0   0|   0  4096k|   0  8.00=20
  0   2   0  98   0   0|   0  5120k|   0  10.0=20
  0   1   0  99   0   0|   0  7680k|   0  15.0=20
  1   0   0 100   0   0|   0  5632k|   0  11.0=20
  0   0   0  99   0   0|   0  7168k|   0  14.0=20
  1   1   0  99   0   0|   0  6656k|   0  13.0=20
  0   0   0 100   0   0|   0  6144k|   0  12.0=20
  1   0   0 100   0   0|   0  7680k|   0  15.0=20
  0   1  22  78   0   0|   0  4608k|   0  9.00=20
  0   0  50  50   0   0|   0  3072k|   0  6.00=20
  1   0  50  50   0   1|   0  7168k|   0  14.0=20
  1   1  50  49   0   0|4096B 5120k|1.00  10.0=20
  0   0  50  50   0   0|   0  8704k|   0  17.0=20
  0   0  50  49   0   0|   0  7680k|   0  15.0=20
  0   1  50  50   0   0|   0  7168k|   0  14.0=20
  1   0  49  49   0   0|   0  7168k|   0  14.0=20
  1   0  50  50   0   0|   0  7680k|   0  15.0=20
  0   0  50  50   0   0|   0  7168k|   0  14.0=20
  0   0  50  50   0   0|   0  2560k|   0  5.00=20
  0   1  30  69   0   0|   0  3624k|   0  8.00=20
  1   0   0  99   0   0|   0  4100k|   0  9.00=20
  0   0   0 100   0   0|   0  5632k|   0  11.0=20
  0   0   0  99   0   0|   0  3584k|   0  7.00=20
  1   0   0 100   0   0|   0  4608k|   0  9.00=20
  0   0   0  99   0   1|   0  5120k|   0  10.0=20
  1   0   4  96   0   0|   0  2560k|   0  6.00=20
  0   0  50  50   0   0|   0  3072k|   0  6.00=20
  0   0  49  50   0   0|   0  5120k|   0  10.0=20
  1   0  50  50   0   0|   0  5120k|   0  10.0=20
  0   0  50  50   0   0|   0  4096k|   0  8.00=20
  1   0  50  50   0   0|   0  5120k|   0  10.0=20
  0   0  50  50   0   0|   0  5120k|   0  10.0=20
  0   1  57  42   0   0|   0  1125k|   0  17.0=20
  0   0 100   0   0   0|   0     0 |   0     0=20
  1   0 100   0   0   0|   0     0 |   0     0=20
  1   0 100   0   0   0|   0     0 |   0     0=20
  0   0 100   0   0   0|   0     0 |   0     0=20
  0   0 100   0   0   0|   0     0 |   0     0

---------------------------------------------------------------------------=
----
Information:
Kernel 3.13.5 (stable release)
Debian7 (stable)
hdparm v9.39


Controller=20
LSI SAS1064
	cat /proc/mpt/ioc0/info=20
	ioc0:
	  ProductID =3D 0x2701 (LSISAS1064 A3)
	  FWVersion =3D 0x01080400
	  MsgVersion =3D 0x0105
	  FirstWhoInit =3D 0x00
	  EventState =3D 0x00
	  CurrentHostMfaHighAddr =3D 0x00000000
	  CurrentSenseBufferHighAddr =3D 0x00000000
	  MaxChainDepth =3D 0x60 frames
	  MinBlockSize =3D 0x20 bytes
	  RequestFrames @ 0xfffffc137f602800 (Dma @ 0x00000000c000a800)
	    {CurReqSz=3D128} x {CurReqDepth=3D511} =3D 65408 bytes ^=3D 0x10000
	    {MaxReqSz=3D128}   {MaxReqDepth=3D511}
	  Frames   @ 0xfffffc137f600000 (Dma @ 0x00000000c0008000)
	    {CurRepSz=3D80} x {CurRepDepth=3D128} =3D 10240 bytes ^=3D 0x2880
	    {MaxRepSz=3D0}   {MaxRepDepth=3D511}
	  MaxDevices =3D 63
	  MaxBuses =3D 1
	  PortNumber =3D 1 (of 1)

	cat /proc/mpt/version=20
		mptlinux-3.04.20
		  Fusion MPT base driver
		  Fusion MPT SAS host driver
		  Fusion MPT ioctl driver

---------------------------------------------------------------------------=
----
Hdparm Information:
	hdparm -I /dev/sda
=09
	/dev/sda:
	SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 =
20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=09
	ATA device, with non-removable media
	Standards:
	        Likely used: 1
	Configuration:
	        Logical         max     current
	        cylinders       0       0
	        heads           0       0
	        sectors/track   0       0
	        --
	        Logical/Physical Sector size:           512 bytes
	        device size with M =3D 1024*1024:           0 MBytes
	        device size with M =3D 1000*1000:           0 MBytes=20
	        cache/buffer size  =3D unknown
	Capabilities:
	        IORDY not likely
	        Cannot perform double-word IO
	        R/W multiple sector transfer: not supported
	        DMA: not supported
			PIO: pio0 =20

---------------------------------------------------------------------------=
----
Moduls load:
lsmod | grep mpt
	mptctl                 27359  0=20
	mptsas                 45861  5=20
	mptscsih               25765  1 mptsas
	mptbase                75530  3 mptctl,mptsas,mptscsih
	scsi_transport_sas     21624  1 mptsas

---------------------------------------------------------------------------=
----
The hdparm result looks like there is somethink not right . There were no f=
eatures supported but why ?


Greetings Markus

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTF2PsAAoJENNjYPi2hQIwd5EP/iOJ2W1i4n2arRuJ/VsgKhYs
C6jP5nY4ClqiLSthkBqr8241y9O8aw6ApdRbzzz8iMqcy7Au6TM7gxyZP5GTz90T
SH1beIbvp/cXLrjzmJ2W8QCajz1mgcV86SNSh14Vj6rx7e/zz8Nt5u+BQcn1KxjI
Uf3k20aYZ9fCVIfUsmVHX0BthHhoLEeAhmApoRAW8TjEIetB+NbSjadKmrROyc0a
POREidjo0DS7hJ99gFkCPhN6Vf1vpWtVxwWJFJxHLdouB0uQZO1tVmKfxNA/NmXt
ZaHQOgUEa/Rqq6XQ+1NOjMUdctp3IBHSgS4/zCKAaEvG/22QneLjum473uxlI9vA
K7r35RCNwiXBtz34N72gISVFGAAEdFKIh8behczVy7kcFRDkl+f7ezHLI/P7bkpt
9BYxTOs4tUBRXOQwSad24aPSiCDVLGIojpsyDp6u+fKzzykoCPktXs2hBYACwPNW
xiUvGAD+ppqmyU8E2kMkNmFlPGDf7iWZjiAHp1I+bp9YwA+is8MCDbwwUfx3VdK5
2MmMJhha3mhg3DA/V4tqRwuhG4q2Ryoq8s/UAczc6sriOsKnHzedkYc7IyGLNml9
f4wG2g1Gma0AhrMBToMyVkTGXWbfIjFPmVNyWArmuONTSx7tKQMGhz2AsvP9dH/e
nBuIKbZMGkUN0e+R+l7r
=ALAE
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
