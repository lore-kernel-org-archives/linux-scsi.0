From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 1/3] scsi: drop unlikely behind BUG_ON()
Date: Sun,  4 Oct 2015 14:18:01 +0800
Message-ID: <a89c7bef0699c3d3f5e592c58ff3f0a4db482b69.1443937856.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

BUG_ON() already contain an unlikely compiler flag. Drop it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f570b48..3b5faab 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1164,8 +1164,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
-		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(count > ivecs);
+		BUG_ON(count > queue_max_integrity_segments(rq->q));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
-- 
2.5.0
