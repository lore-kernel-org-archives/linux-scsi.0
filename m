Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9DC3403E9
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303778; cv=none; b=TNO6WwS69QOHf3ZsjV4XXYD5ns+O/Hy37yvT/c5saSrAzq7tj+UM/lQqrkdDAanHt9zW43J938iflwRgz2Se0N7j0mbYl6Ew2FbywDGszTwy9Zx1TWHGZabVrdpVXLFnIi3Emdyd/bmdl+kpZ/ObVfuZU9J8BCJ0ugQV3qF/R1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303778; c=relaxed/simple;
	bh=pCAZaa30DJPJy8mtuV9FQnXNHFVxBkH2hmu2vfRbe/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JLVAPVrF6T9rI++h991P2fPksViSl/m2jnJ7naFEWMIHsxMikiMuE13888mB7yJF+inPN3Hizr9FsN02GKu2fcc3WdBh2iuVgDO8Jm49ydiVxJE+WaB0qmGdwIYB11cvfeSJaGGG8kML/L4lIk7yzgzuqJi1HADkZTi+vKfTYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2ISzyjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2ISzyjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512311F000E9;
	Fri, 17 Jul 2026 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784303776;
	bh=ZOMFXuIS33qjQ/cPMIapXUkDIKLJMwG+ntvwDlwTcsY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M2ISzyjd84vJZPCAeOd+V2Gl+s26nVveh3/uNXKdTdrHwFkLbRv1KPL2zl71dZkdo
	 uHtywJOrwLyzH+RHcN2a17ls7RN5bdYuM6IzQk9JXrVc+SFBKFryZBdtAfNfDjfVAi
	 KKGAjm4RixRwknX9IROGAS6Q/t1nTE0p/hMU/2PDWTT+nMQr2/nXlejho5PPnSAIH9
	 gn1tFmqvxVXmtAko2qdU37WOshMeoKCGyJOCdFfCkIKLyd6Ubnw54DUPLmsuo0eM6c
	 p6c25cxWxYhHJ1g7qyoHxu29PxSiJdg9wxPe+t2lc+/cpLzdQiYnkCFRAx528Rzk2J
	 ak1J3f+Z+3tAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/56] scsi: qla2xxx: Enable set_els_cmds and
 echo_test for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-21-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-21-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:56:15 +0000
Message-Id: <20260717155616.512311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] qla2x00_process_loopback violates the DMA API by writing to memory=
 mapped with DMA_FROM_DEVICE, leading to data corruption.
--

--- Patch [20]: [PATCH v5 20/56] scsi: qla2xxx: Enable set_els_cmds and ech=
o_test for 29xx ---
commit 3169ddf029c9e47c02297da5b77b2f8371f5f469
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
   =20
This commit enables ELS command support and echo test diagnostics on 29xx
series adapters by adding IS_QLA29XX checks.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index d195723fc06bf..a8dd01cb9a9ae 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> @@ -5492,10 +5493,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct ms=
g_echo_lb *mreq,
> =20
>  	mcp->in_mb =3D MBX_0;
>  	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
> -	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha=
))
>  		mcp->in_mb |=3D MBX_1;

[Severity: High]
This is a pre-existing issue, but enabling echo tests for the 29xx series
exposes these adapters to a DMA API violation in the BSG handling path.

When processing a loopback or echo test BSG command,
qla2x00_process_loopback() maps the user's reply scatterlist with
DMA_FROM_DEVICE. It then asks the hardware to write to a separately
allocated coherent bounce buffer.

The CPU then copies the data from the bounce buffer to the user's
scatterlist:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_process_loopback() {
    ...
    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
                        bsg_job->reply_payload.sg_cnt, rsp_data,
                        rsp_data_len);
    ...
done_unmap_sg:
    dma_unmap_sg(&ha->pdev->dev,
                 bsg_job->reply_payload.sg_list,
                 bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
}

On non-cache-coherent architectures, calling dma_unmap_sg() with
DMA_FROM_DEVICE invalidates the CPU cache for the mapped memory.

Since the CPU wrote to this memory via sg_copy_from_buffer() before the
unmap, are we discarding the dirty cache lines before they can be flushed to
RAM?

Could this destroy the payload data copied to the user's reply buffer,
causing userspace to receive stale or empty data?

>  	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha))
> +	    IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  		mcp->in_mb |=3D MBX_3;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D20
