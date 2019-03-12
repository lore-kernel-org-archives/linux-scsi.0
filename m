From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 1/4] scsi: replace 0 by HCTX_TYPE_DEFAULT to index blk_mq_tag_set->map
Date: Tue, 12 Mar 2019 09:00:28 +0800
Message-ID: <1552352431-18821-2-git-send-email-dongli.zhang@oracle.com>
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
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2018967..985cfc2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1759,7 +1759,7 @@ static int scsi_map_queues(struct blk_mq_tag_set *set)
 
 	if (shost->hostt->map_queues)
 		return shost->hostt->map_queues(shost);
-	return blk_mq_map_queues(&set->map[0]);
+	return blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
 }
 
 void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
-- 
2.7.4
