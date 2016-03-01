From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] scsi_dh_rdac: update 'access_state' field
Date: Tue,  1 Mar 2016 05:55:41 +0100
Message-ID: <1456808143-88932-5-git-send-email-hare@suse.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbcCAE4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 23:56:09 -0500
In-Reply-To: <1456808143-88932-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Track attached SCSI devices and update the 'access_state'
whenever the path state of the device changes.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 38 ++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 93880ed..06fbd0b 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -165,6 +165,7 @@ struct rdac_controller {
 	struct work_struct	ms_work;
 	struct scsi_device	*ms_sdev;
 	struct list_head	ms_head;
+	struct list_head	dh_list;
 };
 
 struct c2_inquiry {
@@ -181,7 +182,9 @@ struct c2_inquiry {
 };
 
 struct rdac_dh_data {
+	struct list_head	node;
 	struct rdac_controller	*ctlr;
+	struct scsi_device	*sdev;
 #define UNINITIALIZED_LUN	(1 << 8)
 	unsigned		lun;
 
@@ -392,6 +395,7 @@ static struct rdac_controller *get_controller(int index, char *array_name,
 	INIT_WORK(&ctlr->ms_work, send_mode_select);
 	INIT_LIST_HEAD(&ctlr->ms_head);
 	list_add(&ctlr->node, &ctlr_list);
+	INIT_LIST_HEAD(&ctlr->dh_list);
 
 	return ctlr;
 }
@@ -455,7 +459,8 @@ static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
 
 static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
-	int err;
+	int err, access_state;
+	struct rdac_dh_data *tmp;
 	struct c9_inquiry *inqp;
 
 	h->state = RDAC_STATE_ACTIVE;
@@ -471,19 +476,31 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 			h->mode = RDAC_MODE; /* LUN in RDAC mode */
 
 		/* Update ownership */
-		if (inqp->avte_cvp & 0x1)
+		if (inqp->avte_cvp & 0x1) {
 			h->lun_state = RDAC_LUN_OWNED;
-		else {
+			access_state = SCSI_ACCESS_STATE_OPTIMAL;
+		} else {
 			h->lun_state = RDAC_LUN_UNOWNED;
-			if (h->mode == RDAC_MODE)
+			if (h->mode == RDAC_MODE) {
 				h->state = RDAC_STATE_PASSIVE;
+				access_state = SCSI_ACCESS_STATE_STANDBY;
+			} else
+				access_state = SCSI_ACCESS_STATE_ACTIVE;
 		}
 
 		/* Update path prio*/
-		if (inqp->path_prio & 0x1)
+		if (inqp->path_prio & 0x1) {
 			h->preferred = RDAC_PREFERRED;
-		else
+			access_state |= SCSI_ACCESS_STATE_PREFERRED;
+		} else
 			h->preferred = RDAC_NON_PREFERRED;
+		rcu_read_lock();
+		list_for_each_entry_rcu(tmp, &h->ctlr->dh_list, node) {
+			/* h->sdev should always be valid */
+			BUG_ON(!tmp->sdev);
+			tmp->sdev->access_state = access_state;
+		}
+		rcu_read_unlock();
 	}
 
 	return err;
@@ -508,6 +525,10 @@ static int initialize_controller(struct scsi_device *sdev,
 		h->ctlr = get_controller(index, array_name, array_id, sdev);
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
+		else {
+			list_add_rcu(&h->node, &h->ctlr->dh_list);
+			h->sdev = sdev;
+		}
 		spin_unlock(&list_lock);
 	}
 	return err;
@@ -829,8 +850,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 		flush_workqueue(kmpath_rdacd);
 
 	spin_lock(&list_lock);
-	if (h->ctlr)
+	if (h->ctlr) {
+		list_del_rcu(&h->node);
+		h->sdev = NULL;
 		kref_put(&h->ctlr->kref, release_controller);
+	}
 	spin_unlock(&list_lock);
 	sdev->handler_data = NULL;
 	kfree(h);
-- 
2.6.2

