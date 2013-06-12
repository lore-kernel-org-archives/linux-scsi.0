From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Wed, 12 Jun 2013 15:28:27 +0200
Message-ID: <51B8777B.5050201@acm.org>
References: <51B87501.4070005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:57178 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3FLN2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 09:28:30 -0400
In-Reply-To: <51B87501.4070005@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: David Dillow <dillowda@ornl.gov>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

Add the necessary functions in the SRP transport module to allow
an SRP initiator driver to implement transport layer error handling
similar to the functionality already provided by the FC transport
layer. This includes:
- Support for implementing fast_io_fail_tmo, the time that should
  elapse after having detected a transport layer problem and
  before failing I/O.
- Support for implementing dev_loss_tmo, the time that should
  elapse after having detected a transport layer problem and
  before removing a remote port.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 Documentation/ABI/stable/sysfs-transport-srp |   36 ++
 drivers/scsi/scsi_transport_srp.c            |  489 +++++++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h            |   54 ++-
 3 files changed, 576 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index b36fb0d..b7759b1 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -5,6 +5,23 @@ Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
 Description:	Instructs an SRP initiator to disconnect from a target and to
 		remove all LUNs imported from that target.
 
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
+Date:		September 1, 2013
+KernelVersion:	3.11
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before removing a target port.
+		Zero means immediate removal.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/fast_io_fail_tmo
+Date:		September 1, 2013
+KernelVersion:	3.11
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before failing I/O. Zero means
+		immediate removal. A negative value will disable this
+		behavior.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
@@ -12,8 +29,27 @@ Contact:	linux-scsi@vger.kernel.org
 Description:	16-byte local SRP port identifier in hexadecimal format. An
 		example: 4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00.
 
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/reconnect_delay
+Date:		September 1, 2013
+KernelVersion:	3.11
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Number of seconds the SCSI layer will wait after a reconnect
+		attempt failed before retrying.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/roles
 Date:		June 27, 2007
 KernelVersion:	2.6.24
 Contact:	linux-scsi@vger.kernel.org
 Description:	Role of the remote port. Either "SRP Initiator" or "SRP Target".
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/state
+Date:		September 1, 2013
+KernelVersion:	3.11
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	State of the transport layer to the remote port. "running" if
+		the transport layer is operational; "blocked" if a transport
+		layer error has been encountered but the fail_io_fast_tmo
+		timer has not yet fired; "fail-fast" after the
+		fail_io_fast_tmo timer has fired and before the "dev_loss_tmo"
+		timer has fired; "lost" after the "dev_loss_tmo" timer has
+		fired and before the port is finally removed.
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index f7ba94a..53b34b3 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -24,12 +24,15 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_srp.h>
+#include "scsi_priv.h"
 #include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
@@ -38,7 +41,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 3
+#define SRP_RPORT_ATTRS 8
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -54,6 +57,28 @@ struct srp_internal {
 
 #define	dev_to_rport(d)	container_of(d, struct srp_rport, dev)
 #define transport_class_to_srp_rport(dev) dev_to_rport((dev)->parent)
+static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
+{
+	return dev_to_shost(r->dev.parent);
+}
+
+/**
+ * srp_tmo_valid() - check timeout combination validity
+ *
+ * If no fast I/O fail timeout has been configured then the device loss timeout
+ * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O fail timeout has
+ * been configured then it must be below the device loss timeout.
+ */
+int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
+{
+	return (fast_io_fail_tmo < 0 && 1 <= dev_loss_tmo &&
+		dev_loss_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		|| (0 <= fast_io_fail_tmo &&
+		    (dev_loss_tmo < 0 ||
+		     (fast_io_fail_tmo < dev_loss_tmo &&
+		      dev_loss_tmo < LONG_MAX / HZ))) ? 0 : -EINVAL;
+}
+EXPORT_SYMBOL_GPL(srp_tmo_valid);
 
 static int srp_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
@@ -134,10 +159,441 @@ static ssize_t store_srp_rport_delete(struct device *dev,
 
 static DEVICE_ATTR(delete, S_IWUSR, NULL, store_srp_rport_delete);
 
+static ssize_t show_srp_rport_state(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	static const char *const state_name[] = {
+		[SRP_RPORT_RUNNING]	= "running",
+		[SRP_RPORT_BLOCKED]	= "blocked",
+		[SRP_RPORT_FAIL_FAST]	= "fail-fast",
+		[SRP_RPORT_LOST]	= "lost",
+	};
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	enum srp_rport_state state = rport->state;
+
+	return sprintf(buf, "%s\n",
+		       (unsigned)state < ARRAY_SIZE(state_name) ?
+		       state_name[state] : "???");
+}
+
+static DEVICE_ATTR(state, S_IRUGO, show_srp_rport_state, NULL);
+
+static ssize_t show_reconnect_delay(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return sprintf(buf, "%d\n", rport->reconnect_delay);
+}
+
+static ssize_t store_reconnect_delay(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, const size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res, delay;
+
+	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &delay);
+	if (res)
+		goto out;
+
+	res = mutex_lock_interruptible(&rport->mutex);
+	if (res)
+		goto out;
+	if (rport->reconnect_delay <= 0 && delay > 0 &&
+	    rport->state != SRP_RPORT_RUNNING) {
+		queue_delayed_work(system_long_wq, &rport->reconnect_work,
+				   delay * HZ);
+	} else if (delay <= 0) {
+		cancel_delayed_work(&rport->reconnect_work);
+	}
+	rport->reconnect_delay = delay;
+	mutex_unlock(&rport->mutex);
+
+	res = count;
+
+out:
+	return res;
+}
+
+static DEVICE_ATTR(reconnect_delay, S_IRUGO | S_IWUSR, show_reconnect_delay,
+		   store_reconnect_delay);
+
+static ssize_t show_failed_reconnects(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return sprintf(buf, "%d\n", rport->failed_reconnects);
+}
+
+static DEVICE_ATTR(failed_reconnects, S_IRUGO, show_failed_reconnects, NULL);
+
+static ssize_t show_srp_rport_fast_io_fail_tmo(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	if (rport->fast_io_fail_tmo >= 0)
+		return sprintf(buf, "%d\n", rport->fast_io_fail_tmo);
+	else
+		return sprintf(buf, "off\n");
+}
+
+static ssize_t store_srp_rport_fast_io_fail_tmo(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16], *p;
+	int res;
+	int fast_io_fail_tmo;
+
+	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+	p = strchr(ch, '\n');
+	if (p)
+		*p = '\0';
+
+	if (strcmp(ch, "off") != 0) {
+		res = kstrtoint(ch, 0, &fast_io_fail_tmo);
+		if (res)
+			goto out;
+	} else {
+		fast_io_fail_tmo = -1;
+	}
+	res = srp_tmo_valid(fast_io_fail_tmo, rport->dev_loss_tmo);
+	if (res)
+		goto out;
+	rport->fast_io_fail_tmo = fast_io_fail_tmo;
+	res = count;
+
+out:
+	return res;
+}
+
+static DEVICE_ATTR(fast_io_fail_tmo, S_IRUGO | S_IWUSR,
+		   show_srp_rport_fast_io_fail_tmo,
+		   store_srp_rport_fast_io_fail_tmo);
+
+static ssize_t show_srp_rport_dev_loss_tmo(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	if (rport->dev_loss_tmo >= 0)
+		return sprintf(buf, "%d\n", rport->dev_loss_tmo);
+	else
+		return sprintf(buf, "off\n");
+}
+
+static ssize_t store_srp_rport_dev_loss_tmo(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res;
+	int dev_loss_tmo;
+
+	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+	if (strcmp(ch, "off") != 0) {
+		res = kstrtoint(ch, 0, &dev_loss_tmo);
+		if (res)
+			goto out;
+	} else {
+		dev_loss_tmo = -1;
+	}
+	res = srp_tmo_valid(rport->fast_io_fail_tmo, dev_loss_tmo);
+	if (res)
+		goto out;
+	rport->dev_loss_tmo = dev_loss_tmo;
+	res = count;
+
+out:
+	return res;
+}
+
+static DEVICE_ATTR(dev_loss_tmo, S_IRUGO | S_IWUSR,
+		   show_srp_rport_dev_loss_tmo,
+		   store_srp_rport_dev_loss_tmo);
+
+static int srp_rport_set_state(struct srp_rport *rport,
+			       enum srp_rport_state new_state)
+{
+	enum srp_rport_state old_state = rport->state;
+
+	lockdep_assert_held(&rport->mutex);
+
+	switch (new_state) {
+	case SRP_RPORT_RUNNING:
+		switch (old_state) {
+		case SRP_RPORT_LOST:
+			goto invalid;
+		default:
+			break;
+		}
+		break;
+	case SRP_RPORT_BLOCKED:
+		switch (old_state) {
+		case SRP_RPORT_RUNNING:
+			break;
+		default:
+			goto invalid;
+		}
+		break;
+	case SRP_RPORT_FAIL_FAST:
+		switch (old_state) {
+		case SRP_RPORT_LOST:
+			goto invalid;
+		default:
+			break;
+		}
+		break;
+	case SRP_RPORT_LOST:
+		break;
+	}
+	rport->state = new_state;
+	return 0;
+
+invalid:
+	return -EINVAL;
+}
+
+/**
+ * scsi_request_fn_active - number of kernel threads inside scsi_request_fn()
+ */
+static int scsi_request_fn_active(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	struct request_queue *q;
+	int request_fn_active = 0;
+
+	shost_for_each_device(sdev, shost) {
+		q = sdev->request_queue;
+
+		spin_lock_irq(q->queue_lock);
+		request_fn_active += q->request_fn_active;
+		spin_unlock_irq(q->queue_lock);
+	}
+
+	return request_fn_active;
+}
+
+/**
+ * srp_reconnect_rport - reconnect by invoking srp_function_template.reconnect()
+ *
+ * Blocks SCSI command queueing before invoking reconnect() such that the
+ * scsi_host_template.queuecommand() won't be invoked concurrently with
+ * reconnect(). This is important since a reconnect() implementation may
+ * reallocate resources needed by queuecommand(). Please note that this
+ * function neither waits until outstanding requests have finished nor tries
+ * to abort these. It is the responsibility of the reconnect() function to
+ * finish outstanding commands before reconnecting to the target port.
+ */
+int srp_reconnect_rport(struct srp_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+	struct scsi_device *sdev;
+	int res;
+
+	pr_debug("SCSI host %s\n", dev_name(&shost->shost_gendev));
+
+	res = mutex_lock_interruptible(&rport->mutex);
+	if (res) {
+		pr_debug("%s: mutex_lock_interruptible() returned %d\n",
+			 dev_name(&shost->shost_gendev), res);
+		goto out;
+	}
+
+	spin_lock_irq(shost->host_lock);
+	scsi_block_requests(shost);
+	spin_unlock_irq(shost->host_lock);
+
+	while (scsi_request_fn_active(shost))
+		msleep(20);
+
+	res = i->f->reconnect(rport);
+	scsi_unblock_requests(shost);
+	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
+		 dev_name(&shost->shost_gendev), rport->state, res);
+	if (res == 0) {
+		cancel_delayed_work(&rport->fast_io_fail_work);
+		cancel_delayed_work(&rport->dev_loss_work);
+		rport->failed_reconnects = 0;
+		scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
+		srp_rport_set_state(rport, SRP_RPORT_RUNNING);
+		/*
+		 * It can occur that after fast_io_fail_tmo expired and before
+		 * dev_loss_tmo expired that the SCSI error handler has
+		 * offlined one or more devices. scsi_target_unblock() doesn't
+		 * change the state of these devices into running, so do that
+		 * explicitly.
+		 */
+		spin_lock_irq(shost->host_lock);
+		__shost_for_each_device(sdev, shost)
+			if (sdev->sdev_state == SDEV_OFFLINE)
+				sdev->sdev_state = SDEV_RUNNING;
+		spin_unlock_irq(shost->host_lock);
+	} else if (rport->state == SRP_RPORT_RUNNING) {
+		srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST);
+		scsi_target_unblock(&shost->shost_gendev,
+				    SDEV_TRANSPORT_OFFLINE);
+	}
+	mutex_unlock(&rport->mutex);
+
+out:
+	return res;
+}
+EXPORT_SYMBOL(srp_reconnect_rport);
+
+static void srp_reconnect_work(struct work_struct *work)
+{
+	struct srp_rport *rport = container_of(to_delayed_work(work),
+					struct srp_rport, reconnect_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	int delay, res;
+
+	res = srp_reconnect_rport(rport);
+	if (res != 0) {
+		shost_printk(KERN_ERR, shost,
+			     "reconnect attempt %d failed (%d)\n",
+			     ++rport->failed_reconnects, res);
+		delay = rport->reconnect_delay *
+			min(100, max(1, rport->failed_reconnects - 10));
+		if (delay > 0)
+			queue_delayed_work(system_long_wq,
+					   &rport->reconnect_work, delay * HZ);
+	}
+}
+
+static void __rport_fast_io_fail_timedout(struct srp_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct srp_internal *i;
+
+	lockdep_assert_held(&rport->mutex);
+
+	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
+		return;
+	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
+
+	/* Involve the LLDD if possible to terminate all io on the rport. */
+	i = to_srp_internal(shost->transportt);
+	if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+}
+
+/**
+ * rport_fast_io_fail_timedout() - fast I/O failure timeout handler
+ *
+ * Unblocks the SCSI host.
+ */
+static void rport_fast_io_fail_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport = container_of(to_delayed_work(work),
+					struct srp_rport, fast_io_fail_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
+	pr_debug("fast_io_fail_tmo expired for %s.\n",
+		 dev_name(&shost->shost_gendev));
+
+	mutex_lock(&rport->mutex);
+	__rport_fast_io_fail_timedout(rport);
+	mutex_unlock(&rport->mutex);
+}
+
+/**
+ * rport_dev_loss_timedout() - device loss timeout handler
+ *
+ * Note: rport->ft->rport_delete must either unblock the SCSI host or schedule
+ * SCSI host removal.
+ */
+static void rport_dev_loss_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport = container_of(to_delayed_work(work),
+					struct srp_rport, dev_loss_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+
+	pr_err("dev_loss_tmo expired for %s.\n",
+	       dev_name(&shost->shost_gendev));
+
+	mutex_lock(&rport->mutex);
+	WARN_ON(srp_rport_set_state(rport, SRP_RPORT_LOST) != 0);
+	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
+	mutex_unlock(&rport->mutex);
+
+	i->f->rport_delete(rport);
+}
+
+/**
+ * srp_start_tl_fail_timers() - start the transport layer failure timers
+ *
+ * Start the transport layer fast I/O failure and device loss timers. Do not
+ * modify a timer that was already started.
+ */
+void srp_start_tl_fail_timers(struct srp_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	int delay;
+
+	mutex_lock(&rport->mutex);
+	pr_debug("%s current state: %d\n", dev_name(&shost->shost_gendev),
+		 rport->state);
+	if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) != 0)
+		goto out_unlock;
+	pr_debug("%s new state: %d\n", dev_name(&shost->shost_gendev),
+		 rport->state);
+	scsi_target_block(&shost->shost_gendev);
+
+	if (rport->fast_io_fail_tmo >= 0)
+		queue_delayed_work(system_long_wq, &rport->fast_io_fail_work,
+				   1UL * rport->fast_io_fail_tmo * HZ);
+	if (rport->dev_loss_tmo >= 0)
+		queue_delayed_work(system_long_wq, &rport->dev_loss_work,
+				   1UL * rport->dev_loss_tmo * HZ);
+	delay = rport->reconnect_delay;
+	if (delay > 0)
+		queue_delayed_work(system_long_wq, &rport->reconnect_work,
+				   1UL * delay * HZ);
+out_unlock:
+	mutex_unlock(&rport->mutex);
+}
+EXPORT_SYMBOL(srp_start_tl_fail_timers);
+
+/**
+ * srp_timed_out - SRP transport intercept of the SCSI timeout EH
+ *
+ * If a timeout occurs while an rport is in the blocked state, ask the SCSI
+ * EH to continue waiting (BLK_EH_RESET_TIMER). Otherwise let the SCSI core
+ * handle the timeout (BLK_EH_NOT_HANDLED).
+ *
+ * Note: This function is called from soft-IRQ context and with the request
+ * queue lock held.
+ */
+static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
+	return scsi_device_blocked(sdev) ? BLK_EH_RESET_TIMER :
+		BLK_EH_NOT_HANDLED;
+}
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
 
+	cancel_delayed_work_sync(&rport->reconnect_work);
+	cancel_delayed_work_sync(&rport->fast_io_fail_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+
 	put_device(dev->parent);
 	kfree(rport);
 }
@@ -214,12 +670,15 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 {
 	struct srp_rport *rport;
 	struct device *parent = &shost->shost_gendev;
+	struct srp_internal *i = to_srp_internal(shost->transportt);
 	int id, ret;
 
 	rport = kzalloc(sizeof(*rport), GFP_KERNEL);
 	if (!rport)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&rport->mutex);
+
 	device_initialize(&rport->dev);
 
 	rport->dev.parent = get_device(parent);
@@ -228,6 +687,17 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
 	rport->roles = ids->roles;
 
+	if (i->f->reconnect)
+		rport->reconnect_delay = i->f->reconnect_delay ?
+			*i->f->reconnect_delay : 10;
+	INIT_DELAYED_WORK(&rport->reconnect_work, srp_reconnect_work);
+	rport->fast_io_fail_tmo = i->f->fast_io_fail_tmo ?
+		*i->f->fast_io_fail_tmo : 15;
+	rport->dev_loss_tmo = i->f->dev_loss_tmo ? *i->f->dev_loss_tmo : 600;
+	INIT_DELAYED_WORK(&rport->fast_io_fail_work,
+			  rport_fast_io_fail_timedout);
+	INIT_DELAYED_WORK(&rport->dev_loss_work, rport_dev_loss_timedout);
+
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
@@ -277,6 +747,12 @@ void srp_rport_del(struct srp_rport *rport)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
+
+	mutex_lock(&rport->mutex);
+	if (rport->state == SRP_RPORT_BLOCKED)
+		__rport_fast_io_fail_timedout(rport);
+	mutex_unlock(&rport->mutex);
+
 	put_device(dev);
 }
 EXPORT_SYMBOL_GPL(srp_rport_del);
@@ -328,6 +804,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	if (!i)
 		return NULL;
 
+	i->t.eh_timed_out = srp_timed_out;
+
 	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
 	i->t.it_nexus_response = srp_it_nexus_response;
 
@@ -345,6 +823,15 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->has_rport_state) {
+		i->rport_attrs[count++] = &dev_attr_state;
+		i->rport_attrs[count++] = &dev_attr_fast_io_fail_tmo;
+		i->rport_attrs[count++] = &dev_attr_dev_loss_tmo;
+	}
+	if (ft->reconnect) {
+		i->rport_attrs[count++] = &dev_attr_reconnect_delay;
+		i->rport_attrs[count++] = &dev_attr_failed_reconnects;
+	}
 	if (ft->rport_delete)
 		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 5a2d2d1..e077496 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -13,6 +13,18 @@ struct srp_rport_identifiers {
 	u8 roles;
 };
 
+enum srp_rport_state {
+	SRP_RPORT_RUNNING,
+	SRP_RPORT_BLOCKED,
+	SRP_RPORT_FAIL_FAST,
+	SRP_RPORT_LOST,
+};
+
+/**
+ * struct srp_rport
+ * @mutex:   Protects against concurrent rport fast_io_fail / dev_loss_tmo /
+ *   reconnect activity.
+ */
 struct srp_rport {
 	/* for initiator and target drivers */
 
@@ -23,11 +35,27 @@ struct srp_rport {
 
 	/* for initiator drivers */
 
-	void *lld_data;	/* LLD private data */
+	void			*lld_data;	/* LLD private data */
+
+	struct mutex		mutex;
+	enum srp_rport_state	state;
+	int			reconnect_delay;
+	int			failed_reconnects;
+	struct delayed_work	reconnect_work;
+	int			fast_io_fail_tmo;
+	int			dev_loss_tmo;
+	struct delayed_work	fast_io_fail_work;
+	struct delayed_work	dev_loss_work;
 };
 
 struct srp_function_template {
 	/* for initiator drivers */
+	bool has_rport_state;
+	int *reconnect_delay;
+	int *fast_io_fail_tmo;
+	int *dev_loss_tmo;
+	int (*reconnect)(struct srp_rport *rport);
+	void (*terminate_rport_io)(struct srp_rport *rport);
 	void (*rport_delete)(struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
@@ -43,7 +71,29 @@ extern void srp_rport_put(struct srp_rport *rport);
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
-
+extern int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo);
+extern int srp_reconnect_rport(struct srp_rport *rport);
+extern void srp_start_tl_fail_timers(struct srp_rport *rport);
 extern void srp_remove_host(struct Scsi_Host *);
 
+/**
+ * srp_chkready() - evaluate the transport layer state before I/O
+ *
+ * Returns a SCSI result code that can be returned by the LLDD. The role of
+ * this function is similar to that of fc_remote_port_chkready().
+ */
+static inline int srp_chkready(struct srp_rport *rport)
+{
+	switch (rport->state) {
+	case SRP_RPORT_RUNNING:
+	case SRP_RPORT_BLOCKED:
+	default:
+		return 0;
+	case SRP_RPORT_FAIL_FAST:
+		return DID_TRANSPORT_FAILFAST << 16;
+	case SRP_RPORT_LOST:
+		return DID_NO_CONNECT << 16;
+	}
+}
+
 #endif
-- 
1.7.10.4

