Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082FD36B910
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 09:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635623; cv=none; b=qBZdEh40ilLoT9EVlayFupkMz6hUplyJqxhBvsdhV8dxFRrzPnWXDrSwZY9rDZm2I8HA15dJpdMrgFW4g++nU0undQoM0dw0Dlb/0jWILcEsx0SFyKsVoJ3PKgG1d5N8k2yViWyovVeHPKtzae6MTlKQGhfqr/vyKkSQ2mwFyD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635623; c=relaxed/simple;
	bh=ATu+bUtMngahMCW0wbTiWZrxSHdx5y9TG0jaZqhcaUU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jPqWZt8fYHrZLqHlst1eAimrBRT6NuH5sHxPeAlVYb1BI4/7x7HnU6PcbiSBOK1sN+ZHCGWtvdr9oBDagoVSMEvoQfmgnQJYrhkscz95TjXY6eJyiZVcFNvSFHX6S4lhrntU0MwaedDS0fsWdTNENq/nkY5zt79Oqi1N43l06SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blqbGz7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blqbGz7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6E81F000FF;
	Thu, 17 Sep 2026 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789635621;
	bh=SwsVb2OMZ8vYHVUM7C3prCvGb/Rf+EcS/KEDpMBZFLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=blqbGz7g9v032wu5Wr/o2vplRZBh3gzkOikMZgWSeMJ6acQVUqynrYJzM0pPV+y4U
	 1/TMYNUFDYOftZ1z/lG30wZHcFqBsMFfr52VPuVQK9YAD8G8AqklQ6U+pb0YWuqFyw
	 jfDSSMFeuuWniHUeiwWLpvCo9rKT9wkZYdDMoYMELYKisfsgDjmkLwgKWIiO7evsnK
	 WcYtWGV9nBZQuEP0Y5oeIZlV0KWsabUvm6rohXi65J8lbdllog/q3RHhM3Gw1e4kVd
	 hCXofGkHMDQO6HjM8UKPSf+1+G1G0AP5Nyv5+drG/Rb6KwvwvW0KrFS1e9B6Ugewtx
	 qyh5ymmHDdhFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917084553.559765-6-cassel@kernel.org>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 09:00:21 +0000
Message-Id: <20260917090021.7C6E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: scsi_debug: zone write pointer incremented on failed ATOMI=
C WRITE
--

commit 9183d5d7f092b92218c3638f33edc6839086d9f3
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)

WRITE ATOMIC (16) is a write command, so on a zoned device it is subject to
the access requirements of the zone that it addresses, and it advances the
write pointer of a sequential write required zone. This patch validates the
access and advances the write pointer holding the zone metadata write lock
across both operations.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 5a95b7cd7a44c..d52b1f762afb5 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6209,7 +6209,24 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
[ ... ]
>  	ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +
> +	/* If ZBC zone then bump its write pointer */
> +	if (sdebug_dev_is_zoned(devip)) {
> +		zbc_inc_wp(devip, lba, len);

[Severity: Medium]
Does this code advance the write pointer even if do_device_access() fails?

If a command like WRITE ATOMIC (16) is submitted with an invalid DMA
direction (e.g., DMA_FROM_DEVICE via SG_IO) or a truncated scatter-gather
list, do_device_access() can return -1 or a short length.

Because the write pointer in resp_atomic_write() is incremented before
checking the return value of do_device_access(), the mock device's internal
zone state could become out-of-sync with the simulated physical medium.
This could cause subsequent valid writes to be incorrectly rejected with
UNALIGNED WRITE COMMAND.

> +		sdeb_meta_write_unlock(sip);
> +	}
> +
>  	if (unlikely(ret =3D=3D -1))
>  		return DID_ERROR << 16;
>  	if (unlikely(ret !=3D len * sdebug_sector_size))
>  		return DID_ERROR << 16;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917084553.5597=
65-4-cassel@kernel.org?part=3D2
