Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5DC1494AD
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 23:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724281863; cv=none; b=tT1SU3Q7FS9VumMQlJs7A56sWfXdZtqsSxZn2RV6EiGP1joMTQXoyH7SolRd0u2neyv6QGsVE98o+F+oFS47+x5FNOOUemqcyCflgKalBHwmeVdGVEdFR1nl9Co9zSoddYKoXRj2uikvZk2QMbPROhPiKE4oEla2gxFTVO5iFVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724281863; c=relaxed/simple;
	bh=9VBaL92c70s2HomVB+5Lnd8xoumFMjj+d/tq9KYHnb0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AHUnqHEeOVqh97742Hhs+lfwHjn7zNCbhVpLqw2JGvhPAFI7Mdh40n2pwZrKfR/GNV4wP4lEFbNGQ0D6ABn2qRww5BgG2xgiAbFyNBwMjKEXwSJSd8RBDWZAKsTYfqXZUgS4nSC+Id4nvjFN5DAHkjVOVhF+jT3i16N3TyMAar0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:1810:1d14:e000:db6f:81d2:6624:c91c] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1sguB6-005CZe-0y;
	Wed, 21 Aug 2024 22:51:43 +0000
Received: from ben by deadeye with local (Exim 4.98)
	(envelope-from <ben@decadent.org.uk>)
	id 1sguB4-00000003XOq-162O;
	Thu, 22 Aug 2024 00:51:42 +0200
Date: Thu, 22 Aug 2024 00:51:42 +0200
From: Ben Hutchings <benh@debian.org>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] aacraid: Fix double-free on probe failure
Message-ID: <ZsZvfqlQMveoL5KQ@decadent.org.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uZ0buPasHycSnHlR"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2a02:1810:1d14:e000:db6f:81d2:6624:c91c
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--uZ0buPasHycSnHlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

aac_probe_one() calls hardware-specific init functions through the
aac_driver_ident::init pointer, all of which eventually call down to
aac_init_adapter().

If aac_init_adapter() fails after allocating memory for
aac_dev::queues, it frees the memory but does not clear that member.

After the hardware-specific init function returns an error,
aac_probe_one() goes down an error path that frees the memory pointed
to by aac_dev::queues, resulting.in a double-free.

Reported-by: Michael Gordon <m.gordon.zelenoborsky@gmail.com>
References: https://bugs.debian.org/1075855
Fixes: 8e0c5ebde82b ("[SCSI] aacraid: Newer adapter communication iterface =
support")
Signed-off-by: Ben Hutchings <benh@debian.org>
---
 drivers/scsi/aacraid/comminit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/commini=
t.c
index bd99c5492b7d..0f64b0244303 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -642,6 +642,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
=20
 	if (aac_comm_init(dev)<0){
 		kfree(dev->queues);
+		dev->queues =3D NULL;
 		return NULL;
 	}
 	/*
@@ -649,6 +650,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	 */
 	if (aac_fib_setup(dev) < 0) {
 		kfree(dev->queues);
+		dev->queues =3D NULL;
 		return NULL;
 	}
 	=09

--uZ0buPasHycSnHlR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmbGb3cACgkQ57/I7JWG
EQnJcBAAnuqh9MiSekrWG0VFiWulrs6Y946LlYQqrzHSY/1a7jhwBN8ipvEIfWHI
uQAA+AecHd45T5zLipOTSsZ2cYPaadHWcV8iqgPS2fouH1zB3HtGlpSAb6zbvTlu
re91gk5w82C6x3N0t+QUTztheOYXa45L1dNgQa8VcBeUg3fbVdfjqVF0jvvoscQn
ZIQ38hLdymWYsxcepJebZt7Szz8+y66S+tQRP8kQVFLcZwrUYfdR2rt/NPeGLlLQ
paHwUFYnxr1grAwT2IMGhJKnTtcUUs1KBh8PxI471o9FSYKdPI8ZCiqRuY9ZNcpf
c/QMZB5e/EuNYtL0nWVTwwZVi30fvw6gKj8dXrUxYRvjn3vkxOzgedxsQ/oh9y5Z
4PTEPRkh/E6U+DKW+U2yhmHp073P91priptgqkLAS4L4wokYtoTjH4sIRkc+rdwI
HV+pq3IbdJG9QmHXQMCqyB9y7SgteBg5PXTMvlpDDahly8zFMYzdGDqVvzkEWaJ6
gBU/kQB4Q7/whAxwdx1L/yAwZ8dQk2SU1apE12Wn+PYBMGH7vbb3cW/m09HNEzpQ
kU3h0TyZmj++eIC3HRALTCQS58BjmEcYxQz9q4gg0Xi954FQyFmsCelO1K2o5vAd
ioy5SZhKI8DRhPZfjzAPJ1D08WvMlwDFDxXrbdqleNW5XiMMCZY=
=XCh4
-----END PGP SIGNATURE-----

--uZ0buPasHycSnHlR--
