From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 10/11] qla2xxx: Remove unused reverse_ini_mode.
Date: Fri, 23 Dec 2016 20:23:38 -0800
Message-ID: <1482553419-4117-11-git-send-email-himanshu.madhani@cavium.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

With support for dual mode in the driver, this mode becomes
dead code. Remove reverse_ini_mode from code.

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  1 -
 drivers/scsi/qla2xxx/qla_target.c | 10 ----------
 drivers/scsi/qla2xxx/qla_target.h |  8 --------
 3 files changed, 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ce3b946..d85066f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3160,7 +3160,6 @@ struct qlt_hw_data {
 	/* Protected by hw lock */
 	uint32_t enable_class_2:1;
 	uint32_t enable_explicit_conf:1;
-	uint32_t ini_mode_force_reverse:1;
 	uint32_t node_name_set:1;
 
 	dma_addr_t atio_dma;	/* Physical address. */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0fc6da5..d2ca518 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5865,8 +5865,6 @@ void qlt_lport_deregister(struct scsi_qla_host *vha)
 /* Must be called under HW lock */
 static void qlt_set_mode(struct scsi_qla_host *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	switch (ql2x_ini_mode) {
 	case QLA2XXX_INI_MODE_DISABLED:
 	case QLA2XXX_INI_MODE_EXCLUSIVE:
@@ -5881,16 +5879,11 @@ static void qlt_set_mode(struct scsi_qla_host *vha)
 	default:
 		break;
 	}
-
-	if (ha->tgt.ini_mode_force_reverse)
-		qla_reverse_ini_mode(vha);
 }
 
 /* Must be called under HW lock */
 static void qlt_clear_mode(struct scsi_qla_host *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	switch (ql2x_ini_mode) {
 	case QLA2XXX_INI_MODE_DISABLED:
 		vha->host->active_mode = MODE_UNKNOWN;
@@ -5905,9 +5898,6 @@ static void qlt_clear_mode(struct scsi_qla_host *vha)
 	default:
 		break;
 	}
-
-	if (ha->tgt.ini_mode_force_reverse)
-		qla_reverse_ini_mode(vha);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 5ebd7fb..2569216 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1073,14 +1073,6 @@ static inline bool qla_dual_mode_enabled(struct scsi_qla_host *ha)
 	return (ha->host->active_mode == MODE_DUAL);
 }
 
-static inline void qla_reverse_ini_mode(struct scsi_qla_host *ha)
-{
-	if (ha->host->active_mode & MODE_INITIATOR)
-		ha->host->active_mode &= ~MODE_INITIATOR;
-	else
-		ha->host->active_mode |= MODE_INITIATOR;
-}
-
 static inline uint32_t sid_to_key(const uint8_t *s_id)
 {
 	uint32_t key;
-- 
1.8.3.1
