From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/8] dt-bindings: scsi: hisi_sas: add an property of signal attenuation
Date: Fri, 2 Mar 2018 23:06:15 +0800
Message-ID: <1520003182-26277-2-git-send-email-john.garry@huawei.com>
References: <1520003182-26277-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520003182-26277-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

For some new boards with hip07 chipset we are required to
set PHY config registers differently. The hw property which
determines how to set these registers is in the PHY signal
attenuation readings.

This patch add an devicetree property, hisi-signal-attenuation,
which is used to describe the signal attenuation of an board.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
index df3bef7..6f6876a 100644
--- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
@@ -53,6 +53,13 @@ Main node required properties:
 Optional main node properties:
  - hip06-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
 			    "am-max-transmissions" limitation.
+ - hisi-signal-attenuation : array of 3 32-bit values, containing de-emphasis,
+		preshoot, and boost attenuation readings for the board. They
+		are used to describe the signal attenuation of the board. These
+		values' range is 7600 to 12400, and used to represent -24dB to
+		24dB.
+		The formula is "y = (x-10000)/10000". For example, 10478
+		means 4.78dB.
 
 Example:
 	sas0: sas@c1000000 {
-- 
1.9.1
