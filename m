From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 17/23] scsi_dh_alua: update all port states
Date: Fri, 19 Feb 2016 09:17:14 +0100
Message-ID: <1455869840-122786-18-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427078AbcBSIRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:53 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we read in the target port group state we should be
updating all affected port groups, otherwise we risk
running out of sync.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 35 ++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ef5d6c3..98d87d9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -476,11 +476,13 @@ static int alua_check_sense(struct scsi_device *sdev,
 static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	struct scsi_sense_hdr sense_hdr;
+	struct alua_port_group *tmp_pg;
 	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
-	unsigned char *ucp, *buff;
+	unsigned char *desc, *buff;
 	unsigned err, retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
+	unsigned long flags;
 
 	if (!pg->expiry) {
 		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
@@ -582,18 +584,32 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	else
 		tpg_desc_tbl_off = 4;
 
-	for (k = tpg_desc_tbl_off, ucp = buff + tpg_desc_tbl_off;
+	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
 	     k < len;
-	     k += off, ucp += off) {
-
-		if (pg->group_id == get_unaligned_be16(&ucp[2])) {
-			pg->state = ucp[0] & 0x0f;
-			pg->pref = ucp[0] >> 7;
-			valid_states = ucp[1];
+	     k += off, desc += off) {
+		u16 group_id = get_unaligned_be16(&desc[2]);
+
+		spin_lock_irqsave(&port_group_lock, flags);
+		tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
+					  group_id);
+		spin_unlock_irqrestore(&port_group_lock, flags);
+		if (tmp_pg) {
+			if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
+				if ((tmp_pg == pg) ||
+				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
+					tmp_pg->state = desc[0] & 0x0f;
+					tmp_pg->pref = desc[0] >> 7;
+				}
+				if (tmp_pg == pg)
+					valid_states = desc[1];
+				spin_unlock_irqrestore(&tmp_pg->lock, flags);
+			}
+			kref_put(&tmp_pg->kref, release_port_group);
 		}
-		off = 8 + (ucp[7] * 4);
+		off = 8 + (desc[7] * 4);
 	}
 
+	spin_lock_irqsave(&pg->lock, flags);
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
@@ -630,6 +646,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		pg->expiry = 0;
 		break;
 	}
+	spin_unlock_irqrestore(&pg->lock, flags);
 	kfree(buff);
 	return err;
 }
-- 
1.8.5.6

