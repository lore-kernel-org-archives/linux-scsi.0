From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/20] scsi_dh_alua: allocate RTPG buffer separately
Date: Tue,  8 Dec 2015 08:37:27 +0100
Message-ID: <1449560260-53407-8-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932835AbbLHHho (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:44 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The RTPG buffer will only evaluated within alua_rtpg(),
so we can allocate it locally there and avoid having to
put it into the global structure.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 56 +++++++++++-------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f3191f7..ca6322d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -56,7 +56,7 @@
 #define TPGS_MODE_IMPLICIT		0x1
 #define TPGS_MODE_EXPLICIT		0x2
 
-#define ALUA_INQUIRY_SIZE		36
+#define ALUA_RTPG_SIZE			128
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 
@@ -75,9 +75,6 @@ struct alua_port_group {
 	int			state;
 	int			pref;
 	unsigned		flags; /* used for optimizing STPG */
-	unsigned char		inq[ALUA_INQUIRY_SIZE];
-	unsigned char		*buff;
-	int			bufflen;
 	unsigned char		transition_tmo;
 };
 
@@ -95,21 +92,6 @@ struct alua_dh_data {
 
 static char print_alua_state(int);
 
-static int realloc_buffer(struct alua_port_group *pg, unsigned len)
-{
-	if (pg->buff && pg->buff != pg->inq)
-		kfree(pg->buff);
-
-	pg->buff = kmalloc(len, GFP_NOIO);
-	if (!pg->buff) {
-		pg->buff = pg->inq;
-		pg->bufflen = ALUA_INQUIRY_SIZE;
-		return 1;
-	}
-	pg->bufflen = len;
-	return 0;
-}
-
 static void release_port_group(struct kref *kref)
 {
 	struct alua_port_group *pg;
@@ -118,8 +100,6 @@ static void release_port_group(struct kref *kref)
 	spin_lock(&port_group_lock);
 	list_del(&pg->node);
 	spin_unlock(&port_group_lock);
-	if (pg->buff && pg->inq != pg->buff)
-		kfree(pg->buff);
 	kfree(pg);
 }
 
@@ -201,8 +181,6 @@ struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
 		return NULL;
 
 	pg->group_id = group_id;
-	pg->buff = pg->inq;
-	pg->bufflen = ALUA_INQUIRY_SIZE;
 	pg->tpgs = tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
@@ -387,8 +365,8 @@ static int alua_check_sense(struct scsi_device *sdev,
 static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
 {
 	struct scsi_sense_hdr sense_hdr;
-	int len, k, off, valid_states = 0;
-	unsigned char *ucp;
+	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
+	unsigned char *ucp, *buff;
 	unsigned err, retval;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -399,15 +377,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 	else
 		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
 
+	buff = kzalloc(bufflen, GFP_KERNEL);
+	if (!buff)
+		return SCSI_DH_DEV_TEMP_BUSY;
+
  retry:
-	retval = submit_rtpg(sdev, pg->buff, pg->bufflen,
-			     &sense_hdr, pg->flags);
+	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
 
 	if (retval) {
 		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
+			kfree(buff);
 			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
@@ -445,14 +427,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+		kfree(buff);
 		return SCSI_DH_IO;
 	}
 
-	len = get_unaligned_be32(&pg->buff[0]) + 4;
+	len = get_unaligned_be32(&buff[0]) + 4;
 
-	if (len > pg->bufflen) {
+	if (len > bufflen) {
 		/* Resubmit with the correct length */
-		if (realloc_buffer(pg, len)) {
+		kfree(buff);
+		bufflen = len;
+		buff = kmalloc(bufflen, GFP_KERNEL);
+		if (!buff) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
@@ -462,9 +448,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 	}
 
 	orig_transition_tmo = pg->transition_tmo;
-	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR &&
-	    pg->buff[5] != 0)
-		pg->transition_tmo = pg->buff[5];
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
+		pg->transition_tmo = buff[5];
 	else
 		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
@@ -476,12 +461,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 		expiry = jiffies + pg->transition_tmo * HZ;
 	}
 
-	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
 		tpg_desc_tbl_off = 8;
 	else
 		tpg_desc_tbl_off = 4;
 
-	for (k = tpg_desc_tbl_off, ucp = pg->buff + tpg_desc_tbl_off;
+	for (k = tpg_desc_tbl_off, ucp = buff + tpg_desc_tbl_off;
 	     k < len;
 	     k += off, ucp += off) {
 
@@ -531,6 +516,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 		err = SCSI_DH_OK;
 		break;
 	}
+	kfree(buff);
 	return err;
 }
 
-- 
1.8.5.6

