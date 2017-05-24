From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 23/31] scsi: Move sense buffer pointer initialization into scsi_initialize_rq()
Date: Tue, 23 May 2017 17:34:12 -0700
Message-ID: <20170524003420.5381-24-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

This patch is a preparation for the next patch that will zero
the struct scsi_request embedded in struct scsi_cmnd before
calling scsi_req_init().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 359f824ab78c..10c6adb208dc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1164,6 +1164,7 @@ static void scsi_initialize_rq(struct request *rq)
 	       sizeof(*cmd) - sizeof(cmd->req));
 	scsi_req_init(&cmd->req);
 	cmd->device = dev;
+	cmd->req.sense = cmd->sense_buffer;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
@@ -2025,7 +2026,6 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 						    GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
-	cmd->req.sense = cmd->sense_buffer;
 	return 0;
 }
 
@@ -2123,7 +2123,6 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 						    NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
 		goto fail;
-	cmd->req.sense = cmd->sense_buffer;
 
 	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
 		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp);
-- 
2.12.2
