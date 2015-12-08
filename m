From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/20] scsi_dh_alua: Use separate alua_port_group structure
Date: Tue,  8 Dec 2015 08:37:26 +0100
Message-ID: <1449560260-53407-7-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbbLHHho (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:44 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The port group needs to be a separate structure as several
LUNs might belong to the same group.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 221 ++++++++++++++++++++---------
 include/scsi/scsi_dh.h                     |   1 +
 2 files changed, 151 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 063c03a..f3191f7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -64,9 +64,13 @@
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
@@ -75,6 +79,12 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
+};
+
+struct alua_dh_data {
+	struct alua_port_group	*pg;
+	int			group_id;
+	int			rel_port;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -85,21 +95,34 @@ struct alua_dh_data {
 
 static char print_alua_state(int);
 
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
 
+static void release_port_group(struct kref *kref)
+{
+	struct alua_port_group *pg;
+
+	pg = container_of(kref, struct alua_port_group, kref);
+	spin_lock(&port_group_lock);
+	list_del(&pg->node);
+	spin_unlock(&port_group_lock);
+	if (pg->buff && pg->inq != pg->buff)
+		kfree(pg->buff);
+	kfree(pg);
+}
+
 /*
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
@@ -160,6 +183,37 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 }
 
 /*
+ * alua_get_pg - Allocate a new port_group structure
+ * @sdev: scsi device
+ * @h: alua device_handler data
+ * @group_id: port group id
+ *
+ * Allocate a new port_group structure for a given
+ * device.
+ */
+struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
+				    int group_id, int tpgs)
+{
+	struct alua_port_group *pg = NULL;
+
+	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
+	if (!pg)
+		return NULL;
+
+	pg->group_id = group_id;
+	pg->buff = pg->inq;
+	pg->bufflen = ALUA_INQUIRY_SIZE;
+	pg->tpgs = tpgs;
+	pg->state = TPGS_STATE_OPTIMIZED;
+	kref_init(&pg->kref);
+	spin_lock(&port_group_lock);
+	list_add(&pg->node, &port_group_list);
+	spin_unlock(&port_group_lock);
+
+	return pg;
+}
+
+/*
  * alua_check_tpgs - Evaluate TPGS setting
  * @sdev: device to be checked
  *
@@ -330,7 +384,7 @@ static int alua_check_sense(struct scsi_device *sdev,
  * Returns SCSI_DH_DEV_OFFLINED if the path is
  * found to be unusable.
  */
-static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
+static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
 {
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
@@ -340,13 +394,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 
-	if (!h->transition_tmo)
+	if (!pg->transition_tmo)
 		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
 	else
-		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
+		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, &sense_hdr, h->flags);
+	retval = submit_rtpg(sdev, pg->buff, pg->bufflen,
+			     &sense_hdr, pg->flags);
 
 	if (retval) {
 		if (!scsi_sense_valid(&sense_hdr)) {
@@ -366,10 +421,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
 		/*
@@ -393,11 +448,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		return SCSI_DH_IO;
 	}
 
-	len = get_unaligned_be32(&h->buff[0]) + 4;
+	len = get_unaligned_be32(&pg->buff[0]) + 4;
 
-	if (len > h->bufflen) {
+	if (len > pg->bufflen) {
 		/* Resubmit with the correct length */
-		if (realloc_buffer(h, len)) {
+		if (realloc_buffer(pg, len)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
@@ -406,31 +461,33 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
+	if (wait_for_transition &&
+	    (orig_transition_tmo != pg->transition_tmo)) {
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
 
-		if (h->group_id == get_unaligned_be16(&ucp[2])) {
-			h->state = ucp[0] & 0x0f;
-			h->pref = ucp[0] >> 7;
+		if (pg->group_id == get_unaligned_be16(&ucp[2])) {
+			pg->state = ucp[0] & 0x0f;
+			pg->pref = ucp[0] >> 7;
 			valid_states = ucp[1];
 		}
 		off = 8 + (ucp[7] * 4);
@@ -438,8 +495,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
-		    h->pref ? "preferred" : "non-preferred",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred",
 		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
 		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
 		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
@@ -448,7 +505,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
 		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
-	switch (h->state) {
+	switch (pg->state) {
 	case TPGS_STATE_TRANSITIONING:
 		if (wait_for_transition) {
 			if (time_before(jiffies, expiry)) {
@@ -463,7 +520,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		}
 
 		/* Transitioning time exceeded, set port to standby */
-		h->state = TPGS_STATE_STANDBY;
+		pg->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
 		/* Path unusable */
@@ -485,22 +542,22 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
  * a re-evaluation of the target group state or SCSI_DH_OK
  * if no further action needs to be taken.
  */
-static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
+static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	int retval;
 	struct scsi_sense_hdr sense_hdr;
 
-	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
+	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
 		/* Only implicit ALUA supported, retry */
 		return SCSI_DH_RETRY;
 	}
-	switch (h->state) {
+	switch (pg->state) {
 	case TPGS_STATE_OPTIMIZED:
 		return SCSI_DH_OK;
 	case TPGS_STATE_NONOPTIMIZED:
-		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
-		    !h->pref &&
-		    (h->tpgs & TPGS_MODE_IMPLICIT))
+		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
+		    !pg->pref &&
+		    (pg->tpgs & TPGS_MODE_IMPLICIT))
 			return SCSI_DH_OK;
 		break;
 	case TPGS_STATE_STANDBY:
@@ -514,13 +571,13 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	default:
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: stpg failed, unhandled TPGS state %d",
-			    ALUA_DH_NAME, h->state);
+			    ALUA_DH_NAME, pg->state);
 		return SCSI_DH_NOSYS;
 		break;
 	}
 	/* Set state to transitioning */
-	h->state = TPGS_STATE_TRANSITIONING;
-	retval = submit_stpg(sdev, h->group_id, &sense_hdr);
+	pg->state = TPGS_STATE_TRANSITIONING;
+	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
 	if (retval) {
 		if (!scsi_sense_valid(&sense_hdr)) {
@@ -530,7 +587,7 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
 		} else {
-			sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
+			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 		}
@@ -548,20 +605,24 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
  */
 static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err = SCSI_DH_DEV_UNSUPP;
+	int err = SCSI_DH_DEV_UNSUPP, tpgs;
 
-	h->tpgs = alua_check_tpgs(sdev);
-	if (h->tpgs == TPGS_MODE_NONE)
+	tpgs = alua_check_tpgs(sdev);
+	if (tpgs == TPGS_MODE_NONE)
 		goto out;
 
 	err = alua_check_vpd(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto out;
 
-	err = alua_rtpg(sdev, h, 0);
-	if (err != SCSI_DH_OK)
+	h->pg = alua_get_pg(sdev, h->group_id, tpgs);
+	if (!h->pg) {
+		err = SCSI_DH_NOMEM;
 		goto out;
-
+	}
+	kref_get(&h->pg->kref);
+	err = alua_rtpg(sdev, h->pg, 0);
+	kref_put(&h->pg->kref, release_port_group);
 out:
 	return err;
 }
@@ -577,6 +638,7 @@ out:
 static int alua_set_params(struct scsi_device *sdev, const char *params)
 {
 	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg = NULL;
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
@@ -589,10 +651,14 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
 		return -EINVAL;
 
+	pg = h->pg;
+	if (!pg)
+		return -ENXIO;
+
 	if (optimize)
-		h->flags |= ALUA_OPTIMIZE_STPG;
+		pg->flags |= ALUA_OPTIMIZE_STPG;
 	else
-		h->flags &= ~ALUA_OPTIMIZE_STPG;
+		pg->flags |= ~ALUA_OPTIMIZE_STPG;
 
 	return result;
 }
@@ -617,16 +683,23 @@ static int alua_activate(struct scsi_device *sdev,
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
 
-	err = alua_rtpg(sdev, h, 1);
-	if (err != SCSI_DH_OK)
+	if (!h->pg)
 		goto out;
 
+	kref_get(&h->pg->kref);
+
 	if (optimize_stpg)
-		h->flags |= ALUA_OPTIMIZE_STPG;
+		h->pg->flags |= ALUA_OPTIMIZE_STPG;
 
-	err = alua_stpg(sdev, h);
+	err = alua_rtpg(sdev, h->pg, 1);
+	if (err != SCSI_DH_OK) {
+		kref_put(&h->pg->kref, release_port_group);
+		goto out;
+	}
+	err = alua_stpg(sdev, h->pg);
 	if (err == SCSI_DH_RETRY)
-		err = alua_rtpg(sdev, h, 1);
+		err = alua_rtpg(sdev, h->pg, 1);
+	kref_put(&h->pg->kref, release_port_group);
 out:
 	if (fn)
 		fn(data, err);
@@ -642,13 +715,19 @@ out:
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = sdev->handler_data;
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
@@ -663,20 +742,18 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 static int alua_bus_attach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h;
-	int err;
+	int err, ret = -EINVAL;
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
-	h->tpgs = TPGS_MODE_UNINITIALIZED;
-	h->state = TPGS_STATE_OPTIMIZED;
-	h->group_id = -1;
+	h->pg = NULL;
 	h->rel_port = -1;
-	h->buff = h->inq;
-	h->bufflen = ALUA_INQUIRY_SIZE;
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
+	if (err == SCSI_DH_NOMEM)
+		ret = -ENOMEM;
 	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
 		goto failed;
 
@@ -684,7 +761,7 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	return 0;
 failed:
 	kfree(h);
-	return -EINVAL;
+	return ret;
 }
 
 /*
@@ -695,8 +772,10 @@ static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 
-	if (h->buff && h->inq != h->buff)
-		kfree(h->buff);
+	if (h->pg) {
+		kref_put(&h->pg->kref, release_port_group);
+		h->pg = NULL;
+	}
 	sdev->handler_data = NULL;
 	kfree(h);
 }
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 85d7317..7e184c6 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -52,6 +52,7 @@ enum {
 	SCSI_DH_TIMED_OUT,
 	SCSI_DH_RES_TEMP_UNAVAIL,
 	SCSI_DH_DEV_OFFLINED,
+	SCSI_DH_NOMEM,
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
-- 
1.8.5.6

