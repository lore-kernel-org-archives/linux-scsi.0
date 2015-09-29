From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/36] scsi_dh_alua: Pass buffer as function argument
Date: Tue, 29 Sep 2015 12:47:15 +0200
Message-ID: <1443523658-87622-14-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934662AbbI2Kry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:54 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Pass in the buffer as a function argument for submit_rtpg().

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8571e57..63423b2 100644
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
 	int err = 0;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
+	rq = get_alua_req(sdev, buff, bufflen, READ);
 	if (!rq) {
 		err = DRIVER_BUSY << 24;
 		goto done;
@@ -149,14 +150,14 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
-	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
+	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
 		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
 		rq->cmd[1] = MI_REPORT_TARGET_PGS;
-	put_unaligned_be32(h->bufflen, &rq->cmd[6]);
+	put_unaligned_be32(bufflen, &rq->cmd[6]);
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
@@ -488,7 +489,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
 	if (retval) {
 		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
-- 
1.8.5.6

