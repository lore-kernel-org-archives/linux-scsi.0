From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/2] SCSI: revert clear-garbage-after-CDB fix
Date: Sat, 16 Dec 2006 19:44:48 +0900
Message-ID: <20061216104448.GB5400@htj.dyndns.org>
References: <20061216104331.GA5400@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061216104331.GA5400@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Upper layer is already passing in enough information via req->cmd_len
and requiring it to do the same thing twice makes it easy to miss -
scsi_execute() doesn't do it.

Now that libata is updated to handle garbage after CDB, remove
unnecessary CDB clearing.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
---
The previous one was [PATCH 1/2], sorry.

 block/scsi_ioctl.c      |    1 -
 drivers/scsi/scsi_lib.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f322b6a..513d82c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -262,7 +262,6 @@ static int sg_io(struct file *file, request_queue_t *q,
 	 * fill in request structure
 	 */
 	rq->cmd_len = hdr->cmd_len;
-	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 	memcpy(rq->cmd, cmd, hdr->cmd_len);
 
 	memset(sense, 0, sizeof(sense));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1748e27..a1df156 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -410,7 +410,6 @@ int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
 		goto free_req;
 
 	req->cmd_len = cmd_len;
-	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sioc->sense;
 	req->sense_len = 0;
-- 
1.4.4.2

