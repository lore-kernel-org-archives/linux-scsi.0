Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACB81E1DF0;
	Thu,  3 Sep 2026 04:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408136; cv=none; b=EiZqZ9MNFY6ptjdK/qaAEdLSyjGugR2pb91S1SEgIlGRsTRG4ysRcxpKVBOsMnnbGmsVx9vB8IvZFYd1ujrc1P59+mGZZf09X5D9dDO/H2O/cv1h5kCRlXd7B0+0amWdZ+S/kC6MntI25egthcmWv42k9Q4SRHSuJT6aRn7iHlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408136; c=relaxed/simple;
	bh=YwRSoTQ3URb4Lf6kEtEU7IU1LPZ5oN+nm48279zVLVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M/B7dQhsVLvn4tVFACSURqkDQLMVPj23ZQ9GUYW1qbbJVCKtl7pg7LBfpESIFU40OzE0TpHN80SOod4XolypsaxJ3AeYIldFZl/jhOTI3MAmFsQA2kLaz5NtizbHbA667YOpdvqb2FEGNYSzYNp3xt8MCF4w/rp6cA+D8mW8wt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFLQABld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFLQABld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF91F000E9;
	Thu,  3 Sep 2026 04:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408134;
	bh=5GYzkARYHoT0VPvnYMswPA/jg4VLOl6zdZBAXzV8uUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WFLQABldNvesD5LxzTUnBrSx7gvPxk4QBmBkbnvxqKl160rngqJuT+PF8Mp2XmYN7
	 pzOzyGPeDxZmiqHxQHdF4QLeDRb4tZT4bR48qetoRDyVyvvqwXybuH3oLpfFZnpjSm
	 tWwYfaJ7BGFftxaDnrFv8ez/uuIVSbemc2lW0jEVE2BX8FtCtmSjPVLsZL8XPuNtdy
	 otoLaYkAT8gYHMFrbzCTS0mtiosAr6nYDj3mvqSj4QwNGwn+Bpey+1xAhpN3mHHBRP
	 yRimLPn6AdyIGvpF6c1kd8ij7TmVSbt1lUFhdC/U1fuerp6AmgxKA6rVoaCQbli5Mf
	 xOBsW5x6pQs0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 28/40] scsi: mvumi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-29-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:02:13 +0000
Message-Id: <20260903040214.49EF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Failure of dma_map_sg() is incorrectly treated as success, leading=
 to potential data corruption.
--

commit fe977aa03b75003e40bf53c83a27104877ab66a8
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mvumi: use 16-bits defined sense codes
   =20
Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.
   =20
No functional change intended.

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
This isn't a bug introduced by this patch, but looking at how we reach this
error block, does the driver mishandle a dma_map_sg() failure?

In mvumi_build_frame(), we call mvumi_make_sgl(). If dma_map_sg() fails
inside mvumi_make_sgl(), it returns 0:

drivers/scsi/mvumi.c:mvumi_make_sgl() {
    ...
	*sg_count =3D dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
			       scmd->sc_data_direction);
	if (*sg_count > mhba->max_sge) {
        ...
		return -1;
	}
    ...
    return 0;
}

Because 0 is not greater than mhba->max_sge, the error check is skipped,
and mvumi_make_sgl() returns 0 (success) instead of -1.=20

Back in mvumi_build_frame(), this bypasses the goto error:

drivers/scsi/mvumi.c:mvumi_build_frame() {
    ...
	if (scsi_bufflen(scmd)) {
		if (mvumi_make_sgl(mhba, scmd, &pframe->payload[0],
			&pframe->sg_counts))
			goto error;

		pframe->data_transfer_length =3D scsi_bufflen(scmd);
	}
    ...
}

Will this cause the hardware to reuse stale DMA addresses from a previous
command frame since data_transfer_length is set but sg_counts is 0?

>  	return -1;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D28
