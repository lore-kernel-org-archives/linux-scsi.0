From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 5/5: scsi-scan-inq-timeout
Date: Thu, 22 Apr 2004 00:48:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421224843.GD643@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141456.GW28633@tpkurt.garloff.de> <20040421132454.A19685@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="veXX9dWIonWZEC6h"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:24292 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262752AbUDUWsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 18:48:50 -0400
Content-Disposition: inline
In-Reply-To: <20040421132454.A19685@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--veXX9dWIonWZEC6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Wed, Apr 21, 2004 at 01:24:54PM -0700, Patrick Mansfield wrote:
> SCSI_TIMEOUT is 2 * HZ.
>=20
> So we defaulted to 6 seconds, and now we default to 5.5 seconds. Why?

True.

I have added half a second to be safe against 0.
Thus, I had the choice of rounding 6 to 6.5 or 5.5.
I chose 5.5, because the old value was chosen very conservative, as it
had to be enough for even sick devices. Now we have a boot parameter
to accomodate these, thus we can be less conservative. Thus 5.5.

> Why not get rid of the HZ/2, and set scsi_inq_timeout =3D SCSI_TIMEOUT/HZ=
 +
> 4 so we default to 6 again?
>=20
> So if a device needs at least N + .5 seconds then just set the
> scsi_inq_timeout to N + 1.

Why do you dislike HZ/2. The number is computed by the compiler at
compile time ...

> >  	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
> >  			" code 0x%x\n", sreq->sr_result ?
> > @@ -393,7 +400,7 @@ static void scsi_probe_lun(struct scsi_r
> >  		memset(inq_result, 0, possible_inq_resp_len);
> >  		scsi_wait_req(sreq, (void *) scsi_cmd,
> >  			      (void *) inq_result,
> > -			      possible_inq_resp_len, SCSI_TIMEOUT + 4 * HZ, 3);
> > +			      possible_inq_resp_len, (1+scsi_inq_timeout)*(HZ/2), 3);
>=20
> IMO just make the two timeouts the same and avoid any potential problems
> (like some funky device always takes 4 seconds to reponsd to an INQUIRY).

It's really only the reset recivery time which makes us choose such long
times. Otherwise SCSI_TIMEOUT would be _plenty_ of time to answer an=20
INQUIRY. An INQUIRY is easier: No medium access is needed, see SPC3.
When this second INQUIRY is done, a first one has succeeded already, so=20
the recovery from the reset has happened already.

Anyway, if you dislike it, I don't care much. If the first INQUIRY
succeeded, it's very unlikely that the second one fails, so the timeout
is even less important in real life.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--veXX9dWIonWZEC6h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhvpLxmLh6hyYd04RAmMzAKDZfmqhufcRtH5j0A6hqd59rO+FjgCgkdhT
48OtP6huiqobIJWmn1Iyw/4=
=IJor
-----END PGP SIGNATURE-----

--veXX9dWIonWZEC6h--
