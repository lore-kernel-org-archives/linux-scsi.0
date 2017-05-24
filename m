From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 24/31] scsi: Make scsi_initialize_rq() zero the entire struct scsi_cmnd
Date: Tue, 23 May 2017 17:34:13 -0700
Message-ID: <20170524003420.5381-25-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

This simplifies the memset() call in scsi_initialize_rq() and avoids
that any stale data is left behind in struct scsi_request.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 10c6adb208dc..4b24c45fa113 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1159,12 +1159,10 @@ static void scsi_initialize_rq(struct request *rq)
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
 
-	/* zero out the cmd, except for the embedded scsi_request */
-	memset((char *)cmd + sizeof(cmd->req), 0,
-	       sizeof(*cmd) - sizeof(cmd->req));
+	memset(cmd, 0, sizeof(*cmd));
 	scsi_req_init(&cmd->req);
 	cmd->device = dev;
-	cmd->req.sense = cmd->sense_buffer;
+	cmd->req.sense = buf;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-- 
2.12.2
