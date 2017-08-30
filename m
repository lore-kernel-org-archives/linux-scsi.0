From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 2/3] Improve requeuing behavior
Date: Tue, 29 Aug 2017 17:07:41 -0700
Message-ID: <20170830000742.29653-3-bart.vanassche@wdc.com>
References: <20170830000742.29653-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9135 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751514AbdH3AIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 20:08:51 -0400
In-Reply-To: <20170830000742.29653-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Brian King <brking@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

Requests are unprepared and reprepared when being requeued.
Avoid that requeuing resets .jiffies_at_alloc and .retries by
initializing these two member variables from inside
scsi_initialize_rq() and by preserving both member variables
when preparing a request. This patch affects the requeuing
behavior of both the legacy scsi and the scsi-mq code paths.

Reported-by: Brian King <brking@linux.vnet.ibm.com>
References: https://lkml.org/lkml/2017/8/18/923 ("Re: [BUG][bisected 270065e] linux-next fails to boot on powerpc")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 170a725e33ce..60fff8468620 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1112,9 +1112,13 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_init_io);
 
 /**
- * scsi_initialize_rq - initialize struct scsi_cmnd.req
+ * scsi_initialize_rq - initialize struct scsi_cmnd partially
  * @rq: Request associated with the SCSI command to be initialized.
  *
+ * This function initializes the members of struct scsi_cmnd that must be
+ * initialized before request processing starts and that won't be
+ * reinitialized if a SCSI command is requeued.
+ *
  * Called from inside blk_get_request() for pass-through requests and from
  * inside scsi_init_command() for filesystem requests.
  */
@@ -1123,6 +1127,8 @@ void scsi_initialize_rq(struct request *rq)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	scsi_req_init(&cmd->req);
+	cmd->jiffies_at_alloc = jiffies;
+	cmd->retries = 0;
 }
 EXPORT_SYMBOL(scsi_initialize_rq);
 
@@ -1162,6 +1168,8 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	void *prot = cmd->prot_sdb;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
+	unsigned long jiffies_at_alloc = cmd->jiffies_at_alloc;
+	int retries = cmd->retries;
 
 	if (!blk_rq_is_scsi(rq) && !(flags & SCMD_INITIALIZED)) {
 		flags |= SCMD_INITIALIZED;
@@ -1177,7 +1185,8 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	cmd->prot_sdb = prot;
 	cmd->flags = flags;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies;
+	cmd->jiffies_at_alloc = jiffies_at_alloc;
+	cmd->retries = retries;
 
 	scsi_add_cmd_to_list(cmd);
 }
-- 
2.14.1
