From: "Richard F. Rebel" <rrebel@whenu.com>
Subject: Re: kernel 2.6.3 mpt fusion 3.00.03:  WWN part of target
	assignment?
Date: Fri, 17 Dec 2004 11:18:43 -0500
Message-ID: <1103300323.18363.525.camel@rebel.corp.whenu.com>
References: <1103056823.18363.330.camel@rebel.corp.whenu.com>
	 <20041216221547.GB339475@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UXDJ4IWPFftfLv4KHgMc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garibaldi.swishmail.com ([209.10.110.70]:28681 "HELO
	garibaldi.swishmail.com") by vger.kernel.org with SMTP
	id S261864AbULQQ0O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2004 11:26:14 -0500
In-Reply-To: <20041216221547.GB339475@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org


--=-UXDJ4IWPFftfLv4KHgMc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hello Jeremy,

The helpful folks at LSI informed me of this useful utility.  After a
couple rounds of emails I did make the persistent bindings and an amd64
version for my system.  This did work, although I still don't understand
why the devices were assigned targets differently based on which swich I
see them through.

off-topic...

I still seem to have a performance problem talking to my nStor devices
tho but not others, so I suspect it's not related to the card or driver.

Does anyone else out there have an nStor 4500f system that might like to
share with me their sequential read performance?  I can only get about
45 MBps using good ole dd.  I can saturate the fibre reading from other
devices we have.  I find this odd as the nStor system has two
controllers, each with a co-proc 1GB ram, and it is fully decked out
with 36GB 15k rpm FC drives.  nStor hasn't been all that helpful so far
except to say that the performance should be fine and begin the finger
pointing.  :/

Best,


On Thu, 2004-12-16 at 14:15 -0800, Jeremy Higdon wrote:
> On Tue, Dec 14, 2004 at 03:40:23PM -0500, Richard F. Rebel wrote:
> >=20
> > Hello,
> >=20
> > I have a LSI logic quad port fibre channel board in two computers on a
> > small SAN.  The SAN consists of a dual controllered nStor raid, as well
> > as a dual controller SSD, each port of each device is connected to one
> > of two QLogic sanbox 5200's.
> >=20
> > One of my devices, the 6GB SSD, reports the following WWN by port:
> >=20
> > Port 0: 20:00:00:02:34:00:00:9a
> >=20
> > Port 2: 20:02:00:02:34:00:00:9a
> >=20
> > As you can see, the number are nearly identical except for the 2nd
> > number which according the the manufacturer equates to the devices
> > internal port number.
> >=20
> > Port 0, is attached to our first switch, port 2, is connected to the
> > 2nd.
> >=20
> > The kernel, upon probing the bus, reports that the SSD's target ID is 0
> > on the first switch, and on the second, it reports target 2.  Why is th=
e
> > device not being assigned the same target like my other SAN devices.
> >=20
> > This is the only device we have that elicits this behavior and it's
> > bunging up my mappings when I have it connected.  When I disconnect the
> > device and reboot everything, all of the fiber channel interfaces repor=
t
> > the other SAN devices identically across all paths (desired and
> > expected).  When I re-connect the SSD to the fabric, in reverse (port 0
> > on switch 2, port 2 on switch 1) the target's are reversed, but the SSD
> > still shows up as target 2.
> >=20
> > Please forgive my ignorance, but what is responsible for assigning the
> > target id?  The SSD vendor claims the switch or the host, and most
> > likely the host is responsible for this.  Is there something I can do t=
o
> > control this?
> >=20
> > Thanks!
> >=20
> > --=20
> > Richard F. Rebel
> >=20
> > cat /dev/null > `tty`
>=20
> Try using lsiutil to create persistent mappings.  However, relying on
> persistent and meaningful target IDs for Fibre SCSI devices is a bad
> idea, because they are typically neither.  That's one reason for the
> fc_transport API, which you don't have in your old kernel.
>=20
> jeremy
--=20
Richard F. Rebel

cat /dev/null > `tty`

--=-UXDJ4IWPFftfLv4KHgMc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBwwbjx1ZaISfnBu0RAprLAJ45wJWuncN55y3lr09hPFccCDjrbwCfcHYs
/JgzIggRwAsHyoifSbt9xw4=
=+xEr
-----END PGP SIGNATURE-----

--=-UXDJ4IWPFftfLv4KHgMc--

