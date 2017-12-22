From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] scsi_dh_alua: skip RTPG for devices only supporting active/optimized
Date: Fri, 22 Dec 2017 12:52:53 +0100
Message-ID: <1513943573-35956-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45483 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLVLw5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Dec 2017 06:52:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

For hardware only supporting active/optimized there's no point in
ever re-issuing RTPG as the only new state we can possibly read is
active/optimized.
This avoid spurious errors during path failover on such arrays.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 37 ++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fd22dc6..022e421 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -40,6 +40,7 @@
 #define TPGS_SUPPORT_LBA_DEPENDENT	0x10
 #define TPGS_SUPPORT_OFFLINE		0x40
 #define TPGS_SUPPORT_TRANSITION		0x80
+#define TPGS_SUPPORT_ALL		0xdf
 
 #define RTPG_FMT_MASK			0x70
 #define RTPG_FMT_EXT_HDR		0x10
@@ -81,6 +82,7 @@ struct alua_port_group {
 	int			tpgs;
 	int			state;
 	int			pref;
+	int			valid_states;
 	unsigned		flags; /* used for optimizing STPG */
 	unsigned char		transition_tmo;
 	unsigned long		expiry;
@@ -243,6 +245,7 @@ static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
 	pg->state = SCSI_ACCESS_STATE_OPTIMAL;
+	pg->valid_states = TPGS_SUPPORT_ALL;
 	if (optimize_stpg)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 	kref_init(&pg->kref);
@@ -516,7 +519,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	struct scsi_sense_hdr sense_hdr;
 	struct alua_port_group *tmp_pg;
-	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
+	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *desc, *buff;
 	unsigned err, retval;
 	unsigned int tpg_desc_tbl_off;
@@ -541,6 +544,22 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
 
 	if (retval) {
+		/*
+		 * Some (broken) implementations have a habit of returning
+		 * an error during things like firmware update etc.
+		 * But if the target only supports active/optimized there's
+		 * not much we can do; it's not that we can switch paths
+		 * or anything.
+		 * So ignore any errors to avoid spurious failures during
+		 * path failover.
+		 */
+		if ((pg->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: ignoring rtpg result %d\n",
+				    ALUA_DH_NAME, retval);
+			kfree(buff);
+			return SCSI_DH_OK;
+		}
 		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
@@ -652,7 +671,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 					rcu_read_unlock();
 				}
 				if (tmp_pg == pg)
-					valid_states = desc[1];
+					tmp_pg->valid_states = desc[1];
 				spin_unlock_irqrestore(&tmp_pg->lock, flags);
 			}
 			kref_put(&tmp_pg->kref, release_port_group);
@@ -665,13 +684,13 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
 		    pg->pref ? "preferred" : "non-preferred",
-		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+		    pg->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
+		    pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+		    pg->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
+		    pg->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
+		    pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
+		    pg->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
+		    pg->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
 	switch (pg->state) {
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-- 
1.8.5.6
