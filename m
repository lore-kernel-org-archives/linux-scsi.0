Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0678137F31C;
	Mon, 31 Aug 2026 02:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143079; cv=none; b=oM0hiwzz93cca2sQ1YkDSnusglKVypEBORxIZUiC3fP42OTWhr02W+kQFHIN/xml3ewHPgqoedd0O8+Tu8Y47GWQx1mozpvNkpqH7MJXnI9q/E04aZyMZp5SrKAzEHYAcYSmcvpOgynpITzWTpBfe2m38IxdkpM4eJN6EFTCXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143079; c=relaxed/simple;
	bh=DNI2+Xeo45W9qB+xoNYY1UXU2B/0LBsRXSMvG/Yo5UU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fJVNGa2T2xntUHjNSZycS44YTZ5bNZ80WIIUIac2T8P4+HJARIYThNsBcvgqcxpu1WlzmhwtAu15gO8YpgMX6L1oFa2VGFk7i30EzQpihJLw+yGg14V2orE8Tozv32Urw1ICLfEu5lI9O7EirU39NQAYtKf/9ZqP003WxryPl9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=naVZMHup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naVZMHup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A991F000E9;
	Mon, 31 Aug 2026 02:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143064;
	bh=ZH9N1/TRlvtLSBOTaA70nE9gJ062Cuqp1e2IEyy6nCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=naVZMHupt+vHiNpS+Ju1lDPptLnZVKkbt9a3LyCQkSbEeqfIVTA2Kc2pOSVang2K8
	 O6kwT4hJ/Umrq+PnvLxliQ1o6eFxPRi2I07UbgKHpFAvkKqX6kDnL6ujUg5ACvMx7y
	 IhX6uwj1aX79ZRT9J5uTWZdRpM5X5cq0oa3XJ45+OFirtPmC1OhF1zhC83NR5AX8Fj
	 BdvtOwjW4uO2sWKU2HQx59iENgTMRk8KVdeB6s0jsVhGBrFNkkI5o1dc1fnsdq2iwF
	 gzNr8olCVoYC88fBQNigvStxsE/MHHoIxLymAVpK+COZyg9ijtBHgGlGYCHA1bfGIB
	 SnJBcohKCIIWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 28/37] scsi: mvumi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260831020451.585944-29-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:24:23 +0000
Message-Id: <20260831022423.C9A991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unhandled dma_map_sg failure in mvumi_make_sgl
--

commit 741665dea239f5c02068d60c93684dd2fc4d00e6
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mvumi: use 16-bits defined sense codes

This refactors the Marvell UMI driver to use scsi_set_sense() and replaces
all hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h to improve code
clarity.

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
This isn't a bug introduced by this patch, but there is a pre-existing issue
in the error handling path leading here.

In mvumi_make_sgl(), which is called just before the error label, if
dma_map_sg() fails it returns 0. However, mvumi_make_sgl() incorrectly
checks for failure by checking if the returned count is greater than max_sg=
e:

drivers/scsi/mvumi.c:mvumi_make_sgl() {
...
	*sg_count =3D dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
			       scmd->sc_data_direction);
	if (*sg_count > mhba->max_sge) {
...
}

Since 0 is not greater than max_sge, the check is bypassed. mvumi_make_sgl()
then skips the scatterlist loop and incorrectly returns 0 (success).

mvumi_build_frame() proceeds to pass the command to the firmware with a
non-zero data_transfer_length (from scsi_bufflen) but 0 scatter-gather
entries.

Could this crash or wedge the Marvell UMI firmware by sending a malformed
command?

>  	return -1;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D28
