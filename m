From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 21/42] qla2xxx: Use proper log message for flash lock failed error.
Date: Fri, 11 Apr 2014 16:54:26 -0400
Message-ID: <1397249687-32666-22-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:39122 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbaDKVcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:00 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Atul Deshmukh <atul.deshmukh@qlogic.com>

Signed-off-by: Atul Deshmukh <atul.deshmukh@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c  |    4 ++++
 drivers/scsi/qla2xxx/qla_nx2.c |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 08572b9..e48084f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -49,7 +49,7 @@
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
  * | Virtual Port                 |       0xa007       |		|
- * | ISP82XX Specific             |       0xb155       | 0xb002,0xb024  |
+ * | ISP82XX Specific             |       0xb157       | 0xb002,0xb024  |
  * |                              |                    | 0xb09e,0xb0ae  |
  * |                              |                    | 0xb0e0-0xb0ef  |
  * |                              |                    | 0xb085,0xb0dc  |
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c268b3f..190283e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -848,6 +848,7 @@ qla82xx_rom_lock(struct qla_hw_data *ha)
 {
 	int done = 0, timeout = 0;
 	uint32_t lock_owner = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while (!done) {
 		/* acquire semaphore2 from PCI HW block */
@@ -856,6 +857,9 @@ qla82xx_rom_lock(struct qla_hw_data *ha)
 			break;
 		if (timeout >= qla82xx_rom_lock_timeout) {
 			lock_owner = qla82xx_rd_32(ha, QLA82XX_ROM_LOCK_ID);
+			ql_log(ql_log_warn, vha, 0xb157,
+			    "%s: Simultaneous flash access by following ports, active port = %d: accessing port = %d",
+			    __func__, ha->portnum, lock_owner);
 			return -1;
 		}
 		timeout++;
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index e38d84c..e631db4 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -448,8 +448,8 @@ qla8044_flash_lock(scsi_qla_host_t *vha)
 			lock_owner = qla8044_rd_reg(ha,
 			    QLA8044_FLASH_LOCK_ID);
 			ql_log(ql_log_warn, vha, 0xb113,
-			    "%s: flash lock by %d failed, held by %d\n",
-				__func__, ha->portnum, lock_owner);
+			    "%s: Simultaneous flash access by following ports, active port = %d: accessing port = %d",
+			    __func__, ha->portnum, lock_owner);
 			ret_val = QLA_FUNCTION_FAILED;
 			break;
 		}
-- 
1.7.7

