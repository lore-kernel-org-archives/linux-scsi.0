From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] scsi_dh_alua: Fix RCU annotations
Date: Thu, 1 Dec 2016 11:30:50 -0800
Message-ID: <75470dc5-b79a-088c-49a8-65cfe282376f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0054.outbound.protection.outlook.com ([104.47.41.54]:64672
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755340AbcLATbB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 14:31:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, tang.junhui@zte.com.cn, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch avoids that sparse complains about RCU pointer dereferences.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: tang.junhui <tang.junhui@zte.com.cn>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7bb2068..815e648 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -95,7 +95,7 @@ struct alua_port_group {
 
 struct alua_dh_data {
 	struct list_head	node;
-	struct alua_port_group	*pg;
+	struct alua_port_group __rcu *pg;
 	int			group_id;
 	spinlock_t		pg_lock;
 	struct scsi_device	*sdev;
@@ -369,7 +369,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 
 	/* Check for existing port group references */
 	spin_lock(&h->pg_lock);
-	old_pg = h->pg;
+	old_pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
 	if (old_pg != pg) {
 		/* port group has changed. Update to new port group */
 		if (h->pg) {
@@ -388,7 +388,9 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		list_add_rcu(&h->node, &pg->dh_list);
 	spin_unlock_irqrestore(&pg->lock, flags);
 
-	alua_rtpg_queue(h->pg, sdev, NULL, true);
+	alua_rtpg_queue(rcu_dereference_protected(h->pg,
+						  lockdep_is_held(&h->pg_lock)),
+			sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
 	if (old_pg)
@@ -940,7 +942,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 static int alua_set_params(struct scsi_device *sdev, const char *params)
 {
 	struct alua_dh_data *h = sdev->handler_data;
-	struct alua_port_group __rcu *pg = NULL;
+	struct alua_port_group *pg = NULL;
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
@@ -987,7 +989,7 @@ static int alua_activate(struct scsi_device *sdev,
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata;
-	struct alua_port_group __rcu *pg;
+	struct alua_port_group *pg;
 
 	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
 	if (!qdata) {
@@ -1051,7 +1053,7 @@ static void alua_check(struct scsi_device *sdev, bool force)
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = sdev->handler_data;
-	struct alua_port_group __rcu *pg;
+	struct alua_port_group *pg;
 	unsigned char state = SCSI_ACCESS_STATE_OPTIMAL;
 	int ret = BLKPREP_OK;
 
@@ -1121,7 +1123,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	struct alua_port_group *pg;
 
 	spin_lock(&h->pg_lock);
-	pg = h->pg;
+	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
 	rcu_assign_pointer(h->pg, NULL);
 	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
-- 
2.10.2

