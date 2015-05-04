From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/17] scsi_dh_alua: Use separate alua_port_group structure
Date: Mon,  4 May 2015 14:42:16 +0200
Message-ID: <1430743343-47174-11-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbbEDMmk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:40 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The port group needs to be a separate structure as several
LUNs might belong to the same group.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 217 +++++++++++++++++++----------
 1 file changed, 141 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0cc18e3..492b721 100644
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
@@ -75,8 +79,12 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
-	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
-	int			senselen;
+};
+
+struct alua_dh_data {
+	struct alua_port_group	*pg;
+	int			rel_port;
+	int			tpgs;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -88,21 +96,35 @@ struct alua_dh_data {
 static char print_alua_state(int);
 static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 
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
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
@@ -230,6 +252,8 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	unsigned char *d;
+	int group_id = -1;
+	struct alua_port_group *pg = NULL;
 
 	if (!sdev->vpd_pg83)
 		return SCSI_DH_DEV_UNSUPP;
@@ -246,7 +270,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 			break;
 		case 0x5:
 			/* Target port group */
-			h->group_id = (d[6] << 8) + d[7];
+			group_id = (d[6] << 8) + d[7];
 			break;
 		default:
 			break;
@@ -254,7 +278,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		d += d[3] + 4;
 	}
 
-	if (h->group_id == -1) {
+	if (group_id == -1) {
 		/*
 		 * Internal error; TPGS supported but required
 		 * VPD identification descriptors not present.
@@ -263,15 +287,34 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: No target port descriptors found\n",
 			    ALUA_DH_NAME);
-		h->state = TPGS_STATE_OPTIMIZED;
 		h->tpgs = TPGS_MODE_NONE;
 		return SCSI_DH_DEV_UNSUPP;
 	}
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, h->group_id, h->rel_port);
+		    ALUA_DH_NAME, group_id, h->rel_port);
 
-	return 0;
+	spin_lock(&port_group_lock);
+	pg = kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
+	if (!pg) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: kzalloc port group failed\n",
+			    ALUA_DH_NAME);
+		/* Temporary failure, bypass */
+		spin_unlock(&port_group_lock);
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
+	pg->group_id = group_id;
+	pg->buff = pg->inq;
+	pg->bufflen = ALUA_INQUIRY_SIZE;
+	pg->tpgs = h->tpgs;
+	pg->state = TPGS_STATE_OPTIMIZED;
+	kref_init(&pg->kref);
+	list_add(&pg->node, &port_group_list);
+	h->pg = pg;
+	spin_unlock(&port_group_lock);
+
+	return SCSI_DH_OK;
 }
 
 static char print_alua_state(int state)
@@ -382,8 +425,9 @@ static int alua_check_sense(struct scsi_device *sdev,
  * Returns SCSI_DH_DEV_OFFLINED if the path is
  * found to be unusable.
  */
-static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
+static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
 {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
@@ -392,17 +436,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 
-	if (!h->transition_tmo)
+	if (!pg->transition_tmo)
 		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
 	else
-		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
+		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
+	retval = submit_rtpg(sdev, pg->buff, pg->bufflen, sense, pg->flags);
 
 	if (retval) {
 	    if (!(driver_byte(retval) & DRIVER_SENSE) ||
-		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
@@ -422,10 +466,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
 
@@ -442,12 +486,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
@@ -456,31 +500,32 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
@@ -488,8 +533,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
-		    h->pref ? "preferred" : "non-preferred",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred",
 		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
 		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
 		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
@@ -498,7 +543,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
 		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
-	switch (h->state) {
+	switch (pg->state) {
 	case TPGS_STATE_TRANSITIONING:
 		if (wait_for_transition) {
 			if (time_before(jiffies, expiry)) {
@@ -513,7 +558,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		}
 
 		/* Transitioning time exceeded, set port to standby */
-		h->state = TPGS_STATE_STANDBY;
+		pg->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
 		/* Path unusable */
@@ -534,23 +579,23 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
 	case TPGS_STATE_OPTIMIZED:
 		return SCSI_DH_OK;
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
@@ -569,8 +614,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		break;
 	}
 	/* Set state to transitioning */
-	h->state = TPGS_STATE_TRANSITIONING;
-	retval = submit_stpg(sdev, h->group_id, sense);
+	pg->state = TPGS_STATE_TRANSITIONING;
+	retval = submit_stpg(sdev, pg->group_id, sense);
 
 	if (retval) {
 		if (!(driver_byte(retval) & DRIVER_SENSE) ||
@@ -582,8 +627,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			/* Retry RTPG */
 			return err;
 		}
-		err = alua_check_sense(h->sdev, &sense_hdr);
-		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
+		err = alua_check_sense(sdev, &sense_hdr);
+		sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 		err = SCSI_DH_RETRY;
@@ -607,13 +652,12 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 		goto out;
 
 	err = alua_check_vpd(sdev, h);
-	if (err != SCSI_DH_OK)
-		goto out;
-
-	err = alua_rtpg(sdev, h, 0);
-	if (err != SCSI_DH_OK)
+	if (err != SCSI_DH_OK || !h->pg)
 		goto out;
 
+	kref_get(&h->pg->kref);
+	err = alua_rtpg(sdev, h->pg, 0);
+	kref_put(&h->pg->kref, release_port_group);
 out:
 	return err;
 }
@@ -629,6 +673,7 @@ out:
 static int alua_set_params(struct scsi_device *sdev, const char *params)
 {
 	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg = NULL;
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
@@ -641,10 +686,18 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
 		return -EINVAL;
 
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (!pg) {
+		rcu_read_unlock();
+		return -ENXIO;
+	}
+	rcu_read_unlock();
+
 	if (optimize)
-		h->flags |= ALUA_OPTIMIZE_STPG;
+		pg->flags |= ALUA_OPTIMIZE_STPG;
 	else
-		h->flags &= ~ALUA_OPTIMIZE_STPG;
+		pg->flags |= ~ALUA_OPTIMIZE_STPG;
 
 	return result;
 }
@@ -669,16 +722,23 @@ static int alua_activate(struct scsi_device *sdev,
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
@@ -694,13 +754,19 @@ out:
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
@@ -721,11 +787,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	if (!h)
 		return -ENOMEM;
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
-	h->state = TPGS_STATE_OPTIMIZED;
-	h->group_id = -1;
+	h->pg = NULL;
 	h->rel_port = -1;
-	h->buff = h->inq;
-	h->bufflen = ALUA_INQUIRY_SIZE;
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
@@ -747,8 +810,10 @@ static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 
-	if (h->buff && h->inq != h->buff)
-		kfree(h->buff);
+	if (h->pg) {
+		kref_put(&h->pg->kref, release_port_group);
+		h->pg = NULL;
+	}
 	kfree(h);
 }
 
-- 
1.8.5.2

