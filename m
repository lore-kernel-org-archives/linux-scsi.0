From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/18] scsi: Change argument type of scsi_req_init()
Date: Fri, 19 May 2017 11:30:07 -0700
Message-ID: <20170519183016.12646-10-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16178 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755988AbdESSa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:27 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Since scsi_req_init() works on a struct scsi_request, change the
argument type into struct scsi_request *.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 block/scsi_ioctl.c                | 10 +++++++---
 drivers/ide/ide-probe.c           |  2 +-
 drivers/scsi/scsi_lib.c           |  4 +++-
 drivers/scsi/scsi_transport_sas.c |  2 +-
 include/scsi/scsi_request.h       |  2 +-
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f96c51f5df40..7440de44dd85 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -741,10 +741,14 @@ int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
 }
 EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
 
-void scsi_req_init(struct request *rq)
+/**
+ * scsi_req_init - initialize certain fields of a scsi_request structure
+ * @req: Pointer to a scsi_request structure.
+ * Initializes .__cmd[], .cmd, .cmd_len and .sense_len but no other members
+ * of struct scsi_request.
+ */
+void scsi_req_init(struct scsi_request *req)
 {
-	struct scsi_request *req = scsi_req(rq);
-
 	memset(req->__cmd, 0, sizeof(req->__cmd));
 	req->cmd = req->__cmd;
 	req->cmd_len = BLK_MAX_CDB;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 824eae707d25..5f77e31c9487 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -745,7 +745,7 @@ static void ide_initialize_rq(struct request *rq)
 {
 	struct ide_request *req = blk_mq_rq_to_pdu(rq);
 
-	scsi_req_init(rq);
+	scsi_req_init(&req->sreq);
 	req->sreq.sense = req->sense;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a294a010d585..efa5741cab02 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1136,7 +1136,9 @@ EXPORT_SYMBOL(scsi_init_io);
 /* Called from inside blk_get_request() */
 static void scsi_initialize_rq(struct request *rq)
 {
-	scsi_req_init(rq);
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+
+	scsi_req_init(&cmd->req);
 }
 
 /* Called after a request has been started. */
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 6de65e73201d..fc049b0265ee 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -215,7 +215,7 @@ static void sas_host_release(struct device *dev)
 
 static void sas_initialize_rq(struct request *rq)
 {
-	scsi_req_init(rq);
+	scsi_req_init(scsi_req(rq));
 }
 
 static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index f0c76f9dc285..e0afa445ee4e 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -27,6 +27,6 @@ static inline void scsi_req_free_cmd(struct scsi_request *req)
 		kfree(req->cmd);
 }
 
-void scsi_req_init(struct request *);
+void scsi_req_init(struct scsi_request *req);
 
 #endif /* _SCSI_SCSI_REQUEST_H */
-- 
2.12.2
