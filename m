Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CBC4A0149;
	Tue,  8 Sep 2026 10:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862500; cv=none; b=svD93urcjI/RJpIdEMB9TUn2C358OSoyIv2uG9lZPlZJFK670G0FKftBgaf1pVBK8NWPMBvADkRTgOAx7ysn/oiTzR77bmSHcnxPGyRyihMODKR91KFCfcrtZrIz77KX5PdkTE+xsUo9xOQ6SCUlN99RNdeO563FrSIZx3tYZvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862500; c=relaxed/simple;
	bh=nm+KhdVC3Xo6iMxyXG7RDiQxFAAG+q8OKVQewANL1bY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=toqustZP3TIg7JxEzPBz5qLqwg1/+cqbqpDgqrFzbj/waOOakxglpFp8nkTxccp22KG3Ii7pCQ6xSZh8ZdLjKmeyg+BiFd3SpYAn+aE4DzY011utTinAM/iaqEI8YVuGsqHDwx4hZC3bnahPzwaOYMIkPWzsEMFnLWBLW04GbIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5N+zbY8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5N+zbY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A563F1F00A3A;
	Tue,  8 Sep 2026 10:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862498;
	bh=B/2g5594zGRuAcEN6ku7LbBbXHwxJXtzOnG/tsXT0mg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y5N+zbY8Zk/LdfrfwhUSKKvRic2RFCcaA5t3Bphx9n6TjVzPFTvFoBr7Prd1XFpJI
	 NQ8DEjBhCHFNDBcA/TxFEJYhEUxpJX1TGdQq+41K0IMA0SHjIjU4S2y2MAkjHEQ2dV
	 S6cn0M0LHPzRXNDVxYzwctb2LG3D14Ch9ygtjU8WfWWbDl2gtcrVkfsLW2hGkwa+um
	 mqWcmQYSAu1QFFDLAOGFMJgZnCQ0TgPhNkjWzUIKe4bx2Y9qp6YUgRfcfDHgX22G7z
	 yd+iWYdQSmjwoPC4cB+sRliAIJh+utuYyFcKfcjmZ8oUq3XptLWWBcn+2radUBVoix
	 spULrfUJXlVxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 27/40] scsi: stex: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-28-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:14:57 +0000
Message-Id: <20260908101457.A563F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Kernel panic upon DMA mapping failure due to BUG_ON(nseg < 0).
--

commit d15faa7735c6e8a30c881eeb0c04ddfab88366ab
Author: Damien Le Moal <dlemoal@kernel.org>
scsi: stex: use 16-bits defined sense codes

This commit refactors the stex driver to use scsi_set_sense() and replaces
hard-coded additional sense codes with enum values. This improves code clar=
ity
and ensures the sense codes are self-documented.

> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 6aeeb338633df..056ff0eb5455c 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
[ ... ]

[Severity: High]
This is a pre-existing issue, but I noticed a potential problem in the DMA
mapping error handling while reviewing this file.

In drivers/scsi/stex.c:stex_map_sg():

	nseg =3D scsi_dma_map(cmd);
	BUG_ON(nseg < 0);

And similarly in drivers/scsi/stex.c:stex_ss_map_sg():

	nseg =3D scsi_dma_map(cmd);
	BUG_ON(nseg < 0);

Can this crash the kernel under memory pressure?=20

If scsi_dma_map() fails (for example, if the SWIOTLB is full or IOMMU space
is exhausted), it returns -ENOMEM. The driver then immediately triggers the
BUG_ON(nseg < 0) statement, crashing the system instead of gracefully handl=
ing
the error. Since this is reachable via normal I/O paths, could unprivileged
userspace trigger memory pressure to induce this failure and cause a local
denial of service?

Would it make sense to update these functions to handle the failure and
return SCSI_MLQUEUE_HOST_BUSY, allowing the SCSI midlayer to retry?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D27
