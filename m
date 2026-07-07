Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108BE3D25A2
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408296; cv=none; b=sN+HFzQkmpX/Dapx4A6MCiG/cRokH95z3Haju7nurGsjfDH5+zlNwPeTp+lOha+VF2QNc1l556rsUjFRHnZ6wUbQCWTPL9hFMYYD2CQe1yb/sZYlY699AzOGBFAGzmZcavBjA4ZitkWMBNlx9n+LlU5THW/by3tnTjqkkWzKcE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408296; c=relaxed/simple;
	bh=vQ0h3rd42/v40y1lhZd1y6cicVChq8PSd81y4go+TTw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dU/c/xa04F9vaYhmJEmJK7Sl4LVowneOpd9bjEZrsBdm2x/M6OYOCEaAvLH5w630hqilHQM0K/0c4BP07lDGhCH1MRIHNroOoQMwHtzyexlUNNjZjbKVXLzy9JvYRVRd/Ox0eg/wD/VQEiwaToHGmHMBKukMRVmn8HREARsmvP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2nhqyKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2nhqyKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED581F00A3D;
	Tue,  7 Jul 2026 07:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408294;
	bh=Th+4jioPSfV4k4xHL1NcPMEey5HKki6l2lkc1zhuw7s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R2nhqyKoci0pPz1303ghzZXRvK02WLA505xw7jrZHyK/UcooyEVXD6FOd2QXfNuQD
	 sQ+d5YXY/JL612gb+dGUNZqKhpthbXl7lhdJPPk3thb9zxZncKQr8oONzMcX0NlfEo
	 Q3xeeS9jbv3ah26Ek1vWOHe/qtq/wHAkaMe5c7vCP5A9G7yqdBntPCHpIMW0pAZKZJ
	 smgUwpt8LpDu4oNlzv+N6Fpoc5yOrjohk+uOjkWfPbXBUYtUzsyZkRIxgqpIssQmBx
	 Y+GCIre+zlbvR1mGfWRBG91SETivuu9P8MYSb1ws9biGbkMtAmotBJOb6+6FdnXvtj
	 MHneCUI8gXrNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 64/88] scsi: qla2xxx: Fix FCE trace enable parsing in
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-65-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-65-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:11:34 +0000
Message-Id: <20260707071134.7ED581F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Lack of lock intersection causes a Use-After-Free when the firmwar=
e dump buffer (ha->fw_dump) is reallocated or freed concurrently with a fir=
mware dump execution.
- [High] Lack of lock intersection causes a Use-After-Free on the FCE DMA t=
race buffer (ha->fce) when FCE is disabled concurrently with a firmware dum=
p.
--

--- Patch [64]: [PATCH v3 64/88] scsi: qla2xxx: Fix FCE trace enable parsin=
g in debugfs ---
commit 02e83541ddb08a379d31174a562473a3c77f5887
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix FCE trace enable parsing in debugfs

qla2x00_dfs_fce_write() called kstrtoul() with a NULL result pointer,
so a successful parse would dereference NULL and oops. Worse, the int
return value (0 on success, negative errno on failure) was assigned to
the unsigned long enable flag, inverting the intended logic: a valid
number was treated as "disable" while a parse failure enabled FCE.

Parse the value into enable and propagate parse errors to userspace.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_df=
s.c
> index 177d47e92e494..5d08bdbcf70ae 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -510,7 +510,9 @@ qla2x00_dfs_fce_write(struct file *file, const char _=
_user *buffer,
>  		return PTR_ERR(buf);
>  	}
> =20
> -	enable =3D kstrtoul(buf, 0, 0);
> +	rc =3D kstrtoul(buf, 0, &enable);
> +	if (rc)
> +		goto out_free;
>  	rc =3D count;
> =20
>  	mutex_lock(&ha->fce_mutex);

[Severity: High]
This isn't a bug introduced by this patch, but could this cause a use-after=
-free
when the firmware dump buffer is reallocated?

When this function calls qla2x00_alloc_fw_dump(), it can free and reassign
ha->fw_dump under optrom_mutex:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_alloc_fw_dump() {
    ...
                vfree(ha->fw_dump);
                ha->fw_dump =3D fw_dump;
    ...
}

Concurrently, if a hardware error triggers a firmware dump, qla25xx_fw_dump=
()
reads from ha->fw_dump holding only hardware_lock:

drivers/scsi/qla2xxx/qla_dbg.c:qla25xx_fw_dump() {
    ...
    if (!ha->fw_dump) {
        ql_log(ql_log_warn, vha, 0xd008,
    ...
}

Since hardware_lock is not held during the vfree() in qla2x00_alloc_fw_dump=
(),
could the concurrent dump write to freed memory?


[Severity: High]
This is a pre-existing issue, but does freeing the FCE trace buffer here
expose a use-after-free race with firmware dumps?

When FCE is disabled, qla2x00_free_fce_trace() is called, which frees ha->f=
ce
without holding hardware_lock:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_free_fce_trace() {
    ...
    dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce, ha->fce_dma);
    ha->fce =3D NULL;
    ...
}

Concurrently, if a firmware dump runs under hardware_lock, it copies from
ha->fce:

drivers/scsi/qla2xxx/qla_dbg.c:qla25xx_copy_fce() {
    ...
    if (!ha->fce)
        return ptr;
    ...
    memcpy(iter_reg, ha->fce, FCE_SIZE);
    ...
}

If qla2x00_free_fce_trace() frees the buffer just before the memcpy(), could
the dump read freed DMA memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D64
