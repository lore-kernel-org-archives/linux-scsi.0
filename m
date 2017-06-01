From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 08/12] Introduce scsi_mq_sgl_size()
Date: Thu, 1 Jun 2017 16:27:07 -0700
Message-ID: <20170601232711.29062-9-bart.vanassche@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29834 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdFAX1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 19:27:22 -0400
In-Reply-To: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch does not change any functionality but makes the next
patch easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2c43b500e9f4..6b4fb48033fb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1858,6 +1858,13 @@ static inline int prep_to_mq(int ret)
 	}
 }
 
+/* Size in bytes of the sg-list stored in the scsi-mq command-private data. */
+static unsigned int scsi_mq_sgl_size(struct Scsi_Host *shost)
+{
+	return min_t(unsigned int, shost->sg_tablesize, SG_CHUNK_SIZE) *
+		sizeof(struct scatterlist);
+}
+
 static int scsi_mq_prep_fn(struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
@@ -1892,10 +1899,7 @@ static int scsi_mq_prep_fn(struct request *req)
 	cmd->sdb.table.sgl = sg;
 
 	if (scsi_host_get_prot(shost)) {
-		cmd->prot_sdb = (void *)sg +
-			min_t(unsigned int,
-			      shost->sg_tablesize, SG_CHUNK_SIZE) *
-			sizeof(struct scatterlist);
+		cmd->prot_sdb = (void *)sg + scsi_mq_sgl_size(shost);
 		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
 
 		cmd->prot_sdb->table.sgl =
@@ -2201,12 +2205,9 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
-	unsigned int cmd_size, sgl_size, tbl_size;
+	unsigned int cmd_size, sgl_size;
 
-	tbl_size = shost->sg_tablesize;
-	if (tbl_size > SG_CHUNK_SIZE)
-		tbl_size = SG_CHUNK_SIZE;
-	sgl_size = tbl_size * sizeof(struct scatterlist);
+	sgl_size = scsi_mq_sgl_size(shost);
 	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
 	if (scsi_host_get_prot(shost))
 		cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;
-- 
2.12.2
