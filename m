From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] bnx2fc: Need not schedule destroy_work from
 __bnx2fc_destroy
Date: Wed, 24 Aug 2011 18:56:42 -0700
Message-ID: <1314237402-17413-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2626 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1HYB5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 21:57:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Since it is already called in the right context with rtnl_lock and dev_mutex
held.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e6c9879..24e7071 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -56,7 +56,7 @@ static struct scsi_host_template bnx2fc_shost_template;
 static struct fc_function_template bnx2fc_transport_function;
 static struct fc_function_template bnx2fc_vport_xport_function;
 static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode);
-static void __bnx2fc_destroy(struct bnx2fc_interface *interface, bool schedule);
+static void __bnx2fc_destroy(struct bnx2fc_interface *interface);
 static int bnx2fc_destroy(struct net_device *net_device);
 static int bnx2fc_enable(struct net_device *netdev);
 static int bnx2fc_disable(struct net_device *netdev);
@@ -840,7 +840,7 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 		list_for_each_entry_safe(interface, tmp, &if_list, list) {
 			if (interface->hba != hba)
 				continue;
-			__bnx2fc_destroy(interface, true);
+			__bnx2fc_destroy(interface);
 		}
 		mutex_unlock(&bnx2fc_dev_lock);
 		return;
@@ -1479,21 +1479,16 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 	scsi_host_put(lport->host);
 }
 
-static void __bnx2fc_destroy(struct bnx2fc_interface *interface, bool schedule)
+static void __bnx2fc_destroy(struct bnx2fc_interface *interface)
 {
 	struct fc_lport *lport = interface->ctlr.lp;
-	struct fcoe_port *port = lport_priv(lport);
 
 	bnx2fc_interface_cleanup(interface);
 	bnx2fc_stop(interface);
-
 	list_del(&interface->list);
 	lport = interface->ctlr.lp;
 	bnx2fc_interface_put(interface);
-	if (schedule)
-		queue_work(bnx2fc_wq, &port->destroy_work);
-	else
-		bnx2fc_if_destroy(lport);
+	bnx2fc_if_destroy(lport);
 }
 
 /**
@@ -1523,7 +1518,7 @@ static int bnx2fc_destroy(struct net_device *netdev)
 
 
 	destroy_workqueue(interface->timer_work_queue);
-	__bnx2fc_destroy(interface, false);
+	__bnx2fc_destroy(interface);
 
 netdev_err:
 	mutex_unlock(&bnx2fc_dev_lock);
@@ -2110,7 +2105,7 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 	list_for_each_entry_safe(interface, tmp, &if_list, list)
 		/* destroy not called yet, move to quiesced list */
 		if (interface->hba == hba)
-			__bnx2fc_destroy(interface, false);
+			__bnx2fc_destroy(interface);
 	mutex_unlock(&bnx2fc_dev_lock);
 
 	bnx2fc_ulp_stop(hba);
-- 
1.7.0.6


