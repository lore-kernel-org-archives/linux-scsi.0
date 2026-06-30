Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FB03CB8FB
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 11:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782818349; cv=none; b=uIeqaz2DGpo0IZVAtQI3EB7BJEPxkOGbRUlT5PGxmD/jOCoP2dyRs8yIEMb7a4YEBitot1PetBM+G2ejq38xGBZ6uiG8+pQeqwa19/kwe99BDYju6XqoIYc5soAzlDzyK3ngG4jt67IvKyTRhJpSUgysEptHee9McAL/ZhCTsqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782818349; c=relaxed/simple;
	bh=YgostYn3Z/HjV6wNXUQgjkZKbzl2YC4UmWJXkvBX1Tc=;
	h=From:Subject:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mDpTvHlLTeyD6DNaqfwExO7tlIUmRl+CvYkHuBltRm7qj64MPomOHZyJsblOnQcNjYYrk5UfMZJN+1d9V3zKgRvnlCw/05Z33VSLxdxwxCKUgMCuIRWAHH8mtWe7443KuDz3+a/DvXT7j3AE5yuo5RTWh9RPtTzqeaIbcXvE1UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ugpao+HA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ugpao+HA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC94B1F000E9
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 11:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782818348;
	bh=uuj7//+7u7gvPoy2H4NgOquVd2FOVyogRaQcxl6DTfs=;
	h=From:Subject:Reply-To:Cc:In-Reply-To:References:Date;
	b=Ugpao+HAZPo1rGP6iZb/xN76FEknljk8unDpryMcY9AH0xlkulU1Q391f2zba/mFQ
	 N9/XxRosCSIZHRf8yb7ZMtvd3/axJzv0p7+/PI8sC+2Og/8+CMc64CA7uT4MXucwp1
	 jfdzm1siA35Y8YaAlvaSAnQRIY0WNFowL9KnDeuuofZyarQ65ILO2e5eVjQoAiB0iC
	 iWSHNkSOOVRaS9/3T+CvbSjvPBEHWzqeZ8xtbwREyWKckrnbd8q9oh6pr3h3Kd/DAa
	 FzcMnc1aLA5m4ujxE2/XaBWkw9Sc/p+ETwyC0Lal2bhRvgm8kBMJDVx4EmWDhTye+u
	 Qj7xevHHkXwUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] scsi: proc: use kmalloc() in proc writers
Reply-To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 11:19:07 +0000
Message-Id: <20260630111907.EC94B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The buffer allocated for the SCSI host write_info callback is not =
zero-initialized or explicitly null-terminated before being passed to drive=
rs. This causes drivers that use string-parsing functions like simple_strto=
ul() to read past the user-provided length into uninitialized memory.
--

commit 781e3d263bb9419478bfe3f51bf7dd6d8c93c647
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

scsi: proc: use kmalloc() in proc writers

proc_scsi_host_write(), proc_scsi_write() and proc_scsi_devinfo_write()
allocate temporary buffers for /proc writes using __get_free_page().
This commit replaces the __get_free_page() calls with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redh=
at.com

> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 1799dcae775c0..fdc355d783da3 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
[ ... ]
> @@ -74,7 +75,7 @@ static ssize_t proc_scsi_host_write(struct file *file, =
const char __user *buf,
>  	if (!shost->hostt->write_info)
>  		return -EINVAL;
> =20
> -	page =3D (char *)__get_free_page(GFP_KERNEL);
> +	page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (page) {
>  		ret =3D -EFAULT;
>  		if (copy_from_user(page, buf, count))
>  			goto out;
>  		ret =3D shost->hostt->write_info(shost, page, count);

[Severity: High]
This is a pre-existing issue, but the buffer allocated for the SCSI host
write_info callback is not zero-initialized or explicitly null-terminated
before being passed to drivers.

If a user writes data to a SCSI host /proc file without appending a non-dig=
it
character (like a newline or null terminator), driver callbacks that use
string parsing functions like simple_strtoul() will continue reading past
the user input into uninitialized memory.

For example, this can happen in drivers/scsi/imm.c:imm_write_info():

	dev->mode =3D simple_strtoul(buffer + 5, NULL, 0);

Could we explicitly null-terminate the buffer or use kzalloc() here, so that
these string parsing functions don't read garbage data from uninitialized
memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-b4-scsi-v1=
-0-494fb37ebe7b@kernel.org?part=3D2
