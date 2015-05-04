From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/17] scsi_dh_alua: use flag for RTPG extended header
Date: Mon,  4 May 2015 14:42:12 +0200
Message-ID: <1430743343-47174-7-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbbEDMm2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:28 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

We should be using a flag when RTPG extended header is not
supported, that saves us sending RTPG twice for older arrays.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f5d5859..69cad2a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -61,6 +61,7 @@
 
 /* flags passed from user level */
 #define ALUA_OPTIMIZE_STPG		1
+#define ALUA_RTPG_EXT_HDR_UNSUPP	2
 
 struct alua_dh_data {
 	int			group_id;
@@ -135,8 +136,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
-static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
-			    bool rtpg_ext_hdr_req)
+static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	struct request *rq;
 	int err;
@@ -149,7 +149,7 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
-	if (rtpg_ext_hdr_req)
+	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
 		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
 		rq->cmd[1] = MI_REPORT_TARGET_PGS;
@@ -499,7 +499,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
 	unsigned err, retval;
-	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
@@ -510,7 +509,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
+	retval = submit_rtpg(sdev, h);
 
 	if (retval) {
 		if (h->senselen == 0 ||
@@ -534,10 +533,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
1.8.5.2

