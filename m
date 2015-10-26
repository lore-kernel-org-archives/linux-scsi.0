From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Mon, 26 Oct 2015 22:14:33 +0800
Message-ID: <1445868903-183817-3-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:6698 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbbJZOBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 10:01:47 -0400
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Add devicetree bindings for HiSilicon SAS driver.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 .../devicetree/bindings/scsi/hisilicon-sas.txt     | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
new file mode 100644
index 0000000..d1e7b2a
--- /dev/null
+++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
@@ -0,0 +1,70 @@
+* HiSilicon SAS controller
+
+The HiSilicon SAS controller supports SAS/SATA.
+
+Main node required properties:
+  - compatible : value should be as follows:
+	(a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS controller IP
+  - reg : Address and length of the SAS register
+  - hisilicon,sas-syscon: phandle of syscon used for sas control
+  - ctrl-reg : offset to the following SAS control registers (in order):
+		- reset assert
+		- clock disable
+		- reset status
+		- reset de-assert
+		- clock enable
+  - queue-count : number of delivery and completion queues in the controller
+  - phy-count : number of phys accessible by the controller
+  - interrupts : Interrupts for phys, completion queues, and fatal
+		 interrupts:
+		  - Each phy has 3 interrupt sources:
+			- broadcast
+			- phyup
+			- abnormal
+		  - Each completion queue has 1 interrupt source
+		  - Each controller has 2 fatal interrupt sources:
+			- ECC
+			- AXI bus
+
+* HiSilicon SAS syscon
+
+Required properties:
+- compatible: should be "hisilicon,sas-ctrl", "syscon"
+- reg: offset and length of the syscon sas-ctrl registers
+
+
+Example:
+	sas_ctrl0: sas_ctrl@c0000000 {
+		compatible = "hisilicon,sas-ctrl", "syscon";
+		reg = <0x0 0xc0000000 0x0 0x10000>;
+	};
+
+	sas0: sas@c1000000 {
+		compatible = "hisilicon,sas-controller-v1";
+		reg = <0x0 0xc1000000 0x0 0x10000>;
+		hisilicon,sas-syscon = <&sas_ctrl0>;
+		ctrl-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;
+		queue-count = <32>;
+		phy-count = <8>;
+		dma-coherent;
+		interrupt-parent = <&mbigen_dsa>;
+		interrupts = <259 4>, <263 4>,<264 4>,/* phy irq(0~79) */
+				<269 4>,<273 4>,<274 4>,/* phy irq(0~79) */
+				<279 4>,<283 4>,<284 4>,/* phy irq(0~79) */
+				<289 4>,<293 4>,<294 4>,/* phy irq(0~79) */
+				<299 4>,<303 4>,<304 4>,/* phy irq(0~79) */
+				<309 4>,<313 4>,<314 4>,/* phy irq(0~79) */
+				<319 4>,<323 4>,<324 4>,/* phy irq(0~79) */
+				<329 4>,<333 4>,<334 4>,/* phy irq(0~79) */
+				<336 1>,<337 1>,<338 1>,<339 1>,<340 1>,
+				<341 1>,<342 1>,<343 1>,/* cq irq (80~111) */
+				<344 1>,<345 1>,<346 1>,<347 1>,<348 1>,
+				<349 1>,<350 1>,<351 1>,/* cq irq (80~111) */
+				<352 1>,<353 1>,<354 1>,<355 1>,<356 1>,
+				<357 1>,<358 1>,<359 1>,/* cq irq (80~111) */
+				<360 1>,<361 1>,<362 1>,<363 1>,<364 1>,
+				<365 1>,<366 1>,<367 1>,/* cq irq (80~111) */
+				<376 4>,/* chip fatal error irq(120) */
+				<381 4>;/* chip fatal error irq(125) */
+		status = "disabled";
+	};
-- 
1.9.1

