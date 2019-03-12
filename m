From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 4/4] scsi: smartpqi: replace 0 by HCTX_TYPE_DEFAULT to index blk_mq_tag_set->map
Date: Tue, 12 Mar 2019 09:00:31 +0800
Message-ID: <1552352431-18821-5-git-send-email-dongli.zhang@oracle.com>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5d9ccba..68aea2a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5789,7 +5789,7 @@ static int pqi_map_queues(struct Scsi_Host *shost)
 {
 	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[0],
+	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
 					ctrl_info->pci_dev, 0);
 }
 
-- 
2.7.4
