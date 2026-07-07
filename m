Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F213DB649
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409649; cv=none; b=ljEPL3QaBVvZc7mZf0NaqJzfMWyP68z5hx/9YFP4M1sjqxaD+8+pwvQeS2EVScoHimTw8MHBoQ62/Nfogz8E5NfVHT015V8uXvyP8TI+wBYYqcWF3ANi2PdjfvzMc1zgDe9xXqhc8FS+wPhUuPcTbkYt+m4DGQlKtDTuTWJR4jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409649; c=relaxed/simple;
	bh=6Qs9grdR1BYwsgZKtAIUDyS2A3zrqLeuTR116Ubx6OE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GZvuO2dDTULw+u47rQrBE1DUc9gHiFJYD+C/p+OSs/7RHUmgNxzVIuVoKEOFJe5j35dW3bldsqH9rnzLlpJtmQYHjbP05Z+CNQdqTtRJ5rFyLqoyQyM4ENYOxrtqzJqYAd2qDP+wImD74ks+Y5ISoUOstx6Phf61/gMfCR2KeiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qj6+zSC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qj6+zSC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F271F00A3D;
	Tue,  7 Jul 2026 07:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409647;
	bh=ZN7pNLmdEzsWKiH4ds+ebieIzrJHX94eQtKFPdGzXEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qj6+zSC6UwoOMDzk48+ZoggHCN4+BpYKOw2a0CE7+lKBg37Ar1zgMamis6lSBcJ6s
	 8iX5XyF2fDQwAYET11jqGBunCFcJB2tXwnhkcGAN95grPZnIHmfoS+qP1VwL2he5SB
	 xo9GekoDXw2tbU5ESfi3vtaGeiavCq8i0KH3GozetKLhGq7tOZTL7hjhpCAs12LqDA
	 PffqZ4Lu+/YlTTT5xubgxtKJHoho+hBzDyuVgcFut/46wpt/XRsszdwQGGS3Hwy/ki
	 fDxGDFxnhYhsi4PpU3Lap6LF60E1QWFO1aE9wn+/lUwI50kAxEf4AmLgb8sNHpWdFd
	 R9s9FsQjZdy8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 83/88] scsi: qla2xxx: Use coherent DMA buffer for
 D_Port diagnostics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-84-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-84-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:34:07 +0000
Message-Id: <20260707073407.B7F271F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch misses identical DMA API violations in `qla26xx_dport_di=
agnostics_v2`
- [High] DMA Use-After-Free on mailbox command timeout
--

--- Patch [83]: [PATCH v3 83/88] scsi: qla2xxx: Use coherent DMA buffer for=
 D_Port diagnostics ---
commit 49a3a18e5cf5c905cd3b276b6e0bdaad40f07c7f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics

qla26xx_dport_diagnostics() streaming-maps the caller's result buffer with
dma_map_single(). The bsg path passes &dd->buf from the __packed struct
qla_dport_diag, where buf lands at a 2-byte offset and shares cachelines
with the surrounding options/unused fields. Mapping such a misaligned
sub-buffer violates the DMA API requirement that streaming buffers be
cacheline aligned and not share a cacheline with other data, and can
corrupt data on non-DMA-coherent architectures.

Allocate a dedicated DMA-coherent buffer inside qla26xx_dport_diagnostics()
for the mailbox command and copy the result back into the caller's buffer.
This removes the streaming map of the misaligned sub-buffer entirely; the
caller's buffer is now only a plain CPU buffer, so its packing no longer
matters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 39544deab576a..59ec5605930b7 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> @@ -6617,8 +6615,9 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
>  		    "Done %s.\n", __func__);
>  	}
> =20
> -	dma_unmap_single(&vha->hw->pdev->dev, dd_dma,
> -	    size, DMA_FROM_DEVICE);
> +	memcpy(dd_buf, dd, size);
> +
> +	dma_free_coherent(&vha->hw->pdev->dev, size, dd, dd_dma);

[Severity: High]
This is a pre-existing issue, but does this unconditional free create a DMA=
=20
use-after-free when the mailbox command times out?

If qla2x00_mailbox_command() returns QLA_FUNCTION_TIMEOUT, an ISP abort is
scheduled asynchronously and the function returns immediately. Freeing the
coherent DMA buffer here releases the physical memory while the hardware
may still be actively running and writing to it, which could corrupt memory.

> =20
>  	return rval;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the adjacent function
qla26xx_dport_diagnostics_v2() suffer from the exact same DMA API violations
that this patch fixes?

Looking at qla26xx_dport_diagnostics_v2() in the same file:

drivers/scsi/qla2xxx/qla_mbx.c:qla26xx_dport_diagnostics_v2() {
    ...
	dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
				dd->buf, size, DMA_FROM_DEVICE);
    ...
	memset(dd->buf, 0, size);
    ...
}

It continues to stream-map the misaligned sub-buffer and improperly modifies
the buffer from the CPU side via memset() while it is mapped, which could
similarly corrupt memory on non-DMA-coherent architectures.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D83
