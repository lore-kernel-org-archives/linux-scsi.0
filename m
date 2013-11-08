From: Loc Ho <lho@apm.com>
Subject: [PATCH 2/5] arm64: Add APM X-Gene SATA DTS binding
Date: Fri,  8 Nov 2013 15:30:35 -0700
Message-ID: <1383949838-25106-3-git-send-email-lho@apm.com>
References: <1383949838-25106-1-git-send-email-lho@apm.com>
 <1383949838-25106-2-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1383949838-25106-2-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: tj@kernel.org, linux-scsi@vger.kernel.org
Cc: Suman Tripathi <stripathi@apm.com>, jcm@redhat.com, devicetree-discuss@lists.ozlabs.org, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

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
