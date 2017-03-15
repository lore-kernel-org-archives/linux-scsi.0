From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 09/14] qla2xxx: Add async new target notification
Date: Wed, 15 Mar 2017 09:48:51 -0700
Message-ID: <20170315164856.17255-10-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0043.outbound.protection.outlook.com ([104.47.38.43]:41344
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753116AbdCOQt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:27 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 +++---
 drivers/scsi/qla2xxx/qla_target.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 532004981dbd..563116188c43 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6005,13 +6005,13 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
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
index c35f889b94a6..d64420251194 100644
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
2.12.0
