From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 22/23] scsi_dh_alua: update 'access_state' field
Date: Fri, 12 Feb 2016 09:25:45 +0100
Message-ID: <1455265546-44470-23-git-send-email-hare@suse.de>
References: <1455265546-44470-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbcBLIZx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 03:25:53 -0500
In-Reply-To: <1455265546-44470-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

Track attached SCSI devices and update the 'access_state' field
whenever an ALUA state change has been detected.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 48 ++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index b429ba3..cbbd957 100644
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
@@ -75,6 +76,7 @@ struct alua_port_group {
 	struct kref		kref;
 	struct rcu_head		rcu;
 	struct list_head	node;
+	struct list_head	dh_list;
 	unsigned char		device_id_str[256];
 	int			device_id_len;
 	int			group_id;
@@ -92,6 +94,7 @@ struct alua_port_group {
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
@@ -357,13 +363,25 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	old_pg = h->pg;
 	if (old_pg != pg) {
 		/* port group has changed. Update to new port group */
+		if (h->pg) {
+			spin_lock_irqsave(&old_pg->lock, flags);
+			list_del_rcu(&h->node);
+			spin_unlock_irqrestore(&old_pg->lock, flags);
+		}
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
 
@@ -613,8 +631,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
 				if ((tmp_pg == pg) ||
 				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
+					struct alua_dh_data *h;
+
 					tmp_pg->state = desc[0] & 0x0f;
 					tmp_pg->pref = desc[0] >> 7;
+					rcu_read_lock();
+					list_for_each_entry_rcu(h,
+						&tmp_pg->dh_list, node) {
+						/* h->sdev should always be valid */
+						BUG_ON(!h->sdev);
+						h->sdev->access_state = desc[0];
+					}
+					rcu_read_unlock();
 				}
 				if (tmp_pg == pg)
 					valid_states = desc[1];
@@ -645,10 +673,22 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->interval = 2;
 			err = SCSI_DH_RETRY;
 		} else {
+			struct alua_dh_data *h;
+
 			/* Transitioning time exceeded, set port to standby */
 			err = SCSI_DH_IO;
 			pg->state = SCSI_ACCESS_STATE_STANDBY;
 			pg->expiry = 0;
+			rcu_read_lock();
+			list_for_each_entry_rcu(h, &pg->dh_list, node) {
+				BUG_ON(!h->sdev);
+				h->sdev->access_state =
+					(pg->state & SCSI_ACCESS_STATE_MASK);
+				if (pg->pref)
+					h->sdev->access_state |=
+						SCSI_ACCESS_STATE_PREFERRED;
+			}
+			rcu_read_unlock();
 		}
 		break;
 	case SCSI_ACCESS_STATE_OFFLINE:
@@ -1052,6 +1092,7 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	rcu_assign_pointer(h->pg, NULL);
 	h->init_error = SCSI_DH_OK;
 	h->sdev = sdev;
+	INIT_LIST_HEAD(&h->node);
 
 	mutex_init(&h->init_mutex);
 	err = alua_initialize(sdev, h);
@@ -1081,9 +1122,12 @@ static void alua_bus_detach(struct scsi_device *sdev)
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

