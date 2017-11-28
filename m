From: =?utf-8?B?6rmA6riw7JuF?= <kwmad.kim@samsung.com>
Subject: RE: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
Date: Tue, 28 Nov 2017 17:27:32 +0900
Message-ID: <002801d36822$bc70eb50$3552c1f0$@samsung.com>
References: <CGME20171128053631epcas1p389908b55511552b79b4083109dddc515@epcas1p3.samsung.com>
        <002a01d3680a$d8817200$89845600$@samsung.com>
        <df3398e9-01ca-e0e5-4f0d-00ecf42f8f35@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:47355 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdK1I1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 03:27:35 -0500
In-reply-to: <df3398e9-01ca-e0e5-4f0d-00ecf42f8f35@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jaehoon Chung' <jh80.chung@samsung.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: cpgs@samsung.com, 'HeonGwang Chu' <hg.chu@samsung.com>, =?utf-8?B?J+q5gOu2gOynhCc=?= <boojin.kim@samsung.com>, 'YOUNGEUN PARK' <youngeun.park@samsung.com>

Hi.
This is modified from Seungwon's initial patch.
And this has been used for several commercial products.
I think you feel weird because you can't see a bunch of unipro and mphy.
But those stuff has been changed whenever new product comes.
So I didn't keep those in this driver.


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jaehoon Chung
> Sent: Tuesday, November 28, 2017 5:20 PM
> To: =EA=B9=80=EA=B8=B0=EC=9B=85; linux-scsi@vger.kernel.org; Martin K. =
Petersen
> Cc: cpgs@samsung.com; HeonGwang Chu; =EA=B9=80=EB=B6=80=EC=A7=84; =
YOUNGEUN PARK
> Subject: Re: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
>=20
> Hi,
>=20
> On 11/28/2017 02:36 PM, =EA=B9=80=EA=B8=B0=EC=9B=85 wrote:
> > This driver is to use UFS devices on Exynos SoC and has been already
> > used for many years for commercial products.
>=20
> Well, i'm not sure but i remembered there are the similar patches
> before..Seungwon and Alim's patches.
> Is it relevant to them?
>=20
> Anyway.. i think i can't test with only these patches..
> how did you test this patches?
>=20
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/Kconfig      |  10 +
> >  drivers/scsi/ufs/Makefile     |   1 +
> >  drivers/scsi/ufs/ufs-exynos.c | 962
> > ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufs-exynos.h | 351 +++++++++++++++
> >  drivers/scsi/ufs/ufshcd.h     |   1 +
> >  5 files changed, 1325 insertions(+)
> >  create mode 100644 drivers/scsi/ufs/ufs-exynos.c  create mode =
100644
> > drivers/scsi/ufs/ufs-exynos.h
>=20
> There is no binding file.
>=20
> >
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig =
index
> > e27b4d4e6ae2..7d71ad8768c3 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > @@ -100,3 +100,13 @@ config SCSI_UFS_QCOM
> >
> >  	  Select this if you have UFS controller on QCOM chipset.
> >  	  If unsure, say N.
> > +
> > +config SCSI_UFS_EXYNOS
> > +	tristate "EXYNOS UFS Host Controller Driver"
> > +	depends on SCSI_UFSHCD && SCSI_UFSHCD_PLATFORM
> > +	---help---
> > +	  This selects the EXYNOS UFS host controller driver.
> > +
> > +	  If you have a controller with this interface, say Y or M here.
> > +
> > +	  If unsure, say N.
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index 9310c6c83041..3312b052dcff 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > @@ -3,6 +3,7 @@
> >  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o =
ufshcd-dwc.o
> > tc-dwc-g210.o
> >  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o
> > ufshcd-dwc.o tc-dwc-g210.o
> >  obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> > +obj-$(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o
> >  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o diff --git
> > a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c new
> > file mode 100644 index 000000000000..98e5aeb80b06
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-exynos.c
> > @@ -0,0 +1,962 @@
> > +/*
> > + * UFS Host Controller driver for Exynos specific extensions
> > + *
> > + * Copyright (C) 2013-2014 Samsung Electronics Co., Ltd.
>=20
> 2013-2014? is it right?
>=20
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as =
published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, =
or
> > + * (at your option) any later version.
> > + */
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/clk.h>
> > +#include "ufshcd.h"
> > +#include "ufshcd-pltfrm.h"
> > +#include "ufs-exynos.h"
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/regmap.h>
> > +#include <linux/spinlock.h>
>=20
> ordering about header file.
>=20
> > +
> > +/*
> > + * Debugging information, SFR/attributes/misc  */ static struct
> > +exynos_ufs *ufs_host_backup[1];> +static int ufs_host_index =3D 0;
>=20
> It has to use the global? Is there any other solution?
>=20
> > +
> > +static struct exynos_ufs_sfr_log ufs_log_std_sfr[] =3D {
> > +	{"CAPABILITIES"			,	REG_CONTROLLER_CAPABILITIES,
> 	0},
> > +	{"UFS VERSION"			,	REG_UFS_VERSION,
> 	0},
> > +	{"PRODUCT ID"			,	REG_CONTROLLER_DEV_ID,
> 	0},
> > +	{"MANUFACTURE ID"		,	REG_CONTROLLER_PROD_ID,
> 	0},
> > +	{"INTERRUPT STATUS"		,	REG_INTERRUPT_STATUS,
> 	0},
> > +	{"INTERRUPT ENABLE"		,	REG_INTERRUPT_ENABLE,
> 	0},
> > +	{"CONTROLLER STATUS"		,	REG_CONTROLLER_STATUS,
> 	0},
> > +	{"CONTROLLER ENABLE"		,	REG_CONTROLLER_ENABLE,
> 	0},
> > +	{"UIC ERR PHY ADAPTER LAYER"	,
> 	REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER,		0},
> > +	{"UIC ERR DATA LINK LAYER"	,	REG_UIC_ERROR_CODE_DATA_LINK_LAYER,
> 		0},
> > +	{"UIC ERR NETWORK LATER"	,	REG_UIC_ERROR_CODE_NETWORK_LAYER,
> 		0},
> > +	{"UIC ERR TRANSPORT LAYER"	,	REG_UIC_ERROR_CODE_TRANSPORT_LAYER,
> 		0},
> > +	{"UIC ERR DME"			,	REG_UIC_ERROR_CODE_DME,
> 	0},
> > +	{"UTP TRANSF REQ INT AGG CNTRL"	,
> 	REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL,		0},
> > +	{"UTP TRANSF REQ LIST BASE L"	,
> 	REG_UTP_TRANSFER_REQ_LIST_BASE_L,		0},
> > +	{"UTP TRANSF REQ LIST BASE H"	,
> 	REG_UTP_TRANSFER_REQ_LIST_BASE_H,		0},
> > +	{"UTP TRANSF REQ DOOR BELL"	,
> 	REG_UTP_TRANSFER_REQ_DOOR_BELL,		0},
> > +	{"UTP TRANSF REQ LIST CLEAR"	,
> 	REG_UTP_TRANSFER_REQ_LIST_CLEAR,		0},
> > +	{"UTP TRANSF REQ LIST RUN STOP"	,
> 	REG_UTP_TRANSFER_REQ_LIST_RUN_STOP,		0},
> > +	{"UTP TASK REQ LIST BASE L"	,
> 	REG_UTP_TASK_REQ_LIST_BASE_L,		0},
> > +	{"UTP TASK REQ LIST BASE H"	,
> 	REG_UTP_TASK_REQ_LIST_BASE_H,		0},
> > +	{"UTP TASK REQ DOOR BELL"	,	REG_UTP_TASK_REQ_DOOR_BELL,
> 	0},
> > +	{"UTP TASK REQ LIST CLEAR"	,	REG_UTP_TASK_REQ_LIST_CLEAR,
> 	0},
> > +	{"UTP TASK REQ LIST RUN STOP"	,
> 	REG_UTP_TASK_REQ_LIST_RUN_STOP,		0},
> > +	{"UIC COMMAND"			,	REG_UIC_COMMAND,
> 	0},
> > +	{"UIC COMMAND ARG1"		,	REG_UIC_COMMAND_ARG_1,
> 	0},
> > +	{"UIC COMMAND ARG2"		,	REG_UIC_COMMAND_ARG_2,
> 	0},
> > +	{"UIC COMMAND ARG3"		,	REG_UIC_COMMAND_ARG_3,
> 	0},
> > +
> > +	{},
> > +};
> > +
> > +/* Helper for UFS CAL interface */
> > +static inline int ufs_init_cal(struct exynos_ufs *ufs, int idx,
> > +					struct platform_device *pdev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_pre_link(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_post_link(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_pre_gear_change(struct exynos_ufs *ufs,
> > +				struct uic_pwr_mode *pmd)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_post_gear_change(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_post_h8_enter(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_pre_h8_exit(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
>=20
> What purpose has these helper fuctions?
>=20
> > +
> > +static inline void exynos_ufs_ctrl_phy_pwr(struct exynos_ufs *ufs,
> > +bool en) {
> > +	int ret =3D 0;
> > +
> > +	if (en)
> > +		ret =3D regmap_update_bits(ufs->pmureg, ufs->cxt_iso.offset,
> > +					ufs->cxt_iso.mask, ufs->cxt_iso.val);
> > +	else
> > +		ret =3D regmap_update_bits(ufs->pmureg, ufs->cxt_iso.offset,
> > +					ufs->cxt_iso.mask, 0);
> > +
> > +	if (ret)
> > +		dev_err(ufs->dev, "Unable to update PHY ISO control\n"); }
> > +
> > +#ifndef __EXYNOS_UFS_VS_DEBUG__
>=20
> There is no defined "__EXYNOS_UFS_VS_DEBUG__". Remove it or include it
> into Kconfig.
>=20
> > +static void exynos_ufs_dump_std_sfr(struct ufs_hba *hba) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	struct exynos_ufs_sfr_log* cfg =3D ufs->debug.std_sfr;
> > +
> > +	dev_err(hba->dev, ": =
----------------------------------------------
> ----- \n");
> > +	dev_err(hba->dev, ": \t\tREGISTER DUMP\n");
> > +	dev_err(hba->dev, ":
> > +--------------------------------------------------- \n");
> > +
> > +	while(cfg) {
> > +		if (!cfg->name)
> > +			break;
> > +		cfg->val =3D ufshcd_readl(hba, cfg->offset);
> > +
> > +		/* Dump */
> > +		dev_err(hba->dev, ": %s(0x%04x):\t\t\t\t0x%08x\n",
> > +				cfg->name, cfg->offset, cfg->val);
> > +
> > +		/* Next SFR */
> > +		cfg++;
> > +	}
> > +}
> > +#endif
> > +
> > +/*
> > + * Exynos debugging main function
> > + */
> > +static void exynos_ufs_dump_debug_info(struct ufs_hba *hba) { =
#ifdef
> > +__EXYNOS_UFS_VS_DEBUG__
>=20
> What is this? Can be remove this.
>=20
> > +#else
> > +	exynos_ufs_dump_std_sfr(hba);
> > +#endif
> > +}
> > +
> > +static inline void exynos_ufs_set_hwacg_control(struct exynos_ufs
> > +*ufs, bool en) {
> > +	u32 reg;
> > +	if ((ufs->hw_rev !=3D UFS_VER_0004) && (ufs->hw_rev !=3D =
UFS_VER_0005))
> > +		return;
> > +
> > +	/*
> > +	 * default value 1->0 at KC. so,
> > +	 * need to set "1(disable HWACG)" during UFS init
> > +	 */
> > +	reg =3D hci_readl(ufs, HCI_UFS_ACG_DISABLE);
> > +	if (en)
> > +		hci_writel(ufs, reg & (~HCI_UFS_ACG_DISABLE_EN),
> HCI_UFS_ACG_DISABLE);
> > +	else
> > +		hci_writel(ufs, reg | HCI_UFS_ACG_DISABLE_EN,
> HCI_UFS_ACG_DISABLE);
> > +
> > +}
> > +
> > +static inline void exynos_ufs_ctrl_auto_hci_clk(struct exynos_ufs
> > +*ufs, bool en) {
> > +	u32 reg =3D hci_readl(ufs, HCI_FORCE_HCS);
> > +
> > +	if (en)
> > +		hci_writel(ufs, reg | HCI_CORECLK_STOP_EN, HCI_FORCE_HCS);
> > +	else
> > +		hci_writel(ufs, reg & ~HCI_CORECLK_STOP_EN, HCI_FORCE_HCS); }
> > +
> > +static inline void exynos_ufs_ctrl_clk(struct exynos_ufs *ufs, bool
> > +en) {
> > +	u32 reg =3D hci_readl(ufs, HCI_FORCE_HCS);
> > +
> > +	if (en)
> > +		hci_writel(ufs, reg | CLK_STOP_CTRL_EN_ALL, HCI_FORCE_HCS);
> > +	else
> > +		hci_writel(ufs, reg & ~CLK_STOP_CTRL_EN_ALL,
> HCI_FORCE_HCS); }
> > +
> > +static inline void exynos_ufs_gate_clk(struct exynos_ufs *ufs, bool
> > +en) {
> > +
> > +	u32 reg =3D hci_readl(ufs, HCI_CLKSTOP_CTRL);
> > +
> > +	if (en)
> > +		hci_writel(ufs, reg | CLK_STOP_ALL, HCI_CLKSTOP_CTRL);
> > +	else
> > +		hci_writel(ufs, reg & ~CLK_STOP_ALL, HCI_CLKSTOP_CTRL); }
> > +
> > +static inline void exynos_ufs_set_unipro_mclk(struct exynos_ufs =
*ufs)
> > +{
> > +	ufs->mclk_rate =3D clk_get_rate(ufs->clk_unipro); }
> > +
> > +static inline void exynos_ufs_fit_aggr_timeout(struct exynos_ufs
> > +*ufs) {
> > +	u32 cnt_val;
> > +	u32 nVal;
>=20
> Don't use the upper character.
>=20
> > +
> > +	/* IA_TICK_SEL : 1(1us_TO_CNT_VAL) */
> > +	nVal =3D hci_readl(ufs, HCI_UFSHCI_V2P1_CTRL);
> > +	nVal |=3D IA_TICK_SEL;
> > +	hci_writel(ufs, nVal, HCI_UFSHCI_V2P1_CTRL);
> > +
> > +	cnt_val =3D ufs->mclk_rate / 1000000 ;
> > +	hci_writel(ufs, cnt_val & CNT_VAL_1US_MASK, HCI_1US_TO_CNT_VAL); }
> > +
> > +static void exynos_ufs_init_pmc_req(struct ufs_hba *hba,
> > +		struct ufs_pa_layer_attr *pwr_max,
> > +		struct ufs_pa_layer_attr *pwr_req)
> > +{
> > +
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	struct uic_pwr_mode *req_pmd =3D &ufs->req_pmd_parm;
> > +	struct uic_pwr_mode *act_pmd =3D &ufs->act_pmd_parm;
> > +
> > +	/* update lane variable after link */
> > +	ufs->num_rx_lanes =3D pwr_max->lane_rx;
> > +	ufs->num_tx_lanes =3D pwr_max->lane_tx;
> > +
> > +	pwr_req->gear_rx
> > +		=3D act_pmd->gear=3D min_t(u8, pwr_max->gear_rx, req_pmd->gear);
> > +	pwr_req->gear_tx
> > +		=3D act_pmd->gear =3D min_t(u8, pwr_max->gear_tx, req_pmd->gear);
> > +	pwr_req->lane_rx
> > +		=3D act_pmd->lane =3D min_t(u8, pwr_max->lane_rx, req_pmd->lane);
> > +	pwr_req->lane_tx
> > +		=3D act_pmd->lane =3D min_t(u8, pwr_max->lane_tx, req_pmd->lane);
> > +	pwr_req->pwr_rx =3D act_pmd->mode =3D req_pmd->mode;
> > +	pwr_req->pwr_tx =3D act_pmd->mode =3D req_pmd->mode;
> > +	pwr_req->hs_rate =3D act_pmd->hs_series =3D req_pmd->hs_series; }
> > +
> > +static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 =
errs,
> > +u8 index) {
> > +	switch(index) {
> > +	case UNIP_PA_LYR:
> > +		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERROR_EN_PA_LAYER);
> > +		break;
> > +	case UNIP_DL_LYR:
> > +		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERROR_EN_DL_LAYER);
> > +		break;
> > +	case UNIP_N_LYR:
> > +		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERROR_EN_N_LAYER);
> > +		break;
> > +	case UNIP_T_LYR:
> > +		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERROR_EN_T_LAYER);
> > +		break;
> > +	case UNIP_DME_LYR:
> > +		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERROR_EN_DME_LAYER);
> > +		break;
> > +	}
> > +}
> > +
> > +static void exynos_ufs_dev_hw_reset(struct ufs_hba *hba) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +
> > +	/* bit[1] for resetn */
>  f> +	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
>=20
> your comment is "bit[1] for resetn" ..but this bit conotrol is for =
bit[0].
> I don't want to use "0 << 0" and " 1 << 0".
>=20
> #define RESETN_HIGH/LOW whatever...
>=20
> > +	udelay(5);
> > +	hci_writel(ufs, 1 << 0, HCI_GPIO_OUT); }
> > +
> > +static void exynos_ufs_init_host(struct exynos_ufs *ufs) {
> > +	u32 reg;
> > +
> > +	/* internal clock control */
> > +	exynos_ufs_ctrl_auto_hci_clk(ufs, false);
> > +	exynos_ufs_set_unipro_mclk(ufs);
> > +
> > +	/* period for interrupt aggregation */
> > +	exynos_ufs_fit_aggr_timeout(ufs);
> > +
> > +	/* misc HCI configurations */
> > +	hci_writel(ufs, 0xA, HCI_DATA_REORDER);
>=20
> Don't use magin number. what is 0xA?
>=20
> > +	hci_writel(ufs, PRDT_PREFECT_EN | PRDT_SET_SIZE(12),
> > +			HCI_TXPRDT_ENTRY_SIZE);
> > +	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
> > +	hci_writel(ufs, 0xFFFFFFFF, HCI_UTRL_NEXUS_TYPE);
> > +	hci_writel(ufs, 0xFFFFFFFF, HCI_UTMRL_NEXUS_TYPE);
>=20
> Ditto.
> > +
> > +	reg =3D hci_readl(ufs, HCI_AXIDMA_RWDATA_BURST_LEN) &
> > +					~BURST_LEN(0);
> > +	hci_writel(ufs, WLU_EN | BURST_LEN(3),
> > +					HCI_AXIDMA_RWDATA_BURST_LEN);
> > +
> > +	/*
> > +	 * Enable HWAGC control by IOP
> > +	 *
> > +	 * default value 1->0 at KC.
> > +	 * always "0"(controlled by UFS_ACG_DISABLE)
> > +	 */
> > +	reg =3D hci_readl(ufs, HCI_IOP_ACG_DISABLE);
> > +	hci_writel(ufs, reg & (~HCI_IOP_ACG_DISABLE_EN),
> > +HCI_IOP_ACG_DISABLE); }
> > +
> > +static int exynos_ufs_init_system(struct exynos_ufs *ufs) {
> > +	struct device *dev =3D ufs->dev;
> > +	int ret =3D 0;
> > +	bool is_io_coherency;
> > +	bool is_dma_coherent;
> > +
> > +	/* PHY isolation bypass */
> > +	exynos_ufs_ctrl_phy_pwr(ufs, true);
> > +
> > +	/* IO cohernecy */
> > +	is_io_coherency =3D !IS_ERR(ufs->sysreg);
> > +	is_dma_coherent =3D !!of_find_property(dev->of_node,
> > +						"dma-coherent", NULL);
> > +
> > +	if (is_io_coherency !=3D is_dma_coherent)
> > +		BUG();
>=20
> BUG()?
>=20
> > +
> > +	if (!is_io_coherency)
> > +		dev_err(dev, "Not configured to use IO coherency\n");
> > +	else
> > +		ret =3D regmap_update_bits(ufs->sysreg, ufs-
> >cxt_coherency.offset,
> > +			ufs->cxt_coherency.mask, ufs->cxt_coherency.val);
> > +
> > +	return ret;
> > +}
> > +
> > +static int exynos_ufs_get_clks(struct ufs_hba *hba) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	struct list_head *head =3D &hba->clk_list_head;
> > +	struct ufs_clk_info *clki;
> > +	int i =3D 0;
> > +
> > +	ufs_host_backup[ufs_host_index++] =3D ufs;
> > +	ufs->debug.std_sfr =3D ufs_log_std_sfr;
> > +
> > +	if (!head || list_empty(head))
> > +		goto out;
> > +
> > +	list_for_each_entry(clki, head, list) {
> > +		/*
> > +		 * get clock with an order listed in device tree
> > +		 */
> > +		if (i =3D=3D 0)
> > +			ufs->clk_hci =3D clki->clk;
> > +		else if (i =3D=3D 1)
> > +			ufs->clk_unipro =3D clki->clk;
> > +
> > +		i++;
> > +	}
> > +out:
> > +	if (!ufs->clk_hci || !ufs->clk_unipro)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static void exynos_ufs_set_features(struct ufs_hba *hba, u32 =
hw_rev)
> > +{
> > +	/* caps */
> > +	hba->caps =3D UFSHCD_CAP_CLK_GATING |
> > +			UFSHCD_CAP_HIBERN8_WITH_CLK_GATING |
> > +			UFSHCD_CAP_INTR_AGGR;
> > +
> > +	/* quirks of common driver */
> > +	hba->quirks =3D UFSHCD_QUIRK_PRDT_BYTE_GRAN;
> > +
> > +	/* quirks of exynos-specific driver */
>=20
> Remove unused comment.
>=20
> > +}
> > +
> > +/*
> > + * Exynos-specific callback functions
> > + *
> > + * init			| Pure SW init & system-related init
> > + * host_reset		| Host SW reset & init
> > + * ...
> > + *
> > + * Initializations for software, host controller and system
> > + * should be contained only in ->host_reset() as possible.
> > + */
> > +
> > +static int exynos_ufs_init(struct ufs_hba *hba) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	int ret;
> > +
> > +	/* set features, such as caps or quirks */
> > +	exynos_ufs_set_features(hba, ufs->hw_rev);
> > +
> > +	/* get some clock sources and debug infomation structures */
> > +	ret =3D exynos_ufs_get_clks(hba);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* system init */
> > +	ret =3D exynos_ufs_init_system(ufs);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ufs->misc_flags =3D EXYNOS_UFS_MISC_TOGGLE_LOG;
> > +
> > +	return 0;
> > +}
> > +
> > +static void exynos_ufs_host_reset(struct ufs_hba *hba) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	unsigned long timeout =3D jiffies + msecs_to_jiffies(1);
> > +
> > +	exynos_ufs_ctrl_auto_hci_clk(ufs, false);
> > +
> > +	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
> > +
> > +	do {
> > +		if (!(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
> > +			goto success;
>=20
> Need to "goto" statement? Just can be located the below code.
> if () {
> 	exynos_ufs_init_host();
> 	exynos_ufs_dev_hw_reset();
> 	return;
> }
>=20
> > +	} while (time_before(jiffies, timeout));
> > +
> > +	dev_err(ufs->dev, "timeout host sw-reset\n");
> > +
> > +	goto out;
>=20
> Not need "goto out", instead "return" at here.
>=20
> > +
> > +success:
> > +	/* host init */
> > +	exynos_ufs_init_host(ufs);
> > +
> > +	/* device reset */
> > +	exynos_ufs_dev_hw_reset(hba);
> > +out:
> > +	return;
> > +}
> > +
> > +static inline void exynos_ufs_dev_reset_ctrl(struct exynos_ufs =
*ufs,
> > +bool en) {
> > +
> > +	if (en)
> > +		hci_writel(ufs, 1 << 0, HCI_GPIO_OUT);
> > +	else
> > +		hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
>=20
> I don't know why this function is need. There is no call anywhere with
> "true".
>=20
> > +}
> > +
> > +static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
> > +					enum ufs_notify_change_status status) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	int ret =3D 0;
> > +
> > +	if (status =3D=3D PRE_CHANGE) {
> > +		if (on) {
> > +			/*
> > +			 * Now all used blocks would not be turned off in a
> host.
> > +			 */
> > +			exynos_ufs_ctrl_auto_hci_clk(ufs, false);
> > +			exynos_ufs_gate_clk(ufs, false);
> > +
> > +			/* HWAGC disable */
> > +			exynos_ufs_set_hwacg_control(ufs, false);
> > +		} else {
> > +			ret =3D ufs_post_h8_enter(ufs);
> > +		}
> > +	} else {
> > +		if (on) {
> > +			ret =3D ufs_pre_h8_exit(ufs);
> > +		} else {
> > +			/*
> > +			 * Now all used blocks would be turned off in a host.
> > +			 */
> > +			exynos_ufs_ctrl_auto_hci_clk(ufs, true);
> > +
> > +			/* HWAGC enable */
> > +			exynos_ufs_set_hwacg_control(ufs, true);
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int exynos_ufs_link_startup_notify(struct ufs_hba *hba,
> > +					enum ufs_notify_change_status status) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	int ret =3D 0;
> > +
> > +	switch (status) {
> > +	case PRE_CHANGE:
> > +		/* refer to hba */
> > +		ufs->hba =3D hba;
> > +
> > +		/* hci */
> > +		exynos_ufs_config_intr(ufs, DFES_DEF_DL_ERRS, UNIP_DL_LYR);
> > +		exynos_ufs_config_intr(ufs, DFES_DEF_N_ERRS, UNIP_N_LYR);
> > +		exynos_ufs_config_intr(ufs, DFES_DEF_T_ERRS, UNIP_T_LYR);
> > +
> > +		exynos_ufs_ctrl_clk(ufs, true);
> > +		exynos_ufs_gate_clk(ufs, false);
> > +		exynos_ufs_set_hwacg_control(ufs, false);
> > +
> > +		if (ufs->num_rx_lanes =3D=3D 0 || ufs->num_tx_lanes =3D=3D 0) {
> > +			ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
> > +					&ufs->num_rx_lanes);
> > +			ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
> > +					&ufs->num_tx_lanes);
> > +			WARN(ufs->num_rx_lanes !=3D ufs->num_tx_lanes,
> > +					"available data lane is not equal(rx:%d,
> tx:%d)\n",
> > +					ufs->num_rx_lanes, ufs->num_tx_lanes);
> > +		}
> > +
> > +		ufs->mclk_rate =3D clk_get_rate(ufs->clk_unipro);
> > +
> > +		ret =3D ufs_pre_link(ufs);
> > +		break;
> > +	case POST_CHANGE:
> > +		/* UIC configuration table after link startup */
> > +		ret =3D ufs_post_link(ufs);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
> > +					enum ufs_notify_change_status status,
> > +					struct ufs_pa_layer_attr *pwr_max,
> > +					struct ufs_pa_layer_attr *pwr_req) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	struct uic_pwr_mode *act_pmd =3D &ufs->act_pmd_parm;
> > +	int ret =3D 0;
> > +
> > +	switch (status) {
> > +	case PRE_CHANGE:
> > +
> > +		/* Set PMC parameters to be requested */
> > +		exynos_ufs_init_pmc_req(hba, pwr_max, pwr_req);
> > +
> > +		/* UIC configuration table before power mode change */
> > +		ret =3D ufs_pre_gear_change(ufs, act_pmd);
> > +
> > +		break;
> > +	case POST_CHANGE:
> > +		/* UIC configuration table after power mode change */
> > +		ret =3D ufs_post_gear_change(ufs);
> > +
> > +		dev_info(ufs->dev,
> > +				"Power mode change(%d): M(%d)G(%d)L(%d)HS-
> series(%d)\n",
> > +				ret, act_pmd->mode, act_pmd->gear,
> > +				act_pmd->lane, act_pmd->hs_series);
>=20
> Fix the indent
>=20
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static void exynos_ufs_set_nexus_t_xfer_req(struct ufs_hba *hba,
> > +				int tag, bool op)
> > +{
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	u32 type;
> > +
> > +	type =3D  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
> > +
> > +	if (op)
> > +		type |=3D (1 << tag);
> > +	else
> > +		type &=3D ~(1 << tag);
> > +
> > +	hci_writel(ufs, type, HCI_UTRL_NEXUS_TYPE); }
> > +
> > +static void exynos_ufs_set_nexus_t_task_mgmt(struct ufs_hba *hba, =
int
> > +tag, u8 tm_func) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	u32 type;
> > +
> > +	type =3D  hci_readl(ufs, HCI_UTMRL_NEXUS_TYPE);
> > +
> > +	switch (tm_func) {
> > +	case UFS_ABORT_TASK:
> > +	case UFS_QUERY_TASK:
> > +		type |=3D (1 << tag);
> > +		break;
> > +	case UFS_ABORT_TASK_SET:
> > +	case UFS_CLEAR_TASK_SET:
> > +	case UFS_LOGICAL_RESET:
> > +	case UFS_QUERY_TASK_SET:
> > +		type &=3D ~(1 << tag);
> > +		break;
> > +	}
> > +
> > +	hci_writel(ufs, type, HCI_UTMRL_NEXUS_TYPE); }
> > +
> > +static int __exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op
> > +pm_op) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +
> > +	exynos_ufs_dev_reset_ctrl(ufs, false);
> > +
> > +	exynos_ufs_ctrl_phy_pwr(ufs, false);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op
> > +pm_op) {
> > +	struct exynos_ufs *ufs =3D to_exynos_ufs(hba);
> > +	int ret =3D 0;
> > +
> > +	exynos_ufs_ctrl_phy_pwr(ufs, true);
> > +
> > +	/* system init */
> > +	ret =3D exynos_ufs_init_system(ufs);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (ufshcd_is_clkgating_allowed(hba))
> > +		clk_prepare_enable(ufs->clk_hci);
> > +	exynos_ufs_ctrl_auto_hci_clk(ufs, false);
> > +
> > +	if (ufshcd_is_clkgating_allowed(hba))
> > +		clk_disable_unprepare(ufs->clk_hci);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct ufs_hba_variant_ops exynos_ufs_ops =3D {
> > +	.init =3D exynos_ufs_init,
> > +	.host_reset =3D exynos_ufs_host_reset,
> > +	.setup_clocks =3D exynos_ufs_setup_clocks,
> > +	.link_startup_notify =3D exynos_ufs_link_startup_notify,
> > +	.pwr_change_notify =3D exynos_ufs_pwr_change_notify,
> > +	.setup_xfer_req =3D exynos_ufs_set_nexus_t_xfer_req,
> > +	.setup_task_mgmt =3D exynos_ufs_set_nexus_t_task_mgmt,
> > +	.dbg_register_dump =3D exynos_ufs_dump_debug_info,
> > +	.suspend =3D __exynos_ufs_suspend,
> > +	.resume =3D __exynos_ufs_resume,
> > +};
> > +
> > +static int exynos_ufs_populate_dt_phy(struct device *dev, struct
> > +exynos_ufs *ufs) {
> > +	struct device_node *ufs_phy;
> > +	struct exynos_ufs_phy *phy =3D &ufs->phy;
> > +	struct resource io_res;
> > +	int ret;
> > +
> > +	ufs_phy =3D of_get_child_by_name(dev->of_node, "ufs-phy");
> > +	if (!ufs_phy) {
> > +		dev_err(dev, "failed to get ufs-phy node\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret =3D of_address_to_resource(ufs_phy, 0, &io_res);
> > +	if (ret) {
> > +		dev_err(dev, "failed to get i/o address phy pma\n");
> > +		goto err_0;
> > +	}
> > +
> > +	phy->reg_pma =3D devm_ioremap_resource(dev, &io_res);
> > +	if (!phy->reg_pma) {
> > +		dev_err(dev, "failed to ioremap for phy pma\n");
> > +		ret =3D -ENOMEM;
> > +		goto err_0;
> > +	}
> > +
> > +err_0:
> > +	of_node_put(ufs_phy);
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * This function is to define offset, mask and shift to access
> somewhere.
> > + */
> > +static int exynos_ufs_set_context_for_access(struct device *dev,
> > +				const char *name, struct exynos_access_cxt *cxt)
> {
> > +	struct device_node *np;
> > +	int ret;
> > +
> > +	np =3D of_get_child_by_name(dev->of_node, name);
> > +	if (!np) {
> > +		dev_err(dev, "failed to get node(%s)\n", name);
> > +		return 1;
>=20
> Don't use the meaningless value.
>=20
> > +	}
> > +
> > +	ret =3D of_property_read_u32(np, "offset", &cxt->offset);
> > +	if (IS_ERR(&cxt->offset)) {
> > +		dev_err(dev, "failed to set cxt(%s) offset\n", name);
> > +		return cxt->offset;
> > +	}
> > +
> > +	ret =3D of_property_read_u32(np, "mask", &cxt->mask);
> > +	if (IS_ERR(&cxt->mask)) {
> > +		dev_err(dev, "failed to set cxt(%s) mask\n", name);
> > +		return cxt->mask;
> > +	}
> > +
> > +	ret =3D of_property_read_u32(np, "val", &cxt->val);
> > +	if (IS_ERR(&cxt->val)) {
> > +		dev_err(dev, "failed to set cxt(%s) val\n", name);
> > +		return cxt->val;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int exynos_ufs_populate_dt_system(struct device *dev, struct
> > +exynos_ufs *ufs) {
> > +	int ret;
> > +
> > +	/* regmap pmureg */
> > +	ufs->pmureg =3D syscon_regmap_lookup_by_phandle(dev->of_node,
> > +					 "samsung,pmu-phandle");
> > +	if (IS_ERR(ufs->pmureg)) {
> > +		/*
> > +		 * phy isolation should be available.
> > +		 * so this case need to be failed.
> > +		 */
> > +		dev_err(dev, "pmu regmap lookup failed.\n");
> > +		return PTR_ERR(ufs->pmureg);
> > +	}
> > +
> > +	/* Set access context for phy isolation bypass */
> > +	ret =3D exynos_ufs_set_context_for_access(dev, "ufs-phy-iso",
> > +							&ufs->cxt_iso);
> > +	if (ret =3D=3D 1) {
> > +		/* no device node, default */
> > +		ufs->cxt_iso.offset =3D 0x0724;
> > +		ufs->cxt_iso.mask =3D 0x1;
> > +		ufs->cxt_iso.val =3D 0x1;
> > +		ret =3D 0;
> > +	}
> > +
> > +	/* regmap sysreg */
> > +	ufs->sysreg =3D syscon_regmap_lookup_by_phandle(dev->of_node,
> > +					 "samsung,sysreg-fsys-phandle");
> > +	if (IS_ERR(ufs->sysreg)) {
> > +		/*
> > +		 * Currently, ufs driver gets sysreg for io coherency.
> > +		 * Some architecture might not support this feature.
> > +		 * So the device node might not exist.
> > +		 */
> > +		dev_err(dev, "sysreg regmap lookup failed.\n");
> > +		return 0;
>=20
> return 0?
>=20
> > +	}
> > +
> > +	/* Set access context for io coherency */
> > +	ret =3D exynos_ufs_set_context_for_access(dev, =
"ufs-dma-coherency",
> > +							&ufs->cxt_coherency);
> > +	if (ret =3D=3D 1) {
> > +		/* no device node, default */
> > +		ufs->cxt_coherency.offset =3D 0x0700;
> > +		ufs->cxt_coherency.mask =3D 0x300;	/* bit 8,9 */
> > +		ufs->cxt_coherency.val =3D 0x3;
> > +		ret =3D 0;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int exynos_ufs_get_pwr_mode(struct device_node *np,
> > +				struct exynos_ufs *ufs)
> > +{
> > +	struct uic_pwr_mode *pmd =3D &ufs->req_pmd_parm;
> > +
> > +	pmd->mode =3D FAST_MODE;
> > +
> > +	if (of_property_read_u8(np, "ufs,pmd-attr-lane", &pmd->lane))
> > +		pmd->lane =3D 1;
> > +
> > +	if (of_property_read_u8(np, "ufs,pmd-attr-gear", &pmd->gear))
> > +		pmd->gear =3D 1;
> > +
> > +	pmd->hs_series =3D PA_HS_MODE_B;
> > +
> > +	return 0;
> > +}
> > +
> > +static int exynos_ufs_populate_dt(struct device *dev, struct
> > +exynos_ufs *ufs) {
> > +	struct device_node *np =3D dev->of_node;
> > +	int ret;
> > +
> > +	/* Get exynos-specific version for featuring */
> > +	if (of_property_read_u32(np, "hw-rev", &ufs->hw_rev))
> > +		ufs->hw_rev =3D UFS_VER_0004;
> > +
> > +	ret =3D exynos_ufs_populate_dt_phy(dev, ufs);
> > +	if (ret) {
> > +		dev_err(dev, "failed to populate dt-phy\n");
> > +		goto out;
> > +	}
> > +
> > +	ret =3D exynos_ufs_populate_dt_system(dev, ufs);
> > +	if (ret) {
> > +		dev_err(dev, "failed to populate dt-pmu\n");
> > +		goto out;
> > +	}
> > +
> > +	exynos_ufs_get_pwr_mode(np, ufs);
> > +
> > +out:
> > +	return ret;
> > +}
> > +
> > +static u64 exynos_ufs_dma_mask =3D DMA_BIT_MASK(32);
> > +
> > +static int exynos_ufs_probe(struct platform_device *pdev) {
> > +	struct device *dev =3D &pdev->dev;
> > +	struct exynos_ufs *ufs;
> > +	struct resource *res;
> > +	int ret;
> > +
> > +	ufs =3D devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
> > +	if (!ufs) {
> > +		dev_err(dev, "cannot allocate mem for exynos-ufs\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* exynos-specific hci */
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +	ufs->reg_hci =3D devm_ioremap_resource(dev, res);
> > +	if (!ufs->reg_hci) {
> > +		dev_err(dev, "cannot ioremap for hci vendor register\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* unipro */
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 2);
> > +	ufs->reg_unipro =3D devm_ioremap_resource(dev, res);
> > +	if (!ufs->reg_unipro) {
> > +		dev_err(dev, "cannot ioremap for unipro register\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* This must be before calling exynos_ufs_populate_dt */
> > +	ret =3D ufs_init_cal(ufs, ufs_host_index, pdev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D exynos_ufs_populate_dt(dev, ufs);
> > +	if (ret) {
> > +		dev_err(dev, "failed to get dt info.\n");
> > +		return ret;
> > +	}
> > +
> > +	ufs->dev =3D dev;
> > +	dev->platform_data =3D ufs;
> > +	dev->dma_mask =3D &exynos_ufs_dma_mask;
> > +
> > +	ret =3D ufshcd_pltfrm_init(pdev, &exynos_ufs_ops);
> > +
> > +	return ret;
> > +}
> > +
> > +static int exynos_ufs_remove(struct platform_device *pdev) {
> > +	struct ufs_hba *hba =3D  platform_get_drvdata(pdev);
> > +	struct exynos_ufs *ufs =3D dev_get_platdata(&pdev->dev);
> > +
> > +	ufshcd_remove(hba);
> > +
> > +	ufs->misc_flags =3D EXYNOS_UFS_MISC_TOGGLE_LOG;
> > +
> > +	exynos_ufs_ctrl_phy_pwr(ufs, false);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int exynos_ufs_suspend(struct device *dev) {
> > +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> > +
> > +	return ufshcd_system_suspend(hba);
> > +}
> > +
> > +static int exynos_ufs_resume(struct device *dev) {
> > +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> > +
> > +	return ufshcd_system_resume(hba);
> > +}
> > +#else
> > +#define exynos_ufs_suspend	NULL
> > +#define exynos_ufs_resume	NULL
> > +#endif /* CONFIG_PM_SLEEP */
> > +
> > +#ifdef CONFIG_PM_RUNTIME
> > +static int exynos_ufs_runtime_suspend(struct device *dev) {
> > +	return ufshcd_system_suspend(dev_get_drvdata(dev));
> > +}
> > +
> > +static int exynos_ufs_runtime_resume(struct device *dev) {
> > +	return ufshcd_system_resume(dev_get_drvdata(dev));
> > +}
> > +
> > +static int exynos_ufs_runtime_idle(struct device *dev) {
> > +	return ufshcd_runtime_idle(dev_get_drvdata(dev));
> > +}
> > +
> > +#else
> > +#define exynos_ufs_runtime_suspend	NULL
> > +#define exynos_ufs_runtime_resume	NULL
> > +#define exynos_ufs_runtime_idle		NULL
> > +#endif /* CONFIG_PM_RUNTIME */
> > +
> > +static void exynos_ufs_shutdown(struct platform_device *pdev) {
> > +	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev)); }
> > +
> > +static const struct dev_pm_ops exynos_ufs_dev_pm_ops =3D {
> > +	.suspend		=3D exynos_ufs_suspend,
> > +	.resume			=3D exynos_ufs_resume,
> > +	.runtime_suspend	=3D exynos_ufs_runtime_suspend,
> > +	.runtime_resume		=3D exynos_ufs_runtime_resume,
> > +	.runtime_idle		=3D exynos_ufs_runtime_idle,
> > +};
> > +
> > +static const struct of_device_id exynos_ufs_match[] =3D {
> > +	{ .compatible =3D "samsung,exynos-ufs", },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, exynos_ufs_match);
> > +
> > +static struct platform_driver exynos_ufs_driver =3D {
> > +	.driver =3D {
> > +		.name =3D "exynos-ufs",
> > +		.owner =3D THIS_MODULE,
> > +		.pm =3D &exynos_ufs_dev_pm_ops,
> > +		.of_match_table =3D exynos_ufs_match,
> > +		.suppress_bind_attrs =3D true,
> > +	},
> > +	.probe =3D exynos_ufs_probe,
> > +	.remove =3D exynos_ufs_remove,
> > +	.shutdown =3D exynos_ufs_shutdown,
> > +};
> > +
> > +module_platform_driver(exynos_ufs_driver);
> > +MODULE_DESCRIPTION("Exynos Specific UFSHCI driver");
> > +MODULE_AUTHOR("Seungwon Jeon <tgih.jun@samsung.com>");
> > +MODULE_AUTHOR("Kiwoong Kim <kwmad.kim@samsung.com>");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/scsi/ufs/ufs-exynos.h
> > b/drivers/scsi/ufs/ufs-exynos.h new file mode 100644 index
> > 000000000000..0480fc4a8931
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-exynos.h
> > @@ -0,0 +1,351 @@
> > +/*
> > + * UFS Host Controller driver for Exynos specific extensions
> > + *
> > + * Copyright (C) 2013-2014 Samsung Electronics Co., Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as =
published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, =
or
> > + * (at your option) any later version.
> > + */
> > +
> > +#ifndef _UFS_EXYNOS_H_
> > +#define _UFS_EXYNOS_H_
> > +
> > +#define UFS_VER_0004	4
> > +#define UFS_VER_0005	5
> > +
> > +/*
> > + * Exynos's Vendor specific registers for UFSHCI  */
> > +#define HCI_TXPRDT_ENTRY_SIZE		0x00
> > +#define HCI_RXPRDT_ENTRY_SIZE		0x04
> > +#define HCI_TO_CNT_DIV_VAL              0x08
> > +#define HCI_1US_TO_CNT_VAL		0x0C
> > + #define CNT_VAL_1US_MASK	0x3ff
> > +#define HCI_INVALID_UPIU_CTRL		0x10
> > +#define HCI_INVALID_UPIU_BADDR		0x14
> > +#define HCI_INVALID_UPIU_UBADDR		0x18
> > +#define HCI_INVALID_UTMR_OFFSET_ADDR	0x1C
> > +#define HCI_INVALID_UTR_OFFSET_ADDR	0x20
> > +#define HCI_INVALID_DIN_OFFSET_ADDR	0x24
> > +#define HCI_VENDOR_SPECIFIC_IS		0x38
> > +#define HCI_VENDOR_SPECIFIC_IE		0x3C
> > +#define HCI_UTRL_NEXUS_TYPE		0x40
> > +#define HCI_UTMRL_NEXUS_TYPE		0x44
> > +#define HCI_E2EFC_CTRL			0x48
> > +#define HCI_SW_RST			0x50
> > + #define UFS_LINK_SW_RST	(1 << 0)
> > + #define UFS_UNIPRO_SW_RST	(1 << 1)
> > + #define UFS_SW_RST_MASK	(UFS_UNIPRO_SW_RST | UFS_LINK_SW_RST)
> > +#define HCI_LINK_VERSION		0x54
> > +#define HCI_IDLE_TIMER_CONFIG		0x58
> > +#define HCI_RX_UPIU_MATCH_ERROR_CODE	0x5C
> > +#define HCI_DATA_REORDER		0x60
> > +#define HCI_MAX_DOUT_DATA_SIZE		0x64
> > +#define HCI_UNIPRO_APB_CLK_CTRL		0x68
> > +#define HCI_AXIDMA_RWDATA_BURST_LEN	0x6C
> > + #define BURST_LEN(x)			((x) << 27 | (x))
> > + #define WLU_EN				(1 << 31)
>=20
> Use BIT(31)
>=20
> > + #define AXIDMA_RWDATA_BURST_LEN	(0xF)
> > +#define HCI_GPIO_OUT			0x70
> > +#define HCI_WRITE_DMA_CTRL		0x74
> > +#define HCI_ERROR_EN_PA_LAYER		0x78
> > +#define HCI_ERROR_EN_DL_LAYER		0x7C
> > +#define HCI_ERROR_EN_N_LAYER		0x80
> > +#define HCI_ERROR_EN_T_LAYER		0x84
> > +#define HCI_ERROR_EN_DME_LAYER		0x88
> > +#define HCI_UFSHCI_V2P1_CTRL			0X8C
> > +#define IA_TICK_SEL				BIT(16)
> > +#define HCI_REQ_HOLD_EN			0xAC
> > +
> > +#define HCI_CLKSTOP_CTRL		0xB0
> > + #define REFCLKOUT_STOP			BIT(4)
> > + #define MPHY_APBCLK_STOP		BIT(3)
> > + #define REFCLK_STOP			BIT(2)
> > + #define UNIPRO_MCLK_STOP		BIT(1)
> > + #define UNIPRO_PCLK_STOP		BIT(0)
> > + #define CLK_STOP_ALL		(REFCLKOUT_STOP |\
> > +					REFCLK_STOP |\
> > +					UNIPRO_MCLK_STOP |\
> > +					UNIPRO_PCLK_STOP)
> > +
> > +#define HCI_FORCE_HCS			0xB4
> > + #define REFCLKOUT_STOP_EN	BIT(11)
> > + #define MPHY_APBCLK_STOP_EN	BIT(10)
> > + #define UFSP_DRCG_EN		BIT(8)
> > + #define REFCLK_STOP_EN		BIT(7)
> > + #define UNIPRO_PCLK_STOP_EN	BIT(6)
> > + #define UNIPRO_MCLK_STOP_EN	BIT(5)
> > + #define HCI_CORECLK_STOP_EN	BIT(4)
> > + #define CLK_STOP_CTRL_EN_ALL	(UFSP_DRCG_EN |\
> > +					MPHY_APBCLK_STOP_EN |\
> > +					REFCLKOUT_STOP_EN |\
> > +					REFCLK_STOP_EN |\
> > +					UNIPRO_PCLK_STOP_EN |\
> > +					UNIPRO_MCLK_STOP_EN)
> > +
> > +#define HCI_FSM_MONITOR			0xC0
> > +#define HCI_PRDT_HIT_RATIO		0xC4
> > +#define HCI_DMA0_MONITOR_STATE		0xC8
> > +#define HCI_DMA0_MONITOR_CNT		0xCC
> > +#define HCI_DMA1_MONITOR_STATE		0xD0
> > +#define HCI_DMA1_MONITOR_CNT		0xD4
> > +
> > +#define HCI_UFS_AXI_DMA_IF_CTRL		0xF8
> > +#define HCI_UFS_ACG_DISABLE		0xFC
> > + #define HCI_UFS_ACG_DISABLE_EN		BIT(0)
> > +#define HCI_IOP_ACG_DISABLE		0x100
> > + #define HCI_IOP_ACG_DISABLE_EN		BIT(0)
> > +#define HCI_MPHY_REFCLK_SEL		0x108
> > + #define MPHY_REFCLK_SEL		BIT(0)
> > +
> > +/* Device fatal error */
> > +#define DFES_ERR_EN	BIT(31)
> > +#define DFES_DEF_DL_ERRS	(UIC_DATA_LINK_LAYER_ERROR_RX_BUF_OF |\
> > +				 UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> > +#define DFES_DEF_N_ERRS		(UIC_NETWORK_UNSUPPORTED_HEADER_TYPE |\
> > +				 UIC_NETWORK_BAD_DEVICEID_ENC |\
> > +				 UIC_NETWORK_LHDR_TRAP_PACKET_DROPPING)
> > +#define DFES_DEF_T_ERRS		(UIC_TRANSPORT_UNSUPPORTED_HEADER_TYPE
> |\
> > +				 UIC_TRANSPORT_UNKNOWN_CPORTID |\
> > +				 UIC_TRANSPORT_NO_CONNECTION_RX |\
> > +				 UIC_TRANSPORT_BAD_TC)
> > +
> > +/* TXPRDT defines */
> > +#define PRDT_PREFECT_EN		BIT(31)
> > +#define PRDT_SET_SIZE(x)	((x) & 0x1F)
> > +
> > +enum {
> > +	UNIP_PA_LYR =3D 0,
> > +	UNIP_DL_LYR,
> > +	UNIP_N_LYR,
> > +	UNIP_T_LYR,
> > +	UNIP_DME_LYR,
> > +};
> > +
> > +/*
> > + * UNIPRO registers
> > + */
> > +#define UNIP_COMP_VERSION			0x000
> > +#define UNIP_COMP_INFO				0x004
> > +#define UNIP_COMP_RESET				0x010
> > +
> > +#define UNIP_DME_POWERON_REQ			0x7800
> > +#define UNIP_DME_POWERON_CNF_RESULT		0x7804
> > +#define UNIP_DME_POWEROFF_REQ			0x7810
> > +#define UNIP_DME_POWEROFF_CNF_RESULT		0x7814
> > +#define UNIP_DME_RESET_REQ 			0x7820
> > +#define UNIP_DME_RESET_REQ_LEVEL		0x7824
> > +#define UNIP_DME_ENABLE_REQ			0x7830
> > +#define UNIP_DME_ENABLE_CNF_RESULT 		0x7834
> > +#define UNIP_DME_ENDPOINTRESET_REQ 		0x7840
> > +#define UNIP_DME_ENDPOINTRESET_CNF_RESULT	0x7844
> > +#define UNIP_DME_LINKSTARTUP_REQ		0x7850
> > +#define UNIP_DME_LINKSTARTUP_CNF_RESULT		0x7854
> > +#define UNIP_DME_HIBERN8_ENTER_REQ 		0x7860
> > +#define UNIP_DME_HIBERN8_ENTER_CNF_RESULT	0x7864
> > +#define UNIP_DME_HIBERN8_ENTER_IND_RESULT	0x7868
> > +#define UNIP_DME_HIBERN8_EXIT_REQ		0x7870
> > +#define UNIP_DME_HIBERN8_EXIT_CNF_RESULT	0x7874
> > +#define UNIP_DME_HIBERN8_EXIT_IND_RESULT	0x7878
> > +#define UNIP_DME_PWR_REQ			0x7880
> > +#define UNIP_DME_PWR_REQ_POWERMODE 		0x7884
> > +#define UNIP_DME_PWR_REQ_LOCALL2TIMER0 		0x7888
> > +#define UNIP_DME_PWR_REQ_LOCALL2TIMER1 		0x788C
> > +#define UNIP_DME_PWR_REQ_LOCALL2TIMER2 		0x7890
> > +#define UNIP_DME_PWR_REQ_REMOTEL2TIMER0		0x78B8
> > +#define UNIP_DME_PWR_REQ_REMOTEL2TIMER1		0x78BC
> > +#define UNIP_DME_PWR_REQ_REMOTEL2TIMER2		0x78C0
> > +#define UNIP_DME_PWR_CNF_RESULT			0x78E8
> > +#define UNIP_DME_PWR_IND_RESULT			0x78EC
> > +#define UNIP_DME_TEST_MODE_REQ 			0x7900
> > +#define UNIP_DME_TEST_MODE_CNF_RESULT		0x7904
> > +
> > +#define UNIP_DME_ERROR_IND_LAYER		0x0C0
> > +#define UNIP_DME_ERROR_IND_ERRCODE		0x0C4
> > +#define UNIP_DME_PACP_CNFBIT			0x0C8
> > +#define UNIP_DME_DL_FRAME_IND			0x0D0
> > +#define UNIP_DME_INTR_STATUS			0x0E0
> > +#define UNIP_DME_INTR_ENABLE			0x0E4
> > +
> > +#define UNIP_DME_GETSET_CONTROL                0x7A00
> > +#define UNIP_DME_GETSET_ADDR                   0x7A04
> > +#define UNIP_DME_GETSET_WDATA                  0x7A08
> > +#define UNIP_DME_GETSET_RDATA                  0x7A0C
> > +#define UNIP_DME_GETSET_RESULT                 0x7A10
> > +#define UNIP_DME_PEER_GETSET_CONTROL           0x7A20
> > +#define UNIP_DME_PEER_GETSET_ADDR              0x7A24
> > +#define UNIP_DME_PEER_GETSET_WDATA             0x7A28
> > +#define UNIP_DME_PEER_GETSET_RDATA             0x7A2C
> > +#define UNIP_DME_PEER_GETSET_RESULT            0x7A30
> > +
> > +#define UNIP_DME_INTR_STATUS_LSB			   0x7B00
> > +#define UNIP_DME_INTR_STATUS_MSB	           0x7B04
> > +#define UNIP_DME_INTR_ERROR_CODE			   0x7B20
> > +#define UNIP_DME_DISCARD_PORT_ID	           0x7B24
> > +#define UNIP_DME_DBG_OPTION_SUITE			   0x7C00
> > +#define UNIP_DME_DBG_CTRL_FSM		           0x7D00
> > +#define UNIP_DME_DBG_FLAG_STATUS			   0x7D14
> > +#define UNIP_DME_DBG_LINKCFG_FSM	           0x7D18
> > +
> > +#define UNIP_DME_INTR_ERROR_CODE		0x7B20
> > +#define UNIP_DME_DEEPSTALL_ENTER_REQ		0x7910
> > +#define UNIP_DME_DISCARD_CPORT_ID		0x7B24
> > +
> > +#define UNIP_DBG_FORCE_DME_CTRL_STATE		0x150
> > +#define UNIP_DBG_AUTO_DME_LINKSTARTUP		0x158
> > +#define UNIP_DBG_PA_CTRLSTATE			0x15C
> > +#define UNIP_DBG_PA_TX_STATE			0x160
> > +#define UNIP_DBG_BREAK_DME_CTRL_STATE		0x164
> > +#define UNIP_DBG_STEP_DME_CTRL_STATE		0x168
> > +#define UNIP_DBG_NEXT_DME_CTRL_STATE		0x16C
> > +
> > +/*
> > + * Driver specific definitions
> > + */
> > +struct exynos_ufs_phy {
> > +	void __iomem *reg_pma;
> > +};
> > +
> > +struct exynos_ufs_clk_info {
> > +	struct list_head list;
> > +	struct clk *clk;
> > +	const char *name;
> > +	u32 freq;
> > +};
> > +
> > +struct exynos_ufs_misc_log {
> > +	struct list_head clk_list_head;
> > +	bool isolation;
> > +};
> > +
> > +struct exynos_ufs_sfr_log {
> > +	const char* name;
> > +	const u32 offset;
> > +#define LOG_STD_HCI_SFR		0xFFFFFFF0
> > +#define LOG_VS_HCI_SFR		0xFFFFFFF1
> > +#define LOG_FMP_SFR		0xFFFFFFF2
> > +#define LOG_UNIPRO_SFR		0xFFFFFFF3
> > +#define LOG_PMA_SFR		0xFFFFFFF4
> > +	u32 val;
> > +};
> > +
> > +struct exynos_ufs_attr_log {
> > +	const u32 offset;
> > +	u32 res;
> > +	u32 val;
> > +};
> > +
> > +struct exynos_ufs_perf {
> > +	u32 opcode;	/* 0: read, 1: write */
> > +	u32 chunk_size;
> > +	ktime_t time;
> > +	u64 total_time;
> > +	u32 count;
> > +	u32 total_count;
> > +};
> > +
> > +/* Main structure for debug and performance */ struct
> > +exynos_ufs_debug {
> > +	struct exynos_ufs_sfr_log* std_sfr;
> > +	struct exynos_ufs_sfr_log* sfr;
> > +	struct exynos_ufs_attr_log* attr;
> > +	struct exynos_ufs_misc_log misc;
> > +	struct exynos_ufs_perf perf;
> > +};
> > +
> > +struct exynos_access_cxt {
> > +	u32 offset;
> > +	u32 mask;
> > +	u32 val;
> > +};
> > +
> > +struct uic_pwr_mode {
> > +	u8 lane;
> > +	u8 gear;
> > +	u8 mode;
> > +	u8 hs_series;
> > +};
> > +
> > +struct exynos_ufs {
> > +	struct device *dev;
> > +	struct ufs_hba *hba;
> > +
> > +	void __iomem *reg_hci;
> > +	void __iomem *reg_unipro;
> > +
> > +	struct regmap *pmureg;
> > +	struct regmap *sysreg;
> > +
> > +	struct clk *clk_hci;
> > +	struct clk *pclk;
> > +	struct clk *clk_unipro;
> > +	u32 mclk_rate;
> > +
> > +	int num_rx_lanes;
> > +	int num_tx_lanes;
> > +
> > +	struct exynos_ufs_phy phy;
> > +	struct uic_pwr_mode req_pmd_parm;
> > +	struct uic_pwr_mode act_pmd_parm;
> > +
> > +	u32 rx_min_actv_time_cap;
> > +	u32 rx_hibern8_time_cap;
> > +	u32 tx_hibern8_time_cap;
> > +
> > +	/* for miscellaneous control */
> > +	u32 misc_flags;
> > +#define EXYNOS_UFS_MISC_TOGGLE_LOG	BIT(0)
> > +
> > +	struct exynos_ufs_debug debug;
> > +
> > +	u32 hw_rev;
> > +
> > +	struct exynos_access_cxt cxt_iso;	/* phy isolation */
> > +	struct exynos_access_cxt cxt_coherency;	/* io coherency */
> > +};
> > +
> > +static inline struct exynos_ufs *to_exynos_ufs(struct ufs_hba *hba) =
{
> > +	return dev_get_platdata(hba->dev);
> > +}
> > +
> > +#ifndef __EXYNOS_UFS_MMIO_FUNC__
> > +#define __EXYNOS_UFS_MMIO_FUNC__
>=20
> I don't understand..why need to check "ifndef =
__EXYNOS_UFS_MMIO_FUNC__".
> (because i didnt find __EXYNOS_UFS_MMIO_FUNC__ anywhere.) It means =
that
> you want to define always, doesn't?
>=20
> > +#define EXYNOS_UFS_MMIO_FUNC(name)						\
> > +static inline void name##_writel(struct exynos_ufs *ufs, u32 val, =
u32
> reg)	\
> > +{										\
> > +	writel(val, ufs->reg_##name + reg);					\
> > +}										\
> > +										\
> > +static inline u32 name##_readl(struct exynos_ufs *ufs, u32 reg)
> 	\
> > +{										\
> > +	return readl(ufs->reg_##name + reg);					\
> > +}
> > +
> > +EXYNOS_UFS_MMIO_FUNC(hci);
> > +EXYNOS_UFS_MMIO_FUNC(unipro);
>=20
> Maybe.. i don't like this style..because it's too difficult to debug =
and
> find the function.
>=20
> > +
> > +static inline void phy_pma_writel(struct exynos_ufs *ufs, u32 val,
> > +u32 reg) {
> > +	u32 reg1 =3D hci_readl(ufs, HCI_CLKSTOP_CTRL);
> > +
> > +	hci_writel(ufs, reg1 & ~MPHY_APBCLK_STOP, HCI_CLKSTOP_CTRL);
> > +	writel(val, ufs->phy.reg_pma + reg);
> > +	hci_writel(ufs, reg1 | MPHY_APBCLK_STOP, HCI_CLKSTOP_CTRL); }
> > +
> > +static inline u32 phy_pma_readl(struct exynos_ufs *ufs, u32 reg) {
> > +	u32 reg1 =3D hci_readl(ufs, HCI_CLKSTOP_CTRL);
> > +
> > +	hci_writel(ufs, reg1 & ~MPHY_APBCLK_STOP, HCI_CLKSTOP_CTRL);
> > +	reg =3D readl(ufs->phy.reg_pma + reg);
> > +	hci_writel(ufs, reg1 | MPHY_APBCLK_STOP, HCI_CLKSTOP_CTRL);
> > +
> > +	return reg;
> > +}
> > +#endif
> > +
> > +#endif /* _UFS_EXYNOS_H_ */
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 1332e544da92..1afd5ac9707c 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -308,6 +308,7 @@ struct ufs_hba_variant_ops {
> >  	int	(*setup_clocks)(struct ufs_hba *, bool,
> >  				enum ufs_notify_change_status);
> >  	int     (*setup_regulators)(struct ufs_hba *, bool);
> > +	void    (*host_reset)(struct ufs_hba *);
> >  	int	(*hce_enable_notify)(struct ufs_hba *,
> >  				     enum ufs_notify_change_status);
> >  	int	(*link_startup_notify)(struct ufs_hba *,
> >
>=20
