From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 06/23] scsi_dh_alua: allocate RTPG buffer separately
Date: Fri, 19 Feb 2016 09:17:03 +0100
Message-ID: <1455869840-122786-7-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427026AbcBSIRq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:46 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The RTPG buffer will only evaluated within alua_rtpg(),
so we can allocate it locally there and avoid having to
put it into the global structure.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 57 ++++++++++++------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 73df60e..af5acc1 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -56,7 +56,7 @@
 #define TPGS_MODE_IMPLICIT		0x1
 #define TPGS_MODE_EXPLICIT		0x2
 
-#define ALUA_INQUIRY_SIZE		36
+#define ALUA_RTPG_SIZE			128
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 
@@ -71,9 +71,6 @@ struct alua_dh_data {
 	int			state;
 	int			pref;
 	unsigned		flags; /* used for optimizing STPG */
-	unsigned char		inq[ALUA_INQUIRY_SIZE];
-	unsigned char		*buff;
-	int			bufflen;
 	unsigned char		transition_tmo;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
@@ -85,21 +82,6 @@ struct alua_dh_data {
 
 static char print_alua_state(int);
 
-static int realloc_buffer(struct alua_dh_data *h, unsigned len)
-{
-	if (h->buff && h->buff != h->inq)
-		kfree(h->buff);
-
-	h->buff = kmalloc(len, GFP_NOIO);
-	if (!h->buff) {
-		h->buff = h->inq;
-		h->bufflen = ALUA_INQUIRY_SIZE;
-		return 1;
-	}
-	h->bufflen = len;
-	return 0;
-}
-
 /*
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
@@ -333,8 +315,8 @@ static int alua_check_sense(struct scsi_device *sdev,
 static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
 {
 	struct scsi_sense_hdr sense_hdr;
-	int len, k, off, valid_states = 0;
-	unsigned char *ucp;
+	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
+	unsigned char *ucp, *buff;
 	unsigned err, retval;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -345,14 +327,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	else
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
+	buff = kzalloc(bufflen, GFP_KERNEL);
+	if (!buff)
+		return SCSI_DH_DEV_TEMP_BUSY;
+
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, &sense_hdr, h->flags);
+	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, h->flags);
 
 	if (retval) {
 		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
+			kfree(buff);
 			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
@@ -390,14 +377,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+		kfree(buff);
 		return SCSI_DH_IO;
 	}
 
-	len = get_unaligned_be32(&h->buff[0]) + 4;
+	len = get_unaligned_be32(&buff[0]) + 4;
 
-	if (len > h->bufflen) {
+	if (len > bufflen) {
 		/* Resubmit with the correct length */
-		if (realloc_buffer(h, len)) {
+		kfree(buff);
+		bufflen = len;
+		buff = kmalloc(bufflen, GFP_KERNEL);
+		if (!buff) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
@@ -407,24 +398,25 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	}
 
 	orig_transition_tmo = h->transition_tmo;
-	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && h->buff[5] != 0)
-		h->transition_tmo = h->buff[5];
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
+		h->transition_tmo = buff[5];
 	else
 		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
-	if (wait_for_transition && (orig_transition_tmo != h->transition_tmo)) {
+	if (wait_for_transition &&
+	    (orig_transition_tmo != h->transition_tmo)) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, h->transition_tmo);
 		expiry = jiffies + h->transition_tmo * HZ;
 	}
 
-	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
 		tpg_desc_tbl_off = 8;
 	else
 		tpg_desc_tbl_off = 4;
 
-	for (k = tpg_desc_tbl_off, ucp = h->buff + tpg_desc_tbl_off;
+	for (k = tpg_desc_tbl_off, ucp = buff + tpg_desc_tbl_off;
 	     k < len;
 	     k += off, ucp += off) {
 
@@ -474,6 +466,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		err = SCSI_DH_OK;
 		break;
 	}
+	kfree(buff);
 	return err;
 }
 
@@ -668,8 +661,6 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h->state = TPGS_STATE_OPTIMIZED;
 	h->group_id = -1;
 	h->rel_port = -1;
-	h->buff = h->inq;
-	h->bufflen = ALUA_INQUIRY_SIZE;
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
@@ -691,8 +682,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 
-	if (h->buff && h->inq != h->buff)
-		kfree(h->buff);
 	sdev->handler_data = NULL;
 	kfree(h);
 }
-- 
1.8.5.6

