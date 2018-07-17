From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v11 2/4] [RESEND] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Tue, 17 Jul 2018 17:36:57 +0800
Message-ID: <20180717093659.103263-3-liwei213@huawei.com>
References: <20180717093659.103263-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717093659.103263-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, sunzhaosheng@hisilicon.com, ian.rickards@arm.com, guodong.xu@linaro.org, puck.chen@hisilicon.com, john.stultz@linaro.org, liwei213@huawei.com, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

add ufs node document for Hisilicon.

Signed-off-by: Li Wei <liwei213@huawei.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Tested-by: John Stultz <john.stultz@linaro.org>
---
 Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 41 ++++++++++++++++++++++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 ++++--
 2 files changed, 48 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt

diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
new file mode 100644
index 000000000000..a48c44817367
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
@@ -0,0 +1,41 @@
+* Hisilicon Universal Flash Storage (UFS) Host Controller
+
+UFS nodes are defined to describe on-chip UFS hardware macro.
+Each UFS Host Controller should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains one of the following -
+					"hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
+					host controller present on Hi36xx chipset.
+- reg               : should contain UFS register address space & UFS SYS CTRL register address,
+- interrupt-parent  : interrupt device
+- interrupts        : interrupt number
+- clocks	        : List of phandle and clock specifier pairs
+- clock-names       : List of clock input name strings sorted in the same
+					order as the clocks property. "ref_clk", "phy_clk" is optional
+- freq-table-hz     : Array of <min max> operating frequencies stored in the same
+                      order as the clocks property. If this property is not
+                      defined or a value in the array is "0" then it is assumed
+                      that the frequency is set by the parent clock or a
+                      fixed rate clock source.
+- resets            : describe reset node register
+- reset-names       : reset node register, the "rst" corresponds to reset the whole UFS IP.
+
+Example:
+
+	ufs: ufs@ff3b0000 {
+		compatible = "hisilicon,hi3660-ufs", "jedec,ufs-1.1";
+		/* 0: HCI standard */
+		/* 1: UFS SYS CTRL */
+		reg = <0x0 0xff3b0000 0x0 0x1000>,
+			<0x0 0xff3b1000 0x0 0x1000>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
+			<&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
+		clock-names = "ref_clk", "phy_clk";
+		freq-table-hz = <0 0>, <0 0>;
+		/* offset: 0x84; bit: 12  */
+		resets = <&crg_rst 0x84 12>;
+		reset-names = "rst";
+	};
diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index c39dfef76a18..2df00524bd21 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -41,6 +41,8 @@ Optional properties:
 -lanes-per-direction	: number of lanes available per direction - either 1 or 2.
 			  Note that it is assume same number of lanes is used both
 			  directions at once. If not specified, default is 2 lanes per direction.
+- resets            : reset node register
+- reset-names       : describe reset node register, the "rst" corresponds to reset the whole UFS IP.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
@@ -61,9 +63,11 @@ Example:
 		vccq-max-microamp = 200000;
 		vccq2-max-microamp = 200000;
 
-		clocks = <&core 0>, <&ref 0>, <&iface 0>;
-		clock-names = "core_clk", "ref_clk", "iface_clk";
-		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
+		clocks = <&core 0>, <&ref 0>, <&phy 0>, <&iface 0>;
+		clock-names = "core_clk", "ref_clk", "phy_clk", "iface_clk";
+		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>, <0 0>;
+		resets = <&reset 0 1>;
+		reset-names = "rst";
 		phys = <&ufsphy1>;
 		phy-names = "ufsphy";
 	};
-- 
2.15.0
