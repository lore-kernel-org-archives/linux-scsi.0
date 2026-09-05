Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF7134A796;
	Sat,  5 Sep 2026 03:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579933; cv=none; b=Gmn+hzUrAniZBkYC7zOZ2HoCj2G88JfwbgKgDwtSakfNYsATaXyuGjUKKO8hwqiCDJlRBwkJjKAAu8xwwc11OiNIEWXKU+9uXtXYcCMAYS3hWhW5Md9omVLxRZ+IAh/gHkXErQyy0aNlY5t466vRef99+5EL/+xeMy8KTaoCBFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579933; c=relaxed/simple;
	bh=Njozu1Izk5z2PCd2N3Cze75iCCzOBSBZumDcNPScsdw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hFeUNbb4AaB2gywJimewr5dYm3DHpLWnxvyHfw9wfkg41hRs3WiYyyhR0sAQ70PyJGA2EgoNCnRTnmjuTMLSaVJcu7hedlmdcd06vCXBJRug61Jx8AujxUkwYAd33WP/290cA7CsJPHiZ083nG3AztNrO45qFC/dQxtJxK8CWeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAHObsMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAHObsMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A8B1F00A3D;
	Sat,  5 Sep 2026 03:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579931;
	bh=uesbkkce/qOdQeNI3FDOOAr1dNTwOdPQFSTh/ZDa46E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RAHObsMSiVfBKx5Ug2Ey9rCyFOgSXhQHx6mpZ5qFSFi5lZrOXST6D8wzEtRrKe1Yz
	 1UMLHDaYM2BsWBK7WiMULUP0TWzQbZ0IPewGw+hfVUCrJf4EUduUsvnpiQ8l82o6c/
	 DetwrjyInKFIZfTu+/XgJUga2z7+1y+dmCZ8Q3h5AJZp3h0ZLfuOXuNdrpZ7hgm1QB
	 WEQY7shytsr8FQvoJdAE5dbtk9EkCloDUL1A41JWxgOoY4YBMNEvZb1YC8pGjC6Mhb
	 4AxSJN1Uu8p8CKmBp3petQAIqVzQ6pcFLjIUWJqGgC6tbQi7RHqU0v0qta1epgHLyC
	 vYKxroWy486rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 28/40] scsi: mvumi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260905032224.509860-29-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:45:30 +0000
Message-Id: <20260905034531.03A8B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but failure of `dma_=
map_sg()` in `mvumi_make_sgl()` is treated as success, leading to submittin=
g malformed commands to the firmware.
--

commit dfc070daf5ae8e3c8f3342502ead3c537cba8d81
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mvumi: use 16-bits defined sense codes

Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e9e2c25cde682..91c2db697c691 100644
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
This is a pre-existing issue, but does mvumi_make_sgl() treat a
dma_map_sg() failure as a success, leading to submitting malformed
commands to the firmware?

When dma_map_sg() fails (e.g., under memory pressure or IOMMU
exhaustion), it returns 0. The function mvumi_make_sgl() at
drivers/scsi/mvumi.c:198 assigns this to *sg_count and checks if it
is greater than mhba->max_sge:

drivers/scsi/mvumi.c:mvumi_make_sgl() {
    ...
	*sg_count =3D dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
			       scmd->sc_data_direction);
	if (*sg_count > mhba->max_sge) {
    ...
}

Since 0 is not greater than max_sge, the code ignores the error and
returns 0 (success).=20

This causes mvumi_build_frame() to submit the command to the firmware
with a non-zero data transfer length but sg_counts =3D=3D 0.

Could sending these malformed commands to the controller crash the
firmware (DoS), trigger IOMMU faults, or cause data corruption if the
firmware attempts to parse an uninitialized payload as an SG list?

Can this be triggered during heavy I/O loads or when IOMMU mappings are
exhausted locally through the following path?

mvumi_queue_command() -> mvumi_build_frame() -> mvumi_make_sgl()

>  	return -1;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D28
