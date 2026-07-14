Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE192F7F1E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784040566; cv=none; b=q+2UULBMbu7ieVbn7i6UymaoLmeWhXDXy+tkK9WdCjbA0sSrv9sVppEWTGM/tPwTdC0y90yZIx7M7d1HhXNvOeFXQ1EknxnNVwDyNrfuyjoTdoNcjFg1GGRc0BfLyK+kY4QQvo9mrY9TtpH1vTfhf0tIOZpwL6dCpH2RDL6ce3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784040566; c=relaxed/simple;
	bh=2yiluNnD5KP+oPUT2er1pYI1KnzVPraeGjGeER+EpY0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cz+P2ISGEhm5gOvo+59XdaCNlN+bs3uP7Mxdk7mSdtCSteUhMyFzaWLGK79dK8tjCGv9znAfs3vkLhwAXqciHF7Y25YCMVNNZlOBlyivVnyzX5wHJQemfF1loQjo2d8+pac4LRuLE4mY+FoBIGXHifnQyOP6FHP7P3kSolsdqrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jON0tyjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jON0tyjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11DC1F000E9;
	Tue, 14 Jul 2026 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784040563;
	bh=4VXoOoIiJbJ5wLv+GtJ7reXLwrbzMvngkPcTteY3ntY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jON0tyjZ00nshW2pNvGRvOAkKIx92cNj5cUizBwtzra5LO9eoW7wuUsN5+SRNt0Ge
	 AcBcZog74MWNngUvHKCgiAn6LRAraxxvTgqje2qdDd23o+jL1pXnELzcyANyM2F3IA
	 IGkgN5ws0KMnPLw9Q3z0/VukyOSBUUtU9Ym/gIWgTbQoNuqZquLlGxVf9zzwuaODbm
	 jqSs2iYtdfpHV73tokMZJwaxCMGi1J2T+K3T03N/qTlWXK5ilzcvAw0fXi3QT5+y3c
	 9maR81vzqzniRLzt/qc1k4M2F4YoJlUCBnmNWSggChxW+JMZuQZPbfinP1wLSY5ykV
	 B9vUwlEV2XavA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 31/56] scsi: qla2xxx: Add 29xx extended logio IOCB
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-32-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-32-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 14:49:22 +0000
Message-Id: <20260714144922.D11DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but DMA memory corru=
ption occurs due to freeing the IOCB buffer before the firmware is reset on=
 a timeout.
--

--- Patch [31]: [PATCH v4 31/56] scsi: qla2xxx: Add 29xx extended logio IOC=
B support ---
commit fd255e4f21f55aa8baef081e73e914c2d628d372
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add 29xx extended logio IOCB support

This commit adds extended logio IOCB support for the 29xx series, which uses
a wider IOCB stride (128 bytes vs 64 bytes). It updates various logio IOCB
builder and completion functions to accept a void pointer and cast dynamica=
lly
to accommodate both layouts.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index f9b326c020557..7dff227899a52 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -2678,7 +2680,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t=
 loop_id, uint8_t domain,
>  						 */
>  	}
> =20
> -	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
> +	dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);

[Severity: High]
This is a pre-existing issue, but could this lead to DMA memory corruption =
if
the command times out?

If qla2x00_issue_iocb_timeout() times out, it schedules an asynchronous DPC
reset and returns, causing lg_buf to be immediately freed back to the DMA
pool here in qla24xx_login_fabric().

If the firmware is merely slow and completes the command before the adapter
reset fully finishes, won't it write the completion status to the physical
address (lg_dma) of this freed buffer?

This could corrupt whatever new allocation is currently using that DMA memo=
ry.

> =20
>  	return rval;
>  }
[ ... ]
> @@ -2898,7 +2903,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_=
t loop_id, uint8_t domain,
>  		    "Done %s.\n", __func__);
>  	}
> =20
> -	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
> +	dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);

[Severity: High]
This is the same pre-existing issue, but in qla24xx_fabric_logout().

Does freeing lg_buf here after a timeout expose the system to use-after-free
DMA corruption if the hardware writes to lg_dma before the asynchronous res=
et
completes?

> =20
>  	return rval;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D31
