Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4AF2BDC1C;
	Mon,  7 Sep 2026 03:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750132; cv=none; b=FXn1eljnsIVrzEp91SyQFAQ+38gLUeucHWf3Ky9Pd0VMbjR38E1Xgmq1W2IP/GqnjNxD3h7aOsW7LDCjVZ8jqXcKcmmxBKd3/yWHheB9TU1f2Rbf8JeBu4bI7SBvN5Avq2ePNP5mUuq7HP7hCsThJBIIqHP/hKuIx3U9cWYXslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750132; c=relaxed/simple;
	bh=zo0qUnRvOgL8VK0IdwC7bzKQR96+j13VhI4/1Rju9Fs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X37YjZrGsiccV0va2AMQYLJTPT54dlwzP9PnlM9cN87cNkyxC6L1zIxkMDxTJFRwBQbv/qJV68BgA9RMW9oh0WScFtwP8AoiuVqVGTg2vXMCgh7OKRKGah1WfAZZtwW1f5iflN+nMFLj9lMOjeNCHE6c7MW/sBTx9YeqEAWdUFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUKffXVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUKffXVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE211F00A3A;
	Mon,  7 Sep 2026 03:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750130;
	bh=rtuiQoUKy0ovGeFpAadT89WFkRjq4ekQA3GMCrRbBqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AUKffXViUTDfZeArsdHQpKY59gY1Icdb9B5ARkE0mRnErpxKfJCL5vVGVBhDBKSHG
	 vbluYgtjhrBdnON8tSQRvCGnJgAlH9cTyAQnYBI4pSuwuTRsuToksy/DRIyjjVh7Fu
	 Ebk7RUTXoXfDTgL8mtIci9kJaGS6PHMvD+usNfj5aod+DncBESxi4+0i4aY20qQdQ1
	 QqJIwiJcx7qiGsKkgQzauYJy9A4ceSgM+298X5jLOvVx2XsBIDJSfZrIKwLIQTWNVf
	 LUaqTJLU2FMuLf4qH1yt8zb9i9xDEExdNfjIM1noLJCR28pRJAd65PIoMM67k6tGH8
	 Qh1tuqPz1vtlg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 26/40] scsi: lpfc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-ide@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-27-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:02:09 +0000
Message-Id: <20260907030210.5CE211F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] lpfc_calc_bg_err uses sg_virt() on scatterlists that may contain h=
ighmem pages, leading to a potential null pointer dereference.
--

commit cab66a9ba1b6f5f7b39fa990a3c85615dae967c4
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: lpfc: use 16-bits defined sense codes

This refactors the lpfc driver to use scsi_set_sense() with defined enum
values from scsi_sense.h instead of hard-coded sense codes. No functional
changes are intended.

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 50616b05488a8..8dd876a1a78d3 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -2848,7 +2848,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc=
_io_buf *lpfc_cmd)

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing these error
handling paths, I noticed a pre-existing issue in lpfc_calc_bg_err().

Earlier in lpfc_calc_bg_err(), the code attempts to get direct virtual
addresses for the scatterlists:

drivers/scsi/lpfc/lpfc_scsi.c:lpfc_calc_bg_err() {
	...
	data_src =3D (uint8_t *)sg_virt(sgde);
	...
	src =3D (struct scsi_dif_tuple *)sg_virt(sgpe);
	...
}

If the block layer or SCSI subsystem submits a request with data or
protection scatterlists backed by highmem pages (for example, via
pass-through mechanisms like SG_IO), sg_virt() will return an invalid
pointer because page_address() returns NULL for highmem pages.

When a hardware data integrity error occurs, lpfc_parse_bg_err() calls
lpfc_calc_bg_err() to manually inspect the error. Could dereferencing these
pointers during CRC calculation or when reading the reference tag cause a
kernel panic?

>  	}
>  out:
>  	if (err_type =3D=3D BGS_GUARD_ERR_MASK) {
> -		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
> +		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
> +			       LOGICAL_BLOCK_GUARD_CHECK_FAILED);
>  		set_host_byte(cmd, DID_ABORT);
>  		phba->bg_guard_err_cnt++;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D26
