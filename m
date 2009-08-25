From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/64] fcoe: add mutex to protect create and destroy
Date: Tue, 25 Aug 2009 14:00:13 -0700
Message-ID: <20090825210013.1553.13730.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31537 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZHYVAL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:11 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Rather than rely on the hostlist_lock to be held while creating exchange
managers, serialize fcoe instance creation and destruction with a mutex.
This will allow the hostlist addition to be moved out of fcoe_if_create(),
which will simplify NPIV support.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 63aeeca..43added 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -55,6 +55,8 @@ module_param_named(ddp_min, fcoe_ddp_min, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
 		 "Direct Data Placement (DDP).");
 
+DEFINE_MUTEX(fcoe_config_mutex);
+
 /* fcoe host list */
 LIST_HEAD(fcoe_hostlist);
 DEFINE_RWLOCK(fcoe_hostlist_lock);
@@ -811,6 +813,7 @@ static int __init fcoe_if_init(void)
 int __exit fcoe_if_exit(void)
 {
 	fc_release_transport(scsi_transport_fcoe_sw);
+	scsi_transport_fcoe_sw = NULL;
 	return 0;
 }
 
@@ -1686,6 +1689,19 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	struct fc_lport *lport;
 	int rc;
 
+	mutex_lock(&fcoe_config_mutex);
+#ifdef CONFIG_FCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+#endif
+
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		rc = -ENODEV;
@@ -1705,6 +1721,7 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 out_putdev:
 	dev_put(netdev);
 out_nodev:
+	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
 
@@ -1722,6 +1739,19 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	struct fc_lport *lport;
 	struct net_device *netdev;
 
+	mutex_lock(&fcoe_config_mutex);
+#ifdef CONFIG_FCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+#endif
+
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		rc = -ENODEV;
@@ -1768,6 +1798,7 @@ out_free:
 out_putdev:
 	dev_put(netdev);
 out_nodev:
+	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
 
@@ -1971,6 +2002,8 @@ static int __init fcoe_init(void)
 	int rc = 0;
 	struct fcoe_percpu_s *p;
 
+	mutex_lock(&fcoe_config_mutex);
+
 	for_each_possible_cpu(cpu) {
 		p = &per_cpu(fcoe_percpu, cpu);
 		skb_queue_head_init(&p->fcoe_rx_list);
@@ -1991,13 +2024,14 @@ static int __init fcoe_init(void)
 	if (rc)
 		goto out_free;
 
+	mutex_unlock(&fcoe_config_mutex);
 	return 0;
 
 out_free:
 	for_each_online_cpu(cpu) {
 		fcoe_percpu_thread_destroy(cpu);
 	}
-
+	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
 module_init(fcoe_init);
@@ -2012,6 +2046,8 @@ static void __exit fcoe_exit(void)
 	unsigned int cpu;
 	struct fcoe_interface *fcoe, *tmp;
 
+	mutex_lock(&fcoe_config_mutex);
+
 	fcoe_dev_cleanup();
 
 	/* releases the associated fcoe hosts */
@@ -2025,5 +2061,7 @@ static void __exit fcoe_exit(void)
 
 	/* detach from scsi transport */
 	fcoe_if_exit();
+
+	mutex_unlock(&fcoe_config_mutex);
 }
 module_exit(fcoe_exit);

