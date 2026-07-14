Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F6374E7F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025758; cv=none; b=fjChT0Uhkm9p1EElIQUZPfV2tr6jIpZsR+aza0PzqhFavRiDxl6FuT5yYAXP40VGIpxlyVn3LryCJ4uK4Co/la7env9VUheoleWjThoz2kxTYG4b4br2E/YtS4Dly3P6yQTP9nJcT3n8CrQEv+b4qZyJl4VZb58Toz9BN6c7hpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025758; c=relaxed/simple;
	bh=K/ps9oRHyg/vt+fKJcaRSRGynBPaasKS2Q3C1v5LM3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e//IWadfAkmQonHizdaHcN8tK6+Bl2vSiDEGGiuw3dDiUvEauJRq0QNCZa5axpfBr94TkVYtgBUwOwj579S5l2Q470Bm/1WC58Nc3XzhtKennuFoaVaCgzfRUMbZm/WsdcasxebgF3pww6hWoRMVV0fz6LE3Pfc0mRrCBM+ubJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d42xTXxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d42xTXxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263351F000E9;
	Tue, 14 Jul 2026 10:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784025757;
	bh=e5B6EwpUUET4B2UQ3Lk5g+0S7X8CuAaCsWqQ5b4VhdY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d42xTXxJu61cFzcpdLT7M1nSLE90uA57hBgSJdlLcbUknOB47/VzRVPqzkRPMHDnl
	 /m1GNbm39LNCcCmRKWtyd7/N3e/vBhYbK+PJicN5dWjYyDmkFKa0kvHxYGgVEj1edh
	 9Om9vBm4qpqgHkScZ++R4VkkHAAne6k7QkqdBVJI/NpBwULk3CVing6OUVL6J92oj9
	 TUQ/7Sl10XM3+WHLpYN4ho1gYJagHu09FyZVsmt55Esr9TEhYLP2jXVZ8yaSzE1Y2l
	 wyBsMMwS7Wh0bTs4OY4v6APUxpNdwF5oPZzljVjLo2ea6Nu/1cyS5QbaFoNJKN0iGx
	 C3qaBzdAY2YIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/56] scsi: qla2xxx: Remove redundant VPD flash read
 in sysfs read path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-7-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:42:36 +0000
Message-Id: <20260714104237.263351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected hardware flash register accesses via `qla28xx_get_aux_=
images()` before acquiring `optrom_mutex`.
- [High] Concurrent accesses to fw_dump sysfs attributes can trigger a Use-=
After-Free or NULL pointer dereference because resources are freed without =
acquiring optrom_mutex.
--

--- Patch [6]: [PATCH v4 06/56] scsi: qla2xxx: Remove redundant VPD flash r=
ead in sysfs read path ---
commit 62e5b966d9421643c341b9735e054bbf8a187205
Author: Manish Rangankar <mrangankar@marvell.com>
scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

This commit removes a redundant read_optrom() call in qla2x00_sysfs_read_vp=
d()
that executes without the optrom_mutex, preventing concurrent flash access
issues.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6a05ce195aa05..800751ab562a1 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c

[ ... ]

> @@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobj=
ect *kobj,
>  	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
>  	mutex_unlock(&ha->optrom_mutex);
> =20
> -	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);

[Severity: High]
This is a pre-existing issue, but does this code leave hardware flash regis=
ter
accesses unprotected earlier in qla2x00_sysfs_read_vpd()?

Looking at qla2x00_sysfs_read_vpd(), qla28xx_get_aux_images() is called bef=
ore=20
acquiring optrom_mutex:

	if (IS_QLA28XX(ha)) {
		qla28xx_get_aux_images(vha, &active_regions);
		...
	}

	mutex_lock(&ha->optrom_mutex);

The qla28xx_get_aux_images() call chain reaches qla24xx_read_flash_data(),
which directly manipulates ISP hardware flash registers. Without optrom_mut=
ex
protection, could this race with concurrent sysfs invocations or other flash
operations and corrupt the hardware state?

>  skip:
>  	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
>  }

[Severity: High]
This is also a pre-existing issue in the same file, but can concurrent acce=
ss
to fw_dump sysfs attributes trigger a use-after-free?

If thread 1 reads the minidump via qla2x00_sysfs_read_fw_dump(), it acquires
optrom_mutex and accesses ha->md_dump:

qla2x00_sysfs_read_fw_dump()
    mutex_lock(&ha->optrom_mutex);
    ...
    rval =3D memory_read_from_buffer(buf, count, &off, ha->md_dump, ...);
    mutex_unlock(&ha->optrom_mutex);

If thread 2 concurrently writes to the sysfs node via
qla2x00_sysfs_write_fw_dump(), it can free ha->md_dump without acquiring
optrom_mutex:

qla2x00_sysfs_write_fw_dump()
    ...
    switch (dump_type) {
    case 0:
        ...
        qla82xx_md_free(vha);

Couldn't thread 1 end up accessing freed memory in memory_read_from_buffer()
if qla82xx_md_free() is called concurrently by thread 2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D6
