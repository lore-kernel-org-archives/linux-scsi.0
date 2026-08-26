Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526672E717B
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 03:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787715631; cv=none; b=P5AOEjw/qWugcJYl+VjKK5yUvlWTKWSZC8maMKFWMsISJ+lKJAskFfxQUeyaVImwvRE0fSBCIMhANVSnC5HEeOM2wRmSrrugj62W+ZAUZlR7OnGzPTl/SRzwq/KeudScUWS/hIWrMkXUKFM4MZ/3U5WO5GFmZF2zxUe+Mziz4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787715631; c=relaxed/simple;
	bh=tjXok4fjFH6wWVEdyge/irIS+2cn4xVBKkX0Qys0Yas=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EV+rjbXa8QhsoCOqlb1TS5MiN3WFAdGpAKMPDEwr3HlU6DpAYKfSLFQQgHQX7c9NK8XapscGl7c7C2n3GD/PiJ1k+jRbSB6Tx8M97F7V/l2uDPVD+q2uXbX6vFev8G/bFwK+bE0h3oihNXbMiryhpuu++WI7ScSLRnJfQr6iXKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N51m3aqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N51m3aqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CEB1F000E9;
	Wed, 26 Aug 2026 03:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787715629;
	bh=605EDfhjnH2OcJy7IUlc0ioQltXypb6G6f62QtL+V04=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N51m3aqukS5tCSpOozPa6/d5nNoeae1vgSdzKleQGZ6IOmU/rnS3oisCiHEQpFKDQ
	 35UJkSHlgxZwNbq84dbIJRJAy6X9PKPO6LegiouCMvvxZVdhnkkodQfj9yDaWEAWVj
	 MNXsxJZ2CNwjGoR7mk8py+N5aCe2L9/kDkytT2wWvF1MwPRLCrNZYm/0W+cWoxZxNE
	 M+B+OaZWMY4J4tV/s21JtaTRxzjOu6bq/IQyDAZlBoJCy+8gmB/E8oY4n9q4MxmaU6
	 WJE7c5HBCf3XapzIX4Bzyjo+garTMG3/8qCfNW65GgCw12MoBc+9m0TxXW40MemHNm
	 F3kZY2BWI41VQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libsas: Fix SMP IO deadlock during HA resume
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260826032845.1632348-1-yangxingui@huawei.com>
References: <20260826032845.1632348-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 03:40:29 +0000
Message-Id: <20260826034029.B2CEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Bypassing PM reference counting via a global state flag creates a =
race condition where concurrent independent threads can submit SMP I/Os wit=
hout holding a PM reference, risking premature hardware suspend.

Pre-existing issues:
- [High] The return value of pm_runtime_get_sync() is ignored, which can le=
ad to accessing powered-off hardware on failure.
--

commit ecfcb25c960bd684b2b9ddb5e30db0c49c3a78b4
Author: Xingui Yang <yangxingui@huawei.com>
scsi: libsas: Fix SMP IO deadlock during HA resume

This commit attempts to fix a deadlock during sas_resume_ha() by
skipping pm_runtime_get_sync() and pm_runtime_put_sync() when the
SAS_HA_RESUMING flag is set. It targets expander-attached ATA devices
triggered by ATA EH via sas_phy_reset().

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index 811c9eb4fef11..77ae2ae7b2c45 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -61,8 +61,17 @@ static int smp_execute_task_sg(struct domain_device *d=
ev,
>  	struct sas_internal *i =3D
>  		to_sas_internal(dev->port->ha->shost->transportt);
>  	struct sas_ha_struct *ha =3D dev->port->ha;
> -
> -	pm_runtime_get_sync(ha->dev);
> +	bool skip_pm =3D test_bit(SAS_HA_RESUMING, &ha->state);

[Severity: High]
Does bypassing PM reference counting via a global state flag create a race
condition here in smp_execute_task_sg() in drivers/scsi/libsas/sas_expander=
.c?

Concurrent independent threads could submit SMP I/Os without holding a PM
reference, risking premature hardware suspend.

For example, if a concurrent userspace SMP request via bsg executes during
sas_resume_ha(), smp_execute_task_sg() could evaluate test_bit for
SAS_HA_RESUMING to true and skip pm_runtime_get_sync(). Meanwhile,
sas_resume_ha() might unblock SCSI requests via scsi_unblock_requests() and
eventually clear SAS_HA_RESUMING, dropping the resume thread's PM reference.

Could this allow the device to autosuspend while the BSG thread is still
waiting for the SMP IO to complete, potentially causing a system crash, bus
fault, or IO timeout?

> +
> +	/*
> +	 * Skip PM get/put during HA resume to avoid deadlock: the host is
> +	 * RPM_RESUMING and the drain waits for this SMP IO to finish, but
> +	 * pm_runtime_get_sync() would block on RPM_RESUMING. Safe because
> +	 * hardware is already initialized by the LLDD before call
> +	 * sas_resume_ha().
> +	 */
> +	if (!skip_pm)
> +		pm_runtime_get_sync(ha->dev);

[Severity: High]
This isn't a bug introduced by this patch, but the return value of
pm_runtime_get_sync() is ignored here in smp_execute_task_sg().

If pm_runtime_get_sync() fails to resume the device due to a hardware fault
or disabled runtime PM, the function will blindly proceed to allocate and
issue SMP tasks to the LLDD. Accessing suspended or unclocked hardware
registers can cause unrecoverable bus faults or system lockups.

Should the negative error code be checked before proceeding to access
hardware?

>  	mutex_lock(&dev->ex_dev.cmd_mutex);
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826032845.1632=
348-1-yangxingui@huawei.com?part=3D1
