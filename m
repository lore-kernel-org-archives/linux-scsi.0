From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/36] scsi_dh_alua: update all port states
Date: Tue, 29 Sep 2015 12:47:31 +0200
Message-ID: <1443523658-87622-30-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934662AbbI2KsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:48:05 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

When we read in the target port group state we should be
updating all affected port groups, otherwise we risk
running out of sync.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 +++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 21f0d20..dd8682e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -500,11 +500,13 @@ static int alua_check_sense(struct scsi_device *sdev,
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
 		if (!pg->transition_tmo)
@@ -604,16 +606,27 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
+		list_for_each_entry(tmp_pg, &port_group_list, node) {
+			if (tmp_pg->group_id != group_id)
+				continue;
+			if (tmp_pg->device_id_len != pg->device_id_len)
+				continue;
+			if (strncmp(tmp_pg->device_id_str, pg->device_id_str,
+				    tmp_pg->device_id_len))
+				continue;
+			tmp_pg->state = desc[0] & 0x0f;
+			tmp_pg->pref = desc[0] >> 7;
+			if (tmp_pg == pg)
+				valid_states = desc[1];
 		}
-		off = 8 + (ucp[7] * 4);
+		spin_unlock_irqrestore(&port_group_lock, flags);
+		off = 8 + (desc[7] * 4);
 	}
 
 	sdev_printk(KERN_INFO, sdev,
-- 
1.8.5.6

