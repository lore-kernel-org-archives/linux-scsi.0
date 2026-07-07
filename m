Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BF638944E
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783404829; cv=none; b=APZlPo5irMvkvQ9F8msJEOhRvRi6U5+TvH4D4/UlLv292l04eSRb5MvBwITdRbriNzRMLVFBgpLCSgnYLuYZ0P/F5WhJeBBBKKCDt8fOU8At6W8J++YVNTpP6qBpb9OPPBdBnPRKfV9yVyWvUjrXhd8flWYUG4qnOcFfmtXlkUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783404829; c=relaxed/simple;
	bh=auUqZysxn3n6QnsvkcmiWlQT/MEU1IluWjxwUdE9TqY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DAc4XGEyMMLkJDD5B422i+NS5s1i7kUUnlkIb/2pNmZpktQ4W/9qO2ZKZJkNju7w+E1AyxRCD2NRQbz3KNzeincPSj4qnLWT4AT4EeRhF75l0uXmaftiBe+BQH8JV1BLjIMRI1NgKCUhZ3a5q/cIP82UjYdAXYgZJJg6P7mCmH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJaNKB28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJaNKB28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004FF1F000E9;
	Tue,  7 Jul 2026 06:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783404828;
	bh=NofRkhyCEC/ligPVUVGUtyiZUXLY8dkU32A7u3fg99I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JJaNKB28gUW2lyirbs+Q3QBpDYiJ1kAOk1RgbwrLsmDq6vPEQimReZfpMl2PUQl92
	 VIBLfOH90SzBMQyNh6VMsSxlSYQYS+YdXT/DlLkR5rBSYlyssnc4DSVJETJui3HZ4+
	 IpUDPIglc8K/8MkwvAIHRAxaD98q7c5VZuNHF5WrBdzZVdXaRUJJJ+WhAnoW4V+IDs
	 /lk8YEl84PuG0u8SWdFnC4OFTCdQ3TpPTFClVuTGlNQxrOi2l85EAgcZXCZNWaxPka
	 4SdSegnnMRziszHkMHZ2UVm6MC/OJCv+Y4wPPcvcZHeA4/tDOp88tU95HrtkbjnSan
	 Q8KHDHVViXJFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/88] scsi: qla2xxx: Remove redundant VPD flash read
 in sysfs read path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-7-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:13:47 +0000
Message-Id: <20260707061348.004FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected hardware flash accesses via MMIO without holding `optr=
om_mutex`.
--

--- Patch [6]: [PATCH v3 06/88] scsi: qla2xxx: Remove redundant VPD flash r=
ead in sysfs read path ---
commit a715b0e512d08c739093c4259bc98b7e60076b5e
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

This commit removes a duplicate call to read_optrom() in the sysfs VPD read
path that was executing without the optrom_mutex held. This prevents
exposure of flash access to concurrent optrom operations.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6a05ce195aa05..800751ab562a1 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobj=
ect *kobj,
>  	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
>  	mutex_unlock(&ha->optrom_mutex);
> =20
> -	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);

[Severity: High]
This is a pre-existing issue, but since this patch fixes an unprotected fla=
sh
access by dropping this duplicate call, are there other unprotected hardware
flash accesses occurring in this same path?

Looking at qla2x00_sysfs_read_vpd() just before the optrom_mutex is acquire=
d,
qla28xx_get_aux_images() is called:

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_sysfs_read_vpd() {
    ...
    if (IS_QLA28XX(ha)) {
        qla28xx_get_aux_images(vha, &active_regions);
        ...
    }

    mutex_lock(&ha->optrom_mutex);
    ...
}

Does calling qla28xx_get_aux_images() outside the optrom_mutex critical
section expose flash access to concurrent optrom operations?

There appear to be similar unprotected hardware flash accesses via MMIO
elsewhere that could cause concurrent reads/writes to corrupt software
state regarding flash regions:

- drivers/scsi/qla2xxx/qla_attr.c:qla2x00_sysfs_write_reset() calling
  ha->isp_ops->get_flash_version()
- drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_get_flash_image_status() calling
  qla27xx_get_active_image() and qla28xx_get_aux_images()

>  skip:
>  	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D6
