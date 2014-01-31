From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/16] scsi_dh_alua: Pass buffer as function argument
Date: Fri, 31 Jan 2014 10:29:47 +0100
Message-ID: <1391160600-19652-4-git-send-email-hare@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaAaJaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:03 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Pass in the buffer as a function argument for submit_vpd() and
submit_rtpg().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 44 ++++++++++++++++--------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ece2255..5358c2f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -143,12 +143,13 @@ static struct request *get_alua_req(struct scsi_device *sdev,
  * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
  * @sdev: sdev the command should be sent to
  */
-static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
+static int submit_vpd_inquiry(struct scsi_device *sdev, unsigned char *buff,
+			      int bufflen, unsigned char *sense)
 {
 	struct request *rq;
 	int err;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
+	rq = get_alua_req(sdev, buff, bufflen, READ);
 	if (!rq) {
 		err = DRIVER_BUSY << 24;
 		goto done;
@@ -158,12 +159,12 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	rq->cmd[0] = INQUIRY;
 	rq->cmd[1] = 1;
 	rq->cmd[2] = 0x83;
-	rq->cmd[4] = h->bufflen;
+	rq->cmd[4] = bufflen;
 	rq->cmd_len = COMMAND_SIZE(INQUIRY);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->sense_len = 0;
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err < 0) {
@@ -171,7 +172,8 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			err = DID_ERROR << 16;
 		else
 			err = rq->errors;
-		h->senselen = rq->sense_len;
+		if (rq->sense_len)
+			err |= (DRIVER_SENSE << 24);
 	}
 	blk_put_request(rq);
 done:
@@ -182,12 +184,13 @@ done:
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
@@ -195,19 +198,19 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 
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
@@ -215,7 +218,8 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			err = DID_ERROR << 16;
 		else
 			err = rq->errors;
-		h->senselen = rq->sense_len;
+		if (rq->sense_len)
+			err |= (DRIVER_SENSE << 24);
 	}
 	blk_put_request(rq);
 done:
@@ -374,11 +378,11 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	expiry = round_jiffies_up(jiffies + timeout);
  retry:
-	retval = submit_vpd_inquiry(sdev, h);
+	retval = submit_vpd_inquiry(sdev, h->buff, h->bufflen, h->sense);
 	if (retval) {
 		unsigned err;
 
-		if (h->senselen == 0 ||
+		if (!(driver_byte(retval) & DRIVER_SENSE) ||
 		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
@@ -575,10 +579,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
 
 	if (retval) {
-		if (h->senselen == 0 ||
+		if (!(driver_byte(retval) & DRIVER_SENSE) ||
 		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
-- 
1.7.12.4

