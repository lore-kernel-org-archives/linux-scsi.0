From: Loc Ho <lho@apm.com>
Subject: [PATCH v7 4/4] arm64: Add APM X-Gene SoC SATA host controller DTS entries
Date: Thu,  2 Jan 2014 17:22:19 -0700
Message-ID: <1388708539-333-5-git-send-email-lho@apm.com>
References: <1388708539-333-1-git-send-email-lho@apm.com>
 <1388708539-333-2-git-send-email-lho@apm.com>
 <1388708539-333-3-git-send-email-lho@apm.com>
 <1388708539-333-4-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:58323 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754504AbaACAW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2014 19:22:59 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so14670720pde.21
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2014 16:22:58 -0800 (PST)
In-Reply-To: <1388708539-333-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   81 ++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index fd2b662..5b09797 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -218,6 +218,48 @@
 				enable-offset = <0x0>;
 				enable-mask = <0x06>;
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
+				clock-names = "sata23clk";
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
+				clock-names = "sata45clk";
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
@@ -266,5 +308,44 @@
 			apm,tx-boost-gain = <2 3 3 2 3 3>;
 			apm,tx-eye-tuning = <2 10 10 2 10 12>;
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

