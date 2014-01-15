From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v7 2/4] Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
Date: Wed, 15 Jan 2014 00:10:38 -0700
Message-ID: <1389769840-15469-3-git-send-email-lho@apm.com>
References: <1389769840-15469-1-git-send-email-lho@apm.com>
 <1389769840-15469-2-git-send-email-lho@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389769840-15469-2-git-send-email-lho-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dmilburn-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 .../devicetree/bindings/phy/apm-xgene-phy.txt      |   94 ++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/apm-xgene-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/apm-xgene-phy.txt b/Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
new file mode 100644
index 0000000..4ffbae0
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
@@ -0,0 +1,94 @@
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
+			  Second PHY memory resource is the SDS PHY access
+			  resource outside of the IP if it is type
+			  "apm,xgene-phy-ext".
+- #phy-cells		: Shall be 1 as it expects one argument for setting
+			  the mode of the PHY. Possible values are 0 (SATA),
+			  1 (SGMII), 2 (PCIe), 3 (USB), and 4 (XFI).
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "disabled" if disabled.
+			  Default is "ok".
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
+			apm,tx-boost-gain = <2 2 2 2 2 2>;
+			apm,tx-eye-tuning = <10 10 10 10 10 10>;
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+			apm,tx-boost-gain = <2 2 2 2 2 2>;
+			apm,tx-eye-tuning = <10 10 10 5 5 5>;
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy-ext";
+			reg = <0x0 0x1f23a000 0x0 0x100>,
+			      <0x0 0x1f2d0000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+			apm,tx-boost-gain = <3 3 3 3 3 3>;
+			apm,tx-eye-tuning = <10 10 10 12 12 12>;
+		};
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
