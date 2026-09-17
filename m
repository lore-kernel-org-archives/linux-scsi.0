Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41B451FCB3
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789651080; cv=none; b=t86F1mxLj1A+FLUArg+Njk9ioTjjIRGCSyGQwO1AWoq5Ue3otAouKj4fPs66wn2TgNpnPV+QHQbVZsW02Jj7zag1p8Q+wNzp8Brhu4P4pgYmtg/ZbFjNDLdQy3+BnwZO75hj0HBkoNhMT+SCbPA06K02XyAJpaI/JLa3Awhr4kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789651080; c=relaxed/simple;
	bh=A9sUwoh777zOCS1Se+rPt2ZLCKCFxam7Udjjd/qOq94=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ktgLk932pa0aZuT4RV+BccWAQdqm1QOoNSr/e1ihzmfh7RTdsV75/x3Ma9TSy3bg7NkuLZfcGFpPed+qXCHO3lnFzKImrNkBXkKJulPdgxEu344Ps8CgQ+mfTzpjAvj+JZ1ap/y6a28Y+OeAKDVxmXzJfNtFgyhzzlQqJJH0/YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKx3HECz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKx3HECz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F4A1F000FF;
	Thu, 17 Sep 2026 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789651078;
	bh=f0H3C/PXI2v2BKGrGpgKC/VjKjokQRh81hrt7hgGNh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DKx3HECzRIB6OL6xjcTSunuwpR94TJqXAdxn4Wgj/OC8FHEghHLFWqSv3g6Y5f90g
	 cS6RqVi89bQ3irnWq3HvwnJxUQ/8kaU+TxwugrJT66bfLPl8YdEoYXkBxmhvhudygG
	 G2v+18BubW3ZeOD8Aa0cBuH27HNwOwfhKqPOUJ+sMu9fe9E8V5GcHSD0Ywqjiu4XD4
	 6m6fCYNDEnIR1ocT5r1AgpbzDca2oQrdc/OwRG3VAizNGe91GNMcPUIYvzQZx2wYwL
	 ZJRhLK5/9WJ/V2EeJK946HJrRCxE/SWPpr2OTCsgVL+RhOLpsFEqNWgXcWi3nIvthR
	 fECH5wivjNmzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: libsas: Fix SMP IO deadlock during HA resume
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917130642.1796231-1-yangxingui@huawei.com>
References: <20260917130642.1796231-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 13:17:58 +0000
Message-Id: <20260917131758.A2F4A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] libsas: missed PM autosuspend in smp_execute_task_sg()
--

commit 8e09b6455fc925eb255f96d9d3584cbd10d1bdaa
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Fix SMP IO deadlock during HA resume

This commit fixes a deadlock during controller resume by using
pm_runtime_get_noresume() and pm_runtime_put_noidle() when
SAS_HA_RESUMING is set. Outside of the resume window, it converts
pm_runtime_get_sync() to pm_runtime_resume_and_get() to handle
runtime resume failures.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index 811c9eb4fef11..a17b938cd3b7c 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c

[ ... ]

> @@ -135,7 +150,10 @@ static int smp_execute_task_sg(struct domain_device =
*dev,
>  		}
>  	}
>  	mutex_unlock(&dev->ex_dev.cmd_mutex);
> -	pm_runtime_put_sync(ha->dev);
> +	if (ha_resuming)
> +		pm_runtime_put_noidle(ha->dev);

[Severity: Medium]
Does this leave the device permanently in the RPM_ACTIVE state if this
thread outlives the host resume?

If an independent thread starts an SMP IO while SAS_HA_RESUMING is set,
it increments the PM usage count via pm_runtime_get_noresume(). If the
host resume process finishes before this SMP IO completes, the PM core
drops its own reference and performs an idle check, which fails because
this independent thread still holds a reference.

When this thread finishes and calls pm_runtime_put_noidle(), the usage
count drops to 0 but the idle check is explicitly skipped. This means
no autosuspend will be queued, and the device might leak its active
state, preventing the controller from autosuspending and leading to
higher power consumption.

> +	else
> +		pm_runtime_put_sync(ha->dev);
> =20
>  	BUG_ON(retry =3D=3D 3 && task !=3D NULL);
>  	sas_free_task(task);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917130642.1796=
231-1-yangxingui@huawei.com?part=3D1
