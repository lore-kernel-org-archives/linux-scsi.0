From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 18/27] scsi: use zeroing allocator rather than allocator followed by memset 0
Date: Fri, 28 Jun 2019 10:49:21 +0800
Message-ID: <20190628024922.15754-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace allocator followed by memset with 0 with zeroing allocator.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 5 +----
 drivers/scsi/qedf/qedf_dbg.c     | 3 +--
 drivers/scsi/qla2xxx/qla_attr.c  | 7 ++-----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 1ee857d9d165..0dfac41f2fa8 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6017,7 +6017,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				 phba->hba_debugfs_root,
 				 phba, &lpfc_debugfs_op_slow_ring_trc);
 		if (!phba->slow_ring_trc) {
-			phba->slow_ring_trc = kmalloc(
+			phba->slow_ring_trc = kzalloc(
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc),
 				GFP_KERNEL);
@@ -6028,9 +6028,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				goto debug_failed;
 			}
 			atomic_set(&phba->slow_ring_trc_cnt, 0);
-			memset(phba->slow_ring_trc, 0,
-				(sizeof(struct lpfc_debugfs_trc) *
-				lpfc_debugfs_max_slow_ring_trc));
 		}
 
 		snprintf(name, sizeof(name), "nvmeio_trc");
diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
index e0387e495261..0d2aed82882a 100644
--- a/drivers/scsi/qedf/qedf_dbg.c
+++ b/drivers/scsi/qedf/qedf_dbg.c
@@ -106,11 +106,10 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 int
 qedf_alloc_grc_dump_buf(u8 **buf, uint32_t len)
 {
-		*buf = vmalloc(len);
+		*buf = vzalloc(len);
 		if (!(*buf))
 			return -ENOMEM;
 
-		memset(*buf, 0, len);
 		return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8d560c562e9c..dabd139fdaeb 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -382,7 +382,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		ha->optrom_region_size = size;
 
 		ha->optrom_state = QLA_SREADING;
-		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+		ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
 			ql_log(ql_log_warn, vha, 0x7062,
 			    "Unable to allocate memory for optrom retrieval "
@@ -404,7 +404,6 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    "Reading flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size);
 
-		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		ha->isp_ops->read_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
@@ -457,7 +456,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		ha->optrom_region_size = size;
 
 		ha->optrom_state = QLA_SWRITING;
-		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+		ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
 			ql_log(ql_log_warn, vha, 0x7066,
 			    "Unable to allocate memory for optrom update "
@@ -471,8 +470,6 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		ql_dbg(ql_dbg_user, vha, 0x7067,
 		    "Staging flash region write -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size);
-
-		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		break;
 	case 3:
 		if (ha->optrom_state != QLA_SWRITING) {
-- 
2.11.0
