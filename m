From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 2/2] PHY: Add Gen1/Gen2 support for the APM SoC X-Gene SATA PHY driver
Date: Fri, 18 Apr 2014 23:33:17 +0530
Message-ID: <1397844197-13356-3-git-send-email-stripathi@apm.com>
References: <1397844197-13356-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:59609 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754603AbaDRTEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2014 15:04:37 -0400
In-Reply-To: <1397844197-13356-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, tj@kernel.org
Cc: olof@lixom.net, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch adds the necessary PHY code to support SATA Gen1/Gen2 for
the APM X-Gene SoC PHY driver.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/phy/phy-xgene.c | 90 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 13 deletions(-)

diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
index 4aa1ccd..36e1d99 100644
--- a/drivers/phy/phy-xgene.c
+++ b/drivers/phy/phy-xgene.c
@@ -48,7 +48,7 @@
  * at 0x1f23a000 (SATA Port 4/5). For such PHY, another resource is required
  * to located the SDS/Ref PLL CMU module and its clock for that IP enabled.
  *
- * Currently, this driver only supports Gen3 SATA mode with external clock.
+ * This driver supports Gen3/Gen2/Gen1 SATA mode with external clock.
  */
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -76,10 +76,6 @@
 #define DEFAULT_SATA_TXCN2		{ 0x0, 0x0, 0x0 }
 #define DEFAULT_SATA_TXCP1		{ 0xa, 0xa, 0xa }

-#define SATA_SPD_SEL_GEN3		0x7
-#define SATA_SPD_SEL_GEN2		0x3
-#define SATA_SPD_SEL_GEN1		0x1
-
 #define SSC_DISABLE			0
 #define SSC_ENABLE			1

@@ -331,6 +327,14 @@
 		(((dst) & ~0x00000040) | (((u32) (src) << 6) & 0x00000040))
 #define  RXTX_REG7_RX_WORD_MODE_SET(dst, src) \
 		(((dst) & ~0x00003800) | (((u32) (src) << 11) & 0x00003800))
+#define  RXTX_REG7_RX_DATA_RATE_RD(src)	((0x00000600 & (u32) (src)) >> 9)
+#define  RXTX_REG7_RESETB_RXD_SET(dst, src) \
+		(((dst) & ~0x00000100) | (((u32) (src) << 8) & 0x00000100))
+#define  RXTX_REG7_RESETB_RXA_SET(dst, src) \
+		(((dst) & ~0x00000080) | (((u32) (src) << 7) & 0x00000080))
+#define  RXTX_REG7_LOOP_BACK_ENA_CTLE_MASK	0x00004000
+#define  RXTX_REG7_LOOP_BACK_ENA_CTLE_SET(dst, src) \
+		(((dst) & ~0x00004000) | (((u32) (src) << 14) & 0x00004000))
 #define RXTX_REG8			0x010
 #define  RXTX_REG8_CDR_LOOP_ENA_SET(dst, src) \
 		(((dst) & ~0x00004000) | (((u32) (src) << 14) & 0x00004000))
@@ -342,14 +346,6 @@
 		(((dst) & ~0x000000f0) | (((u32) (src) << 4) & 0x000000f0))
 #define  RXTX_REG8_SD_DISABLE_SET(dst, src) \
 		(((dst) & ~0x00000100) | (((u32) (src) << 8) & 0x00000100))
-#define RXTX_REG7			0x00e
-#define  RXTX_REG7_RESETB_RXD_SET(dst, src) \
-		(((dst) & ~0x00000100) | (((u32) (src) << 8) & 0x00000100))
-#define  RXTX_REG7_RESETB_RXA_SET(dst, src) \
-		(((dst) & ~0x00000080) | (((u32) (src) << 7) & 0x00000080))
-#define  RXTX_REG7_LOOP_BACK_ENA_CTLE_MASK	0x00004000
-#define  RXTX_REG7_LOOP_BACK_ENA_CTLE_SET(dst, src) \
-		(((dst) & ~0x00004000) | (((u32) (src) << 14) & 0x00004000))
 #define RXTX_REG11			0x016
 #define  RXTX_REG11_PHASE_ADJUST_LIMIT_SET(dst, src) \
 		(((dst) & ~0x0000f800) | (((u32) (src) << 11) & 0x0000f800))
@@ -1615,8 +1611,76 @@ static int xgene_phy_hw_init(struct phy *phy)
 	return 0;
 }

+static void xgene_phy_sata_force_gen(struct xgene_phy_ctx *ctx,
+				     int lane, bool is_gen3)
+{
+	u32 val;
+
+	serdes_rd(ctx, lane, RXTX_REG38, &val);
+	val = RXTX_REG38_CUSTOMER_PINMODE_INV_SET(val, is_gen3 ? 0x0 : 0x400);
+	serdes_wr(ctx, lane, RXTX_REG38, val);
+
+	/* Set boost control value */
+	serdes_rd(ctx, lane, RXTX_REG1, &val);
+	val = RXTX_REG1_RXACVCM_SET(val, 0x7);
+	val = RXTX_REG1_CTLE_EQ_SET(val,
+			            ctx->sata_param.txboostgain[lane * 3 +
+			            ctx->sata_param.speed[lane]]);
+	serdes_wr(ctx, lane, RXTX_REG1, val);
+
+	serdes_rd(ctx, lane, RXTX_REG125, &val);
+	val = RXTX_REG125_PQ_REG_SET(val,
+			             ctx->sata_param.txeyetuning[lane * 3 +
+			             ctx->sata_param.speed[lane]]);
+	serdes_wr(ctx, lane, RXTX_REG125, val);
+
+	serdes_rd(ctx, lane, RXTX_REG61, &val);
+	val = RXTX_REG61_SPD_SEL_CDR_SET(val,
+		ctx->sata_param.txspeed[ctx->sata_param.speed[lane]]);
+ 	serdes_wr(ctx, lane, RXTX_REG61, val);
+}
+
+static int xgene_phy_set_rate(struct phy *phy, int lane, u64 rate)
+{
+	struct xgene_phy_ctx *ctx = phy_get_drvdata(phy);
+	u32 val;
+
+	if (lane >= MAX_LANE)
+		return -EINVAL;
+
+	if (ctx->mode == MODE_SATA) {
+		/*
+		 * Check if the previous rate is same
+		 * as the current link up rate. If so
+		 * skip the operation.
+		 */
+		serdes_rd(ctx, lane, RXTX_REG7, &val);
+		if (2 - (RXTX_REG7_RX_DATA_RATE_RD(val)) ==
+		    ctx->sata_param.speed[lane])
+			return 1;
+
+		switch (rate) {
+		case 1500000000ULL:
+			ctx->sata_param.speed[lane] = 0;
+			xgene_phy_sata_force_gen(ctx, lane, false);
+			break;
+		case 3000000000ULL:
+			ctx->sata_param.speed[lane] = 1;
+			xgene_phy_sata_force_gen(ctx, lane, false);
+			break;
+		default:
+			ctx->sata_param.speed[lane] = 2;
+			xgene_phy_sata_force_gen(ctx, lane, true);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static const struct phy_ops xgene_phy_ops = {
 	.init		= xgene_phy_hw_init,
+	.set_rate	= xgene_phy_set_rate,
 	.owner		= THIS_MODULE,
 };

--
1.8.2.1

