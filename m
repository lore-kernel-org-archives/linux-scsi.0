From: Loc Ho <lho@apm.com>
Subject: [PATCH v5 4/4] arm64: Add APM X-Gene SoC SATA host controller DTS entries
Date: Tue, 26 Nov 2013 00:01:25 -0700
Message-ID: <1385449285-30764-5-git-send-email-lho@apm.com>
References: <1385449285-30764-1-git-send-email-lho@apm.com>
 <1385449285-30764-2-git-send-email-lho@apm.com>
 <1385449285-30764-3-git-send-email-lho@apm.com>
 <1385449285-30764-4-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:43344 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753698Ab3KZHCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2013 02:02:03 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so7416293pbc.39
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2013 23:02:02 -0800 (PST)
In-Reply-To: <1385449285-30764-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

arm64: Add APM X-Gene SoC SATA host controller and clock DTS entries

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   81 ++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index f74c26a..fd8ff25 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -176,6 +176,51 @@
 				reg-names = "csr-reg";
 				clock-output-names = "eth8clk";
 			};
+
+			sata01clk: sata01clk@1f21c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "sata01clk";
+				reg = <0x0 0x1f21c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata01clk";
+				status = "disabled";
+				csr-offset = <0x4>;
+				csr-mask = <0x3f>;
+				enable-offset = <0x0>;
+				enable-mask = <0x3f>;
+			};
+
+			sata23clk: sata23clk@1f22c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "sata23clk";
+				reg = <0x0 0x1f22c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata23clk";
+				status = "ok";
+				csr-offset = <0x4>;
+				csr-mask = <0x3f>;
+				enable-offset = <0x0>;
+				enable-mask = <0x3f>;
+			};
+
+			sata45clk: sata45clk@1f23c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "sata45clk";
+				reg = <0x0 0x1f23c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata45clk";
+				status = "ok";
+				csr-offset = <0x4>;
+				csr-mask = <0x3f>;
+				enable-offset = <0x0>;
+				enable-mask = <0x3f>;
+			};
 		};
 
 		serial0: serial@1c020000 {
@@ -224,5 +269,41 @@
 			apm-tx-boost-gain = <0x3 0x3 0x3 0x3 0x3 0x3>;
 			apm-tx-eye-tuning = <0xa 0xa 0xa 0xc 0xc 0xc>;
 		};
+
+		sata1: sata@1a000000 {
+			compatible = "apm,xgene-ahci-sgmii";
+			reg = <0x0 0x1a000000 0x0 0x1000>,
+			      <0x0 0x1f210000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x86 0x4>;
+			status = "disabled";
+			clocks = <&sata01clk 0>;
+			phys = <&phy1 0>;
+			phy-names = "sata-6g";
+		};
+
+		sata2: sata@1a400000 {
+			compatible = "apm,xgene-ahci-sgmii";
+			reg = <0x0 0x1a400000 0x0 0x1000>,
+			      <0x0 0x1f220000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x87 0x4>;
+			status = "ok";
+			clocks = <&sata23clk 0>;
+			phys = <&phy2 0>;
+			phy-names = "sata-6g";
+		};
+
+		sata3: sata@1a800000 {
+			compatible = "apm,xgene-ahci-pcie";
+			reg = <0x0 0x1a800000 0x0 0x1000>,
+			      <0x0 0x1f230000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x88 0x4>;
+			status = "ok";
+			clocks = <&sata45clk 0>;
+			phys = <&phy3 0>;
+			phy-names = "sata-6g";
+		};
 	};
 };
-- 
1.5.5

