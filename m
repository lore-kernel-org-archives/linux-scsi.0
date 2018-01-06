From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v7 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Sat, 6 Jan 2018 17:51:14 +0800
Message-ID: <20180106095117.67907-3-liwei213@huawei.com>
References: <20180106095117.67907-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180106095117.67907-1-liwei213@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: fengbaopeng@hisilicon.com, zhangfei.gao@linaro.org, gengjianfeng@hisilicon.com, zangleigang@hisilicon.com, guodong.xu@linaro.org
List-Id: linux-scsi@vger.kernel.org

add ufs node document for Hisilicon.

Signed-off-by: Li Wei <liwei213@huawei.com>
---
 Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt

diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
new file mode 100644
index 000000000000..175693e47d6b
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
@@ -0,0 +1,43 @@
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
+- freq-table-hz		: Array of <min max> operating frequencies stored in the same
+                          order as the clocks property. If this property is not
+			  defined or a value in the array is "0" then it is assumed
+			  that the frequency is set by the parent clock or a
+			  fixed rate clock source.
+- resets            : reset node register, one reset the clk and the other reset the controller
+- reset-names       : describe reset node register
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
+		/* offset: 0x84; bit: 12 */
+		/* offset: 0x84; bit: 7  */
+		resets = <&crg_rst 0x84 12>,
+			<&crg_rst 0x84 7>;
+		reset-names = "rst", "assert";
+	};
-- 
2.15.0
