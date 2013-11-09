From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 2/5] arm64: Add APM X-Gene DTS entry for SATA controllers
Date: Sat,  9 Nov 2013 00:00:28 -0700
Message-ID: <1383980431-6572-3-git-send-email-lho@apm.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
 <1383980431-6572-2-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:40324 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758911Ab3KIHAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 02:00:51 -0500
Received: by mail-pa0-f43.google.com with SMTP id hz1so3176504pad.30
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 23:00:50 -0800 (PST)
In-Reply-To: <1383980431-6572-2-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

arm64: Add APM X-Gene SATA clock and controller DTS entries.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   73 ++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 359d7b6..09fc967 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -176,6 +176,36 @@
 				reg-names = "csr-reg";
 				clock-output-names = "eth8clk";
 			};
+
+			eth01clk: eth01clk@1f21c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "eth01clk";
+	                        reg = <0x0 0x1f21c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "eth01clk";
+			};
+
+			eth23clk: eth23clk@1f22c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "eth23clk";
+	                        reg = <0x0 0x1f22c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "eth23clk";
+			};
+
+			sata45clk: sata45clk@1f23c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "sata45clk";
+	                        reg = <0x0 0x1f23c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata45clk";
+			};
 		};
 
 		serial0: serial@1c020000 {
@@ -193,5 +223,48 @@
 			reg = <0x0 0x17000014 0x0 0x100>;
 			mask = <0x1>;
 		};
+
+		sata0: sata@1a000000 {
+			compatible = "apm,xgene-ahci";
+			reg =  <0x0 0x1a000000 0x0 0x100000
+				0x0 0x1f210000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x86 0x4>;
+			#clock-cells = <1>;
+		        clocks = <&eth01clk 0>;
+			clock-names = "eth01clk";
+			status = "na";
+			serdes-diff-clk = <0>;
+			gen-sel = <3>;
+		};
+
+		sata1: sata@1a400000 {
+			compatible = "apm,xgene-ahci";
+			reg =  <0x0 0x1a400000 0x0 0x100000
+				0x0 0x1f220000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x87 0x4>;
+			#clock-cells = <1>;
+		        clocks = <&eth23clk 0>;
+			clock-names = "eth23clk";
+			status = "na";
+			serdes-diff-clk = <0>;
+			gen-sel = <3>;
+		};
+
+		sata2: sata@1a800000 {
+			compatible = "apm,xgene-ahci";
+			reg =  <0x0 0x1a800000 0x0 0x100000
+				0x0 0x1f230000 0x0 0x10000
+				0x0 0x1f2d0000 0x0 0x10000 >;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x88 0x4>;
+			#clock-cells = <1>;
+		        clocks = <&sata45clk 0>;
+			clock-names = "sata45clk";
+			status = "ok";
+			serdes-diff-clk = <0>;
+			gen-sel = <3>;
+		};
 	};
 };
-- 
1.5.5

