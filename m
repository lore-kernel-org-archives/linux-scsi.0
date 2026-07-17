Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E205F3D648F
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305248; cv=none; b=mATw3xss10iYKWQ81CC+57HBzhZe2d1kM3Jl327p2XE4le3q2epu68b8FyMwnR+QmMXKhj/QRn+dpxqC8gtARjdKJ3M76cu5PxVGMTP/U3/Jq61j7/wqjgUGidPd5lg5Fyu3us1v6bjXjkeS8Fy4cZSW8QELwj0Y0zxQ629nSwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305248; c=relaxed/simple;
	bh=TOp5wGjcX5OYT+0V2qqtrBfBfpJgpF3wSIvf8xm07lo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lIOVbgqDvBnNjP6bafrNfXJS0cTLH973vcnr5v7S3GDw5/kV2HOfn3sN5bFJ2RPCXu0XUpKvMFWbzNhk0tnijmU3xg8FCzWCPywcHZXGhBSHgQcfMzlOO8WcMvJSsMzvr1H8PlLiS8+hTbEVkRbHuz7ZYi2ilxvaZ4tRwiY3tkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQ3uYHI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQ3uYHI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5381F00A3A;
	Fri, 17 Jul 2026 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305246;
	bh=Mu6tizZFm7ntfP7GNXgggMA8K4bpNjlhrSS6zo0EXPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JQ3uYHI34dAZIhqR6O2RfPrCNBy5D/YeouLJlkP76cGUj6fLCfKClfNBGPEdJgokQ
	 lvcBR3AEyvp6QsKhKwDQIA1bP85cN9BcvzFIznCvDF6wXF8xYlYWSpqj/hQPBWCJYH
	 H+Z7Wa2/0v9RJSNCXNCMunMwZtYw/6u55ab6xNEvlGuM3x96oVuDLovLexflpCwo7L
	 MVBiUt9CbMlm9Qmu71A0ICZTnaaaFHRPpGvh/Ehy6PaO5TZ6x2tfNd06e5kIPv8Z9D
	 BM+NfQlOQ7y/Oz2FOhaDNa0yjQg6yQfSXHq0FGfoASUbahJgQoq0TR7BeiSAiCheuI
	 Pvn9rK6e8A84Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/56] scsi: qla2xxx: Add support for QLA29XX in
 memory allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-25-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-25-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:20:46 +0000
Message-Id: <20260717162046.9D5381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unconditional calls to `dma_pool_free()` with conditionally alloca=
ted (and potentially NULL) pointers cause a kernel panic during error recov=
ery.
--

--- Patch [24]: [PATCH v5 24/56] scsi: qla2xxx: Add support for QLA29XX in =
memory allocation ---
commit d2e304ac1a70602773864240ceed6148180e105c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add support for QLA29XX in memory allocation

This patch enhances the qla2x00_mem_alloc function to include checks for
QLA29XX adapters. This ensures proper handling of the new adapter series
alongside existing QLA27XX and QLA28XX checks.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 5450c40259bf9..3be59179a0245 100644
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
This is a pre-existing issue, but while reviewing the error cleanup paths h=
ere,
I noticed a potential issue slightly higher up in the same function.

Could the unconditional calls to dma_pool_free() higher up in the cleanup
sequence cause a kernel panic?

In drivers/scsi/qla2xxx/qla_os.c:qla2x00_mem_alloc(), several DMA pool
allocations are conditional based on adapter capabilities. For example,
ha->ex_init_cb and ha->sf_init_cb are allocated for CNA/newer adapters,
ha->async_pd for non-FWI2, and ha->ms_iocb for non-2100/2200.

If a subsequent memory allocation fails, the error recovery path jumps
to labels that unconditionally call dma_pool_free():

fail_loop_id_map:
	dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
fail_async_pd:
	dma_pool_free(ha->s_dma_pool, ha->sf_init_cb, ha->sf_init_cb_dma);
fail_sf_init_cb:
	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);

And later:

fail_free_ms_iocb:
	dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);

If the pointers were never allocated, they remain NULL. Since
dma_pool_free() does not safely handle NULL pointers in its fast path,
calling it with a NULL pointer could trigger a kernel panic during error
recovery. Should these calls be guarded with NULL checks to prevent
crashing when handling an allocation failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D24
