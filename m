From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/5] scsi: hisi_sas: Add support for interrupt coalescing for v3 hw
Date: Fri, 9 Nov 2018 22:06:34 +0800
Message-ID: <1541772396-161814-4-git-send-email-john.garry@huawei.com>
References: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If INT_COAL_EN is enabled, config time and count of interrupt coalescing.
Then if CQ collects count of CQ entries in time, it will report the
interrupt. Or if CQ doesn't collect enough CQ entries in time, it Will
report the interrupt at timeout.

As all the registers are not supported to be changed dynamically, so
need to config those register between disable and enable PHYs.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   2 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 100 +++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 94a9e13..535c613 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -322,6 +322,8 @@ struct hisi_hba {
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
 	struct work_struct rst_work;
 	u32 phy_state;
+	u32 intr_coal_ticks;	/* Time of interrupt coalesce in us */
+	u32 intr_coal_count;	/* Interrupt count to coalesce */
 };
 
 /* Generic HW DMA host memory structures */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 10d1651..0c3fa43 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2107,9 +2107,109 @@ static ssize_t intr_conv_v3_hw_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(intr_conv_v3_hw);
 
+static void config_intr_coal_v3_hw(struct hisi_hba *hisi_hba)
+{
+	/* config those registers between enable and disable PHYs */
+	hisi_sas_stop_phys(hisi_hba);
+
+	if (hisi_hba->intr_coal_ticks == 0 ||
+	    hisi_hba->intr_coal_count == 0) {
+		hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
+		hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
+		hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
+	} else {
+		hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x3);
+		hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME,
+				 hisi_hba->intr_coal_ticks);
+		hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT,
+				 hisi_hba->intr_coal_count);
+	}
+	phys_init_v3_hw(hisi_hba);
+}
+
+static ssize_t intr_coal_ticks_v3_hw_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 hisi_hba->intr_coal_ticks);
+}
+
+static ssize_t intr_coal_ticks_v3_hw_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	u32 intr_coal_ticks;
+	int ret;
+
+	ret = kstrtou32(buf, 10, &intr_coal_ticks);
+	if (ret) {
+		dev_err(dev, "Input data of interrupt coalesce unmatch\n");
+		return -EINVAL;
+	}
+
+	if (intr_coal_ticks >= BIT(24)) {
+		dev_err(dev, "intr_coal_ticks must be less than 2^24!\n");
+		return -EINVAL;
+	}
+
+	hisi_hba->intr_coal_ticks = intr_coal_ticks;
+
+	config_intr_coal_v3_hw(hisi_hba);
+
+	return count;
+}
+static DEVICE_ATTR_RW(intr_coal_ticks_v3_hw);
+
+static ssize_t intr_coal_count_v3_hw_show(struct device *dev,
+					  struct device_attribute
+					  *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 hisi_hba->intr_coal_count);
+}
+
+static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
+		struct device_attribute
+		*attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	u32 intr_coal_count;
+	int ret;
+
+	ret = kstrtou32(buf, 10, &intr_coal_count);
+	if (ret) {
+		dev_err(dev, "Input data of interrupt coalesce unmatch\n");
+		return -EINVAL;
+	}
+
+	if (intr_coal_count >= BIT(8)) {
+		dev_err(dev, "intr_coal_count must be less than 2^8!\n");
+		return -EINVAL;
+	}
+
+	hisi_hba->intr_coal_count = intr_coal_count;
+
+	config_intr_coal_v3_hw(hisi_hba);
+
+	return count;
+}
+static DEVICE_ATTR_RW(intr_coal_count_v3_hw);
+
 struct device_attribute *host_attrs_v3_hw[] = {
 	&dev_attr_phy_event_threshold,
 	&dev_attr_intr_conv_v3_hw,
+	&dev_attr_intr_coal_ticks_v3_hw,
+	&dev_attr_intr_coal_count_v3_hw,
 	NULL
 };
 
-- 
1.9.1
