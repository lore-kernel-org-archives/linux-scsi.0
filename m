From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 3/7] scsi: add scsi-mq helpers to retrieve pdu and check started state
Date: Fri, 3 Apr 2015 09:58:19 -0600
Message-ID: <1428076703-31014-4-git-send-email-axboe@fb.com>
References: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428076703-31014-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

scsi_mq_scmd_to_pdu() returns the LLD pdu associated with a struct
scsi_cmnd.

scsi_mq_scmd_start() returns whether or not a given scsi command
has been started or not.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 include/scsi/scsi_cmnd.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9fc1aecfc813..df02c89e8714 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -8,6 +8,7 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_device.h>
+#include <linux/blk-mq.h>
 
 struct Scsi_Host;
 struct scsi_driver;
@@ -155,6 +156,16 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
+static inline void *scsi_mq_scmd_to_pdu(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_to_pdu(scmd->request) + sizeof(*scmd);
+}
+
+static inline bool scsi_mq_scmd_started(struct scsi_cmnd *scmd)
+{
+	return blk_mq_request_started(scmd->request);
+}
+
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
-- 
1.9.1
