Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66736A004;
	Thu, 27 Aug 2026 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847598; cv=none; b=DEQaY3hJPR+MV6pHLTy30mSHAwyPJNh9dVI21bSgPVqlf7xKXkxJb8j3Kw5DMZBykzlMrYFj/4Ta/WEmkbxFZPPTSkrHvYoy4S+BEevBx+mYWtfZqO1SsPzQXBCrdUFfzif7Kq/NT1/8gMqubOheqrXRb6Mj998L9k8YYy6BAFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847598; c=relaxed/simple;
	bh=I6EwbYK82+Us6SL6ec1C1k04zXtMhFQYDY7D0UfejGU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dHF1OoVnP8uOv7oM45XlP+WMkTZs8z6w5Qha8qPsulDcpPKTkOZ+R3OfjGuGs7oHTmTSdJ1YKMhh6XSlc1OzM5dIa1nINCA2gUeDxOjuODUq8W+clZRiTVzrhEUDKrLTN9j2rd2aV9KBf6wio/aSKtYTj/wKi1oFVMxUHwErV7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeYQrfAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeYQrfAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C0B1F00A3A;
	Thu, 27 Aug 2026 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847596;
	bh=7cP0ZYUXZI80PHeDtaILEq3ALSOs1dSrM5l9Fe7cxlQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PeYQrfAhZ2yfKDtAXiP0GRnWXBxZImr8DgZ5GsX5gGAPB7x/uG+OuQx8iboZFrmMv
	 ZXjAGRlnHcVbqkynEvtg3H328/5kw1HF4GMbm6B2rSxU0KSilteXfgVes3TfqXZzoH
	 SLV05TwwuEkRYKiVWXDBqiY36VF6XjrABOJQ/2oG4DTEfiTdkKazm62Mxz0+vGUCz/
	 ll96yUICLbcU5c7kjZU4S4rjib8pCkW1ED983XscWPuCdEGgpIOsRJ1VF5b1a7QOa9
	 Q+ngPyQ70ZjS0AOWk1+pXQFGrx1vOuosz1XeexMDHS9T40yrOszb1V1DyQUcDCZL6Z
	 wbCIRwblA8vVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 03/11] soc: qcom: crypto_virt: add support for
 create, prepare and import keys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org
In-Reply-To: <20260827160806.1295313-4-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-4-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:19:56 +0000
Message-Id: <20260827161956.A7C0B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing QCOM SCM dependency check leads to NULL pointer dereference
- [Medium] Global state inheritance of `g_wrapped_key_size` across devices
- [Low] Unconditional registration of unsupported hardware-wrapped key oper=
ations
--

commit 4b3400c30fba3c871f1ea78eace978c0fff73f5a
Author: linlzhan <linlin.zhang@oss.qualcomm.com>
soc: qcom: crypto_virt: add support for create, prepare and import keys

This commit adds support for generating, preparing, and importing hardware
wrapped keys in the crypto_virt driver. It obtains the wrapped key size
from the "qcom,wrapped-key-size" property and enables SCM helpers.

> diff --git a/drivers/soc/qcom/crypto_virt.c b/drivers/soc/qcom/crypto_vir=
t.c
> index 4ee2a36af6c1f..93c7993fb4a5d 100644
> --- a/drivers/soc/qcom/crypto_virt.c
> +++ b/drivers/soc/qcom/crypto_virt.c
[ ... ]
> +static int crypto_virt_probe(struct platform_device *pdev)
>  {
> +	int ret;
> +

[Severity: High]
Should this probe function verify that the QCOM SCM driver is available
before proceeding?

Since the driver registers virtio block crypto operations here, userspace c=
an
issue block crypto ioctls as soon as this completes. If SCM is not yet read=
y,
a call to a function like qcom_scm_generate_ice_key() will unconditionally
dereference the uninitialized __scm pointer:

qcom_scm_generate_ice_key()
   void *lt_key_buf =3D qcom_tzmem_alloc(__scm->mempool, ...);

Could we add a check for qcom_scm_is_available() and return -EPROBE_DEFER
if it is not yet ready?

> +	ret =3D of_property_read_u32(pdev->dev.of_node, "qcom,wrapped-key-size",
> +				    &g_wrapped_key_size);
> +	if (ret)
> +		dev_warn(&pdev->dev, "qcom,wrapped-key-size not found\n");

[Severity: Medium]
Could this leak state between different probed devices?

Because g_wrapped_key_size is a static global variable, it retains its value
from previous probes. If a newly probed device is missing the
qcom,wrapped-key-size property, of_property_read_u32() returns an error
without modifying the output variable.

Would it be safer to zero-initialize g_wrapped_key_size before the read,
so that a device without this property doesn't accidentally inherit the
wrapped key size from a previously probed device?

> +
> +	if (!g_wrapped_key_size ||
> +	    g_wrapped_key_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE) {
> +		dev_err(&pdev->dev,
> +			"invalid qcom,wrapped-key-size %u, won't support generate/import/prep=
are hardware wrapped key\n",
> +			g_wrapped_key_size);
> +		g_wrapped_key_size =3D 0;
> +	}
> +
>  	virtblk_set_crypto_ops(&virtblk_crypto_qcom_vops);

[Severity: Low]
Does this code unconditionally register the hardware-wrapped key operations,
even when they are unsupported?

By registering virtblk_crypto_qcom_vops with non-NULL function pointers for
generate_key, prepare_key, and import_key, the block layer framework will
assume these capabilities are supported.

When invoked, the unsupported operations check for !g_wrapped_key_size and
return -EINVAL:

crypto_virt_generate_key() {
    ...
    if (!g_wrapped_key_size) {
        ...
        return -EINVAL;
    }
}

Should these operations either return the standard -EOPNOTSUPP, or avoid
being registered altogether when the feature is locally disabled?

>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D3
