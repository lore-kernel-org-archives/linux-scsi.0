From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_dh_alua: do not fail for unknown VPD identification
Date: Fri,  6 May 2016 10:34:35 +0200
Message-ID: <1462523675-63172-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbcEFIf0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 04:35:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Not every device will return a useable VPD identification, but
still might support ALUA. Rather then disable ALUA support we
should be allowing the device identification to be empty and
attach individual ALUA device handler to each devices.

Reported-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ab666a1..eddc200 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -195,10 +195,13 @@ static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
 {
 	struct alua_port_group *pg;
 
+	if (!id_str || !id_size || !strlen(id_str))
+		return NULL;
+
 	list_for_each_entry(pg, &port_group_list, node) {
 		if (pg->group_id != group_id)
 			continue;
-		if (pg->device_id_len != id_size)
+		if (!pg->device_id_len || pg->device_id_len != id_size)
 			continue;
 		if (strncmp(pg->device_id_str, id_str, id_size))
 			continue;
@@ -232,14 +235,14 @@ static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 					    sizeof(pg->device_id_str));
 	if (pg->device_id_len <= 0) {
 		/*
-		 * Internal error: TPGS supported but no device
-		 * identifcation found. Disable ALUA support.
+		 * TPGS supported but no device identifcation found.
+		 * Generate private device identification.
 		 */
-		kfree(pg);
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: No device descriptors found\n",
 			    ALUA_DH_NAME);
-		return ERR_PTR(-ENXIO);
+		pg->device_id_str[0] = '\0';
+		pg->device_id_len = 0;
 	}
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
@@ -354,9 +357,15 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 			return SCSI_DH_NOMEM;
 		return SCSI_DH_DEV_UNSUPP;
 	}
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: device %s port group %x rel port %x\n",
-		    ALUA_DH_NAME, pg->device_id_str, group_id, rel_port);
+	if (pg->device_id_len)
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: device %s port group %x rel port %x\n",
+			    ALUA_DH_NAME, pg->device_id_str,
+			    group_id, rel_port);
+	else
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: port group %x rel port %x\n",
+			    ALUA_DH_NAME, group_id, rel_port);
 
 	/* Check for existing port group references */
 	spin_lock(&h->pg_lock);
-- 
1.8.5.6

