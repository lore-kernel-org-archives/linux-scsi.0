Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9A634A78E
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195909; cv=none; b=NLcK3pCQw6ggm+W2pLkUMdYBAkO6na8wVWxTu7DrSwTN5bz7VPUDmtBB8ScZyop4YNqpN8xRAI/1/5EyYJ5KBKXKO2X54/0m1Bhfwg07xvnmKEzCZbN6+Bq2EXhAjd2iEoo7dMQS2Pr/ryt07L/1piajIv0aqlmGsSkNRFx1ufs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195909; c=relaxed/simple;
	bh=LNg2B0OBe5yd7VKDWzxEekson6erFAufH8LYeHCG0+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LnjP4btqdJ64Cl0dQnBeqpfM56SA1OcCW+ugHkYKNh3dsqg9dc16S559NTLYNw14m7sUXYEWbCGCpYEqb2ObvS0G5YIC/FomFfymMRPqb1sMxdpPvoUHy7MutqW3iFngXBf8W5RhhnTFAVcZTxZW+u9sU93Y7XUxOxbqdYF6tGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bD3g/6Hn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bD3g/6Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF391F000E9;
	Mon, 31 Aug 2026 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788195907;
	bh=fR59VanO/iqJPbGG3vfQXD+ysUPokzSqGEbwQiqw0Gg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bD3g/6HnrH/B4g0Skw6+rvfCM0s08WoxHVi1cvyQFp7KU0GBBVcEYmsioQdc1tZ/+
	 Qz2GDXXRL4A6dp1bq+TGJ1OW07zP3rZekBtsUx7Sh/vDSlZf/6udf2XwkZBs0sZBdz
	 b/HiLBF8c//14aIZDlCZPivO/fXzmCps3Q/m+8g4t+Q7AyKCOZlBDvxugN4VpCC/a1
	 Wa+9SKZfusp/ZoJs/lGMq/WeJJpjRqabHgo0za3qcAKUZQQJijH69TZ5Zfn84aFtON
	 3ngfEEOxc9m+vGRF/HJTVaFmLz5dTexrIRdBurhjVfBksSKMTbBrwIjQSCtVI6foWc
	 t4h7dJwLhnhRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] scsi: pm8001: Reject firmware update
 in fatal error state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831133314.4125787-555-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-555-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 17:05:07 +0000
Message-Id: <20260831170507.AEF391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] TOCTOU race in fw_status check allows concurrent firmware updates,=
 leading to a double free and Use-After-Free (UAF) of pm8001_ha->fw_image.
--

commit 0afa89048afde066ccd69e2cb178118dd117d047
Author: Kumar Meiyappan <kumar.meiyappan@microchip.com>

scsi: pm8001: Reject firmware update in fatal error state

pm8001_store_update_fw() allows a firmware update request even when the
controller has already entered a fatal error state. This commit rejects the
request early by checking controller_fatal_error to avoid a call trace.

Link: https://patch.msgid.link/20260416153757.414896-1-sagar.biradar@microc=
hip.com

> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
> index cbfda8c04e956..bb38b2d63acb8 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -826,6 +826,14 @@ static ssize_t pm8001_store_update_fw(struct device =
*cdev,
>  		goto out;
>  	}
> =20
> +	if (pm8001_ha->controller_fatal_error) {
> +		pm8001_dbg(pm8001_ha, FAIL,
> +			   "controller in fatal error state, firmware update rejected\n");
> +		pm8001_ha->fw_status =3D FAIL_PARAMETERS;
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but could this sysfs write handl=
er
be subject to a TOCTOU race condition if multiple threads with CAP_SYS_ADMIN
privileges write to the update_fw sysfs attribute concurrently?

Because kernfs does not serialize concurrent writes to the same sysfs file,
the check earlier in pm8001_store_update_fw():

	if (pm8001_ha->fw_status =3D=3D FLASH_IN_PROGRESS)
		return -EINPROGRESS;
	pm8001_ha->fw_status =3D FLASH_IN_PROGRESS;

lacks lock protection. If two threads pass this check simultaneously, they =
will
both proceed and later call request_firmware() on the same pointer:

	ret =3D request_firmware(&pm8001_ha->fw_image,
			       filename_ptr,
			       pm8001_ha->dev);

This would leak the first firmware allocation. Furthermore, both threads wi=
ll
eventually call:

	release_firmware(pm8001_ha->fw_image);

Does this sequence result in a double free of pm8001_ha->fw_image?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831133314.4125=
787-555-sashal@kernel.org?part=3D1
