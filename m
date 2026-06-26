Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733303F39E8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475629; cv=none; b=bcNImOKyVWNi3oL67SvAThoKhjko5cJmd68RVA3tEstIjW1jRiBTQFfpId0ts8fpfMITYxfy0RHUz9dYosgqsCrwgzOfnQXzNtp3N6DnJPFTC4r1VupXyoVWOaxJcqiJEnyH78KQ/+jAWFPM9kCrrDtlN81bzeABgMCTDEr9Y5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475629; c=relaxed/simple;
	bh=an5+jO/MiSgkZvOBxB3Yfixgkue+y1lAZQGrKXR3yQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eS5pxk6900Vz2p0IYDuFfawbzbA8Xm6uCoQ6fOJYRSs7zF1lrT0Zu3OP7WCJaR6zXpu7gP2Vb/Lafohv4QbC7C0uTEr73g4P65EGnlvgSev8dAWSM/FmGAY3TlfZWCUjUZn1T9DN7cYS1r+g30KTw6XBFrSF8JYAnoxYS6rhEJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haNj/Xdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haNj/Xdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AD81F000E9;
	Fri, 26 Jun 2026 12:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475628;
	bh=A/ls5tiRMJcUVleQN7G8XX639fvKvsiTxg/RQBrK2lM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=haNj/XdlYPHrw6suNA8flyY+tZbp/ratSVslmfX61hox1Yyx0P/eqiR/ytGqtW3UC
	 NRp+nVlanSvIxlsEJPIaZ6SvK1k0J5drPRABHRREI7qv8wxaxcDd83VzMmXOm7WAfh
	 rkHK9spQN7Z7ef7e31pBo2pVUXu4CR+6fVNj/toypZTQLcYE/swVjer76HGmXhE4JU
	 gUQ5xs6SrRo+tvi5XJGxiNcdnZPOYbYAYJwE7h52Yt67rLa8OQuqxJMunS5LesHdg+
	 zwcikIEmacLMsoFdaKEJKjQMK+P+xmhomXYLUysPjhV0PTCOtAvAwPJBGdfgBHUKbc
	 xcmJKiGnayIHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 02/10] mpi3mr: Update MPI Headers to revision 41
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-3-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-3-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:07:07 +0000
Message-Id: <20260626120708.32AD81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing endian conversion for `driver_pg1.flags` before bitwise AN=
D.
--

commit dcead2e50e7c04fa8f12bc236d238e9408c959bb
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Update MPI Headers to revision 41

Update MPI Headers to revision 41.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -4128,11 +4128,15 @@ mpi3mr_read_driver_page1(struct mpi3mr_ioc *mrioc)
>  	struct mpi3_driver_page1 driver_pg1;
>  	u16 pg_sz =3D sizeof(driver_pg1);
>  	int retval =3D 0;
> =20
>  	mrioc->ts_update_interval =3D MPI3MR_TSUPDATE_INTERVAL;
> +	mrioc->skip_dev_shutdown_on_unload =3D 0;
> =20
>  	retval =3D mpi3mr_cfg_get_driver_pg1(mrioc, &driver_pg1, pg_sz);
> -	if (!retval && driver_pg1.time_stamp_update)
> +
> +	if (retval)
> +		return;
> +
> +	if (driver_pg1.time_stamp_update)
>  		mrioc->ts_update_interval =3D (driver_pg1.time_stamp_update * 60);
> +
> +	mrioc->skip_dev_shutdown_on_unload =3D
> +		(driver_pg1.flags &
> +		 MPI3_DRIVER1_FLAGS_DEVICE_SHUTDOWN_ON_UNLOAD_DISABLE) ? 1 : 0;

[Severity: High]
Does this code miss an endianness conversion for driver_pg1.flags before the
bitwise AND?

If driver_pg1.flags is populated natively in little-endian format from the
controller without swapping, evaluating it against a host-endian macro could
lead to incorrect logic on Big-Endian architectures.

For example, if the firmware sets
MPI3_DRIVER1_FLAGS_DEVICE_SHUTDOWN_ON_UNLOAD_DISABLE (0x01), a Big-Endian C=
PU
would read it as 0x01000000, evaluate the check to false, and fail to skip =
the
requested device shutdown.

Conversely, if a future flag sets bit 24, a Big-Endian CPU reads it as
0x00000001, evaluates the check to true, and falsely skips device shutdown,
which could lead to data loss such as unflushed drive caches.

Is le32_to_cpu() or similar needed here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D2
