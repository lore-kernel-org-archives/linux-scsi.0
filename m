From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH] scsi: remove unnecessary unlikely()
Date: Wed,  5 Sep 2018 23:47:20 +0300
Message-ID: <20180905204720.992-1-igor.stoppa@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: igor.stoppa@gmail.com, Igor Stoppa <igor.stoppa@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

BUG_ON() already contains an unlikely(), there is no need for another one.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0adfb3bce0fd..aaa1819b0a69 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1207,8 +1207,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
-		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(count > ivecs);
+		BUG_ON(count > queue_max_integrity_segments(rq->q));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
-- 
2.17.1
