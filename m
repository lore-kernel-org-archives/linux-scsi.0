From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v11 3/4] arm64: dts: add ufs dts node
Date: Mon, 2 Jul 2018 17:35:46 +0800
Message-ID: <20180702093547.39507-4-liwei213@huawei.com>
References: <20180702093547.39507-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180702093547.39507-1-liwei213@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: sunzhaosheng@hisilicon.com, guodong.xu@linaro.org, puck.chen@hisilicon.com, gengjianfeng@hisilicon.com, zangleigang@hisilicon.com, fengbaopeng@hisilicon.com, john.stultz@linaro.org, liwei213@huawei.com, ian.rickards@arm.com
List-Id: linux-scsi@vger.kernel.org

arm64: dts: add ufs node for Hisilicon.

Signed-off-by: Li Wei <liwei213@huawei.com>

---
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index 8d477dcbfa58..851190a719ea 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -1000,6 +1000,24 @@
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
