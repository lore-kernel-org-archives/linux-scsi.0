Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168E2749CF
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 04:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784260987; cv=none; b=pomx/TkcQGW6gufCpFff/oTei5Fd567XQLCrTUbnt0tX217ChR3Im+oitspPXHoqEWtSUyDgH2sRRH5BMz9DfQoqD38v6dfs10urK/ECVer8SbYcTaxyg1DSs4bUKTV9P1IaIn3wnmNHhaHF9UzEIgINx6sWM4M6DGF78/rEAX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784260987; c=relaxed/simple;
	bh=s17AiaF1E0J1iXQ/cGq/aqS/wb+5gUQg0g/Kuo8J6g0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l47R9NAHi3mCQ7nFkZWnz4dlO1NT5E987LK173adw8fdTH5DPeXowRJzy4J/5FEOgl5DKUpPU14gPQLDiPRROeIeJm34gK9/qYn6XnT3GQfM66fJc24KFm5zrNLsNNRoLL0djvYtDJhLndFyQflWvanzNrocSBbDWpwXkdrwnaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yfwx3awB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yfwx3awB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B091F000E9;
	Fri, 17 Jul 2026 04:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784260986;
	bh=+xrOh9ojRt2GI2IQuhXz6yRzOiJzh0CC7FhMAqZDB4A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yfwx3awBmmF68VUR8nq2+BLxRp74q0DRP/5v5XgSQZGSIzvw51v1HOMzzW44C9y1c
	 HxE3tm8NzB47ZPFskqfwIX+BIUzR7/s7J16S/NZAmRiLLOmcJGxsx4F0odawyIQjhl
	 ogi7QQZ+A5QamsPaShZ0c4iimGVdbgjS9M/kR5F+TLL25qEUuWUYeCHwcO/t+o6L2a
	 vIeXtDGVhfulv/MOxizYKj2voARvx6e5XNivvsuPQ96gFxPK2cRQIJ5DrZJjMtt6IT
	 Hpteo4wXy0hXCjXyLaYEoMZ41ynRC73AJy1+F+414y853VxdgUPMOqoQGbUIUH5wRy
	 OxO26B0CoNBAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ufs: host: Remove redundant dev_err()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pan Chuang" <panchuang@vivo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717035013.563791-1-panchuang@vivo.com>
References: <20260717035013.563791-1-panchuang@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 04:03:05 +0000
Message-Id: <20260717040305.C3B091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Teardown order violation in ufs_qcom_remove() destroys the MSI dom=
ain before devres-managed IRQs are freed, leading to a potential Use-After-=
Free or panic.
--

--- Patch [1]: [PATCH] ufs: host: Remove redundant dev_err() ---
commit 2d60d33ee1768b4175522f72c450271bc5ddc6ae
Author: Pan Chuang <panchuang@vivo.com>

ufs: host: Remove redundant dev_err()

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 291c434487648..7d690ea2fa674 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2431,8 +2431,6 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
>  		ret =3D devm_request_irq(hba->dev, qi[idx].irq, ufs_qcom_mcq_esi_handl=
er,
>  				       IRQF_SHARED, "qcom-mcq-esi", qi + idx);
>  		if (ret) {
> -			dev_err(hba->dev, "%s: Failed to request IRQ for %d, err =3D %d\n",
> -				__func__, qi[idx].irq, ret);
>  			/* Free previously allocated IRQs */
>  			for (int j =3D 0; j < idx; j++)
>  				devm_free_irq(hba->dev, qi[j].irq, qi + j);

[Severity: High]
This is a pre-existing issue, but since devres-managed IRQs are used here,=
=20
does ufs_qcom_remove() break teardown symmetry?

In ufs_qcom_remove(), the MSI domain is destroyed manually before
devres-managed IRQ handlers are released:

drivers/ufs/host/ufs-qcom.c:ufs_qcom_remove() {
    ...
    ufshcd_pltfrm_remove(pdev);
    if (host->esi_enabled)
        platform_device_msi_free_irqs_all(hba->dev);
    ...
}

When the device is unbound, platform_device_msi_free_irqs_all() destroys the
MSI IRQ domain and descriptors before devres runs.

When devm_irq_release() later calls free_irq(), it silently returns early
because the descriptor is already gone. This bypasses the critical
__synchronize_irq() and kthread_stop() cleanup logic.

Could this permanently leak the threaded IRQ handlers (struct irqaction
objects) and cause a use-after-free or kernel panic if a handler is
scheduled or running while the driver memory is freed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717035013.5637=
91-1-panchuang@vivo.com?part=3D1
