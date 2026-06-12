Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D936F91F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260845; cv=none; b=ifWVfZHensBh4a6N70DLrAubesiBGYjODBP84SkB/O6ypQ7C1HCSMfsWQe2NDS4SPKhLv7Fyjt8trgrutjtMZUoqwJo+vENQg4hpHxdl6nHOi5HvJsAcEIUTgeD/xC8mTDiTGyyPoQrRaMY6vG4RG9sMAjSI3NMpE6nrBA57cDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260845; c=relaxed/simple;
	bh=2olPoPCBkrIbTiF0sn0sCApEm7ZQxVwWw1iHADaE7Xs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GY53Tr7i+Upf8u0fVDVIaC+OQmLEqjDe5OLG/c/iyHP4GWIcJGVFCXyh1+3fCkNd94XtyCnAhkevcXI0OU/Yo4+p31yfWWd2DAdOr+WxnsG9fSUkjapnhRYR3ISG+riKVW3CUcEB87zwQ9oDAGbo5gp+7yzKC/ZDtL/jIKgD/+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdRofQ4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdRofQ4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F471F000E9;
	Fri, 12 Jun 2026 10:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260843;
	bh=qWS68IZeIYVxIzb74AVm6qcv43PkEvOdmEagL9pMdow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JdRofQ4Jo/T2H/sGy6QvL8CqDxFPYoBtxHK04fuQMM9ppo5E8/CTg216nCV9CwFf6
	 tDz58PPQE3DCUn4kfF677dwNkSFD9rtEpZIbdTovv5LCWda1U5uFkf7SpGLWxBAcV8
	 t8QlmK+wuuMJaMMv1jHXwidP2atEM4+0kJQJgFg2i7ucHJ5jgSOmdvmJpJ3O11JaJY
	 mvhYHkZY4oL9KG+BEDM40VHPgvFctz9ml4lyQzthxlfrlXy9uTS8A9BVTiqYKXSxtO
	 OxziWAcJJBMDHH3ndxtyxqubEG+6MSC1+cEqMAeflHmSNDm3SalOh6sityyNEcr/Lj
	 jdG+B5dIJEIRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/60] scsi: qla2xxx: Add support for QLA29XX in
 memory allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-27-njavali@marvell.com>
References: <20260612095333.1666592-27-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:40:42 +0000
Message-Id: <20260612104043.A1F471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double frees and NULL pointer dereferences occur on `qla2x00_mem_a=
lloc` error paths because freed pointers are not set to NULL.
--

commit ec7e8420d4fa55d2851ed0f0ca2bc56ab9339db8
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add support for QLA29XX in memory allocation

This commit enhances qla2x00_mem_alloc to support QLA29XX adapters. It modi=
fies
the conditions for memory allocation and cleanup, ensuring proper handling =
of
the new adapter series alongside existing QLA27XX and QLA28XX checks.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index a3e2c0a95a99b..3ac48eeb9f698 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -4681,12 +4683,12 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_=
t req_len, uint16_t rsp_len,
>  	}
> =20
>  fail_dif_bundl_dma_pool:
> -	if (IS_QLA82XX(ha) || ql2xenabledif) {
> +	if (IS_QLA82XX(ha) || IS_QLA29XX(ha) || ql2xenabledif) {
>  		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
>  		ha->fcp_cmnd_dma_pool =3D NULL;
>  	}
>  fail_dl_dma_pool:
> -	if (IS_QLA82XX(ha) || ql2xenabledif) {
> +	if (IS_QLA82XX(ha) || IS_QLA29XX(ha) || ql2xenabledif) {
>  		dma_pool_destroy(ha->dl_dma_pool);
>  		ha->dl_dma_pool =3D NULL;
>  	}

[Severity: High]
This is a pre-existing issue, but does the error path in qla2x00_mem_alloc()
lead to double-frees and NULL pointer dereferences?

When qla2x00_mem_alloc() fails during late allocation stages (e.g., at
fail_lsrjt or fail_async_pd), it frees adapter members like ha->elsrej.c or
ha->async_pd but leaves the pointers non-NULL. The function returns -ENOMEM,
and the caller qla2x00_probe_one() handles this by branching to
probe_hw_failed, which unconditionally calls qla2x00_mem_free(ha).

Because the pointers were not zeroed out, qla2x00_mem_free(ha) evaluates th=
em
as valid and attempts to free them again, resulting in a systemic double-fr=
ee.

Additionally, fail_s_dma_pool destroys and correctly NULLs ha->s_dma_pool.
When qla2x00_mem_free(ha) later evaluates the dangling ha->async_pd as true,
it calls dma_pool_free(ha->s_dma_pool, ...) with a NULL pool pointer, which
will cause an immediate kernel panic when the allocator lock is dereference=
d:

qla2x00_mem_free() {
	...
	if (ha->async_pd)
		dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
	...
}

Should the error labels in qla2x00_mem_alloc() that free resources be updat=
ed
to also set their corresponding pointers to NULL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D26
