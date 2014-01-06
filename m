From: Loc Ho <lho@apm.com>
Subject: [PATCH v6 4/4] arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries
Date: Mon,  6 Jan 2014 11:11:02 -0700
Message-ID: <1389031862-4285-5-git-send-email-lho@apm.com>
References: <1389031862-4285-1-git-send-email-lho@apm.com>
 <1389031862-4285-2-git-send-email-lho@apm.com>
 <1389031862-4285-3-git-send-email-lho@apm.com>
 <1389031862-4285-4-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:59158 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755492AbaAFSLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 13:11:44 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so18558226pdj.33
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2014 10:11:42 -0800 (PST)
In-Reply-To: <1389031862-4285-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

This patch adds the DTS entries for the APM X-Gene SoC 15Gbps Multi-purpose
PHY driver. The PHY for SATA controller 0 and 1 are enabled by default.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   76 ++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 359d7b6..7e0466a 100644
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
@@ -193,5 +238,36 @@
 			reg = <0x0 0x17000014 0x0 0x100>;
 			mask = <0x1>;
 		};
+
+		phy1: phy@1f21a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f21a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy1clk 0>;
+			status = "disabled";
+			apm,tx-boost-gain = <2 3 3 2 3 3>;
+			apm,tx-eye-tuning = <2 10 10 2 10 10>;
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy2clk 0>;
+			status = "ok";
+			apm,tx-boost-gain = <2 3 2 2 3 2>;
+			apm,tx-eye-tuning = <1 10 10 2 10 5>;
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy-ext";
+			reg = <0x0 0x1f23a000 0x0 0x100>,
+			      <0x0 0x1f2d0000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy3clk 0>;
+			status = "ok";
+			apm,tx-boost-gain = <2 3 3 2 3 3>;
+			apm,tx-eye-tuning = <2 10 10 2 10 12>;
+		};
 	};
 };
-- 
1.5.5

