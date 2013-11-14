From: Loc Ho <lho@apm.com>
Subject: [PATCH v3 2/4] Documentation: Add documentation for APM X-Gene SATA controllor DTS binding
Date: Thu, 14 Nov 2013 14:39:11 -0700
Message-ID: <1384465153-29902-3-git-send-email-lho@apm.com>
References: <1384465153-29902-1-git-send-email-lho@apm.com>
 <1384465153-29902-2-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:37033 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758090Ab3KNVje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 16:39:34 -0500
Received: by mail-pb0-f44.google.com with SMTP id rp16so2618354pbb.17
        for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2013 13:39:33 -0800 (PST)
In-Reply-To: <1384465153-29902-2-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Documentation:: Add documentation for APM X-Gene SoC SATA host controller DTS binding

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Olof Johansson <olof@lixom.net>
---
 .../devicetree/bindings/ata/apm-xgene.txt          |   62 +++++++++++++++++++-
 1 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
index d18db67..0d16bfe 100644
--- a/Documentation/devicetree/bindings/ata/apm-xgene.txt
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -1,4 +1,4 @@
-* APM X-Gene 6.0 Gb/s SATA PHY nodes
+* APM X-Gene 6.0 Gb/s SATA PHY and controller nodes
 
 SATA PHY nodes are defined to describe on-chip Serial ATA PHY. Each SATA PHY
 (pair of PHY) has its own node.
@@ -67,3 +67,63 @@ Example:
 			status = "ok";
 		};
 
+SATA host controller nodes are defined to describe on-chip Serial ATA
+controllers. Each SATA controller (pair of ports) have its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-ahci"
+- reg			: First memory resource shall be the AHCI memory
+			  resource.
+			  Second memory resource shall be the host controller
+			  memory resource.
+- id			: Controller ID (0 = first, 1 = second, 2 = third)
+- interrupt-parent	: Interrupt controller
+- interrupts		: Interrupt mapping for SATA host controller IRQ
+- clocks		: Reference to the clock entry
+- phys			: PHY reference
+- phy-names		: Name of the PHY reference
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "na" if disabled.
+			  Default is "ok".
+
+Example:
+		sata0: sata@1a000000 {
+			compatible = "apm,xgene-ahci";
+			id = <0>;
+			reg =  <0x0 0x1a000000 0x0 0x100000
+				0x0 0x1f210000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x86 0x4>;
+		        clocks = <&eth01clk 0>;
+			status = "na";
+			phys = <&sataphy0>;
+			phy-names = "sataphy0";
+		};
+
+		sata1: sata@1a400000 {
+			compatible = "apm,xgene-ahci";
+			id = <1>;
+			reg =  <0x0 0x1a400000 0x0 0x100000
+				0x0 0x1f220000 0x0 0x10000>;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x87 0x4>;
+		        clocks = <&eth23clk 0>;
+			status = "ok";
+			phys = <&sataphy1>;
+			phy-names = "sataphy1";
+		};
+
+		sata2: sata@1a800000 {
+			compatible = "apm,xgene-ahci";
+			id = <2>;
+			reg =  <0x0 0x1a800000 0x0 0x100000
+				0x0 0x1f230000 0x0 0x10000
+				0x0 0x1f2d0000 0x0 0x10000 >;
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x88 0x4>;
+		        clocks = <&sata45clk 0>;
+			status = "ok";
+			phys = <&sataphy2>;
+			phy-names = "sataphy2";
+		};
-- 
1.5.5

