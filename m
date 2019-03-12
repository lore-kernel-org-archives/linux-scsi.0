From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 3/4] scsi: qla2xxx: replace 0 by HCTX_TYPE_DEFAULT to index blk_mq_tag_set->map
Date: Tue, 12 Mar 2019 09:00:30 +0800
Message-ID: <1552352431-18821-4-git-send-email-dongli.zhang@oracle.com>
References: <1552352431-18821-1-git-send-email-dongli.zhang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552352431-18821-1-git-send-email-dongli.zhang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux-kernel@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, don.brace@microsemi.com, esc.storagedev@microsemi.com, dongli.zhang@oracle.com
List-Id: linux-scsi@vger.kernel.org

Use HCTX_TYPE_DEFAULT instead of 0 to avoid hardcoding.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 677f82f..9e22cfc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7179,7 +7179,7 @@ static int qla2xxx_map_queues(struct Scsi_Host *shost)
 {
 	int rc;
 	scsi_qla_host_t *vha = (scsi_qla_host_t *)shost->hostdata;
-	struct blk_mq_queue_map *qmap = &shost->tag_set.map[0];
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
 	if (USER_CTRL_IRQ(vha->hw) || !vha->hw->mqiobase)
 		rc = blk_mq_map_queues(qmap);
-- 
2.7.4
