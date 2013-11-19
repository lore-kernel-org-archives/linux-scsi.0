From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 2/4] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Tue, 19 Nov 2013 16:53:15 -0700
Message-ID: <1384905197-3566-3-git-send-email-lho@apm.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
 <1384905197-3566-2-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:56153 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752423Ab3KSXxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2013 18:53:37 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so4488492pdj.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 15:53:36 -0800 (PST)
In-Reply-To: <1384905197-3566-2-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation

Document the DTS binding for the X-Gene SoC SATA PHY driver.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 .../devicetree/bindings/ata/apm-xgene-phy.txt      |   61 ++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene-phy.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt b/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
new file mode 100644
index 0000000..bbae164
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
@@ -0,0 +1,61 @@
+* APM X-Gene 6.0 Gb/s SATA PHY nodes
+
+SATA PHY nodes are defined to describe on-chip Serial ATA PHY. Each SATA PHY
+(pair of PHY) has its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-ahci-phy" or
+			  "apm,xgene-ahci-phy2". The "apm,xgene-ahci-phy"
+			  describes an port shared with SGMII Ethernet port.
+			  The "apm,xgene-ahci-phy2" describes an port not
+			  shared with SGMII and the PLL located at another
+			  memory resource region.
+- reg			: First PHY memory resource
+			  Second separate PHY PLL clock memory resource if
+			  type "apm,xgene-ahci-phy2"
+- #phy-cells		: Shall be 0
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "na" if disabled. Default
+			  is "ok".
+- txeyetuning		: Manual control to fine tune the capture of the serial
+			  bit lines from the automatic calibrated position.
+			  Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
+			  Range from 0 to 0x7f. Default is 0xa.
+- txeyedirection	: Eye tuning manual control direction. 0 means sample
+			  data earlier than the nominal sampling point. 1 means
+			  sample data later than the nominal sampling point.
+			  Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
+			  Default is 0x0.
+- txboostgain		: Frequency boost and DC gain control. Two set of
+			  3-tuple setting for Gen1, Gen2, and Gen3. Range is
+			  between 0 to 0x1f. Default is 0x3.
+- txspeed		: Tx operating speed. Two set of 3-tuple for
+			  Gen1 (0x1), Gen2 (0x3), and Gen3 (0x7). Default is
+			  0x7.
+
+NOTE: PHY override parameters are board specific setting.
+
+Example:
+		sataphy0: sataphy@1f210000 {
+			compatible = "apm,xgene-ahci-phy";
+			reg = <0x0 0x1f210000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "na";
+		};
+
+		sataphy1: sataphy@1f220000 {
+			compatible = "apm,xgene-ahci-phy";
+			reg = <0x0 0x1f220000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "ok";
+		};
+
+		sataphy2: sataphy@1f230000 {
+			compatible = "apm,xgene-ahci-phy2";
+			reg = <0x0 0x1f230000 0x0 0x10000
+			       0x0 0x1f2d0000 0x0 0x10000 >;
+			#phy-cells = <0>;
+			status = "ok";
+		};
+
-- 
1.5.5

