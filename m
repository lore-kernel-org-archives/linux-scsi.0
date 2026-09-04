Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F0372662;
	Fri,  4 Sep 2026 02:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487239; cv=none; b=u1z14lSVWTafwBIMPNKL0pu0x+kBhYDummKkRXmgXKyoNcOdvewLiPK6G50AHoQSLWcDhN/uG61wNSE3HSTqlHcHotYWAjDZeL/X8GKpc3zPdPG4FvMIdrDJZHGN0LxWGId9xawkrpTzBcx8HBGKG03ZRlkRGplEll36QqF8T8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487239; c=relaxed/simple;
	bh=jjUmMRMUMPJY7SztcCQQLUfy2QIvLnfJFCW4hP8N+0c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uYZY+HLq2OaTHOcPuGOEsdjcttl+LwrYczjmaXx9Ml8uqs93Q1xvf50oSUxf7BjxfE5ArXdQ8473CvexQbY7Fii/Gpsi/FcIEGxHv/hwOxtt7y59wwdFGNdqWHbnftSh1rLUFR/oyJH2CbPr5bFHiASxIxfVOXr/5AMxFvJLF3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiCoZ2RU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiCoZ2RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336561F000E9;
	Fri,  4 Sep 2026 02:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487237;
	bh=VVr9F83C4beBb1RaI8dtBPqhZHNZNShp/7p83/XKaG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SiCoZ2RUe5v3iwbWYJqwJ/tzTD/kQXHBOXTPkTd2VY1Ay8/sWSxgkC5weyHuMzu9N
	 9IUoJ4p1QkCVOxkvqfRIm3Dz9TeijKROSL//+SHgsTgxLU4hdwMky4pedvZV8Z7w3u
	 n/h2QeVYZ8moi76/jVv6DRY6fHUOFC4EKTvROc2oCoMuC6tt0IyKeCJURZJi9cuQcI
	 kyAM9x7EtVVGHgSUpSfoDwanhTMV8bnv5/de9HOwRHy2ox/Yv0HeFojWDgKdsRhWJm
	 Jyae/henrDK1KYhJIiNsXFvMrVcM2H6Aa/BojU2EfMasZJDkM1+8Z8NwheKx+jf/Dc
	 EH50ODI6yDrNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 25/40] scsi: ps3rom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-26-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:00:36 +0000
Message-Id: <20260904020037.336561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but in `ps3rom_inter=
rupt`, the `cmd` pointer (retrieved from `priv->curr_cmd`) is dereferenced =
without a NULL check when processing mismatched tags or spurious async even=
ts.
--

commit 0fd451167d5347bf13c34e7718d8d4873fdfa19c
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ps3rom: use 16-bits defined sense codes

Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h.

> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index a9c727d229313..c63c581b493c3 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c

[ ... ]

> @@ -316,7 +317,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *da=
ta)
>  		goto done;
>  	}
> =20
> -	scsi_build_sense(cmd, 0, sense_key, asc, ascq);
> +	scsi_set_sense(cmd, 0, sense_key, scsi_sense_code(asc, ascq));
> =20
>  done:
>  	priv->curr_cmd =3D NULL;

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing
ps3rom_interrupt(), it looks like there might be a pre-existing NULL pointer
dereference issue when a tag mismatch occurs.

If the hypervisor returns an asynchronous status with an unmatched tag
(tag !=3D dev->tag) while the driver is idle, the code logs the mismatch:

	if (tag !=3D dev->tag)
		dev_err(&dev->sbd.core,
			"%s:%u: tag mismatch, got %llx, expected %llx\n",
			__func__, __LINE__, tag, dev->tag);

But there is no early return on this path. The code continues on, retrieves
the command pointer (which would be NULL if the driver is idle):

	cmd =3D priv->curr_cmd;

And then unconditionally dereferences it:

	if (!status) {
		/* OK, completed */
		if (cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {

Could this lead to a kernel panic if a spurious async event or mismatched t=
ag
is received while no command is active?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D25
