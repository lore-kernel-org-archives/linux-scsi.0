Received: from mx1.white.stw.pengutronix.de (mx1.white.stw.pengutronix.de [185.203.200.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B34A3D34B6;
	Thu,  2 Jul 2026 07:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.200.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978832; cv=none; b=F/sVCDgMqT2CMj81ZHhk9xT1AmFws4E18EjaFFwSF1X2GLbX3GXdU7HtvXz/hKA4qm7Yo4X4Nm7uX9aj7JUr5vhx+5/+tqdzSKYTJEIAC8qSOAMq4nPxfT1Y91Bnesp/Jb9Ya21CNvED9vNEc/u/CzsoDDbODk24kvLHMHcTW70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978832; c=relaxed/simple;
	bh=Pe93Bh10IOKLtnaCQ1jZVfixg2proisvXEBBme7mEZ4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q3exHeIwMtvPp5HaAlTyLUYbOERATDlXTUz3b/BR9j1i6Hzmfw/5b90YHy+SyHw417edeVSv+XK9vDNF+1H+Rji5B529QkcmgQ4hG9nM0WKQBigCW4yfj4ykNkuh3ORhp6dVX20kDn2x/vwRlbxdjxa2oTV3WgrpUbkp33XEkHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.200.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de (drehscheibe.grey.stw.pengutronix.de [IPv6:2a0a:edc0:0:c01:1d::a2])
	(Authenticated sender: relay-from-drehscheibe.grey.stw.pengutronix.de)
	by mx1.white.stw.pengutronix.de (Postfix) with ESMTPSA id 1A7AC2003DD;
	Thu, 02 Jul 2026 09:53:41 +0200 (CEST)
Received: from lupine.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::4e] helo=lupine)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1wfCEv-005i6i-02;
	Thu, 02 Jul 2026 09:53:41 +0200
Received: from pza by lupine with local (Exim 4.98.2)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1wfCEp-0000000032p-3mmg;
	Thu, 02 Jul 2026 09:53:35 +0200
Message-ID: <c49d9bea7f9a172a97d0acfaa9680bdac80f75e1.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Yixun Lan <dlan@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, Rob
 Herring	 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor
 Dooley	 <conor+dt@kernel.org>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt	 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti	 <alex@ghiti.fr>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Thu, 02 Jul 2026 09:53:35 +0200
In-Reply-To: <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
	 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Do, 2026-07-02 at 02:31 +0000, Yixun Lan wrote:
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
>=20
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  drivers/ufs/host/Kconfig        |  12 +
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++++++=
++++++
>  drivers/ufs/host/ufs-spacemit.h |  90 ++++
>  4 files changed, 1034 insertions(+)
>=20
[...]
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
> @@ -0,0 +1,931 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>

Missing #include <linux/reset.h> for
devm_reset_control_get_optional_exclusive_deasserted() below.
Don't rely on indirect includes.

[...]
> +/**
> + * ufs_spacemit_init - init phy and prepare clk
> + * @hba: host controller instance
> + */
> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> +	int err =3D 0;
> +	struct device *dev =3D hba->dev;
> +	struct ufs_spacemit_host *host;
> +
> +	host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	host->rst =3D devm_reset_control_get_optional_exclusive_deasserted(dev,=
 NULL);

Why is this stored in struct ufs_spacemit_host at all? As far as I can
see it is never used again, so this could be a local variable.

[...]
> diff --git a/drivers/ufs/host/ufs-spacemit.h b/drivers/ufs/host/ufs-space=
mit.h
> new file mode 100644
> index 000000000000..6ae3c263a360
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.h
> @@ -0,0 +1,90 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * SpacemiT UFS Host Controller driver
> + *
> + * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
> + */
> +
> +#ifndef _UFS_SPACEMIT_H_
> +#define _UFS_SPACEMIT_H_
> +
> +#include <linux/reset-controller.h>

Drop this, we are not implementing a reset controller driver here.

> +#include <linux/reset.h>

You could replace this with a struct reset_control forward declaration.
Or drop it ...

[...]
> +struct ufs_spacemit_host {
> +	struct ufs_hba *hba;
> +	struct ufs_pa_layer_attr dev_req_params;
> +	struct reset_control *rst;

... if you end up removing the rst field entirely.

regards
Philipp
