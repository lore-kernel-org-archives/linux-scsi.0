Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9E049F13F
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788289710; cv=none; b=GmAjxvzet9A175XeKSYQzxIggM528GpiS/Luzd0OV7YcO/XZ5ALJp8noMpViqR3zSMEzGR+jB2+krG3LunhkLn35SnlQBsf3XIlKOKUTeZJ2ahcZhbu2Av8y68zXHO4geUF7A0UbZjjDK1GypOSpBd1SunI/QVGEi3Kuk2mc9Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788289710; c=relaxed/simple;
	bh=9LFsoPdA7Z96tuN4KE74hGywRfz1bmrcnuAywiH5gdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAuCpsLY5vOgo9GEAEpkr64ZWKT5o6MpG6NPQA3mk+024zEy3czLB4CRuBDeA2WE6LB7H0MU85xzzvF/4H9wrXxtRylogkpuPXxfsy7+0eSHOEN+PJoKZAK1BkETZNppYchVNDvd2p9Fj+vvB/zHODzxHK7NKKZlrVFZyeBBDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iI4sQjiX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iI4sQjiX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788289708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aIxAvTRNvxJgRJBiEkDQ2UEAvyzYXhxvE+oYR37jJhI=;
	b=iI4sQjiXNiLP87Ypju4n3fQqdDye9SjBCz3t+pHNbpXITDqx8VVHfOpr5dtEweTFZSu5Dl
	wbkX1fWB4Dtc9uyeKA3IT+Nbrq+ORgP7kI6CGZIeXke09O0pFAVtYIQdcALtNr7tvI8gKT
	d5P8ep72F+aBigdYCvtSV9sQgu0fqDE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-P5I-FGMdPmOCoUPEPOt70Q-1; Tue,
 01 Sept 2026 15:08:26 -0400
X-MC-Unique: P5I-FGMdPmOCoUPEPOt70Q-1
X-Mimecast-MFC-AGG-ID: P5I-FGMdPmOCoUPEPOt70Q_1788289703
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EA59183035E;
	Tue,  1 Sep 2026 19:08:23 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C5807E3;
	Tue,  1 Sep 2026 19:08:22 +0000 (UTC)
Date: Tue, 1 Sep 2026 15:08:20 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com,
	jasowangio@gmail.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, neeraj.soni@oss.qualcomm.com,
	gaurav.kashyap@oss.qualcomm.com, mani@kernel.org,
	andersson@kernel.org, konradybcio@kernel.org, bvanassche@acm.org,
	alim.akhtar@samsung.com, avri.altman@sandisk.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 06/11] scsi: ufs: core: add slot path to
 ufshcd_prepare_lrbp_crypto
Message-ID: <20260901190820.GB729142@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-7-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pBRcO3zyIP96qqRf"
Content-Disposition: inline
In-Reply-To: <20260827160806.1295313-7-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

--pBRcO3zyIP96qqRf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 09:07:15AM -0700, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>=20
> ufshcd_prepare_lrbp_crypto() programs crypto_key_slot in the LRB from
> rq->crypt_keyslot.  With the blk-crypto slot path a bio can carry a
> pre-programmed physical ICE keyslot index in crypt_ctx->bc_slot rather
> than a blk_crypto_key pointer.  In that case rq->crypt_keyslot is NULL
> and the existing code incorrectly falls through to the "no encryption"
> path, leaving crypto_key_slot as -1.
>=20
> Extend the function to handle both cases: when rq->crypt_keyslot is
> set, derive the slot index via blk_crypto_keyslot_index() as before;
> when bc_slot.data_unit_size_bits is non-zero, read crypto_key_slot
> directly from bc_slot.phy_slot.
>=20
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/ufs/core/ufshcd-crypto.h | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

This patch also looks like it's specific to the out-of-band key slot
programming interface. Skipping for now.

>=20
> diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-c=
rypto.h
> index 8f66db94e179..2fc5601c0f76 100644
> --- a/drivers/ufs/core/ufshcd-crypto.h
> +++ b/drivers/ufs/core/ufshcd-crypto.h
> @@ -15,13 +15,21 @@
>  static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
>  					      struct ufshcd_lrb *lrbp)
>  {
> -	if (!rq || !rq->crypt_keyslot) {
> +	if (!rq) {
>  		lrbp->crypto_key_slot =3D -1;
>  		return;
>  	}
> =20
> -	lrbp->crypto_key_slot =3D blk_crypto_keyslot_index(rq->crypt_keyslot);
> -	lrbp->data_unit_num =3D rq->crypt_ctx->bc_dun[0];
> +	if (rq->crypt_keyslot) {
> +		lrbp->crypto_key_slot =3D blk_crypto_keyslot_index(rq->crypt_keyslot);
> +		lrbp->data_unit_num =3D rq->crypt_ctx->bc_dun[0];
> +	} else if (rq->crypt_ctx && rq->crypt_ctx->bc_slot.data_unit_size_bits)=
 {
> +		lrbp->crypto_key_slot =3D rq->crypt_ctx->bc_slot.phy_slot;
> +		lrbp->data_unit_num =3D rq->crypt_ctx->bc_dun[0];
> +	} else {
> +		lrbp->crypto_key_slot =3D -1;
> +	}
> +
>  }
> =20
>  static inline void
> --=20
> 2.34.1
>=20

--pBRcO3zyIP96qqRf
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXIqQACgkQnKSrs4Gr
c8iYNQf/Z/Mg0LaUa6dUJKhoFrywpY04b1BFZC1/1mBEcV2rEpgme0EWNIrKViN/
3k9Cl7masxIgvtvpYzcTYaXy/es7h5fzlSTiP8qyPftSB9iBVHq8mzRO3oJqybld
z0R8smUmJK8J0eRDOcNbPmEEiY/bV6r4xgNZD0qC3+K+lJHQinp7yz2D9HySG1cO
Vh3+MBiYeUpmoRya/8hEa1X1hXhoIlQRmrNkL6+mhR3A46ybQCAcmVtjfguXcGGk
KJ0wH4y6TcHdZCy8PnGRKOe+Pg8/XTw3q9Eittz5wr26GmhPqtjn7dAmWKwtz42l
tyy1f3bl5pR2uOxzo3IH0lNg4wcHig==
=a1Wq
-----END PGP SIGNATURE-----

--pBRcO3zyIP96qqRf--

