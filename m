Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE3E369D53
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715725; cv=none; b=rFoOoC3UCxtc0BzuaHio1x1tr2GsCmvH/LumGXHu/JBhCinp+WZ7jAPMHjTSeayASWco73H1LGS00SlXSCq+TOAvgQQJHOG1i20qR4r7Rg+wH5b5tNMGpfbVC6n0l8qVfFO/LgnPbaFoXLBCwULegtbZX/s+S+FLEnAa7T6h3YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715725; c=relaxed/simple;
	bh=13wQ2GnPCykBzEyEh/hVLKwyNaskWPTjZxbhUueAgUk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FBlsTpkvIOvyQpDTjnnPxR2Um4bMmfKU2Ulj3P8sJeMUhE00YMP4NrwAWzoMvm6MoZpHJIPVxD+Lxp7yE8mxcoBGcJLkDSGgUU9/5zzAMgB+Dk5fU0KPf2ZxVlYKeaMsPcG7NCIwMz6uSxnADzjJcffHMFGu988o2JiVPr1XDeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwNGTpnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwNGTpnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD35B1F000FF;
	Fri, 18 Sep 2026 07:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715718;
	bh=qB6DN7L37ICXfXkZKNW17OYkdlmqEjLwW5bl9weaC44=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DwNGTpnU7WLU71XdfA1dCAgfRqNoH+wB9IlLhy3GIH0hZAh+bHegbt1/YCJ58yyqv
	 3+ZBxwXLCIfyhZgXUHg96xpGZbXsbdnbrQ33Y0xFyRroOX/r4D3+PtYgr83AVKb+5Q
	 Q8b3pIv1Xx38r9Cl/CydZ5aPkkGT7zXHkBrXhf8O8RUy5Rd9DUEXFuHeaeYQNzTk7w
	 zS1L/Qqkl4sgh/t5qwmQg8iAl/TJYxMkMjCuUQKMIiLH28npeBQkis0LztLvwj1S2J
	 1BbhTj4LTd4X2kYFq0MFptMUoX1q5O/Gfesub9so0Iq2EcKudbNftWPSfeANPF1gXb
	 8IpiiPYMPUU7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: libsas: Fix SMP IO deadlock during HA resume
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260918070307.381207-1-yangxingui@huawei.com>
References: <20260918070307.381207-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:15:18 +0000
Message-Id: <20260918071518.BD35B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: libsas: concurrent SMP IO to uninitialized hardware during P=
M resume
--

commit 2357f5bc7ff2aaf7e480b366cb3ce830c9f21616
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Fix SMP IO deadlock during HA resume
   =20
This commit replaces pm_runtime_get_sync() with a conditional
pm_runtime_get_noresume() during HA resume to prevent an SMP IO deadlock.
Outside the resume window, it converts to pm_runtime_resume_and_get() and
checks the result.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index 811c9eb4fef11..5a8cdd3682fe7 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct domain_device *d=
ev,
>  	struct sas_internal *i =3D
>  		to_sas_internal(dev->port->ha->shost->transportt);
>  	struct sas_ha_struct *ha =3D dev->port->ha;
> -
> -	pm_runtime_get_sync(ha->dev);
> +	bool ha_resuming =3D test_bit(SAS_HA_RESUMING, &ha->state);
> +
> +	/*
> +	 * While the host is resuming, ha->dev may be RPM_RESUMING and
> +	 * the resume blocked in sas_drain_work() waiting for this very
> +	 * SMP IO, so waiting for the host to resume here would deadlock.
> +	 * Hold the reference without resuming, the hardware is already
> +	 * initialized by the LLDD before sas_resume_ha() runs.
> +	 */
> +	if (ha_resuming) {
> +		pm_runtime_get_noresume(ha->dev);

[Severity: High]
Does this disjoint check of the global state flag followed by
pm_runtime_get_noresume() bypass power management synchronization,
potentially enabling concurrent I/Os to race with host hardware
initialization?

For instance, if userspace submits concurrent SMP I/Os via bsg, could
they race with the driver actively resetting the hardware? In
hisi_sas_v3_resume(), scsi_unblock_requests() is called before
sas_prep_resume_ha(). Could this allow concurrent requests to observe
ha_resuming =3D=3D true and bypass the pm_runtime_resume_and_get() sync,
resulting in I/O submission to uninitialized hardware?

Also, is there a time-of-check to time-of-use race here? If a thread
reads ha_resuming =3D=3D true, gets preempted while the device resumes and
autosuspends back to RPM_SUSPENDED, could it wake up and use
pm_runtime_get_noresume() to submit I/O to a powered-off device?

> +	} else {
> +		res =3D pm_runtime_resume_and_get(ha->dev);
> +		if (res)
> +			return res;
> +	}
>  	mutex_lock(&dev->ex_dev.cmd_mutex);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918070307.3812=
07-1-yangxingui@huawei.com?part=3D1
