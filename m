From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 15/29] scsi: aacraid: Create helper functions to get lun info
Date: Thu, 21 Dec 2017 09:34:06 -0800
Message-ID: <20171221173420.8213-16-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0079.outbound.protection.outlook.com ([104.47.38.79]:32896
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754124AbdLUReo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:44 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Created inline function to retrieve lun info for each device from the
phy luns structure.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 59 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index affa2f1..83d2576 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1847,7 +1847,48 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
 mem_free_all:
 	kfree(phys_luns);
 	goto out;
+}
+
+static inline u32 aac_get_safw_phys_lun_count(struct aac_dev *dev)
+{
+	struct aac_ciss_phys_luns_resp *phys_luns;
+
+	phys_luns = dev->safw_phys_luns;
+
+	return ((phys_luns->list_length[0]<<24) +
+			(phys_luns->list_length[1]<<16) +
+			(phys_luns->list_length[2]<<8) +
+			(phys_luns->list_length[3])) / 24;
+}
 
+static inline u32 aac_get_safw_phys_bus(struct aac_dev *dev, int lun)
+{
+	return dev->safw_phys_luns->lun[lun].level2[1] & 0x3f;
+}
+
+static inline u32 aac_get_safw_phys_target(struct aac_dev *dev, int lun)
+{
+	return dev->safw_phys_luns->lun[lun].level2[0];
+}
+
+static inline u32 aac_get_safw_phys_expose_flag(struct aac_dev *dev, int lun)
+{
+	return dev->safw_phys_luns->lun[lun].bus >> 6;
+}
+
+static inline u32 aac_get_safw_phys_attribs(struct aac_dev *dev, int lun)
+{
+	return dev->safw_phys_luns->lun[lun].node_ident[9];
+}
+
+static inline u32 aac_get_safw_phys_nexus(struct aac_dev *dev, int lun)
+{
+	return *((u32 *)&dev->safw_phys_luns->lun[lun].node_ident[12]);
+}
+
+static inline u32 aac_get_safw_phys_device_type(struct aac_dev *dev, int lun)
+{
+	return dev->safw_phys_luns->lun[lun].node_ident[8];
 }
 
 /**
@@ -1865,22 +1906,16 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 	u32 i, bus, target;
 	u8 expose_flag, attribs;
 	u8 devtype;
-	struct aac_ciss_phys_luns_resp *phys_luns;
-
-	phys_luns = dev->safw_phys_luns;
 
-	lun_count = ((phys_luns->list_length[0] << 24)
-			+ (phys_luns->list_length[1] << 16)
-			+ (phys_luns->list_length[2] << 8)
-			+ (phys_luns->list_length[3])) / 24;
+	lun_count = aac_get_safw_phys_lun_count(dev);
 
 	for (i = 0; i < lun_count; ++i) {
 
-		bus = phys_luns->lun[i].level2[1] & 0x3f;
-		target = phys_luns->lun[i].level2[0];
-		expose_flag = phys_luns->lun[i].bus >> 6;
-		attribs = phys_luns->lun[i].node_ident[9];
-		nexus = *((u32 *) &phys_luns->lun[i].node_ident[12]);
+		bus = aac_get_safw_phys_bus(dev, i);
+		target = aac_get_safw_phys_target(dev, i);
+		expose_flag = aac_get_safw_phys_expose_flag(dev, i);
+		attribs = aac_get_safw_phys_attribs(dev, i);
+		nexus = aac_get_safw_phys_nexus(dev, i);
 
 		if (bus >= AAC_MAX_BUSES || target >= AAC_MAX_TARGETS)
 			continue;
-- 
2.9.4
