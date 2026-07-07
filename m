Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B833E025F
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409167; cv=none; b=q01oNwP4kwVdnKkpA7Ui36l3yf9n+7RCQtNX5yDPD4EHvbV0Vun8awr3vZxN8FDjol0o5vG1F+Zx0u639a4sPI4z5OAumRgkLtIhICbE5ClzRM36Ayw9w5PVjjkHPsa+x9plYWv9J182wFiDQjxhBIpvhVbiF+n8mnmd7vLdTRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409167; c=relaxed/simple;
	bh=Orb2jSxEwUYKemMio0WxkI4AiEGCNY52lKqJR8NTLbY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rJjtNh/c10/gv8ow6Xow1RpC2nGZfzN5hmhvLnMKoAX29SBYmKG/sFK+eA67L8Ok246BkLUHf0TPPRVc6pzldzO3j6G+5iYie/B9KM26sAMEgB54IKvKOMyoH1ilf89xD8a2Dd3PISAAcn1N3w1HReBwDZUpfyGRrYa99qiX+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2Y71+Kz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2Y71+Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EFA1F000E9;
	Tue,  7 Jul 2026 07:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409157;
	bh=XrRz+LABxf/FBD7CpImRU5bledHSRA+tLayv82D2fYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d2Y71+KzIQTiZz1k3IUS7aG8hvGQFWCdyxLsh8WivO++xmVtRkLBtgbGHKNqmLCjx
	 4VY6uHiMqboD1v8rWTd6fuQFy5l20AyEciF+4GpPO7TyZKvHng2KiFi/k9b3tle0gm
	 loLWRZI7k2rwD4huZzKgmruKchhNUp5fvZv6k7YrraI1fqsKk/X5m6BofLJCwrXyAR
	 NVaZoFBfyLi/QpSyBlZLphy+XjECfRmj3cOQHmEY1B8Ucfm/NQPZzgQ2GNJ4H5DQWy
	 0IRSKpffeot5WHlXCUELow3a0DkFOXBwS8bDit+MjuryYy876QSMUJzI5tdluF7bjj
	 UE4qro7Fn114A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 67/88] scsi: qla2xxx: Null out freed pointers in
 qla2x00_mem_alloc() error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-68-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-68-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:25:57 +0000
Message-Id: <20260707072557.C4EFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double free of ha->sns_cmd in error path of qla2x00_mem_alloc.
--

--- Patch [67]: [PATCH v3 67/88] scsi: qla2xxx: Null out freed pointers in =
qla2x00_mem_alloc() error path ---
commit 67cec0babb19e6c4e62f136f94d2843f83907bad
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

This commit updates the error handling path in qla2x00_mem_alloc() to null
out several pointers after freeing them. This prevents a subsequent call
to qla2x00_mem_free() from double-freeing these resources when the hardware
probe fails.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4619,28 +4619,43 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_=
t req_len, uint16_t rsp_len,
[ ... ]
>  fail_ex_init_cb:
>  	kfree(ha->npiv_info);
> +	ha->npiv_info =3D NULL;
>  fail_npiv_info:
>  	dma_free_coherent(&ha->pdev->dev,
>  		((*rsp)->length + 1) * rsp_entry_size,

[Severity: High]
This is a pre-existing issue, but since this patch is cleaning up dangling
pointers in the qla2x00_mem_alloc() error path, should ha->sns_cmd also
be cleared?

Further down in the error cleanup for qla2x00_mem_alloc(), ha->sns_cmd is=20
freed without setting the pointer to NULL:

fail_free_ms_iocb:
        dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
        ha->ms_iocb =3D NULL;
        ha->ms_iocb_dma =3D 0;

        if (ha->sns_cmd)
                dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt=
),
                    ha->sns_cmd, ha->sns_cmd_dma);
fail_dma_pool:

If an earlier allocation fails on legacy hardware, the cleanup code frees=20
ha->sns_cmd and leaves it dangling. When the error propagates up, the probe=
=20
error handler probe_hw_failed calls qla2x00_mem_free(). Since ha->sns_cmd=20
is still non-NULL, qla2x00_mem_free() will free it a second time.

Could this lead to memory corruption during probe failure on older systems?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D67
