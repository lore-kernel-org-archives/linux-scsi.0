From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 17/23] scsi_dh_alua: update all port states
Date: Tue, 19 Jan 2016 09:22:01 +0100
Message-ID: <1453191727-3626-18-git-send-email-hare@suse.de>
References: <1453191727-3626-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbcASIWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 03:22:36 -0500
In-Reply-To: <1453191727-3626-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we read in the target port group state we should be
updating all affected port groups, otherwise we risk
running out of sync.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 +++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0464be9..a8273cc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -481,11 +481,13 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -587,16 +589,27 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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

