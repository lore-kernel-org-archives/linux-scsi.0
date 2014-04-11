From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 14/42] qla2xxx: Track the process when the ROM_LOCK failure happens
Date: Fri, 11 Apr 2014 16:54:19 -0400
Message-ID: <1397249687-32666-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32035 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbaDKVb7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:31:59 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Hiral Patel <hiral.patel@qlogic.com>

Signed-off-by: Hiral Patel <hiral.patel@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   20 ++++++++++++++------
 drivers/scsi/qla2xxx/qla_nx.h |    3 ---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 3c5819a..61774bc 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -860,13 +860,14 @@ qla82xx_rom_lock(struct qla_hw_data *ha)
 		}
 		timeout++;
 	}
-	qla82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, ROM_LOCK_DRIVER);
+	qla82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, ha->portnum);
 	return 0;
 }
 
 static void
 qla82xx_rom_unlock(struct qla_hw_data *ha)
 {
+	qla82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, 0xffffffff);
 	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
 }
 
@@ -950,6 +951,7 @@ static int
 qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 {
 	int ret, loops = 0;
+	uint32_t lock_owner = 0;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
@@ -958,8 +960,10 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 		loops++;
 	}
 	if (loops >= 50000) {
+		lock_owner = qla82xx_rd_32(ha, QLA82XX_ROM_LOCK_ID);
 		ql_log(ql_log_fatal, vha, 0x00b9,
-		    "Failed to acquire SEM2 lock.\n");
+		    "Failed to acquire SEM2 lock, Lock Owner %u.\n",
+		    lock_owner);
 		return -1;
 	}
 	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
@@ -1057,6 +1061,7 @@ static int
 ql82xx_rom_lock_d(struct qla_hw_data *ha)
 {
 	int loops = 0;
+	uint32_t lock_owner = 0;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
@@ -1065,8 +1070,9 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
 		loops++;
 	}
 	if (loops >= 50000) {
+		lock_owner = qla82xx_rd_32(ha, QLA82XX_ROM_LOCK_ID);
 		ql_log(ql_log_warn, vha, 0xb010,
-		    "ROM lock failed.\n");
+		    "ROM lock failed, Lock Owner %u.\n", lock_owner);
 		return -1;
 	}
 	return 0;
@@ -2811,12 +2817,14 @@ static void
 qla82xx_rom_lock_recovery(struct qla_hw_data *ha)
 {
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	uint32_t lock_owner = 0;
 
-	if (qla82xx_rom_lock(ha))
+	if (qla82xx_rom_lock(ha)) {
+		lock_owner = qla82xx_rd_32(ha, QLA82XX_ROM_LOCK_ID);
 		/* Someone else is holding the lock. */
 		ql_log(ql_log_info, vha, 0xb022,
-		    "Resetting rom_lock.\n");
-
+		    "Resetting rom_lock, Lock Owner %u.\n", lock_owner);
+	}
 	/*
 	 * Either we got the lock, or someone
 	 * else died while holding it.
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index d57f6fe..d978a5d 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -333,9 +333,6 @@
 #define QLA82XX_ROMUSB_ROM_INSTR_OPCODE		(ROMUSB_ROM + 0x0004)
 #define QLA82XX_ROMUSB_GLB_CAS_RST		(ROMUSB_GLB + 0x0038)
 
-/* Lock IDs for ROM lock */
-#define ROM_LOCK_DRIVER       0x0d417340
-
 #define QLA82XX_PCI_CRB_WINDOWSIZE 0x00100000	 /* all are 1MB windows */
 #define QLA82XX_PCI_CRB_WINDOW(A) \
 	(QLA82XX_PCI_CRBSPACE + (A)*QLA82XX_PCI_CRB_WINDOWSIZE)
-- 
1.7.7

