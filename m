From: Ryan Anderson <ryan@autoweb.net>
Subject: RE: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600
	aacraidPERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 17:15:53 -0500
Message-ID: <1101248153.26294.84.camel@ryan2.internal.autoweb.net>
References: <60807403EABEB443939A5A7AA8A7458B694F1B@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-st3OdbyWZ+31F5G9DOQJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.autoweb.net ([198.172.237.26]:41745 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S261505AbUKWWQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:16:07 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B694F1B@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


--=-st3OdbyWZ+31F5G9DOQJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-23 at 17:07 -0500, Salyzyn, Mark wrote:
> Do you have the latest Firmware from Dell? Do you have the Read and
> Write Cache disabled as Dell has recommended (for pre 6091(?) Firmware)?

The latest Dell firmware that I have seen is 6092, which would seem to
make your second question irrelevant.  Is that correct?

dmesg says this about the controller:
AAC0: kernel 2.8.4 build 6092
AAC0: monitor 2.8.4 build 6092
AAC0: bios 2.8.0 build 6092
AAC0: serial 83ac41d3fafaf001
scsi0 : percraid
  Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02

> The `container going offline' is a result of the Firmware in the card
> not responding to a SCSI command within 60 seconds (the Linux SCSI layer
> timeout). In the older firmware this would occur at the combination of
> high load, drive or scsi bus problems and the card flushing the cache.
> If the problem persists, preventing the card building up a large amount
> of cache data may be the only way to mitigate this.

Ok, I can experiment with this.  Where should I start?  (I'm not afraid
of source-level hacking, just don't know where to start.)

> I have had others experiment with overriding the SCSI timeout (the
> Adaptec driver branch has an AAC_EXTENDED_TIMEOUT) to limited success.
> Turning off the SCSI timeout (add a scsi_del_timer as command is issued
> to the controller, and a scsi_add_timer in the interrupt service routine
> before completion) worked extremely well, but this makes me
> understandably nervous.

That completely disables *any* timeout, correct?
That would make me a .. bit nervous, too.

I'm going to try to build a load today that can trigger the problem.
(It's rather hard to debug when the problem is very hard to trigger -
sigh)


--=20

Ryan Anderson               =20
AutoWeb Communications, Inc.=20
email: ryan@autoweb.net=20

--=-st3OdbyWZ+31F5G9DOQJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBo7aZvV/uNaz8d+gRAgUZAJ9nbfj8I6AUVX9TWF75XlCMAn3PgACfRhhC
IQJj8l2mXbaZtXM/6/jkEew=
=c/K+
-----END PGP SIGNATURE-----

--=-st3OdbyWZ+31F5G9DOQJ--
