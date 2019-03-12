From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 2/4] scsi: virtio_scsi: replace 0 by HCTX_TYPE_DEFAULT to index blk_mq_tag_set->map
Date: Tue, 12 Mar 2019 09:00:29 +0800
Message-ID: <1552352431-18821-3-git-send-email-dongli.zhang@oracle.com>
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
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1a6f150..e5de26b 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -661,7 +661,7 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 static int virtscsi_map_queues(struct Scsi_Host *shost)
 {
 	struct virtio_scsi *vscsi = shost_priv(shost);
-	struct blk_mq_queue_map *qmap = &shost->tag_set.map[0];
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
 	return blk_mq_virtio_map_queues(qmap, vscsi->vdev, 2);
 }
-- 
2.7.4
