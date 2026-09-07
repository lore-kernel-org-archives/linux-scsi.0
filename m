Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C682215161;
	Mon,  7 Sep 2026 03:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750241; cv=none; b=i9HuoA4VEcWWnD3LFIp5uIW47uZCyUhcnvgQsorXJpCgcrweNdCFAASf8v3tkLnr8VM78jLqhw189Wff/sWw8HhJIbF+8zGexfOho2vnhy3ao0id/eJa2rOZtejJuT4S40Yx1i50DMdZRoeBtZyU2n5BDb4h0h0IQVdJ3yLupds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750241; c=relaxed/simple;
	bh=3kETtJa6z7bPAPslGa5D1du43JCV0WQ7CI3gB6C2JW4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DVrAAipHCOuevHBMP/nPw3uCGYIQ7F2xdHUqdZ/G7u9Kv+8dOIk4TyGYmc9FpsnLtvGqn+AhRnwfXDbPcwgf/qsoPn/igB8hYcPs4yucrn5/bnk4wdR44K5NmaGT8Zw92293Y2C4NtgPxq9O6e22cklr0tHFS2NRs/9+XGLC4JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWkKvwEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWkKvwEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B68A1F00A3A;
	Mon,  7 Sep 2026 03:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750240;
	bh=AUebvPVQ9Adu77nP04B8uvA9Ii1uUU21SMT/43mAjhw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gWkKvwEcdrEXqZL7HwAYtmp0nyVA9O0GL7iQxZNHuVxviNeyU8jX6Mkkb8A0UZMoO
	 HO5xN1GTjWf1zfABMMoixtsE3j7UmyHSoQ+1CK73aU55j6fxvLbis+u2QswX5wLWoB
	 a+NC/wEgBsr+toZ78DLcSy2HVtPvmZWjyHsXlAx+E9lJQ0dCdwK6j/vPRnGiP3RD2G
	 c6SZDXCkVX7LDrt/+U2ALrt5EpJygLcR7ShGc3b2O0FEfQP/XuIW4AAMeeJJrruq8q
	 zZPX/0oqqWaH+sXMoW73anQWkQQxruUonddvt5VKJL6DzbX939MCNwCzOva9ndhUzd
	 N11pMSn/VmlzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 28/40] scsi: mvumi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-29-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:03:59 +0000
Message-Id: <20260907030359.9B68A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing error check for dma_map_sg() failure leading to malformed =
hardware command.
--

commit 01d41c52d8869238d18b5758b906a883c2a803f9
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mvumi: use 16-bits defined sense codes

This commit refactors the Marvell UMI driver to use scsi_set_sense() and
replaces hard-coded additional sense codes with enum values from
include/scsi/scsi_sense.h.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e9e2c25cde682..91c2db697c691 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -2067,7 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi=
_hba *mhba,
>  	return 0;
> =20
>  error:

[Severity: High]
This is a pre-existing issue, but I noticed a potential problem in how
dma_map_sg() failures are handled when building frames.

If dma_map_sg() fails under memory pressure or IOMMU resource exhaustion,
it returns 0. In drivers/scsi/mvumi.c:mvumi_make_sgl():

    *sg_count =3D dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
                           scmd->sc_data_direction);
    if (*sg_count > mhba->max_sge) {
        ...

When dma_map_sg() returns 0, the check (*sg_count > mhba->max_sge) is
false, and mvumi_make_sgl() incorrectly returns 0 (success) without checking
for the mapping failure.

Because mvumi_build_frame() proceeds normally, it submits a command to the
storage controller with a data_transfer_length > 0 but an empty scatter
gather list (sg_counts =3D 0).

Could this malformed command cause the storage controller firmware to hang,
timeout, or reset, potentially degrading or disabling the storage array?

> -	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
>  	return -1;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D28
