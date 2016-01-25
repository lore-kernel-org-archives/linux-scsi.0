From: John Garry <john.garry@huawei.com>
Subject: [RESEND PATCH v2 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Tue, 26 Jan 2016 02:47:01 +0800
Message-ID: <1453747643-61875-2-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add the dt bindings for HiSi SAS controller v2 HW.

The main difference in the controller from dt perspective
is interrupts. The v2 controller does not have dedicated
fatal and broadcast interrupts - they are multiplexed on
the channel interrupt.

Each SAS v2 controller can issue upto 64 commands
(or connection requests) on the system bus without waiting
for a response - this is know as am-max-transmissions.
In hip06, sas controller #1 has a limitation that it has to
limit am-max-transmissions to 32 - this limitation is due
to chip system bus design. It is not anticipated that any
future chip incorporating v2 controller will have such a
limitation.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 .../devicetree/bindings/scsi/hisilicon-sas.txt      | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
index f67e761..f3da463 100644
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
@@ -13,7 +14,7 @@ Main node required properties:
   - ctrl-clock-ena-reg : offset to controller clock enable register in ctrl reg
   - queue-count : number of delivery and completion queues in the controller
   - phy-count : number of phys accessible by the controller
-  - interrupts : Interrupts for phys, completion queues, and fatal
+  - interrupts : For v1 hw: Interrupts for phys, completion queues, and fatal
 		sources; the interrupts are ordered in 3 groups, as follows:
 			- Phy interrupts
 			- Completion queue interrupts
@@ -30,6 +31,24 @@ Main node required properties:
 		Fatal interrupts : the fatal interrupts are ordered as follows:
 			- ECC
 			- AXI bus
+		For v2 hw: Interrupts for phys, Sata, and completion queues;
+		the interrupts are ordered in 3 groups, as follows:
+			- Phy interrupts
+			- Sata interrupts
+			- Completion queue interrupts
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
+ - hip06-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
+			    "am-max-transmissions" limitation.
 
 Example:
 	sas0: sas@c1000000 {
-- 
1.9.1
