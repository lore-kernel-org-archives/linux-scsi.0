From: brking@us.ibm.com
Subject: [PATCH 11/15] ipr: Remove tcq_active flag from resource entry
Date: Mon, 21 Feb 2005 15:09:36 -0600
Message-ID: <200502212109.j1LL9a6l002651@d01av02.pok.ibm.com>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41662 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262129AbVBUVJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:37 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9bcC025321
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:37 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9b0H245638
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:37 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9b8C002677
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove the tcq_active flag from the ipr_resource_entry struct
since the same information is available through scsi core APIs.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   10 +++-------
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    1 -
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_remove_tcq_active_flag drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_remove_tcq_active_flag	2005-02-21 13:16:12.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:16:12.000000000 -0600
@@ -792,7 +792,6 @@ static void ipr_init_res_entry(struct ip
 	res->add_to_ml = 0;
 	res->del_from_ml = 0;
 	res->resetting_device = 0;
-	res->tcq_active = 0;
 	res->sdev = NULL;
 }
 
@@ -2696,13 +2695,10 @@ static int ipr_change_queue_type(struct 
 			 */
 			scsi_set_tag_type(sdev, tag_type);
 
-			if (tag_type) {
-				res->tcq_active = 1;
+			if (tag_type)
 				scsi_activate_tcq(sdev, sdev->queue_depth);
-			} else {
-				res->tcq_active = 0;
+			else
 				scsi_deactivate_tcq(sdev, sdev->queue_depth);
-			}
 		} else
 			tag_type = 0;
 	} else
@@ -3514,7 +3510,7 @@ static void ipr_erp_cancel_all(struct ip
 
 	ipr_reinit_ipr_cmnd_for_erp(ipr_cmd);
 
-	if (!res->tcq_active) {
+	if (!scsi_get_tag_type(scsi_cmd->device)) {
 		ipr_erp_request_sense(ipr_cmd);
 		return;
 	}
diff -puN drivers/scsi/ipr.h~ipr_remove_tcq_active_flag drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_remove_tcq_active_flag	2005-02-21 13:16:12.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:16:12.000000000 -0600
@@ -726,7 +726,6 @@ struct ipr_resource_entry {
 	u8 add_to_ml:1;
 	u8 del_from_ml:1;
 	u8 resetting_device:1;
-	u8 tcq_active:1;
 
 	struct scsi_device *sdev;
 	struct list_head queue;
_
