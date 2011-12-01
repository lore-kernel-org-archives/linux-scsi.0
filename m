From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Thu, 1 Dec 2011 20:11:45 +0100
Message-ID: <201112012011.45444.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add a time-based transport layer test such that fail-over in a multipath
setup can happen quickly.

Add the necessary functions in the SRP transport module to allow an SRP
initiator driver to implement this.

Add a slave_delete callback in the SCSI host template such that SCSI
hosts that hold a reference to a SCSI device can be deleted via the
sysfs SCSI host "delete" attribute.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |   18 +++
 drivers/infiniband/ulp/srp/ib_srp.c          |   48 ++++++++
 drivers/scsi/scsi_sysfs.c                    |    7 +-
 drivers/scsi/scsi_transport_srp.c            |  168 +++++++++++++++++++++++++-
 include/scsi/scsi_host.h                     |    9 ++
 include/scsi/scsi_transport_srp.h            |    9 ++
 6 files changed, 257 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index 7b0d4a5..d8a9048 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -1,3 +1,21 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/ping_interval
+Date:		November 1, 2011
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Time in seconds between two sucessive ping attempts. Setting
+		this parameter to zero or a negative value disables the ping
+		mechanism.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/ping_timeout
+Date:		November 1, 2011
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	If more time has elapsed than the specified number of seconds
+		since the latest successful ping attempt, the SRP initiator
+		driver that enabled this feature is informed about a transport
+		layer timeout by invoking its rport_ping_timedout callback
+		function.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 797a8f1..82057f2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -507,6 +507,26 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 }
 
 /**
+ * srp_disable_ping() - Stop pinging a target.
+ *
+ * Note: Can be invoked concurrently via the SCSI host sysfs attribute "delete"
+ * and one of the rport callback functions.
+ */
+static void srp_disable_ping(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_target_port *target = host_to_target(shost);
+	struct srp_rport *rport = target->rport;
+
+	if (rport->sdev == sdev) {
+		pr_debug("Disabling pinging rport %p via sdev %p\n", rport,
+			 sdev);
+		srp_rport_set_sdev(rport, NULL);
+		srp_rport_disable_ping(rport);
+	}
+}
+
+/*
  * srp_remove_target() - Remove an SRP target.
  *
  * The strategy to remove a target is as follows:
@@ -522,6 +542,8 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
  */
 static void srp_remove_target(struct srp_target_port *target)
 {
+	struct srp_rport *rport = target->rport;
+
 	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
 	srp_del_scsi_host_attr(target->scsi_host);
@@ -529,6 +551,8 @@ static void srp_remove_target(struct srp_target_port *target)
 	mutex_lock(&target->mutex);
 	mutex_unlock(&target->mutex);
 	srp_unblock_rport(rport);
+	if (rport->sdev)
+		srp_disable_ping(rport->sdev);
 	srp_rport_disable_recovery(target->rport);
 	cancel_delayed_work_sync(&target->reconnect_work);
 	srp_stop_rport(target->rport);
@@ -555,6 +579,21 @@ static void srp_remove_work(struct work_struct *work)
 	srp_remove_target(target);
 }
 
+static void srp_ping_timedout(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+
+	pr_debug("ping timeout: rport = %p; target = %p / state %d\n",
+		 rport, target, target->state);
+
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_BLOCKED)) {
+		srp_block_rport(rport);
+		srp_start_recovery_timer(target->rport);
+	}
+	mutex_unlock(&target->mutex);
+}
+
 static void srp_recovery_timedout(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
@@ -1506,6 +1545,13 @@ static int srp_slave_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct srp_target_port *target = host_to_target(shost);
+	struct srp_rport *rport = target->rport;
+
+	if (!rport->sdev) {
+		pr_debug("Enable pinging rport %p through sdev %p\n", rport,
+			 sdev);
+		srp_rport_set_sdev(rport, sdev);
+	}
 
 	if (!WARN_ON(target->rq_tmo_jiffies == 0))
 		blk_queue_rq_timeout(sdev->request_queue,
@@ -2070,6 +2116,7 @@ static struct scsi_host_template srp_template = {
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
 	.slave_alloc			= srp_slave_alloc,
+	.slave_delete			= srp_disable_ping,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.eh_abort_handler		= srp_abort,
@@ -2084,6 +2131,7 @@ static struct scsi_host_template srp_template = {
 };
 
 static struct srp_function_template ib_srp_transport_functions = {
+	.rport_ping_timedout	 = srp_ping_timedout,
 	.rport_recovery_timedout = srp_recovery_timedout,
 };
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e0bd3f7..328caa3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -534,7 +534,12 @@ static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
 static void sdev_store_delete_callback(struct device *dev)
 {
-	scsi_remove_device(to_scsi_device(dev));
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_host_template *sht = sdev->host->hostt;
+
+	if (sht->slave_delete)
+		sht->slave_delete(sdev);
+	scsi_remove_device(sdev);
 }
 
 static ssize_t
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 9a57b7b..135a870 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -29,6 +29,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
 #include "scsi_transport_srp_internal.h"
@@ -39,7 +40,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 3
+#define SRP_RPORT_ATTRS 5
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -117,6 +118,67 @@ show_srp_rport_roles(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
 
+static ssize_t show_srp_rport_ping_interval(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return sprintf(buf, "%d\n", rport->ping_itv);
+}
+
+static ssize_t store_srp_rport_ping_interval(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res, ping_itv;
+
+	sprintf(ch, "%.*s", (int)min(sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &ping_itv);
+	if (res)
+		goto out;
+	rport->ping_itv = ping_itv;
+	pr_debug("rport %p: new ping interval = %d seconds\n", rport, ping_itv);
+	if (ping_itv > 0)
+		queue_delayed_work(system_long_wq, &rport->ping_work,
+				   ping_itv * HZ);
+	else
+		cancel_delayed_work(&rport->ping_work);
+	res = count;
+out:
+	return res;
+}
+
+static DEVICE_ATTR(ping_interval, S_IRUGO | S_IWUSR,
+		   show_srp_rport_ping_interval, store_srp_rport_ping_interval);
+
+static ssize_t show_srp_rport_ping_timeout(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return sprintf(buf, "%d\n", rport->ping_tmo);
+}
+
+static ssize_t store_srp_rport_ping_timeout(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res;
+
+	sprintf(ch, "%.*s", (int)min(sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &rport->ping_tmo);
+	return res == 0 ? count : res;
+}
+
+static DEVICE_ATTR(ping_timeout, S_IRUGO | S_IWUSR, show_srp_rport_ping_timeout,
+		   store_srp_rport_ping_timeout);
+
 static ssize_t show_srp_rport_recovery_tmo(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
@@ -194,6 +256,7 @@ void srp_unblock_rport(struct srp_rport *rport)
 	spin_lock_irqsave(&rport->lock, flags);
 	prev_state = rport->state;
 	if (prev_state == SRP_RPORT_BLOCKED) {
+		rport->latest_ping_response = jiffies;
 		rport->state = SRP_RPORT_LIVE;
 		unblock = true;
 	}
@@ -249,6 +312,20 @@ void srp_start_recovery_timer(struct srp_rport *rport)
 EXPORT_SYMBOL(srp_start_recovery_timer);
 
 /**
+ * srp_rport_disable_ping() - Stop pinging and prevent reenabling pinging.
+ */
+void srp_rport_disable_ping(struct srp_rport *rport)
+{
+	struct device *dev = rport->dev.parent;
+
+	WARN_ON(rport->state == SRP_RPORT_BLOCKED);
+	device_remove_file(dev, &dev_attr_ping_timeout);
+	device_remove_file(dev, &dev_attr_ping_interval);
+	cancel_delayed_work_sync(&rport->ping_work);
+}
+EXPORT_SYMBOL(srp_rport_disable_ping);
+
+/**
  * srp_rport_disable_recovery() - Disable the transport layer recovery timer.
  */
 void srp_rport_disable_recovery(struct srp_rport *rport)
@@ -265,10 +342,92 @@ EXPORT_SYMBOL(srp_rport_disable_recovery);
  */
 void srp_stop_rport(struct srp_rport *rport)
 {
+	srp_rport_disable_ping(rport);
 	srp_rport_disable_recovery(rport);
 }
 EXPORT_SYMBOL(srp_stop_rport);
 
+/**
+ * srp_rport_set_sdev() - Set the SCSI device that will be used for pinging.
+ */
+void srp_rport_set_sdev(struct srp_rport *rport, struct scsi_device *sdev)
+{
+	unsigned long flags;
+
+	if (sdev && !get_device(&sdev->sdev_dev))
+		sdev = NULL;
+
+	spin_lock_irqsave(&rport->lock, flags);
+	swap(rport->sdev, sdev);
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	if (sdev)
+		put_device(&sdev->sdev_dev);
+}
+EXPORT_SYMBOL(srp_rport_set_sdev);
+
+/**
+ * srp_rport_get_sdev() - Get the SCSI device used for pinging.
+ */
+static struct scsi_device *rport_get_sdev(struct srp_rport *rport)
+{
+	struct scsi_device *sdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rport->lock, flags);
+	sdev = rport->sdev;
+	if (sdev && !get_device(&sdev->sdev_dev))
+		sdev = NULL;
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	return sdev;
+}
+
+/**
+ * rport_ping() - Verify whether the transport layer is still operational.
+ */
+static void rport_ping(struct work_struct *work)
+{
+	struct scsi_sense_hdr sshdr;
+	struct srp_rport *rport;
+	struct scsi_device *sdev;
+	int res, itv, tmo;
+
+	rport = container_of(work, struct srp_rport, ping_work.work);
+	itv = rport->ping_itv;
+	tmo = rport->ping_tmo;
+	sdev = rport_get_sdev(rport);
+	pr_debug("rport %p has state %d; sdev = %p; ping interval = %d\n",
+		 rport, rport->state, sdev, itv);
+	if (itv <= 0)
+		goto out;
+	if (!sdev)
+		goto schedule;
+	if (rport->state == SRP_RPORT_BLOCKED)
+		goto put;
+	memset(&sshdr, 0, sizeof(sshdr));
+	res = scsi_test_unit_ready(sdev, itv, 1, NULL);
+	pr_debug("scsi_test_unit_ready() result = 0x%x / %s%s\n", res,
+		 scsi_sense_valid(&sshdr) ? "sense valid" : "sense not valid",
+		 scsi_sense_valid(&sshdr) &&
+		 sshdr.sense_key == UNIT_ATTENTION ? " (unit attention)" : "");
+	if (scsi_status_is_good(res) || (res & SAM_STAT_CHECK_CONDITION)) {
+		rport->latest_ping_response = jiffies;
+	} else if (tmo > 0 &&
+		   time_after(jiffies, rport->latest_ping_response + tmo)) {
+		shost_printk(KERN_INFO, sdev->host,
+			     "SRP ping timeout elapsed\n");
+		if (rport->ft->rport_ping_timedout)
+			rport->ft->rport_ping_timedout(rport);
+	}
+put:
+	put_device(&sdev->sdev_dev);
+schedule:
+	queue_delayed_work(system_long_wq, &rport->ping_work, itv * HZ);
+out:
+	return;
+}
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -346,6 +505,7 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	rport->roles = ids->roles;
 
 	rport->recovery_tmo = 120;
+	INIT_DELAYED_WORK(&rport->ping_work, rport_ping);
 	INIT_DELAYED_WORK(&rport->recovery_work, rport_recovery_timedout);
 	spin_lock_init(&rport->lock);
 	rport->state = SRP_RPORT_LIVE;
@@ -353,6 +513,8 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
+	pr_debug("rport %p has name %s\n", rport, dev_name(&rport->dev));
+
 	transport_setup_device(&rport->dev);
 
 	ret = device_add(&rport->dev);
@@ -467,6 +629,10 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->rport_ping_timedout) {
+		i->rport_attrs[count++] = &dev_attr_ping_interval;
+		i->rport_attrs[count++] = &dev_attr_ping_timeout;
+	}
 	if (ft->rport_recovery_timedout)
 		i->rport_attrs[count++] = &dev_attr_recovery_tmo;
 	i->rport_attrs[count++] = NULL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f1f2644..16536a6 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -233,6 +233,15 @@ struct scsi_host_template {
 	 */
 	int (* slave_configure)(struct scsi_device *);
 
+	/**
+	 * Callback invoked just before scsi_remove_device() will be invoked
+	 * e.g. if device removal has been requested via the sdev "delete"
+	 * sysfs attribute.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (* slave_delete)(struct scsi_device *);
+
 	/*
 	 * Immediately prior to deallocating the device and after all activity
 	 * has ceased the mid layer calls this point so that the low level
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index fcda8e3..565cb79 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -38,14 +38,20 @@ struct srp_rport {
 	void			*lld_data;	/* LLD private data */
 
 	spinlock_t		lock;
+	struct scsi_device	*sdev;
 	enum srp_rport_state	state;
 
+	int			ping_itv;
+	int			ping_tmo;
+	unsigned long		latest_ping_response;
 	int			recovery_tmo;
+	struct delayed_work	ping_work;
 	struct delayed_work	recovery_work;
 };
 
 struct srp_function_template {
 	/* for initiator drivers */
+	void (*rport_ping_timedout) (struct srp_rport *rport);
 	void (*rport_recovery_timedout) (struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
@@ -62,6 +68,9 @@ extern void srp_rport_del(struct srp_rport *);
 extern void srp_unblock_rport(struct srp_rport *rport);
 extern void srp_block_rport(struct srp_rport *rport);
 extern void srp_start_recovery_timer(struct srp_rport *rport);
+extern void srp_rport_set_sdev(struct srp_rport *rport,
+			       struct scsi_device *sdev);
+extern void srp_rport_disable_ping(struct srp_rport *rport);
 extern void srp_rport_disable_recovery(struct srp_rport *rport);
 extern void srp_stop_rport(struct srp_rport *rport);
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
