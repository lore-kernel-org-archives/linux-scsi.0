From: Loc Ho <lho@apm.com>
Subject: [PATCH v3 2/4] Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
Date: Mon, 25 Nov 2013 22:46:56 -0700
Message-ID: <1385444818-29682-3-git-send-email-lho@apm.com>
References: <1385444818-29682-1-git-send-email-lho@apm.com>
 <1385444818-29682-2-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1385444818-29682-2-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 .../devicetree/bindings/ata/apm-xgene-phy.txt      |   89 ++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene-phy.txt

diff --git a/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt b/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
new file mode 100644
index 0000000..7ec2ea5
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
@@ -0,0 +1,89 @@
+* APM X-Gene 15Gbps Multi-purpose PHY nodes
+
+PHY nodes are defined to describe on-chip 15Gbps Multi-purpose PHY. Each
+PHY (pair of lanes) has its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-phy" or
+			  "apm,xgene-phy-ext". The "apm,xgene-phy" describes
+			  an PHY with internal reference PLL located within
+			  the IP. The "apm,xgene-phy-ext" describes an PHY
+			  where the internal reference PLL located outside of
+			  the IP.
+- reg			: First PHY memory resource is the SDS PHY access
+			  resource.
+			  Second PHY memory resoruce is the clock and reset
+			  resources.
+			  Third PHY memory resource is the SDS PHY access
+			  resource outside of the IP if it is type
+			  "apm,xgene-phy-ext".
+- #phy-cells		: Shall be 1 as it expects one argument for setting
+			  the mode of the PHY. Possible values are 0 (SATA),
+			  1 (SGMII), 2 (PCIe), or 3 (USB).
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "disabled" if disabled.
+			  Default is "ok".
+- apm-tx-eye-tuning	: Manual control to fine tune the capture of the serial
+			  bit lines from the automatic calibrated position.
+			  Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
+			  Range from 0 to 0x7f in unit of one bit period.
+			  Default is 0xa.
+- apm-tx-eye-direction	: Eye tuning manual control direction. 0 means sample
+			  data earlier than the nominal sampling point. 1 means
+			  sample data later than the nominal sampling point.
+			  Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
+			  Default is 0x0.
+- apm-tx-boost-gain	: Frequency boost AC (LSB 3-bit) and DC (2-bit)
+			  gain control. Two set of 3-tuple setting for Gen1,
+			  Gen2, and Gen3. Range is between 0 to 0x1f in unit
+			  of dB. Default is 0x3.
+- apm-tx-amplitude	: Amplitude control. Two set of 3-tuple setting for
+			  Gen1, Gen2, and Gen3. Range is between 0 to 0xf in
+			  unit of 13.3mV. Default is 0xf.
+- apm-tx-pre-cursor1	: 1st pre-cursor emphasis taps control. Two set of
+			  3-tuple setting for Gen1, Gen2, and Gen3. Range is
+			  between 0 to 0xf in unit of 18.2mV. Default is 0x0.
+- apm-tx-pre-cursor2	: 2st pre-cursor emphasis taps control. Two set of
+			  3-tuple setting for Gen1, Gen2, and Gen3. Range is
+			  between 0 to 0x7 in unit of 18.2mV. Default is 0x0.
+- apm-tx-post-cursor	: Post-cursor emphasis taps control. Two set of
+			  3-tuple setting for Gen1, Gen2, and Gen3. Range is
+			  between 0 to 0x1f in unit of 18.2mV. Default is 0xf.
+- apm-tx-speed		: Tx operating speed. One set of 3-tuple for
+			  Gen1 (0x1), Gen2 (0x3), and Gen3 (0x7). Default is
+			  0x7.
+
+NOTE: PHY override parameters are board specific setting.
+
+Example:
+		phy1: phy@1f210000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f21a000 0x0 0x100>,
+			      <0x0 0x1f21c000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "disabled";
+			apm-tx-boost-gain = <0x2 0x2 0x2 0x2 0x2 0x2>;
+			apm-tx-eye-tuning = <0xa 0xa 0xa 0xa 0xa 0xa>;
+		};
+
+		phy2: phy@1f220000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>,
+			      <0x0 0x1f22c000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+			apm-tx-boost-gain = <0x2 0x2 0x2 0x2 0x2 0x2>;
+			apm-tx-eye-tuning = <0xa 0xa 0xa 0x5 0x5 0x5>;
+		};
+
+		phy3: phy@1f230000 {
+			compatible = "apm,xgene-phy-ext";
+			reg = <0x0 0x1f23a000 0x0 0x100>,
+			      <0x0 0x1f23c000 0x0 0x100>,
+			      <0x0 0x1f2d0000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+			apm-tx-boost-gain = <0x3 0x3 0x3 0x3 0x3 0x3>;
+			apm-tx-eye-tuning = <0xa 0xa 0xa 0xc 0xc 0xc>;
+		};
-- 
1.5.5

