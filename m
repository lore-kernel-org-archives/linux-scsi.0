From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] target: NULL dereference on error path
Date: Fri, 20 Jul 2012 10:07:34 +0300
Message-ID: <20120720070733.GD11710@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26107 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2GTHHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2012 03:07:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

We called destroy_workqueue(dev->tmr_wq) before ->tmr_wq was allocated
which leads to an oops.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7647eca..0eaae23 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1098,7 +1098,7 @@ struct se_device *transport_add_device_to_core_hba(
 	 * Setup the Asymmetric Logical Unit Assignment for struct se_device
 	 */
 	if (core_setup_alua(dev, force_pt) < 0)
-		goto out;
+		goto err_dev_list;
 
 	/*
 	 * Startup the struct se_device processing thread
@@ -1108,7 +1108,7 @@ struct se_device *transport_add_device_to_core_hba(
 	if (!dev->tmr_wq) {
 		pr_err("Unable to create tmr workqueue for %s\n",
 			dev->transport->name);
-		goto out;
+		goto err_dev_list;
 	}
 	/*
 	 * Setup work_queue for QUEUE_FULL
@@ -1126,7 +1126,7 @@ struct se_device *transport_add_device_to_core_hba(
 		if (!inquiry_prod || !inquiry_rev) {
 			pr_err("All non TCM/pSCSI plugins require"
 				" INQUIRY consts\n");
-			goto out;
+			goto err_wq;
 		}
 
 		strncpy(&dev->se_sub_dev->t10_wwn.vendor[0], "LIO-ORG", 8);
@@ -1136,9 +1136,10 @@ struct se_device *transport_add_device_to_core_hba(
 	scsi_dump_inquiry(dev);
 
 	return dev;
-out:
-	destroy_workqueue(dev->tmr_wq);
 
+err_wq:
+	destroy_workqueue(dev->tmr_wq);
+err_dev_list:
 	spin_lock(&hba->device_lock);
 	list_del(&dev->dev_list);
 	hba->dev_count--;
