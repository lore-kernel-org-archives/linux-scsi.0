From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/20] scsi_dh_alua: update all port states
Date: Wed,  8 Jul 2015 11:06:16 +0200
Message-ID: <1436346378-96518-19-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934517AbbGHJGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:33 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

When we read in the target port group state we should be
updating all affected port groups, otherwise we risk
running out of sync.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index aa58659..44b57bc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -560,11 +560,13 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
+	struct alua_port_group *tmp_pg;
 	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *ucp, *buff;
 	unsigned err, retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
+	unsigned long flags;
 
 	if (!pg->expiry) {
 		if (!pg->transition_tmo)
@@ -669,17 +671,35 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	else
 		tpg_desc_tbl_off = 4;
 
+	spin_lock_irqsave(&port_group_lock, flags);
 	for (k = tpg_desc_tbl_off, ucp = buff + tpg_desc_tbl_off;
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

