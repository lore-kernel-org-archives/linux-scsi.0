From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/4] SCSI-QLA4...: Less function calls in qla4xxx_is_flash_ddb_exists()
 after error detection
Date: Fri, 06 Feb 2015 23:16:39 +0100
Message-ID: <54D53D47.7030102@users.sourceforge.net>
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
Date: Fri, 6 Feb 2015 21:55:55 +0100

The vfree() function was called in two cases by the
qla4xxx_is_flash_ddb_exists() function during error handling even if the passed
variables "fw_tddb" and "tmp_tddb" contained still a null pointer.

* This implementation detail could be improved by adjustments for jump labels.

* Let us return immediately after the first failed function call according to
  the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/qla4xxx/ql4_os.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a7ca479..e508bc9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6470,16 +6470,14 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 				       struct dev_db_entry *fw_ddb_entry)
 {
 	struct qla_ddb_index  *nt_ddb_idx, *nt_ddb_idx_tmp;
-	struct ql4_tuple_ddb *fw_tddb = NULL;
-	struct ql4_tuple_ddb *tmp_tddb = NULL;
 	int rval, ret = QLA_ERROR;
+	struct ql4_tuple_ddb *tmp_tddb;
+	struct ql4_tuple_ddb *fw_tddb = vzalloc(sizeof(*fw_tddb));
 
-	fw_tddb = vzalloc(sizeof(*fw_tddb));
 	if (!fw_tddb) {
 		DEBUG2(ql4_printk(KERN_WARNING, ha,
 				  "Memory Allocation failed.\n"));
-		ret = QLA_SUCCESS;
-		goto exit_check;
+		return QLA_SUCCESS;
 	}
 
 	tmp_tddb = vzalloc(sizeof(*tmp_tddb));
@@ -6487,7 +6485,7 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 		DEBUG2(ql4_printk(KERN_WARNING, ha,
 				  "Memory Allocation failed.\n"));
 		ret = QLA_SUCCESS;
-		goto exit_check;
+		goto vfree_fw;
 	}
 
 	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb, NULL);
@@ -6498,7 +6496,7 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 		ret = qla4xxx_compare_tuple_ddb(ha, fw_tddb, tmp_tddb, true);
 		/* found duplicate ddb */
 		if (ret == QLA_SUCCESS)
-			goto exit_check;
+			goto vfree_tmp;
 	}
 
 	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
@@ -6512,13 +6510,14 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 			else
 				ret = QLA_SUCCESS;
 
-			goto exit_check;
+			goto vfree_tmp;
 		}
 	}
 
-exit_check:
-	vfree(fw_tddb);
+vfree_tmp:
 	vfree(tmp_tddb);
+vfree_fw:
+	vfree(fw_tddb);
 	return ret;
 }
 
-- 
2.2.2
