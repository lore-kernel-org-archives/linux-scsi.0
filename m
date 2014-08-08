From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v6 2/2] arm64: Remove the clock and PHY reference from the APM X-Gene SoC AHCI SATA Host controller dts node.
Date: Fri,  8 Aug 2014 21:44:26 +0530
Message-ID: <1407514466-25312-3-git-send-email-stripathi@apm.com>
References: <1407514466-25312-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407514466-25312-1-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch removes all clocks and PHY references from the APM X-Gene
SoC AHCI SATA host controller and PHY DTS nodes. The clock and PHY
are no longer needed as they are handled by the firmware. By removing
only the reference is not enough as any un-used clock entry will get
disabled by the clock framework. This patch also updates the APM X-Gene
SOC AHCI SATA Host controller clock and PHY bindings as optional
properties.

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 .../devicetree/bindings/ata/apm-xgene.txt          | 10 +--
 arch/arm64/boot/dts/apm-storm.dtsi                 | 93 ----------------------
 2 files changed, 5 insertions(+), 98 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
index a668f0e..4cd32c2 100644
--- a/Documentation/devicetree/bindings/ata/apm-xgene.txt
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -17,16 +17,16 @@ Required properties:
 			  5th optional memory resource shall be the host
 			  controller MUX memory resource if required.
 - interrupts		: Interrupt-specifier for SATA host controller IRQ.
-- clocks		: Reference to the clock entry.
-- phys			: A list of phandles + phy-specifiers, one for each
-			  entry in phy-names.
-- phy-names		: Should contain:
-  * "sata-phy" for the SATA 6.0Gbps PHY

 Optional properties:
 - dma-coherent		: Present if dma operations are coherent
 - status		: Shall be "ok" if enabled or "disabled" if disabled.
 			  Default is "ok".
+- clocks		: Reference to the clock entry.
+- phys			: A list of phandles + phy-specifiers, one for each
+			  entry in phy-names.
+- phy-names		: Should contain:
+  * "sata-phy" for the SATA 6.0Gbps PHY

 Example:
 		sataclk: sataclk {
diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 40aa96c..4a56bcf 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -177,87 +177,6 @@
 				clock-output-names = "eth8clk";
 			};

-			sataphy1clk: sataphy1clk@1f21c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f21c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sataphy1clk";
-				status = "disabled";
-				csr-offset = <0x4>;
-				csr-mask = <0x00>;
-				enable-offset = <0x0>;
-				enable-mask = <0x06>;
-			};
-
-			sataphy2clk: sataphy1clk@1f22c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f22c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sataphy2clk";
-				status = "ok";
-				csr-offset = <0x4>;
-				csr-mask = <0x3a>;
-				enable-offset = <0x0>;
-				enable-mask = <0x06>;
-			};
-
-			sataphy3clk: sataphy1clk@1f23c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f23c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sataphy3clk";
-				status = "ok";
-				csr-offset = <0x4>;
-				csr-mask = <0x3a>;
-				enable-offset = <0x0>;
-				enable-mask = <0x06>;
-			};
-
-			sata01clk: sata01clk@1f21c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f21c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sata01clk";
-				csr-offset = <0x4>;
-				csr-mask = <0x05>;
-				enable-offset = <0x0>;
-				enable-mask = <0x39>;
-			};
-
-			sata23clk: sata23clk@1f22c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f22c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sata23clk";
-				csr-offset = <0x4>;
-				csr-mask = <0x05>;
-				enable-offset = <0x0>;
-				enable-mask = <0x39>;
-			};
-
-			sata45clk: sata45clk@1f23c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f23c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sata45clk";
-				csr-offset = <0x4>;
-				csr-mask = <0x05>;
-				enable-offset = <0x0>;
-				enable-mask = <0x39>;
-			};
-
 			rtcclk: rtcclk@17000000 {
 				compatible = "apm,xgene-device-clock";
 				#clock-cells = <1>;
@@ -320,7 +239,6 @@
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f21a000 0x0 0x100>;
 			#phy-cells = <1>;
-			clocks = <&sataphy1clk 0>;
 			status = "disabled";
 			apm,tx-boost-gain = <30 30 30 30 30 30>;
 			apm,tx-eye-tuning = <2 10 10 2 10 10>;
@@ -330,7 +248,6 @@
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f22a000 0x0 0x100>;
 			#phy-cells = <1>;
-			clocks = <&sataphy2clk 0>;
 			status = "ok";
 			apm,tx-boost-gain = <30 30 30 30 30 30>;
 			apm,tx-eye-tuning = <1 10 10 2 10 10>;
@@ -340,7 +257,6 @@
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f23a000 0x0 0x100>;
 			#phy-cells = <1>;
-			clocks = <&sataphy3clk 0>;
 			status = "ok";
 			apm,tx-boost-gain = <31 31 31 31 31 31>;
 			apm,tx-eye-tuning = <2 10 10 2 10 10>;
@@ -356,9 +272,6 @@
 			interrupts = <0x0 0x86 0x4>;
 			dma-coherent;
 			status = "disabled";
-			clocks = <&sata01clk 0>;
-			phys = <&phy1 0>;
-			phy-names = "sata-phy";
 		};

 		sata2: sata@1a400000 {
@@ -371,9 +284,6 @@
 			interrupts = <0x0 0x87 0x4>;
 			dma-coherent;
 			status = "ok";
-			clocks = <&sata23clk 0>;
-			phys = <&phy2 0>;
-			phy-names = "sata-phy";
 		};

 		sata3: sata@1a800000 {
@@ -385,9 +295,6 @@
 			interrupts = <0x0 0x88 0x4>;
 			dma-coherent;
 			status = "ok";
-			clocks = <&sata45clk 0>;
-			phys = <&phy3 0>;
-			phy-names = "sata-phy";
 		};

 		rtc: rtc@10510000 {
--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
