Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855BE4C77A0;
	Tue,  8 Sep 2026 10:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862328; cv=none; b=UVyG6nhPrYrnP7R9Cp/CHMkN2XMG+SmzuYp1XZYL02KcqscvxpvDYC28kdXDbchZ/Q8RPu1TojCNCM5j9YTWFT61r8MlPA3ulBW67lCRKmroh8nhkt/jYX7fWyuaBG0L5Mwwo5ztkSXMYRoUr932s1muBwOtLgcz+EAAIkpkXxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862328; c=relaxed/simple;
	bh=6j22/dJhROyPlg8ivB4htqJOqioSNhilD+x0JrcP0x4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F6IFphrY2x/uYKUJwLzQICVKgG0UXQGoKuV6gLCT1N05htP3DcGVjjlMTgIY9PYXgow+K0DiJoHFtqjbx1OFBPksrhFK38+fzISUsirJQk9sXzLwXf5CoyGK16By5RZRjz6RtZ2/B0PrGty8lDkJD0g3ZZN1/CUYSuKhLDPtai8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00B01F00A3D;
	Tue,  8 Sep 2026 10:12:05 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 28/40] scsi: mvumi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-29-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:12:05 +0000
Message-Id: <20260908101205.A00B01F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver fails to check for dma_map_sg() returning 0 in mvumi_ma=
ke_sgl(), leading to a zero-length scatter-gather list being submitted to t=
he hardware.
--

commit 08a9c22b18db2961d038b4a430b3ff95036d00ea
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mvumi: use 16-bits defined sense codes

This commit refactors the Marvell UMI driver to use scsi_set_sense() and
enum values from scsi_sense.h instead of hardcoded additional sense codes.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e70d336b4ab39..a5bd3258a3994 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -2067,7 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi=
_hba *mhba,
>  	return 0;
> =20
>  error:
> -	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
>  	return -1;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the error
handling in this area, I noticed a pre-existing issue if DMA mapping fails
earlier in the command setup.

When processing a SCSI command with data, mvumi_build_frame() calls
mvumi_make_sgl(). Inside mvumi_make_sgl(), dma_map_sg() is called:

drivers/scsi/mvumi.c:mvumi_make_sgl() {
    ...
    *sg_count =3D dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
                           scmd->sc_data_direction);
    if (*sg_count > mhba->max_sge) {
    ...
}

If memory is fragmented or IOMMU space is exhausted, dma_map_sg() returns 0.

Because *sg_count is 0, the check *sg_count > mhba->max_sge evaluates to
false, and the mapping loop is bypassed. The function returns 0 (success)
instead of jumping to an error path.

Back in mvumi_build_frame(), the driver proceeds to set the transfer length:

drivers/scsi/mvumi.c:mvumi_build_frame() {
    ...
    if (scsi_bufflen(scmd)) {
        if (mvumi_make_sgl(mhba, scmd, &pframe->payload[0],
                           &pframe->sg_counts))
            goto error;

        pframe->data_transfer_length =3D scsi_bufflen(scmd);
    ...
}

Does this instruct the hardware to transfer data with sg_counts =3D 0 but a
non-zero data_transfer_length?

Could this cause a hardware DMA fault or lead to memory corruption and a
subsequent controller reset?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D28
