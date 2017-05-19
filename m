From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 11/18] scsi: Move most of scsi_init_command() into scsi_initialize_rq()
Date: Fri, 19 May 2017 11:30:09 -0700
Message-ID: <20170519183016.12646-12-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16178 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755837AbdESSah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:37 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

Move the initializations that only have to be performed once and
not every time a request is prepared from scsi_init_command()
into scsi_initialize_rq(). This patch also moves the
jiffies_at_alloc assignment such that it gets back the meaning it
had before commit e9c787e65c0c, namely the value of the jiffies
counter at request allocation time.

Fixes: commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a8d4f17ad5aa..68ce053b184b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1156,26 +1156,24 @@ void scsi_del_cmd_from_list(struct scsi_cmnd *cmd)
 static void scsi_initialize_rq(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
-
-	scsi_req_init(&cmd->req);
-}
-
-/* Called after a request has been started. */
-void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
-{
+	struct scsi_device *dev = rq->q->queuedata;
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
 		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
-
+	scsi_req_init(&cmd->req);
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
+}
 
+/* Called after a request has been started. */
+void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
+{
 	scsi_add_cmd_to_list(cmd);
 }
 
-- 
2.12.2
