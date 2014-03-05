From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v13 3/3] arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries
Date: Wed,  5 Mar 2014 15:43:19 -0700
Message-ID: <1394059399-30671-4-git-send-email-lho@apm.com>
References: <1394059399-30671-1-git-send-email-lho@apm.com>
 <1394059399-30671-2-git-send-email-lho@apm.com>
 <1394059399-30671-3-git-send-email-lho@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394059399-30671-3-git-send-email-lho-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kishon-l0cyMroinI0@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds the DTS entries for the APM X-Gene SoC 15Gbps Multi-purpose
PHY driver. The PHY for SATA controller 2 and 3 are enabled by default.

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   75 ++++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index d37d736..c78ddcf 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -176,6 +176,51 @@
 				reg-names = "csr-reg";
 				clock-output-names = "eth8clk";
 			};
+
+			sataphy1clk: sataphy1clk@1f21c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "socplldiv2";
+				reg = <0x0 0x1f21c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sataphy1clk";
+				status = "disabled";
+				csr-offset = <0x4>;
+				csr-mask = <0x00>;
+				enable-offset = <0x0>;
+				enable-mask = <0x06>;
+			};
+
+			sataphy2clk: sataphy1clk@1f22c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "socplldiv2";
+				reg = <0x0 0x1f22c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sataphy2clk";
+				status = "ok";
+				csr-offset = <0x4>;
+				csr-mask = <0x3a>;
+				enable-offset = <0x0>;
+				enable-mask = <0x06>;
+			};
+
+			sataphy3clk: sataphy1clk@1f23c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "socplldiv2";
+				reg = <0x0 0x1f23c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sataphy3clk";
+				status = "ok";
+				csr-offset = <0x4>;
+				csr-mask = <0x3a>;
+				enable-offset = <0x0>;
+				enable-mask = <0x06>;
+			};
 		};
 
 		serial0: serial@1c020000 {
@@ -187,5 +232,35 @@
 			interrupt-parent = <&gic>;
 			interrupts = <0x0 0x4c 0x4>;
 		};
+
+		phy1: phy@1f21a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f21a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy1clk 0>;
+			status = "disabled";
+			apm,tx-boost-gain = <30 30 30 30 30 30>;
+			apm,tx-eye-tuning = <2 10 10 2 10 10>;
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy2clk 0>;
+			status = "ok";
+			apm,tx-boost-gain = <30 30 30 30 30 30>;
+			apm,tx-eye-tuning = <1 10 10 2 10 10>;
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f23a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy3clk 0>;
+			status = "ok";
+			apm,tx-boost-gain = <31 31 31 31 31 31>;
+			apm,tx-eye-tuning = <2 10 10 2 10 10>;
+		};
 	};
 };
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
