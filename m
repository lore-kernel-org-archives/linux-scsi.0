From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 13/18] scsi: Move sense buffer pointer initialization into scsi_initialize_rq()
Date: Fri, 19 May 2017 11:30:11 -0700
Message-ID: <20170519183016.12646-14-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:51270 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755758AbdESSaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:25 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

This patch is a preparation for the next patch that will zero
the struct scsi_request embedded in struct scsi_cmnd before
calling scsi_req_init().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2e3dc22ecf3..eeb668935836 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1164,6 +1164,7 @@ static void scsi_initialize_rq(struct request *rq)
 	memset((char *)cmd + sizeof(cmd->req), 0,
 		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
 	scsi_req_init(&cmd->req);
+	cmd->req.sense = cmd->sense_buffer;
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
@@ -2022,7 +2023,6 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 		scsi_alloc_sense_buffer(shost, GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
-	cmd->req.sense = cmd->sense_buffer;
 	return 0;
 }
 
@@ -2114,7 +2114,6 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
 		goto fail;
-	cmd->req.sense = cmd->sense_buffer;
 
 	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
 		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp);
-- 
2.12.2
