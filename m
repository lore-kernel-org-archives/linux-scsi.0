From: Loc Ho <lho@apm.com>
Subject: [PATCH v5 2/4] Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding
Date: Tue, 26 Nov 2013 00:01:23 -0700
Message-ID: <1385449285-30764-3-git-send-email-lho@apm.com>
References: <1385449285-30764-1-git-send-email-lho@apm.com>
 <1385449285-30764-2-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1385449285-30764-2-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 .../devicetree/bindings/ata/apm-xgene.txt          |  102 ++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
new file mode 100644
index 0000000..879eee7
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -0,0 +1,102 @@
+* APM X-Gene 6.0 Gb/s SATA host controller and clock nodes
+
+SATA host controller nodes are defined to describe on-chip Serial ATA
+controllers. Each SATA controller (pair of ports) have its own node. Its
+corresponding clock nodes are shown below.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-ahci-sgmii" if mux'ed with SGMII
+			  or "apm,xgene-ahci-pcie" if mux'ed with PCIe.
+- reg			: First memory resource shall be the AHCI memory
+			  resource.
+			  Second memory resource shall be the host controller
+			  memory resource.
+- interrupt-parent	: Interrupt controller.
+- interrupts		: Interrupt mapping for SATA host controller IRQ.
+- clocks		: Reference to the clock entry.
+- phys			: PHY reference with parameter 0.
+- phy-names		: Name of the PHY. Shall be "sata-6g".
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "na" if disabled.
+			  Default is "ok".
+
+Example:
+		sata01clk: sata01clk@1f21c000 {
+			compatible = "apm,xgene-device-clock";
+			#clock-cells = <1>;
+			clocks = <&socplldiv2 0>;
+			clock-names = "sata01clk";
+			reg = <0x0 0x1f21c000 0x0 0x1000>;
+			reg-names = "csr-reg";
+			clock-output-names = "sata01clk";
+			status = "ok";
+			csr-offset = <0x4>;
+			csr-mask = <0x3f>;
+			enable-offset = <0x0>;
+			enable-mask = <0x3f>;
+		};
+
+		sata23clk: sata23clk@1f22c000 {
+			compatible = "apm,xgene-device-clock";
+			#clock-cells = <1>;
+			clocks = <&socplldiv2 0>;
+			clock-names = "sata23clk";
+			reg = <0x0 0x1f22c000 0x0 0x1000>;
+			reg-names = "csr-reg";
+			clock-output-names = "sata23clk";
+			csr-offset = <0x4>;
+			csr-mask = <0x3f>;
+			enable-offset = <0x0>;
+			enable-mask = <0x3f>;
+		};
+
+		sata45clk: sata45clk@1f23c000 {
+			compatible = "apm,xgene-device-clock";
+			#clock-cells = <1>;
+			clocks = <&socplldiv2 0>;
+			clock-names = "sata45clk";
+			reg = <0x0 0x1f23c000 0x0 0x1000>;
+			reg-names = "csr-reg";
+			clock-output-names = "sata45clk";
+			csr-offset = <0x4>;
+			csr-mask = <0x3f>;
+			enable-offset = <0x0>;
+			enable-mask = <0x3f>;
+		};
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
-- 
1.5.5

