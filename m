From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v4 3/5] arm64: dts: add ufs dts node
Date: Fri, 20 Oct 2017 16:50:43 +0800
Message-ID: <20171020085045.7737-4-liwei213@huawei.com>
References: <20171020085045.7737-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171020085045.7737-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: guodong.xu@linaro.org, liwei213@huawei.com, fengbaopeng@hisilicon.com, lihuan41@hisilicon.com, wangyupeng4@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

arm64: dts: add ufs node for Hisilicon.

Signed-off-by: Li Wei <liwei213@huawei.com>
---
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts |  5 +++++
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi         | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
index fd4705c451e2..457645a2b53f 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
@@ -276,3 +276,8 @@
 		interrupts = <3 IRQ_TYPE_EDGE_RISING>;
 	};
 };
+
+&ufs {
+	reset-gpio = <&gpio18 1 0>;
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index b7a90d632959..a24ab8472347 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -978,5 +978,24 @@
 			clocks = <&crg_ctrl HI3660_OSC32K>;
 			clock-names = "apb_pclk";
 		};
+
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
+			clock-names = "clk_ref", "clk_phy";
+			freq-table-hz = <0 0>, <0 0>;
+			/* offset: 0x84; bit: 12 */
+			/* offset: 0x84; bit: 7  */
+			resets = <&crg_rst 0x84 12>,
+				<&crg_rst 0x84 7>;
+			reset-names = "rst", "assert";
+		};
 	};
 };
-- 
2.11.0
