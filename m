From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v12 1/3] Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding
Date: Fri, 21 Feb 2014 10:47:31 -0700
Message-ID: <1393004853-25994-2-git-send-email-lho@apm.com>
References: <1393004853-25994-1-git-send-email-lho@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393004853-25994-1-git-send-email-lho-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 .../devicetree/bindings/ata/apm-xgene.txt          |   70 ++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
new file mode 100644
index 0000000..633eb3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -0,0 +1,70 @@
+* APM X-Gene 6.0 Gb/s SATA host controller nodes
+
+SATA host controller nodes are defined to describe on-chip Serial ATA
+controllers. Each SATA controller (pair of ports) have its own node.
+
+Required properties:
+- compatible		: Shall contain:
+  * "apm,xgene-ahci-sgmii" if mux'ed with SGMII
+  * "apm,xgene-ahci-pcie" if mux'ed with PCIe
+- reg			: First memory resource shall be the AHCI memory
+			  resource.
+			  Second memory resource shall be the host controller
+			  memory resource.
+- interrupts		: Interrupt-specifier for SATA host controller IRQ.
+- clocks		: Reference to the clock entry.
+- phys			: A list of phandles + phy-specifiers, one for each
+			  entry in phy-names.
+- phy-names		: Should contain:
+  * "sata-6g" for the SATA 6.0Gbps PHY
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "disabled" if disabled.
+			  Default is "ok".
+- interrupt-parent	: Interrupt controller.
+
+Example:
+		sataclk: sataclk {
+			compatible = "fixed-clock";
+			#clock-cells = <1>;
+			clock-frequency = <100000000>;
+			clock-output-names = "sataclk";
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>,
+			      <0x0 0x1f22c000 0x0 0x100>;
+			#phy-cells = <1>;
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f23a000 0x0 0x100>,
+			      <0x0 0x1f23c000 0x0 0x100>;
+			#phy-cells = <1>;
+		};
+
+		sata2: sata@1a400000 {
+			compatible = "apm,xgene-ahci-sgmii";
+			reg = <0x0 0x1a400000 0x0 0x1000>,
+			      <0x0 0x1f220000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x87 0x4>;
+			status = "ok";
+			clocks = <&sataclk 0>;
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
+			clocks = <&sataclk 0>;
+			phys = <&phy3 0>;
+			phy-names = "sata-6g";
+		};
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
