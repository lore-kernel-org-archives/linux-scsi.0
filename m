From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] sdd scsi-ml event wq
Date: Fri, 28 May 2004 10:15:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085732140.2782.14.camel@laptop.fenrus.com>
References: <40B6F16B.6070909@cs.wisc.edu>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-USqNAzcSbXxbEm2Tdk/e"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:22702 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265960AbUE1IPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 04:15:44 -0400
In-Reply-To: <40B6F16B.6070909@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-USqNAzcSbXxbEm2Tdk/e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-05-28 at 09:59, Mike Christie wrote:
> The attached patch just adds a scsi-ml work queue to handle all
> events. It also converts the transport_scsi_fc class to use it,
> so drivers using that class do not have to worry about calling
> the event functions from a process context.

question: it seems you allow only a limited number of outstanding
events, fair enough. However, how are users of this API supposed to
handle failure? I see you pass the error nicely all the way down, yet I
don't quite understand how a driver (the consumer of the API) is
supposed to handle failure. Queue the event itself? Sounds ugly/wrong to
me. I'm just wondering if the cleanup you propose doesn't just mean that
the uglyness gets pushed to correct users of the API.. which isn't quite
a nett win (under the assumption that there are more than one users of a
subsystem function)

--=-USqNAzcSbXxbEm2Tdk/e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAtvUsxULwo51rQBIRApkdAJ40t1W1e8Swep8dpqd7lcH1U690JACeIRkv
sWyHB/QYGEzIdrAkaDHJUhw=
=E07+
-----END PGP SIGNATURE-----

--=-USqNAzcSbXxbEm2Tdk/e--

