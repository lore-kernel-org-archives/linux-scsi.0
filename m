Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC81B37418C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306340; cv=none; b=YOQdQSpLUE4p2jNHWEeFzlsEBeL0WZn9IMx9mJ6O/qVLMcm5N8a4/tRHAt39Eao35FtXUuXPmbpA6UqwIFZejna7OV17yxCJMnbKGRrUAEpxDi5blAuokw1XYiXQDOovGoL4m4inFxpHMIroN9txBEbnWpSg1gKdXKZsKcfd9U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306340; c=relaxed/simple;
	bh=0gsJoXvpSXCVsMBxVBnn1c8FX3RNeKTsnea/sVZ19p8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q8Nmf4WkM+d9SJtxcGHKJr7zngLf4deJ6zdcTEawH0xu6kX32g5OhK8EC/BIfgBZY2lkfwflTQjdw6Bi2UOc8t7k5Z5UPJJYuLPtuNga6riyw2ZIOk1EhG+P7YQqElakVS05dgrtHk9LW8AyH2UBF9qBqomQp+Z5BbxwBjk4aVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Di8+4x+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di8+4x+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670D71F000E9;
	Fri, 17 Jul 2026 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306338;
	bh=5I/u7Oklu19yC+AG6iQqVNyJc+qZ4jjvMJoxr8h9DKw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Di8+4x+vkZ4VHli51pOLMGhJx1S69lsRjkoN/j9RrNdILObj5NGgibH6KSsS0jsL9
	 Z/X1NuJG7fjSWx7DLV+nmXCFfcLXV1yVrYquuSP8mC4pDjpcbKDe+ycDKEsOBzqcXu
	 D4FbaCE2J7peHbe+JddFu85/5ra/xbOG+459JUpBgvXaEjFdakf8lrRYu3FTCyNYDS
	 lOC7irKWJ7DDrqyNFpKUc9c4lbLS1DzYAENyo/i+j+Bh3qZ1ZMYcs0wM0aYYtZlL/Z
	 LiWKbWaG7Tj+NcBIPz5/DdrOFs98tokehe43DDW9SLel+y8cH1gpdlPgNZEydX6UE3
	 HKeM3X60TbvvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 39/56] scsi: qla2xxx: Adjust feature gating in BSG
 paths for 29xx support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-40-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-40-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:38:57 +0000
Message-Id: <20260717163858.670D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `qla2x00_do_dport_diagnostics` BSG handler leaks up to 128 byt=
es of uninitialized kernel heap memory to userspace.
- [High] The D-port diagnostics function passes an unaligned inner struct f=
ield to `dma_map_single()` and subsequently modifies it with `memset()` aft=
er it has been mapped for `DMA_FROM_DEVICE`, violating DMA API rules and ri=
sking memory corruption.
- [High] The `qla2x00_update_fru_versions` BSG handler writes uninitialized=
 kernel stack memory to the adapter's persistent storage (NVRAM/flash) and =
can cause a kernel panic when provided a malformed request.
--

--- Patch [39]: [PATCH v5 39/56] scsi: qla2xxx: Adjust feature gating in BS=
G paths for 29xx support ---
commit e379ff9d45844a3d1de7b4db9393d48209a2ed9c
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Extend qla2xxx BSG command handling to recognize QLA29xx adapters and
align feature availability with hardware capabilities.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 46eed5df7eefb..9ee56ccd52b01 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2014,7 +2014,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg=
_job)
>  	bsg_job_done(bsg_job, bsg_reply->result,
>  		     bsg_reply->reply_payload_rcv_len);
> =20
> -	return rval;
> +	return 0;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does qla2x00_update_fru_vers=
ions()
in drivers/scsi/qla2xxx/qla_bsg.c have an out-of-bounds read?

If a user provides a small payload but specifies a large count, the loop:

while (count--) {
    memcpy(sfp, &image->field_info, sizeof(image->field_info));

will iterate over uninitialized trailing stack memory in the bsg array
since there is no bounds check on count against the payload size.
Could this leak kernel stack memory to hardware storage or cause a panic?

[ ... ]

> @@ -2855,7 +2855,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	struct qla_dport_diag *dd;
> =20
>  	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
>  	dd =3D kmalloc_obj(*dd);

[Severity: High]
This isn't a bug introduced by this patch, but by allowing QLA29xx adapters
here, does qla2x00_do_dport_diagnostics() leak kernel heap memory?

The dd buffer is allocated without zero-initialization. If a user provides
a short request payload (e.g., 0 bytes), trailing fields like dd->options
and the 62-byte unused array remain uninitialized.

When sg_copy_from_buffer() copies the full 128 bytes back to the user's
reply payload, could this disclose uninitialized kernel heap memory?

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index cec308811d9eb..ce845afe3e16a 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6566,7 +6566,7 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
>  	dma_addr_t dd_dma;
> =20
>  	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return QLA_FUNCTION_FAILED;
> =20
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x119f,

[Severity: High]
This isn't a bug introduced by this patch, but does exposing this to QLA29xx
adapters risk memory corruption via DMA API violations in
qla26xx_dport_diagnostics() in drivers/scsi/qla2xxx/qla_mbx.c?

The struct qla_dport_diag is packed, placing its buf array at an unaligned
offset. When this is mapped:

dd_dma =3D dma_map_single(&vha->hw->pdev->dev, dd_buf, size, DMA_FROM_DEVIC=
E);

Mapping an unaligned address violates DMA rules. Furthermore, immediately
after mapping, the memory is modified:

memset(dd_buf, 0, size);

Does writing to memory while mapped for DMA_FROM_DEVICE dirty the CPU cache,
which could overwrite the hardware DMA results upon eviction?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D39
