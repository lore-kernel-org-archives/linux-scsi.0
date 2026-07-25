Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96E9377EC7;
	Sat, 25 Jul 2026 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784971111; cv=none; b=ABKsOXnq52/LHdErnyyKKFQeZ5tNzxpykyIG7S0wbcSWg+zk8+kuV6mflceieUv2HwVv1Y1Jhep+HhWj4IoBu9n2kyCb/JBJ0SwJG6aqKU/oCZduczuMuAxqn9SxgKztwXSGvPBOdgRo2l/b4u4MdrE2NnGZbDj6VRf8fbvqfhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784971111; c=relaxed/simple;
	bh=RTxYTtd2iXidLxcPEMQBMPqrg80ANTF5jeEnGP6zcSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lT0S7fsk2u26uNeSJ5jVOjzkip8cT86SdnKsMDp9Br217g7RpLESSMChO/iC3kZifD2KzeAUfCg2zs4+urGeKG+RXXsj2qxfP2DM+7+sFgr5b+UBUUv0A+cbSP1zz6hPBGmNzMRfrqKSbLZYE0Lzt8mm+acNASwlyqCAJntI/tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBoBT3pQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBoBT3pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F3D1F000E9;
	Sat, 25 Jul 2026 09:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784971108;
	bh=zXZsG0yYtOm3DPrrBAksWmNTNjdQy47MFZdmr+uh6nA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RBoBT3pQC4HZDzXPYlv465ebdNWya3PFbBQO0BhRZBjPKeigSZtYC0wpYvRvwni/T
	 TK9LZikpL2GY9InqD5sYoaTZvU1aQqqVRtD64lHIHsEXhCQoO4/uuhXjL5yto5wkNo
	 mjelapnSn6P5754X0AkEbKludJ6AMNo8qjK4tWp/IAi+18YfhZ5Tkxo9LqOA4z/W0q
	 f5aDXFcz4tiw07HH4quNHafTvUzFtYrO3H+NFeWsD3962JCWj7ORjqctL1EeMYGcnN
	 Eu9R0rj3jIb/p26ZaYcpoJ0+jXlF7VzPqxN3YZA5RfRl6RTnjb/mSZu0NtRRjSJ9q2
	 8rd0iYUj6Rnmw==
Date: Sat, 25 Jul 2026 09:18:24 +0000
From: Yixun Lan <dlan@kernel.org>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260725091824-GKA77545@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
 <7x3b4sttnc4oxkuvxmpkihfi76lkapjcigo7khgcgfytvol7w2@v5ykuyrk2z3m>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7x3b4sttnc4oxkuvxmpkihfi76lkapjcigo7khgcgfytvol7w2@v5ykuyrk2z3m>

Hi Anirudh,

On 15:16 Sun 12 Jul     , Anirudh Srinivasan wrote:
> On Thu, Jul 02, 2026 at 02:31:36AM +0000, Yixun Lan wrote:
> > SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> > which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> > M-PHY v3.0 standard.
> > 
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  drivers/ufs/host/Kconfig        |  12 +
> >  drivers/ufs/host/Makefile       |   1 +
> >  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/ufs/host/ufs-spacemit.h |  90 ++++
> >  4 files changed, 1034 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> > index ff170c0b6da0..4f53b7f7688f 100644
> > --- a/drivers/ufs/host/Kconfig
> > +++ b/drivers/ufs/host/Kconfig
> > @@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> >  	bool
> >  	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
> >  
> > +config SCSI_UFS_SPACEMIT
> > +	tristate "SpacemiT UFS controller driver"
> > +	depends on SCSI_UFSHCD_PLATFORM && ARCH_SPACEMIT
> 
> Can you add SCSI_UFSHCD_PLATFORM and SCSI_UFS_SPACEMIT as modules to
> riscv defconfig (or just add the former and add a default y if
> ARCH_SPACEMIT in this Kconfig entry). This will let defconfig kernels
> to boot with persistant rootfs on these devices.
> 
Ok, will consider adding one entry to riscv defconfig, but this should be
handled in another separate patch, for making it as module or built-in driver,
I'm incline to choose latter one, but would be glad to hear different opinion

-- 
Yixun Lan (dlan)
