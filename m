From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 11/13] Documentation: devicetree: ufs: Add DT bindings for
 exynos UFS host controller
Date: Thu, 01 Oct 2015 13:39:28 +0530
Message-ID: <1443686970-28104-12-git-send-email-alim.akhtar@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../devicetree/bindings/ufs/ufs-exynos.txt         |   93 ++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt

diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
new file mode 100644
index 0000000..00df72e
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
@@ -0,0 +1,93 @@
+* Exynos Universal Flash Storage (UFS) Host Controller
+
+UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible name, contains "samsung,exynos7-ufs"
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+- reg               : <registers mapping>
+
+Optional properties:
+- vdd-hba-supply        : phandle to UFS host controller supply regulator node
+- vcc-supply            : phandle to VCC supply regulator node
+- vccq-supply           : phandle to VCCQ supply regulator node
+- vccq2-supply          : phandle to VCCQ2 supply regulator node
+- vcc-supply-1p8        : For embedded UFS devices, valid VCC range is 1.7-1.95V
+                          or 2.7-3.6V. This boolean property when set, specifies
+			  to use low voltage range of 1.7-1.95V. Note for external
+			  UFS cards this property is invalid and valid VCC range is
+			  always 2.7-3.6V.
+- vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
+- vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
+- vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply
+- <name>-fixed-regulator : boolean property specifying that <name>-supply is a fixed regulator
+
+- clocks                : List of phandle and clock specifier pairs
+- clock-names           : List of clock input name strings sorted in the same
+                          order as the clocks property.
+- freq-table-hz		: Array of <min max> operating frequencies stored in the same
+                          order as the clocks property. If this property is not
+			  defined or a value in the array is "0" then it is assumed
+			  that the frequency is set by the parent clock or a
+			  fixed rate clock source.
+- pclk-freq-avail-range : specifies available frequency range(min/max) for APB clock
+- ufs,pwr-attr-mode : specifies mode value for power mode change
+- ufs,pwr-attr-lane : specifies lane count value for power mode change
+- ufs,pwr-attr-gear : specifies gear count value for power mode change
+- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
+- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
+			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
+- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
+			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
+- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
+			      this is a boolean property.
+- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY
+- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
+- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
+- ufs-pa-tacctivate : specifies time wake-up remote M-RX
+- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state
+
+Note: If above properties are not defined it can be assumed that the supply
+regulators or clocks are always on.
+
+Example:
+	ufshc@0x15570000 {
+		compatible = "samsung,exynos7-ufs";
+		reg = <0xfc598000 0x800>;
+		reg = <0x15570000 0x100>,
+		      <0x15570100 0x100>,
+		      <0x15571000 0x200>,
+		      <0x15572000 0x300>;
+		reg-names = "hci", "vs_hci", "unipro", "ufsp";
+		interrupts = <0 200 0>;
+
+		vdd-hba-supply = <&xxx_reg0>;
+		vdd-hba-fixed-regulator;
+		vcc-supply = <&xxx_reg1>;
+		vcc-supply-1p8;
+		vccq-supply = <&xxx_reg2>;
+		vccq2-supply = <&xxx_reg3>;
+		vcc-max-microamp = 500000;
+		vccq-max-microamp = 200000;
+		vccq2-max-microamp = 200000;
+
+		clocks = <&core 0>, <&ref 0>, <&iface 0>;
+		clock-names = "core_clk", "ref_clk", "iface_clk";
+		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
+
+		pclk-freq-avail-range = <70000000 133000000>;
+
+		ufs,pwr-attr-mode = "FAST";
+		ufs,pwr-attr-lane = /bits/ 8 <2>;
+		ufs,pwr-attr-gear = /bits/ 8 <2>;
+		ufs,pwr-attr-hs-series = "HS_rate_b";
+		ufs,pwr-local-l2-timer = <8000 28000 20000>;
+		ufs,pwr-remote-l2-timer = <12000 32000 16000>;
+		ufs-rx-adv-fine-gran-sup_en = <1>;
+		ufs-rx-adv-fine-gran-step = <3>;
+		ufs-rx-adv-min-activate-time-cap = <10>;
+		ufs-pa-granularity = <6>;
+		ufs-pa-tacctivate = <6>;
+		ufs-pa-hibern8time = <20>;
+	};
-- 
1.7.10.4
