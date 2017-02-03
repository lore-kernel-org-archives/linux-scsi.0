From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 12/14] qla2xxx: Add async new target notification
Date: Fri, 3 Feb 2017 14:40:53 -0800
Message-ID: <1486161655-2307-13-git-send-email-himanshu.madhani@cavium.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 +++---
 drivers/scsi/qla2xxx/qla_target.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8b372b2..2909b7b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5998,13 +5998,13 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD_24XX;
 	tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT_24XX;
 
-	if (base_vha->fc_vport)
-		return 0;
-
 	mutex_lock(&qla_tgt_mutex);
 	list_add_tail(&tgt->tgt_list_entry, &qla_tgt_glist);
 	mutex_unlock(&qla_tgt_mutex);
 
+	if (ha->tgt.tgt_ops && ha->tgt.tgt_ops->add_target)
+		ha->tgt.tgt_ops->add_target(base_vha);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 82d53f3..20e25e5 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -693,6 +693,7 @@ struct qla_tgt_func_tmpl {
 	void (*shutdown_sess)(struct fc_port *);
 	int (*get_dif_tags)(struct qla_tgt_cmd *cmd, uint16_t *pfw_prot_opts);
 	int (*chk_dif_tags)(uint32_t tag);
+	void (*add_target)(struct scsi_qla_host *);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
-- 
1.8.3.1
