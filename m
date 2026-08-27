Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A243A813;
	Thu, 27 Aug 2026 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847822; cv=none; b=g1/2iCbfhbB81Z4lpqNaFAJp0KEjRaRKUzjqXJVeozwnEHsnlIDfRzFOtjKAZqJBdCJRfYuXekqSOrHDsykJI6HBDWXnQWR9Nq/qKU0vYTup5bXB/EttqjqUIDKmIxcLpiHeWMjuNpRtFjjvG6vJNbADHn0+MRs4X5uEOg46QSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847822; c=relaxed/simple;
	bh=ASsr8CJ1pBBlhRwZiWMTS/aOyYihh+0kBd42uRhfAtY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UoVr3r0nNIGUrLGRw2ZX7ClKTxDKKhuLDjpWKqrOcRdugt02pferHE4MDDJzMMZbqGGMrKsT0/sC356xO2j9VCpnkCUpLpEVUXeBN3Y18EcNgbZYKmTXBZ2eAlwJ53YwY+iY/av0OujWvaG+NoXenxIexCaDXW/vU+A4BEwrM18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1LjnbGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1LjnbGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9DC1F00A3A;
	Thu, 27 Aug 2026 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847820;
	bh=M28tsMtXsRjJPwNiY8/DzqPv+2sqwDD5bYAyGEZXEiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k1LjnbGRI2w8yxBYZf/p0mTBRxRXiHYOK8TSo6uqsDuQ9uIERUx8WtNY9iB/sW/Rd
	 hDhoh+HS1ASWaDmlNnp/6+tnCWveFpveCWoka6J2gXquZlnSrZ7RixXLLXaNOay9uD
	 tymjgEIqXsMg96F5FGY3Zlq9D0Z4pu8PTzctuUmYNZaUCqHUBmtek5PejxWuPBzsJK
	 PjohgB4jgL6Y+og0G1XkFd/nkL7a8OMIKfeXhxh2YDJP4ZpS8Daw1qjTqtzOh8/Lxd
	 bQwerkaRbQT1bxZeJEyluXdVxGWi0Z0BmwpLENqTfcb+Txb+0Z/DfCm1P5pB2NPYGR
	 ORL35sdAIOsjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 01/11] virtio_blk: add inline encryption support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: robh@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:23:40 +0000
Message-Id: <20260827162340.5A9DC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] The singleton inline crypto profile stores a pointer to the first =
probed virtio-blk device, leading to a Use-After-Free when that device is u=
nbound.
- [Medium] Missing validation of crypto_modes_supported when reusing the si=
ngleton blk_crypto_profile across multiple devices.
- [Low] Accessing `req->crypt_ctx` and `req->crypt_keyslot` without `#ifdef=
 CONFIG_BLK_INLINE_ENCRYPTION` breaks compilation when inline encryption is=
 disabled.
- [Low] A reversed Kconfig dependency between VIRTIO_BLK and VIRTBLK_CRYPTO=
_VIRTUALIZATION causes a vmlinux linkage failure when VIRTIO_BLK is built-i=
n and the extension is a module.
--

commit a4edc1b4437c893d0130908c0c7ae81f9e6802b0
Author: linlzhan <linlzhan@qti.qualcomm.com>

virtio_blk: add inline encryption support

Negotiate VIRTIO_BLK_F_INLINE_ENCRYPTION with the host and wire it into
the block layer's inline-crypto framework to enable inline encryption
on virtio block device.

> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 858320b6ebb7e..7790ee2c700c4 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -312,6 +312,19 @@ config VIRTIO_BLK
>  	  This is the virtual block driver for virtio.  It can be used with
>            QEMU based VMMs (like KVM or Xen).  Say Y or M.
> =20
> +config VIRTBLK_CRYPTO_VIRTUALIZATION
> +	tristate "Virtio block inline encryption virtualization support"
> +	depends on VIRTIO_BLK && BLK_INLINE_ENCRYPTION

[Severity: Low]
Can this combination cause a linker error? If VIRTIO_BLK=3Dy and
VIRTBLK_CRYPTO_VIRTUALIZATION=3Dm, IS_ENABLED(CONFIG_VIRTBLK_CRYPTO_VIRTUAL=
IZATION)
evaluates to true in the built-in virtio_blk.o, causing it to call
virtblk_init_inline_crypto(). Since that function is in a separate module,
would this result in an undefined reference during the vmlinux link?

> +	help
> +	  Say 'Y or M' to enable routing of crypto requests to a different
> +	  operating system in a virtualized environment. This option by
> +	  itself does not provide a working backend: enable a
> +	  platform-specific driver that implements struct
> +	  virtblk_crypto_variant_ops as well (e.g. QCOM_CRYPTO_VIRT on
> +	  Qualcomm platforms). Without one, VIRTIO_BLK_F_INLINE_ENCRYPTION is
> +	  still negotiated and advertised to the block layer, but every
> +	  inline-crypto operation fails with -EOPNOTSUPP at runtime.
> +
>  config BLK_DEV_RBD
>  	tristate "Rados block device (RBD)"
>  	depends on INET && BLOCK
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 32bf3ba07a9dc..61a3967bb4dfe 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c

[ ... ]

> @@ -235,6 +249,15 @@ static void virtblk_cleanup_cmd(struct request *req)
>  		kfree(bvec_virt(&req->special_vec));
>  }
> =20
> +static bool is_crypto_request(struct virtio_device *vdev, struct request=
 *req)
> +{
> +	if (!IS_ENABLED(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) ||
> +	    !virtio_has_feature(vdev, VIRTIO_BLK_F_INLINE_ENCRYPTION))
> +		return false;
> +
> +	return req->crypt_ctx && req->crypt_keyslot;

[Severity: Low]
Does this cause a build failure when CONFIG_BLK_INLINE_ENCRYPTION is disabl=
ed?
Even though is_crypto_request() returns false, the compiler still evaluates
req->crypt_ctx and req->crypt_keyslot. Since these fields are conditionally
compiled out of struct request without inline encryption, accessing them he=
re
and in virtblk_setup_cmd() might break the build.

> +}
> +
>  static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
>  				      struct request *req,
>  				      struct virtblk_req *vbr)

[ ... ]

> @@ -309,8 +339,8 @@ static blk_status_t virtblk_setup_cmd(struct virtio_d=
evice *vdev,
> =20
>  	/* Set fields for non-REQ_OP_DRV_IN request types */
>  	vbr->in_hdr_len =3D in_hdr_len;
> -	vbr->out_hdr.type =3D cpu_to_virtio32(vdev, type);
> -	vbr->out_hdr.sector =3D cpu_to_virtio64(vdev, sector);
> +	vbr->out_hdr.base.type =3D cpu_to_virtio32(vdev, type);
> +	vbr->out_hdr.base.sector =3D cpu_to_virtio64(vdev, sector);
> =20
>  	if (type =3D=3D VIRTIO_BLK_T_DISCARD || type =3D=3D VIRTIO_BLK_T_WRITE_=
ZEROES ||
>  	    type =3D=3D VIRTIO_BLK_T_SECURE_ERASE) {
> @@ -318,6 +348,17 @@ static blk_status_t virtblk_setup_cmd(struct virtio_=
device *vdev,
>  			return BLK_STS_RESOURCE;
>  	}
> =20
> +	if (type =3D=3D VIRTIO_BLK_T_CRYPTO_IN || type =3D=3D VIRTIO_BLK_T_CRYP=
TO_OUT) {
> +		unsigned int slot =3D blk_crypto_keyslot_index(req->crypt_keyslot);
> +		unsigned int data_unit_size_bits =3D req->crypt_ctx->bc_key->data_unit=
_size_bits;
> +		u64 dun =3D req->crypt_ctx->bc_dun[0];

[Severity: Low]
Does this also cause a build failure when CONFIG_BLK_INLINE_ENCRYPTION is
disabled, since these conditionally compiled struct fields are directly
accessed without preprocessor guards?

> +
> +		vbr->out_hdr.crypto_append.msg.slot =3D cpu_to_virtio32(vdev, slot);
> +		vbr->out_hdr.crypto_append.msg.data_unit_size_bits =3D
> +				cpu_to_virtio32(vdev, data_unit_size_bits);
> +		vbr->out_hdr.crypto_append.msg.dun =3D cpu_to_virtio64(vdev, dun);
> +	}
> +
>  	return 0;
>  }
> =20
> diff --git a/drivers/block/virtio_blk_crypto_ext.c b/drivers/block/virtio=
_blk_crypto_ext.c
> new file mode 100644
> index 0000000000000..00b6d410d3036
> --- /dev/null
> +++ b/drivers/block/virtio_blk_crypto_ext.c

[ ... ]

> +int virtblk_init_inline_crypto(unsigned int max_slots, unsigned int max_=
dun_bytes,
> +			       unsigned int key_types,
> +			       const unsigned int crypto_modes_supported[BLK_ENCRYPTION_MODE_=
MAX],
> +			       struct device *dev)
> +{
> +	struct blk_crypto_profile *profile =3D &g_vdcp.profile;
> +	unsigned int key_type_supported =3D 0;
> +	int err =3D 0;
> +
> +	dev_info(dev, "probing inline crypto capabilities\n");
> +
> +	mutex_lock(&virtblk_crypto_init_lock);
> +
> +	/*
> +	 * profile is a single, process-wide blk_crypto_profile shared by every
> +	 * VIRTIO_BLK_F_INLINE_ENCRYPTION device. Only the first device to get
> +	 * here actually initializes it; any other device just reuses it as-is
> +	 * if its negotiated capabilities match. A mismatch means this device's
> +	 * capabilities don't actually correspond to what the shared profile
> +	 * was set up for (wrong keyslot count, DUN size, or key types), which
> +	 * is a correctness/security concern, not just a cosmetic one -- fail
> +	 * instead of silently registering a profile that doesn't match what
> +	 * this device supports.
> +	 */
> +	if (g_crypto_profile_initialized) {
> +		if (max_slots !=3D g_max_slots || max_dun_bytes !=3D g_max_dun_bytes ||
> +		    key_types !=3D g_key_types) {

[Severity: Medium]
Does this logic skip validating the negotiated crypto_modes_supported array?
If a second device supports different cryptographic modes than the first on=
e,
could it silently inherit the first device's modes, potentially causing the
block layer to send unsupported crypto requests?

> +			dev_warn(dev,
> +				 "inline crypto profile already initialized by %s (max_slots=3D%u ma=
x_dun_bytes=3D%u key_types=3D0x%x); "
> +				 "this device reports max_slots=3D%u max_dun_bytes=3D%u key_types=3D=
0x%x -- sharing one "
> +				 "blk_crypto_profile across multiple VIRTIO_BLK_F_INLINE_ENCRYPTION =
devices with differing "
> +				 "capabilities is not supported, refusing to enable inline crypto fo=
r this device\n",
> +				 dev_name(virtblk_profile_owner), g_max_slots, g_max_dun_bytes, g_ke=
y_types,
> +				 max_slots, max_dun_bytes, key_types);
> +			err =3D -EINVAL;
> +		}
> +		goto out_unlock;
> +	}
> +
> +	if (key_types & VIRTIO_BLK_CRYPTO_KEY_TYPE_RAW)
> +		key_type_supported |=3D BLK_CRYPTO_KEY_TYPE_RAW;
> +	if (key_types & VIRTIO_BLK_CRYPTO_KEY_TYPE_HW_WRAPPED)
> +		key_type_supported |=3D BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
> +
> +	err =3D blk_crypto_profile_init(profile, max_slots);
> +	if (err) {
> +		dev_err(dev, "crypto profile initialization failed: %d\n", err);
> +		goto out_unlock;
> +	}
> +
> +	profile->ll_ops =3D virtblk_crypto_ops;
> +	profile->max_dun_bytes_supported =3D max_dun_bytes;
> +	profile->key_types_supported =3D key_type_supported;
> +	profile->dev =3D dev;
> +	memcpy(profile->modes_supported, crypto_modes_supported,
> +	       BLK_ENCRYPTION_MODE_MAX * sizeof(unsigned int));
> +
> +	virtblk_profile_owner =3D dev;

[Severity: High]
Can this lead to a use-after-free?

profile->dev stores a pointer to the first probed virtio-blk device in a
globally shared singleton. If this device is hot-unplugged or unbound,
its struct device is freed.

When a subsequent device performs a crypto operation, could blk_crypto_hw_e=
nter()
dereference this freed pointer when calling pm_runtime_get_sync(profile->de=
v)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D1
