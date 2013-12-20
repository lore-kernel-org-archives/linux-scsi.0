From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/16] scsi_dh_alua: use local buffer for VPD inquiry
Date: Fri, 20 Dec 2013 13:13:31 +0100
Message-ID: <1387541621-54967-7-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab3LTMNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:44 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

VPD inquiry need to be done only once, so we can be using
a local buffer here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 45 ++++++++++++++++++------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index adc77ef..49952f4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -322,16 +322,27 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
  */
 static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 {
+	unsigned char *buff;
+	unsigned char bufflen = 36;
 	int len, timeout = ALUA_FAILOVER_TIMEOUT;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 	unsigned retval;
 	unsigned char *d;
 	unsigned long expiry;
+	int err;
 
 	expiry = round_jiffies_up(jiffies + timeout);
  retry:
-	retval = submit_vpd_inquiry(sdev, h->buff, h->bufflen, sense);
+	buff = kmalloc(bufflen, GFP_ATOMIC);
+	if (!buff) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: kmalloc buffer failed\n",
+			    ALUA_DH_NAME);
+		/* Temporary failure, bypass */
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
+	retval = submit_vpd_inquiry(sdev, buff, bufflen, sense);
 	if (retval) {
 		unsigned err;
 
@@ -345,6 +356,7 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 				err = SCSI_DH_DEV_TEMP_BUSY;
 			else
 				err = SCSI_DH_IO;
+			kfree(buff);
 			return err;
 		}
 		err = alua_check_sense(sdev, &sense_hdr);
@@ -362,24 +374,19 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	}
 
 	/* Check if vpd page exceeds initial buffer */
-	len = (h->buff[2] << 8) + h->buff[3] + 4;
-	if (len > h->bufflen) {
+	len = (buff[2] << 8) + buff[3] + 4;
+	if (len > bufflen) {
 		/* Resubmit with the correct length */
-		if (realloc_buffer(h, len)) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: kmalloc buffer failed\n",
-				    ALUA_DH_NAME);
-			/* Temporary failure, bypass */
-			return SCSI_DH_DEV_TEMP_BUSY;
-		}
+		kfree(buff);
+		bufflen = len;
 		goto retry;
 	}
 
 	/*
 	 * Now look for the correct descriptor.
 	 */
-	d = h->buff + 4;
-	while (d < h->buff + len) {
+	d = buff + 4;
+	while (d < buff + len) {
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
@@ -406,13 +413,15 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME);
 		h->state = TPGS_STATE_OPTIMIZED;
 		h->tpgs = TPGS_MODE_NONE;
-		return SCSI_DH_DEV_UNSUPP;
+		err = SCSI_DH_DEV_UNSUPP;
+	} else {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: port group %02x rel port %02x\n",
+			    ALUA_DH_NAME, h->group_id, h->rel_port);
+		err = SCSI_DH_OK;
 	}
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, h->group_id, h->rel_port);
-
-	return SCSI_DH_OK;
+	kfree(buff);
+	return err;
 }
 
 static char print_alua_state(int state)
-- 
1.7.12.4

