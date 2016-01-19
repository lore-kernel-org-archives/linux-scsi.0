From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 22/23] scsi_dh_alua: update 'access_state' field
Date: Tue, 19 Jan 2016 09:22:06 +0100
Message-ID: <1453191727-3626-23-git-send-email-hare@suse.de>
References: <1453191727-3626-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454AbcASIWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 03:22:39 -0500
In-Reply-To: <1453191727-3626-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Track attached SCSI devices and update the 'access_state' field
whenever an ALUA state change has been detected.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 34 ++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index df8e06f..5352139 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
@@ -74,6 +75,7 @@ static struct workqueue_struct *kaluad_sync_wq;
 struct alua_port_group {
 	struct kref		kref;
 	struct list_head	node;
+	struct list_head	dh_list;
 	unsigned char		device_id_str[256];
 	int			device_id_len;
 	int			group_id;
@@ -91,6 +93,7 @@ struct alua_port_group {
 };
 
 struct alua_dh_data {
+	struct list_head	node;
 	struct alua_port_group	*pg;
 	int			group_id;
 	spinlock_t		pg_lock;
@@ -247,6 +250,7 @@ struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
 	INIT_LIST_HEAD(&pg->rtpg_list);
 	INIT_LIST_HEAD(&pg->node);
+	INIT_LIST_HEAD(&pg->dh_list);
 	spin_lock_init(&pg->lock);
 
 	spin_lock(&port_group_lock);
@@ -328,6 +332,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 {
 	int rel_port = -1, group_id;
 	struct alua_port_group *pg, *old_pg = NULL;
+	bool pg_updated;
+	unsigned long flags;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
 	if (group_id < 0) {
@@ -359,16 +365,27 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		if (h->pg != pg) {
 			/* port group has changed. Update to new port group */
 			old_pg = h->pg;
+			spin_lock_irqsave(&old_pg->lock, flags);
+			list_del_rcu(&h->node);
+			spin_unlock_irqrestore(&old_pg->lock, flags);
 			rcu_assign_pointer(h->pg, pg);
+			pg_updated = true;
 		}
 	} else {
 		rcu_assign_pointer(h->pg, pg);
+		pg_updated = true;
 	}
 	if (sdev->synchronous_alua)
 		pg->flags |= ALUA_SYNC_STPG;
 	alua_rtpg_queue(h->pg, sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
+	if (pg_updated) {
+		spin_lock_irqsave(&pg->lock, flags);
+		list_add_rcu(&h->node, &pg->dh_list);
+		spin_unlock_irqrestore(&pg->lock, flags);
+	}
+
 	if (old_pg)
 		kref_put(&old_pg->kref, release_port_group);
 
@@ -612,6 +629,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
 		spin_lock_irqsave(&port_group_lock, flags);
 		list_for_each_entry(tmp_pg, &port_group_list, node) {
+			struct alua_dh_data *h;
+
 			if (tmp_pg->group_id != group_id)
 				continue;
 			if (tmp_pg->device_id_len != pg->device_id_len)
@@ -621,6 +640,13 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				continue;
 			tmp_pg->state = desc[0] & 0x0f;
 			tmp_pg->pref = desc[0] >> 7;
+			rcu_read_lock();
+			list_for_each_entry_rcu(h, &tmp_pg->dh_list, node) {
+				/* h->sdev should always be valid */
+				BUG_ON(!h->sdev);
+				h->sdev->access_state = desc[0];
+			}
+			rcu_read_unlock();
 			if (tmp_pg == pg)
 				valid_states = desc[1];
 		}
@@ -1040,6 +1066,7 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	rcu_assign_pointer(h->pg, NULL);
 	h->init_error = SCSI_DH_OK;
 	h->sdev = sdev;
+	INIT_LIST_HEAD(&h->node);
 
 	mutex_init(&h->init_mutex);
 	err = alua_initialize(sdev, h);
@@ -1069,9 +1096,12 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	rcu_assign_pointer(h->pg, NULL);
 	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
-	if (pg)
+	if (pg) {
+		spin_lock(&pg->lock);
+		list_del_rcu(&h->node);
+		spin_unlock(&pg->lock);
 		kref_put(&pg->kref, release_port_group);
-
+	}
 	sdev->handler_data = NULL;
 	kfree(h);
 }
-- 
1.8.5.6

