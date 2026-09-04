Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29846358378;
	Fri,  4 Sep 2026 02:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487228; cv=none; b=ZnsG36uXBUMkPyFNxmD3QIrdfzzYagco9XEEiOdMAFCi+kTIGfwiwQB/2zS58dI4DHJyax+J+PrgrOfEV1kjNS/bYouWbaq4NvCiJpUpWcPYhrdZ5lQhYLhPC71S5pZKLA8NZQgOLbEh3ZHLPzZFWDgRSyYOhUGdqtfpV7zPhFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487228; c=relaxed/simple;
	bh=ttYUw+YKdAU/kXdI/A1KeDk8XP0w97KLdexzRpAgSeA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Uu7AuP3jMaiwuDLRmL0uBU7M/9LmDzDtm9tfEKfzD/oD4luoKA1CHIzNdI/+OyRtdx3ouWnlI4OTnanXqjjx8ETod8jywt4jrKb3DTduS0FBWcHzhn63KBbvmOc7Yxizes71icrmZHk8/YNAds9F6MJys2u/fsIPvJ1rwjjepDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1hsl2bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1hsl2bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2013E1F00A3D;
	Fri,  4 Sep 2026 02:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487226;
	bh=H0o8pzSSB4DEIbeeWivZjRCSzSNUNHxiiii0C2NhKcA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K1hsl2bipvc3JsSlhgo8g13J4ZTewefYxPMVRGb9/4BPYwbZTTSxSxyx+z4zQ/83n
	 RiIcezp2xTNsi13WnFCa/n3oIxTPkkOSoEHYZaC0UO9S2XLF8C+Rx0uJIQ5lPaiOJB
	 /N6jR3slqjBnEltUHZ64XZkoJ57T+eZXYvKojlFeso4q3qBdf18TTD5Sq+d+cdIt7f
	 xgC4qqvpmdO7CsoAliYZghzEXGEmXdirS2PEJWr3wsjxdeKXjjdVn1YfRh5sqFoa5E
	 ZlrYymwSPiXhMkjcfbltefzMnJyK7bcRYg8n6cPKiNRVN/HlPUAeCHRaCpeU8I7nV+
	 Z1QnFV3CwKA2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/40] scsi: lpfc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260904002644.157668-27-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:00:25 +0000
Message-Id: <20260904020026.2013E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] `lpfc_calc_bg_err` incorrectly mixes physical and DMA scatterlist =
concepts by using `sg_virt()` with `sg_dma_len()`, leading to out-of-bounds=
 memory access if the IOMMU coalesces segments.
--

commit 2a7f5cef754d14cd9ca36fe2a3d4393a003f4af6
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: lpfc: use 16-bits defined sense codes

Refactor the lpfc driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h.

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 8a795c65e3c3e..849d4de91b381 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -2848,7 +2848,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc=
_io_buf *lpfc_cmd)
>  	}
>  out:
>  	if (err_type =3D=3D BGS_GUARD_ERR_MASK) {
> -		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
> +		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
> +			       LOGICAL_BLOCK_GUARD_CHECK_FAILED);

[Severity: High]
This is a pre-existing issue, but while reviewing the changes in
lpfc_calc_bg_err(), I noticed that it might incorrectly mix physical and DMA
scatterlist concepts when a BlockGuard error occurs and lpfc_parse_bg_err()
falls back to this function.

If the system IOMMU coalesced multiple physical scatterlist segments into a
single DMA segment, can sg_dma_len() exceed the physical length?

The code earlier in lpfc_calc_bg_err() appears to use sg_dma_len() to itera=
te
over a CPU virtual address mapping:

drivers/scsi/lpfc/lpfc_scsi.c:lpfc_calc_bg_err() {
    ...
    data_src =3D (uint8_t *)sg_virt(sgde);
    data_len =3D sg_dma_len(sgde);
    ...
    src =3D (struct scsi_dif_tuple *)sg_virt(sgpe);
    start_ref_tag =3D scsi_prot_ref_tag(cmd);
    start_app_tag =3D src->app_tag;
    len =3D sg_dma_len(sgpe);
    ...
}

Does advancing a virtual pointer obtained from sg_virt() by sg_dma_len() re=
ad
past the end of the physically contiguous page into unrelated memory,
potentially causing an out-of-bounds memory read?

This could be triggered by storage hardware errors or corrupted IO on syste=
ms
with IOMMU enabled, leading to incorrect diagnostic checksums, false error
reports, or a kernel panic if it crosses into unmapped memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D26
