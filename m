From: Loc Ho <lho@apm.com>
Subject: [PATCH v18 4/4] arm64: Add APM X-Gene SoC AHCI SATA host controller DTS entries
Date: Fri, 14 Mar 2014 17:53:21 -0600
Message-ID: <1394841201-29495-5-git-send-email-lho@apm.com>
References: <1394841201-29495-1-git-send-email-lho@apm.com>
 <1394841201-29495-2-git-send-email-lho@apm.com>
 <1394841201-29495-3-git-send-email-lho@apm.com>
 <1394841201-29495-4-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:52342 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756428AbaCNXyA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2014 19:54:00 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so3283078pad.21
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2014 16:54:00 -0700 (PDT)
In-Reply-To: <1394841201-29495-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

This patch adds APM X-Gene SoC AHCI SATA host controller DTS entries.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   80 ++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 6d4f493..93f4b2d 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -218,6 +218,45 @@
 				enable-offset = <0x0>;
 				enable-mask = <0x06>;
 			};
+
+			sata01clk: sata01clk@1f21c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f21c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata01clk";
+				csr-offset = <0x4>;
+				csr-mask = <0x05>;
+				enable-offset = <0x0>;
+				enable-mask = <0x39>;
+			};
+
+			sata23clk: sata23clk@1f22c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f22c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata23clk";
+				csr-offset = <0x4>;
+				csr-mask = <0x05>;
+				enable-offset = <0x0>;
+				enable-mask = <0x39>;
+			};
+
+			sata45clk: sata45clk@1f23c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f23c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata45clk";
+				csr-offset = <0x4>;
+				csr-mask = <0x05>;
+				enable-offset = <0x0>;
+				enable-mask = <0x39>;
+			};
 		};
 
 		serial0: serial@1c020000 {
@@ -259,5 +298,46 @@
 			apm,tx-boost-gain = <31 31 31 31 31 31>;
 			apm,tx-eye-tuning = <2 10 10 2 10 10>;
 		};
+
+		sata1: sata@1a000000 {
+			compatible = "apm,xgene-ahci";
+			reg = <0x0 0x1a000000 0x0 0x1000>,
+			      <0x0 0x1f210000 0x0 0x1000>,
+			      <0x0 0x1f21d000 0x0 0x1000>,
+			      <0x0 0x1f21e000 0x0 0x1000>,
+			      <0x0 0x1f217000 0x0 0x1000>;
+			interrupts = <0x0 0x86 0x4>;
+			status = "disabled";
+			clocks = <&sata01clk 0>;
+			phys = <&phy1 0>;
+			phy-names = "sata-phy";
+		};
+
+		sata2: sata@1a400000 {
+			compatible = "apm,xgene-ahci";
+			reg = <0x0 0x1a400000 0x0 0x1000>,
+			      <0x0 0x1f220000 0x0 0x1000>,
+			      <0x0 0x1f22d000 0x0 0x1000>,
+			      <0x0 0x1f22e000 0x0 0x1000>,
+			      <0x0 0x1f227000 0x0 0x1000>;
+			interrupts = <0x0 0x87 0x4>;
+			status = "ok";
+			clocks = <&sata23clk 0>;
+			phys = <&phy2 0>;
+			phy-names = "sata-phy";
+		};
+
+		sata3: sata@1a800000 {
+			compatible = "apm,xgene-ahci";
+			reg = <0x0 0x1a800000 0x0 0x1000>,
+			      <0x0 0x1f230000 0x0 0x1000>,
+			      <0x0 0x1f23d000 0x0 0x1000>,
+			      <0x0 0x1f23e000 0x0 0x1000>;
+			interrupts = <0x0 0x88 0x4>;
+			status = "ok";
+			clocks = <&sata45clk 0>;
+			phys = <&phy3 0>;
+			phy-names = "sata-phy";
+		};
 	};
 };
-- 
1.5.5

