Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DFB41E6C0;
	Thu, 27 Aug 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787848020; cv=none; b=g0cvgtzTnx/nXqHtXE+EcBSa9olE+5oOorpnN2wRduKjA8NSn+eoLDtKJVI494rTMdxnpUDe3kIBNnxluDp68xR9vFehX0Wqn097Bmx89eMpkI121EqHjJmv/A5P3b1Bn6+ym0C/9qqlLQ3tpwJ+ELTATppSStEqjFX0aSgU0Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787848020; c=relaxed/simple;
	bh=gAdJXDRpYEMMfANpfQ3gpkV9HRAngObsmbAWocXYzbk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QM3IL+qcXJ3PW+qSamCAwLG++xjHW8c/LzTS1Nk507NsCOqzpHeS5qWs3zR2nc7EVUkjWnLve5OAHwDWoLEOOsMeyB5Dhzt5XpJ2kEfoIOwLt89Y17Bi6BgiBcmYyu7QVn2b/rahSaVrYCQ+L8BTwNv2FHbI/WglkQgq92UdNWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMYLaqQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMYLaqQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0131F000E9;
	Thu, 27 Aug 2026 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787848019;
	bh=Lvw/o5uIn8t0KutwqrHBSFx2SbtdFgUpMJWjvUXVS5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LMYLaqQmQaZvBK2Wm0ZgqRIhePk6kVUE7RdMsOJC2DnZ2XCU75D5ENoQmp8r8RnQ8
	 4CoXeoa9EdLHvAoipE/XrTPxaWVImdbYq2LRcY2mhvhHhP2Fuc+BDyrLSHbpoRYw7E
	 PWf5gihTpckKfdIGX0kL9/FZ1NNwvkEGQDNyb+mfJWUwarzrBuiy7Hy2trpWuQIHk5
	 LVt8pyskM0x7ip7qFQC3eNGTCU9GGoENqNmBvidjYnZSTNz9M5eq0d5aZ5ZcUKF90a
	 suuyZ7J9Eyy+kRY1ih/KaRBCusr65k+l/6KMKg2E9+5xR978VH37YNwBUwW/7cGYV5
	 eOGuMvqf9AmyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 05/11] blk-crypto: add slot-based inline encryption
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260827160806.1295313-6-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-6-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:26:58 +0000
Message-Id: <20260827162658.CB0131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Multiple core block layer and driver functions unconditionally=
 dereference the `bc_key` pointer in a bio's crypto context for slot-based =
bios, leading to kernel panics.
- [High] Standard block drivers fail to retrieve a keyslot for slot-path bi=
os and silently drop encryption, leading to incorrectly encrypted data bein=
g written to disk.
- [High] Bio splitting causes silent Initialization Vector (IV) reuse and b=
reaks cryptographic confidentiality if `data_unit_size_bits` is 0.
- [High] Missing bounds check on `data_unit_size_bits` causes Undefined Beh=
avior during bit shift operations.
--

commit ecf24121b79d01c98765828aa3d5cd87595d9349
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

blk-crypto: add slot-based inline encryption path

For the virtio-blk inline encryption use case, the guest kernel goes
through the normal blk_crypto_key programming flow via SMC call in a
virtual slot format before I/O starts.  It then requests the host to
handle that I/O with the key programmed into the corresponding physical
keyslot.

> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index 2c7a0446572aa..04035d237f039 100644
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

[ ... ]

> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index bc3a9f59574b1..2212d06d3c112 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
[ ... ]
> @@ -113,11 +113,31 @@ void bio_crypt_set_ctx(struct bio *bio, const struc=
t blk_crypto_key *key,
[ ... ]
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

[Severity: Critical]
If we set bc_key to NULL here for slot-based bios, will this cause kernel
panics in core block layer and driver functions that unconditionally
dereference it?

For example, when submit_bio_noacct() calls blk_crypto_supported(), it
evaluates &bio->bi_crypt_context->bc_key->crypto_cfg and passes a NULL
pointer:

block/blk-crypto-internal.h:blk_crypto_supported() {
    ...
    return blk_crypto_config_supported_natively(bio->bi_bdev,
                    &bio->bi_crypt_context->bc_key->crypto_cfg);
}

The native configuration check then dereferences this config, causing an
immediate crash.

Similarly, won't functions like bio_split_io_at() in block/blk-merge.c
unconditionally dereference bc_key when constructing DMA alignment masks?

block/blk-merge.c:bio_split_io_at() {
    ...
    start_align_mask |=3D (bc->bc_key->crypto_cfg.data_unit_size - 1);
    ...
}

And virtblk_setup_cmd() in drivers/block/virtio_blk.c also appears to
blindly dereference it:

drivers/block/virtio_blk.c:virtblk_setup_cmd() {
    ...
    unsigned int data_unit_size_bits =3D req->crypt_ctx->bc_key->data_unit_=
size_bits;
    ...
}

Could a guest VM trigger this trivially via the host proxy?

> +	bc->bc_slot =3D *slot;
> +	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
> +
> +	bio->bi_crypt_context =3D bc;
> +}
> +EXPORT_SYMBOL_GPL(bio_crypt_set_ctx_by_slot);
> +

[ ... ]

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

[Severity: High]
If an untrusted guest proxy provides a data_unit_size_bits of 0, won't this
condition silently bypass incrementing the DUN array?

If a bio exceeds hardware limits, bio_split_io_at() splits it and calls
__bio_crypt_advance(). If the increment is bypassed, both halves of the
split bio would be submitted to hardware using the exact same Initialization
Vector (IV) for different data sectors. Does this silent IV reuse break
cryptographic confidentiality?

> +		bio_crypt_dun_increment(bc->bc_dun,
> +					bytes >> bc->bc_slot.data_unit_size_bits);

[Severity: High]
Additionally, is there a missing bounds check on data_unit_size_bits here?

If a guest provides a value of 32 or greater, this right shift on the 32-bit
bytes unsigned integer will trigger undefined behavior.

>  }

[ ... ]

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

[Severity: High]
If we allow the bio to proceed to the low-level driver here, are standard
block drivers prepared to handle a NULL keyslot for slot-based bios?

Because blk_crypto_rq_get_keyslot() bypasses allocation when bc_key is
NULL, req->crypt_keyslot will be uninitialized. In drivers like MMC,
this NULL keyslot is ignored, failing to populate the physical keyslot inde=
x:

drivers/mmc/core/crypto.c:mmc_crypto_prepare_req() {
    ...
    keyslot =3D req->crypt_keyslot;
    if (keyslot)
        mrq->crypto_key_slot =3D blk_crypto_keyslot_index(keyslot);
    ...
}

This leaves the internal keyslot index defaulting to 0. Will this hardware
proceed encrypting with keyslot 0, leading to data corruption or a silent
leak of poorly encrypted data?

> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D5
