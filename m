Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4202F1FDF
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 09:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782724260; cv=none; b=Tt3KlF2XuoIg8QsHLiUMvEKPgdLw3GeVTqPdExzLRHY3BVIfdze8q1tbyO2BrX0exmtbBXqaroMQ7GCMfy2hNhuq95GyY3hmZAMCvg+5PBnSJVu+72fLMJrb9kA7hzpVdkdF5+hZ/O12vC1lFAU3LG76jOtXrGxaSbeY6VefY5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782724260; c=relaxed/simple;
	bh=G1stVcbmGMT3nlvloEH1Wj2zY9Y9YVll980qSioKNMw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HX/20Oy+RoYW6x4zqo1MuVHbEarHef6oVPUMUGQ9QWy7OXLcQBMEk8PBMZYlrFdMt06eX45Bv0HUgJUhIK7Byaa6zOxwETPT2wvp5Zzzrm8+IuvZy/GFyhiiIngjxjVtl9M0+kniC7Lcmo1Nz/1J+5yr1BW1oFQuzU/6JCMk6Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIMCNqIA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIMCNqIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA171F000E9;
	Mon, 29 Jun 2026 09:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782724259;
	bh=qopkMxVxOiLnPbATi3+xnC06ePf9hKfczuccEaKSqGg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JIMCNqIAATBro6zKxKqVkeOUFfpkv+/4irUxHN+/xKaiul2oi8z3g8Yv8jnCC9UKF
	 hYXqn+fHFFIeS6XjNuTjdNUVjXX5O8PSz87Pg+WOc/mioi6ICO1cB/s4p05x8fpewZ
	 PeFGpybbBs755JqEXeffNnRSPrVrj5I/cYsNipwYKMIgQGObWE0DwrBphL2JWZEuuf
	 jmknFvWrxoFfjzmmxVDL+8AWaHPU9xAWNp4UDtWjfTrQAeAP1cc8snnmCSr640/Qmp
	 dOqYv7IMrUSk+jtP9vd4ImmsEYOlG+Q4ngcbMwPpWVC+hgUShmhM6XTJZ2u5+oWvL7
	 NB8nClOFhpP4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0
 for no DMA capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260629085310.2298552-2-john.g.garry@oracle.com>
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
 <20260629085310.2298552-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 09:10:57 +0000
Message-Id: <20260629091058.EBA171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dma_max_mapping_size() returning 0 causes division by zero in amdx=
dna_cbuf_map() and invalid zero-sized block layer limits in MMC drivers.
--

commit b19cb5dc0c3fd9b25263f65c9d042ee616692807
Author: John Garry <john.g.garry@oracle.com>

dma-mapping: make dma_max_mapping_size() return 0 for no DMA capability

This commit updates dma_max_mapping_size() to return 0 when a device
is not DMA capable, reflecting that the maximum mapping size for such
devices is 0.

> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 4fe04669e5e66..7e576e5c6b8be 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -979,6 +979,9 @@ size_t dma_max_mapping_size(struct device *dev)
>  	const struct dma_map_ops *ops =3D get_dma_ops(dev);
>  	size_t size =3D SIZE_MAX;
> =20
> +	if (!dev->dma_mask)
> +		return 0;

[Severity: High]
Could this new return value of 0 cause a division by zero in callers that
expect a strictly positive maximum mapping size?

For instance, in drivers/accel/amdxdna/amdxdna_cbuf.c:amdxdna_cbuf_map(),
the returned size is used directly as a divisor:

        max_seg =3D min_t(size_t, UINT_MAX, dma_max_mapping_size(dev));
        n_entries =3D (cbuf->node.size + max_seg - 1) / max_seg;

If a device lacking a dma_mask maps the attachment, max_seg becomes 0,
which would result in an immediate kernel panic.

Additionally, could this cause invalid zero-sized block layer queue limits
in MMC drivers? In drivers/mmc/host/bcm2835.c:bcm2835_add_host(), the
return value clamps max_req_size:

        mmc->max_req_size =3D min_t(size_t, 524288, dma_max_mapping_size(de=
v));

If the device lacks DMA support, max_req_size becomes 0, which propagates
to the block layer and can trigger panics when processing requests.

> +
>  	if (dma_map_direct(dev, ops))
>  		size =3D dma_direct_max_mapping_size(dev);
>  	else if (use_dma_iommu(dev))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629085310.2298=
552-1-john.g.garry@oracle.com?part=3D1
