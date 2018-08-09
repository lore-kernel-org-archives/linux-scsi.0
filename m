From: Janek Kotas <jank@cadence.com>
Subject: [PATCH v3 1/2] dt-bindings: ufs: Add bindings for Cadence UFS
Date: Thu, 9 Aug 2018 13:25:15 +0000
Message-ID: <F39BF38C-FD85-4115-975C-8D923518A541@global.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <6FDA65D15228A2438FC47A36059969F2@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "robh+dt@kernel.org" <robh+dt@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds a DT binding documentation for
Cadence UFS Host Controller.

Signed-off-by: Jan Kotas <jank@cadence.com>
---
 .../devicetree/bindings/ufs/cdns,ufshc.txt         | 31 ++++++++++++++++++=
++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt

diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documen=
tation/devicetree/bindings/ufs/cdns,ufshc.txt
new file mode 100644
index 00000000..a04a4989
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
@@ -0,0 +1,31 @@
+* Cadence Universal Flash Storage (UFS) Controller
+
+UFS nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+Please see the ufshcd-pltfrm.txt for a list of all available properties.
+
+Required properties:
+- compatible	: Compatible list, contains the following controller:
+			"cdns,ufshc"
+		  complemented with the JEDEC version:
+			"jedec,ufs-2.0"
+
+- reg		: Address and length of the UFS register set.
+- interrupts	: One interrupt mapping.
+- freq-table-hz	: Clock frequency table.
+		  See the ufshcd-pltfrm.txt for details.
+- clocks	: List of phandle and clock specifier pairs.
+- clock-names	: List of clock input name strings sorted in the same
+		  order as the clocks property. "core_clk" is mandatory.
+		  Depending on a type of a PHY,
+		  the "phy_clk" clock can also be added, if needed.
+
+Example:
+	ufs@fd030000 {
+		compatible =3D "cdns,ufshc", "jedec,ufs-2.0";
+		reg =3D <0xfd030000 0x10000>;
+		interrupts =3D <0 1 IRQ_TYPE_LEVEL_HIGH>;
+		freq-table-hz =3D <0 0>, <0 0>;
+		clocks =3D <&ufs_core_clk>, <&ufs_phy_clk>;
+		clock-names =3D "core_clk", "phy_clk";
+	};
--=20
2.15.0
