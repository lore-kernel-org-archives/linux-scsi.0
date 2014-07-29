From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v4 2/4] arm64: Remove the clock and PHY reference from the APM X-Gene SoC AHCI SATA Host controller dts node.
Date: Tue, 29 Jul 2014 12:24:50 +0530
Message-ID: <1406616892-30273-3-git-send-email-stripathi@apm.com>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:52623 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752759AbaG2Gzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 02:55:54 -0400
In-Reply-To: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch removes all clocks and PHY references from the APM X-Gene
SoC AHCI SATA host controller and PHY DTS nodes. The clock and PHY
are no longer needed as they are handled by the firmware. By removing
only the reference is not enough as any un-used clock entry will get
disabled by the clock framework.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 92 --------------------------------------
 1 file changed, 92 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index f8c40a6..fa1a57f 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -177,86 +177,6 @@
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
 		};

 		serial0: serial@1c020000 {
@@ -273,7 +193,6 @@
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f21a000 0x0 0x100>;
 			#phy-cells = <1>;
-			clocks = <&sataphy1clk 0>;
 			status = "disabled";
 			apm,tx-boost-gain = <30 30 30 30 30 30>;
 			apm,tx-eye-tuning = <2 10 10 2 10 10>;
@@ -283,7 +202,6 @@
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f22a000 0x0 0x100>;
 			#phy-cells = <1>;
-			clocks = <&sataphy2clk 0>;
 			status = "ok";
 			apm,tx-boost-gain = <30 30 30 30 30 30>;
 			apm,tx-eye-tuning = <1 10 10 2 10 10>;
@@ -293,7 +211,6 @@
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f23a000 0x0 0x100>;
 			#phy-cells = <1>;
-			clocks = <&sataphy3clk 0>;
 			status = "ok";
 			apm,tx-boost-gain = <31 31 31 31 31 31>;
 			apm,tx-eye-tuning = <2 10 10 2 10 10>;
@@ -309,9 +226,6 @@
 			interrupts = <0x0 0x86 0x4>;
 			dma-coherent;
 			status = "disabled";
-			clocks = <&sata01clk 0>;
-			phys = <&phy1 0>;
-			phy-names = "sata-phy";
 		};

 		sata2: sata@1a400000 {
@@ -324,9 +238,6 @@
 			interrupts = <0x0 0x87 0x4>;
 			dma-coherent;
 			status = "ok";
-			clocks = <&sata23clk 0>;
-			phys = <&phy2 0>;
-			phy-names = "sata-phy";
 		};

 		sata3: sata@1a800000 {
@@ -338,9 +249,6 @@
 			interrupts = <0x0 0x88 0x4>;
 			dma-coherent;
 			status = "ok";
-			clocks = <&sata45clk 0>;
-			phys = <&phy3 0>;
-			phy-names = "sata-phy";
 		};
 	};
 };
--
1.8.2.1

