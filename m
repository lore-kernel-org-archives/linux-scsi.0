From: Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: [PATCH v2 3/5] arm64: dts: Add ufs dts node
Date: Fri, 16 Jun 2017 14:51:17 +0800
Message-ID: <20170616065119.10704-4-butao@hisilicon.com>
References: <20170616065119.10704-1-butao@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616065119.10704-1-butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org, riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: guodong.xu-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, suzhuangluan-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, kongfei-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

arm64: dts: add ufs node for hi3660

Signed-off-by: Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
---
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts |  9 +++++++++
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi         | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
index 186251ffc6b2..5dbe642f3c66 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
@@ -32,3 +32,12 @@
 &uart5 {
 	status = "okay";
 };
+
+&ufs {
+	ufs-hi3660-use-rate-B;
+	ufs-hi3660-broken-fastauto;
+	ufs-hi3660-use-HS-GEAR3;
+	ufs-hi3660-broken-clk-gate-bypass;
+	reset-gpio = <&gpio18 1 0>;
+	status = "okay";
+}
diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index 3983086bd67b..e688fdb0a939 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -141,6 +141,25 @@
 		#size-cells = <2>;
 		ranges;
 
+		ufs: ufs@ff3b0000 {
+			compatible = "jedec,ufs-1.1", "hisilicon,hi3660-ufs";
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
+
 		fixed_uart5: fixed_19_2M {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-- 
2.11.GIT

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
