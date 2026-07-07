Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4541A5B9E
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405368; cv=none; b=NDtH2o0wrtRNIK1+cnCDX3rTY44u56t6oGdyFq9CMmE6saqvK7X2R4c0vWIaxKY9kWiu0khukF2Ms8LvtWGJ/1gh8L2wE0ZlAcqOJbqPRiTgD9fmL4fOz+4ZKJSzrZc10+VS0+nc6PqgZDj1j8GLYBBVvpAlLIntkAKmCMC749o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405368; c=relaxed/simple;
	bh=f6BqVbiKxpubo8U1norgMxOKANDMwosaZOiVCCQc1Eo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iyGdG/dnG7ollznVZp/nZWOf2X8NPqNvgOFj+vcB1ifitFnjE70TpQYmKEHm3ZETI0JidzSTXmAxm+ZvB9V2IChfZlX42UvRaBj2dlTDrhqVXmqwwpQSqff/QMahVtwDsg/M2XK+RxtpLw6nUU9FnRFHehSrK0uCzp2Tp3vxXaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HadSBkbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HadSBkbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947B31F000E9;
	Tue,  7 Jul 2026 06:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405366;
	bh=iTeboLzsKzO6Au9Uzg5iA+9pnBCrLv2frsSUaVI28Uk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HadSBkbZ+eW8UdVxGHdmo4gmExdONKevcQQGj/Ys45Q9LfyaCkFecIqbaVpSbOcJ7
	 intjpeA1xsMfsWwFodKVtZpuJOKXWo+wBLzDqSVqq0G3XFckEcoAInSuYXCh4R2EpQ
	 uGyKOl+o4ZCVPhB+HEYEfDH2ngIEvC+dM8igawGlpxJmn9W8wi62+vatnGRmz0qXzX
	 s+6/225kM0swz1yzrHUBvjBllOUFkKmVqT2gV3YJW1pKAQ1xpJe1eZKYcscWOUXMzI
	 M8xIAqb8oGKhwU9D5HRg8jrAKo5enbPnycoV3Eqi13R44Rlg7ikbD1hLYwfEPzGU4O
	 ujEaqsugdv9gg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 24/88] scsi: qla2xxx: Add support for QLA29XX in
 memory allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-25-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-25-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:22:46 +0000
Message-Id: <20260707062246.947B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Null Pointer Dereference causing kernel panic on error teardown pa=
th for QLA2100/QLA2200 adapters
--

--- Patch [24]: [PATCH v3 24/88] scsi: qla2xxx: Add support for QLA29XX in =
memory allocation ---
commit db4cb43a507169e793ecdb17d74dbe9af9a96803
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add support for QLA29XX in memory allocation

Enhance the qla2x00_mem_alloc function to include checks for QLA29XX
adapters. This modification updates the conditions for memory allocation
and cleanup, ensuring proper handling of the new adapter series alongside
existing QLA27XX and QLA28XX checks.

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

[Severity: High]
This is a pre-existing issue, but does the error path in qla2x00_mem_alloc()
just above this change have a potential null pointer dereference?

If the driver probes a QLA2100 or QLA2200 adapter, it skips allocating
ha->ms_iocb and ha->ct_sns, leaving them as NULL, and instead allocates
ha->sns_cmd. If a subsequent memory allocation fails, the teardown path
jumps to fail_req and unconditionally falls through to fail_free_ms_iocb:

fail_req:
        dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
                ha->ct_sns, ha->ct_sns_dma);
        ha->ct_sns =3D NULL;
        ha->ct_sns_dma =3D 0;
fail_free_ms_iocb:
        dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);

Since dma_pool_free() does not safely handle a NULL vaddr, could this
attempt to write to address 0 and cause a kernel panic?

> -	if (IS_QLA82XX(ha) || ql2xenabledif) {
> +	if (IS_QLA82XX(ha) || IS_QLA29XX(ha) || ql2xenabledif) {
>  		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
>  		ha->fcp_cmnd_dma_pool =3D NULL;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D24
