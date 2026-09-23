Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F7B48FF8C;
	Wed, 23 Sep 2026 19:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790190917; cv=none; b=l9ZvlQsy44L9JAoy6e3wKXBiWafhaIQYwZtnfbpji+bJ0tDUCt+njk2cOb/CIBO2RV8wsUKQBkG+Zx52F90Y62DLeby192xbTlzdpqnH4orLRiZ1yRMxnPQ6ze/Oy5/zALN5oyIheCI8sUdhkR7zvAQoqSG3kGgvR3n0CsCTHBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790190917; c=relaxed/simple;
	bh=XK6kTKxoEhbWk0ruiXDuOzrQVZRw4qw9TJ7CxZ1/Rkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YgsaxbLK7kq0GmsktLAWhzWnRmBKB7GMSHwf/slqilQTjnodXNPPTzh/Ia9lMsN6Zczc5LSgOhxaZ2vZnNfcjUm6douqo2QZdWHaCrHypLebz9IRVNZgVTc5UgNZBqwOH201PXbtCS66jGFlE4tH28/LR0YgozXOhYW3OFsk/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYJZhenP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYJZhenP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A090D1F00893;
	Wed, 23 Sep 2026 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790190915;
	bh=3Y1y4VrTKcT8bGuAKsLBgtA9V/g9miBITIm9ZUJW3gU=;
	h=From:To:Cc:Subject:Date;
	b=VYJZhenPiIOv+y6cCVWb0WF5eZSB6CQWXTK/4lp54Jr1RGX5y/CMrH3/hGV3+esLE
	 RLSVmFYyL7Fri/PADGnXueJ1dNP8hZx8y2i+kKnWoIlyO9cTXLAX4/4tSj7keJ1IAw
	 LXckAHcDbKE/TZnlvbUhu4n4SfXhCzeDlBPkISFLTEg8V8tzGjaRHbs2gS365dWVeG
	 ajLvU6YFgACG7ms7ozB0xuXQ8Wj5/uPw02B7W8H62xgbmgD4XpySK/ZuB+ISrz+ml5
	 Q5ichN54V4rGrz3JzAYXlNIkjiVRezwp1vVvAqcjKR00z50pCFXJlypQE1DfLsEu5m
	 PTQjK6iFxca9A==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Xingui Yang <yangxingui@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] dt-bindings: scsi: Convert hisilicon,hip05-sas-v1 to DT schema
Date: Wed, 23 Sep 2026 14:15:10 -0500
Message-ID: <20260923191511.2205564-1-robh@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the HiSilicon SAS controller binding to DT schema. It's a
straight forward conversion.

Assisted-by: LLM
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Fix truncated interrupts and add back descriptions
 - Fix syscon offset descriptions
---
 .../bindings/scsi/hisilicon,hip05-sas-v1.yaml | 158 ++++++++++++++++++
 .../bindings/scsi/hisilicon-sas.txt           |  98 -----------
 MAINTAINERS                                   |   2 +-
 3 files changed, 159 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
 delete mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml b/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
new file mode 100644
index 000000000000..27d4cf5078e6
--- /dev/null
+++ b/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
@@ -0,0 +1,158 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/scsi/hisilicon,hip05-sas-v1.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: HiSilicon SAS controller
+
+maintainers:
+  - Xingui Yang <yangxingui@huawei.com>
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - hisilicon,hip05-sas-v1
+          - hisilicon,hip06-sas-v2
+          - hisilicon,hip07-sas-v2
+
+  reg:
+    minItems: 1
+    items:
+      - description: SAS registers
+      - description: CPLD SGPIO control registers
+
+  clocks:
+    minItems: 1
+    maxItems: 2
+
+  dma-coherent: true
+
+  interrupts:
+    description: >
+      Interrupt specifiers for PHY, SATA, and completion queues; ordering and
+      number depend on controller version.
+
+      For v1 hw: Interrupts for phys, completion queues, and fatal
+      sources; the interrupts are ordered in 3 groups, as follows:
+
+        - Phy interrupts - Each phy has 3 interrupt sources:
+            - broadcast
+            - phyup
+            - abnormal
+          The phy interrupts are ordered into groups of 3 per phy
+          (broadcast, phyup, and abnormal) in increasing order.
+        - Completion queue interrupts - each completion queue has 1 interrupt
+          source.
+        - Fatal interrupts - the fatal interrupts are ordered as follows:
+            - ECC
+            - AXI bus
+
+      For v2 hw: Interrupts for phys, Sata, and completion queues;
+      the interrupts are ordered in 3 groups, as follows:
+
+        - Phy interrupts - Each controller has 2 phy interrupts:
+            - phy up/down
+            - channel interrupt
+        - Sata interrupts - Each phy on the controller has 1 Sata interrupt.
+        - Completion queue interrupts - each completion queue has 1 interrupt
+          source
+    minItems: 58
+    maxItems: 128
+
+  ctrl-reset-reg:
+    description: Offset to controller reset register in SAS syscon region.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  ctrl-reset-sts-reg:
+    description: Offset to controller reset status register in SAS syscon region.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  ctrl-clock-ena-reg:
+    description: Offset to controller clock enable register in SAS syscon region.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  hip06-sas-v2-quirk-amt:
+    description:
+      Indicates that the v2 controller has the "am-max-transmissions" limitation.
+    type: boolean
+
+  hisilicon,sas-syscon:
+    description: Phandle of syscon used for SAS control.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+  hisilicon,signal-attenuation:
+    description:
+      De-emphasis, preshoot, and boost attenuation readings for the board,
+      used to calculate signal attenuation (y = (x-10000)/10000).
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 3
+    maxItems: 3
+    items:
+      minimum: 7600
+      maximum: 12400
+
+  phy-count:
+    description: Number of PHYs accessible by the controller.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  queue-count:
+    description: Number of delivery and completion queues in the controller.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  sas-addr:
+    description: SAS address, array of 8 bytes representing host SAS address.
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    minItems: 8
+    maxItems: 8
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - ctrl-reset-reg
+  - ctrl-reset-sts-reg
+  - ctrl-clock-ena-reg
+  - hisilicon,sas-syscon
+  - phy-count
+  - queue-count
+  - sas-addr
+
+additionalProperties: false
+
+examples:
+  - |
+    sas@c1000000 {
+        compatible = "hisilicon,hip05-sas-v1";
+        reg = <0xc1000000 0x10000>;
+        dma-coherent;
+        interrupts = <259 4>, <263 4>, <264 4>, /* phy0 */
+                     <269 4>, <273 4>, <274 4>, /* phy1 */
+                     <279 4>, <283 4>, <284 4>, /* phy2 */
+                     <289 4>, <293 4>, <294 4>, /* phy3 */
+                     <299 4>, <303 4>, <304 4>, /* phy4 */
+                     <309 4>, <313 4>, <314 4>, /* phy5 */
+                     <319 4>, <323 4>, <324 4>, /* phy6 */
+                     <329 4>, <333 4>, <334 4>, /* phy7 */
+                     <336 1>, <337 1>, <338 1>, /* cq0-2 */
+                     <339 1>, <340 1>, <341 1>, /* cq3-5 */
+                     <342 1>, <343 1>, <344 1>, /* cq6-8 */
+                     <345 1>, <346 1>, <347 1>, /* cq9-11 */
+                     <348 1>, <349 1>, <350 1>, /* cq12-14 */
+                     <351 1>, <352 1>, <353 1>, /* cq15-17 */
+                     <354 1>, <355 1>, <356 1>, /* cq18-20 */
+                     <357 1>, <358 1>, <359 1>, /* cq21-23 */
+                     <360 1>, <361 1>, <362 1>, /* cq24-26 */
+                     <363 1>, <364 1>, <365 1>, /* cq27-29 */
+                     <366 1>, <367 1>,          /* cq30-31 */
+                     <376 4>,                   /* fatal ecc */
+                     <381 4>;                   /* fatal axi */
+        ctrl-reset-reg = <0xa60>;
+        ctrl-reset-sts-reg = <0x5a30>;
+        ctrl-clock-ena-reg = <0x338>;
+        hisilicon,sas-syscon = <&pcie_sas>;
+        queue-count = <32>;
+        phy-count = <8>;
+        sas-addr = [50 01 88 20 16 00 00 0a];
+    };
diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
deleted file mode 100644
index 8c6659ed2cfc..000000000000
--- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+++ /dev/null
@@ -1,98 +0,0 @@
-* HiSilicon SAS controller
-
-The HiSilicon SAS controller supports SAS/SATA.
-
-Main node required properties:
-  - compatible : value should be as follows:
-	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
-	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
-	(c) "hisilicon,hip07-sas-v2" for v2 hw in hip07 chipset
-  - sas-addr : array of 8 bytes for host SAS address
-  - reg : Contains two regions. The first is the address and length of the SAS
-          register. The second is the address and length of CPLD register for
-          SGPIO control. The second is optional, and should be set only when
-          we use a CPLD for directly attached disk LED control.
-  - hisilicon,sas-syscon: phandle of syscon used for sas control
-  - ctrl-reset-reg : offset to controller reset register in ctrl reg
-  - ctrl-reset-sts-reg : offset to controller reset status register in ctrl reg
-  - ctrl-clock-ena-reg : offset to controller clock enable register in ctrl reg
-  - queue-count : number of delivery and completion queues in the controller
-  - phy-count : number of phys accessible by the controller
-  - interrupts : For v1 hw: Interrupts for phys, completion queues, and fatal
-		sources; the interrupts are ordered in 3 groups, as follows:
-			- Phy interrupts
-			- Completion queue interrupts
-			- Fatal interrupts
-		Phy interrupts : Each phy has 3 interrupt sources:
-			- broadcast
-			- phyup
-			- abnormal
-		The phy interrupts are ordered into groups of 3 per phy
-		(broadcast, phyup, and abnormal) in increasing order.
-		Completion queue interrupts : each completion queue has 1
-			interrupt source.
-			The interrupts are ordered in increasing order.
-		Fatal interrupts : the fatal interrupts are ordered as follows:
-			- ECC
-			- AXI bus
-		For v2 hw: Interrupts for phys, Sata, and completion queues;
-		the interrupts are ordered in 3 groups, as follows:
-			- Phy interrupts
-			- Sata interrupts
-			- Completion queue interrupts
-		Phy interrupts : Each controller has 2 phy interrupts:
-			- phy up/down
-			- channel interrupt
-		Sata interrupts : Each phy on the controller has 1 Sata
-			interrupt. The interrupts are ordered in increasing
-			order.
-		Completion queue interrupts : each completion queue has 1
-			interrupt source. The interrupts are ordered in
-			increasing order.
-
-Optional main node properties:
- - hip06-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
-			    "am-max-transmissions" limitation.
- - hisilicon,signal-attenuation : array of 3 32-bit values, containing de-emphasis,
-		preshoot, and boost attenuation readings for the board. They
-		are used to describe the signal attenuation of the board. These
-		values' range is 7600 to 12400, and used to represent -24dB to
-		24dB.
-		The formula is "y = (x-10000)/10000". For example, 10478
-		means 4.78dB.
-
-Example:
-	sas0: sas@c1000000 {
-		compatible = "hisilicon,hip05-sas-v1";
-		sas-addr = [50 01 88 20 16 00 00 0a];
-		reg = <0x0 0xc1000000 0x0 0x10000>;
-		hisilicon,sas-syscon = <&pcie_sas>;
-		ctrl-reset-reg = <0xa60>;
-		ctrl-reset-sts-reg = <0x5a30>;
-		ctrl-clock-ena-reg = <0x338>;
-		queue-count = <32>;
-		phy-count = <8>;
-		dma-coherent;
-		interrupt-parent = <&mbigen_dsa>;
-		interrupts =    <259 4>,<263 4>,<264 4>,/* phy0 */
-				<269 4>,<273 4>,<274 4>,/* phy1 */
-				<279 4>,<283 4>,<284 4>,/* phy2 */
-				<289 4>,<293 4>,<294 4>,/* phy3 */
-				<299 4>,<303 4>,<304 4>,/* phy4 */
-				<309 4>,<313 4>,<314 4>,/* phy5 */
-				<319 4>,<323 4>,<324 4>,/* phy6 */
-				<329 4>,<333 4>,<334 4>,/* phy7 */
-				<336 1>,<337 1>,<338 1>,/* cq0-2 */
-				<339 1>,<340 1>,<341 1>,/* cq3-5 */
-				<342 1>,<343 1>,<344 1>,/* cq6-8 */
-				<345 1>,<346 1>,<347 1>,/* cq9-11 */
-				<348 1>,<349 1>,<350 1>,/* cq12-14 */
-				<351 1>,<352 1>,<353 1>,/* cq15-17 */
-				<354 1>,<355 1>,<356 1>,/* cq18-20 */
-				<357 1>,<358 1>,<359 1>,/* cq21-23 */
-				<360 1>,<361 1>,<362 1>,/* cq24-26 */
-				<363 1>,<364 1>,<365 1>,/* cq27-29 */
-				<366 1>,<367 1>/* cq30-31 */
-				<376 4>,/* fatal ecc */
-				<381 4>;/* fatal axi */
-	};
diff --git a/MAINTAINERS b/MAINTAINERS
index dccddc99ac9a..9cae1650167b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11997,7 +11997,7 @@ HISILICON SAS Controller
 M:	Xingui Yang <yangxingui@huawei.com>
 S:	Supported
 W:	http://www.hisilicon.com
-F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+F:	Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
 F:	drivers/scsi/hisi_sas/
 
 HISILICON SECURITY ENGINE V2 DRIVER (SEC2)
-- 
2.53.0

