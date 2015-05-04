From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/17] scsi_dh_alua: Pass buffer as function argument
Date: Mon,  4 May 2015 14:42:13 +0200
Message-ID: <1430743343-47174-8-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbbEDMmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:39 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Pass in the buffer as a function argument for submit_vpd() and
submit_rtpg().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 69cad2a..1bfc7a4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -136,12 +136,13 @@ static struct request *get_alua_req(struct scsi_device *sdev,
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
@@ -149,19 +150,19 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 
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
+	rq->cmd[6] = (bufflen >> 24) & 0xff;
+	rq->cmd[7] = (bufflen >> 16) & 0xff;
+	rq->cmd[8] = (bufflen >>  8) & 0xff;
+	rq->cmd[9] = bufflen & 0xff;
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->sense_len = 0;
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err < 0) {
@@ -169,7 +170,8 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			err = DID_ERROR << 16;
 		else
 			err = rq->errors;
-		h->senselen = rq->sense_len;
+		if (rq->sense_len)
+			err |= (DRIVER_SENSE << 24);
 	}
 	blk_put_request(rq);
 done:
@@ -509,10 +511,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
 
 	if (retval) {
-		if (h->senselen == 0 ||
+	    if (!(driver_byte(retval) & DRIVER_SENSE) ||
 		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
-- 
1.8.5.2

