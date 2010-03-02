From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: [PATCH] Don't change direction flags in struct request.
Date: Tue, 2 Mar 2010 00:04:51 +0000 (UTC)
Message-ID: <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 18 Mar 2010 22:31:30 -0700
In-Reply-To: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, Eddie Williams <Eddie.Williams@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hugh Daschbach <hdasch@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

The EMC multipath device handler should not change the I/O direction
flags of its trespass command request.

The CFQ elevator may BUG if the direction flags on an I/O request are
changed after allocation.  cfq_set_request() and cfq_put_request()
count READ and WRITE requests separately.  Changing the I/O request
direction after blk_get_request() allocates the request throws off
this CFQ accounting.

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6196675..3709342 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -269,10 +269,12 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 				unsigned char *buffer)
 {
 	struct request *rq;
+	int mode = READ;
 	int len = 0;
 
-	rq = blk_get_request(sdev->request_queue,
-			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
+	if (cmd == MODE_SELECT || cmd == MODE_SELECT_10)
+		mode = WRITE;
+	rq = blk_get_request(sdev->request_queue, mode, GFP_NOIO);
 	if (!rq) {
 		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
 		return NULL;
@@ -284,12 +286,10 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 	switch (cmd) {
 	case MODE_SELECT:
 		len = sizeof(short_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		break;
 	case INQUIRY:
-- 
1.6.6.196.g1f735
