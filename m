From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 5/5] Documentation: Add documentation for APM X-Gene SATA DTS binding
Date: Sat,  9 Nov 2013 00:00:31 -0700
Message-ID: <1383980431-6572-6-git-send-email-lho@apm.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
 <1383980431-6572-2-git-send-email-lho@apm.com>
 <1383980431-6572-3-git-send-email-lho@apm.com>
 <1383980431-6572-4-git-send-email-lho@apm.com>
 <1383980431-6572-5-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:36601 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758949Ab3KIHBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 02:01:09 -0500
Received: by mail-pb0-f51.google.com with SMTP id xa7so3094775pbc.24
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 23:01:08 -0800 (PST)
In-Reply-To: <1383980431-6572-5-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Documentation: Add documentation for APM X-Gene SATA DTS binding

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 .../devicetree/bindings/ata/apm-xgene.txt          |   84 ++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
new file mode 100644
index 0000000..cd52864
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -0,0 +1,84 @@
+* APM X-Gene 6.0 Gb/s SATA nodes
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+Each SATA controller (pair of ports) have its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-ahci"
+- reg			: First memory resource shall be the AHCI memory resource
+			  Second memory resource shall be the Serdes memory resource
+			  Third memory resource shall be the optional Serdes
+			  memory resource if mux'ed with another IP
+- interrupt-parent	: Interrupt controller
+- interrupts		: Interrupt mapping for SATA IRQ
+- #clock-cells		: Shall be value of 1
+- clocks		: Reference to the clock entry
+- clock-names		: Shall be "eth01clk", "eth23clk", or "eth45clk".
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "na" if disabled. Default
+			  is "ok".
+- serdes-diff-clk	: Shall be 0 for external, 1 internal differential,
+			  or 2 internal single ended clock. Default is 0.
+- gen-sel		: Shall be 1 (force Gen1), 2 (Force Gen2, or 3 Gen3).
+			  Default is 3.
+- EQA1			: Serdes EQ parameter for A1 chip. Default is 9.
+- EQ			: Serdes EQ parameter for non-A1 chip. Default is 2.
+- GENAVG		: Enable averaging Serdes calculation. Default is 0 for
+			  A1 chip and 1 for non-A1 chip.
+- LBA1			: Serdes loopback buffer for A1 chip. Default is 1;
+- LB			: Serdes loopback buffer for non-A1 chip. Default is 0;
+- LCA1			: Serdes loopback enable control for A1 chip. Default
+			  is 1;
+- LC			: Serdes loopback enable control for non-A1 chip.
+			  Default is 0;
+- CDRA1			: Serdes SPD select CDR for A1 chip. Default is 5.
+- CDR			: Serdes SPD select CDR for non-A1 chip. Default is 5.
+- PQA1			: Serdes PQ for A1 chip. Default is 8.
+- PQ			: Serdes PQ for non-A1 chip. Default is 0xA.
+- coherent		: Enable coherent (1 = enable, 0 = disable).
+			  Default is 1.
+
+Example:
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
-- 
1.5.5

