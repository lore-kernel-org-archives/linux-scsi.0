Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946788;
	b=LGHR94hhnrObMlDuyB1lq4FSqZ6NB+cnhME3yvJ7q9A8PnHuKtyN3G0qlBGXcGGHJCj/
	 V/Mg7zgUtrhMfgLnlft2evOlDC7H2O+USYjrT0eH7pUNiMtDeccPbTK1tc5H7411Ico5j
	 1cAjd8bWJe49/+Aqkl30zqe2+paTtZZ3KZPO3k0frc2YXCAe4VFS0ny1JOilOihX+LgES
	 1de+q3Tk+51DvkqxM8kE9E/Y+omaclXLSLjVrX0fpY+7FeIMjBkAZyFECGC2XqShbkOnb
	 Cp/axO9VP2lx69HtlDGvgCeADuB7U9KagO19U5cEM0mFIhG2D/TfIUvrhZsMT5hZz1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946788;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vi26vPv5btpjKVdCOc/d7TJeCoFZq8IUhNrxGCiqYeM=;
	b=JRPIRHpEHmj987JUsNAilRjJ++ktiTw3BG7fWsUc0t1+7kM95VWfjOLfCqFRM9Kv5nVD
	 kaTiG6zRMfbxvzwaW9oCCpkOCnjn72XTdqUojy8F4KRIkw7llhcS4S5/wyrsO70rysu2+
	 m+DNX8nSpJIh8Z7N9HSqfrlutZfPUjXIm7khfr47er5Y61V6xg4sTwEYOcSrLjnpqHcLr
	 M8wfmAvG2FzNr6LADd1HSa3alN5cmxgfjtyP6PEaeJX0OaZtrUb4LCOyh7poEKJL/akC3
	 j6S8ZwZg8URmTdXe+4sfqPxuDK9E26iyrWI+xkWZLWcfX05FPV5V4j6x0rxQ25zA9aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gwMIlTeq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9313606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gwMIlTeq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C93E1F0089F;
	Fri,  6 Nov 2026 06:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793946787;
	bh=vi26vPv5btpjKVdCOc/d7TJeCoFZq8IUhNrxGCiqYeM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=gwMIlTeqBm2RtnsIFdXrozlEjzHcmu3CApyGrBNQ0+FzoRIRJLrmloFcx59IP6/XE
	 YVht6DpLSL/www6ZN0aHe+SHYN3s3jkf9w04kNJ5uQkAfIbOedwVxqihHSElIeQDaC
	 NJEKfXuMaMd3yoIU6sNvJUGGaM1nEA9XcEYoNE/vpBGOp/tS0yLMhAi7mIraa7v3dc
	 7HUC6evK/RWPmD4MS2dei1cNfOGVJic4nRN3+zbQ+IfjNppn5rYb0BAzc8TBmxMAus
	 CrOwVj3Mxkx8kp/AS0X2jtFNFMb6oaKvvEQX6qvbsM/3zdLhVsf2Wls2MHp5JMMQuE
	 yP4XapXJS0dqA==
Message-ID: <sashiko-outbox-200897@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <c408e7a7167984a07dc714f43273d029b8904939.1793943246.git.hy50.seo@samsung.com>
References: <cover.1793943246.git.hy50.seo@samsung.com>
 <CGME20261106061546epcas2p3b0d54ffe9fcea407f7d0e27ed579de0d@epcas2p3.samsung.com>
 <c408e7a7167984a07dc714f43273d029b8904939.1793943246.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:33:06 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: ufs: core: missing error and RPM handling in
  ufshcd_wl_poweroff()
--

commit 9a163b2c91f3c9901825d9d544ee48c174c9b6c6
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Hold host_sem in ufshcd_wl_poweroff()

This commit acquires hba->host_sem in ufshcd_wl_poweroff() before calling
__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) so that error recovery is
serialized against hibernation poweroff and hba->host_sem remains balanced
if hibernation is aborted and ufshcd_wl_resume() runs.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5a3ca3b4e6666..c2c34b044c3ec 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11583,6 +11583,8 @@ static int ufshcd_wl_poweroff(struct device *dev)
>  	struct scsi_device *sdev =3D to_scsi_device(dev);
>  	struct ufs_hba *hba =3D shost_priv(sdev->host);
> =20
> +	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
> +	down(&hba->host_sem);
>  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>  	return 0;
>  }

[Severity: Medium]
What happens if __ufshcd_wl_suspend() fails here or if dev is already
runtime-suspended?

When __ufshcd_wl_suspend() fails, it drops its initial ufshcd_hold(hba)
via ufshcd_release(hba) before returning:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_suspend() {
    ...
	if (ret) {
		ufshcd_update_evt_hist(hba, UFS_EVT_WL_SUSP_ERR, (u32)ret);
		hba->clk_gating.is_suspended =3D false;
		ufshcd_release(hba);
	}
    ...
}

Unlike ufshcd_wl_suspend(), ufshcd_wl_poweroff() ignores that failure,
leaves hba->host_sem held (blocking ufshcd_err_handler()), and returns 0
so the parent controller suspends while the UFS device and link are still
active.  If hibernation is then aborted, ufshcd_wl_resume() calls
__ufshcd_wl_resume(hba, UFS_SYSTEM_PM), which calls ufshcd_release(hba) a
second time and underflows hba->clk_gating.active_reqs.

In addition, ufshcd_suspend_prepare() leaves ufs_device_wlun
runtime-suspended when ufshcd_rpm_ok_for_spm(hba) is true, but
ufshcd_wl_poweroff() does not check pm_runtime_suspended(dev) (unlike
ufshcd_wl_suspend() and ufshcd_wl_resume()): if the device is in
UFS_SLEEP_PWR_MODE or UIC_LINK_HIBERN8_STATE, __ufshcd_wl_suspend() hits
!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba), schedules
ufshcd_force_error_recovery(hba) (which blocks on hba->host_sem), and
clears hba->clk_gating.is_suspended; if it is already in
UFS_POWERDOWN_PWR_MODE and UIC_LINK_OFF_STATE, __ufshcd_wl_suspend() takes
a second ufshcd_hold(hba) that ufshcd_wl_resume() never releases because
pm_runtime_suspended(dev) is true.

Finally, ufshcd_wl_poweroff() does not set hba->is_sys_suspended =3D true on
success like ufshcd_wl_suspend() does, so if __ufshcd_wl_resume() fails
during restore, ufshcd_err_handling_prepare() will skip re-enabling
regulators, clocks, and IRQs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793943246.gi=
t.hy50.seo@samsung.com?part=3D2
