From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/4] SCSI-QLA4...: Deletion of unnecessary checks before three
 function calls
Date: Fri, 06 Feb 2015 23:13:06 +0100
Message-ID: <54D53C72.1020702@users.sourceforge.net>
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
Date: Fri, 6 Feb 2015 20:38:23 +0100

The following functions perform also input parameter validation.
* iscsi_boot_destroy_kset
* kfree
* vfree

Thus the test around their calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c  | 31 ++++++++++---------------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c291fdf..2343c0f 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -2410,7 +2410,7 @@ exit_free_acb:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk), acb,
 			  acb_dma);
 exit_config_acb:
-	if ((acb_config == ACB_CONFIG_SET) && ha->saved_acb) {
+	if (acb_config == ACB_CONFIG_SET) {
 		kfree(ha->saved_acb);
 		ha->saved_acb = NULL;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..2a00fd3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4131,9 +4131,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
 				  ha->queues_dma);
 
-	 if (ha->fw_dump)
-		vfree(ha->fw_dump);
-
+	vfree(ha->fw_dump);
 	ha->queues_len = 0;
 	ha->queues = NULL;
 	ha->queues_dma = 0;
@@ -4155,8 +4153,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 	if (ha->chap_dma_pool)
 		dma_pool_destroy(ha->chap_dma_pool);
 
-	if (ha->chap_list)
-		vfree(ha->chap_list);
+	vfree(ha->chap_list);
 	ha->chap_list = NULL;
 
 	if (ha->fw_ddb_dma_pool)
@@ -4175,9 +4172,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		iounmap(ha->reg);
 	}
 
-	if (ha->reset_tmplt.buff)
-		vfree(ha->reset_tmplt.buff);
-
+	vfree(ha->reset_tmplt.buff);
 	pci_release_regions(ha->pdev);
 }
 
@@ -6370,10 +6365,8 @@ static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
 	}
 
 exit_check:
-	if (fw_tddb)
-		vfree(fw_tddb);
-	if (tmp_tddb)
-		vfree(tmp_tddb);
+	vfree(fw_tddb);
+	vfree(tmp_tddb);
 	return ret;
 }
 
@@ -6525,10 +6518,8 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 	}
 
 exit_check:
-	if (fw_tddb)
-		vfree(fw_tddb);
-	if (tmp_tddb)
-		vfree(tmp_tddb);
+	vfree(fw_tddb);
+	vfree(tmp_tddb);
 	return ret;
 }
 
@@ -7806,10 +7797,8 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		ret = -ESRCH;
 
 exit_ddb_logout:
-	if (flash_tddb)
-		vfree(flash_tddb);
-	if (tmp_tddb)
-		vfree(tmp_tddb);
+	vfree(flash_tddb);
+	vfree(tmp_tddb);
 	if (fw_ddb_entry)
 		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
 
@@ -9002,7 +8991,7 @@ static void qla4xxx_remove_adapter(struct pci_dev *pdev)
 	/* destroy iface from sysfs */
 	qla4xxx_destroy_ifaces(ha);
 
-	if ((!ql4xdisablesysfsboot) && ha->boot_kset)
+	if (!ql4xdisablesysfsboot)
 		iscsi_boot_destroy_kset(ha->boot_kset);
 
 	qla4xxx_destroy_fw_ddb_session(ha);
-- 
2.2.2
