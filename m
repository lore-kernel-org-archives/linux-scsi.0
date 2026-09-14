Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C47418A37
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376533; cv=none; b=XOjatvStqqoqXRh8avZzptaFd0u16HIlVJ5vy4PfHkVnJo8jRTT5xNLKj5DlYhCb0eYP6Ca4pLz8ogj8QGgxg+HugZvhiqpL0ruzq27A0k5LUEDsjzaB+ib6JEbn8pMI7aJMQJ1EblBtCgiSiJkY7xa20/+t539Xhax8/O3cA0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376533; c=relaxed/simple;
	bh=1BupEelQRer0SUadu6k8iq3YgZm1QPteG8TrqexcJLA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YQaSCnRqtsNvLpIxy4N8nm0a3xiHlyITew9+nRxwcS8YDOUjvNLI6lUiSZCJihoabItNYacwS6t3k9QeS2zWPnEMxCKx089kl5Z2rFYHAcFGZp8eVNVFxczRBDGxzhDXaVRP4eCPa6p5nU+i29Uy4/3brwmQnPzLc54Ea3VQCPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4jvz910; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4jvz910"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A873A1F000FF;
	Mon, 14 Sep 2026 09:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789376531;
	bh=FQ23IbWFlnfX6nSb6x+R2CZ6z2kI3KipalyjnlTU0Ik=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M4jvz910dBDJfNiiPMfgxLzx/feCex0OUaiOQcMNqspKSoDQGW8emgsvynhXF/2it
	 SIXu1fkIXiUOXAkb/1M7vgw4dctMsJIof1MZz2cgaGr04NrTNpL5qUW39Pt1QgVlvg
	 LqsHTz3AMKVBdhw7wyq6lXe1qPMC0m15D4zfUjz/iU5ieCE0s/Q9UpKtuBMOzRtlLK
	 FcqQxXA0pOMMvmy9Jqy87PVZ1f7gpkzWfffHN50FcXkBqM8NooAMuaevGxO8+nVoDL
	 xx1d5dcugbQ0RcAIVNQUY6bYG+HjCuctK1O0Y1CTF8QNy+rnRMc8iw4Vr3eBOE1h3y
	 TmNZiGdFwX4eQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] ufs: always notify POST_CHANGE even on gear
 switch failure
Reply-To: sashiko-reviews@lists.linux.dev
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260914085148.136429-2-peter.wang@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
 <20260914085148.136429-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 09:02:11 +0000
Message-Id: <20260914090211.A873A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Passing `NULL` for `dev_req_params` on failure causes spurious e=
rror logs in unmodified vendor drivers (`ufs-qcom`, `ufs-hisi`) and destroy=
s the context needed for proper resource rollback.
--

commit e9e864935f979762e71567d19e93d8a30870f23b
Author: Peter Wang <peter.wang@mediatek.com>

ufs: always notify POST_CHANGE even on gear switch failure

This commit modifies ufshcd_change_power_mode() to always notify POST_CHANG=
E,
even if the gear switch fails. On failure, it passes NULL for dev_req_params
and updates ufs-exynos and ufshcd-pci to handle the NULL argument.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 234e18b5078f2..2e7a592dbf2f1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5003,8 +5003,12 @@ int ufshcd_change_power_mode(struct ufs_hba *hba,
> =20
>  	ret =3D ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);
> =20
> -	if (!ret)
> -		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
> +	/*
> +	 * Always notify POST_CHANGE to pair with PRE_CHANGE, even on failure.
> +	 * On failure, pass dev_req_params =3D NULL to indicate nothing to appl=
y.
> +	 * POST_CHANGE return value is advisory and does not mask @ret.
> +	 */
> +	ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, ret ? NULL : pwr_mode);

[Severity: Medium]
Will passing NULL for dev_req_params on failure cause issues for unmodified
vendor drivers?

Looking at ufs_qcom_pwr_change_notify() in drivers/ufs/host/ufs-qcom.c, it
has an early check that will trap this NULL argument and log a spurious err=
or
before any POST_CHANGE cleanup can execute:

drivers/ufs/host/ufs-qcom.c:ufs_qcom_pwr_change_notify() {
	if (!dev_req_params) {
		pr_err("%s: incoming dev_req_params is NULL\n", __func__);
		return -EINVAL;
	}
	...
}

Similarly, ufs_hisi_pwr_change_notify() in drivers/ufs/host/ufs-hisi.c will
also log a spurious error on every power mode change failure:

drivers/ufs/host/ufs-hisi.c:ufs_hisi_pwr_change_notify() {
	if (!dev_req_params) {
		dev_err(hba->dev,
			    "%s: incoming dev_req_params is NULL\n", __func__);
		ret =3D -EINVAL;
		goto out;
	}
	...
}

Additionally, does passing NULL here destroy the context needed for proper
resource rollback?

For instance, in ufs_qcom_pwr_change_notify(), resources are acquired in
PRE_CHANGE based on the dev_req_params:

drivers/ufs/host/ufs-qcom.c:ufs_qcom_pwr_change_notify() {
	...
		/* enable the device ref clock before changing to HS mode */
		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
			ufshcd_is_hs_mode(dev_req_params))
			ufs_qcom_dev_ref_clk_ctrl(host, true);
	...
}

By omitting the original parameters on failure, the target drivers are prev=
ented
from using the requested mode context in POST_CHANGE to safely revert their
state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914085148.1364=
29-1-peter.wang@mediatek.com?part=3D1
