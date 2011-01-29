From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 27/28] fcoe: use dedicated workqueue instead of system_wq
Date: Fri, 28 Jan 2011 16:05:32 -0800
Message-ID: <20110129000532.1784.82462.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab1A2AFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:05:33 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

From: Tejun Heo <tj@kernel.org>

fcoe uses the system_wq to destroy ports and the work items need to be
flushed before the driver is unloaded.  As the work items free the
containing data structure, they can't be flushed directly.  The
workqueue should be flushed instead.

Also, the destruction works can be chained - ie. destruction of a port
may lead to destruction of another port where the work item for the
former queues the work for the latter.  Currently, the depth of chain
can be at most two and fcoe_exit() makes sure everything is complete
by calling flush_scheduled_work() twice.

With commit c8efcc25 (workqueue: allow chained queueing during
destruction), destroy_workqueue() can take care of chained works on
workqueue destruction.  Add and use fcoe_wq instead.  Simply
destroying fcoe_wq on driver unload takes care of flushing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8a1005d..46c57e5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -31,6 +31,7 @@
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
+#include <linux/workqueue.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_transport.h>
@@ -58,6 +59,8 @@ MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
 
 DEFINE_MUTEX(fcoe_config_mutex);
 
+static struct workqueue_struct *fcoe_wq;
+
 /* fcoe_percpu_clean completion.  Waiter protected by fcoe_create_mutex */
 static DECLARE_COMPLETION(fcoe_flush_completion);
 
@@ -1896,7 +1899,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		list_del(&fcoe->list);
 		port = lport_priv(fcoe->ctlr.lp);
 		fcoe_interface_cleanup(fcoe);
-		schedule_work(&port->destroy_work);
+		queue_work(fcoe_wq, &port->destroy_work);
 		goto out;
 		break;
 	case NETDEV_FEAT_CHANGE:
@@ -2387,6 +2390,10 @@ static int __init fcoe_init(void)
 	unsigned int cpu;
 	int rc = 0;
 
+	fcoe_wq = alloc_workqueue("fcoe", 0, 0);
+	if (!fcoe_wq)
+		return -ENOMEM;
+
 	/* register as a fcoe transport */
 	rc = fcoe_transport_attach(&fcoe_sw_transport);
 	if (rc) {
@@ -2425,6 +2432,7 @@ out_free:
 		fcoe_percpu_thread_destroy(cpu);
 	}
 	mutex_unlock(&fcoe_config_mutex);
+	destroy_workqueue(fcoe_wq);
 	return rc;
 }
 module_init(fcoe_init);
@@ -2450,7 +2458,7 @@ static void __exit fcoe_exit(void)
 		list_del(&fcoe->list);
 		port = lport_priv(fcoe->ctlr.lp);
 		fcoe_interface_cleanup(fcoe);
-		schedule_work(&port->destroy_work);
+		queue_work(fcoe_wq, &port->destroy_work);
 	}
 	rtnl_unlock();
 
@@ -2461,15 +2469,17 @@ static void __exit fcoe_exit(void)
 
 	mutex_unlock(&fcoe_config_mutex);
 
-	/* flush any asyncronous interface destroys,
-	 * this should happen after the netdev notifier is unregistered */
-	flush_scheduled_work();
-	/* That will flush out all the N_Ports on the hostlist, but now we
-	 * may have NPIV VN_Ports scheduled for destruction */
-	flush_scheduled_work();
+	/*
+	 * destroy_work's may be chained but destroy_workqueue()
+	 * can take care of them. Just kill the fcoe_wq.
+	 */
+	destroy_workqueue(fcoe_wq);
 
-	/* detach from scsi transport
-	 * must happen after all destroys are done, therefor after the flush */
+	/*
+	 * Detaching from the scsi transport must happen after all
+	 * destroys are done on the fcoe_wq. destroy_workqueue will
+	 * enusre the fcoe_wq is flushed.
+	 */
 	fcoe_if_exit();
 
 	/* detach from fcoe transport */
@@ -2618,7 +2628,7 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
 	mutex_lock(&n_port->lp_mutex);
 	list_del(&vn_port->list);
 	mutex_unlock(&n_port->lp_mutex);
-	schedule_work(&port->destroy_work);
+	queue_work(fcoe_wq, &port->destroy_work);
 	return 0;
 }
 

