From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/16] scsi_dh_alua: Use separate alua_port_group structure
Date: Fri, 31 Jan 2014 10:29:51 +0100
Message-ID: <1391160600-19652-8-git-send-email-hare@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaAaJaJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:09 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The port group needs to be a separate structure as several
LUNs might belong to the same group.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 220 ++++++++++++++++++-----------
 1 file changed, 139 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 88f98e0..0af6866 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -63,9 +63,13 @@
 #define ALUA_OPTIMIZE_STPG		1
 #define ALUA_RTPG_EXT_HDR_UNSUPP	2
 
-struct alua_dh_data {
+static LIST_HEAD(port_group_list);
+static DEFINE_SPINLOCK(port_group_lock);
+
+struct alua_port_group {
+	struct kref		kref;
+	struct list_head	node;
 	int			group_id;
-	int			rel_port;
 	int			tpgs;
 	int			state;
 	int			pref;
@@ -74,6 +78,13 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
+};
+
+struct alua_dh_data {
+	struct alua_port_group	*pg;
+	int			rel_port;
+	int			tpgs;
+	unsigned		flags; /* used for optimizing STPG */
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -92,18 +103,18 @@ static inline struct alua_dh_data *get_alua_data(struct scsi_device *sdev)
 	return ((struct alua_dh_data *) scsi_dh_data->buf);
 }
 
-static int realloc_buffer(struct alua_dh_data *h, unsigned len)
+static int realloc_buffer(struct alua_port_group *pg, unsigned len)
 {
-	if (h->buff && h->buff != h->inq)
-		kfree(h->buff);
+	if (pg->buff && pg->buff != pg->inq)
+		kfree(pg->buff);
 
-	h->buff = kmalloc(len, GFP_NOIO);
-	if (!h->buff) {
-		h->buff = h->inq;
-		h->bufflen = ALUA_INQUIRY_SIZE;
+	pg->buff = kmalloc(len, GFP_NOIO);
+	if (!pg->buff) {
+		pg->buff = pg->inq;
+		pg->bufflen = ALUA_INQUIRY_SIZE;
 		return 1;
 	}
-	h->bufflen = len;
+	pg->bufflen = len;
 	return 0;
 }
 
@@ -137,6 +148,20 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 	return rq;
 }
 
+static void release_port_group(struct kref *kref)
+{
+	struct alua_port_group *pg;
+
+	pg = container_of(kref, struct alua_port_group, kref);
+	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id);
+	spin_lock(&port_group_lock);
+	list_del(&pg->node);
+	spin_unlock(&port_group_lock);
+	if (pg->buff && pg->inq != pg->buff)
+		kfree(pg->buff);
+	kfree(pg);
+}
+
 /*
  * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
  * @sdev: sdev the command should be sent to
@@ -327,10 +352,11 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	int len, timeout = ALUA_FAILOVER_TIMEOUT;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
-	unsigned retval;
+	unsigned retval, err;
+	int group_id = -1;
 	unsigned char *d;
 	unsigned long expiry;
-	int err;
+	struct alua_port_group *pg = NULL;
 
 	expiry = round_jiffies_up(jiffies + timeout);
  retry:
@@ -344,8 +370,6 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	}
 	retval = submit_vpd_inquiry(sdev, buff, bufflen, sense);
 	if (retval) {
-		unsigned err;
-
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
 		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
@@ -356,8 +380,7 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 				err = SCSI_DH_DEV_TEMP_BUSY;
 			else
 				err = SCSI_DH_IO;
-			kfree(buff);
-			return err;
+			goto out;
 		}
 		err = alua_check_sense(sdev, &sense_hdr);
 		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
@@ -369,7 +392,8 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: evpd inquiry failed, ", ALUA_DH_NAME);
 			scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
-			return SCSI_DH_IO;
+			err = SCSI_DH_IO;
+			goto out;
 		}
 	}
 
@@ -394,7 +418,7 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			break;
 		case 0x5:
 			/* Target port group */
-			h->group_id = (d[6] << 8) + d[7];
+			group_id = (d[6] << 8) + d[7];
 			break;
 		default:
 			break;
@@ -402,7 +426,7 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 		d += d[3] + 4;
 	}
 
-	if (h->group_id == -1) {
+	if (group_id == -1) {
 		/*
 		 * Internal error; TPGS supported but required
 		 * VPD identification descriptors not present.
@@ -411,15 +435,37 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: No target port descriptors found\n",
 			    ALUA_DH_NAME);
-		h->state = TPGS_STATE_OPTIMIZED;
 		h->tpgs = TPGS_MODE_NONE;
 		err = SCSI_DH_DEV_UNSUPP;
-	} else {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: port group %02x rel port %02x\n",
-			    ALUA_DH_NAME, h->group_id, h->rel_port);
-		err = SCSI_DH_OK;
+		goto out;
 	}
+
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x rel port %02x\n",
+		    ALUA_DH_NAME, group_id, h->rel_port);
+	spin_lock(&port_group_lock);
+	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
+	if (!pg) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: kzalloc port group failed\n",
+			    ALUA_DH_NAME);
+		/* Temporary failure, bypass */
+		spin_unlock(&port_group_lock);
+		err = SCSI_DH_DEV_TEMP_BUSY;
+		goto out;
+	}
+	pg->group_id = group_id;
+	pg->buff = pg->inq;
+	pg->bufflen = ALUA_INQUIRY_SIZE;
+	pg->tpgs = h->tpgs;
+	pg->state = TPGS_STATE_OPTIMIZED;
+	pg->flags = h->flags;
+	kref_init(&pg->kref);
+	list_add(&pg->node, &port_group_list);
+	h->pg = pg;
+	spin_unlock(&port_group_lock);
+	err = SCSI_DH_OK;
+out:
 	kfree(buff);
 	return err;
 }
@@ -525,7 +571,7 @@ static int alua_check_sense(struct scsi_device *sdev,
  * Returns SCSI_DH_DEV_OFFLINED if the path is
  * found to be unusable.
  */
-static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
+static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
 {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
@@ -536,13 +582,13 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 
-	if (!h->transition_tmo)
+	if (!pg->transition_tmo)
 		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
 	else
-		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
+		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, sense, h->flags);
+	retval = submit_rtpg(sdev, pg->buff, pg->bufflen, sense, pg->flags);
 
 	if (retval) {
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
@@ -566,10 +612,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		 * The retry without rtpg_ext_hdr_req set
 		 * handles this.
 		 */
-		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
+		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
 		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
 		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
-			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
+			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
 
@@ -592,12 +638,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		return SCSI_DH_IO;
 	}
 
-	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
-		(h->buff[2] << 8) + h->buff[3] + 4;
+	len = (pg->buff[0] << 24) + (pg->buff[1] << 16) +
+		(pg->buff[2] << 8) + pg->buff[3] + 4;
 
-	if (len > h->bufflen) {
+	if (len > pg->bufflen) {
 		/* Resubmit with the correct length */
-		if (realloc_buffer(h, len)) {
+		if (realloc_buffer(pg, len)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
@@ -606,31 +652,32 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		goto retry;
 	}
 
-	orig_transition_tmo = h->transition_tmo;
-	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && h->buff[5] != 0)
-		h->transition_tmo = h->buff[5];
+	orig_transition_tmo = pg->transition_tmo;
+	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR &&
+	    pg->buff[5] != 0)
+		pg->transition_tmo = pg->buff[5];
 	else
-		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
+		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
-	if (wait_for_transition && (orig_transition_tmo != h->transition_tmo)) {
+	if (wait_for_transition && (orig_transition_tmo != pg->transition_tmo)) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
-			    ALUA_DH_NAME, h->transition_tmo);
-		expiry = jiffies + h->transition_tmo * HZ;
+			    ALUA_DH_NAME, pg->transition_tmo);
+		expiry = jiffies + pg->transition_tmo * HZ;
 	}
 
-	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
 		tpg_desc_tbl_off = 8;
 	else
 		tpg_desc_tbl_off = 4;
 
-	for (k = tpg_desc_tbl_off, ucp = h->buff + tpg_desc_tbl_off;
+	for (k = tpg_desc_tbl_off, ucp = pg->buff + tpg_desc_tbl_off;
 	     k < len;
 	     k += off, ucp += off) {
 
-		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
-			h->state = ucp[0] & 0x0f;
-			h->pref = ucp[0] >> 7;
+		if (pg->group_id == (ucp[2] << 8) + ucp[3]) {
+			pg->state = ucp[0] & 0x0f;
+			pg->pref = ucp[0] >> 7;
 			valid_states = ucp[1];
 		}
 		off = 8 + (ucp[7] * 4);
@@ -638,8 +685,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
-		    h->pref ? "preferred" : "non-preferred",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred",
 		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
 		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
 		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
@@ -648,7 +695,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
 		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
-	switch (h->state) {
+	switch (pg->state) {
 	case TPGS_STATE_TRANSITIONING:
 		if (wait_for_transition) {
 			if (time_before(jiffies, expiry)) {
@@ -663,7 +710,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		}
 
 		/* Transitioning time exceeded, set port to standby */
-		h->state = TPGS_STATE_STANDBY;
+		pg->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
 		/* Path unusable */
@@ -684,21 +731,21 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
  * response. Returns SCSI_DH_RETRY per default to trigger
  * a re-evaluation of the target group state.
  */
-static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
+static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	int retval, err = SCSI_DH_RETRY;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 
-	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
+	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
 		/* Only implicit ALUA supported, retry */
 		return SCSI_DH_RETRY;
 	}
-	switch (h->state) {
+	switch (pg->state) {
 	case TPGS_STATE_NONOPTIMIZED:
-		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
-		    (!h->pref) &&
-		    (h->tpgs & TPGS_MODE_IMPLICIT))
+		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
+		    (!pg->pref) &&
+		    (pg->tpgs & TPGS_MODE_IMPLICIT))
 			return SCSI_DH_OK;
 		break;
 	case TPGS_STATE_STANDBY:
@@ -715,8 +762,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		break;
 	}
 	/* Set state to transitioning */
-	h->state = TPGS_STATE_TRANSITIONING;
-	retval = submit_stpg(sdev, h->group_id, sense);
+	pg->state = TPGS_STATE_TRANSITIONING;
+	retval = submit_stpg(sdev, pg->group_id, sense);
 
 	if (retval) {
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
@@ -728,11 +775,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			/* Retry RTPG */
 			return err;
 		}
-		err = alua_check_sense(h->sdev, &sense_hdr);
-		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
+		err = alua_check_sense(sdev, &sense_hdr);
+		sdev_printk(KERN_INFO, sdev, "%s: stpg failed, ",
 			    ALUA_DH_NAME);
 		scsi_show_sense_hdr(&sense_hdr);
-		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
+		sdev_printk(KERN_INFO, sdev, "%s: stpg failed, ",
 			    ALUA_DH_NAME);
 		scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
 		err = SCSI_DH_RETRY;
@@ -756,16 +803,16 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 		goto out;
 
 	err = alua_vpd_inquiry(sdev, h);
-	if (err != SCSI_DH_OK)
-		goto out;
-
-	err = alua_rtpg(sdev, h, 0);
-	if (err != SCSI_DH_OK)
+	if (err != SCSI_DH_OK || !h->pg)
 		goto out;
 
+	kref_get(&h->pg->kref);
+	err = alua_rtpg(sdev, h->pg);
+	kref_put(&h->pg->kref, release_port_group);
 out:
 	return err;
 }
+
 /*
  * alua_set_params - set/unset the optimize flag
  * @sdev: device on the path to be activated
@@ -818,16 +865,22 @@ static int alua_activate(struct scsi_device *sdev,
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int err = SCSI_DH_OK;
 
-	err = alua_rtpg(sdev, h, 1);
-	if (err != SCSI_DH_OK)
+	if (!h->pg)
 		goto out;
 
 	if (optimize_stpg)
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
-	err = alua_stpg(sdev, h);
+	kref_get(&h->pg->kref);
+	err = alua_rtpg(sdev, h->pg);
+	if (err != SCSI_DH_OK) {
+		kref_put(&h->pg->kref, release_port_group);
+		goto out;
+	}
+	err = alua_stpg(sdev, h->pg);
 	if (err == SCSI_DH_RETRY)
-		err = alua_rtpg(sdev, h);
+		err = alua_rtpg(sdev, h->pg);
+	kref_put(&h->pg->kref, release_port_group);
 out:
 	if (fn)
 		fn(data, err);
@@ -843,13 +896,19 @@ out:
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
+	int state;
 	int ret = BLKPREP_OK;
 
-	if (h->state == TPGS_STATE_TRANSITIONING)
+	if (!h->pg)
+		return ret;
+	kref_get(&h->pg->kref);
+	state = h->pg->state;
+	kref_put(&h->pg->kref, release_port_group);
+	if (state == TPGS_STATE_TRANSITIONING)
 		ret = BLKPREP_DEFER;
-	else if (h->state != TPGS_STATE_OPTIMIZED &&
-		 h->state != TPGS_STATE_NONOPTIMIZED &&
-		 h->state != TPGS_STATE_LBA_DEPENDENT) {
+	else if (state != TPGS_STATE_OPTIMIZED &&
+		 state != TPGS_STATE_NONOPTIMIZED &&
+		 state != TPGS_STATE_LBA_DEPENDENT) {
 		ret = BLKPREP_KILL;
 		req->cmd_flags |= REQ_QUIET;
 	}
@@ -899,11 +958,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	scsi_dh_data->scsi_dh = &alua_dh;
 	h = (struct alua_dh_data *) scsi_dh_data->buf;
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
-	h->state = TPGS_STATE_OPTIMIZED;
-	h->group_id = -1;
+	h->pg = NULL;
 	h->rel_port = -1;
-	h->buff = h->inq;
-	h->bufflen = ALUA_INQUIRY_SIZE;
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
@@ -942,8 +998,10 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	h = (struct alua_dh_data *) scsi_dh_data->buf;
-	if (h->buff && h->inq != h->buff)
-		kfree(h->buff);
+	if (h->pg) {
+		kref_put(&h->pg->kref, release_port_group);
+		h->pg = NULL;
+	}
 	kfree(scsi_dh_data);
 	module_put(THIS_MODULE);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", ALUA_DH_NAME);
-- 
1.7.12.4

