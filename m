From: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Subject: Re: Usb storage mounting was broken somewhere between
	2.6.0-test5-bk10 and 2.6.0-test6-bk1
Date: Wed, 22 Oct 2003 09:49:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066808944.3699.9.camel@ulysse.olympe.o2t>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
	 <20031021175556.A8670@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F7oFhboEjAO2S0atO5Q4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.clb.oleane.net ([213.56.31.20]:19339 "EHLO
	smtp4.clb.oleane.net") by vger.kernel.org with ESMTP
	id S263309AbTJVHzF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 03:55:05 -0400
In-Reply-To: <20031021175556.A8670@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, dbrownell@users.sourceforge.net


--=-F7oFhboEjAO2S0atO5Q4
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mer 22/10/2003 =E0 02:55, Patrick Mansfield a =E9crit :

> It is a multi slot card reader, and SCSI sees these as multiple LUNs
> (multiple sd's), though you say you can only use one at a time. So we see
> INQUIRY's to LUN 0 and LUN 1, and LUN 1 shows up and is then mounted via
> /dev/smartmedia, correct?

/mnt/smartmedia, yes.

The device is a dual CF/SM reader. CF is lun 0, SM lun 1.
A mechanical flap prevents use of more than one slot at once (so maybe
the chip/driver has no knowledge at all it's restricted)

Card presence is checked via polling. So with debug activated one sees a
lot of accesses to lun 0 before lun 1 is probed.

> David - as replied to you by Nicolas in the bug, the dmesg you commented
> on is the one that was working (the "2.6.0-test5-bk5 scenario"). SCSI is
> not confused in that case (though I am somewhat confused by the various
> dmesg and log files).

Well, I tried to provide all the data:(.

> Where are the SCSI INQUIRY messages? The ones with Vendor and Model. And
> sd attach messages?
>=20
> If the SCSI INQUIRY messages are not output, SCSI is not seeing the devic=
e
> at all and it is more likely a usb issue.
>=20
> AFAICT the bad dmesg ends without a reset, where the good one shows an
> INQUIRY being sent and returned back OK, followed by logs of the mount
> command.
>=20
> i.e. bad demsg/log has:
>=20
> Oct  2 23:55:35 rousalka kernel: usb-storage: USB Mass Storage device det=
ected
> Oct  2 23:55:35 rousalka kernel: usb-storage: act_altsetting is 0, id_ind=
ex is 16
> Oct  2 23:55:35 rousalka kernel: usb-storage: -- associate_dev
> Oct  2 23:55:35 rousalka kernel: usb-storage: Vendor: SCM Microsystems
> Oct  2 23:55:35 rousalka kernel: usb-storage: Product: eUSB SmartMedia /
> CompactFlash Adapter
>=20
> And then nothing at all???

Nothing. The broken kernel outputs no further usb storage messages.
I'll re-test this evening with full usb-storage and usb debug, though
I'm pretty sure they were already activated in the test scenarii (on
both kernels - same .config after all).

And looking at the .configs that were uploaded at test time - yes they
were. I doubt -test8-bk1 will be different when tested.

Cheers,

--=20
Nicolas Mailhot

--=-F7oFhboEjAO2S0atO5Q4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/ljZvI2bVKDsp8g0RAtHGAJ9TmF/luTNS3CRUA82cs4xGRIiNMQCfTTrN
MAaxZFerE7AG7jP28qlzeF4=
=1TkX
-----END PGP SIGNATURE-----

--=-F7oFhboEjAO2S0atO5Q4--

