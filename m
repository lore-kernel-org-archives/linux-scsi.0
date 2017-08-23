From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Improve requeuing behavior
Date: Wed, 23 Aug 2017 14:05:35 -0700
Message-ID: <20170823210535.1072-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11603 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932594AbdHWVGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:06:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Brian King <brking@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

Requests are unprepared and reprepared when being requeued. Avoid
that requeuing resets .jiffies_at_alloc and .retries by initializing
these two member variables from inside blk_get_request() and by
preserving both member variables when preparing a request. This patch
affects the requeuing behavior of scsi-sq and scsi-mq.

Reported-by: Brian King <brking@linux.vnet.ibm.com>
References: https://lkml.org/lkml/2017/8/18/923 ("Re: [BUG][bisected 270065e] linux-next fails to boot on powerpc")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ebc5c713ee37..8d1ec1e7b0e2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1122,6 +1122,8 @@ void scsi_initialize_rq(struct request *rq)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	scsi_req_init(&cmd->req);
+	cmd->jiffies_at_alloc = jiffies;
+	cmd->retries = 0;
 }
 EXPORT_SYMBOL(scsi_initialize_rq);
 
@@ -1160,6 +1162,8 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
 	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
+	unsigned long jiffies_at_alloc = cmd->jiffies_at_alloc;
+	int retries = cmd->retries;
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
@@ -1170,7 +1174,8 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	cmd->prot_sdb = prot;
 	cmd->flags = unchecked_isa_dma;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies;
+	cmd->jiffies_at_alloc = jiffies_at_alloc;
+	cmd->retries = retries;
 
 	scsi_add_cmd_to_list(cmd);
 }
-- 
2.14.0
