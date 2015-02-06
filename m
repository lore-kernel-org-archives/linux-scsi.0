From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/4] SCSI-QLA4...: Less function calls in qla4xxx_sysfs_ddb_logout()
 after error detection
Date: Fri, 06 Feb 2015 23:17:51 +0100
Message-ID: <54D53D8F.7060307@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54D53BE4.7010807@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D53BE4.7010807@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@parallels.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 6 Feb 2015 22:44:23 +0100

The vfree() function was called in three cases by the qla4xxx_sysfs_ddb_logout()
function during error handling even if the passed variables "flash_tddb" and
"tmp_tddb" contained still a null pointer.

* This implementation detail could be improved by adjustments for jump labels.

* Let us return immediately after the first failed function call according to
  the current Linux coding style convention.

* Delete also an unnecessary check for the variable "fw_ddb_entry" there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/qla4xxx/ql4_os.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e508bc9..802390b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7699,23 +7699,22 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
-	struct ql4_tuple_ddb *flash_tddb = NULL;
-	struct ql4_tuple_ddb *tmp_tddb = NULL;
-	struct dev_db_entry *fw_ddb_entry = NULL;
-	struct ddb_entry *ddb_entry = NULL;
 	dma_addr_t fw_ddb_dma;
 	uint32_t next_idx = 0;
 	uint32_t state = 0, conn_err = 0;
 	uint16_t conn_id = 0;
 	int idx, index;
 	int status, ret = 0;
+	struct ql4_tuple_ddb *flash_tddb;
+	struct ql4_tuple_ddb *tmp_tddb;
+	struct ddb_entry *ddb_entry;
+	struct dev_db_entry *fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool,
+								GFP_KERNEL,
+								&fw_ddb_dma);
 
-	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
-				      &fw_ddb_dma);
-	if (fw_ddb_entry == NULL) {
+	if (!fw_ddb_entry) {
 		ql4_printk(KERN_ERR, ha, "%s:Out of memory\n", __func__);
-		ret = -ENOMEM;
-		goto exit_ddb_logout;
+		return -ENOMEM;
 	}
 
 	flash_tddb = vzalloc(sizeof(*flash_tddb));
@@ -7723,7 +7722,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		ql4_printk(KERN_WARNING, ha,
 			   "%s:Memory Allocation failed.\n", __func__);
 		ret = -ENOMEM;
-		goto exit_ddb_logout;
+		goto free_pool;
 	}
 
 	tmp_tddb = vzalloc(sizeof(*tmp_tddb));
@@ -7731,7 +7730,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		ql4_printk(KERN_WARNING, ha,
 			   "%s:Memory Allocation failed.\n", __func__);
 		ret = -ENOMEM;
-		goto exit_ddb_logout;
+		goto free_flash;
 	}
 
 	if (!fnode_sess->targetname) {
@@ -7739,7 +7738,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 			   "%s:Cannot logout from SendTarget entry\n",
 			   __func__);
 		ret = -EPERM;
-		goto exit_ddb_logout;
+		goto free_tmp;
 	}
 
 	if (fnode_sess->is_boot_target) {
@@ -7747,7 +7746,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 			   "%s: Logout from boot target entry is not permitted.\n",
 			   __func__);
 		ret = -EPERM;
-		goto exit_ddb_logout;
+		goto free_tmp;
 	}
 
 	strlcpy(flash_tddb->iscsi_name, fnode_sess->targetname,
@@ -7794,12 +7793,12 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 	if (idx == MAX_DDB_ENTRIES)
 		ret = -ESRCH;
 
-exit_ddb_logout:
-	vfree(flash_tddb);
+free_tmp:
 	vfree(tmp_tddb);
-	if (fw_ddb_entry)
-		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
-
+free_flash:
+	vfree(flash_tddb);
+free_pool:
+	dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
 	return ret;
 }
 
-- 
2.2.2
