From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -2nd repost 4/4] SCSI: scsi_lib, fix potential NULL dereference
Date: Wed,  4 Nov 2009 17:15:21 +0100
Message-ID: <1257351321-8281-4-git-send-email-jirislaby@gmail.com>
References: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757187AbZKDQPe@vger.kernel.org>
In-Reply-To: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: aacraid@adaptec.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Stanse found a potential NULL dereference in scsi_kill_request.

Instead of triggering BUG() in 'if (unlikely(cmd == NULL))' branch,
the kernel will Oops earlier on cmd dereference.

Move the dereferences after the if.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_lib.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ed98279..47ee130 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1359,9 +1359,9 @@ static int scsi_lld_busy(struct request_queue *q)
 static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
-	struct scsi_device *sdev = cmd->device;
-	struct scsi_target *starget = scsi_target(sdev);
-	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *sdev;
+	struct scsi_target *starget;
+	struct Scsi_Host *shost;
 
 	blk_start_request(req);
 
@@ -1371,6 +1371,9 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 		BUG();
 	}
 
+	sdev = cmd->device;
+	starget = scsi_target(sdev);
+	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
-- 
1.6.4.2
