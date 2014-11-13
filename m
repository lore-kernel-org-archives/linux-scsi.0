From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 3/3] zfcp: auto port scan resiliency
Date: Thu, 13 Nov 2014 14:59:48 +0100
Message-ID: <1415887188-40233-4-git-send-email-maier@linux.vnet.ibm.com>
References: <1415887188-40233-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:46684 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbaKMOAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 09:00:39 -0500
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 13 Nov 2014 14:00:36 -0000
In-Reply-To: <1415887188-40233-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

This patch improves the Fibre Channel port scan behaviour of the zfcp lldd.
Without it the zfcp device driver may churn up the storage area network by
excessive scanning and scan bursts, particularly in big virtual server
environments, potentially resulting in interference of virtual servers and
reduced availability of storage connectivity.

The two main issues as to the zfcp device drivers automatic port scan in
virtual server environments are frequency and simultaneity.
On the one hand, there is no point in allowing lots of ports scans
in a row. It makes sense, though, to make sure that a scan is conducted
eventually if there has been any indication for potential SAN changes.
On the other hand, lots of virtual servers receiving the same indication
for a SAN change had better not attempt to conduct a scan instantly,
that is, at the same time.

Hence this patch has a two-fold approach for better port scanning:
the introduction of a rate limit to amend frequency issues, and the
introduction of a short random backoff to amend simultaneity issues.
Both approaches boil down to deferred port scans, with delays
comprising parts for both approaches.

The new port scan behaviour is summarised best by:

                                               NEW:    NEW:
                          no_auto_port_rescan  random  rate    flush
                                               backoff limit   =wait

adapter resume/thaw       yes                  yes     no      yes*
adapter online (user)     no                   yes     no      yes*
port rescan (user)        no                   no      no      yes
adapter recovery (user)   yes                  yes     yes     no
adapter recovery (other)  yes                  yes     yes     no
incoming ELS              yes                  yes     yes     no
incoming ELS lost         yes                  yes     yes     no

Implementation is straight-forward by converting an existing worker to
a delayed worker. But care is needed whenever that worker is going to be
flushed (in order to make sure work has been completed), since a flush
operation cancels the timer set up for deferred execution (see * above).

There is a small race window whenever a port scan work starts
running up to the point in time of storing the time stamp for that port
scan. The impact is negligible. Closing that gap isn't trivial, though, and
would the destroy the beauty of a simple work-to-delayed-work conversion.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   |  6 +++--
 drivers/s390/scsi/zfcp_ccw.c   | 32 ++++++++++++++++++++++----
 drivers/s390/scsi/zfcp_def.h   |  3 ++-
 drivers/s390/scsi/zfcp_ext.h   |  1 +
 drivers/s390/scsi/zfcp_fc.c    | 52 +++++++++++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_sysfs.c | 10 +++++---
 6 files changed, 90 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 8004b07..01a7339 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -353,9 +353,11 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 	adapter->ccw_device = ccw_device;
 
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
-	INIT_WORK(&adapter->scan_work, zfcp_fc_scan_ports);
+	INIT_DELAYED_WORK(&adapter->scan_work, zfcp_fc_scan_ports);
 	INIT_WORK(&adapter->ns_up_work, zfcp_fc_sym_name_update);
 
+	adapter->next_port_scan = jiffies;
+
 	if (zfcp_qdio_setup(adapter))
 		goto failed;
 
@@ -420,7 +422,7 @@ void zfcp_adapter_unregister(struct zfcp_adapter *adapter)
 {
 	struct ccw_device *cdev = adapter->ccw_device;
 
-	cancel_work_sync(&adapter->scan_work);
+	cancel_delayed_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
 	cancel_work_sync(&adapter->ns_up_work);
 	zfcp_destroy_adapter_work_queue(adapter);
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index f9879d4..54c7b48 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -56,8 +56,22 @@ static int zfcp_ccw_activate(struct ccw_device *cdev, int clear, char *tag)
 	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				tag);
+
+	/*
+	 * We want to scan ports here, with some random backoff and without
+	 * rate limit. Recovery has already scheduled a port scan for us,
+	 * but with both random delay and rate limit. Nevertheless we get
+	 * what we want here by flushing the scheduled work after sleeping
+	 * an equivalent random time.
+	 * Let the port scan random delay elapse first. If recovery finishes
+	 * up to that point in time, that would be perfect for both recovery
+	 * and port scan. If not, i.e. recovery takes ages, there was no
+	 * point in waiting a random delay on top of the time consumed by
+	 * recovery.
+	 */
+	msleep(zfcp_fc_port_scan_backoff());
 	zfcp_erp_wait(adapter);
-	flush_work(&adapter->scan_work); /* ok to call even if nothing queued */
+	flush_delayed_work(&adapter->scan_work);
 
 	zfcp_ccw_adapter_put(adapter);
 
@@ -162,11 +176,19 @@ static int zfcp_ccw_set_online(struct ccw_device *cdev)
 	adapter->req_no = 0;
 
 	zfcp_ccw_activate(cdev, 0, "ccsonl1");
-	/* scan for remote ports
-	   either at the end of any successful adapter recovery
-	   or only after the adapter recovery for setting a device online */
+
+	/*
+	 * We want to scan ports here, always, with some random delay and
+	 * without rate limit - basically what zfcp_ccw_activate() has
+	 * achieved for us. Not quite! That port scan depended on
+	 * !no_auto_port_rescan. So let's cover the no_auto_port_rescan
+	 * case here to make sure a port scan is done unconditionally.
+	 * Since zfcp_ccw_activate() has waited the desired random time,
+	 * we can immediately schedule and flush a port scan for the
+	 * remaining cases.
+	 */
 	zfcp_fc_inverse_conditional_port_scan(adapter);
-	flush_work(&adapter->scan_work); /* ok to call even if nothing queued */
+	flush_delayed_work(&adapter->scan_work);
 	zfcp_ccw_adapter_put(adapter);
 	return 0;
 }
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index d91173f..b8e853e 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -186,12 +186,13 @@ struct zfcp_adapter {
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
 	unsigned long		stats_reset;
-	struct work_struct	scan_work;
+	struct delayed_work	scan_work;
 	struct work_struct	ns_up_work;
 	struct service_level	service_level;
 	struct workqueue_struct	*work_queue;
 	struct device_dma_parameters dma_parms;
 	struct zfcp_fc_events events;
+	unsigned long		next_port_scan;
 };
 
 struct zfcp_port {
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index a9c570a..5b50065 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -85,6 +85,7 @@ extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
 extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
 extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
 extern void zfcp_fc_sym_name_update(struct work_struct *);
+extern unsigned int zfcp_fc_port_scan_backoff(void);
 extern void zfcp_fc_conditional_port_scan(struct zfcp_adapter *);
 extern void zfcp_fc_inverse_conditional_port_scan(struct zfcp_adapter *);
 
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index ca28e1c..25d49f3 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/utsname.h>
+#include <linux/random.h>
 #include <scsi/fc/fc_els.h>
 #include <scsi/libfc.h>
 #include "zfcp_ext.h"
@@ -31,12 +32,54 @@ module_param_named(no_auto_port_rescan, no_auto_port_rescan, bool, 0600);
 MODULE_PARM_DESC(no_auto_port_rescan,
 		 "no automatic port_rescan (default off)");
 
+static unsigned int port_scan_backoff = 500;
+module_param(port_scan_backoff, uint, 0600);
+MODULE_PARM_DESC(port_scan_backoff,
+	"upper limit of port scan random backoff in msecs (default 500)");
+
+static unsigned int port_scan_ratelimit = 60000;
+module_param(port_scan_ratelimit, uint, 0600);
+MODULE_PARM_DESC(port_scan_ratelimit,
+	"minimum interval between port scans in msecs (default 60000)");
+
+unsigned int zfcp_fc_port_scan_backoff(void)
+{
+	if (!port_scan_backoff)
+		return 0;
+	return get_random_int() % port_scan_backoff;
+}
+
+static void zfcp_fc_port_scan_time(struct zfcp_adapter *adapter)
+{
+	unsigned long interval = msecs_to_jiffies(port_scan_ratelimit);
+	unsigned long backoff = msecs_to_jiffies(zfcp_fc_port_scan_backoff());
+
+	adapter->next_port_scan = jiffies + interval + backoff;
+}
+
+static void zfcp_fc_port_scan(struct zfcp_adapter *adapter)
+{
+	unsigned long now = jiffies;
+	unsigned long next = adapter->next_port_scan;
+	unsigned long delay = 0, max;
+
+	/* delay only needed within waiting period */
+	if (time_before(now, next)) {
+		delay = next - now;
+		/* paranoia: never ever delay scans longer than specified */
+		max = msecs_to_jiffies(port_scan_ratelimit + port_scan_backoff);
+		delay = min(delay, max);
+	}
+
+	queue_delayed_work(adapter->work_queue, &adapter->scan_work, delay);
+}
+
 void zfcp_fc_conditional_port_scan(struct zfcp_adapter *adapter)
 {
 	if (no_auto_port_rescan)
 		return;
 
-	queue_work(adapter->work_queue, &adapter->scan_work);
+	zfcp_fc_port_scan(adapter);
 }
 
 void zfcp_fc_inverse_conditional_port_scan(struct zfcp_adapter *adapter)
@@ -44,7 +87,7 @@ void zfcp_fc_inverse_conditional_port_scan(struct zfcp_adapter *adapter)
 	if (!no_auto_port_rescan)
 		return;
 
-	queue_work(adapter->work_queue, &adapter->scan_work);
+	zfcp_fc_port_scan(adapter);
 }
 
 /**
@@ -680,12 +723,15 @@ static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
  */
 void zfcp_fc_scan_ports(struct work_struct *work)
 {
-	struct zfcp_adapter *adapter = container_of(work, struct zfcp_adapter,
+	struct delayed_work *dw = to_delayed_work(work);
+	struct zfcp_adapter *adapter = container_of(dw, struct zfcp_adapter,
 						    scan_work);
 	int ret, i;
 	struct zfcp_fc_req *fc_req;
 	int chain, max_entries, buf_num, max_bytes;
 
+	zfcp_fc_port_scan_time(adapter);
+
 	chain = adapter->adapter_features & FSF_FEATURE_ELS_CT_CHAINED_SBALS;
 	buf_num = chain ? ZFCP_FC_GPN_FT_NUM_BUFS : 1;
 	max_entries = chain ? ZFCP_FC_GPN_FT_MAX_ENT : ZFCP_FC_GPN_FT_ENT_PAGE;
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index a488c09..96a0be1 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -221,9 +221,13 @@ static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
 	if (!adapter)
 		return -ENODEV;
 
-	/* sync the user-space- with the kernel-invocation of scan_work */
-	queue_work(adapter->work_queue, &adapter->scan_work);
-	flush_work(&adapter->scan_work);
+	/*
+	 * Users wish is our command: immediately schedule and flush a
+	 * worker to conduct a synchronous port scan, that is, neither
+	 * a random delay nor a rate limit is applied here.
+	 */
+	queue_delayed_work(adapter->work_queue, &adapter->scan_work, 0);
+	flush_delayed_work(&adapter->scan_work);
 	zfcp_ccw_adapter_put(adapter);
 
 	return (ssize_t) count;
-- 
1.8.5.5

