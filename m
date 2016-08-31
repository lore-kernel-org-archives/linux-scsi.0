From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 06/15] smartpqi: add kdump support
Date: Wed, 31 Aug 2016 14:54:41 -0500
Message-ID: <147267328124.22907.1717174624826580691.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0085.outbound.protection.outlook.com ([104.47.40.85]:55808
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754200AbcHaUKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 16:10:12 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   13 +++++++++---
 drivers/scsi/smartpqi/smartpqi_init.c |   35 +++++++++++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sis.c  |   10 +++++++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |    2 ++
 4 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 053be6b..5f965ad 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -79,11 +79,13 @@ struct pqi_ctrl_registers {
 	__le32	sis_ctrl_to_host_doorbell;		/* 9Ch */
 	u8	reserved3[0xa0 - (0x9c + sizeof(__le32))];
 	__le32	sis_ctrl_to_host_doorbell_clear;	/* A0h */
-	u8	reserved4[0xbc - (0xa0 + sizeof(__le32))];
+	u8	reserved4[0xb0 - (0xa0 + sizeof(__le32))];
+	__le32	sis_driver_scratch;			/* B0h */
+	u8	reserved5[0xbc - (0xb0 + sizeof(__le32))];
 	__le32	sis_firmware_status;			/* BCh */
-	u8	reserved5[0x1000 - (0xbc + sizeof(__le32))];
+	u8	reserved6[0x1000 - (0xbc + sizeof(__le32))];
 	__le32	sis_mailbox[8];				/* 1000h */
-	u8	reserved6[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
+	u8	reserved7[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
 	/*
 	 * The PQI spec states that the PQI registers should be at
 	 * offset 0 from the PCIe BAR 0.  However, we can't map
@@ -963,6 +965,11 @@ struct pqi_ctrl_info {
 	struct semaphore lun_reset_sem;
 };
 
+enum pqi_ctrl_mode {
+	UNKNOWN,
+	PQI_MODE
+};
+
 /*
  * assume worst case: SATA queue depth of 31 minus 4 internal firmware commands
  */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dbc8b40..43bfeac 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -153,6 +153,18 @@ static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
 	return pqi_scsi3addr_equal(scsi3addr, RAID_CTLR_LUNID);
 }
 
+static inline enum pqi_ctrl_mode pqi_get_ctrl_mode(
+	struct pqi_ctrl_info *ctrl_info)
+{
+	return sis_read_driver_scratch(ctrl_info);
+}
+
+static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_mode mode)
+{
+	sis_write_driver_scratch(ctrl_info, mode);
+}
+
 #define PQI_RESCAN_WORK_INTERVAL	(10 * HZ)
 
 static inline void pqi_schedule_rescan_worker(struct pqi_ctrl_info *ctrl_info)
@@ -5266,10 +5278,30 @@ out:
 	return rc;
 }
 
+static int pqi_kdump_init(struct pqi_ctrl_info *ctrl_info)
+{
+	if (!sis_is_firmware_running(ctrl_info))
+		return -ENXIO;
+
+	if (pqi_get_ctrl_mode(ctrl_info) == PQI_MODE) {
+		sis_disable_msix(ctrl_info);
+		if (pqi_reset(ctrl_info) == 0)
+			sis_reenable_sis_mode(ctrl_info);
+	}
+
+	return 0;
+}
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
 
+	if (reset_devices) {
+		rc = pqi_kdump_init(ctrl_info);
+		if (rc)
+			return rc;
+	}
+
 	/*
 	 * When the controller comes out of reset, it is always running
 	 * in legacy SIS mode.  This is so that it can be compatible
@@ -5343,6 +5375,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
 	/* From here on, we are running in PQI mode. */
 	ctrl_info->pqi_mode_enabled = true;
+	pqi_save_ctrl_mode(ctrl_info, PQI_MODE);
 
 	rc = pqi_alloc_admin_queues(ctrl_info);
 	if (rc) {
@@ -5879,6 +5912,8 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_ctrl_to_host_doorbell_clear) != 0xa0);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
+		sis_driver_scratch) != 0xb0);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_firmware_status) != 0xbc);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_mailbox) != 0x1000);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 5d416a8..71408f9 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -376,6 +376,16 @@ int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
+void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value)
+{
+	writel(value, &ctrl_info->registers->sis_driver_scratch);
+}
+
+u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info)
+{
+	return readl(&ctrl_info->registers->sis_driver_scratch);
+}
+
 static void __attribute__((unused)) verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index d2ff8d5..bd6e7b0 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -28,5 +28,7 @@ void sis_enable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_disable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
+void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
+u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
 
 #endif	/* _SMARTPQI_SIS_H */

