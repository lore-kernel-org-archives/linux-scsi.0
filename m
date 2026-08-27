Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CDA4908B0;
	Thu, 27 Aug 2026 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847899; cv=none; b=jwVsSRly6dSFut4ALSR4JvdJ7iwJ9q2agZEySdVTlwTgjQGfGre89CSZE1aKNxyHLQDxSS91bkwiZSyucLkDnOtz/oZKv3hZSoA2rjihisvjj637KqeFN51u5Wvd1UfsYRFTfQOxQfmz+rzgXvPDX3iwn+DOps5AtZL8kujTCUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847899; c=relaxed/simple;
	bh=CAf0QfGnvd9nvXOrd1pCQkzNlHxH6VQQFndUQmmrBt0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QRfh/skjfOa/AiL2e1omVT8LXMrVXecnrp2RS4lRniQpXUzIBBWxncWuPnHAOQnkMoN7KJ42S3YzS9EiNxtweMKWqGmULROT6AXKHF/9QH3u3So3IDBnyxzF29tL5P1c2H1SHo8cPi6gmEn0DxtwSMXfcYudiI04eqO8M+CRZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/nLu8wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/nLu8wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3FD1F00ADB;
	Thu, 27 Aug 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847897;
	bh=or5i9lW2C+pYU+NoS0VmRfRlCEfl6vfA7FQaObPSp9A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l/nLu8wn8kcy3DuRd1iAWhCkpBzXCTijHFKYmTg6TiFnPfCw627L0KmlC67fMeMBM
	 Yxh/HwtX7bz6vvkuBTBL983b4OyKbG43H0JUZTcsUub6SABX/9gNvVAIXrzKHAW9LS
	 fzFAzro/ezLMEAX7CSKJpbzExOWkx8lxs1ZJ/eIGwT+j8AmlvVFYcJ3fbLhFs0EFOd
	 waKB51NF8GtYDsyV6MFM2okeoDqvx2wWdgdeZSOpdn55Jy+U5AMXtzJ6ksQrO156CK
	 0/fbDnFFiCyzHHeGubZZwZx4wVvb4Bq0Qaxw9V2F+L3Hl29IMUYTtYk5e8jh3heLEO
	 KGyCqv6Q/bSPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 02/11] soc: qcom: add crypto_virt backend for
 virtio-blk inline crypto
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260827160806.1295313-3-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-3-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:24:56 +0000
Message-Id: <20260827162456.DF3FD1F00ADB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing `key_type` validation and endianness conversion in `crypto=
_virt_program_key()` allows raw keys to be programmed incorrectly.
- [High] `keyslot_program` callback triggers a `GFP_KERNEL` memory allocati=
on on the bio submission path, causing a potential memory reclaim deadlock.
- [Medium] Kernel log spam (DoS) via unratelimited error printing on invali=
d key derivation.
--

commit 2e7401200408cdbaa703d51ece5e8968e39837e3
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

soc: qcom: add crypto_virt backend for virtio-blk inline crypto

The commit adds the QCOM_CRYPTO_VIRT driver to support virtio-blk inline
crypto in a Qualcomm GVM environment. It maps keyslot programming and evict=
ion
to SCM calls, offloading hardware operations to Trust Zone.

> diff --git a/drivers/soc/qcom/crypto_virt.c b/drivers/soc/qcom/crypto_vir=
t.c
> new file mode 100644
> index 0000000000000..4ee2a36af6c1f
> --- /dev/null
> +++ b/drivers/soc/qcom/crypto_virt.c
> @@ -0,0 +1,89 @@

[ ... ]

> +static int crypto_virt_program_key(const struct blk_crypto_key *key,
> +				   unsigned int slot)
> +{
> +	u32 dus_512_units;
> +	int ret;

[ ... ]

> +	/* qcom_scm_ice_set_key()'s data_unit_size is expressed in 512-byte uni=
ts */
> +	dus_512_units =3D key->crypto_cfg.data_unit_size / 512;
> +
> +	ret =3D qcom_scm_ice_set_key(slot, key->bytes, key->size,
> +		QCOM_SCM_ICE_CIPHER_AES_256_XTS, dus_512_units);

[Severity: High]
Does this code need to validate that the key is a hardware-wrapped key, or =
apply
the hardware-mandated endianness swap for standard keys before passing the =
key
buffer directly to the SCM call?

[Severity: High]
Could this SCM call, which allocates memory internally via
qcom_tzmem_alloc(..., GFP_KERNEL), trigger a memory reclaim deadlock?

Since this function serves as the keyslot_program profile callback, it exec=
utes
in the IO submission path where FS/IO reclaim is strictly forbidden. Should
this allocation be wrapped with memalloc_noio_save() to prevent direct recl=
aim
from attempting another bio submission?

> +	if (ret)
> +		pr_err("%s: slot=3D%u ret=3D%d\n", __func__, slot, ret);
> +
> +	return ret;
> +}

[ ... ]

> +static int crypto_virt_derive_sw_secret_key(const u8 *eph_key, size_t ep=
h_key_size,
> +					    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	int ret;
> +
> +	ret =3D qcom_scm_derive_sw_secret(eph_key, eph_key_size,
> +					sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
> +	if (ret =3D=3D -EIO || ret =3D=3D -EINVAL)
> +		ret =3D -EBADMSG; /* probably invalid key */
> +
> +	if (ret)
> +		pr_err("%s: ret=3D%d\n", __func__, ret);

[Severity: Medium]
Could this unratelimited error print in the direct execution path of a
user-triggerable key derivation failure allow an attacker to trivially spam
the kernel logs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D2
