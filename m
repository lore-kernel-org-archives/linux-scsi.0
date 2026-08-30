Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D73839B4
	for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2026 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788097061; cv=none; b=DbccDx50MQ3856cVzetjvXE52QlADAyGv5DODyKm0LHOCUcNj/QK6nPis/JT2jPu4xIj9mlWHYpV5H9LVmargvnyBtrot30rK5M77jNXboKy3B2vXOVXVUlQgPDDNiv9aB4Hf5YUUuwv0hC61YB/cmQ9QephTPj79c7s2tGOUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788097061; c=relaxed/simple;
	bh=MysWeXYfHSg83P5u4kN/ChJnQKpTqa82o95py9EPx/Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tKYGPNUrvxApN/RG5Q65mYZSrSf6GTysJ9OTskci+7WjKud9PxesHxVGwaoAEJa07ZafOzdxGmsEAR24lFEsZ2stFPlpivtM97tdG4+Rh6WNn1bOuTM/giMwi1XUN6oXmEdFw4kcm+vVLVCvNCpj9rEiY5+NftRy7CzU9wb+3Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQHISCuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQHISCuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4562E1F000E9;
	Sun, 30 Aug 2026 13:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788097059;
	bh=3Bo9GKUlX6PnEp1cJd9NwO3x4khVtoezvU9NVkvRTPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YQHISCuXe7Dl2oFbrRJPMfBZmAjk0LApmmRwJIxnvjGeIsMHT59InEcyCCm/PcjbJ
	 6Pk5uroLEexhsoMcaut6mRHUaquvU6Wyn3pyhQxxYKCT3ccO4temI+jmhC6kQzDZRz
	 x2IMrnpkPLLY8PCDEWzNDsX7xyDeJ8SFzp0eJRpWp/qJCpjcVGoCBOU88QTiODIVJ9
	 bpPogSasRDPgioS4eXsXDbPJq2Qq8U159ccgG6byTaCHWruDOq+drhHkhqIx8+hNAz
	 i3RPztjO5GvQxnOETBfZJT7txCN5E5jYU+WGVMkrIOXZ4oHE1Zf8lOOfMDaJiy2pls
	 DtAWFEvw1CVFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ufs: rockchip: propagate controller reset errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260830132723.5855-1-pengpeng@iscas.ac.cn>
References: <20260830132723.5855-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 13:37:38 +0000
Message-Id: <20260830133739.4562E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Propagated reset errors during HCE enable are ignored by the UFS=
 core, defeating the patch's stated goal.

Pre-existing issues:
- [High] Clock enable count leaks when the UFS core resume functions fail i=
n runtime or system resume.
- [High] Premature clock disable in ufs_rockchip_runtime_suspend() leads to=
 unsafe hardware access and a state mismatch on failure.
--

commit 5aa3f0967e7ed951d7f28ee06f36a7216652dda8
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ufs: rockchip: propagate controller reset errors

This commit modifies the Rockchip UFS driver to propagate reset controller
errors instead of discarding them. It updates initialization, HCE enable,
and runtime resume paths to return these errors, and it unwinds the
reference clock on failure in the resume path.

> diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockc=
hip.c
> index bac68f238e1c4..3b9661befe6ae 100644
> --- a/drivers/ufs/host/ufs-rockchip.c
> +++ b/drivers/ufs/host/ufs-rockchip.c
[ ... ]
> @@ -46,9 +51,7 @@ static int ufs_rockchip_hce_enable_notify(struct ufs_hb=
a *hba,
>  	}
> =20
>  	/* PRE_CHANGE */
> -	ufs_rockchip_controller_reset(host);
> -
> -	return 0;
> +	return ufs_rockchip_controller_reset(host);
>  }
> =20

[Severity: Medium]
Will this propagated error actually be handled by the core?

Looking at the caller in the UFS core, ufshcd_hba_execute_hce() appears to
unconditionally ignore the return value of the PRE_CHANGE notification and
continues the HCE enable sequence regardless:

drivers/ufs/core/ufshcd.c:ufshcd_hba_execute_hce() {
	...
	ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
=09
	/* start controller initialization sequence */
	ufshcd_hba_start(hba);
	...
}

Could this lead to the driver continuing initialization despite the reset
failure, defeating the purpose of propagating this error?

[ ... ]
> @@ -291,7 +296,11 @@ static int ufs_rockchip_runtime_resume(struct device=
 *dev)
>  		return err;
>  	}
> =20
> -	ufs_rockchip_controller_reset(host);
> +	err =3D ufs_rockchip_controller_reset(host);
> +	if (err) {
> +		clk_disable_unprepare(host->ref_out_clk);
> +		return err;
> +	}
> =20
>  	return ufshcd_runtime_resume(dev);
>  }

[Severity: High]
This is a pre-existing issue, but does this function leak the clock enable
count if the core resume fails?

When ufshcd_runtime_resume(dev) is called, its return value is passed
verbatim to the caller. If it returns an error, the function exits without
unwinding the host->ref_out_clk that was enabled earlier in this function.
This could result in an unbounded clock reference count leak on repeated
runtime resume failures, preventing power domains from turning off.

[Severity: High]
This is also a pre-existing issue, but looking at the counterpart function
ufs_rockchip_runtime_suspend() in this same file, is the reference clock
disabled prematurely?

drivers/ufs/host/ufs-rockchip.c:ufs_rockchip_runtime_suspend() {
	...
	clk_disable_unprepare(host->ref_out_clk);

	/* Do not power down the genpd if rpm_lvl is less than level 5 */
	dev_pm_genpd_rpm_always_on(dev, hba->rpm_lvl < UFS_PM_LVL_5);

	return ufshcd_runtime_suspend(dev);
}

Disabling the reference clock before calling ufshcd_runtime_suspend(dev)
might cause bus timeouts and abort the suspend process if the UFS core
attempts to access the hardware. If ufshcd_runtime_suspend() fails, the PM
core considers the suspend aborted, but the physical clock remains disabled,
which could leave the hardware in an unrecoverable state for subsequent
accesses.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830132723.5855=
-1-pengpeng@iscas.ac.cn?part=3D1
