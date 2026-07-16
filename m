Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5943F4102
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191660; cv=none; b=r7dS2DXDPs1/JkqzNyC1FsrBX7myTl7jZhWrHNbppiemqvim4zzb6I4tf8euluPS5fAmWxl5zvtfLS21jizwashS9GrZVT73hbKpI2/of0tRuVxe1Mx6IxRzdItJCgs0GuEmziNmkYokbu5/gg+HXr72mtidR+DnOmLUil6RxxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191660; c=relaxed/simple;
	bh=RiZ57RyLutL631tyVJqLyycUx2NiOfvxX/m+jztBOEs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JhaRZ8NoxnfQeIWnmVwjAcrDmXaAWaM+YWJIirlcpFJlhxxmLHgIMBmSvsQ8Pq1sXKY+tgFcXkN+WdhRg+H8R1aG3hUYw96pCCCSnBMV2gHU2SX1Q9fY5NuXFbw7fnmFumE7IsyReEIxr/idqiPqxXFhb4FyY5JmwvgQ8Lc2/xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3ZUt+Yh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3ZUt+Yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D7A1F000E9;
	Thu, 16 Jul 2026 08:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191655;
	bh=HTJujuWXZHwPeagJcjjPwlWntToW6xzd2WhcVcT7XPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I3ZUt+YhyLa4lCNW+2Mqq/vgxJKJAYXtdm3RdpSJmHVxCx+gQNkyGVIrzlb4x6F3z
	 vOlZku6G7tGo9r/naXR1MJwIzFxlqcjsunzSL+pUDR0X/lnS549DlgMVJVtuzTZz0W
	 deTaBwnglJr7JI/QK1psgt/Zn5msaKm+v6jlGE/oLjcjhwTiLihrIDKWHBv7WxAR1P
	 L4CELRo0l0V1Zhy1yxcZfwXYGH/PoTjxr4mZbYD+g7ueJrNN3oi4R5RqAzbI6toFSj
	 AAya4ZCwzIOyx2aKjEjQjfpS0fmwmIaGYTkJsn6yHq3mxSzCzf9TL3k/WJKMgm1rZ5
	 V00AYXaEtLUNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260716081145.3950172-1-yangxingui@huawei.com>
References: <20260716081145.3950172-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 08:47:35 +0000
Message-Id: <20260716084735.91D7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Removing `sas_resume_ha_no_sync()` and restoring `sas_resume_ha()`=
 reintroduces a resume deadlock for hardware events like `PHYE_LOSS_OF_SIGN=
AL`.
--

--- Patch [1]: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas=
 disk-wake race ---
commit f62439ea23dd5d0db3e1f9ebd2572dcb77f2890b
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race

This patch moves the PHYE_RESUME_TIMEOUT notification after sas_drain_work()
to fix a deadlock in the resume path. It then removes sas_resume_ha_no_sync=
()
and restores the draining sas_resume_ha() in hisi_sas.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> index 213d5b5dea94f..8a2500993e19d 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
[ ... ]
> @@ -5261,15 +5261,7 @@ static int _resume_v3_hw(struct device *device)
>  		return rc;
>  	}
>  	phys_init_v3_hw(hisi_hba);
> -
> -	/*
> -	 * If a directly-attached disk is removed during suspend, a deadlock
> -	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
> -	 * hisi_hba->device to be active, which can only happen when resume
> -	 * completes. So don't wait for the HA event workqueue to drain upon
> -	 * resume.
> -	 */
> -	sas_resume_ha_no_sync(sha);
> +	sas_resume_ha(sha);
>  	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
> =20
>  	dev_warn(dev, "end of resuming controller\n");

> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_ini=
t.c
> index 0bec236f0fb59..c3f3d05b46dea 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
[ ... ]
> @@ -426,6 +426,23 @@ static void _sas_resume_ha(struct sas_ha_struct *ha,=
 bool drain)
>  		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
>  			 i, i > 1 ? "s" : "");
>  	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) =3D=3D 0, tmo);
> +
> +	/*
> +	 * All phys are back up or timed out. Turn on I/O and drain
> +	 * pending work.
> +	 */
> +	scsi_unblock_requests(ha->shost);
> +	sas_drain_work(ha);

[Severity: High]
Could this reintroduce a resume deadlock for hardware events like
PHYE_LOSS_OF_SIGNAL?

During host resume in _resume_v3_hw(), hardware is re-enabled via
phys_init_v3_hw() just before calling sas_resume_ha(). If a hardware event
fires during the 25-second wait window, the interrupt handler will queue it.

Looking at sas_defer_event() in sas_event.c, events for suspended phys are
not deferred:

drivers/scsi/libsas/sas_event.c:sas_defer_event() {
    ...
    if (test_bit(SAS_HA_RESUMING, &ha->state) && !phy->suspended) {
        ... deferred =3D true;
    }
    ...
}

Since it isn't deferred, the event worker executes it immediately:
sas_phye_loss_of_signal() -> sas_deform_port() -> sas_destruct_devices() ->
sas_rphy_delete() -> device_del().

Because hisi_sas uses device links with DL_FLAG_PM_RUNTIME, device_del()
triggers a synchronous resume (pm_runtime_get_sync()), which blocks waiting
for the host to finish resuming.

At the same time, this sas_drain_work() call blocks waiting for the event
worker to finish, resulting in a deadlock. Could a hardware event fire
during this wait and cause this scenario?

> +
> +	/*
> +	 * Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
> +	 * calls sas_deform_port() -> sas_destruct_devices(), which removes
> +	 * SCSI devices and, for LLDDs using device_link() PM sync, waits
> +	 * for the host to be runtime-active. Sending it before the drain
> +	 * would deadlock: the drain waits for the handler, the handler
> +	 * waits for host resume, and host resume waits for the drain to
> +	 * finish.
> +	 */
>  	for (i =3D 0; i < ha->num_phys; i++) {
>  		struct asd_sas_phy *phy =3D ha->sas_phy[i];

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716081145.3950=
172-1-yangxingui@huawei.com?part=3D1
