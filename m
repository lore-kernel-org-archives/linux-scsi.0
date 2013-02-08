From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/23] qla2xxx: Display the lock owner on lock acquire failure.
Date: Fri,  8 Feb 2013 01:57:53 -0500
Message-ID: <1360306684-8286-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:36496 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752684Ab3BHHTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:11 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c  |    9 ++++++++-
 drivers/scsi/qla2xxx/qla_os.c  |    8 +++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 65e95bd..29101fe 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -36,7 +36,7 @@
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
  * | Virtual Port                 |       0xa007       |		|
- * | ISP82XX Specific             |       0xb084       | 0xb002,0xb024  |
+ * | ISP82XX Specific             |       0xb086       | 0xb002,0xb024  |
  * | MultiQ                       |       0xc00c       |		|
  * | Misc                         |       0xd010       |		|
  * | Target Mode		  |	  0xe070       |		|
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 042368b..dc4be5b 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -847,14 +847,21 @@ static int
 qla82xx_rom_lock(struct qla_hw_data *ha)
 {
 	int done = 0, timeout = 0;
+	uint32_t lock_owner = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while (!done) {
 		/* acquire semaphore2 from PCI HW block */
 		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_LOCK));
 		if (done == 1)
 			break;
-		if (timeout >= qla82xx_rom_lock_timeout)
+		if (timeout >= qla82xx_rom_lock_timeout) {
+			lock_owner = qla82xx_rd_32(ha, QLA82XX_ROM_LOCK_ID);
+			ql_dbg(ql_dbg_p3p, vha, 0xb085,
+			    "Failed to acquire rom lock, acquired by %d.\n",
+			    lock_owner);
 			return -1;
+		}
 		timeout++;
 	}
 	qla82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, ROM_LOCK_DRIVER);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 33fb217..a947f70 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4065,6 +4065,8 @@ qla83xx_force_lock_recovery(scsi_qla_host_t *base_vha)
 	uint32_t idc_lck_rcvry_stage_mask = 0x3;
 	uint32_t idc_lck_rcvry_owner_mask = 0x3c;
 	struct qla_hw_data *ha = base_vha->hw;
+	ql_dbg(ql_dbg_p3p, base_vha, 0xb086,
+	    "Trying force recovery of the IDC lock.\n");
 
 	rval = qla83xx_rd_reg(base_vha, QLA83XX_IDC_LOCK_RECOVERY, &data);
 	if (rval)
@@ -4156,6 +4158,7 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 {
 	uint16_t options = (requester_id << 15) | BIT_6;
 	uint32_t data;
+	uint32_t lock_owner;
 	struct qla_hw_data *ha = base_vha->hw;
 
 	/* IDC-lock implementation using driver-lock/lock-id remote registers */
@@ -4167,8 +4170,11 @@ retry_lock:
 			qla83xx_wr_reg(base_vha, QLA83XX_DRIVER_LOCKID,
 			    ha->portnum);
 		} else {
+			qla83xx_rd_reg(base_vha, QLA83XX_DRIVER_LOCKID,
+			    &lock_owner);
 			ql_dbg(ql_dbg_p3p, base_vha, 0xb063,
-			    "Failed to acquire IDC lock. retrying...\n");
+			    "Failed to acquire IDC lock, acquired by %d, "
+			    "retrying...\n", lock_owner);
 
 			/* Retry/Perform IDC-Lock recovery */
 			if (qla83xx_idc_lock_recovery(base_vha)
-- 
1.7.7

