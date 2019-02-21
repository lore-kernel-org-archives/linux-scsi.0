From: <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 1/2] dt-bindings: scsi: ufs: Add document for ufs-mediatek
Date: Thu, 21 Feb 2019 17:50:36 +0800
Message-ID: <1550742637-12385-3-git-send-email-stanley.chu@mediatek.com>
References: <1550742637-12385-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1550742637-12385-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

Add UFS and UFS PHY node document for Mediatek SoC chips.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 .../devicetree/bindings/ufs/ufs-mediatek.txt  | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-mediatek.txt

diff --git a/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt b/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
new file mode 100644
index 000000000000..c09a4f884bea
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
@@ -0,0 +1,62 @@
+* Mediatek Universal Flash Storage (UFS) Host Controller
+
+UFS nodes are defined to describe on-chip UFS hardware macro.
+Each UFS Host Controller should have its own node.
+
+UFS PHY nodes are defined to describe on-chip UFS PHY hardware macro.
+Each UFS PHY node should have its own node.
+
+Required properties for UFS nodes:
+- compatible         : Compatible list, contains the following controller:
+                       "mediatek,ufshci"
+- reg                : Address and length of the UFS register set.
+- interrupt-parent   : interrupt device.
+- interrupts         : interrupt number.
+- clocks             : List of phandle and clock specifier pairs.
+- clock-names        : List of clock input name strings sorted in the same
+                       order as the clocks property. "ufs0-clock", "ufs0-unipro-clk" and
+                       "ufs0-mp-clk" are mandatory.
+- freq-table-hz      : Array of <min max> operating frequencies stored in the same
+                       order as the clocks property. If this property is not
+                       defined or a value in the array is "0" then it is assumed
+                       that the frequency is set by the parent clock or a
+                       fixed rate clock source.
+- vcc-supply         : Power to the UFS device.
+- vcc-fixed-regulator: Specify that vcc-supply is a fixed regulator.
+- lanes-per-direction: Number of lanes available per direction. Shall be 1.
+
+Required properties for UFS PHY nodes:
+- compatible         : Compatible list, contains the following controller:
+                       "mediatek,ufs_mphy"
+- reg                : Address and length of the UFS PHY register set.
+
+Example:
+
+	ufshci:ufshci@11270000 {
+		compatible = "mediatek,ufshci";
+		reg = <0 0x11270000 0 0x2300>;
+		interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_LOW>;
+
+		clocks =
+			<&infracfg_ao INFRACFG_AO_UFS_CG>,
+			<&infracfg_ao INFRACFG_AO_UNIPRO_SCK_CG>,
+			<&infracfg_ao INFRACFG_AO_UFS_MP_SAP_BCLK_CG>;
+		clock-names =
+			"ufs0-clock",
+			"ufs0-unipro-clk",
+			"ufs0-mp-clk";
+		freq-table-hz =
+			<0 0>,
+			<0 0>,
+			<0 0>;
+
+		vcc-supply = <&mt_pmic_vemc_ldo_reg>;
+		vcc-fixed-regulator;
+
+		lanes-per-direction = <1>;
+	};
+
+	ufs_mphy@11fa0000 {
+		compatible = "mediatek,ufs_mphy";
+		reg = <0 0x11fa0000 0 0xc000>;
+	};
-- 
2.18.0
