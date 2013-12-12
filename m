From: Loc Ho <lho@apm.com>
Subject: [PATCH v6 4/4] arm64: Add APM X-Gene SoC SATA host controller DTS entries
Date: Thu, 12 Dec 2013 00:55:40 -0700
Message-ID: <1386834940-30875-5-git-send-email-lho@apm.com>
References: <1386834940-30875-1-git-send-email-lho@apm.com>
 <1386834940-30875-2-git-send-email-lho@apm.com>
 <1386834940-30875-3-git-send-email-lho@apm.com>
 <1386834940-30875-4-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1386834940-30875-4-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   84 ++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index e967676..4d7fe65 100644
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
@@ -224,5 +269,44 @@
 			apm,tx-boost-gain = <0x2 0x3 0x3 0x2 0x3 0x3>;
 			apm,tx-eye-tuning = <0x2 0xa 0xa 0x2 0xa 0xc>;
 		};
+
+		sata1: sata@1a000000 {
+			compatible = "apm,xgene-ahci-sgmii";
+			reg = <0x0 0x1a000000 0x0 0x1000>,
+			      <0x0 0x1f210000 0x0 0x10000>,
+			      <0x0 0x1f2a0000 0x0 0x10000>,
+			      <0x0 0x1c000200 0x0 0x100>;
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
+			      <0x0 0x1f220000 0x0 0x10000>,
+			      <0x0 0x1f2a0000 0x0 0x10000>,
+			      <0x0 0x1c000200 0x0 0x100>;
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
+			      <0x0 0x1f230000 0x0 0x10000>,
+			      <0x0 0x1f2a0000 0x0 0x10000>,
+			      <0x0 0x1c000200 0x0 0x100>;
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

