From: Loc Ho <lho@apm.com>
Subject: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Thu, 14 Nov 2013 12:31:57 -0700
Message-ID: <1384457519-21335-2-git-send-email-lho@apm.com>
References: <1384457519-21335-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:49319 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754832Ab3KNTcV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 14:32:21 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so2447542pbc.26
        for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2013 11:32:20 -0800 (PST)
In-Reply-To: <1384457519-21335-1-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation

Document the DTS binding for the X-Gene SoC SATA PHY driver.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Olof Johansson <olof@lixom.net> 
---
 .../devicetree/bindings/ata/apm-xgene.txt          |   69 ++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
new file mode 100644
index 0000000..d18db67
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
@@ -0,0 +1,69 @@
+* APM X-Gene 6.0 Gb/s SATA PHY nodes
+
+SATA PHY nodes are defined to describe on-chip Serial ATA PHY. Each SATA PHY
+(pair of PHY) has its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-ahci-phy"
+- reg			: First memory resource shall be the PHY memory resource
+			  Second memory resource shall be the optional PHY
+			  memory resource if mux'ed with another IP
+- id			: PHY ID (0 = first, 1 = second, 2 = third)
+- #phy-cells		: Shall be 0
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "na" if disabled. Default
+			  is "ok".
+- CTLE0			: PHY override parameters for channel 0 register REG1
+			  field CTLE_EQ. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0x2.
+- CTLE1			: PHY override parameters for channel 1 register REG1
+			  field CTLE_EQ. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0x2.
+- PQ0			: PHY override parameters for channel 0 register REG125
+			  field PQ_REG. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0xA.
+- PQ1			: PHY override parameters for channel 1 register REG125
+			  field PQ_REG. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0xA.
+- PQS0			: PHY override parameters for channel 0 register REG125
+			  field PQ_SIGN. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0x1.
+- PQS1			: PHY override parameters for channel 1 register REG125
+			  field PQ_SIGN. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0x1.
+- SPD0			: PHY override parameters for channel 0 register REG61
+			  field PQ_SIGN. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0x5.
+- SPD1			: PHY override parameters for channel 1 register REG61
+			  field PQ_SIGN. First value for Gen1, second value
+			  for Gen2, and third value for Gen3. Default is 0x5.
+
+NOTE: PHY override parameters are board specific setting.
+
+Example:
+		sataphy0: sataphy@1f210000 {
+			compatible = "apm,xgene-ahci-phy";
+			id = <0>;
+			reg = <0x0 0x1f210000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "na";
+		};
+
+		sataphy1: sataphy@1f220000 {
+			compatible = "apm,xgene-ahci-phy";
+			id = <1>;
+			reg = <0x0 0x1f220000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "ok";
+		};
+
+		sataphy2: sataphy@1f230000 {
+			compatible = "apm,xgene-ahci-phy";
+			id = <2>;
+			reg = <0x0 0x1f230000 0x0 0x10000
+			       0x0 0x1f2d0000 0x0 0x10000 >;
+			#phy-cells = <0>;
+			status = "ok";
+		};
+
-- 
1.5.5

