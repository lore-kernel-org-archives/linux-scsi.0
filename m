From: brking@us.ibm.com
Subject: [PATCH 10/15] ipr: Remove resource qdepth field
Date: Mon, 21 Feb 2005 15:09:29 -0600
Message-ID: <200502212109.j1LL9U0U002415@d03av03.boulder.ibm.com>
Received: from e32.co.us.ibm.com ([32.97.110.130]:64396 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262127AbVBUVJc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:32 -0500
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LL9V5j203118
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:31 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9VUK114414
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:31 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9U5n002444
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove qdepth field from the ipr_resource_entry structure since
the same data is also available in the scsi_device struct.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   26 ++++--------------------
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    1 
 2 files changed, 5 insertions(+), 22 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_remove_dev_qdepth drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_remove_dev_qdepth	2005-02-21 13:15:56.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:15:56.000000000 -0600
@@ -793,7 +793,6 @@ static void ipr_init_res_entry(struct ip
 	res->del_from_ml = 0;
 	res->resetting_device = 0;
 	res->tcq_active = 0;
-	res->qdepth = IPR_MAX_CMD_PER_LUN;
 	res->sdev = NULL;
 }
 
@@ -2668,23 +2667,8 @@ static int ipr_free_dump(struct ipr_ioa_
  **/
 static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
-	struct ipr_resource_entry *res;
-	int tagged = 0;
-	unsigned long lock_flags = 0;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res) {
-		res->qdepth = qdepth;
-
-		if (ipr_is_gscsi(res) && res->tcq_active)
-			tagged = MSG_ORDERED_TAG;
-	}
-
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	scsi_adjust_queue_depth(sdev, tagged, qdepth);
-	return qdepth;
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	return sdev->queue_depth;
 }
 
 /**
@@ -2714,10 +2698,10 @@ static int ipr_change_queue_type(struct 
 
 			if (tag_type) {
 				res->tcq_active = 1;
-				scsi_activate_tcq(sdev, res->qdepth);
+				scsi_activate_tcq(sdev, sdev->queue_depth);
 			} else {
 				res->tcq_active = 0;
-				scsi_deactivate_tcq(sdev, res->qdepth);
+				scsi_deactivate_tcq(sdev, sdev->queue_depth);
 			}
 		} else
 			tag_type = 0;
@@ -2852,7 +2836,7 @@ static int ipr_slave_configure(struct sc
 		}
 		if (IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
 			sdev->allow_restart = 1;
-		scsi_adjust_queue_depth(sdev, 0, res->qdepth);
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return 0;
diff -puN drivers/scsi/ipr.h~ipr_remove_dev_qdepth drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_remove_dev_qdepth	2005-02-21 13:15:56.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:15:56.000000000 -0600
@@ -728,7 +728,6 @@ struct ipr_resource_entry {
 	u8 resetting_device:1;
 	u8 tcq_active:1;
 
-	int qdepth;
 	struct scsi_device *sdev;
 	struct list_head queue;
 };
_
