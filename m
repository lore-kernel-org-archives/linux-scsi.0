Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655827;
	b=gmmLsB7JDXxlRirkRMg7XN9+4fN+aToE9sGyY2lp6YJcUSFGPQHNudL8bBL9mgsHHM63
	 wLTJ9hxLxCdn9J/3rXUuC7ZroBudESiE4mBVBpe+EJJ1N2+gf67vdKeNWkfgNPP1t0kk8
	 VKFIeyDSu2547DqNyytHpcjFLlUo+zmvtgV1KaAQMtrBN1+1+0O0uzke3VdI/uP+faUfP
	 FjX1uuQJNRke/VIgeLkl6sgq4aQz27VnlNS7PeHBVWkv6+yAKhUyjCaJ/zoLnHILV91E0
	 InX98CXVnNOWHuE2Nb8326zUwGYEPntXoHPTGVrAl97v1zBgNDHujPWdpYZiTn9gAtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655827;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=o93JunSRhIZdqAiS5A19ead8eWPnZ1Dx9sHzgcf0N1Y=;
	b=rk2ip025J+unIBNqpvRE53fqCgn2E0m0Mkm2ylHsWemOAnM67unS5urPjJLikG9nUKVM
	 4SFTMgZA9feA9P9UfkNulnqtGfjrhQEv1eUWYwK7fyCrU+pCXsP8hySirzryLHaH7VDKc
	 NHl3F3mL+aIaWOvKJNTd36jaylEVQR3lGRWqSwdRr3tFWlcH5UJAnHXPO6/2T7V9pQu7/
	 FSC3Ds2/98TlG+DGHKWM+gKxSETHxqS15HSFhwqcIwJ8PRMfdvpRTam3nMvq+KyJ3OPEa
	 lo6zDPuGC8xnGAkzDHhTz0toIOO/tGbTfImZVHbTfL2p89cToUY470jYcQr0lIRAnEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CHVtHoon;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0A3606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CHVtHoon
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304371F000C3;
	Thu, 22 Oct 2026 07:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792655826;
	bh=o93JunSRhIZdqAiS5A19ead8eWPnZ1Dx9sHzgcf0N1Y=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=CHVtHoonCecW5lqttwhXykVV/B2eb1GjQpnl9SzQijuew397qyn+aSmx61EcEbxKE
	 M1OI9dyJxV6+uZ7mMT9kz0rncVebysgaqG3KADxnWi6/LZ/OSclzzqgJSnjU3u1qb3
	 dGAvkThsgRy3a9RgNaBj0p+1yxEuJgFg3KhsaybO4f8V9Mj4jHRbGNkbXK3iNegv8I
	 UvD7R6Trufh0pnIpH8TBe3vsZlnAwUIG6HHR02VtaFT6DdtMvj751JfxrzdhsxJeWQ
	 uU3u9RlL8qF9xkkvw2kg4qLH37NdYRQj8Onshr6K/wox6LHPk7mCV3jvSlbd3bWUUP
	 Fh8m6Phfv9Ggg==
Message-ID: <sashiko-outbox-181149@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ufs: Change the error check sequence for auto
 hibern8
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261022074249.3098100-1-hy50.seo@samsung.com>
References: <CGME20261022074701epcas2p30b1d22790ff85d4179d38bda18184575@epcas2p3.samsung.com>
 <20261022074249.3098100-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 07:57:05 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ufs: NULL pointer dereference in ufshcd_uic_cmd_compl() on a=
uto-hibern8 error
- [High] scsi: ufs: missed auto-hibern8 error detection in ufshcd_uic_cmd_c=
ompl() when cmd is active
--

commit b23209e884c306055d4141ae75fa4129efd7affa
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: Change the error check sequence for auto hibern8

This commit moves the ufshcd_is_auto_hibern8_error() check in
ufshcd_uic_cmd_compl() into the !cmd branch so auto-hibern8 errors can be
recorded when no UIC command is active.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..4d44dbcda6423 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5930,14 +5930,15 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct uf=
s_hba *hba, u32 intr_status)
>  	guard(spinlock_irqsave)(&hba->host->host_lock);
>  	cmd =3D hba->active_uic_cmd;
>  	if (!cmd) {
> -		dev_err(hba->dev,
> -			"No active UIC command. Maybe a timeout occurred?\n");
> -		return retval;
> +		if (ufshcd_is_auto_hibern8_error(hba, intr_status)) {
> +			hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
> +		} else {
> +			dev_err(hba->dev,
> +				"No active UIC command. Maybe a timeout occurred?\n");
> +			return retval;
> +		}
>  	}

[Severity: High]
When cmd is NULL and ufshcd_is_auto_hibern8_error() returns true, execution
falls through to the remainder of ufshcd_uic_cmd_compl() with cmd still NUL=
L:

drivers/ufs/core/ufshcd.c:ufshcd_uic_cmd_compl() {
	...
	if (intr_status & UIC_COMMAND_COMPL) {
		cmd->argument2 |=3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
				  MASK_UIC_COMMAND_RESULT;
		cmd->argument3 =3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
		if (!hba->uic_async_done)
			cmd->cmd_active =3D false;
		complete(&cmd->done);
		retval =3D IRQ_HANDLED;
	}

	if (intr_status & UFSHCD_UIC_PWR_MASK && hba->uic_async_done) {
		cmd->cmd_active =3D false;
		complete(hba->uic_async_done);
		retval =3D IRQ_HANDLED;
	}
}

If UIC_COMMAND_COMPL is also set in intr_status (for example, if a prior UIC
command timed out in ufshcd_wait_for_uic_cmd() and cleared
hba->active_uic_cmd to NULL before a late completion interrupt arrived
alongside an auto-hibern8 error), won't dereferencing cmd->argument2 cause a
NULL pointer dereference?

Similarly, UFSHCD_UIC_PWR_MASK includes UFSHCD_UIC_HIBERN8_MASK, so
intr_status & UFSHCD_UIC_PWR_MASK is always true on this path. In
ufshcd_uic_pwr_ctrl(), hba->uic_async_done is assigned and host_lock is
released before __ufshcd_send_uic_cmd() sets hba->active_uic_cmd:

drivers/ufs/core/ufshcd.c:ufshcd_uic_pwr_ctrl() {
	...
	hba->uic_async_done =3D &uic_async_done;
	ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
	spin_unlock_irqrestore(&hba->host->host_lock, flags);
	ret =3D __ufshcd_send_uic_cmd(hba, cmd);
	...
}

If an auto-hibern8 error interrupt is serviced in that window while cmd is
NULL, won't cmd->cmd_active =3D false also dereference a NULL cmd pointer?
Should the auto-hibern8 error branch return retval after setting hba->error=
s?

> =20
> -	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
> -		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
> -

[Severity: High]
ufshcd_is_auto_hibern8_error() is only called from ufshcd_uic_cmd_compl(),
and it explicitly checks whether hba->active_uic_cmd is a manual hibernate
command:

drivers/ufs/core/ufshcd.c:ufshcd_is_auto_hibern8_error() {
	...
	if (hba->active_uic_cmd &&
	    (hba->active_uic_cmd->command =3D=3D UIC_CMD_DME_HIBER_ENTER ||
	    hba->active_uic_cmd->command =3D=3D UIC_CMD_DME_HIBER_EXIT))
		return false;

	return true;
}

By moving the ufshcd_is_auto_hibern8_error() check inside if (!cmd), that
hba->active_uic_cmd check in ufshcd_is_auto_hibern8_error() becomes
unreachable because hba->active_uic_cmd is always NULL at the call site.

If an auto-hibern8 enter or exit error occurs while a non-hibernate UIC
command (such as UIC_CMD_DME_GET, UIC_CMD_DME_PEER_GET, or UIC_CMD_DME_SET)
is active in hba->active_uic_cmd, hba->errors will no longer be updated with
UFSHCD_UIC_HIBERN8_MASK & intr_status. Because UFSHCD_UIC_HIBERN8_MASK is n=
ot
part of UFSHCD_ERROR_MASK, ufshcd_sl_intr() relies on hba->errors being set
to invoke ufshcd_check_errors():

drivers/ufs/core/ufshcd.c:ufshcd_sl_intr() {
	if (intr_status & UFSHCD_UIC_MASK)
		retval |=3D ufshcd_uic_cmd_compl(hba, intr_status);

	if (intr_status & UFSHCD_ERROR_MASK || hba->errors)
		retval |=3D ufshcd_check_errors(hba, intr_status);
	...
}

In addition, if a power mode command is active in ufshcd_uic_pwr_ctrl() with
hba->uic_async_done set, an auto-hibern8 error interrupt will match
intr_status & UFSHCD_UIC_PWR_MASK and complete hba->uic_async_done without
recording the error in hba->errors.

Could ufshcd_is_auto_hibern8_error() be checked before the if (!cmd) check =
so
that auto-hibern8 errors are caught both when cmd is NULL and when a
non-hibernate UIC command is active?

>  	if (intr_status & UIC_COMMAND_COMPL) {
>  		/*
>  		 * Store the UIC command result in the lowest byte of

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022074249.3098=
100-1-hy50.seo@samsung.com?part=3D1
