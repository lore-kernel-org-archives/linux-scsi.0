From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/20] scsi_dh_alua: update 'access_state' field
Date: Tue,  8 Dec 2015 08:37:39 +0100
Message-ID: <1449560260-53407-20-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbbLHHht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:49 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Track attached SCSI devices and update the 'access_state' field
whenever an ALUA state change has been detected.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6c6ff0b..d01c86407 100644
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
@@ -76,6 +77,7 @@ static struct workqueue_struct *kaluad_wq;
 struct alua_port_group {
 	struct kref		kref;
 	struct list_head	node;
+	struct list_head	dh_list;
 	unsigned char		device_id_str[256];
 	int			device_id_len;
 	int			group_id;
@@ -93,6 +95,7 @@ struct alua_port_group {
 };
 
 struct alua_dh_data {
+	struct list_head	node;
 	struct alua_port_group	*pg;
 	int			rel_port;
 	spinlock_t		pg_lock;
@@ -243,6 +246,7 @@ struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
 	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
 	INIT_LIST_HEAD(&pg->rtpg_list);
 	INIT_LIST_HEAD(&pg->node);
+	INIT_LIST_HEAD(&pg->dh_list);
 	spin_lock_init(&pg->lock);
 
 	/* Re-check list again to catch concurrent updates */
@@ -370,13 +374,26 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		old_pg = pg;
 		/* port_group has changed. Update to new port group */
 		if (h->pg != pg) {
+			unsigned long flags;
+
 			old_pg = h->pg;
 			rcu_assign_pointer(h->pg, pg);
+			spin_lock_irqsave(&old_pg->lock, flags);
+			list_del_rcu(&h->node);
+			spin_unlock_irqrestore(&old_pg->lock, flags);
+			spin_lock_irqsave(&pg->lock, flags);
+			list_add_rcu(&h->node, &pg->dh_list);
+			spin_unlock_irqrestore(&pg->lock, flags);
 			h->pg->expiry = 0;
 			pg_found = true;
 		}
 	} else {
+		unsigned long flags;
+
 		rcu_assign_pointer(h->pg, pg);
+		spin_lock_irqsave(&pg->lock, flags);
+		list_add_rcu(&h->node, &pg->dh_list);
+		spin_unlock_irqrestore(&pg->lock, flags);
 		pg_found = true;
 	}
 	alua_rtpg_queue(h->pg, sdev, NULL, true);
@@ -630,6 +647,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
 		spin_lock_irqsave(&port_group_lock, flags);
 		list_for_each_entry(tmp_pg, &port_group_list, node) {
+			struct alua_dh_data *h;
+
 			if (tmp_pg->group_id != group_id)
 				continue;
 			if (tmp_pg->device_id_len != pg->device_id_len)
@@ -639,6 +658,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				continue;
 			tmp_pg->state = desc[0] & 0x0f;
 			tmp_pg->pref = desc[0] >> 7;
+			rcu_read_lock();
+			list_for_each_entry_rcu(h, &tmp_pg->dh_list, node) {
+				if (h->sdev)
+					h->sdev->access_state = desc[0];
+			}
+			rcu_read_unlock();
 			if (tmp_pg == pg)
 				valid_states = desc[1];
 		}
@@ -1056,6 +1081,7 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h->rel_port = -1;
 	h->init_error = SCSI_DH_OK;
 	h->sdev = sdev;
+	INIT_LIST_HEAD(&h->node);
 
 	mutex_init(&h->init_mutex);
 	err = alua_initialize(sdev, h);
@@ -1086,6 +1112,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
 	if (pg) {
+		spin_lock(&pg->lock);
+		list_del_rcu(&h->node);
+		spin_unlock(&pg->lock);
 		synchronize_rcu();
 		if (pg->rtpg_sdev)
 			flush_delayed_work(&pg->rtpg_work);
-- 
1.8.5.6

