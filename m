Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEA717D2
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 09:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782379895; cv=none; b=j8V+k7+L9504J4FejWmbjqKFc2xbpMp2dDCTdB2yoWa6hjbV5wjG3DSm3LyPS9DSnkpmkEMIwSaxJ8m7K3PRFGs4PuPebJsucc5RQTswIQPbDmxRQPtRKWnm36KHe3qk8lkGNo8UyZ3GSs7o/l+W1zA4fojzigezfQPo94YA3Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782379895; c=relaxed/simple;
	bh=Wx3Zb90Hc6jqfxSAmosOVddD6iuLNy3pKYuG5fFlzpE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bpOVoZB3upVgbDEWMLJuFtFdnvHR2HjgtkN/WIYREQt6dErOeyXtpKeGj3F2ILpjljT8jP1viF7k8iJRDVjtyEAi7iC+xfA3Sz8UztVNsjVYYe642UocQx8b9bPZD46zsZfbEF4dKcmBXiebj1UC6aiQtGOLbmAH2OeDNoVdh1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvSJt5Kh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvSJt5Kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4B11F000E9;
	Thu, 25 Jun 2026 09:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782379892;
	bh=698wi2/pIHUEECcTh3MMknLSK0C/qTH88IeWvjgdHYQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cvSJt5Kh2AUGqZI7AZHuYh/g74lH4ztDR5eYIfZ7UtorVJaLW4Z7CUc3yy7PrEPuQ
	 NrZFa5OEzt7j9d7ZgzQ/EQtVnDmkzWxsqaSCumPdTjnZQtw/wGjOFaz2MYhDIBN+BR
	 vyZZLAYBT6cWqUXG4C3LHTSv149kvfo6Bup/sUjlRawJi3z42PyD0070192Ys3ozPd
	 252B9EqSx/FHVIfLkfakaaTsNLa98kf3g0rOVNeI2MutVEOit57DdR/OIEid+/wcji
	 vWVGf3p0Vo6Wt6lVFOhpwxKAtUCWTHA8q6Sb8eWGKzP2VanwSo7axqVWdaUorssBoT
	 5uC43/PgAgQGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid: clear ioctl DMA buffers before use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260625090101.4761-1-alhouseenyousef@gmail.com>
References: <20260625090101.4761-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 09:31:32 +0000
Message-Id: <20260625093132.7C4B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Sleeping in Atomic Context during DMA buffer allocation
- [High] DMA Buffer Overflow due to bypassed bounds check on read-only pass=
through commands
- [High] Invalid Free and potential NULL pointer dereference on allocation =
failure path
--

commit ddb879c51888ddd8509956e8e975f6048a188af1
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>

scsi: megaraid: clear ioctl DMA buffers before use

The MIMD ioctl path reuses DMA buffers from per-adapter pools, or
allocates a fresh pool buffer when the shared buffers are busy. Read
commands copy the requested user-visible length back after firmware
completion, but firmware is not guaranteed to overwrite every byte in the
bounce buffer.

Clear the attached DMA buffer before issuing the command so short device
writes cannot return stale data from a previous ioctl or allocation. This
covers both regular DCMDs and passthrough commands after their requested
lengths have been validated.

> diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/=
megaraid_mm.c
> index a70692779a16c..6e0db096215c7 100644
> --- a/drivers/scsi/megaraid/megaraid_mm.c
> +++ b/drivers/scsi/megaraid/megaraid_mm.c

[ ... ]

> @@ -577,6 +578,8 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc,=
 int xferlen)
>  	if (!kioc->buf_vaddr)
>  		return -ENOMEM;

[Severity: High]
This is a pre-existing issue, but does the allocation right before this che=
ck
sleep while holding a spinlock?

drivers/scsi/megaraid/megaraid_mm.c:mraid_mm_attach_buf() {
...
	spin_lock_irqsave(&pool->lock, flags);

	kioc->pool_index	=3D right_pool;
	kioc->free_buf		=3D 1;
	kioc->buf_vaddr 	=3D pci_pool_alloc(pool->handle, GFP_KERNEL,
							&kioc->buf_paddr);
	spin_unlock_irqrestore(&pool->lock, flags);

	if (!kioc->buf_vaddr)
		return -ENOMEM;
...
}

Calling pci_pool_alloc() with GFP_KERNEL can sleep, which could cause a
scheduling while atomic panic since pool->lock is held with interrupts
disabled.

[Severity: High]
This isn't a bug introduced by this patch, but can the failure path cause a
NULL pointer dereference?

If pci_pool_alloc() fails, it returns -ENOMEM with kioc->free_buf already s=
et
to 1. When the caller propagates the error and invokes
mraid_mm_dealloc_kioc():

drivers/scsi/megaraid/megaraid_mm.c:mraid_mm_dealloc_kioc() {
...
		if (kioc->free_buf =3D=3D 1)
			pci_pool_free(pool->handle, kioc->buf_vaddr,=20
							kioc->buf_paddr);
...
}

This would attempt to free the memory by calling pci_pool_free() with a NULL
virtual address.

> +	memset(kioc->buf_vaddr, 0, xferlen);
> +
>  	return 0;
>  }

[Severity: High]
This is a pre-existing issue, but could the bounds check in mimd_to_kioc()
leave device-to-memory transfers completely unvalidated?

drivers/scsi/megaraid/megaraid_mm.c:mimd_to_kioc() {
...
	pthru32->dataxferaddr	=3D kioc->buf_paddr;
	if (kioc->data_dir & UIOC_WR) {
		if (pthru32->dataxferlen > kioc->xferlen)
			return -EINVAL;
		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
						pthru32->dataxferlen)) {
			return (-EFAULT);
		}
	}
...
}

The bounds check for dataxferlen is nested inside
if (kioc->data_dir & UIOC_WR). If the command is a read-only transfer
(UIOC_WR is unset), this check is skipped. A user could issue an ioctl
with a small xferlen but a huge dataxferlen, instructing the firmware
to write past the allocated bounce buffer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625090101.4761=
-1-alhouseenyousef@gmail.com?part=3D1
