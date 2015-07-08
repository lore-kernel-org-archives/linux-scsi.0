From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/20] scsi_dh_alua: put sense buffer on stack
Date: Wed,  8 Jul 2015 11:06:08 +0200
Message-ID: <1436346378-96518-11-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934509AbbGHJGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:32 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

We don't need to have the sense buffer available all the time,
putting it on stack is totally sufficient.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 61301cf..ea4a920 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -75,8 +75,6 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
-	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
-	int			senselen;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -379,6 +377,7 @@ static int alua_check_sense(struct scsi_device *sdev,
  */
 static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
 {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
@@ -393,11 +392,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, sense, h->flags);
 
 	if (retval) {
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
-		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
@@ -532,6 +531,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int retval;
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 
 	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
@@ -564,11 +564,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	}
 	/* Set state to transitioning */
 	h->state = TPGS_STATE_TRANSITIONING;
-	retval = submit_stpg(sdev, h->group_id, h->sense);
+	retval = submit_stpg(sdev, h->group_id, sense);
 
 	if (retval) {
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
-		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: stpg failed, result %d",
-- 
1.8.5.2

