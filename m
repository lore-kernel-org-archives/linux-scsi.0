Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE6242D88;
	Fri,  4 Sep 2026 02:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487939; cv=none; b=g+1V6z5dxLo7au0XnYgDrEEzWS8vqFR2oUygZQtHi5HZThZYMd4HfNe6sMMQjaMIYs5MtXGjpbqDr/wU9/arWWhcN4WaM/BppNMPf2dJmCMl3Pf15NQ2BDjzP9JsuC8v/h3ob+fze8uRqXTolzUDifjXtoU5L1b0FoiAT/kOk+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487939; c=relaxed/simple;
	bh=5YIrh7A4BM8rg91MnwdfHy7I3ewnsfXy9XVbMNCjFrs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DTkTdBZ+z+uXlN1Y8fafwoivlIuiDU3Eu6zhxWgermiuvdTLVyZQXt7JBhSWB+fgCNrklpPdvD6klwW3/JzyuARDsum4+nPhkmsKmLGrdteOvMBWN/+9P2aFbROzH+mKkdEpHbwcR2LQBowBzkgAVP8cW59KVJPpubft7wNQHRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZgSONJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZgSONJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2501F000E9;
	Fri,  4 Sep 2026 02:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487938;
	bh=eRVY+wz42f3W4zGEJfJdtkKNlwOKRzeINu7BTVNvT4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gZgSONJFCOxVU/MW+RPQf7Pb1qvAVNROgr6PhCsiq6q3IDNsG5kjdNbGRyXXDgdZD
	 ucnzzBgWtvozYCNTgu/DWQNdG1Lsq9pNBX7iN32gPVyvhgIVPpYwDpJD2M0kCJ+b+M
	 Ba6eZcjJ+0dg2Ur3f9Plmq6oJMB2NV4hvIN0Am4j5pRdlNwXWiKvi8A7GVG4oCpvKi
	 3lgdBO0sYEEhhn82PksaG9xuaIJGqUj5VpPpWnTXF1vRR6HnkwBvCi62WLzJdjy8Hf
	 3i9kTqu0PWn5WJ+dGUJZNf0t00vJBfQErrZow9JcGYOPKMsyNpmeDr5KrLrGL5fvdG
	 EwmEU7reP1ogA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 28/40] scsi: mvumi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260904002644.157668-29-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:12:17 +0000
Message-Id: <20260904021217.7D2501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] DMA Mapping Failure Mishandling in `mvumi_make_sgl`
--

commit 8f7e0d6528db79abbbc2754c90191d5fcfa6d746
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mvumi: use 16-bits defined sense codes
   =20
Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

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

[Severity: High]
This isn't a bug introduced by this patch, but does mvumi_make_sgl() proper=
ly
handle DMA mapping failures?

Under memory pressure or IOMMU resource exhaustion, dma_map_sg() can fail a=
nd
return 0. However, in mvumi_make_sgl():

	*sg_count =3D dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
			       scmd->sc_data_direction);
	if (*sg_count > mhba->max_sge) {
        ...

If dma_map_sg() returns 0, the check (*sg_count > mhba->max_sge) evaluates =
to
false. The scsi_for_each_sg loop is skipped, and mvumi_make_sgl() incorrect=
ly
returns 0 (success).

The caller mvumi_build_frame() receives this success status and proceeds to
submit the command with a non-zero data_transfer_length but an sg_counts of=
 0,
along with uninitialized scatter-gather elements in the hardware frame payl=
oad.

Could this malformed frame cause the hardware controller to crash or perform
wild DMA accesses?

>  	return -1;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D28
