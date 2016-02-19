From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 08/23] scsi_dh_alua: use unique device id
Date: Fri, 19 Feb 2016 09:17:05 +0100
Message-ID: <1455869840-122786-9-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426703AbcBSIRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:44 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use scsi_vpd_lun_id() to assign a unique device identification
to the alua port group structure.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 55 +++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e9fb760..0bcd901 100644
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
@@ -162,6 +164,26 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
 }
 
+struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
+					 int group_id)
+{
+	struct alua_port_group *pg;
+
+	list_for_each_entry(pg, &port_group_list, node) {
+		if (pg->group_id != group_id)
+			continue;
+		if (pg->device_id_len != id_size)
+			continue;
+		if (strncmp(pg->device_id_str, id_str, id_size))
+			continue;
+		if (!kref_get_unless_zero(&pg->kref))
+			continue;
+		return pg;
+	}
+
+	return NULL;
+}
+
 /*
  * alua_alloc_pg - Allocate a new port_group structure
  * @sdev: scsi device
@@ -174,17 +196,39 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 				      int group_id, int tpgs)
 {
-	struct alua_port_group *pg;
+	struct alua_port_group *pg, *tmp_pg;
 
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
+	pg->device_id_len = scsi_vpd_lun_id(sdev, pg->device_id_str,
+					    sizeof(pg->device_id_str));
+	if (pg->device_id_len <= 0) {
+		/*
+		 * Internal error: TPGS supported but no device
+		 * identifcation found. Disable ALUA support.
+		 */
+		kfree(pg);
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No device descriptors found\n",
+			    ALUA_DH_NAME);
+		return ERR_PTR(-ENXIO);
+	}
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
+
 	spin_lock(&port_group_lock);
+	tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
+				  group_id);
+	if (tmp_pg) {
+		spin_unlock(&port_group_lock);
+		kfree(pg);
+		return tmp_pg;
+	}
+
 	list_add(&pg->node, &port_group_list);
 	spin_unlock(&port_group_lock);
 
@@ -269,7 +313,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 	h->group_id = group_id;
 
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
+		    "%s: port group %x rel port %x\n",
 		    ALUA_DH_NAME, h->group_id, h->rel_port);
 
 	return 0;
@@ -597,8 +641,9 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 		goto out;
 
 	h->pg = alua_alloc_pg(sdev, h->group_id, tpgs);
-	if (!h->pg) {
-		err = SCSI_DH_NOMEM;
+	if (IS_ERR(h->pg)) {
+		if (PTR_ERR(h->pg) == -ENOMEM)
+			err = SCSI_DH_NOMEM;
 		goto out;
 	}
 	kref_get(&h->pg->kref);
-- 
1.8.5.6

