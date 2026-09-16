Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C39A4E4335;
	Wed, 16 Sep 2026 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595559; cv=none; b=dP0iCQkEeh/Rqtw3fWIu/JHuyqK1GAugri6KyBN5MbXwMXBYHOhw3tgYjXPH1L/zVUWuXc6tkQF+WgxmSnTky4Xo9/RzIQjPYMwk1H9PlADzNV+Mx1SPHN+lW8SJSaRQ577mxXANrQRXAWv/O5Buww95y9gUPnle2dWbTVe/7Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595559; c=relaxed/simple;
	bh=jPKu2Fombip+Gx2QXmAiEbv1qfRPb7QMV4qF/9/nyrY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6+gfr/9Emib4zn7AG66k42q5bpkIDo9aWgwdIvSU2lFZd3DHwteAx6MUqJeKJ6II1VGBx78oKsMSbqolaNHSiGuchJagoLxdqBLIXbPQ9GMl5DIwH14NwlySwpRZN78EqAU1AGcgkkVBpUrIzmaPvHp1jzy+/QMymBRJdtnd4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRhbwbgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRhbwbgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2516D1F000FF;
	Wed, 16 Sep 2026 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789595545;
	bh=vG+D5IFPEEJDm9UrHoc/18Q/AggbmyC0XiMDqFxfxco=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=bRhbwbgFMxGBxMuQimwCbEGXvAppYI73YLlTOaPWzroGT6J6wsSkvbvuuePs07vTw
	 gteMlpMf6ht1als9uaI6HG+FRSfEiqw7+17mt2s9cACf5d8vnBeukIWcu6AWbFKhub
	 1TyquISC/FkHkURA+Rm/4sqTVac61WcbQ83dKYlAFfXIlRcX17VlnmVNLCvhQt+NW8
	 DlfVTG1ioh6YnR6ye6YlN9qvotqCtpxAM3+1JaUJfzfGFjxQ+lfUuHknbefY7NlTQi
	 cDa9FAHZLjnQyCTgZNZoD7kgJOv5XZRrLV/+lBg3gcnJv9J3MI431M8HsEZM4OBE1S
	 j1hP1RMu3JuIA==
Date: Wed, 16 Sep 2026 21:52:23 +0000
From: Yixun Lan <dlan@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260916215223-GKA297024@kernel.org>
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
 <20260916-08-k3-ufs-support-v5-2-1f5d71f1027d@kernel.org>
 <aqrDMVMMtTfVVu8X@aurel32.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqrDMVMMtTfVVu8X@aurel32.net>

Hi Aurelien, 

On 18:26 Wed 16 Sep     , Aurelien Jarno wrote:
> Hi Yixun,
> 
> On 2026-09-16 02:59, Yixun Lan wrote:
> > SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> > which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> > M-PHY v3.0 standard.
> > 
> > Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> > Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  drivers/ufs/host/Kconfig        |  12 +
> >  drivers/ufs/host/Makefile       |   1 +
> >  drivers/ufs/host/ufs-spacemit.c | 688 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/ufs/host/ufs-spacemit.h |  79 +++++
> >  4 files changed, 780 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> > index ff170c0b6da0..6146872fcecc 100644
> > --- a/drivers/ufs/host/Kconfig
> > +++ b/drivers/ufs/host/Kconfig
> > @@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> >  	bool
> >  	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
> >  
> > +config SCSI_UFS_SPACEMIT
> > +	tristate "SpacemiT UFS controller driver"
> > +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPACEMIT || COMPILE_TEST)
> > +	help
> > +	  This selects the SpacemiT specific additions to UFSHCD platform driver.
> > +	  UFS host on SpacemiT needs some vendor specific configuration before
> > +	  accessing the hardware which includes PHY configuration and vendor
> > +	  specific registers.
> > +
> > +	  Select this if you have UFS controller on SpacemiT chipset.
> > +	  If unsure, say N.
> > +
> >  config SCSI_UFS_SPRD
> >  	tristate "Unisoc specific hooks to UFS controller platform driver"
> >  	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPRD || COMPILE_TEST)
> > diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
> > index 7d8db67eb23c..a3c447b8fc21 100644
> > --- a/drivers/ufs/host/Makefile
> > +++ b/drivers/ufs/host/Makefile
> > @@ -13,6 +13,7 @@ obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
> >  obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
> >  obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
> >  obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
> > +obj-$(CONFIG_SCSI_UFS_SPACEMIT) += ufs-spacemit.o
> >  obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
> >  obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
> >  obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > index 000000000000..179e6edb2ac2
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> > @@ -0,0 +1,688 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
> > + */
> > +
> > +
...
> > +/*
> > + * Keep UFS ACLK at a lower parent rate (409.6MHz) for stable init.
> > + * This mirrors the "ufs-low-aclk-freq" change from the other environment.
> > + */
> > +#define UFS_ACLK_LOW_FREQ_HZ		409600000UL
> 
> You probably want to rename that to AXI, although here it's not that 
> important.
> 
Ok, will do

...
> > +static u32 ufs_spacemit_get_sys1clk_1us(struct ufs_hba *hba)
> > +{
> > +	struct ufs_clk_info *clki, *ufs_aclk = NULL;
> > +	struct list_head *head = &hba->clk_list_head;
> > +	unsigned long rate_hz = 0;
> > +
> > +	if (!list_empty(head)) {
> > +		list_for_each_entry(clki, head, list) {
> > +			if (clki->name && !strcmp(clki->name, "aclk") && clki->clk) {
> 
> On the other hand, you definitely want to rename this one to "axi" to 
> match the device tree change. Right now the whole patchset just doesn't 
> work.
> 
Oops, you right, will fix it

-- 
Yixun Lan (dlan)
