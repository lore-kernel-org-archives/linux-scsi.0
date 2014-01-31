From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/16] scsi_dh_alua: put sense buffer on stack
Date: Fri, 31 Jan 2014 10:29:49 +0100
Message-ID: <1391160600-19652-6-git-send-email-hare@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbaAaJaI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:08 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

There is no need to have the sense buffer as part of the per-device
structure, we can put the sense buffer on the stack.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ef92008..adc77ef 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -74,8 +74,6 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
-	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
-	int			senselen;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -325,6 +323,7 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int len, timeout = ALUA_FAILOVER_TIMEOUT;
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 	unsigned retval;
 	unsigned char *d;
@@ -332,12 +331,12 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	expiry = round_jiffies_up(jiffies + timeout);
  retry:
-	retval = submit_vpd_inquiry(sdev, h->buff, h->bufflen, h->sense);
+	retval = submit_vpd_inquiry(sdev, h->buff, h->bufflen, sense);
 	if (retval) {
 		unsigned err;
 
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
-		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: evpd inquiry failed, ", ALUA_DH_NAME);
@@ -519,6 +518,7 @@ static int alua_check_sense(struct scsi_device *sdev,
  */
 static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
 {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
@@ -533,11 +533,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, sense, h->flags);
 
 	if (retval) {
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
-		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
 				    ALUA_DH_NAME);
-- 
1.7.12.4

