From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/6] scsi: hisi_sas: Send HARD RESET to clear the previous affiliation of STP target port
Date: Thu, 28 Feb 2019 22:51:01 +0800
Message-ID: <1551365462-128193-6-git-send-email-john.garry@huawei.com>
References: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If we exchange SAS expander from one SAS controller to other SAS
controller without powering it down, the STP target port will maintain
previous affiliation and reject all subsequent connection requests from
other STP initiator ports with OPEN_REJECT (STP RESOURCES BUSY).

To solve this issue, send HARD RESET to clear the previous affiliation of
STP target port according to SPL (chapter 6.19.4).

We (re-)introduce dev status flag to know if to sleep in NEXUS reset code
or not for remote PHYs. The idea is that if the device is being
initialised, we don't require the delay, and caller would wait for link to
be established, cf. sas_ata_hard_reset().

Co-developed-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  7 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 44 ++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  1 +
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 515aee9318a4..9bfa9f12d81e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -18,6 +18,7 @@
 #include <linux/dmapool.h>
 #include <linux/iopoll.h>
 #include <linux/lcm.h>
+#include <linux/libata.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
@@ -94,6 +95,11 @@ enum {
 	PORT_TYPE_SATA = (1U << 0),
 };
 
+enum dev_status {
+	HISI_SAS_DEV_INIT,
+	HISI_SAS_DEV_NORMAL,
+};
+
 enum {
 	HISI_SAS_INT_ABT_CMD = 0,
 	HISI_SAS_INT_ABT_DEV = 1,
@@ -195,6 +201,7 @@ struct hisi_sas_device {
 	struct hisi_sas_dq	*dq;
 	struct list_head	list;
 	enum sas_device_type	dev_type;
+	enum dev_status dev_status;
 	int device_id;
 	int sata_idx;
 	spinlock_t lock; /* For protecting slots */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d8204bc3931b..d12924256964 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -708,6 +708,7 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 
 			hisi_hba->devices[i].device_id = i;
 			sas_dev = &hisi_hba->devices[i];
+			sas_dev->dev_status = HISI_SAS_DEV_INIT;
 			sas_dev->dev_type = device->dev_type;
 			sas_dev->hisi_hba = hisi_hba;
 			sas_dev->sas_device = device;
@@ -732,6 +733,8 @@ static int hisi_sas_init_device(struct domain_device *device)
 	struct hisi_sas_tmf_task tmf_task;
 	int retry = HISI_SAS_SRST_ATA_DISK_CNT;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct device *dev = hisi_hba->dev;
+	struct sas_phy *local_phy;
 
 	switch (device->dev_type) {
 	case SAS_END_DEVICE:
@@ -747,6 +750,31 @@ static int hisi_sas_init_device(struct domain_device *device)
 	case SAS_SATA_PM:
 	case SAS_SATA_PM_PORT:
 	case SAS_SATA_PENDING:
+		/*
+		 * send HARD RESET to clear previous affiliation of
+		 * STP target port
+		 */
+		local_phy = sas_get_local_phy(device);
+		if (!scsi_is_sas_phy_local(local_phy)) {
+			unsigned long deadline = ata_deadline(jiffies, 20000);
+			struct sata_device *sata_dev = &device->sata_dev;
+			struct ata_host *ata_host = sata_dev->ata_host;
+			struct ata_port_operations *ops = ata_host->ops;
+			struct ata_port *ap = sata_dev->ap;
+			struct ata_link *link;
+			unsigned int classes;
+
+			ata_for_each_link(link, ap, EDGE)
+				rc = ops->hardreset(link, &classes,
+						    deadline);
+		}
+		sas_put_local_phy(local_phy);
+		if (rc) {
+			dev_warn(dev, "SATA disk hardreset fail: 0x%x\n",
+				 rc);
+			return rc;
+		}
+
 		while (retry-- > 0) {
 			rc = hisi_sas_softreset_ata_disk(device);
 			if (!rc)
@@ -809,6 +837,7 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	rc = hisi_sas_init_device(device);
 	if (rc)
 		goto err_out;
+	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
 	return 0;
 
 err_out:
@@ -1715,20 +1744,23 @@ static int hisi_sas_clear_aca(struct domain_device *device, u8 *lun)
 static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 {
 	struct sas_phy *local_phy = sas_get_local_phy(device);
-	int rc, reset_type = (device->dev_type == SAS_SATA_DEV ||
-			(device->tproto & SAS_PROTOCOL_STP)) ? 0 : 1;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[local_phy->number];
 	struct hisi_sas_phy *phy = container_of(sas_phy,
 			struct hisi_sas_phy, sas_phy);
 	DECLARE_COMPLETION_ONSTACK(phyreset);
+	int rc, reset_type;
 
 	if (scsi_is_sas_phy_local(local_phy)) {
 		phy->in_reset = 1;
 		phy->reset_completion = &phyreset;
 	}
 
+	reset_type = (sas_dev->dev_status == HISI_SAS_DEV_INIT ||
+		      !dev_is_sata(device)) ? 1 : 0;
+
 	rc = sas_phy_reset(local_phy, reset_type);
 	sas_put_local_phy(local_phy);
 
@@ -1744,8 +1776,13 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 		/* report PHY down if timed out */
 		if (!ret)
 			hisi_sas_phy_down(hisi_hba, sas_phy->id, 0);
-	} else
+	} else if (sas_dev->dev_status != HISI_SAS_DEV_INIT) {
+		/*
+		 * If in init state, we rely on caller to wait for link to be
+		 * ready; otherwise, delay.
+		 */
 		msleep(2000);
+	}
 
 	return rc;
 }
@@ -2264,6 +2301,7 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
 		hisi_hba->devices[i].dev_type = SAS_PHY_UNUSED;
 		hisi_hba->devices[i].device_id = i;
+		hisi_hba->devices[i].dev_status = HISI_SAS_DEV_INIT;
 	}
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e40cc6b3b67b..89160ab3efb0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -868,6 +868,7 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 
 			hisi_hba->devices[i].device_id = i;
 			sas_dev = &hisi_hba->devices[i];
+			sas_dev->dev_status = HISI_SAS_DEV_INIT;
 			sas_dev->dev_type = device->dev_type;
 			sas_dev->hisi_hba = hisi_hba;
 			sas_dev->sas_device = device;
-- 
2.17.1
