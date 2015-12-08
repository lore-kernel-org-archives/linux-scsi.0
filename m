From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/20] scsi_dh_alua: use unique device id
Date: Tue,  8 Dec 2015 08:37:28 +0100
Message-ID: <1449560260-53407-9-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbbLHHhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:47 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use scsi_vpd_lun_id() to assign a unique device identification
to the alua port group structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 64 ++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ca6322d..688e0f7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -70,6 +70,8 @@ static DEFINE_SPINLOCK(port_group_lock);
 struct alua_port_group {
 	struct kref		kref;
 	struct list_head	node;
+	unsigned char		device_id_str[256];
+	int			device_id_len;
 	int			group_id;
 	int			tpgs;
 	int			state;
@@ -162,6 +164,25 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
 }
 
+struct alua_port_group *alua_lookup_pg(char *id_str, size_t id_size,
+				       int group_id)
+{
+	struct alua_port_group *pg = NULL;
+
+	list_for_each_entry(pg, &port_group_list, node) {
+		if (pg->group_id != group_id)
+			continue;
+		if (pg->device_id_len != id_size)
+			continue;
+		if (strncmp(pg->device_id_str, id_str, id_size))
+			continue;
+		kref_get(&pg->kref);
+		return pg;
+	}
+
+	return NULL;
+}
+
 /*
  * alua_get_pg - Allocate a new port_group structure
  * @sdev: scsi device
@@ -172,19 +193,37 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
  * device.
  */
 struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
-				    int group_id, int tpgs)
+				    int group_id, int tpgs,
+				    char *id_str, size_t id_size)
 {
-	struct alua_port_group *pg = NULL;
+	struct alua_port_group *pg = NULL, *tmp_pg;
+
+	spin_lock(&port_group_lock);
+	pg = alua_lookup_pg(id_str, id_size, group_id);
+	spin_unlock(&port_group_lock);
+	if (pg)
+		return pg;
 
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg)
 		return NULL;
 
+	strncpy(pg->device_id_str, id_str, sizeof(pg->device_id_str));
+
+	pg->device_id_len = id_size;
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
+
+	/* Re-check list again to catch concurrent updates */
 	spin_lock(&port_group_lock);
+	tmp_pg = alua_lookup_pg(id_str, id_size, group_id);
+	if (tmp_pg) {
+		spin_unlock(&port_group_lock);
+		kfree(pg);
+		return tmp_pg;
+	}
 	list_add(&pg->node, &port_group_list);
 	spin_unlock(&port_group_lock);
 
@@ -592,6 +631,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err = SCSI_DH_DEV_UNSUPP, tpgs;
+	char device_id_str[256];
+	int device_id_len;
 
 	tpgs = alua_check_tpgs(sdev);
 	if (tpgs == TPGS_MODE_NONE)
@@ -601,7 +642,24 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	if (err != SCSI_DH_OK)
 		goto out;
 
-	h->pg = alua_get_pg(sdev, h->group_id, tpgs);
+	device_id_len = scsi_vpd_lun_id(sdev, device_id_str,
+					sizeof(device_id_str));
+	if (device_id_len <= 0) {
+		/*
+		 * Internal error: TPGS supported but no device
+		 * identifcation found. Disable ALUA support.
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No device descriptors found\n",
+			    ALUA_DH_NAME);
+		goto out;
+	}
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: device %s port group %02x rel port %02x\n",
+		    ALUA_DH_NAME, device_id_str, h->group_id, h->rel_port);
+
+	h->pg = alua_get_pg(sdev, h->group_id, tpgs,
+			    device_id_str, device_id_len);
 	if (!h->pg) {
 		err = SCSI_DH_NOMEM;
 		goto out;
-- 
1.8.5.6

