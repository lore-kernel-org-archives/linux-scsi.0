From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/3] arm64: dts: hisilicon: hi3670: Add UFS controller support
Date: Fri,  7 Dec 2018 23:21:50 +0530
Message-ID: <20181207175151.8969-3-manivannan.sadhasivam@linaro.org>
References: <20181207175151.8969-1-manivannan.sadhasivam@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207175151.8969-1-manivannan.sadhasivam@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, liwei213@huawei.com, robh+dt@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, john.stultz@linaro.org, amit.kucheria@linaro.org, guodong.xu@linaro.org, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Add UFS controller support for HiSilicon HI3670 SoC.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/hisilicon/hi3670.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
index 6ccdf5040ffd..285219dd657f 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
@@ -654,6 +654,24 @@
 			clock-names = "apb_pclk";
 		};
 
+		/* UFS */
+		ufs: ufs@ff3c0000 {
+			compatible = "hisilicon,hi3670-ufs", "jedec,ufs-2.1";
+			/* 0: HCI standard */
+			/* 1: UFS SYS CTRL */
+			reg = <0x0 0xff3c0000 0x0 0x1000>,
+				<0x0 0xff3e0000 0x0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&crg_ctrl HI3670_CLK_GATE_UFSIO_REF>,
+				<&crg_ctrl HI3670_CLK_GATE_UFS_SUBSYS>;
+			clock-names = "ref_clk", "phy_clk";
+			freq-table-hz = <0 0>, <0 0>;
+			/* offset: 0x84; bit: 12 */
+			resets = <&crg_rst 0x84 12>;
+			reset-names = "rst";
+		};
+
 		/* SD */
 		dwmmc1: dwmmc1@ff37f000 {
 			compatible = "hisilicon,hi3670-dw-mshc";
-- 
2.17.1
