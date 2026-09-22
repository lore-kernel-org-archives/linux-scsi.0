Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B85F2DC79B;
	Tue, 22 Sep 2026 07:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790063283; cv=none; b=Rx6aIKeslgmHrSJUTNwjFwXT9/wx72HXFgjZ3xrS0TV5twN1i0x0GzZKcmFWdvUhZraB2k9AWHg1O/v95vUw1I7DqZbo/+HeFxe5Cr+7DKkvZiOlp9SiwwBPzOY2eHFHYBXd9C4Gqkrfuuykz6UbRr3SutWP4kYrumsWEiG/vWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790063283; c=relaxed/simple;
	bh=lQsPYsbAPQ5pDzOqviHpFXvEmk6EvwmhbDS5PIp+ylM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nN6/Gc0lrPCIYbwK6k2JVo3ULQEquKgPsKNlWiMwUNWfp3wOQ+nizmDOk+JTbyfTXIcheC30o1Jz0UE/iHAW6DHF4NQr4TuQQOo1Ekw8CaAQHwWqqQXGTVBrQRBODvEfFzQZmNoCs582G8OtYQxWt6hHYLVr7Dd+qYNHNfRFTRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpJwJ95R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpJwJ95R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264A51F000FF;
	Tue, 22 Sep 2026 07:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790063277;
	bh=71BnTTBfDHUjWPKQkT4aD/X5LnAp5WIflUcNL5vzZuA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CpJwJ95RVd8Nj3Kb59r5Cj/9R19uj5XmD8hy40byF3h8SkL0b08jwriUrhhs2H+0p
	 yIZs4sn81BtCu0dIzkIrK7QeLCd6t0gplU/Koe+LUeCczb+BmD3a221eUzBtPGqaT1
	 e3Tsg/Y/fzeYGuO4HRYGV/Vpf22R2c7Vcl+gWxBYT2XcuP7Lz1LEKG4oiYpbdkbcG5
	 zhKzJ8ztiT8A4f4s2Qq2UuRlnFAByGVQu5EQi+RqyW0+D4h07cHv7b+2b41Lle13MH
	 2SlRML0CaNOoV9l7BVzJkgfxAHhoXuH/splGzdzOm1KKOiTAFlhP0ixfXwuWgQF71v
	 fngyMkxY/TlLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/12] scsi: ufs: dwc: Return a negative error if the
 link is down
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, imx@lists.linux.dev, Frank.Li@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260922073009.1449688-2-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
 <20260922073009.1449688-2-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 07:47:56 +0000
Message-Id: <20260922074757.264A51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ufs: dwc: ufshcd_dwc_link_is_up() propagates positive error v=
alues
--

commit bbaf6092d07a94b81e19b83041bbd45bc5f8771f
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

scsi: ufs: dwc: Return a negative error if the link is down

This commit updates ufshcd_dwc_link_is_up() to return -ENOLINK when the link
is down, rather than returning 1. It also propagates any errors returned by
ufshcd_dme_get() to the caller.

> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
> index 21b1cf912dcc6..ccf785fce6cc6 100644
> --- a/drivers/ufs/host/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba=
 *hba, u32 divider_val)
>   * ufshcd_dwc_link_is_up() - check if link is up.
>   * @hba: private structure pointer
>   *
> - * Return: 0 on success, non-zero value on failure.
> + * Return: 0 on success, a negative errno value on failure.
>   */
>  static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
>  {
>  	int dme_result =3D 0;
> +	int ret;
> =20
> -	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
> +	ret =3D ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
> +	if (ret)
> +		return ret;

[Severity: Low]
Are we propagating a positive error code here?

Looking at ufshcd_wait_for_uic_cmd() in drivers/ufs/core/ufshcd.c, when a D=
ME
hardware command fails, it extracts the positive error code from the UIC
registers:

	ret =3D uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;

Since this value propagates up through ufshcd_dme_get(), returning it direc=
tly
means ufshcd_dwc_link_is_up() can still return positive error codes. Does t=
his
violate the updated API contract to return a negative errno value on failur=
e?

While upstream callers evaluate the result as a truthy value (if (err)) and=
 the
probe safely fails without crashing, returning positive error codes violates
standard Linux driver conventions.

> =20
>  	if (dme_result =3D=3D UFSHCD_LINK_IS_UP) {
>  		ufshcd_set_link_active(hba);
>  		return 0;
>  	}
> =20
> -	return 1;
> +	return -ENOLINK;
>  }
> =20
>  /**

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922073009.1449=
688-1-larisa.grigore@oss.nxp.com?part=3D1
