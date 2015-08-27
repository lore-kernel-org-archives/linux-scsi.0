From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/23] scsi_dh_alua: use unique device id
Date: Thu, 27 Aug 2015 14:41:15 +0200
Message-ID: <1440679281-13234-18-git-send-email-hare@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbbH0Ml3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:29 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use scsi_vpd_lun_id() to assign a unique device identification
to the alua port group structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 70 +++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index dbe9ff2..c2b2100b 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -70,6 +70,8 @@ static DEFINE_SPINLOCK(port_group_lock);
 struct alua_port_group {
 	struct kref		kref;
 	struct list_head	node;
+	unsigned char		device_id_str[256];
+	int			device_id_size;
 	int			group_id;
 	int			tpgs;
 	int			state;
@@ -229,7 +231,9 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	unsigned char *d;
 	int group_id = -1;
-	struct alua_port_group *pg = NULL;
+	char device_id_str[256];
+	int device_id_size;
+	struct alua_port_group *tmp_pg, *pg = NULL;
 
 	if (!sdev->vpd_pg83)
 		return SCSI_DH_DEV_UNSUPP;
@@ -266,9 +270,39 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		h->tpgs = TPGS_MODE_NONE;
 		return SCSI_DH_DEV_UNSUPP;
 	}
+	device_id_size = scsi_vpd_lun_id(sdev, device_id_str, 256);
+	if (device_id_size <= 0) {
+		/*
+		 * Internal error: TPGS supported by no
+		 * device identifcation found.
+		 * Disable ALUA support.
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No device descriptors found\n",
+			    ALUA_DH_NAME);
+		h->tpgs = TPGS_MODE_NONE;
+		return SCSI_DH_DEV_UNSUPP;
+	}
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, group_id, h->rel_port);
+		    "%s: device %s port group %02x "
+		    "rel port %02x\n", ALUA_DH_NAME,
+		    device_id_str, group_id, h->rel_port);
+	spin_lock(&port_group_lock);
+	list_for_each_entry(tmp_pg, &port_group_list, node) {
+		if (tmp_pg->group_id != group_id)
+			continue;
+		if (tmp_pg->device_id_size != device_id_size)
+			continue;
+		if (strncmp(tmp_pg->device_id_str, device_id_str,
+			    device_id_size))
+			continue;
+		h->pg = tmp_pg;
+		kref_get(&tmp_pg->kref);
+		break;
+	}
+	spin_unlock(&port_group_lock);
+	if (h->pg)
+		return SCSI_DH_OK;
 
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg) {
@@ -278,13 +312,39 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		/* Temporary failure, bypass */
 		return SCSI_DH_DEV_TEMP_BUSY;
 	}
+	if (device_id_size)
+		strncpy(pg->device_id_str, device_id_str, 256);
+	else
+		pg->device_id_str[0] = '\0';
+
+	pg->device_id_size = device_id_size;
 	pg->group_id = group_id;
 	pg->tpgs = h->tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
 	spin_lock(&port_group_lock);
-	list_add(&pg->node, &port_group_list);
-	h->pg = pg;
+	/*
+	 * Re-check list again to catch
+	 * concurrent updates
+	 */
+	list_for_each_entry(tmp_pg, &port_group_list, node) {
+		if (tmp_pg->group_id != pg->group_id)
+			continue;
+		if (tmp_pg->device_id_size != pg->device_id_size)
+			continue;
+		if (strncmp(tmp_pg->device_id_str, pg->device_id_str,
+			    device_id_size))
+			continue;
+		h->pg = tmp_pg;
+		kref_get(&tmp_pg->kref);
+		kfree(pg);
+		pg = NULL;
+		break;
+	}
+	if (pg) {
+		list_add(&pg->node, &port_group_list);
+		h->pg = pg;
+	}
 	spin_unlock(&port_group_lock);
 
 	return SCSI_DH_OK;
-- 
1.8.5.6

