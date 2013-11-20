From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 11:37:05 +0000
Message-ID: <20131120113704.GT5914@e106331-lin.cambridge.arm.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
 <1384905197-3566-2-git-send-email-lho@apm.com>
 <1384905197-3566-3-git-send-email-lho@apm.com>
 <1384905197-3566-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36430 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab3KTLh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 06:37:58 -0500
Content-Disposition: inline
In-Reply-To: <1384905197-3566-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: "olof@lixom.net" <olof@lixom.net>, "tj@kernel.org" <tj@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

On Tue, Nov 19, 2013 at 11:53:16PM +0000, Loc Ho wrote:
> This patch adds support for APM X-Gene SoC 6.0Gbps SATA PHY. This is the
> physical layer interface for the corresponding SATA host controller. This
> driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---

As a general note, this patch is very difficult to review.

There are a large number of macros for accessing bits of registers, vast
swathes of register reads and writes which all look very similar, and
while I suspect could be factored out further into more descriptive
helpers I don't know enough about the hardware to even figure out if any
of it is correct as it stands.

Many of the comments provide little to no information, and comments next
to variables seem to be just the variable name with additional spaces.

There are a few inconsistencies in style which are simply jarring (e.g.
randomly jumping between lower case and upper case in prints, using
different loop structures when repeatedly performing an action for
calibration), and preferably would be more uniform.

[...]

> +struct xgene_ahci_phy_ctx {
> +       struct device *dev;
> +       struct phy *phy;
> +       u64 csr_phys;           /* Physical address of PHY CSR base addr */
> +       void *csr_base;         /* PHY CSR base addr */
> +       void *pcie_base;        /* PHY CSR base addr with PCIE clock macro */

Should these not have an __iomem annotation? Elsewhere too...

> +
> +       /* Override Serdes parameters */
> +       u32 speed[MAX_CHANNEL]; /* Index for override parameter per channel */
> +       u32 txspeed[3];         /* Tx speed */
> +       u32 txboostgain[MAX_CHANNEL*3]; /* Tx freq boost and gain control */
> +       u32 txeyetuning[MAX_CHANNEL*3]; /* Tx eye tuning */
> +       u32 txeyedirection[MAX_CHANNEL*3]; /* Tx eye tuning direction */
> +};
> +
> +/* Manual calibration is required for chip that is earlier than A3.
> +   To enable, pass boot argument sata_xgene_phy.manual=1 */
> +static int enable_manual_cal;
> +MODULE_PARM_DESC(manual, "Enable manual calibration (1=enable 0=disable)");
> +module_param_named(manual, enable_manual_cal, int, 0444);
> +
> +static void phy_rd(void *addr, u32 *val)
> +{
> +       *val = readl(addr);
> +#if defined(XGENE_DBG1_CSR)
> +       pr_debug("SATAPHY CSR RD: 0x%p value: 0x%08x\n", addr, *val);

Can you not use dev_dbg here as you do elsehere?

Either that or make your own debug print function, with the ifdefs
hidden in its definition.

[...]

> +static void phy_wr_flush(void *addr, u32 val)
> +{
> +       writel(val, addr);
> +#if defined(XGENE_DBG1_CSR)
> +       pr_debug("SATAPHY CSR WR: 0x%p value: 0x%08x\n", addr, val);
> +#endif
> +       val = readl(addr);      /* Force an barrier */

Nit: s/an barrier/a barrier/g

> +}
> +
> +static void serdes_wr(void *csr_base, u32 indirect_cmd_reg,
> +                     u32 indirect_data_reg, u32 addr, u32 data)
> +{
> +       u32 val;
> +       u32 cmd;
> +
> +       cmd = CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK;
> +       cmd = (addr << 4) | cmd;
> +       phy_wr(csr_base + indirect_data_reg, data);
> +       phy_rd(csr_base + indirect_data_reg, &val); /* Force a barrier */
> +       phy_wr(csr_base + indirect_cmd_reg, cmd);
> +       phy_rd(csr_base + indirect_cmd_reg, &val); /* Force a barrier */
> +       /* Add an barrier - very important please don't remove */
> +       mb();

Why? Either justify this or remove it.

[...]

> +static void serdes_rd(void *csr_base, u32 indirect_cmd_reg,
> +                     u32 indirect_data_reg, u32 addr, u32 *data)
> +{
> +       u32 val;
> +       u32 cmd;
> +
> +       cmd = CFG_IND_RD_CMD_MASK | CFG_IND_CMD_DONE_MASK;
> +       cmd = (addr << 4) | cmd;
> +       phy_wr(csr_base + indirect_cmd_reg, cmd);
> +       phy_rd(csr_base + indirect_cmd_reg, &val); /* Force a barrier */
> +       /* Add an barrier - very important please don't remove */
> +       mb();

Why? Please justify why I shouldn't just remove it.

> +       /* Ignore one read */
> +       phy_rd(csr_base + indirect_cmd_reg, &val);

Why?

[...]

> +static int xgene_phy_cal_rdy_check(void *csr_serdes,
> +                                  void (*serdes_rd) (void *, u32, u32 *),
> +                                  void (*serdes_wr) (void *, u32, u32),
> +                                  void (*serdes_toggle1to0) (void *, u32, u32))
> +{
> +       int loopcount;
> +       u32 val;
> +
> +       if (!enable_manual_cal)
> +               goto skip_manual_cal;
> +
> +       /* TERM CALIBRATION CH0 */
> +       serdes_rd(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR, &val);
> +       val = CMU_REG17_PVT_CODE_R2A_SET(val, 0x12);
> +       val = CMU_REG17_RESERVED_7_SET(val, 0x0);
> +       serdes_wr(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR, val);
> +       serdes_toggle1to0(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR,
> +                       CMU_REG17_PVT_TERM_MAN_ENA_MASK);
> +       /* DOWN CALIBRATION CH0 */
> +       serdes_rd(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR, &val);
> +       val = CMU_REG17_PVT_CODE_R2A_SET(val, 0x26);
> +       val = CMU_REG17_RESERVED_7_SET(val, 0x0);
> +       serdes_wr(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR, val);
> +       serdes_toggle1to0(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG16_ADDR,
> +                       CMU_REG16_PVT_DN_MAN_ENA_MASK);
> +       /* UP CALIBRATION CH0 */
> +       serdes_rd(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR, &val);
> +       val = CMU_REG17_PVT_CODE_R2A_SET(val, 0x28);
> +       val = CMU_REG17_RESERVED_7_SET(val, 0x0);
> +       serdes_wr(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG17_ADDR, val);
> +       serdes_toggle1to0(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG16_ADDR,
> +                       CMU_REG16_PVT_UP_MAN_ENA_MASK);
> +
> +skip_manual_cal:
> +       /* Check PLL calibration for 10ms */
> +       loopcount = 50;
> +       do {
> +               serdes_rd(csr_serdes, KC_CLKMACRO_CMU_REGS_CMU_REG7_ADDR, &val);
> +               if (CMU_REG7_PLL_CALIB_DONE_RD(val))
> +                       return 0;
> +               udelay(200); /* No need to poll faster than 200 us */

Why? Does the hardware take that long to respond? If so, mention that.

> +       } while (!CMU_REG7_PLL_CALIB_DONE_RD(val) && --loopcount > 0);
> +
> +       return -1;

The return value never seems to be used by callers. If this fails, how
bad is it to continue as if this had succeeded?

[...]

> +/* SATA port macro configuration */
> +static int xgene_phy_sata_macro_cfg(struct xgene_ahci_phy_ctx *ctx)
> +{
> +       void *csr_serdes = ctx->csr_base + SATA_SERDES_OFFSET;
> +       int calib_loop_count = 0;
> +       u32 val;
> +
> +       phy_rd(csr_serdes + SATA_ENET_CLK_MACRO_REG_ADDR, &val);
> +       val = I_RESET_B_SET(val, 0x0);
> +       val = I_PLL_FBDIV_SET(val, 0x27);
> +       val = I_CUSTOMEROV_SET(val, 0x0);
> +       phy_wr(csr_serdes + SATA_ENET_CLK_MACRO_REG_ADDR, val);
> +
> +       xgene_phy_macro_cfg(csr_serdes, sds_rd, sds_wr, 1 /* 100MHz ref */);
> +
> +       phy_rd(csr_serdes + SATA_ENET_CLK_MACRO_REG_ADDR, &val);
> +       val = I_RESET_B_SET(val, 0x1);
> +       val = I_CUSTOMEROV_SET(val, 0x0);
> +       phy_wr(csr_serdes + SATA_ENET_CLK_MACRO_REG_ADDR, val);
> +
> +       mb();

Please comment all barriers with a description of why they are
necessary.

> +
> +       while (++calib_loop_count <= 5) {
> +               if (xgene_phy_macro_cal_rdy_chk(ctx) == 0)
> +                       break;
> +               xgene_phy_macro_pdwn_force_vco(ctx);
> +       }

Why 5 times? Does the hardware take some time to respond? I didn't spot
any explicitly delays in the callees.

> +       if (calib_loop_count > 5) {
> +               dev_err(ctx->dev, "Clock macro PLL not ready...\n");
> +               return -1;
> +       }
> +       phy_rd(csr_serdes + SATA_ENET_CLK_MACRO_REG_ADDR, &val);
> +       dev_dbg(ctx->dev, "Clock macro PLL %sLOOKED...\n",

Perhaps "locked"?

> +               O_PLL_LOCK_RD(val) ? "" : "UN");
> +       dev_dbg(ctx->dev, "Clock macro PLL %sREADY...\n",
> +               O_PLL_READY_RD(val) ? "" : "NOT");

Why is part of this in UPPERCASE?

[...]

> +       xgene_phy_macro_cfg(pcie_base, sds_pcie_rd, sds_pcie_wr,
> +                           0 /* 50Mhz clock */);

The fact that you have a comment on each call to xgene_phy_macro_cfg
shows that the prototype can be improved. Take a flags parameter instead
of the ref_100MHz parameter, and have some defines like PHY_CLK_50MHZ
and PHY_CLK_100MHZ. That will make things much clearer.

> +
> +       phy_rd(pcie_base + SM_PCIE_X8_SDS_CSR_REGS_PCIE_CLK_MACRO_REG_ADDR,
> +              &val);
> +       val = PCIE_CLK_MACRO_REG_I_RESET_B_SET(val, 0x1);
> +       val = PCIE_CLK_MACRO_REG_I_CUSTOMEROV_SET(val, 0x0);
> +       phy_wr(pcie_base + SM_PCIE_X8_SDS_CSR_REGS_PCIE_CLK_MACRO_REG_ADDR,
> +              val);
> +
> +       mb();

Why?

> +
> +       /* Check for 5 times */
> +       calib_loop_count = 5;
> +       do {
> +               if (xgene_phy_pcie_macro_cal_rdy_chk(ctx) == 0)
> +                       break;
> +               xgene_phy_pcie_macro_pdwn_force_vco(ctx);
> +       } while (--calib_loop_count > 0);

Why 5 times?

> +       if (calib_loop_count <= 0) {
> +               dev_err(ctx->dev, "Clock macro PLL failed\n");
> +               return -1;
> +       }
> +       phy_rd(pcie_base + SM_PCIE_X8_SDS_CSR_REGS_PCIE_CLK_MACRO_REG_ADDR,
> +              &val);
> +       dev_dbg(ctx->dev, "Clock macro PLL %sLOOKED...\n",
> +                PCIE_CLK_MACRO_REG_O_PLL_LOCK_RD(val) ? "" : "UN");
> +       dev_dbg(ctx->dev, "Clock macro PLL %sREADY...\n",
> +                PCIE_CLK_MACRO_REG_O_PLL_READY_RD(val) ? "" : "NOT ");

Again, why does the sentence suddenly switch to UPPERCASE?

[...]

> +static void xgene_phy_force_lat_summer_cal(struct xgene_ahci_phy_ctx *ctx,
> +                                          int channel)
> +{
> +       void *csr_base = ctx->csr_base + SATA_SERDES_OFFSET;
> +       u32 os = channel * 0x200;
> +       int i;
> +       struct {
> +               u32 reg;
> +               u32 val;
> +       } serdes_reg[] = {
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG38_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG39_ADDR, 0xff00},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG40_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG41_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG42_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG43_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG44_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG45_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG46_ADDR, 0xffff},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG47_ADDR, 0xfffc},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG48_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG49_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG50_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG51_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG52_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG53_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG54_ADDR, 0x0},
> +               {KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG55_ADDR, 0x0},
> +               {0, 0x0},
> +       };
> +
> +       /* SUMMER CALIBRATION CH0/CH1 */
> +       /* SUMMER calib toggle CHX */
> +       sds_toggle1to0(csr_base,
> +                      KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG127_ADDR + os,
> +                      CH0_RXTX_REG127_FORCE_SUM_CAL_START_MASK);
> +       /* latch calib toggle CHX */
> +       sds_toggle1to0(csr_base,
> +                      KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG127_ADDR + os,
> +                      CH0_RXTX_REG127_FORCE_LAT_CAL_START_MASK);
> +       /* CHX */
> +       sds_wr(csr_base, KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG28_ADDR + os, 0x7);
> +       sds_wr(csr_base, KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG31_ADDR + os,
> +              0x7e00);
> +
> +       sds_clrbits(csr_base, KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG4_ADDR + os,
> +                   CH0_RXTX_REG4_TX_LOOPBACK_BUF_EN_MASK);
> +       sds_clrbits(csr_base, KC_SERDES_X2_RXTX_REGS_CH0_RXTX_REG7_ADDR + os,
> +                   CH0_RXTX_REG7_LOOP_BACK_ENA_CTLE_MASK);
> +
> +       /* RXTX_REG38-55 */
> +       for (i = 0; serdes_reg[i].reg != 0; i++)
> +               sds_wr(csr_base, serdes_reg[i].reg + os, serdes_reg[i].val);

As the size is well known in advance,  why not use ARRAY_SIZE rather
than having a terminating element:

for (i = 0; i < ARRAY_SIZE(serdes_reg); i++)
	sds_wr(...);

[...]

> +static void xgene_phy_gen_avg_val(struct xgene_ahci_phy_ctx *ctx, int channel)
> +{
> +       void *csr_serdes_base = ctx->csr_base + SATA_SERDES_OFFSET;
> +       int avg_loop = 10;

What is value meant to mean? How was it derived?

> +       int MAX_LOOP = 10;

Why UPPERCASE?

That violates the principle of least surprise, I'd expect a name in
uppercase to be a #defined value.

[...]

> +                       dev_dbg(ctx->dev, "Interation Value: %d\n", avg_loop);

s/Interation/Iteration/g

Even then, why not just say something like "took %d loops to ${DO
THING}"?

[...]

> +skip_manual_cal:
> +       /* Check for 10 ms */
> +       loopcount = 50;
> +       do {
> +               sds_rd(csr_serdes, KC_SERDES_CMU_REGS_CMU_REG7_ADDR, &val);
> +               if (CMU_REG7_PLL_CALIB_DONE_RD(val))
> +                       break;
> +               udelay(200);    /* No need to poll more than 200 us */

Please comment _why_ there's no need.

> +       } while (--loopcount > 0);
> +
> +       sds_rd(csr_serdes, KC_SERDES_CMU_REGS_CMU_REG7_ADDR, &val);
> +       if (CMU_REG7_PLL_CALIB_DONE_RD(val) == 1)
> +               dev_dbg(ctx->dev, "PLL calibration done\n");
> +       if (CMU_REG7_VCO_CAL_FAIL_RD(val) == 0x0) {
> +               dev_dbg(ctx->dev, "PLL calibration successful\n");
> +       } else {
> +               /* Assert SDS reset and recall calib function */
> +               dev_err(ctx->dev,
> +                       "PLL calibration failed due to VCO failure\n");
> +               return -1;
> +       }
> +
> +       dev_dbg(ctx->dev, "Checking TX ready\n");
> +       sds_rd(csr_serdes, KC_SERDES_CMU_REGS_CMU_REG15_ADDR, &val);
> +       dev_dbg(ctx->dev, "PHY TX is %sready\n", val & 0x300 ? "" : "NOT ");

Now we have MIXED case; why?

[...]

> +       phy_rd(csr_serdes_base + SATA_ENET_SDS_PCS_CTL0_ADDR, &val);
> +       val = REGSPEC_CFG_I_RX_WORDMODE0_SET(val, 0x3);
> +       val = REGSPEC_CFG_I_TX_WORDMODE0_SET(val, 0x3);
> +       phy_wr(csr_serdes_base + SATA_ENET_SDS_PCS_CTL0_ADDR, val);
> +
> +       mb();

Why?

> +
> +       calib_loop_count = 10;
> +       do {
> +               rc = xgene_phy_cal_rdy_chk(ctx);
> +               if (rc == 0)
> +                       break;
> +               xgene_phy_pdwn_force_vco(ctx);
> +       } while (++calib_loop_count > 0);
> +       if (calib_loop_count <= 0) {
> +               dev_err(ctx->dev, "PLL calibration failed\n");
> +               return -ENODEV;
> +       }

This loop and check are broken. Because calib_loop_count is signed,
overflow is undefined behaviour. As calib_loop_count initialised to 10,
and then only incremented, the only was it could become less than zero
is upon overflow.

Perhaps this should be calib_loop_count--, and then a test for
calib_loop_count > 0.

> +static int xgene_ahci_phy_hw_init(struct phy *phy)
> +{
> +       struct xgene_ahci_phy_ctx *ctx = phy_get_drvdata(phy);
> +       int rc;
> +
> +       rc = xgene_phy_init(ctx, SATA_CLK_EXT_DIFF, 0 /* SSC */);

It would be far nicer to make the call tell you everything you need to
know about the arguments, rather than adding comments inside the call.

> +static int xgene_ahci_phy_power_on(struct phy *phy)
> +{
> +       return 0;
> +}
> +
> +static int xgene_ahci_phy_power_off(struct phy *phy)
> +{
> +       return 0;
> +}

I'm not entirely familiar with the PHY framework, but it seems odd to
have these if they do nothing. Are there no regulators / resets / gpios
to poke, registers to reset to sane values?

> +static void xgene_ahci_phy_get_param(struct platform_device *pdev,
> +       const char *name, u32 *buffer, int count, u32 default_val)
> +{
> +       int rc;
> +       int i;
> +       rc = of_property_read_u32_array(pdev->dev.of_node, name, buffer,
> +                                       count);

Why not return here if !rc? Then you don't need to indent the next
statement.

> +       if (rc) {
> +               for (i = 0; i < count; i++)
> +                       buffer[i] = default_val;
> +       }
> +}
> +
> +static int xgene_ahci_phy_probe(struct platform_device *pdev)
> +{
> +       struct phy_provider *phy_provider;
> +       struct xgene_ahci_phy_ctx *ctx;
> +       struct resource *res;
> +       char name[80];
> +       int rc = 0;
> +
> +       if (!of_device_is_available(pdev->dev.of_node))
> +               return -ENODEV;

I was under the impression the standard bus types already checked the
device was available, and would not allocate a device for those which
were not. From a glance at drivers/of/platform.c, it seems this line is
unnecessary.

> +       /* Load override paramaters */
> +       xgene_ahci_phy_get_param(pdev, "txeyetuning", ctx->txeyetuning, 6,
> +                                DEFAULT_TXEYETUNING);
> +       xgene_ahci_phy_get_param(pdev, "txeyedirection", ctx->txeyedirection,
> +                                6, DEFAULT_TXEYEDIRECTION);
> +       xgene_ahci_phy_get_param(pdev, "txboostgain", ctx->txboostgain, 6,
> +                                DEFAULT_TXBOOST_GAIN);
> +       xgene_ahci_phy_get_param(pdev, "txspeed", ctx->txspeed, 3,
> +                                DEFAULT_SPD_SEL);

Further to my comments on the binding, these should probably also be
prefixed with "apm,".

> +       ctx->speed[0] = 2;      /* Default to Gen3 for channel 0 */
> +       ctx->speed[1] = 2;      /* Default to Gen3 for channel 1 */
> +
> +       ctx->dev = &pdev->dev;
> +       platform_set_drvdata(pdev, ctx);
> +
> +       phy_provider = devm_of_phy_provider_register(ctx->dev,
> +                                                    xgene_ahci_phy_xlate);
> +       if (IS_ERR(phy_provider)) {
> +               rc = PTR_ERR(phy_provider);
> +               goto error;
> +       }
> +
> +       sprintf(name, "xgene-ahci-phy-%08X", (u32) ctx->csr_phys);

Why cap this to 32 bits if this going to appear on a 64-bit system?

> +       ctx->phy = devm_phy_create(ctx->dev, (u32) ctx->csr_phys,
> +                                  &xgene_phy_ops, name);

Likewise, this looks odd.

Thanks,
Mark.
