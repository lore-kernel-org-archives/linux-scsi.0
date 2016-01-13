From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 22/24] scsi_dh_alua: use common definitions for ALUA state
Date: Wed, 13 Jan 2016 09:09:57 +0100
Message-ID: <1452672599-9820-23-git-send-email-hare@suse.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbcAMIKU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 03:10:20 -0500
In-Reply-To: <1452672599-9820-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_proto.h now contains definitions for the ALUA state,
so we don't have to carry them in the device handler.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 62 +++++++++++++-----------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d602d98..50f42cb 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -32,14 +32,6 @@
 #define ALUA_DH_NAME "alua"
 #define ALUA_DH_VER "1.3"
 
-#define TPGS_STATE_OPTIMIZED		0x0
-#define TPGS_STATE_NONOPTIMIZED		0x1
-#define TPGS_STATE_STANDBY		0x2
-#define TPGS_STATE_UNAVAILABLE		0x3
-#define TPGS_STATE_LBA_DEPENDENT	0x4
-#define TPGS_STATE_OFFLINE		0xe
-#define TPGS_STATE_TRANSITIONING	0xf
-
 #define TPGS_SUPPORT_NONE		0x00
 #define TPGS_SUPPORT_OPTIMIZED		0x01
 #define TPGS_SUPPORT_NONOPTIMIZED	0x02
@@ -180,7 +172,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 
 	/* Prepare the data buffer */
 	memset(stpg_data, 0, stpg_len);
-	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
+	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL & 0x0f;
 	put_unaligned_be16(group_id, &stpg_data[6]);
 
 	/* Prepare the command. */
@@ -248,7 +240,7 @@ struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	}
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
-	pg->state = TPGS_STATE_OPTIMIZED;
+	pg->state = SCSI_ACCESS_STATE_OPTIMAL;
 	if (optimize_stpg)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 	kref_init(&pg->kref);
@@ -392,22 +384,22 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	return SCSI_DH_OK;
 }
 
-static char print_alua_state(int state)
+static char print_alua_state(enum scsi_access_state state)
 {
 	switch (state) {
-	case TPGS_STATE_OPTIMIZED:
+	case SCSI_ACCESS_STATE_OPTIMAL:
 		return 'A';
-	case TPGS_STATE_NONOPTIMIZED:
+	case SCSI_ACCESS_STATE_ACTIVE:
 		return 'N';
-	case TPGS_STATE_STANDBY:
+	case SCSI_ACCESS_STATE_STANDBY:
 		return 'S';
-	case TPGS_STATE_UNAVAILABLE:
+	case SCSI_ACCESS_STATE_UNAVAILABLE:
 		return 'U';
-	case TPGS_STATE_LBA_DEPENDENT:
+	case SCSI_ACCESS_STATE_LBA:
 		return 'L';
-	case TPGS_STATE_OFFLINE:
+	case SCSI_ACCESS_STATE_OFFLINE:
 		return 'O';
-	case TPGS_STATE_TRANSITIONING:
+	case SCSI_ACCESS_STATE_TRANSITIONING:
 		return 'T';
 	default:
 		return 'X';
@@ -658,7 +650,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
 	switch (pg->state) {
-	case TPGS_STATE_TRANSITIONING:
+	case SCSI_ACCESS_STATE_TRANSITIONING:
 		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
 			pg->interval = 2;
@@ -666,11 +658,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		} else {
 			/* Transitioning time exceeded, set port to standby */
 			err = SCSI_DH_IO;
-			pg->state = TPGS_STATE_STANDBY;
+			pg->state = SCSI_ACCESS_STATE_STANDBY;
 			pg->expiry = 0;
 		}
 		break;
-	case TPGS_STATE_OFFLINE:
+	case SCSI_ACCESS_STATE_OFFLINE:
 		/* Path unusable */
 		err = SCSI_DH_DEV_OFFLINED;
 		pg->expiry = 0;
@@ -703,21 +695,21 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_RETRY;
 	}
 	switch (pg->state) {
-	case TPGS_STATE_OPTIMIZED:
+	case SCSI_ACCESS_STATE_OPTIMAL:
 		return SCSI_DH_OK;
-	case TPGS_STATE_NONOPTIMIZED:
+	case SCSI_ACCESS_STATE_ACTIVE:
 		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
 		    !pg->pref &&
 		    (pg->tpgs & TPGS_MODE_IMPLICIT))
 			return SCSI_DH_OK;
 		break;
-	case TPGS_STATE_STANDBY:
-	case TPGS_STATE_UNAVAILABLE:
+	case SCSI_ACCESS_STATE_STANDBY:
+	case SCSI_ACCESS_STATE_UNAVAILABLE:
 		break;
-	case TPGS_STATE_OFFLINE:
+	case SCSI_ACCESS_STATE_OFFLINE:
 		return SCSI_DH_IO;
 		break;
-	case TPGS_STATE_TRANSITIONING:
+	case SCSI_ACCESS_STATE_TRANSITIONING:
 		break;
 	default:
 		sdev_printk(KERN_INFO, sdev,
@@ -727,7 +719,7 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		break;
 	}
 	/* Set state to transitioning */
-	pg->state = TPGS_STATE_TRANSITIONING;
+	pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
 	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
 	if (retval) {
@@ -773,7 +765,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		int state = pg->state;
 
 		spin_unlock_irqrestore(&pg->lock, flags);
-		if (state == TPGS_STATE_TRANSITIONING) {
+		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
 			if (alua_tur(sdev) == SCSI_DH_RETRY) {
 				spin_lock_irqsave(&pg->lock, flags);
 				pg->flags &= ~ALUA_PG_RUNNING;
@@ -1010,7 +1002,7 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group __rcu *pg;
-	int state = TPGS_STATE_OPTIMIZED;
+	enum scsi_access_state state = SCSI_ACCESS_STATE_OPTIMAL;
 	int ret = BLKPREP_OK;
 
 	rcu_read_lock();
@@ -1019,14 +1011,14 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 		state = pg->state;
 		/* Defer I/O while rtpg_work is active */
 		if (pg->rtpg_sdev)
-			state = TPGS_STATE_TRANSITIONING;
+			state = SCSI_ACCESS_STATE_TRANSITIONING;
 	}
 	rcu_read_unlock();
-	if (state == TPGS_STATE_TRANSITIONING)
+	if (state == SCSI_ACCESS_STATE_TRANSITIONING)
 		ret = BLKPREP_DEFER;
-	else if (state != TPGS_STATE_OPTIMIZED &&
-		 state != TPGS_STATE_NONOPTIMIZED &&
-		 state != TPGS_STATE_LBA_DEPENDENT) {
+	else if (state != SCSI_ACCESS_STATE_OPTIMAL &&
+		 state != SCSI_ACCESS_STATE_ACTIVE &&
+		 state != SCSI_ACCESS_STATE_LBA) {
 		ret = BLKPREP_KILL;
 		req->cmd_flags |= REQ_QUIET;
 	}
-- 
1.8.5.6

