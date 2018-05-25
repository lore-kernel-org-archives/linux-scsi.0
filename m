From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v10 3/5] arm64: dts: add ufs dts node
Date: Fri, 25 May 2018 17:17:10 +0800
Message-ID: <20180525091712.37227-4-liwei213@huawei.com>
References: <20180525091712.37227-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180525091712.37227-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, guodong.xu@linaro.org, puck.chen@hisilicon.com, john.stultz@linaro.org, liwei213@huawei.com, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

arm64: dts: add ufs node for Hisilicon.

Signed-off-by: Li Wei <liwei213@huawei.com>
---
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index ec3eb8e33a3a..04438621c6c3 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -892,6 +892,24 @@
 			reset-gpios = <&gpio11 1 0 >;
 		};
 
+		/* UFS */
+		ufs: ufs@ff3b0000 {
+			compatible = "hisilicon,hi3660-ufs", "jedec,ufs-1.1";
+			/* 0: HCI standard */
+			/* 1: UFS SYS CTRL */
+			reg = <0x0 0xff3b0000 0x0 0x1000>,
+				<0x0 0xff3b1000 0x0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
+				<&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
+			clock-names = "ref_clk", "phy_clk";
+			freq-table-hz = <0 0>, <0 0>;
+			/* offset: 0x84; bit: 12 */
+			resets = <&crg_rst 0x84 12>;
+			reset-names = "rst";
+		};
+
 		/* SD */
 		dwmmc1: dwmmc1@ff37f000 {
 			#address-cells = <1>;
-- 
2.15.0
