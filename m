From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 4/7] dt-bindings: phy: Add document for phy-mtk-ufs
Date: Thu, 14 Mar 2019 12:08:33 +0800
Message-ID: <1552536516-12723-6-git-send-email-stanley.chu@mediatek.com>
References: <1552536516-12723-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552536516-12723-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, yingjoe.chen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Add UFS M-PHY node document for MediaTek SoC chips.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 .../devicetree/bindings/phy/phy-mtk-ufs.txt   | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
new file mode 100644
index 000000000000..74b5e6baa605
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
@@ -0,0 +1,38 @@
+MediaTek Universal Flash Storage (UFS) M-PHY binding
+--------------------------------------------------------
+
+UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
+Each UFS M-PHY node should have its own node.
+
+To bind UFS M-PHY with UFS host controller, the controller node should
+contain a phandle reference to UFS M-PHY node.
+
+Required properties for UFS M-PHY nodes:
+- compatible         : Compatible list, contains the following controller:
+                       "mediatek,mt8183-ufsphy" for ufs phy
+                       persent on MT81xx chipsets.
+- reg                : Address and length of the UFS M-PHY register set.
+- #phy-cells         : This property shall be set to 0.
+- clocks             : List of phandle and clock specifier pairs.
+- clock-names        : List of clock input name strings sorted in the same
+                       order as the clocks property. Following clocks are
+                       mandatory.
+                       "unipro": Unipro core control clock.
+                       "mp": M-PHY core control clock.
+
+Example:
+
+	ufsphy: phy@11fa0000 {
+		compatible = "mediatek,mt8183-ufsphy";
+		reg = <0 0x11fa0000 0 0xc000>;
+		#phy-cells = <0>;
+
+		clocks = <&infracfg_ao INFRACFG_AO_UNIPRO_SCK_CG>,
+			 <&infracfg_ao INFRACFG_AO_UFS_MP_SAP_BCLK_CG>;
+		clock-names = "unipro", "mp";
+	};
+
+	ufshci@11270000 {
+		...
+		phys = <&ufsphy>;
+	};
-- 
2.18.0
