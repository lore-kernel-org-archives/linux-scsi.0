From: Loc Ho <lho@apm.com>
Subject: [PATCH v11 2/4] Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
Date: Tue, 25 Feb 2014 11:41:37 -0700
Message-ID: <1393353699-6443-3-git-send-email-lho@apm.com>
References: <1393353699-6443-1-git-send-email-lho@apm.com>
 <1393353699-6443-2-git-send-email-lho@apm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393353699-6443-2-git-send-email-lho@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, tj@kernel.org
Cc: olof@lixom.net, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 .../devicetree/bindings/phy/apm-xgene-phy.txt      |   79 ++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/apm-xgene-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/apm-xgene-phy.txt b/Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
new file mode 100644
index 0000000..5f3a65a
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
@@ -0,0 +1,79 @@
+* APM X-Gene 15Gbps Multi-purpose PHY nodes
+
+PHY nodes are defined to describe on-chip 15Gbps Multi-purpose PHY. Each
+PHY (pair of lanes) has its own node.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-phy".
+- reg			: PHY memory resource is the SDS PHY access resource.
+- #phy-cells		: Shall be 1 as it expects one argument for setting
+			  the mode of the PHY. Possible values are 0 (SATA),
+			  1 (SGMII), 2 (PCIe), 3 (USB), and 4 (XFI).
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "disabled" if disabled.
+			  Default is "ok".
+- clocks		: Reference to the clock entry.
+- apm,tx-eye-tuning	: Manual control to fine tune the capture of the serial
+			  bit lines from the automatic calibrated position.
+			  Two set of 3-tuple setting for each (up to 3)
+			  supported link speed on the host. Range from 0 to
+			  127 in unit of one bit period. Default is 10.
+- apm,tx-eye-direction	: Eye tuning manual control direction. 0 means sample
+			  data earlier than the nominal sampling point. 1 means
+			  sample data later than the nominal sampling point.
+			  Two set of 3-tuple setting for each (up to 3)
+			  supported link speed on the host. Default is 0.
+- apm,tx-boost-gain	: Frequency boost AC (LSB 3-bit) and DC (2-bit)
+			  gain control. Two set of 3-tuple setting for each
+			  (up to 3) supported link speed on the host. Range is
+			  between 0 to 31 in unit of dB. Default is 3.
+- apm,tx-amplitude	: Amplitude control. Two set of 3-tuple setting for
+			  each (up to 3) supported link speed on the host.
+			  Range is between 0 to 199500 in unit of uV.
+			  Default is 199500 uV.
+- apm,tx-pre-cursor1	: 1st pre-cursor emphasis taps control. Two set of
+			  3-tuple setting for each (up to 3) supported link
+			  speed on the host. Range is 0 to 273000 in unit of
+			  uV. Default is 0.
+- apm,tx-pre-cursor2	: 2st pre-cursor emphasis taps control. Two set of
+			  3-tuple setting for each (up to 3) supported link
+			  speed on the host. Range is 0 to 127400 in unit uV.
+			  Default is 0x0.
+- apm,tx-post-cursor	: Post-cursor emphasis taps control. Two set of
+			  3-tuple setting for Gen1, Gen2, and Gen3. Range is
+			  between 0 to 0x1f in unit of 18.2mV. Default is 0xf.
+- apm,tx-speed		: Tx operating speed. One set of 3-tuple for each
+			  supported link speed on the host.
+			   0 = 1-2Gbps
+			   1 = 2-4Gbps (1st tuple default)
+			   2 = 4-8Gbps
+			   3 = 8-15Gbps (2nd tuple default)
+			   4 = 2.5-4Gbps
+			   5 = 4-5Gbps
+			   6 = 5-6Gbps
+			   7 = 6-16Gbps (3rd tuple default)
+
+NOTE: PHY override parameters are board specific setting.
+
+Example:
+		phy1: phy@1f21a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f21a000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f23a000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+		};
-- 
1.5.5
