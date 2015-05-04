From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/17] scsi_dh_alua: update all port states
Date: Mon,  4 May 2015 14:42:22 +0200
Message-ID: <1430743343-47174-17-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbbEDMmm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:42 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we read in the target port group state we should be
updating all affected port groups, otherwise we risk
running out of sync.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index cf83005..6c1eadf 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -548,6 +548,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	unsigned err, retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
+	struct alua_port_group *tmp_pg;
+	unsigned long flags;
 
 	if (!pg->expiry) {
 		if (!pg->transition_tmo)
@@ -638,17 +640,35 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	else
 		tpg_desc_tbl_off = 4;
 
+	spin_lock_irqsave(&port_group_lock, flags);
 	for (k = tpg_desc_tbl_off, ucp = pg->buff + tpg_desc_tbl_off;
 	     k < len;
 	     k += off, ucp += off) {
 
-		if (pg->group_id == (ucp[2] << 8) + ucp[3]) {
-			pg->state = ucp[0] & 0x0f;
-			pg->pref = ucp[0] >> 7;
-			valid_states = ucp[1];
+		list_for_each_entry(tmp_pg, &port_group_list, node) {
+			u16 group_id = get_unaligned_be16(&ucp[2]);
+			if (tmp_pg->group_id != group_id)
+				continue;
+			if (tmp_pg->device_id_size != pg->device_id_size)
+				continue;
+			if (memcmp(tmp_pg->device_id, pg->device_id,
+				   tmp_pg->device_id_size))
+				continue;
+			tmp_pg->state = ucp[0] & 0x0f;
+			tmp_pg->pref = ucp[0] >> 7;
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: device %s port group %02x "
+				    "state %c %s\n", ALUA_DH_NAME,
+				    tmp_pg->device_id_str, tmp_pg->group_id,
+				    print_alua_state(tmp_pg->state),
+				    tmp_pg->pref ?
+				    "preferred" : "non-preferred");
+			if (tmp_pg == pg)
+				valid_states = ucp[1];
 		}
 		off = 8 + (ucp[7] * 4);
 	}
+	spin_unlock_irqrestore(&port_group_lock, flags);
 
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-- 
1.8.5.2

