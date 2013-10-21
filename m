From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/19] fcoe: Reduce fcoe_sysfs_fcf_add() stack usage
Date: Mon, 21 Oct 2013 11:01:55 -0700
Message-ID: <20131021180155.31563.98565.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:22609 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3JUSB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:01:56 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

This patch fixes the following compiler warning:

drivers/scsi/fcoe/fcoe_ctlr.c: In function fcoe_sysfs_fcf_add:
drivers/scsi/fcoe/fcoe_ctlr.c:211:1: warning: the frame size of 1480 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 9e83a79..692c653 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -164,28 +164,30 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 {
 	struct fcoe_ctlr *fip = new->fip;
 	struct fcoe_ctlr_device *ctlr_dev = fcoe_ctlr_to_ctlr_dev(fip);
-	struct fcoe_fcf_device temp, *fcf_dev;
-	int rc = 0;
+	struct fcoe_fcf_device *temp, *fcf_dev;
+	int rc = -ENOMEM;
 
 	LIBFCOE_FIP_DBG(fip, "New FCF fab %16.16llx mac %pM\n",
 			new->fabric_name, new->fcf_mac);
 
+	temp = kzalloc(sizeof(*temp), GFP_KERNEL);
+	if (!temp)
+		goto out;
+
 	mutex_lock(&ctlr_dev->lock);
 
-	temp.fabric_name = new->fabric_name;
-	temp.switch_name = new->switch_name;
-	temp.fc_map = new->fc_map;
-	temp.vfid = new->vfid;
-	memcpy(temp.mac, new->fcf_mac, ETH_ALEN);
-	temp.priority = new->pri;
-	temp.fka_period = new->fka_period;
-	temp.selected = 0; /* default to unselected */
-
-	fcf_dev = fcoe_fcf_device_add(ctlr_dev, &temp);
-	if (unlikely(!fcf_dev)) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	temp->fabric_name = new->fabric_name;
+	temp->switch_name = new->switch_name;
+	temp->fc_map = new->fc_map;
+	temp->vfid = new->vfid;
+	memcpy(temp->mac, new->fcf_mac, ETH_ALEN);
+	temp->priority = new->pri;
+	temp->fka_period = new->fka_period;
+	temp->selected = 0; /* default to unselected */
+
+	fcf_dev = fcoe_fcf_device_add(ctlr_dev, temp);
+	if (unlikely(!fcf_dev))
+		goto unlock;
 
 	/*
 	 * The fcoe_sysfs layer can return a CONNECTED fcf that
@@ -204,9 +206,13 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 
 	list_add(&new->list, &fip->fcfs);
 	fip->fcf_count++;
+	rc = 0;
 
-out:
+unlock:
 	mutex_unlock(&ctlr_dev->lock);
+
+out:
+	kfree(temp);
 	return rc;
 }
 

