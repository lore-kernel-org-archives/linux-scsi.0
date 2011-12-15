From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: pm8001: locking in mpi_sata_completion() is broken
Date: Thu, 15 Dec 2011 09:15:01 +0300
Message-ID: <20111215061501.GF26939@mwanda>
References: <20111214092947.GA1537@elgon.mountain>
 <05B890C6DE854627B79801C1B3B16BBE@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48137 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LOGOy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2011 01:14:54 -0500
Content-Disposition: inline
In-Reply-To: <05B890C6DE854627B79801C1B3B16BBE@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: lindar_liu@usish.com, linux-scsi@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2011 at 09:26:46AM +0800, Jack Wang wrote:
> >   2018                          mb();/*in order to force CPU ordering*/
> >   2019                          spin_unlock_irqrestore(&pm8001_ha->lock,
> > flags);
> >=20
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Calling irqrestore before we've done an irqsave.  What are we trying to
> > restore?
> [Jack Wang]=20
> We hold spin_lock_irqsave when we process interrupt, so here we need rest=
ore
> it to do task done clean.


You're not restoring a previous saved state, flags is set to zero
here.  You're calling:
				spin_unlock_irqrestore(&pm8001_ha->lock, 0);

The whole function is badly broken.  mpi_sata_event() has similar
problems.

With spin_lock_irqsave() and spin_unlock_irqrestore() you first have
to save the state to "flags" before you can restore it.  Doing it
the other way round doesn't make any sort sense.

regards,
dan carpenter

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6ZBlAAoJEOnZkXI/YHqRXKAP/2ifzBSR1R4DZooAM3c/wjoP
VDlDNKikYYrMlXzP0M4YgPhFycVi+pVeehX+bLCZ7pVIrNjcdLiLzSj2/ZVYAP9w
UP0elHP7DH8n8Gx5rwF6DDANDUFjeC/QRm9/IJkBOZKZIelicA0FZY5+xZIR6hwj
Ehao8La5lyGWaLtAPV0PYIIYdo12+FNHa5M2RLlOboc55LBcji0b/igRX7tLxT6y
kALSof9lz6uG09PpU1HeGHtrkDJsditgLVIlSER9XQxphand1VNrRrm7pPGv/lHZ
I3Z2wv1n2CqwdIzpf0DjHTwyB3kgUC5oRd035OLEQ9swW4WrEbvRA+GvO4NtZgZ9
M99z50m5SeW4+cV5mpvUUXfwhFzXiqoIGBKjepXnf0CI1D8H30A4ggEZ40gy2Qu5
IbEfA8wQ0860zmy3qoQFrcGAV90KFTOg/B9G+rnJWex082FKvrT85rLWhcfTNMF6
fWrdEJU5I35MQ/W9sext4En/VfXS84EEezv/EMw1d0C3zSfDdF9B0GOqShp0OAWl
OsDISbDR7Q+vk6n0pZ1bEIswB0lE4utE0Dv5QonO0jjHtW5mZmZZmqVnE/lEhRvh
kf0KmxTGZW+DuJbp7SLyGQ0fAdzxJlC6/9/zvVcNeidDOhaj3HvcHPCCC1GkrFgt
NxPDYKCXw7huNFY9XaSN
=HfK2
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
