From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/36] scsi_dh_alua: use flag for RTPG extended header
Date: Tue, 29 Sep 2015 12:47:13 +0200
Message-ID: <1443523658-87622-12-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934669AbbI2Kry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:54 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

We should be using a flag when RTPG extended header is not
supported, that saves us sending RTPG twice for older arrays.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4ff9b90..a963f51 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -59,8 +59,9 @@
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 
-/* flags passed from user level */
+/* device handler flags */
 #define ALUA_OPTIMIZE_STPG		1
+#define ALUA_RTPG_EXT_HDR_UNSUPP	2
 
 struct alua_dh_data {
 	int			group_id;
@@ -134,8 +135,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
-static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
-			    bool rtpg_ext_hdr_req)
+static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	struct request *rq;
 	int err = 0;
@@ -148,7 +148,7 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
-	if (rtpg_ext_hdr_req)
+	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
 		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
 		rq->cmd[1] = MI_REPORT_TARGET_PGS;
@@ -484,7 +484,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
 	unsigned err, retval;
-	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
@@ -495,7 +494,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
+	retval = submit_rtpg(sdev, h);
 	if (retval) {
 		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
@@ -515,10 +514,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		 * The retry without rtpg_ext_hdr_req set
 		 * handles this.
 		 */
-		if (rtpg_ext_hdr_req == 1 &&
+		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
 		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
 		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
-			rtpg_ext_hdr_req = 0;
+			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
 
-- 
1.8.5.6

