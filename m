From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v3 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Tue, 29 Aug 2017 16:41:13 +0800
Message-ID: <20170829084116.106695-3-liwei213@huawei.com>
References: <20170829084116.106695-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170829084116.106695-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: guodong.xu@linaro.org, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

add ufs node document for Hisilicon

Signed-off-by: Li Wei <liwei213@huawei.com>
---
 Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt

diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
new file mode 100644
index 000000000000..cfc84c821d50
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
@@ -0,0 +1,35 @@
+* Hisilicon Universal Flash Storage (UFS) Host Controller
+
+UFS nodes are defined to describe on-chip UFS hardware macro.
+Each UFS Host Controller should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains one of the following -
+			"hisilicon,hi3660-ufs" for hisi ufs host controller
+			 present on Hi3660 chipset.
+- reg               : should contain UFS register address space & UFS SYS CTRL register address,
+- interrupt-parent  : interrupt device
+- interrupts        : interrupt number
+- clocks	        : List of phandle and clock specifier pairs
+- clock-names       : List of clock input name strings sorted in the same
+		      order as the clocks property. "clk_ref", "clk_phy" is optional
+
+Optional properties for board device:
+- reset-gpio			: specifies to reset devices
+
+Example:
+
+	ufs: ufs@ff3b0000 {
+		compatible = "jedec,ufs-1.1", "hisilicon,hi3660-ufs";
+		/* 0: HCI standard */
+		/* 1: UFS SYS CTRL */
+		reg = <0x0 0xff3b0000 0x0 0x1000>,
+			<0x0 0xff3b1000 0x0 0x1000>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
+			<&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
+		clock-names = "clk_ref", "clk_phy";
+		freq-table-hz = <0 0>, <0 0>;
+		reset-gpio = <&gpio18 1 0>;
+	}
-- 
2.11.0
