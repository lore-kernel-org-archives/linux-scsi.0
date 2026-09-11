Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982FF42BE93;
	Fri, 11 Sep 2026 10:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122747; cv=none; b=hGJPsWPkVaSjAE1QeopbAkAbfWV9IcujNsR3oOX+sH3G9Nte3GOacL9ZX0qAew48nN34pK6G8gmwUR5GFRECZZoxLgpv+0c8wMA0APNzFV/LnpBUIyh3M6BxpKqBU7TK8XG7wIS8yS0gXW3LxYgDVOe/s0FGxMMS+Yi/exyBV00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122747; c=relaxed/simple;
	bh=kN9gJHl4VkFSGQWA2JGU9OcB1UKXNZIgZSdTBvEmYPo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gZojV73d+uHtIeQbrihIURfg44jakEVkFywhH3uvE/gJMNPeT/Pb+SoTgXLEqVyJec2b2+qlBt6eUMQP3n3gJguGmedP8NIiH/nAaXsF4Ixg6rFT282wW5kSc2ON192Sr/dUfDvpG6et6A33lvf4ersgq07wtb4SufZbSzAMXwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3C4tqm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3C4tqm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE2B1F000FF;
	Fri, 11 Sep 2026 10:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789122743;
	bh=D2mCohtwDs2RHmlq+Zn7XQH2mpnU6V9J2n77p2wEC1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X3C4tqm6+RvNPmmwapIrPtDWJIC4gNv6d4ZxlFAzSfUe53nv9BQ1vasNx47QGepx0
	 v1W3eUSXCy7wxDvOBiMXjHMWoppTUajvR7YYn9hvtbvX9ZNTmj0MPy5CJcG93Z1UIO
	 ok35b0NzeHhw3CNS1Sc2o8m5x5GgtBHvoeQBUMW29V9x9YJW76ZMhG/mzvpUTcguEY
	 VadH+bhe9Cw+SlJW97vpgN7RlHY0ZkfdCeXate9/xuBzjqhqweGYUQsOFwEYtFps0w
	 8dLJqMRfayUv7MtQsUs5qGenNpOzKr1F9qZFoqEGw8y19iOwPEbGzqlEKjm1bmJe90
	 A3L9sZcZLJBMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] scsi: ufs: dwc: Rename amd-versal2 read/write
 PHY API and move to dwc common file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Minda Chen" <minda.chen@starfivetech.com>
Cc: robh@kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260911102359.83288-3-minda.chen@starfivetech.com>
References: <20260911102359.83288-1-minda.chen@starfivetech.com>
 <20260911102359.83288-3-minda.chen@starfivetech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 10:32:22 +0000
Message-Id: <20260911103222.EFE2B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Data race in `ufs_dwc_phy_reg_write` and `ufs_dwc_phy_reg_read` du=
e to shared mutable `static` arrays
--

commit 0483c36fe85ab166d063a9b9c880720ee52b5d3b
Author: Minda Chen <minda.chen@starfivetech.com>

scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc commo=
n file

This commit renames the AMD Versal2 UFS read/write PHY register APIs and mo=
ves
them to the common ufshcd-dwc.c file. This allows other designware UFS PHY
vendors to reuse the PHY register read/write functions.

> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
> index 21b1cf912dcc6..b057a78e151c4 100644
> --- a/drivers/ufs/host/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -15,6 +15,59 @@
>  #include "ufshcd-dwc.h"
>  #include "ufshci-dwc.h"
> =20
> +int ufs_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
> +{
> +	static struct ufshcd_dme_attr_val phy_write_attrs[] =3D {

[Severity: High]
This isn't a bug introduced by this patch, but moving it from the specific
versal2 driver to the generic ufshcd-dwc.c library makes it affect all DWC
UFS controllers.

Since the phy_write_attrs array in ufs_dwc_phy_reg_write() is declared stat=
ic
but is mutated on every function call below, could this cause a data race?

If multiple UFS host controllers in a system execute PHY configuration or
power state changes concurrently (e.g., during asynchronous device probing),
they could overwrite each other's attribute values in this globally shared
array. This might result in writing incorrect values to the UFS PHY
registers, potentially leading to link instability or storage failures.

> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +	};
> +
> +	phy_write_attrs[0].mib_val =3D (u8)addr;
> +	phy_write_attrs[1].mib_val =3D (u8)(addr >> 8);
> +	phy_write_attrs[2].mib_val =3D (u8)val;
> +	phy_write_attrs[3].mib_val =3D (u8)(val >> 8);
> +
> +	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_wr=
ite_attrs));
> +}
> +EXPORT_SYMBOL(ufs_dwc_phy_reg_write);
> +
> +int ufs_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
> +{
> +	u32 mib_val;
> +	int ret;
> +	static struct ufshcd_dme_attr_val phy_read_attrs[] =3D {

[Severity: High]
This is a pre-existing issue, but similar to the above, the phy_read_attrs
array in ufs_dwc_phy_reg_read() is mutated on every function call.

Could multiple controllers executing concurrently overwrite each other's
values here, leading to incorrect UFS PHY register reads?

> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +	};
> +
> +	phy_read_attrs[0].mib_val =3D (u8)addr;
> +	phy_read_attrs[1].mib_val =3D (u8)(addr >> 8);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911102359.8328=
8-1-minda.chen@starfivetech.com?part=3D2
