From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/20] scsi_dh_alua: Pass buffer as function argument
Date: Wed,  8 Jul 2015 11:06:05 +0200
Message-ID: <1436346378-96518-8-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934485AbbGHJGa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:30 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Pass in the buffer as a function argument for submit_vpd() and
submit_rtpg().

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 3f4fe0e..28a3b99 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
@@ -136,12 +137,13 @@ static struct request *get_alua_req(struct scsi_device *sdev,
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
-static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
+static unsigned submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
+			    int bufflen, unsigned char *sense, int flags)
 {
 	struct request *rq;
 	int err;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
+	rq = get_alua_req(sdev, buff, bufflen, READ);
 	if (!rq) {
 		err = DRIVER_BUSY << 24;
 		goto done;
@@ -149,25 +151,21 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
-	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
+	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
 		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
 		rq->cmd[1] = MI_REPORT_TARGET_PGS;
-	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
-	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
-	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
-	rq->cmd[9] = h->bufflen & 0xff;
+	put_unaligned_be32(bufflen, &rq->cmd[6]);
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->sense_len = 0;
 
 	blk_execute_rq(rq->q, NULL, rq, 1);
-	if (rq->errors) {
+	if (rq->errors)
 		err = rq->errors;
-		h->senselen = rq->sense_len;
-	}
+
 	blk_put_request(rq);
 done:
 	return err;
@@ -497,7 +495,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
 
 	if (retval) {
 		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-- 
1.8.5.2

