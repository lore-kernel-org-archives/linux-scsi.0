Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8337C4A093F
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788290039; cv=none; b=Sbi6J9StVso5xy2Se7MU/bIFopS49eBTwutgnMQRyx66erFeINHZcn/jakozrvPvNf75wPq8DzaSNCedzulAsVShZvQXPGmDR1+Bp4Xhks3w2/2Wvnu0J7+mpsBZPH8F/06wFmbr3nAdASLPH29qhPOUKGOFbWqcBZ2aQTWlAIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788290039; c=relaxed/simple;
	bh=rlnEpoQqZM0q1JKCIvkU4Yzcc1HivHI0aGOTf4jB2Lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtltMreZGY1U6iEfmUsw75RSJTWKKifTULUQZEXt0Axkq3B6a13mIH9QaFBpwNCxhe718e82/wVt+h2ljsxDlvMGg9acouCwEcjL08dVuaTedXny83VC+4b49UMGCuJzURxuBYHpORrezfNDd4pOQIDAl5OPuHPxxoAdmSk8bBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O0WEUnCl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0WEUnCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788290033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Gc0ait3L/IgveRSbsQEV85pq6/ltievYnmCwsbLN8s=;
	b=O0WEUnClA/dZltVM2YvPxEQW0gm8PQC87ubfb3mfZq/1VLj/gr1ab6Ow8rg62LFyJyCppU
	Qu+uH/skrSLdXy9BKaW3E5N6ul3ssrv+2HU1HirWLOoqrorrv364v2nW6R+qpsSpMgquSU
	wcT1SRY2nOICbpzuWAgc7Ls0mv7o1Xc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-k8giU1h9OVCJTn1H8fntNg-1; Tue,
 01 Sept 2026 15:13:49 -0400
X-MC-Unique: k8giU1h9OVCJTn1H8fntNg-1
X-Mimecast-MFC-AGG-ID: k8giU1h9OVCJTn1H8fntNg_1788290026
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6D0B195411F;
	Tue,  1 Sep 2026 19:13:45 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 000DC30001A2;
	Tue,  1 Sep 2026 19:13:43 +0000 (UTC)
Date: Tue, 1 Sep 2026 15:13:42 -0400
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
Subject: Re: [PATCH v1 07/11] blk-crypto: move bio_crypt_dun_increment() to
 the public header
Message-ID: <20260901191342.GC729142@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PEA6fpBf2bNc3JFu"
Content-Disposition: inline
In-Reply-To: <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

--PEA6fpBf2bNc3JFu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 09:07:16AM -0700, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>=20
> bio_crypt_dun_increment() is currently declared only in
> block/blk-crypto-internal.h, which is not accessible to code
> outside of block/.  Drivers that manage inline-encrypted I/O
> directly need to advance the DUN across bio_vecs within a bio,
> or across multiple bios in a request, and have no other way
> to call this function.
>=20
> Move the declaration from block/blk-crypto-internal.h to
> include/linux/blk-crypto.h alongside the existing
> bio_crypt_dun_is_contiguous() and blk_crypto_init_key()
> declarations. The implementation in block/blk-crypto.c is
> unchanged.
>=20
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  block/blk-crypto-internal.h | 3 ---
>  include/linux/blk-crypto.h  | 3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)

Other include/linux/blk-crypto.h functions export their symbols. Does
bio_crypt_dun_increment() need EXPORT_SYMBOL_GPL() like
bio_crypt_set_ctx() and friends?

>=20
> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index 04035d237f03..32c720aabba7 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -26,9 +26,6 @@ int blk_crypto_sysfs_register(struct gendisk *disk);
> =20
>  void blk_crypto_sysfs_unregister(struct gendisk *disk);
> =20
> -void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> -			     unsigned int inc);
> -
>  bool bio_crypt_rq_ctx_compatible(struct request *rq, struct bio *bio);
> =20
>  bool bio_crypt_ctx_mergeable(struct bio_crypt_ctx *bc1, unsigned int bc1=
_bytes,
> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 33ae52b77522..c9f436b6b2ef 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
> @@ -181,6 +181,9 @@ bool bio_crypt_dun_is_contiguous(const struct bio_cry=
pt_ctx *bc,
>  				 unsigned int bytes,
>  				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
> =20
> +void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> +			     unsigned int inc);
> +
>  int blk_crypto_init_key(struct blk_crypto_key *blk_key,
>  			const u8 *key_bytes, size_t key_size,
>  			enum blk_crypto_key_type key_type,
> --=20
> 2.34.1
>=20

--PEA6fpBf2bNc3JFu
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXI+YACgkQnKSrs4Gr
c8iM3Qf/XFmILiCbeSjbXunU0k6T8u+dWvrzWNhq4pxK9Sj3ejQwcBFSp0YgWTeP
huZvq2kGaf90TF7mw48y1hF3UnUHN9YCdADHFCePBQjaUsXeCtVguebgzFhhqvCe
govoIFLmGhVjuU08W4/32X2McSZm/RU7nEaXkwX8baWQGmT6OJeteJsng7GyyCWW
FHCOoHLTI3UKR40LJrijN1S/cnP/vZvYMs9X2LCwGmHua5uaTdoI0APEWwH34397
u7yXS7G74oYNxIFC3zuqZ2ikoZQ7LDpNqrlTb4WttYP1sOhForEze0lQO6gFt/s/
8Iyi2gjGMdOLc56RWntVSrqktDwQYA==
=lhw/
-----END PGP SIGNATURE-----

--PEA6fpBf2bNc3JFu--

