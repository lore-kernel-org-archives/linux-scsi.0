From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 4/4] scsi-mq: Always unprepare before requeuing a request
Date: Wed, 30 Aug 2017 16:58:42 -0700
Message-ID: <20170830235842.29725-5-bart.vanassche@wdc.com>
References: <20170830235842.29725-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37462 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdHaAAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 20:00:04 -0400
In-Reply-To: <20170830235842.29725-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

One of the two scsi-mq functions that requeue a request unprepares a
request before requeueing (scsi_io_completion()) but the other function
not (__scsi_queue_insert()). Make sure that a request is unprepared
before requeuing it.

Fixes: commit d285203cf647 ("scsi: add support for a blk-mq based I/O path.")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6085377643ae..9cf6a80fe297 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -44,6 +44,8 @@ static struct kmem_cache *scsi_sense_cache;
 static struct kmem_cache *scsi_sense_isadma_cache;
 static DEFINE_MUTEX(scsi_sense_cache_mutex);
 
+static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd);
+
 static inline struct kmem_cache *
 scsi_select_sense_cache(bool unchecked_isa_dma)
 {
@@ -140,6 +142,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 
+	if (cmd->request->rq_flags & RQF_DONTPREP) {
+		cmd->request->rq_flags &= ~RQF_DONTPREP;
+		scsi_mq_uninit_cmd(cmd);
+	} else {
+		WARN_ON_ONCE(true);
+	}
 	blk_mq_requeue_request(cmd->request, true);
 	put_device(&sdev->sdev_gendev);
 }
@@ -982,8 +990,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 * A new command will be prepared and issued.
 		 */
 		if (q->mq_ops) {
-			cmd->request->rq_flags &= ~RQF_DONTPREP;
-			scsi_mq_uninit_cmd(cmd);
 			scsi_mq_requeue_cmd(cmd);
 		} else {
 			scsi_release_buffers(cmd);
-- 
2.14.1
