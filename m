From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 03/10] scsi_transport_srp: Add transport layer error handling
Date: Sat, 26 Oct 2013 14:33:30 +0200
Message-ID: <526BB69A.7070300@acm.org>
References: <526BB5AC.7010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yahoo.smtp.stone-is.be ([5.134.1.31]:60820 "EHLO
	yahoo.smtp.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3JZMdh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Oct 2013 08:33:37 -0400
In-Reply-To: <526BB5AC.7010601@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@kernel.org>, Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Jack Wang <xjtuwjp@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

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
Acked-by: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Vu Pham <vu@mellanox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 Documentation/ABI/stable/sysfs-transport-srp |  31 ++
 drivers/scsi/scsi_transport_srp.c            | 430 ++++++++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h            |  74 ++++-
 3 files changed, 532 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index b36fb0d..8b6acc7 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -5,6 +5,24 @@ Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
 Description:	Instructs an SRP initiator to disconnect from a target and to
 		remove all LUNs imported from that target.
 
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
+Date:		February 1, 2014
+KernelVersion:	3.13
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before removing a target port.
+		Zero means immediate removal. Setting this attribute to "off"
+		will disable the dev_loss timer.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/fast_io_fail_tmo
+Date:		February 1, 2014
+KernelVersion:	3.13
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before failing I/O. Zero means
+		failing I/O immediately. Setting this attribute to "off" will
+		disable the fast_io_fail timer.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
@@ -17,3 +35,16 @@ Date:		June 27, 2007
 KernelVersion:	2.6.24
 Contact:	linux-scsi@vger.kernel.org
 Description:	Role of the remote port. Either "SRP Initiator" or "SRP Target".
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/state
+Date:		February 1, 2014
+KernelVersion:	3.13
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	State of the transport layer used for communication with the
+		remote port. "running" if the transport layer is operational;
+		"blocked" if a transport layer error has been encountered but
+		the fast_io_fail_tmo timer has not yet fired; "fail-fast"
+		after the fast_io_fail_tmo timer has fired and before the
+		"dev_loss_tmo" timer has fired; "lost" after the
+		"dev_loss_tmo" timer has fired and before the port is finally
+		removed.
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index f7ba94a..2696e26 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -24,12 +24,15 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
+#include "scsi_priv.h"
 #include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
@@ -38,7 +41,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 3
+#define SRP_RPORT_ATTRS 6
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -54,6 +57,34 @@ struct srp_internal {
 
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
+ * The combination of the timeout parameters must be such that SCSI commands
+ * are finished in a reasonable time. Hence do not allow the fast I/O fail
+ * timeout to exceed SCSI_DEVICE_BLOCK_MAX_TIMEOUT. Furthermore, these
+ * parameters must be such that multipath can detect failed paths timely.
+ * Hence do not allow both parameters to be disabled simultaneously.
+ */
+int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
+{
+	if (fast_io_fail_tmo < 0 && dev_loss_tmo < 0)
+		return -EINVAL;
+	if (fast_io_fail_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+	if (dev_loss_tmo >= LONG_MAX / HZ)
+		return -EINVAL;
+	if (fast_io_fail_tmo >= 0 && dev_loss_tmo >= 0 &&
+	    fast_io_fail_tmo >= dev_loss_tmo)
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(srp_tmo_valid);
 
 static int srp_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
@@ -134,10 +165,383 @@ static ssize_t store_srp_rport_delete(struct device *dev,
 
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
+static ssize_t srp_show_tmo(char *buf, int tmo)
+{
+	return tmo >= 0 ? sprintf(buf, "%d\n", tmo) : sprintf(buf, "off\n");
+}
+
+static int srp_parse_tmo(int *tmo, const char *buf)
+{
+	int res = 0;
+
+	if (strncmp(buf, "off", 3) != 0)
+		res = kstrtoint(buf, 0, tmo);
+	else
+		*tmo = -1;
+
+	return res;
+}
+
+static ssize_t show_srp_rport_fast_io_fail_tmo(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return srp_show_tmo(buf, rport->fast_io_fail_tmo);
+}
+
+static ssize_t store_srp_rport_fast_io_fail_tmo(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	int res;
+	int fast_io_fail_tmo;
+
+	res = srp_parse_tmo(&fast_io_fail_tmo, buf);
+	if (res)
+		goto out;
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
+	return srp_show_tmo(buf, rport->dev_loss_tmo);
+}
+
+static ssize_t store_srp_rport_dev_loss_tmo(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	int res;
+	int dev_loss_tmo;
+
+	res = srp_parse_tmo(&dev_loss_tmo, buf);
+	if (res)
+		goto out;
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
+static void __rport_fail_io_fast(struct srp_rport *rport)
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
+	/* Involve the LLD if possible to terminate all I/O on the rport. */
+	i = to_srp_internal(shost->transportt);
+	if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+}
+
+/**
+ * rport_fast_io_fail_timedout() - fast I/O failure timeout handler
+ */
+static void rport_fast_io_fail_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport = container_of(to_delayed_work(work),
+					struct srp_rport, fast_io_fail_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
+	pr_info("fast_io_fail_tmo expired for SRP %s / %s.\n",
+		dev_name(&rport->dev), dev_name(&shost->shost_gendev));
+
+	mutex_lock(&rport->mutex);
+	if (rport->state == SRP_RPORT_BLOCKED)
+		__rport_fail_io_fast(rport);
+	mutex_unlock(&rport->mutex);
+}
+
+/**
+ * rport_dev_loss_timedout() - device loss timeout handler
+ */
+static void rport_dev_loss_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport = container_of(to_delayed_work(work),
+					struct srp_rport, dev_loss_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+
+	pr_info("dev_loss_tmo expired for SRP %s / %s.\n",
+		dev_name(&rport->dev), dev_name(&shost->shost_gendev));
+
+	mutex_lock(&rport->mutex);
+	WARN_ON(srp_rport_set_state(rport, SRP_RPORT_LOST) != 0);
+	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
+	mutex_unlock(&rport->mutex);
+
+	i->f->rport_delete(rport);
+}
+
+static void __srp_start_tl_fail_timers(struct srp_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	int fast_io_fail_tmo, dev_loss_tmo;
+
+	lockdep_assert_held(&rport->mutex);
+
+	if (!rport->deleted) {
+		fast_io_fail_tmo = rport->fast_io_fail_tmo;
+		dev_loss_tmo = rport->dev_loss_tmo;
+		pr_debug("%s current state: %d\n",
+			 dev_name(&shost->shost_gendev), rport->state);
+
+		if (fast_io_fail_tmo >= 0 &&
+		    srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
+			pr_debug("%s new state: %d\n",
+				 dev_name(&shost->shost_gendev),
+				 rport->state);
+			scsi_target_block(&shost->shost_gendev);
+			queue_delayed_work(system_long_wq,
+					   &rport->fast_io_fail_work,
+					   1UL * fast_io_fail_tmo * HZ);
+		}
+		if (dev_loss_tmo >= 0)
+			queue_delayed_work(system_long_wq,
+					   &rport->dev_loss_work,
+					   1UL * dev_loss_tmo * HZ);
+	} else {
+		pr_debug("%s has already been deleted\n",
+			 dev_name(&shost->shost_gendev));
+		srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST);
+		scsi_target_unblock(&shost->shost_gendev,
+				    SDEV_TRANSPORT_OFFLINE);
+	}
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
+	mutex_lock(&rport->mutex);
+	__srp_start_tl_fail_timers(rport);
+	mutex_unlock(&rport->mutex);
+}
+EXPORT_SYMBOL(srp_start_tl_fail_timers);
+
+/**
+ * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
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
+ * srp_reconnect_rport() - reconnect to an SRP target port
+ *
+ * Blocks SCSI command queueing before invoking reconnect() such that
+ * queuecommand() won't be invoked concurrently with reconnect() from outside
+ * the SCSI EH. This is important since a reconnect() implementation may
+ * reallocate resources needed by queuecommand().
+ *
+ * Notes:
+ * - This function neither waits until outstanding requests have finished nor
+ *   tries to abort these. It is the responsibility of the reconnect()
+ *   function to finish outstanding commands before reconnecting to the target
+ *   port.
+ * - It is the responsibility of the caller to ensure that the resources
+ *   reallocated by the reconnect() function won't be used while this function
+ *   is in progress. One possible strategy is to invoke this function from
+ *   the context of the SCSI EH thread only. Another possible strategy is to
+ *   lock the rport mutex inside each SCSI LLD callback that can be invoked by
+ *   the SCSI EH (the scsi_host_template.eh_*() functions and also the
+ *   scsi_host_template.queuecommand() function).
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
+	if (res)
+		goto out;
+	scsi_target_block(&shost->shost_gendev);
+	while (scsi_request_fn_active(shost))
+		msleep(20);
+	res = i->f->reconnect(rport);
+	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
+		 dev_name(&shost->shost_gendev), rport->state, res);
+	if (res == 0) {
+		cancel_delayed_work(&rport->fast_io_fail_work);
+		cancel_delayed_work(&rport->dev_loss_work);
+
+		srp_rport_set_state(rport, SRP_RPORT_RUNNING);
+		scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
+		/*
+		 * If the SCSI error handler has offlined one or more devices,
+		 * invoking scsi_target_unblock() won't change the state of
+		 * these devices into running so do that explicitly.
+		 */
+		spin_lock_irq(shost->host_lock);
+		__shost_for_each_device(sdev, shost)
+			if (sdev->sdev_state == SDEV_OFFLINE)
+				sdev->sdev_state = SDEV_RUNNING;
+		spin_unlock_irq(shost->host_lock);
+	} else if (rport->state == SRP_RPORT_RUNNING) {
+		/*
+		 * srp_reconnect_rport() was invoked with fast_io_fail
+		 * off. Mark the port as failed and start the TL failure
+		 * timers if these had not yet been started.
+		 */
+		__rport_fail_io_fast(rport);
+		scsi_target_unblock(&shost->shost_gendev,
+				    SDEV_TRANSPORT_OFFLINE);
+		__srp_start_tl_fail_timers(rport);
+	} else if (rport->state != SRP_RPORT_BLOCKED) {
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
+/**
+ * srp_timed_out() - SRP transport intercept of the SCSI timeout EH
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
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+
+	pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
+	return i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
+		BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
+}
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
 
+	cancel_delayed_work_sync(&rport->fast_io_fail_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+
 	put_device(dev->parent);
 	kfree(rport);
 }
@@ -214,12 +618,15 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
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
@@ -228,6 +635,13 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
 	rport->roles = ids->roles;
 
+	rport->fast_io_fail_tmo = i->f->fast_io_fail_tmo ?
+		*i->f->fast_io_fail_tmo : 15;
+	rport->dev_loss_tmo = i->f->dev_loss_tmo ? *i->f->dev_loss_tmo : 60;
+	INIT_DELAYED_WORK(&rport->fast_io_fail_work,
+			  rport_fast_io_fail_timedout);
+	INIT_DELAYED_WORK(&rport->dev_loss_work, rport_dev_loss_timedout);
+
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
@@ -277,6 +691,13 @@ void srp_rport_del(struct srp_rport *rport)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
+
+	mutex_lock(&rport->mutex);
+	if (rport->state == SRP_RPORT_BLOCKED)
+		__rport_fail_io_fast(rport);
+	rport->deleted = true;
+	mutex_unlock(&rport->mutex);
+
 	put_device(dev);
 }
 EXPORT_SYMBOL_GPL(srp_rport_del);
@@ -328,6 +749,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	if (!i)
 		return NULL;
 
+	i->t.eh_timed_out = srp_timed_out;
+
 	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
 	i->t.it_nexus_response = srp_it_nexus_response;
 
@@ -345,6 +768,11 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->has_rport_state) {
+		i->rport_attrs[count++] = &dev_attr_state;
+		i->rport_attrs[count++] = &dev_attr_fast_io_fail_tmo;
+		i->rport_attrs[count++] = &dev_attr_dev_loss_tmo;
+	}
 	if (ft->rport_delete)
 		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 5a2d2d1..ee70016 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -13,6 +13,26 @@ struct srp_rport_identifiers {
 	u8 roles;
 };
 
+/**
+ * enum srp_rport_state - SRP transport layer state
+ * @SRP_RPORT_RUNNING:   Transport layer operational.
+ * @SRP_RPORT_BLOCKED:   Transport layer not operational; fast I/O fail timer
+ *                       is running and I/O has been blocked.
+ * @SRP_RPORT_FAIL_FAST: Fast I/O fail timer has expired; fail I/O fast.
+ * @SRP_RPORT_LOST:      Device loss timer has expired; port is being removed.
+ */
+enum srp_rport_state {
+	SRP_RPORT_RUNNING,
+	SRP_RPORT_BLOCKED,
+	SRP_RPORT_FAIL_FAST,
+	SRP_RPORT_LOST,
+};
+
+/**
+ * struct srp_rport
+ * @lld_data: LLD private data.
+ * @mutex:    Protects against concurrent rport fast_io_fail / dev_loss_tmo.
+ */
 struct srp_rport {
 	/* for initiator and target drivers */
 
@@ -23,11 +43,38 @@ struct srp_rport {
 
 	/* for initiator drivers */
 
-	void *lld_data;	/* LLD private data */
+	void			*lld_data;
+
+	struct mutex		mutex;
+	enum srp_rport_state	state;
+	bool			deleted;
+	int			fast_io_fail_tmo;
+	int			dev_loss_tmo;
+	struct delayed_work	fast_io_fail_work;
+	struct delayed_work	dev_loss_work;
 };
 
+/**
+ * struct srp_function_template
+ * @has_rport_state: Whether or not to create the state, fast_io_fail_tmo and
+ *     dev_loss_tmo sysfs attribute for an rport.
+ * @reset_timer_if_blocked: Whether or srp_timed_out() should reset the command
+ *     timer if the device on which it has been queued is blocked.
+ * @fast_io_fail_tmo: If not NULL, points to the default fast_io_fail_tmo value.
+ * @dev_loss_tmo: If not NULL, points to the default dev_loss_tmo value.
+ * @reconnect: Callback function for reconnecting to the target. See also
+ *     srp_reconnect_rport().
+ * @terminate_rport_io: Callback function for terminating all outstanding I/O
+ *     requests for an rport.
+ */
 struct srp_function_template {
 	/* for initiator drivers */
+	bool has_rport_state;
+	bool reset_timer_if_blocked;
+	int *fast_io_fail_tmo;
+	int *dev_loss_tmo;
+	int (*reconnect)(struct srp_rport *rport);
+	void (*terminate_rport_io)(struct srp_rport *rport);
 	void (*rport_delete)(struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
@@ -43,7 +90,30 @@ extern void srp_rport_put(struct srp_rport *rport);
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
+ * Returns a SCSI result code that can be returned by the LLD queuecommand()
+ * implementation. The role of this function is similar to that of
+ * fc_remote_port_chkready().
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
1.8.1.4

