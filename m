Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E08537418C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261562; cv=none; b=WH65Mjvcmm15qepFkKTz+YY9JVm3RC+XXgqtkRJtiaumq9VySK8fgDPasRq0yjTSKeaLoGtb2luvEROQHuM0CTWyNZrFLXAaGEafi638tnj8ewqFlLfusJ4I4DSsoLPZkLkoPoz5X3/OmqyJx3iVHK8YbbKOjeO5VyJxTItAHus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261562; c=relaxed/simple;
	bh=xRVA4agDRbmQv17mQLaJ5+F7vranAivlG+LVt124TK4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VPZp1J5SXe+s/K29pcmScxQRJukvpqYhQREOQFWRqegqYf6soPY2+59DOHGnwaRwN1NkEpURhieS05lxP0l9lgkeuXxeaNz9i3AcyBgQrwWDv5XPbKB31J0gxQbWUfqv0Jdw0f0BQcIZAJUvR7sD94eZH1m2LAICoF0CVgf4Jv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=he32AG8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="he32AG8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1FC1F000E9;
	Fri, 12 Jun 2026 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781261560;
	bh=z2Oe+UHMG3E8fvWMbGvHolEDZQlFgCEgATTlYBpFrVk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=he32AG8lahXjUxfJ6IekCdQ5d/U0wPD6cAOZ2k0ID2IDL2lHg+ixc+S0q4elQAYoX
	 Wo2s2n9XiOvVIywqbPL5hDZ5LuAR2prSyp5NBSy7cvWNaqujjFUGz+BgZdEcTBzuP2
	 1tYfmnAYbBlfL9+QPEsCGtB0OS4nkao3ACLbGSE3DVC3awtCay2gVMac2aPGuGsLMH
	 2ewvGkQccAmqURWNbAJ1fFCESzPhdzvB+h4y5a1A2XUwMp4PKfJXnhhAW+cjroqGVp
	 u27+6xpFX0HkniS4Cm4IGWDMF6mF5QhZZjIMYQmm/tth2kc40M1MVDE5hk/z3GMeQZ
	 2RkfAnB+Bh+Ug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC] scsi: core: Drop dev->dma_mask check in evaluating
 max_sectors
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612103819.568200-1-john.g.garry@oracle.com>
References: <20260612103819.568200-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:52:40 +0000
Message-Id: <20260612105240.9C1FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Unconditional evaluation of `dma_max_mapping_size()` causes a =
NULL pointer dereference for SCSI hosts without a DMA mask.
- [High] Removing the `dma_mask` check truncates `shost->max_sectors` to 0 =
when `CONFIG_HAS_DMA` is disabled.
--

commit 465a19a9abf6d802d300cbfcf6fda41b10b0b1a3
Author: John Garry <john.g.garry@oracle.com>

scsi: core: Drop dev->dma_mask check in evaluating max_sectors

This commit removes the dma_dev->dma_mask check before evaluating
shost->max_sectors. The intention is that dma_max_mapping_size() no longer
requires dma_mask to be handled before being called.

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e047747d4ecf8..d22526d8a77e0 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
[ ... ]
> @@ -252,10 +252,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, =
struct device *dev,
> =20
>  	shost->dma_dev =3D dma_dev;
> =20
> -	if (dma_dev->dma_mask) {
> -		shost->max_sectors =3D min_t(unsigned int, shost->max_sectors,
> -				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
> -	}
> +	shost->max_sectors =3D min_t(unsigned int, shost->max_sectors,
> +			dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);

[Severity: Critical]
Does this unconditionally dereference a NULL pointer for non-DMA hosts like
scsi_debug?

Looking at dma_max_mapping_size() when CONFIG_HAS_DMA is enabled, it calls
the dma_map_direct() inline helper, which unconditionally dereferences the
DMA mask pointer:

kernel/dma/mapping.c:dma_map_direct() {
    ...
    return dma_go_direct(dev, *dev->dma_mask, ops);
}

If a software or PIO-only host doesn't initialize a DMA mask, wouldn't
*dev->dma_mask cause a panic during driver load?

[Severity: High]
What happens to the queue limit when the kernel is built without
CONFIG_HAS_DMA?

The fallback stub for dma_max_mapping_size() unconditionally returns 0:

include/linux/dma-mapping.h:dma_max_mapping_size() {
    return 0;
}

Since the dma_mask guard was removed, won't this cause min_t() to evaluate
to 0, unconditionally truncating shost->max_sectors to 0 for these hosts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612103819.5682=
00-1-john.g.garry@oracle.com?part=3D1
