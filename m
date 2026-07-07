Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5A3D1AA0
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409114; cv=none; b=YbdBcI00iTXg/M69Rc7il5797eY72K7CDSebYa0lU/E5eIrADmySxk+NWNziphjxsAAhdhhPZ/L0OmVbKBSjBRFoJTCjkMEUA26ImiAn4PwcrWMuuNq0BigVoG9LzEKQQuZVEv0mvSAUMaAVBve98EhTwATicl6IvNywUjkEo6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409114; c=relaxed/simple;
	bh=WeMung0su5HX1AtZyB1IXW+fUJBfTEcHqE3FUfjkqS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KaqT/8mG/euWxTYddWmGHfwRW8Xc3cqNOCZ1/18vCN88odKUbEkK1cuW218mfkTIBKJBpoNHMmZmmHSqwZdXe8P34FMEvapgQ8A8cdM5ejKT/FAux3IcUkPTJ/LhaefbRhrDu1btpRiJczVWZLsAgijbeHZGw4tmO5jb6NtVJuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKCFc9Uo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKCFc9Uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871EF1F000E9;
	Tue,  7 Jul 2026 07:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409103;
	bh=TiMbExork4hBvGiGalEsRDvl5ovGiRqumdefYVEA1vg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bKCFc9UovAv+fcW/CenxpTw7w9v4bcFXeM6ghSEeh3p3otAoWPmlFlT4ZGvhigyUe
	 0cCznruNyjSlJ41m8zKF2VEDsyxCJmIJG3sgpSdBVYN5N7aeiRpL5Z9kFWh/MBOVZY
	 Kb4PEelSoo5x1dgSYwCmdkdI9LDqApyO7O+tANZau/OT0e08GsBeuelOQ7K/HAjHjS
	 OUqQxXAHG/vpCWBcKh8Tmbg4wV1gaG50NbbFqwtvo0c0xja2ggT6JlJBSbUZjWBK6V
	 MKtPO8cV9+/U/tEPRKM9Jpal76v0bky3ijZHcE6uC0hjOuSSk4iVwqOggeTTt0+qYK
	 6/6oSgvwxCqJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 65/88] scsi: qla2xxx: Fix FCE trace use-after-free
 during firmware dump
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-66-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-66-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:25:03 +0000
Message-Id: <20260707072503.871EF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Race condition between FCE enable and firmware dump causes Use=
-After-Free and Buffer Overflow.
- [High] Missing lock / Use-after-free in `qla_enable_fce_trace` and `qla82=
xx_restart_isp`.
- [High] TOCTOU race leading to NULL pointer dereference in `qla2x00_dfs_fc=
e_release`.
- [Medium] Asymmetrical locking in `qla2x00_alloc_fce_trace` leading to dat=
a race and uninitialized memory access during firmware dumps.
--

--- Patch [65]: [PATCH v3 65/88] scsi: qla2xxx: Fix FCE trace use-after-fre=
e during firmware dump ---
commit d9c15811116bd4288fadefd8eb8bb3d8713c9a4a
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump

The commit fixes a use-after-free during a firmware dump by unpublishing
ha->fce under hardware_lock before freeing the dma buffer. A concurrent
dump will now either safely complete its copy or observe a null pointer.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 9d6b229bd3525..76b7ed501b04e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3752,11 +3752,27 @@ int qla2x00_alloc_fce_trace(scsi_qla_host_t *vha)
> =20
>  void qla2x00_free_fce_trace(struct qla_hw_data *ha)
>  {

[Severity: Medium]
This isn't a bug introduced by this patch, but since we are fixing fce
synchronization during firmware dumps, does the allocation side in
qla2x00_alloc_fce_trace() also need hardware_lock protection?

qla2x00_alloc_fce_trace() assigns ha->fce and ha->fce_dma without holding
ha->hardware_lock:

	ha->fce_dma =3D tc_dma;
	ha->fce =3D tc;
	ha->fce_bufs =3D FCE_NUM_BUFFERS;

A concurrent firmware dump triggered via qla27xx_fwdump() under
hardware_lock could observe a non-null ha->fce but read uninitialized
or stale values for the dma address and other fields.

> -	if (!ha->fce)
> +	void *fce;
> +	dma_addr_t fce_dma;
> +	unsigned long flags;
> +
> +	/*
> +	 * Unpublish ha->fce under hardware_lock so a firmware dump in
> +	 * progress (which reads ha->fce under the same lock) cannot race
> +	 * with the buffer being freed.
> +	 */
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
> +	if (!ha->fce) {
> +		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  		return;
> -	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce, ha->fce_dma);
> +	}

[Severity: High]
This is a pre-existing issue, but can qla_enable_fce_trace() and
qla82xx_restart_isp() race with this hardware_lock protected clearing
of ha->fce?

In qla_enable_fce_trace():

	if (ha->fce) {
		ha->flags.fce_enabled =3D 1;
		memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));

Neither function holds ha->hardware_lock or ha->fce_mutex.

If a debugfs fce trace disable runs concurrently, this function clears
ha->fce and frees the dma buffer. The abort path could read a non-null
ha->fce, get preempted, and then execute memset() on the freed memory.

[Severity: High]
This is another pre-existing issue, but is there a time-of-check to
time-of-use race in qla2x00_dfs_fce_release() that could cause a null
pointer dereference?

drivers/scsi/qla2xxx/qla_dfs.c:qla2x00_dfs_fce_release():

	if (ha->flags.fce_enabled || !ha->fce)
		goto out;

	mutex_lock(&ha->fce_mutex);

	/* Re-enable FCE tracing. */
	ha->flags.fce_enabled =3D 1;
	memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));

If !ha->fce is evaluated without holding ha->fce_mutex, a concurrent
write to the fce debugfs node could disable tracing, acquire fce_mutex,
and call qla2x00_free_fce_trace() which sets ha->fce to null.

Once the write releases the mutex, qla2x00_dfs_fce_release() acquires
it and calls memset(ha->fce), causing a crash.

[Severity: Critical]
This is also a pre-existing issue, but is there a race between fce
enable and firmware dumps that can cause a buffer overflow and
use-after-free?

In qla2x00_dfs_fce_write():

	if (!ha->fce) {
		rc =3D qla2x00_alloc_fce_trace(vha);
		...
		if (!ha->flags.fce_dump_buf_alloced)
			qla2x00_alloc_fw_dump(vha);
	}

This populates ha->fce before resizing the fw_dump buffer.
qla2x00_alloc_fw_dump() calls vfree(ha->fw_dump) holding optrom_mutex
but not hardware_lock.

If a firmware dump begins under hardware_lock just after ha->fce is
populated but before the new buffer is allocated, it will see
ha->fce is not null and insert bytes into the old fw_dump buffer:

drivers/scsi/qla2xxx/qla_tmpl.c:qla27xx_fwdt_entry_t264():

	if (vha->hw->fce) {
		...
		qla27xx_insertbuf(vha->hw->fce, FCE_SIZE, buf, len);
	}

This overflows the buffer since it wasn't sized for fce data.

Additionally, while the dump is writing to buf (which is ha->fw_dump),
alloc_fw_dump() could concurrently call vfree() on that exact buffer.

> +	fce =3D ha->fce;
> +	fce_dma =3D ha->fce_dma;
>  	ha->fce =3D NULL;
>  	ha->fce_dma =3D 0;
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
> +	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, fce, fce_dma);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D65
