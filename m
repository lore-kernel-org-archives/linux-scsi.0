From: Loc Ho <lho@apm.com>
Subject: [PATCH v7 2/4] Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding
Date: Thu,  2 Jan 2014 17:22:17 -0700
Message-ID: <1388708539-333-3-git-send-email-lho@apm.com>
References: <1388708539-333-1-git-send-email-lho@apm.com>
 <1388708539-333-2-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:44259 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754043AbaACAWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2014 19:22:45 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so15077148pab.36
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2014 16:22:44 -0800 (PST)
In-Reply-To: <1388708539-333-2-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 .../devicetree/bindings/ata/apm-xgene.txt          |   68 ++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
new file mode 100644
index 0000000..3d1421a
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -0,0 +1,68 @@
+* APM X-Gene 6.0 Gb/s SATA host controller nodes
+
+SATA host controller nodes are defined to describe on-chip Serial ATA
+controllers. Each SATA controller (pair of ports) have its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-ahci-sgmii" if mux'ed with SGMII
+			  or "apm,xgene-ahci-pcie" if mux'ed with PCIe.
+- reg			: First memory resource shall be the AHCI memory
+			  resource.
+			  Second memory resource shall be the host controller
+			  memory resource.
+- interrupts		: Interrupt mapping for SATA host controller IRQ.
+- clocks		: Reference to the clock entry.
+- phys			: PHY reference with parameter 0.
+- phy-names		: Name of the PHY. Shall be "sata-6g".
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
+			compatible = "apm,xgene-phy-ext";
+			reg = <0x0 0x1f23a000 0x0 0x100>,
+			      <0x0 0x1f23c000 0x0 0x100>,
+			      <0x0 0x1f2d0000 0x0 0x100>;
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

