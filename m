From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH] megaraid_sas : Pass driver version to firmware inside IOC init frame
Date: Wed, 10 Jun 2015 15:52:55 +0530
Message-ID: <201506101028.t5AASaRN030984@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:60400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbbFJKZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 06:25:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, thenzl@redhat.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com


Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   10 +++++++---
 drivers/scsi/megaraid/megaraid_sas_base.c   |   18 ++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    7 +++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 20c3754..5bd4d30 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1038,6 +1038,7 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 
+#define MEGASAS_MAX_NAME                        32
 #define MEGASAS_MAX_SECTORS                    (2*1024)
 #define MEGASAS_MAX_SECTORS_IEEE		(2*128)
 #define MEGASAS_DBG_LVL				1
@@ -1264,17 +1265,18 @@ struct megasas_init_frame {
 	__le32 pad_0;		/*0Ch */
 
 	__le16 flags;		/*10h */
-	__le16 reserved_3;		/*12h */
+	__le16 reserved_2;		/*12h */
 	__le32 data_xfer_len;	/*14h */
 
 	__le32 queue_info_new_phys_addr_lo;	/*18h */
 	__le32 queue_info_new_phys_addr_hi;	/*1Ch */
 	__le32 queue_info_old_phys_addr_lo;	/*20h */
 	__le32 queue_info_old_phys_addr_hi;	/*24h */
-	__le32 reserved_4[2];	/*28h */
+	__le32 driver_ver_lo;      /*28h */
+	__le32 driver_ver_hi;      /*2Ch */
 	__le32 system_info_lo;      /*30h */
 	__le32 system_info_hi;      /*34h */
-	__le32 reserved_5[2];	/*38h */
+	__le32 reserved_3[2];	/*38h */
 
 } __attribute__ ((packed));
 
@@ -1665,6 +1667,8 @@ struct megasas_instance {
 	dma_addr_t producer_h;
 	__le32 *consumer;
 	dma_addr_t consumer_h;
+	__le32 *verbuf;
+	dma_addr_t verbuf_h;
 	struct MR_DRV_SYSTEM_INFO *system_info_buf;
 	dma_addr_t system_info_h;
 	struct MR_LD_VF_AFFILIATION *vf_affiliation;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a022c39..6bfb3eb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4252,6 +4252,14 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 
 	init_frame->cmd = MFI_CMD_INIT;
 	init_frame->cmd_status = MFI_STAT_INVALID_STATUS;
+
+	if (instance->verbuf) {
+		snprintf((char *)instance->verbuf, strlen(MEGASAS_VERSION) + 2, "%s\n",
+			MEGASAS_VERSION);
+		init_frame->driver_ver_lo = cpu_to_le32(instance->verbuf_h);
+		init_frame->driver_ver_hi = 0;
+	}
+
 	init_frame->queue_info_new_phys_addr_lo =
 		cpu_to_le32(lower_32_bits(initq_info_h));
 	init_frame->queue_info_new_phys_addr_hi =
@@ -5257,6 +5265,12 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		break;
 	}
 
+	instance->verbuf = pci_alloc_consistent(pdev,
+						MEGASAS_MAX_NAME * sizeof(u32),
+						&instance->verbuf_h);
+	if (!instance->verbuf)
+		dev_info(&instance->pdev->dev, "Can't allocate version buffer\n");
+
 	instance->system_info_buf = pci_zalloc_consistent(pdev,
 					sizeof(struct MR_DRV_SYSTEM_INFO),
 					&instance->system_info_h);
@@ -5838,6 +5852,10 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		pci_free_consistent(pdev, sizeof(struct MR_DRV_SYSTEM_INFO),
 				    instance->system_info_buf, instance->system_info_h);
 
+	if (instance->verbuf)
+		pci_free_consistent(pdev, MEGASAS_MAX_NAME * sizeof(u32),
+				instance->verbuf, instance->verbuf_h);
+
 	scsi_host_put(host);
 
 	pci_disable_device(pdev);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0637f42..359d605 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -671,6 +671,13 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
+	if (instance->verbuf) {
+		snprintf((char *)instance->verbuf, strlen(MEGASAS_VERSION) + 2, "%s\n",
+			MEGASAS_VERSION);
+		init_frame->driver_ver_lo = cpu_to_le32(instance->verbuf_h);
+		init_frame->driver_ver_hi = 0;
+	}
+
 	sys_info = dmi_get_system_info(DMI_PRODUCT_UUID);
 	if (instance->system_info_buf && sys_info) {
 		memcpy(instance->system_info_buf->systemId, sys_info,
-- 
1.7.1

