Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F5D4A0915
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788289610; cv=none; b=f3lrcdGzP9iGfIMhxRPSaGN5U15cUxp3noYnbO7LRQYzf56d5zklD5hlvVZldJOLWEMh3UJf9SVn/EcJgCoD6MkKvJfuQyoxiuqDgFdxTaGH6+U1lfy8GjAqQEQ9uv4rH68ZT4EAjAJvJfdAlVC9eqYRmWSaoEksDXsJg5EDwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788289610; c=relaxed/simple;
	bh=NL8uP9mXcv5YlmIYafsmjVCCgsE5TReqtVLIrXALZkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuXozb7N2FO7MJxGo/+7KluMt7A0XByeGHXuZQubgs94w/a2nMkPBIhwiUJzE3B8ud6h85fkEcbWtJOsicZxs2GFEd3bEzRhirKH9Y0UKywBKpHIV7P8fBzkAlhPPhjCeJn8g4cnhZJHVmD/IAxpCFcSPkmaUNiN8vrqREcose0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+pVPgac; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+pVPgac"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788289606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rpR05mO04ugLQKCafQxRkfUKWWr5jCrxssepYzcFjvk=;
	b=Y+pVPgacV4tbOhSeRTXti2y6do/Olehwt0XQHX7m0+6rHBvTL8eQVZbgAPZ8xhLGG0I/gj
	NGpHfb4T1GNvozmLO3HvwTXlBzc1lZEIYpV08YsSGtA/6uEU9eKNaftjMQ1I3V7rFdU0d1
	e2DSBd28Bf2sjGcWECDveD3M9wXf5Zg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-XNm1M7c8Nge7KOvuIaRshg-1; Tue,
 01 Sept 2026 15:06:42 -0400
X-MC-Unique: XNm1M7c8Nge7KOvuIaRshg-1
X-Mimecast-MFC-AGG-ID: XNm1M7c8Nge7KOvuIaRshg_1788289599
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE9CD1944F10;
	Tue,  1 Sep 2026 19:06:38 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21A971800257;
	Tue,  1 Sep 2026 19:06:36 +0000 (UTC)
Date: Tue, 1 Sep 2026 15:06:35 -0400
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
Subject: Re: [PATCH v1 05/11] blk-crypto: add slot-based inline encryption
 path
Message-ID: <20260901190635.GA729142@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-6-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wKZb190Ph5vaNUIG"
Content-Disposition: inline
In-Reply-To: <20260827160806.1295313-6-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

--wKZb190Ph5vaNUIG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 09:07:14AM -0700, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>=20
> For the virtio-blk inline encryption use case, the guest kernel goes
> through the normal blk_crypto_key programming flow via SMC call in a
> virtual slot format before I/O starts.  It then requests the host to
> handle that I/O with the key programmed into the corresponding physical
> keyslot.

Just a note for other reviewers: This patch is specific to the
out-of-band key slot programming approach taken in this series. We are
discussing in-band key slot programming where this patch probably won't
be necessary.

I am skipping this patch for now.

>=20
> Introduce a "slot path" that lets a bio carry a pre-programmed physical
> ICE keyslot index rather than a blk_crypto_key pointer.  Add struct
> blk_crypto_slot, containing the physical slot index (phy_slot) and
> data_unit_size_bits, and embed it in struct bio_crypt_ctx alongside the
> existing bc_key pointer.  A NULL bc_key indicates the slot path.
>=20
> Provide bio_crypt_set_ctx_by_slot() as the caller-facing API for this
> path.  Update the internal consumers of bio_crypt_ctx to handle both
> paths:
>=20
>   - __bio_crypt_advance() and bio_crypt_dun_is_contiguous() use
>     bc_slot.data_unit_size_bits to update the DUN when bc_key is NULL.
>   - bio_crypt_ctx_compatible() compares phy_slot and data_unit_size_bits
>     when bc_key is NULL, preserving request-merging for slot-based bios.
>   - __blk_crypto_submit_bio() short-circuits for the slot path: if the
>     device exposes a crypto_profile the bio is passed through as-is;
>     otherwise it fails with BLK_STS_NOTSUPP.  The software fallback is
>     not attempted since the guest has no key material.
>   - blk_crypto_rq_get_keyslot() skips kernel-side keyslot allocation
>     when bc_key is NULL.
>=20
> There is no functional change to the existing key-based path.
>=20
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  block/blk-crypto-internal.h |  2 +-
>  block/blk-crypto.c          | 57 ++++++++++++++++++++++++++++++++++---
>  include/linux/blk-crypto.h  | 25 ++++++++++++++++
>  3 files changed, 79 insertions(+), 5 deletions(-)
>=20
> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index 2c7a0446572a..04035d237f03 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -176,7 +176,7 @@ static inline void bio_crypt_do_front_merge(struct re=
quest *rq,
>  blk_status_t __blk_crypto_rq_get_keyslot(struct request *rq);
>  static inline blk_status_t blk_crypto_rq_get_keyslot(struct request *rq)
>  {
> -	if (blk_crypto_rq_is_encrypted(rq))
> +	if (blk_crypto_rq_is_encrypted(rq) && rq->crypt_ctx->bc_key)
>  		return __blk_crypto_rq_get_keyslot(rq);
>  	return BLK_STS_OK;
>  }
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index bc3a9f59574b..2212d06d3c11 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -113,11 +113,31 @@ void bio_crypt_set_ctx(struct bio *bio, const struc=
t blk_crypto_key *key,
> =20
>  	bc->bc_key =3D key;
>  	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
> +	memset(&bc->bc_slot, 0, sizeof(bc->bc_slot));
> =20
>  	bio->bi_crypt_context =3D bc;
>  }
>  EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
> =20
> +void bio_crypt_set_ctx_by_slot(struct bio *bio,
> +			       const struct blk_crypto_slot *slot,
> +			       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> +			       gfp_t gfp_mask)
> +{
> +	struct bio_crypt_ctx *bc;
> +
> +	WARN_ON_ONCE(!(gfp_mask & __GFP_DIRECT_RECLAIM));
> +
> +	bc =3D mempool_alloc(bio_crypt_ctx_pool, gfp_mask);
> +
> +	bc->bc_key =3D NULL;
> +	bc->bc_slot =3D *slot;
> +	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
> +
> +	bio->bi_crypt_context =3D bc;
> +}
> +EXPORT_SYMBOL_GPL(bio_crypt_set_ctx_by_slot);
> +
>  void __bio_crypt_free_ctx(struct bio *bio)
>  {
>  	mempool_free(bio->bi_crypt_context, bio_crypt_ctx_pool);
> @@ -156,8 +176,12 @@ void __bio_crypt_advance(struct bio *bio, unsigned i=
nt bytes)
>  {
>  	struct bio_crypt_ctx *bc =3D bio->bi_crypt_context;
> =20
> -	bio_crypt_dun_increment(bc->bc_dun,
> -				bytes >> bc->bc_key->data_unit_size_bits);
> +	if (bc->bc_key)
> +		bio_crypt_dun_increment(bc->bc_dun,
> +					bytes >> bc->bc_key->data_unit_size_bits);
> +	else if (bc->bc_slot.data_unit_size_bits)
> +		bio_crypt_dun_increment(bc->bc_dun,
> +					bytes >> bc->bc_slot.data_unit_size_bits);
>  }
> =20
>  /*
> @@ -169,7 +193,14 @@ bool bio_crypt_dun_is_contiguous(const struct bio_cr=
ypt_ctx *bc,
>  				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE])
>  {
>  	int i;
> -	unsigned int carry =3D bytes >> bc->bc_key->data_unit_size_bits;
> +	unsigned int carry;
> +
> +	if (bc->bc_key)
> +		carry =3D bytes >> bc->bc_key->data_unit_size_bits;
> +	else if (bc->bc_slot.data_unit_size_bits) {
> +		carry =3D bytes >> bc->bc_slot.data_unit_size_bits;
> +	} else
> +		return false;
> =20
>  	for (i =3D 0; i < BLK_CRYPTO_DUN_ARRAY_SIZE; i++) {
>  		if (bc->bc_dun[i] + carry !=3D next_dun[i])
> @@ -198,7 +229,12 @@ static bool bio_crypt_ctx_compatible(struct bio_cryp=
t_ctx *bc1,
>  	if (!bc1)
>  		return !bc2;
> =20
> -	return bc2 && bc1->bc_key =3D=3D bc2->bc_key;
> +	if (bc1->bc_key)
> +		return bc2 && bc1->bc_key =3D=3D bc2->bc_key;
> +	else
> +		return bc2 && !bc2->bc_key &&
> +		       bc1->bc_slot.phy_slot =3D=3D bc2->bc_slot.phy_slot &&
> +		       bc1->bc_slot.data_unit_size_bits =3D=3D bc2->bc_slot.data_unit_=
size_bits;
>  }
> =20
>  bool bio_crypt_rq_ctx_compatible(struct request *rq, struct bio *bio)
> @@ -260,6 +296,19 @@ bool __blk_crypto_submit_bio(struct bio *bio)
>  		return false;
>  	}
> =20
> +	if (!bc_key) {
> +		/*
> +		* Slot path: the ICE keyslot was pre-programmed by the
> +		* hypervisor. The target device must natively support inline
> +		* encryption; there is no fallback for slot-based crypto.
> +		*/
> +		if (!bdev_get_queue(bdev)->crypto_profile) {
> +			bio_endio_status(bio, BLK_STS_NOTSUPP);
> +			return false;
> +		}
> +		return true;
> +	}
> +
>  	/*
>  	 * If the device does not natively support the encryption context, try =
to use
>  	 * the fallback if available.
> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 938ff536838c..33ae52b77522 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
> @@ -119,9 +119,28 @@ struct blk_crypto_key {
>  #define BLK_CRYPTO_MAX_IV_SIZE		32
>  #define BLK_CRYPTO_DUN_ARRAY_SIZE	(BLK_CRYPTO_MAX_IV_SIZE / sizeof(u64))
> =20
> +/**
> + * struct blk_crypto_slot - physical slot context for slot-based inline =
crypto
> + * @phy_slot:           Physical ICE keyslot index (already resolved fro=
m virt).
> + * @data_unit_size_bits: log2 of the encryption data unit size; used by
> + *                       __bio_crypt_advance() to increment the DUN corr=
ectly
> + *                       when a bio is split.  0 means unknown/unset.
> + *
> + * Used when a bio carries inline crypto context by physical slot index =
rather
> + * than by a blk_crypto_key pointer (i.e. bc_key =3D=3D NULL in bio_cryp=
t_ctx).
> + * Set by crypto_vblk when building the bio for a GVM VIRTIO_BLK_T_CRYPT=
O_IN/OUT
> + * request; left zeroed for all other bio types.
> + */
> +struct blk_crypto_slot {
> +	unsigned int phy_slot;
> +	unsigned int data_unit_size_bits;
> +};
> +
>  /**
>   * struct bio_crypt_ctx - an inline encryption context
>   * @bc_key: the key, algorithm, and data unit size to use
> + * @bc_slot: physical slot + data_unit_size_bits for slot-based crypto
> + *           (used when bc_key =3D=3D NULL)
>   * @bc_dun: the data unit number (starting IV) to use
>   *
>   * A bio_crypt_ctx specifies that the contents of the bio will be encryp=
ted (for
> @@ -130,6 +149,7 @@ struct blk_crypto_key {
>   */
>  struct bio_crypt_ctx {
>  	const struct blk_crypto_key	*bc_key;
> +	struct blk_crypto_slot		 bc_slot;
>  	u64				bc_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
>  };
> =20
> @@ -152,6 +172,11 @@ void bio_crypt_set_ctx(struct bio *bio, const struct=
 blk_crypto_key *key,
>  		       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
>  		       gfp_t gfp_mask);
> =20
> +void bio_crypt_set_ctx_by_slot(struct bio *bio,
> +			       const struct blk_crypto_slot *slot,
> +			       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> +			       gfp_t gfp_mask);
> +
>  bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
>  				 unsigned int bytes,
>  				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
> --=20
> 2.34.1
>=20

--wKZb190Ph5vaNUIG
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXIjsACgkQnKSrs4Gr
c8gIsAgAjxY1AuCye1sw9H4sjqZsfj0jPTgKoNqMfnOBNaQiIfFkrD6/oOL8BMg6
JFz5bBHobx5DmK+dDZE65Hku8bMijIzZ9ZOueGjQuXv83InuB60l6tHqtVDXkbE9
jETy31d+aBbBbP76d9iwJQ/X2AdqywtaN6J9O5jr1sOPv1wxh2SAFacqLDWZWL+B
n86AKJzAkA6iAxqTWuTAJ0CtngqbNaPpV3x/Amp1n1H61fT/hs8k/6HECuQMJ4At
5Q0ODPOBUhPD5BapzzgzzAFfMdWLIvMeHdwMIq2VPLERD4yz46VlQRy5TiqFIqOF
R+UoasO0aVBF4KdvWhDuu0d3lYIdDw==
=bouA
-----END PGP SIGNATURE-----

--wKZb190Ph5vaNUIG--

