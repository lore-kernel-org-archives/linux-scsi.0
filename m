From: John Garry <john.garry@huawei.com>
Subject: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Fri, 8 Jan 2016 22:15:20 +0800
Message-ID: <1452262542-64589-2-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add the dt bindings for HiSi SAS controller v2 HW.

The main difference in the controllers from dt perspective
is interrupts.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 .../devicetree/bindings/scsi/hisilicon-sas.txt       | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
index 0a7a325..2695023 100644
--- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
@@ -5,6 +5,7 @@ The HiSilicon SAS controller supports SAS/SATA.
 Main node required properties:
   - compatible : value should be as follows:
 	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
+	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
   - sas-addr : array of 8 bytes for host SAS address
   - reg : Address and length of the SAS register
   - hisilicon,sas-syscon: phandle of syscon used for sas control
@@ -13,11 +14,11 @@ Main node required properties:
   - ctrl-clock-ena-reg : offset to controller clock enable register in ctrl reg
   - queue-count : number of delivery and completion queues in the controller
   - phy-count : number of phys accessible by the controller
-  - interrupts : Interrupts for phys, completion queues, and fatal
+  - interrupts : For v1 hw: Interrupts for phys, completion queues, and fatal
 		sources; the interrupts are ordered in 3 groups, as follows:
-			- Phy interrupts
-			- Completion queue interrupts
-			- Fatal interrupts
+		  - Phy interrupts
+		  - Completion queue interrupts
+		  - Fatal interrupts
 		Phy interrupts : Each phy has 3 interrupt sources:
 			- broadcast
 			- phyup
@@ -25,11 +26,28 @@ Main node required properties:
 		The phy interrupts are ordered into groups of 3 per phy
 		(broadcast, phyup, and abnormal) in increasing order.
 		Completion queue interrupts : each completion queue has 1
-			interrupt source.
-			The interrupts are ordered in increasing order.
+			interrupt source. The interrupts are ordered in
+			increasing order.
 		Fatal interrupts : the fatal interrupts are ordered as follows:
 			- ECC
 			- AXI bus
+		For v2 hw: Interrupts for phys, Sata, and completion queues;
+		the interrupts are ordered in 3 groups, as follows:
+		  - Phy interrupts
+		  - Sata interrupts
+		  - Completion queue interrupts
+		Phy interrupts : Each controller has 2 phy interrupts:
+			- phy up/down
+			- channel interrupt
+		Sata interrupts : Each phy on the controller has 1 Sata
+			interrupt. The interrupts are ordered in increasing
+			order.
+		Completion queue interrupts : each completion queue has 1
+			interrupt source. The interrupts are ordered in
+			increasing order.
+
+Optional main node properties:
+ - am-max-trans : limit controller for am max transmissions
 
 Example:
 	sas0: sas@c1000000 {
-- 
1.9.1
