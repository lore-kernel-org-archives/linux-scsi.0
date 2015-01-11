From: ygardi@codeaurora.org
Subject: Re: [PATCH v5 1/4] phy: qcom-ufs: add support for 20nm phy
Date: Sun, 11 Jan 2015 11:10:32 -0000
Message-ID: <a44215ed5612939f56645bc4d3adf9f3.squirrel@www.codeaurora.org>
References: <1420645411-26222-1-git-send-email-ygardi@qti.qualcomm.com>
    <1420645411-26222-2-git-send-email-ygardi@qti.qualcomm.com>
    <4507DCE6-FBE5-42A1-9DB3-4544D820ED2D@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <4507DCE6-FBE5-42A1-9DB3-4544D820ED2D@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Kumar Gala <galak@codeaurora.org>
Cc: Yaniv Gardi <ygardi@qti.qualcomm.com>, james.bottomley@hansenpartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, MSM Mailing List <linux-arm-msm@vger.kernel.org>, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, Yaniv Gardi <ygardi@codeaurora.org>, noag@codeaurora.org, draviv@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>, Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>
> On Jan 7, 2015, at 9:43 AM, Yaniv Gardi <ygardi@qti.qualcomm.com> wro=
te:
>
>> This change adds a support for a 20nm qcom-ufs phy that is
>> required in platforms that use ufs-qcom controller.
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>> drivers/phy/Makefile                |   2 +
>> drivers/phy/phy-qcom-ufs-i.h        | 167 ++++++++
>
> Curious, if the =91-i=92 in name means anything, or if we could just =
call this
> phy-qcom-ufs.h

'-i' stands for 'internal'.
phy-qcom-ufs.h name is already in use in include\linux\phy.
We would like to avoid using same file name

>
>> drivers/phy/phy-qcom-ufs-qmp-20nm.c | 257 +++++++++++++
>> drivers/phy/phy-qcom-ufs-qmp-20nm.h | 235 ++++++++++++
>> drivers/phy/phy-qcom-ufs.c          | 745
>> ++++++++++++++++++++++++++++++++++++
>> include/linux/phy/phy-qcom-ufs.h    |  33 ++
>> 6 files changed, 1439 insertions(+)
>> create mode 100644 drivers/phy/phy-qcom-ufs-i.h
>> create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
>> create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
>> create mode 100644 drivers/phy/phy-qcom-ufs.c
>> create mode 100644 include/linux/phy/phy-qcom-ufs.h
>>
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index aa74f96..ba94e85 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -34,3 +34,5 @@ obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+=3D
>> phy-spear1340-miphy.o
>> obj-$(CONFIG_PHY_XGENE)			+=3D phy-xgene.o
>> obj-$(CONFIG_PHY_STIH407_USB)		+=3D phy-stih407-usb.o
>> obj-$(CONFIG_PHY_STIH41X_USB)		+=3D phy-stih41x-usb.o
>> +obj-$(CONFIG_SCSI_UFS_QCOM) 	+=3D phy-qcom-ufs.o
>> +obj-$(CONFIG_SCSI_UFS_QCOM) 	+=3D phy-qcom-ufs-qmp-20nm.o
>> diff --git a/drivers/phy/phy-qcom-ufs-i.h b/drivers/phy/phy-qcom-ufs=
-i.h
>> new file mode 100644
>> index 0000000..50f1fdc
>> --- /dev/null
>> +++ b/drivers/phy/phy-qcom-ufs-i.h
>> @@ -0,0 +1,167 @@
>> +/*
>> + * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2 a=
nd
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#ifndef UFS_QCOM_PHY_I_H_
>> +#define UFS_QCOM_PHY_I_H_
>> +
>> +#include <linux/module.h>
>> +#include <linux/clk.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/slab.h>
>> +
>> +#include <linux/phy/phy-qcom-ufs.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/io.h>
>> +#include <linux/delay.h>
>> +
>> +#define readl_poll_timeout(addr, val, cond, sleep_us, timeout_us) \
>> +({ \
>> +	ktime_t timeout =3D ktime_add_us(ktime_get(), timeout_us); \
>> +	might_sleep_if(timeout_us); \
>> +	for (;;) { \
>> +		(val) =3D readl(addr); \
>> +		if (cond) \
>> +			break; \
>> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
>> +			(val) =3D readl(addr); \
>> +			break; \
>> +		} \
>> +		if (sleep_us) \
>> +			usleep_range(DIV_ROUND_UP(sleep_us, 4), sleep_us); \
>> +	} \
>> +	(cond) ? 0 : -ETIMEDOUT; \
>> +})
>
> We have a version of this in drivers/phy/phy-qcom-apq8064-sata.c, can=
 we
> pull them out into something like include/asm-generic/io.h
>

it's a different version and the 'signature' is different.
in our code, incoming parameters are:
(addr, val, cond, sleep_us, timeout_us)
in phy-qcom-apq8064-sata.c the parameters are:
(void __iomem *addr, u32 mask)
we'd rather not bring any changes to phy-qcom-apq8064-sata.c,
if it's not trivial (changing incoming parameters and change logic requ=
ire
testing) as we can not test them.


>> +
>> +#define UFS_QCOM_PHY_CAL_ENTRY(reg, val)	\
>> +	{				\
>> +		.reg_offset =3D reg,	\
>> +		.cfg_value =3D val,	\
>> +	}
>> +
>> +#define UFS_QCOM_PHY_NAME_LEN	30
>> +
>> +enum {
>> +	MASK_SERDES_START       =3D 0x1,
>> +	MASK_PCS_READY          =3D 0x1,
>> +};
>> +
>> +enum {
>> +	OFFSET_SERDES_START     =3D 0x0,
>> +};
>
> Any reason these aren=92t #defines?
no special reason.

>
>> +
>> +struct ufs_qcom_phy_stored_attributes {
>> +	u32 att;
>> +	u32 value;
>> +};
>> +
>> +struct ufs_qcom_phy_calibration {
>> +	u32 reg_offset;
>> +	u32 cfg_value;
>> +};
>> +
>> +struct ufs_qcom_phy_vreg {
>> +	const char *name;
>> +	struct regulator *reg;
>> +	int max_uA;
>> +	int min_uV;
>> +	int max_uV;
>> +	bool enabled;
>> +	bool is_always_on;
>> +};
>> +
>> +struct ufs_qcom_phy {
>> +	struct list_head list;
>> +	struct device *dev;
>> +	void __iomem *mmio;
>> +	void __iomem *dev_ref_clk_ctrl_mmio;
>> +	struct clk *tx_iface_clk;
>> +	struct clk *rx_iface_clk;
>> +	bool is_iface_clk_enabled;
>> +	struct clk *ref_clk_src;
>> +	struct clk *ref_clk_parent;
>> +	struct clk *ref_clk;
>> +	bool is_ref_clk_enabled;
>> +	bool is_dev_ref_clk_enabled;
>> +	struct ufs_qcom_phy_vreg vdda_pll;
>> +	struct ufs_qcom_phy_vreg vdda_phy;
>> +	struct ufs_qcom_phy_vreg vddp_ref_clk;
>> +	unsigned int quirks;
>> +	u8 host_ctrl_rev_major;
>> +	u16 host_ctrl_rev_minor;
>> +	u16 host_ctrl_rev_step;
>> +
>> +	/*
>> +	* If UFS PHY power down is deasserted and power is restored to ana=
log
>> +	* circuits, the rx_sigdet can glitch. If the glitch is wide enough=
,
>> +	* it can trigger the digital logic to think it saw a DIF-N and cau=
se
>> +	* it to exit Hibern8. Disabling the rx_sigdet during power-up mask=
s
>> +	* the glitch.
>> +	*/
>> +	#define UFS_QCOM_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE	(1 << 0)
>> +
>
> Where is this used? is it a QUIRK, if so probably having _QUIRK_ in t=
he
> name would be good.

it's a good point. it was a quirk, but it's no longer in use.
will be removed.

>
>> +	/*
>> +	* If UFS link is put into Hibern8 and if UFS PHY analog hardware i=
s
>> +	* power collapsed (by clearing UFS_PHY_POWER_DOWN_CONTROL), Hibern=
8
>> +	* exit might fail even after powering on UFS PHY analog hardware.
>> +	* Enabling this quirk will help to solve above issue by doing
>> +	* custom PHY settings just before PHY analog power collapse.
>> +	*/
>> +	#define UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE	(1 =
<<
>> 1)
>> +
>
> Any reason not to either put this right after quirks above, or pull i=
t out
> of the struct define, and keep it right after?

i accept your comment.
i relocated it right after 'quirks' above.

>
>> +	char name[UFS_QCOM_PHY_NAME_LEN];
>> +	struct ufs_qcom_phy_calibration *cached_regs;
>> +	int cached_regs_table_size;
>> +	bool is_powered_on;
>> +	struct ufs_qcom_phy_specific_ops *phy_spec_ops;
>> +};
>> +
>> +/**
>> + * struct ufs_qcom_phy_specific_ops - set of pointers to functions
>> which have a
>> + * specific implementation per phy. Each UFS phy, should implement
>> + * those functions according to its spec and requirements
>> + * @calibrate_phy: pointer to a function that calibrate the phy
>> + * @start_serdes: pointer to a function that starts the serdes
>> + * @is_physical_coding_sublayer_ready: pointer to a function that
>> + * checks pcs readiness
>
> What is the expected return values here? 0 means ready, non-zero erro=
r?
>
that is correct. a comment regarding return value added.

>> + * @set_tx_lane_enable: pointer to a function that enable tx lanes
>> + * @power_control: pointer to a function that controls analog rail =
of
>> phy
>> + * and writes to QSERDES_RX_SIGDET_CNTRL attribute
>> + */
>> +struct ufs_qcom_phy_specific_ops {
>> +	int (*calibrate_phy)(struct ufs_qcom_phy *phy, bool is_rate_B);
>> +	void (*start_serdes)(struct ufs_qcom_phy *phy);
>> +	int (*is_physical_coding_sublayer_ready)(struct ufs_qcom_phy *phy)=
;
>> +	void (*set_tx_lane_enable)(struct ufs_qcom_phy *phy, u32 val);
>> +	void (*power_control)(struct ufs_qcom_phy *phy, bool val);
>> +};
>> +
>> +struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy);
>> +int ufs_qcom_phy_power_on(struct phy *generic_phy);
>> +int ufs_qcom_phy_power_off(struct phy *generic_phy);
>> +int ufs_qcom_phy_exit(struct phy *generic_phy);
>
> Any reasons these need to be exported, and not just kept static?  I a=
ssume
> these are called via the generic PHY ops.
>
actually there is a reason.
the last patch in this series is adding another phy: 14nm.
in order to be able to support multiple number of phys, we hold a singl=
e
generic routine,
that is exported to all phys

>> +int ufs_qcom_phy_init_clks(struct phy *generic_phy,
>> +			struct ufs_qcom_phy *phy_common);
>> +int ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
>> +			struct ufs_qcom_phy *phy_common);
>> +int ufs_qcom_phy_remove(struct phy *generic_phy,
>> +		       struct ufs_qcom_phy *ufs_qcom_phy);
>> +struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev=
,
>> +			struct ufs_qcom_phy *common_cfg,
>> +			struct phy_ops *ufs_qcom_phy_gen_ops,
>> +			struct ufs_qcom_phy_specific_ops *phy_spec_ops);
>> +int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
>> +			struct ufs_qcom_phy_calibration *tbl_A, int tbl_size_A,
>> +			struct ufs_qcom_phy_calibration *tbl_B, int tbl_size_B,
>> +			bool is_rate_B);
>> +#endif
>> diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
>> b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
>> new file mode 100644
>> index 0000000..8332f96
>> --- /dev/null
>> +++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
>> @@ -0,0 +1,257 @@
>> +/*
>> + * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2 a=
nd
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include "phy-qcom-ufs-qmp-20nm.h"
>> +
>> +#define UFS_PHY_NAME "ufs_phy_qmp_20nm"
>> +
>> +static
>> +int ufs_qcom_phy_qmp_20nm_phy_calibrate(struct ufs_qcom_phy
>> *ufs_qcom_phy,
>> +					bool is_rate_B)
>> +{
>> +	struct ufs_qcom_phy_calibration *tbl_A, *tbl_B;
>> +	int tbl_size_A, tbl_size_B;
>> +	u8 major =3D ufs_qcom_phy->host_ctrl_rev_major;
>> +	u16 minor =3D ufs_qcom_phy->host_ctrl_rev_minor;
>> +	u16 step =3D ufs_qcom_phy->host_ctrl_rev_step;
>> +	int err;
>> +
>> +	if ((major =3D=3D 0x1) && (minor =3D=3D 0x002) && (step =3D=3D 0x0=
000)) {
>> +		tbl_size_A =3D ARRAY_SIZE(phy_cal_table_rate_A_1_2_0);
>> +		tbl_A =3D phy_cal_table_rate_A_1_2_0;
>> +	} else if ((major =3D=3D 0x1) && (minor =3D=3D 0x003) && (step =3D=
=3D 0x0000)) {
>> +		tbl_size_A =3D ARRAY_SIZE(phy_cal_table_rate_A_1_3_0);
>> +		tbl_A =3D phy_cal_table_rate_A_1_3_0;
>> +	} else {
>> +		dev_err(ufs_qcom_phy->dev, "%s: Unknown UFS-PHY version, no
>> calibration values\n",
>> +			__func__);
>> +		err =3D -ENODEV;
>> +		goto out;
>> +	}
>> +
>> +	tbl_size_B =3D ARRAY_SIZE(phy_cal_table_rate_B);
>> +	tbl_B =3D phy_cal_table_rate_B;
>> +
>> +	err =3D ufs_qcom_phy_calibrate(ufs_qcom_phy, tbl_A, tbl_size_A,
>> +						tbl_B, tbl_size_B, is_rate_B);
>> +
>> +	if (err)
>> +		dev_err(ufs_qcom_phy->dev, "%s: ufs_qcom_phy_calibrate() failed
>> %d\n",
>> +			__func__, err);
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +static
>> +void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy
>> *phy_common)
>> +{
>> +	phy_common->quirks =3D
>> +		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
>> +}
>> +
>> +static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy_qmp_20nm *phy =3D phy_get_drvdata(generic_phy)=
;
>> +	struct ufs_qcom_phy *phy_common =3D &phy->common_cfg;
>> +	int err =3D 0;
>> +
>> +	err =3D ufs_qcom_phy_init_clks(generic_phy, phy_common);
>> +	if (err) {
>> +		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\=
n",
>> +			__func__, err);
>> +		goto out;
>> +	}
>> +
>> +	err =3D ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
>> +	if (err) {
>> +		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() fai=
led
>> %d\n",
>> +			__func__, err);
>> +		goto out;
>> +	}
>> +
>> +	ufs_qcom_phy_qmp_20nm_advertise_quirks(phy_common);
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +static
>> +void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, =
bool
>> val)
>> +{
>> +	bool hibern8_exit_after_pwr_collapse =3D phy->quirks &
>> +		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
>> +
>> +	if (val) {
>> +		writel_relaxed(0x1, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
>> +		/*
>> +		 * Before any transactions involving PHY, ensure PHY knows
>> +		 * that it's analog rail is powered ON.
>> +		 */
>> +		mb();
>> +
>> +		if (hibern8_exit_after_pwr_collapse) {
>> +			/*
>> +			 * Give atleast 1us delay after restoring PHY analog
>> +			 * power.
>> +			 */
>> +			usleep_range(1, 2);
>> +			writel_relaxed(0x0A, phy->mmio +
>> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
>> +			writel_relaxed(0x08, phy->mmio +
>> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
>> +			/*
>> +			 * Make sure workaround is deactivated before proceeding
>> +			 * with normal PHY operations.
>> +			 */
>> +			mb();
>> +		}
>> +	} else {
>> +		if (hibern8_exit_after_pwr_collapse) {
>> +			writel_relaxed(0x0A, phy->mmio +
>> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
>> +			writel_relaxed(0x02, phy->mmio +
>> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
>> +			/*
>> +			 * Make sure that above workaround is activated before
>> +			 * PHY analog power collapse.
>> +			 */
>> +			mb();
>> +		}
>> +
>> +		writel_relaxed(0x0, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
>> +		/*
>> +		 * ensure that PHY knows its PHY analog rail is going
>> +		 * to be powered down
>> +		 */
>> +		mb();
>> +	}
>> +}
>> +
>> +static
>> +void ufs_qcom_phy_qmp_20nm_set_tx_lane_enable(struct ufs_qcom_phy *=
phy,
>> u32 val)
>> +{
>> +	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
>> +			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
>> +	mb();
>> +}
>> +
>> +static inline void ufs_qcom_phy_qmp_20nm_start_serdes(struct
>> ufs_qcom_phy *phy)
>> +{
>> +	u32 tmp;
>> +
>> +	tmp =3D readl_relaxed(phy->mmio + UFS_PHY_PHY_START);
>> +	tmp &=3D ~MASK_SERDES_START;
>> +	tmp |=3D (1 << OFFSET_SERDES_START);
>> +	writel_relaxed(tmp, phy->mmio + UFS_PHY_PHY_START);
>> +	mb();
>> +}
>> +
>> +static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy
>> *phy_common)
>> +{
>> +	int err =3D 0;
>> +	u32 val;
>> +
>> +	err =3D readl_poll_timeout(phy_common->mmio + UFS_PHY_PCS_READY_ST=
ATUS,
>> +			val, (val & MASK_PCS_READY), 10, 1000000);
>> +	if (err)
>> +		dev_err(phy_common->dev, "%s: poll for pcs failed err =3D %d\n",
>> +			__func__, err);
>> +	return err;
>> +}
>> +
>> +static struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops =3D {
>> +	.init		=3D ufs_qcom_phy_qmp_20nm_init,
>> +	.exit		=3D ufs_qcom_phy_exit,
>> +	.power_on	=3D ufs_qcom_phy_power_on,
>> +	.power_off	=3D ufs_qcom_phy_power_off,
>> +	.owner		=3D THIS_MODULE,
>> +};
>> +
>> +static struct ufs_qcom_phy_specific_ops phy_20nm_ops =3D {
>> +	.calibrate_phy		=3D ufs_qcom_phy_qmp_20nm_phy_calibrate,
>> +	.start_serdes		=3D ufs_qcom_phy_qmp_20nm_start_serdes,
>> +	.is_physical_coding_sublayer_ready =3D
>> ufs_qcom_phy_qmp_20nm_is_pcs_ready,
>> +	.set_tx_lane_enable	=3D ufs_qcom_phy_qmp_20nm_set_tx_lane_enable,
>> +	.power_control		=3D ufs_qcom_phy_qmp_20nm_power_control,
>> +};
>> +
>> +static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev=
)
>> +{
>> +	struct device *dev =3D &pdev->dev;
>> +	struct phy *generic_phy;
>> +	struct ufs_qcom_phy_qmp_20nm *phy;
>> +	int err =3D 0;
>> +
>> +	phy =3D devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
>> +	if (!phy) {
>> +		dev_err(dev, "%s: failed to allocate phy\n", __func__);
>> +		err =3D -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	generic_phy =3D ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
>> +				&ufs_qcom_phy_qmp_20nm_phy_ops, &phy_20nm_ops);
>> +
>> +	if (!generic_phy) {
>> +		dev_err(dev, "%s: ufs_qcom_phy_generic_probe() failed\n",
>> +			__func__);
>> +		err =3D -EIO;
>> +		goto out;
>> +	}
>> +
>> +	phy_set_drvdata(generic_phy, phy);
>> +
>> +	strlcpy(phy->common_cfg.name, UFS_PHY_NAME,
>> +			sizeof(phy->common_cfg.name));
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +static int ufs_qcom_phy_qmp_20nm_remove(struct platform_device *pde=
v)
>> +{
>> +	struct device *dev =3D &pdev->dev;
>> +	struct phy *generic_phy =3D to_phy(dev);
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +	int err =3D 0;
>> +
>> +	err =3D ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
>> +	if (err)
>> +		dev_err(dev, "%s: ufs_qcom_phy_remove failed =3D %d\n",
>> +			__func__, err);
>> +
>> +	return err;
>> +}
>> +
>> +static const struct of_device_id ufs_qcom_phy_qmp_20nm_of_match[] =3D=
 {
>> +	{.compatible =3D "qcom,ufs-phy-qmp-20nm"},
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_20nm_of_match);
>> +
>> +static struct platform_driver ufs_qcom_phy_qmp_20nm_driver =3D {
>> +	.probe =3D ufs_qcom_phy_qmp_20nm_probe,
>> +	.remove =3D ufs_qcom_phy_qmp_20nm_remove,
>> +	.driver =3D {
>> +		.of_match_table =3D ufs_qcom_phy_qmp_20nm_of_match,
>> +		.name =3D "ufs_qcom_phy_qmp_20nm",
>> +		.owner =3D THIS_MODULE,
>> +	},
>> +};
>> +
>> +module_platform_driver(ufs_qcom_phy_qmp_20nm_driver);
>> +
>> +MODULE_DESCRIPTION("Universal Flash Storage (UFS) QCOM PHY QMP 20nm=
");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.h
>> b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
>> new file mode 100644
>> index 0000000..4f3076b
>> --- /dev/null
>> +++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
>> @@ -0,0 +1,235 @@
>> +/*
>> + * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2 a=
nd
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#ifndef UFS_QCOM_PHY_QMP_20NM_H_
>> +#define UFS_QCOM_PHY_QMP_20NM_H_
>> +
>> +#include "phy-qcom-ufs-i.h"
>> +
>> +/* QCOM UFS PHY control registers */
>> +
>> +#define COM_OFF(x)     (0x000 + x)
>> +#define PHY_OFF(x)     (0xC00 + x)
>> +#define TX_OFF(n, x)   (0x400 + (0x400 * n) + x)
>> +#define RX_OFF(n, x)   (0x600 + (0x400 * n) + x)
>> +
>> +/* UFS PHY PLL block registers */
>> +#define QSERDES_COM_SYS_CLK_CTRL		COM_OFF(0x0)
>> +#define QSERDES_COM_PLL_VCOTAIL_EN		COM_OFF(0x04)
>> +#define QSERDES_COM_PLL_CNTRL			COM_OFF(0x14)
>> +#define QSERDES_COM_PLL_IP_SETI			COM_OFF(0x24)
>> +#define QSERDES_COM_CORE_CLK_IN_SYNC_SEL	COM_OFF(0x28)
>> +#define QSERDES_COM_BIAS_EN_CLKBUFLR_EN		COM_OFF(0x30)
>> +#define QSERDES_COM_PLL_CP_SETI			COM_OFF(0x34)
>> +#define QSERDES_COM_PLL_IP_SETP			COM_OFF(0x38)
>> +#define QSERDES_COM_PLL_CP_SETP			COM_OFF(0x3C)
>> +#define QSERDES_COM_SYSCLK_EN_SEL_TXBAND	COM_OFF(0x48)
>> +#define QSERDES_COM_RESETSM_CNTRL		COM_OFF(0x4C)
>> +#define QSERDES_COM_RESETSM_CNTRL2		COM_OFF(0x50)
>> +#define QSERDES_COM_PLLLOCK_CMP1		COM_OFF(0x90)
>> +#define QSERDES_COM_PLLLOCK_CMP2		COM_OFF(0x94)
>> +#define QSERDES_COM_PLLLOCK_CMP3		COM_OFF(0x98)
>> +#define QSERDES_COM_PLLLOCK_CMP_EN		COM_OFF(0x9C)
>> +#define QSERDES_COM_BGTC			COM_OFF(0xA0)
>> +#define QSERDES_COM_DEC_START1			COM_OFF(0xAC)
>> +#define QSERDES_COM_PLL_AMP_OS			COM_OFF(0xB0)
>> +#define QSERDES_COM_RES_CODE_UP_OFFSET		COM_OFF(0xD8)
>> +#define QSERDES_COM_RES_CODE_DN_OFFSET		COM_OFF(0xDC)
>> +#define QSERDES_COM_DIV_FRAC_START1		COM_OFF(0x100)
>> +#define QSERDES_COM_DIV_FRAC_START2		COM_OFF(0x104)
>> +#define QSERDES_COM_DIV_FRAC_START3		COM_OFF(0x108)
>> +#define QSERDES_COM_DEC_START2			COM_OFF(0x10C)
>> +#define QSERDES_COM_PLL_RXTXEPCLK_EN		COM_OFF(0x110)
>> +#define QSERDES_COM_PLL_CRCTRL			COM_OFF(0x114)
>> +#define QSERDES_COM_PLL_CLKEPDIV		COM_OFF(0x118)
>> +
>> +/* TX LANE n (0, 1) registers */
>> +#define QSERDES_TX_EMP_POST1_LVL(n)		TX_OFF(n, 0x08)
>> +#define QSERDES_TX_DRV_LVL(n)			TX_OFF(n, 0x0C)
>> +#define QSERDES_TX_LANE_MODE(n)			TX_OFF(n, 0x54)
>> +
>> +/* RX LANE n (0, 1) registers */
>> +#define QSERDES_RX_CDR_CONTROL1(n)		RX_OFF(n, 0x0)
>> +#define QSERDES_RX_CDR_CONTROL_HALF(n)		RX_OFF(n, 0x8)
>> +#define QSERDES_RX_RX_EQ_GAIN1_LSB(n)		RX_OFF(n, 0xA8)
>> +#define QSERDES_RX_RX_EQ_GAIN1_MSB(n)		RX_OFF(n, 0xAC)
>> +#define QSERDES_RX_RX_EQ_GAIN2_LSB(n)		RX_OFF(n, 0xB0)
>> +#define QSERDES_RX_RX_EQ_GAIN2_MSB(n)		RX_OFF(n, 0xB4)
>> +#define QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(n)	RX_OFF(n, 0xBC)
>> +#define QSERDES_RX_CDR_CONTROL_QUARTER(n)	RX_OFF(n, 0xC)
>> +#define QSERDES_RX_SIGDET_CNTRL(n)		RX_OFF(n, 0x100)
>> +
>> +/* UFS PHY registers */
>> +#define UFS_PHY_PHY_START			PHY_OFF(0x00)
>> +#define UFS_PHY_POWER_DOWN_CONTROL		PHY_OFF(0x4)
>> +#define UFS_PHY_TX_LANE_ENABLE			PHY_OFF(0x44)
>> +#define UFS_PHY_PWM_G1_CLK_DIVIDER		PHY_OFF(0x08)
>> +#define UFS_PHY_PWM_G2_CLK_DIVIDER		PHY_OFF(0x0C)
>> +#define UFS_PHY_PWM_G3_CLK_DIVIDER		PHY_OFF(0x10)
>> +#define UFS_PHY_PWM_G4_CLK_DIVIDER		PHY_OFF(0x14)
>> +#define UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER	PHY_OFF(0x34)
>> +#define UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER	PHY_OFF(0x38)
>> +#define UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER	PHY_OFF(0x3C)
>> +#define UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER	PHY_OFF(0x40)
>> +#define UFS_PHY_OMC_STATUS_RDVAL		PHY_OFF(0x68)
>> +#define UFS_PHY_LINE_RESET_TIME			PHY_OFF(0x28)
>> +#define UFS_PHY_LINE_RESET_GRANULARITY		PHY_OFF(0x2C)
>> +#define UFS_PHY_TSYNC_RSYNC_CNTL		PHY_OFF(0x48)
>> +#define UFS_PHY_PLL_CNTL			PHY_OFF(0x50)
>> +#define UFS_PHY_TX_LARGE_AMP_DRV_LVL		PHY_OFF(0x54)
>> +#define UFS_PHY_TX_SMALL_AMP_DRV_LVL		PHY_OFF(0x5C)
>> +#define UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL	PHY_OFF(0x58)
>> +#define UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL	PHY_OFF(0x60)
>> +#define UFS_PHY_CFG_CHANGE_CNT_VAL		PHY_OFF(0x64)
>> +#define UFS_PHY_RX_SYNC_WAIT_TIME		PHY_OFF(0x6C)
>> +#define UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xB4)
>> +#define UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xE0)
>> +#define UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xB8)
>> +#define UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xE4)
>> +#define UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY	PHY_OFF(0xBC)
>> +#define UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY	PHY_OFF(0xE8)
>> +#define UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY	PHY_OFF(0xFC=
)
>> +#define UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY		PHY_OFF(0x100)
>> +#define UFS_PHY_RX_SIGDET_CTRL3				PHY_OFF(0x14c)
>> +#define UFS_PHY_RMMI_ATTR_CTRL			PHY_OFF(0x160)
>> +#define UFS_PHY_RMMI_RX_CFGUPDT_L1	(1 << 7)
>> +#define UFS_PHY_RMMI_TX_CFGUPDT_L1	(1 << 6)
>> +#define UFS_PHY_RMMI_CFGWR_L1		(1 << 5)
>> +#define UFS_PHY_RMMI_CFGRD_L1		(1 << 4)
>> +#define UFS_PHY_RMMI_RX_CFGUPDT_L0	(1 << 3)
>> +#define UFS_PHY_RMMI_TX_CFGUPDT_L0	(1 << 2)
>> +#define UFS_PHY_RMMI_CFGWR_L0		(1 << 1)
>> +#define UFS_PHY_RMMI_CFGRD_L0		(1 << 0)
>> +#define UFS_PHY_RMMI_ATTRID			PHY_OFF(0x164)
>> +#define UFS_PHY_RMMI_ATTRWRVAL			PHY_OFF(0x168)
>> +#define UFS_PHY_RMMI_ATTRRDVAL_L0_STATUS	PHY_OFF(0x16C)
>> +#define UFS_PHY_RMMI_ATTRRDVAL_L1_STATUS	PHY_OFF(0x170)
>> +#define UFS_PHY_PCS_READY_STATUS		PHY_OFF(0x174)
>> +
>> +#define UFS_PHY_TX_LANE_ENABLE_MASK		0x3
>> +
>> +/*
>> + * This structure represents the 20nm specific phy.
>> + * common_cfg MUST remain the first field in this structure
>> + * in case extra fields are added. This way, when calling
>> + * get_ufs_qcom_phy() of generic phy, we can extract the
>> + * common phy structure (struct ufs_qcom_phy) out of it
>> + * regardless of the relevant specific phy.
>> + */
>> +struct ufs_qcom_phy_qmp_20nm {
>> +	struct ufs_qcom_phy common_cfg;
>> +};
>
> Do expect at some point the 20nm phy to change such that this struct =
would
> have something more in it?  If not it seems like we should just use
> 'struct ufs_qcom_phy=92 directly in this code and remove the addition=
al
> indirection.
>

as this driver should support multiple number of phys (last change in t=
his
series is adding another
phy) we need to do it as generic as possible, for future phys that migh=
t
be different as well.

>> +
>> +static struct ufs_qcom_phy_calibration phy_cal_table_rate_A_1_2_0[]=
 =3D {
>> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
>> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SIGDET_CTRL3, 0x0D),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x1b),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x0f),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(0), 0x2F),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(0), 0x20),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(1), 0x2F),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(1), 0x20),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x3),
>> +};
>> +
>> +static struct ufs_qcom_phy_calibration phy_cal_table_rate_A_1_3_0[]=
 =3D {
>> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
>> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SIGDET_CTRL3, 0x0D),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x2b),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x38),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x3c),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_CODE_UP_OFFSET, 0x02),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_CODE_DN_OFFSET, 0x02),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x40),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x3),
>> +};
>> +
>> +static struct ufs_qcom_phy_calibration phy_cal_table_rate_B[] =3D {
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
>> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1e),
>> +};
>> +
>
> While I doubt we=92d include this in more than one place, seems like =
the
> static tables should be in the .c file instead.
>

indeed this table (and the one that will be added to 14nm phy), is
included only once,
but we'd rather keep the definition table in the header file for a
separation reasons.

>> +#endif
>> diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
>> new file mode 100644
>> index 0000000..44ee983
>> --- /dev/null
>> +++ b/drivers/phy/phy-qcom-ufs.c
>> @@ -0,0 +1,745 @@
>> +/*
>> + * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2 a=
nd
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include "phy-qcom-ufs-i.h"
>> +
>> +#define MAX_PROP_NAME              32
>> +#define VDDA_PHY_MIN_UV            1000000
>> +#define VDDA_PHY_MAX_UV            1000000
>> +#define VDDA_PLL_MIN_UV            1800000
>> +#define VDDA_PLL_MAX_UV            1800000
>> +#define VDDP_REF_CLK_MIN_UV        1200000
>> +#define VDDP_REF_CLK_MAX_UV        1200000
>> +
>> +static int __ufs_qcom_phy_init_vreg(struct phy *, struct
>> ufs_qcom_phy_vreg *,
>> +				    const char *, bool);
>> +static int ufs_qcom_phy_init_vreg(struct phy *, struct
>> ufs_qcom_phy_vreg *,
>> +				  const char *);
>> +static int ufs_qcom_phy_base_init(struct platform_device *pdev,
>> +				  struct ufs_qcom_phy *phy_common);
>> +
>> +int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
>> +			   struct ufs_qcom_phy_calibration *tbl_A,
>> +			   int tbl_size_A,
>> +			   struct ufs_qcom_phy_calibration *tbl_B,
>> +			   int tbl_size_B, bool is_rate_B)
>> +{
>> +	int i;
>> +	int ret =3D 0;
>> +
>> +	if (!tbl_A) {
>> +		dev_err(ufs_qcom_phy->dev, "%s: tbl_A is NULL", __func__);
>> +		ret =3D EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	for (i =3D 0; i < tbl_size_A; i++)
>> +		writel_relaxed(tbl_A[i].cfg_value,
>> +			       ufs_qcom_phy->mmio + tbl_A[i].reg_offset);
>> +
>> +	/*
>> +	 * In case we would like to work in rate B, we need
>> +	 * to override a registers that were configured in rate A table
>> +	 * with registers of rate B table.
>> +	 * table.
>> +	 */
>> +	if (is_rate_B) {
>> +		if (!tbl_B) {
>> +			dev_err(ufs_qcom_phy->dev, "%s: tbl_B is NULL",
>> +				__func__);
>> +			ret =3D EINVAL;
>> +			goto out;
>> +		}
>> +
>> +		for (i =3D 0; i < tbl_size_B; i++)
>> +			writel_relaxed(tbl_B[i].cfg_value,
>> +				ufs_qcom_phy->mmio + tbl_B[i].reg_offset);
>> +	}
>> +
>> +	/* flush buffered writes */
>> +	mb();
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev=
,
>> +				struct ufs_qcom_phy *common_cfg,
>> +				struct phy_ops *ufs_qcom_phy_gen_ops,
>> +				struct ufs_qcom_phy_specific_ops *phy_spec_ops)
>> +{
>> +	int err;
>> +	struct device *dev =3D &pdev->dev;
>> +	struct phy *generic_phy =3D NULL;
>> +	struct phy_provider *phy_provider;
>> +
>> +	err =3D ufs_qcom_phy_base_init(pdev, common_cfg);
>> +	if (err) {
>> +		dev_err(dev, "%s: phy base init failed %d\n", __func__, err);
>> +		goto out;
>> +	}
>> +
>> +	phy_provider =3D devm_of_phy_provider_register(dev,
>> of_phy_simple_xlate);
>> +	if (IS_ERR(phy_provider)) {
>> +		err =3D PTR_ERR(phy_provider);
>> +		dev_err(dev, "%s: failed to register phy %d\n", __func__, err);
>> +		goto out;
>> +	}
>> +
>> +	generic_phy =3D devm_phy_create(dev, NULL, ufs_qcom_phy_gen_ops);
>> +	if (IS_ERR(generic_phy)) {
>> +		err =3D  PTR_ERR(generic_phy);
>> +		dev_err(dev, "%s: failed to create phy %d\n", __func__, err);
>> +		goto out;
>> +	}
>> +
>> +	common_cfg->phy_spec_ops =3D phy_spec_ops;
>> +	common_cfg->dev =3D dev;
>> +
>> +out:
>> +	return generic_phy;
>> +}
>> +
>> +/*
>> + * This assumes the embedded phy structure inside generic_phy is of
>> type
>> + * struct ufs_qcom_phy. In order to function properly it's crucial
>> + * to keep the embedded struct "struct ufs_qcom_phy common_cfg"
>> + * as the first inside generic_phy.
>> + */
>> +struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy)
>> +{
>> +	return (struct ufs_qcom_phy *)phy_get_drvdata(generic_phy);
>> +}
>> +
>> +static
>> +int ufs_qcom_phy_base_init(struct platform_device *pdev,
>> +			   struct ufs_qcom_phy *phy_common)
>> +{
>> +	struct device *dev =3D &pdev->dev;
>> +	struct resource *res;
>> +	int err =3D 0;
>> +
>> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_me=
m");
>> +	if (!res) {
>> +		dev_err(dev, "%s: phy_mem resource not found\n", __func__);
>> +		err =3D -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	phy_common->mmio =3D devm_ioremap_resource(dev, res);
>> +	if (IS_ERR((void const *)phy_common->mmio)) {
>> +		err =3D PTR_ERR((void const *)phy_common->mmio);
>> +		phy_common->mmio =3D NULL;
>> +		dev_err(dev, "%s: ioremap for phy_mem resource failed %d\n",
>> +			__func__, err);
>> +		goto out;
>> +	}
>> +
>> +	/* "dev_ref_clk_ctrl_mem" is optional resource */
>> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +					   "dev_ref_clk_ctrl_mem");
>> +	if (!res) {
>> +		dev_dbg(dev, "%s: dev_ref_clk_ctrl_mem resource not found\n",
>> +			__func__);
>> +		goto out;
>> +	}
>> +
>> +	phy_common->dev_ref_clk_ctrl_mmio =3D devm_ioremap_resource(dev, r=
es);
>> +	if (IS_ERR((void const *)phy_common->dev_ref_clk_ctrl_mmio)) {
>> +		err =3D PTR_ERR((void const *)phy_common->dev_ref_clk_ctrl_mmio);
>> +		phy_common->dev_ref_clk_ctrl_mmio =3D NULL;
>> +		dev_err(dev, "%s: ioremap for dev_ref_clk_ctrl_mem resource faile=
d
>> %d\n",
>> +			__func__, err);
>> +	}
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +static int __ufs_qcom_phy_clk_get(struct phy *phy,
>> +			 const char *name, struct clk **clk_out, bool err_print)
>> +{
>> +	struct clk *clk;
>> +	int err =3D 0;
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(phy);
>> +	struct device *dev =3D ufs_qcom_phy->dev;
>> +
>> +	clk =3D devm_clk_get(dev, name);
>> +	if (IS_ERR(clk)) {
>> +		err =3D PTR_ERR(clk);
>> +		if (err_print)
>> +			dev_err(dev, "failed to get %s err %d", name, err);
>> +	} else {
>> +		*clk_out =3D clk;
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static
>> +int ufs_qcom_phy_clk_get(struct phy *phy,
>> +			 const char *name, struct clk **clk_out)
>> +{
>> +	return __ufs_qcom_phy_clk_get(phy, name, clk_out, true);
>> +}
>> +
>> +int
>> +ufs_qcom_phy_init_clks(struct phy *generic_phy,
>> +		       struct ufs_qcom_phy *phy_common)
>> +{
>> +	int err;
>> +
>> +	err =3D ufs_qcom_phy_clk_get(generic_phy, "tx_iface_clk",
>> +				   &phy_common->tx_iface_clk);
>> +	if (err)
>> +		goto out;
>> +
>> +	err =3D ufs_qcom_phy_clk_get(generic_phy, "rx_iface_clk",
>> +				   &phy_common->rx_iface_clk);
>> +	if (err)
>> +		goto out;
>> +
>> +	err =3D ufs_qcom_phy_clk_get(generic_phy, "ref_clk_src",
>> +				   &phy_common->ref_clk_src);
>> +	if (err)
>> +		goto out;
>> +
>> +	/*
>> +	 * "ref_clk_parent" is optional hence don't abort init if it's not
>> +	 * found.
>> +	 */
>> +	__ufs_qcom_phy_clk_get(generic_phy, "ref_clk_parent",
>> +				   &phy_common->ref_clk_parent, false);
>> +
>> +	err =3D ufs_qcom_phy_clk_get(generic_phy, "ref_clk",
>> +				   &phy_common->ref_clk);
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +int
>> +ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
>> +			      struct ufs_qcom_phy *phy_common)
>> +{
>> +	int err;
>> +
>> +	err =3D ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vdda_pll,
>> +		"vdda-pll");
>> +	if (err)
>> +		goto out;
>> +
>> +	err =3D ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vdda_phy,
>> +		"vdda-phy");
>> +
>> +	if (err)
>> +		goto out;
>> +
>> +	/* vddp-ref-clk-* properties are optional */
>> +	__ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vddp_ref_clk,
>> +				 "vddp-ref-clk", true);
>> +out:
>> +	return err;
>> +}
>> +
>> +static int __ufs_qcom_phy_init_vreg(struct phy *phy,
>> +		struct ufs_qcom_phy_vreg *vreg, const char *name, bool optional)
>> +{
>> +	int err =3D 0;
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(phy);
>> +	struct device *dev =3D ufs_qcom_phy->dev;
>> +
>> +	char prop_name[MAX_PROP_NAME];
>> +
>> +	vreg->name =3D kstrdup(name, GFP_KERNEL);
>> +	if (!vreg->name) {
>> +		err =3D -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	vreg->reg =3D devm_regulator_get(dev, name);
>> +	if (IS_ERR(vreg->reg)) {
>> +		err =3D PTR_ERR(vreg->reg);
>> +		vreg->reg =3D NULL;
>> +		if (!optional)
>> +			dev_err(dev, "failed to get %s, %d\n", name, err);
>> +		goto out;
>> +	}
>> +
>> +	if (dev->of_node) {
>> +		snprintf(prop_name, MAX_PROP_NAME, "%s-max-microamp", name);
>> +		err =3D of_property_read_u32(dev->of_node,
>> +					prop_name, &vreg->max_uA);
>> +		if (err && err !=3D -EINVAL) {
>> +			dev_err(dev, "%s: failed to read %s\n",
>> +					__func__, prop_name);
>> +			goto out;
>> +		} else if (err =3D=3D -EINVAL || !vreg->max_uA) {
>> +			if (regulator_count_voltages(vreg->reg) > 0) {
>> +				dev_err(dev, "%s: %s is mandatory\n",
>> +						__func__, prop_name);
>> +				goto out;
>> +			}
>> +			err =3D 0;
>> +		}
>> +		snprintf(prop_name, MAX_PROP_NAME, "%s-always-on", name);
>> +		if (of_get_property(dev->of_node, prop_name, NULL))
>> +			vreg->is_always_on =3D true;
>> +		else
>> +			vreg->is_always_on =3D false;
>> +	}
>> +
>> +	if (!strcmp(name, "vdda-pll")) {
>> +		vreg->max_uV =3D VDDA_PLL_MAX_UV;
>> +		vreg->min_uV =3D VDDA_PLL_MIN_UV;
>> +	} else if (!strcmp(name, "vdda-phy")) {
>> +		vreg->max_uV =3D VDDA_PHY_MAX_UV;
>> +		vreg->min_uV =3D VDDA_PHY_MIN_UV;
>> +	} else if (!strcmp(name, "vddp-ref-clk")) {
>> +		vreg->max_uV =3D VDDP_REF_CLK_MAX_UV;
>> +		vreg->min_uV =3D VDDP_REF_CLK_MIN_UV;
>> +	}
>> +
>> +out:
>> +	if (err)
>> +		kfree(vreg->name);
>> +	return err;
>> +}
>> +
>> +static int ufs_qcom_phy_init_vreg(struct phy *phy,
>> +			struct ufs_qcom_phy_vreg *vreg, const char *name)
>> +{
>> +	return __ufs_qcom_phy_init_vreg(phy, vreg, name, false);
>> +}
>> +
>> +static
>> +int ufs_qcom_phy_cfg_vreg(struct phy *phy,
>> +			  struct ufs_qcom_phy_vreg *vreg, bool on)
>> +{
>> +	int ret =3D 0;
>> +	struct regulator *reg =3D vreg->reg;
>> +	const char *name =3D vreg->name;
>> +	int min_uV;
>> +	int uA_load;
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(phy);
>> +	struct device *dev =3D ufs_qcom_phy->dev;
>> +
>> +	BUG_ON(!vreg);
>> +
>> +	if (regulator_count_voltages(reg) > 0) {
>> +		min_uV =3D on ? vreg->min_uV : 0;
>> +		ret =3D regulator_set_voltage(reg, min_uV, vreg->max_uV);
>> +		if (ret) {
>> +			dev_err(dev, "%s: %s set voltage failed, err=3D%d\n",
>> +					__func__, name, ret);
>> +			goto out;
>> +		}
>> +		uA_load =3D on ? vreg->max_uA : 0;
>> +		ret =3D regulator_set_optimum_mode(reg, uA_load);
>> +		if (ret >=3D 0) {
>> +			/*
>> +			 * regulator_set_optimum_mode() returns new regulator
>> +			 * mode upon success.
>> +			 */
>> +			ret =3D 0;
>> +		} else {
>> +			dev_err(dev, "%s: %s set optimum mode(uA_load=3D%d) failed, err=3D=
%d\n",
>> +					__func__, name, uA_load, ret);
>> +			goto out;
>> +		}
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>> +static
>> +int ufs_qcom_phy_enable_vreg(struct phy *phy,
>> +			     struct ufs_qcom_phy_vreg *vreg)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(phy);
>> +	struct device *dev =3D ufs_qcom_phy->dev;
>> +	int ret =3D 0;
>> +
>> +	if (!vreg || vreg->enabled)
>> +		goto out;
>> +
>> +	ret =3D ufs_qcom_phy_cfg_vreg(phy, vreg, true);
>> +	if (ret) {
>> +		dev_err(dev, "%s: ufs_qcom_phy_cfg_vreg() failed, err=3D%d\n",
>> +			__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	ret =3D regulator_enable(vreg->reg);
>> +	if (ret) {
>> +		dev_err(dev, "%s: enable failed, err=3D%d\n",
>> +				__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	vreg->enabled =3D true;
>> +out:
>> +	return ret;
>> +}
>> +
>> +int ufs_qcom_phy_enable_ref_clk(struct phy *generic_phy)
>> +{
>> +	int ret =3D 0;
>> +	struct ufs_qcom_phy *phy =3D get_ufs_qcom_phy(generic_phy);
>> +
>> +	if (phy->is_ref_clk_enabled)
>> +		goto out;
>> +
>> +	/*
>> +	 * reference clock is propagated in a daisy-chained manner from
>> +	 * source to phy, so ungate them at each stage.
>> +	 */
>> +	ret =3D clk_prepare_enable(phy->ref_clk_src);
>> +	if (ret) {
>> +		dev_err(phy->dev, "%s: ref_clk_src enable failed %d\n",
>> +				__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * "ref_clk_parent" is optional clock hence make sure that clk
>> reference
>> +	 * is available before trying to enable the clock.
>> +	 */
>> +	if (phy->ref_clk_parent) {
>> +		ret =3D clk_prepare_enable(phy->ref_clk_parent);
>> +		if (ret) {
>> +			dev_err(phy->dev, "%s: ref_clk_parent enable failed %d\n",
>> +					__func__, ret);
>> +			goto out_disable_src;
>> +		}
>> +	}
>> +
>> +	ret =3D clk_prepare_enable(phy->ref_clk);
>> +	if (ret) {
>> +		dev_err(phy->dev, "%s: ref_clk enable failed %d\n",
>> +				__func__, ret);
>> +		goto out_disable_parent;
>> +	}
>> +
>> +	phy->is_ref_clk_enabled =3D true;
>> +	goto out;
>> +
>> +out_disable_parent:
>> +	if (phy->ref_clk_parent)
>> +		clk_disable_unprepare(phy->ref_clk_parent);
>> +out_disable_src:
>> +	clk_disable_unprepare(phy->ref_clk_src);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static
>> +int ufs_qcom_phy_disable_vreg(struct phy *phy,
>> +			      struct ufs_qcom_phy_vreg *vreg)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(phy);
>> +	struct device *dev =3D ufs_qcom_phy->dev;
>> +	int ret =3D 0;
>> +
>> +	if (!vreg || !vreg->enabled || vreg->is_always_on)
>> +		goto out;
>> +
>> +	ret =3D regulator_disable(vreg->reg);
>> +
>> +	if (!ret) {
>> +		/* ignore errors on applying disable config */
>> +		ufs_qcom_phy_cfg_vreg(phy, vreg, false);
>> +		vreg->enabled =3D false;
>> +	} else {
>> +		dev_err(dev, "%s: %s disable failed, err=3D%d\n",
>> +				__func__, vreg->name, ret);
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>> +void ufs_qcom_phy_disable_ref_clk(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *phy =3D get_ufs_qcom_phy(generic_phy);
>> +
>> +	if (phy->is_ref_clk_enabled) {
>> +		clk_disable_unprepare(phy->ref_clk);
>> +		/*
>> +		 * "ref_clk_parent" is optional clock hence make sure that clk
>> +		 * reference is available before trying to disable the clock.
>> +		 */
>> +		if (phy->ref_clk_parent)
>> +			clk_disable_unprepare(phy->ref_clk_parent);
>> +		clk_disable_unprepare(phy->ref_clk_src);
>> +		phy->is_ref_clk_enabled =3D false;
>> +	}
>> +}
>> +
>> +#define UFS_REF_CLK_EN	(1 << 5)
>> +
>> +static void ufs_qcom_phy_dev_ref_clk_ctrl(struct phy *generic_phy, =
bool
>> enable)
>> +{
>> +	struct ufs_qcom_phy *phy =3D get_ufs_qcom_phy(generic_phy);
>> +
>> +	if (phy->dev_ref_clk_ctrl_mmio &&
>> +	    (enable ^ phy->is_dev_ref_clk_enabled)) {
>> +		u32 temp =3D readl_relaxed(phy->dev_ref_clk_ctrl_mmio);
>> +
>> +		if (enable)
>> +			temp |=3D UFS_REF_CLK_EN;
>> +		else
>> +			temp &=3D ~UFS_REF_CLK_EN;
>> +
>> +		/*
>> +		 * If we are here to disable this clock immediately after
>> +		 * entering into hibern8, we need to make sure that device
>> +		 * ref_clk is active atleast 1us after the hibern8 enter.
>> +		 */
>> +		if (!enable)
>> +			udelay(1);
>> +
>> +		writel_relaxed(temp, phy->dev_ref_clk_ctrl_mmio);
>> +		/* ensure that ref_clk is enabled/disabled before we return */
>> +		wmb();
>> +		/*
>> +		 * If we call hibern8 exit after this, we need to make sure that
>> +		 * device ref_clk is stable for atleast 1us before the hibern8
>> +		 * exit command.
>> +		 */
>> +		if (enable)
>> +			udelay(1);
>> +
>> +		phy->is_dev_ref_clk_enabled =3D enable;
>> +	}
>> +}
>> +
>> +void ufs_qcom_phy_enable_dev_ref_clk(struct phy *generic_phy)
>> +{
>> +	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, true);
>> +}
>> +
>> +void ufs_qcom_phy_disable_dev_ref_clk(struct phy *generic_phy)
>> +{
>> +	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, false);
>> +}
>> +
>> +/* Turn ON M-PHY RMMI interface clocks */
>> +int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *phy =3D get_ufs_qcom_phy(generic_phy);
>> +	int ret =3D 0;
>> +
>> +	if (phy->is_iface_clk_enabled)
>> +		goto out;
>> +
>> +	ret =3D clk_prepare_enable(phy->tx_iface_clk);
>> +	if (ret) {
>> +		dev_err(phy->dev, "%s: tx_iface_clk enable failed %d\n",
>> +				__func__, ret);
>> +		goto out;
>> +	}
>> +	ret =3D clk_prepare_enable(phy->rx_iface_clk);
>> +	if (ret) {
>> +		clk_disable_unprepare(phy->tx_iface_clk);
>> +		dev_err(phy->dev, "%s: rx_iface_clk enable failed %d. disabling a=
lso
>> tx_iface_clk\n",
>> +				__func__, ret);
>> +		goto out;
>> +	}
>> +	phy->is_iface_clk_enabled =3D true;
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +/* Turn OFF M-PHY RMMI interface clocks */
>> +void ufs_qcom_phy_disable_iface_clk(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *phy =3D get_ufs_qcom_phy(generic_phy);
>> +
>> +	if (phy->is_iface_clk_enabled) {
>> +		clk_disable_unprepare(phy->tx_iface_clk);
>> +		clk_disable_unprepare(phy->rx_iface_clk);
>> +		phy->is_iface_clk_enabled =3D false;
>> +	}
>> +}
>> +
>> +int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +	int ret =3D 0;
>> +
>> +	if (!ufs_qcom_phy->phy_spec_ops->start_serdes) {
>> +		dev_err(ufs_qcom_phy->dev, "%s: start_serdes() callback is not
>> supported\n",
>> +			__func__);
>> +		ret =3D -ENOTSUPP;
>> +	} else {
>> +		ufs_qcom_phy->phy_spec_ops->start_serdes(ufs_qcom_phy);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32
>> tx_lanes)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +	int ret =3D 0;
>> +
>> +	if (!ufs_qcom_phy->phy_spec_ops->set_tx_lane_enable) {
>> +		dev_err(ufs_qcom_phy->dev, "%s: set_tx_lane_enable() callback is =
not
>> supported\n",
>> +			__func__);
>> +		ret =3D -ENOTSUPP;
>> +	} else {
>> +		ufs_qcom_phy->phy_spec_ops->set_tx_lane_enable(ufs_qcom_phy,
>> +							       tx_lanes);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
>> +					  u8 major, u16 minor, u16 step)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +
>> +	ufs_qcom_phy->host_ctrl_rev_major =3D major;
>> +	ufs_qcom_phy->host_ctrl_rev_minor =3D minor;
>> +	ufs_qcom_phy->host_ctrl_rev_step =3D step;
>> +}
>> +
>> +int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rat=
e_B)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +	int ret =3D 0;
>> +
>> +	if (!ufs_qcom_phy->phy_spec_ops->calibrate_phy) {
>> +		dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy() callback is not
>> supported\n",
>> +			__func__);
>> +		ret =3D -ENOTSUPP;
>> +	} else {
>> +		ret =3D ufs_qcom_phy->phy_spec_ops->
>> +				calibrate_phy(ufs_qcom_phy, is_rate_B);
>> +		if (ret)
>> +			dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy() failed %d\n",
>> +				__func__, ret);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int ufs_qcom_phy_remove(struct phy *generic_phy,
>> +			struct ufs_qcom_phy *ufs_qcom_phy)
>> +{
>> +	phy_power_off(generic_phy);
>> +
>> +	kfree(ufs_qcom_phy->vdda_pll.name);
>> +	kfree(ufs_qcom_phy->vdda_phy.name);
>> +
>> +	return 0;
>> +}
>> +
>> +int ufs_qcom_phy_exit(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +
>> +	if (ufs_qcom_phy->is_powered_on)
>> +		phy_power_off(generic_phy);
>> +
>> +	return 0;
>> +}
>> +
>> +int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *ufs_qcom_phy =3D get_ufs_qcom_phy(generic_phy=
);
>> +
>> +	if (!ufs_qcom_phy->phy_spec_ops->is_physical_coding_sublayer_ready=
) {
>> +		dev_err(ufs_qcom_phy->dev, "%s: is_physical_coding_sublayer_ready=
()
>> callback is not supported\n",
>> +			__func__);
>> +		return -ENOTSUPP;
>> +	}
>> +
>> +	return ufs_qcom_phy->phy_spec_ops->
>> +			is_physical_coding_sublayer_ready(ufs_qcom_phy);
>> +}
>> +
>> +int ufs_qcom_phy_power_on(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *phy_common =3D get_ufs_qcom_phy(generic_phy);
>> +	struct device *dev =3D phy_common->dev;
>> +	int err;
>> +
>> +	err =3D ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_ph=
y);
>> +	if (err) {
>> +		dev_err(dev, "%s enable vdda_phy failed, err=3D%d\n",
>> +			__func__, err);
>> +		goto out;
>> +	}
>> +
>> +	phy_common->phy_spec_ops->power_control(phy_common, true);
>> +
>> +	/* vdda_pll also enables ref clock LDOs so enable it first */
>> +	err =3D ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_pl=
l);
>> +	if (err) {
>> +		dev_err(dev, "%s enable vdda_pll failed, err=3D%d\n",
>> +			__func__, err);
>> +		goto out_disable_phy;
>> +	}
>> +
>> +	err =3D ufs_qcom_phy_enable_ref_clk(generic_phy);
>> +	if (err) {
>> +		dev_err(dev, "%s enable phy ref clock failed, err=3D%d\n",
>> +			__func__, err);
>> +		goto out_disable_pll;
>> +	}
>> +
>> +	/* enable device PHY ref_clk pad rail */
>> +	if (phy_common->vddp_ref_clk.reg) {
>> +		err =3D ufs_qcom_phy_enable_vreg(generic_phy,
>> +					       &phy_common->vddp_ref_clk);
>> +		if (err) {
>> +			dev_err(dev, "%s enable vddp_ref_clk failed, err=3D%d\n",
>> +				__func__, err);
>> +			goto out_disable_ref_clk;
>> +		}
>> +	}
>> +
>> +	phy_common->is_powered_on =3D true;
>> +	goto out;
>> +
>> +out_disable_ref_clk:
>> +	ufs_qcom_phy_disable_ref_clk(generic_phy);
>> +out_disable_pll:
>> +	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
>> +out_disable_phy:
>> +	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
>> +out:
>> +	return err;
>> +}
>> +
>> +int ufs_qcom_phy_power_off(struct phy *generic_phy)
>> +{
>> +	struct ufs_qcom_phy *phy_common =3D get_ufs_qcom_phy(generic_phy);
>> +
>> +	phy_common->phy_spec_ops->power_control(phy_common, false);
>> +
>> +	if (phy_common->vddp_ref_clk.reg)
>> +		ufs_qcom_phy_disable_vreg(generic_phy,
>> +					  &phy_common->vddp_ref_clk);
>> +	ufs_qcom_phy_disable_ref_clk(generic_phy);
>> +
>> +	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
>> +	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
>> +	phy_common->is_powered_on =3D false;
>> +
>> +	return 0;
>> +}
>> diff --git a/include/linux/phy/phy-qcom-ufs.h
>> b/include/linux/phy/phy-qcom-ufs.h
>> new file mode 100644
>> index 0000000..5feb1c9
>> --- /dev/null
>> +++ b/include/linux/phy/phy-qcom-ufs.h
>> @@ -0,0 +1,33 @@
>> +/*
>> + * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2 a=
nd
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#ifndef PHY_QCOM_UFS_H_
>> +#define PHY_QCOM_UFS_H_
>> +
>> +#include "phy.h"
>> +
>> +int ufs_qcom_phy_enable_ref_clk(struct phy *phy);
>> +void ufs_qcom_phy_disable_ref_clk(struct phy *phy);
>
> what=92s the difference here between the two above and below?  Might =
be
> useful for all of these functions to have DocBook style comments.
>

done


>> +void ufs_qcom_phy_enable_dev_ref_clk(struct phy *);
>> +void ufs_qcom_phy_disable_dev_ref_clk(struct phy *);
>
> Can we be consistent for readability and have these be:
> void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
> void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
>

done

>> +int ufs_qcom_phy_enable_iface_clk(struct phy *phy);
>> +void ufs_qcom_phy_disable_iface_clk(struct phy *phy);
>> +int ufs_qcom_phy_start_serdes(struct phy *generic_phy);
>> +int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32
>> tx_lanes);
>> +int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool
>> is_rate_B);
>> +int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy);
>> +void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
>> +			u8 major, u16 minor, u16 step);
>
> similar comment as above, can we make generic_phy just phy to match.
>

done

> As there isn=92t a matching =91restore=92 to
> ufs_qcom_phy_save_controller_version.  Is this really
> ufs_qcom_phy_set_controller_version instead?
>

controller version can only be read from the controller registers.
the version can not be modifies obviously.
so if we use "save" (into SW structure) we wont have the "restore".
if we use "read" we won't have the "write"
and if we use "get" we wont have the "set",
so i guess save it is just as good as any other. do you agree ?


>> +
>> +#endif /* PHY_QCOM_UFS_H_ */
>> --
>> 1.8.2.1
>>
>> --
>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
>> member of Code Aurora Forum, hosted by The Linux Foundation
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-arm-=
msm"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora F=
orum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
