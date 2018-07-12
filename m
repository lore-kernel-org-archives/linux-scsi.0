From: Janek Kotas <jank@cadence.com>
Subject: [PATCH v2 1/2] dt-bindings: ufs: Add UFS platform driver for Cadence
 UFS
Date: Thu, 12 Jul 2018 11:58:04 +0000
Message-ID: <B652B768-D5BC-460F-B0A4-64A2A76064CC@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <7BB539BA0F3B754E9C2006A6E5D380F1@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "robh+dt@kernel.org" <robh+dt@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds a device tree platform
driver description for Cadence UFS Controller.

Signed-off-by: Jan Kotas <jank@cadence.com>
---
 .../devicetree/bindings/ufs/cdns,ufshc.txt         | 31 ++++++++++++++++++=
++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt

diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documen=
tation/devicetree/bindings/ufs/cdns,ufshc.txt
new file mode 100644
index 0000000..cb6d62a
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
@@ -0,0 +1,31 @@
+* Cadence Universal Flash Storage (UFS) Controller
+
+UFS nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible	: compatible list, contains the following controller:
+			"cdns,ufshc"
+		  complemented with the JEDEC version:
+			"jedec,ufs-2.0"
+
+- reg		: address and length of the UFS register set
+- interrupts	: one interrupt mapping
+- clocks	: List of phandle and clock specifier pairs.
+- clock-names	: List of clock input name strings sorted in the same
+		  order as the clocks property. "core" is mandatory.
+- freq-table-hz	: Array of <min max> operating frequencies stored in the s=
ame
+		  order as the clocks property. If this property is not
+		  defined or a value in the array is "0" then it is assumed
+		  that the frequency is set by the parent clock or a
+		  fixed rate clock source.
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
1.9.0
