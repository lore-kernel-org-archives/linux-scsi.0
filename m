From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 17/18] srp_transport: Add transport layer recovery support
Date: Sat, 14 Jan 2012 12:56:13 +0000
Message-ID: <2536946.Diyz1JQnfo@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:47149 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2ANNFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 08:05:05 -0500
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, dillowda@ornl.gov

Add the necessary functions in the SRP transport module to allow
an SRP initiator driver to implement transport layer recovery.
This includes:
- A ping mechanism to check whether the transport layer is still
  operational.
- Support for implementing fast_io_fail_tmo, the time that should
  elapse after having detected a transport layer problem and
  before failing I/O.
- Support for implementing dev_loss_tmo, the time that should
  elapse after having detected a transport layer problem and
  before removing a remote port.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: David Dillow <dillowda@ornl.gov>
---
 drivers/scsi/scsi_transport_srp.c |  430 ++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h |   33 +++
 2 files changed, 462 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 35f85bc..a7628c9 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -2,6 +2,7 @@
  * SCSI RDMA (SRP) transport class
  *
  * Copyright (C) 2007 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2011 Bart Van Assche <bvanassche@acm.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -28,8 +29,10 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
+#include "scsi_priv.h"
 #include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
@@ -38,7 +41,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 3
+#define SRP_RPORT_ATTRS 7
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -132,6 +135,415 @@ static ssize_t store_srp_rport_delete(struct device *dev,
 
 static DEVICE_ATTR(delete, S_IWUSR, NULL, store_srp_rport_delete);
 
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
+	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &ping_itv);
+	if (res)
+		goto out;
+	res = -EINVAL;
+	if (ping_itv > ULONG_MAX / HZ)
+		goto out;
+	rport->ping_itv = ping_itv;
+	if (ping_itv > 0)
+		queue_delayed_work(system_long_wq, &rport->ping_work,
+				   1UL * ping_itv * HZ);
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
+	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &rport->ping_tmo);
+	return res == 0 ? count : res;
+}
+
+static DEVICE_ATTR(ping_timeout, S_IRUGO | S_IWUSR, show_srp_rport_ping_timeout,
+		   store_srp_rport_ping_timeout);
+
+/**
+ * srp_tmo_valid() - Check timeout combination validity.
+ *
+ * If no fast I/O fail timeout has been configured then the device loss timeout
+ * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O fail timeout has
+ * been configured then it must be below the device loss timeout.
+ */
+static int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
+{
+	return (fast_io_fail_tmo < 0 &&
+		0 <= dev_loss_tmo &&
+		dev_loss_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		|| (0 <= fast_io_fail_tmo &&
+		    fast_io_fail_tmo < dev_loss_tmo &&
+		    dev_loss_tmo < ULONG_MAX / HZ) ? 0 : -EINVAL;
+}
+
+static ssize_t show_srp_rport_fast_io_fail_tmo(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
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
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res;
+	int fast_io_fail_tmo;
+
+	if (count >= 3 && memcmp(buf, "off", 3) == 0) {
+		fast_io_fail_tmo = -1;
+	} else {
+		sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+		res = kstrtoint(ch, 0, &fast_io_fail_tmo);
+		if (res)
+			goto out;
+	}
+	res = srp_tmo_valid(fast_io_fail_tmo, rport->dev_loss_tmo);
+	if (res)
+		goto out;
+	rport->fast_io_fail_tmo = fast_io_fail_tmo;
+	if (rport->state == SRP_RPORT_BLOCKED)
+		srp_start_tl_fail_timers(rport);
+	res = count;
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
+	return sprintf(buf, "%d\n", rport->dev_loss_tmo);
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
+	res = kstrtoint(ch, 0, &dev_loss_tmo);
+	if (res)
+		goto out;
+	res = srp_tmo_valid(rport->fast_io_fail_tmo, dev_loss_tmo);
+	if (res)
+		goto out;
+	rport->dev_loss_tmo = dev_loss_tmo;
+	if (rport->state == SRP_RPORT_BLOCKED)
+		srp_start_tl_fail_timers(rport);
+	res = count;
+out:
+	return res;
+}
+
+static DEVICE_ATTR(dev_loss_tmo, S_IRUGO | S_IWUSR,
+		   show_srp_rport_dev_loss_tmo,
+		   store_srp_rport_dev_loss_tmo);
+
+static bool srp_unblock_rport(struct srp_rport *rport)
+{
+	unsigned long flags;
+	enum srp_rport_state prev_state;
+	bool unblock;
+
+	spin_lock_irqsave(&rport->lock, flags);
+	prev_state = rport->state;
+	if (prev_state == SRP_RPORT_BLOCKED) {
+		rport->state = SRP_RPORT_LIVE;
+		unblock = true;
+	}
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	if (unblock) {
+		dev_info(&rport->dev, "unblocked SRP rport\n");
+		scsi_target_unblock(rport->dev.parent);
+	}
+
+	return unblock;
+}
+
+/**
+ * rport_fast_io_fail_timedout() - Fast I/O failure timeout handler.
+ *
+ * Unblocks the SCSI host.
+ */
+static void rport_fast_io_fail_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport;
+
+	rport = container_of(to_delayed_work(work), struct srp_rport,
+			     fast_io_fail_work);
+
+	pr_err("SRP transport: fast_io_fail_tmo (%ds) expired - unblocking %s.\n",
+	       rport->fast_io_fail_tmo, dev_name(&rport->dev));
+
+	BUG_ON(!rport->ft);
+
+	/* Involve the LLDD if possible to terminate all io on the rport. */
+	if (rport->ft->terminate_rport_io)
+		rport->ft->terminate_rport_io(rport);
+
+	srp_unblock_rport(rport);
+}
+
+/**
+ * rport_dev_loss_timedout() - Device loss timeout handler.
+ *
+ * Note: rport->ft->rport_delete must either unblock the SCSI host or schedule
+ * SCSI host removal.
+ */
+static void rport_dev_loss_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport;
+
+	rport = container_of(to_delayed_work(work), struct srp_rport,
+			     dev_loss_work);
+
+	pr_err("SRP transport: dev_loss_tmo (%ds) expired - removing %s.\n",
+	       rport->dev_loss_tmo, dev_name(&rport->dev));
+
+	BUG_ON(!rport->ft);
+	BUG_ON(!rport->ft->rport_delete);
+
+	rport->ft->rport_delete(rport);
+}
+
+/**
+ * srp_resume_io() - Unblock an rport and cancel the failure timers.
+ */
+void srp_resume_io(struct srp_rport *rport)
+{
+	unsigned long flags;
+
+	if (!srp_unblock_rport(rport))
+		return;
+
+	spin_lock_irqsave(&rport->lock, flags);
+	rport->latest_ping_response = jiffies;
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	cancel_delayed_work(&rport->fast_io_fail_work);
+	cancel_delayed_work(&rport->dev_loss_work);
+}
+EXPORT_SYMBOL(srp_resume_io);
+
+/**
+ * srp_block_rport() - Block an rport.
+ */
+void srp_block_rport(struct srp_rport *rport)
+{
+	unsigned long flags;
+	bool block = false;
+
+	spin_lock_irqsave(&rport->lock, flags);
+	if (rport->state == SRP_RPORT_LIVE) {
+		rport->state = SRP_RPORT_BLOCKED;
+		block = true;
+	}
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	if (block) {
+		dev_info(&rport->dev, "blocked SRP rport\n");
+		scsi_target_block(rport->dev.parent);
+	}
+}
+EXPORT_SYMBOL(srp_block_rport);
+
+/**
+ * srp_start_tl_fail_timers() - Start the transport layer failure timers.
+ *
+ * Start the transport layer fast I/O failure and device loss timers. Do not
+ * modify a timer that was already started.
+ */
+void srp_start_tl_fail_timers(struct srp_rport *rport)
+{
+	if (rport->fast_io_fail_tmo >= 0)
+		queue_delayed_work(system_long_wq, &rport->fast_io_fail_work,
+				   1UL * rport->fast_io_fail_tmo * HZ);
+	WARN_ON(rport->dev_loss_tmo < 0);
+	queue_delayed_work(system_long_wq, &rport->dev_loss_work,
+			   1UL * rport->dev_loss_tmo * HZ);
+}
+EXPORT_SYMBOL(srp_start_tl_fail_timers);
+
+/**
+ * srp_rport_disable_ping() - Stop pinging and prevent reenabling pinging.
+ */
+void srp_rport_disable_ping(struct srp_rport *rport)
+{
+	struct device *dev = rport->dev.parent;
+	struct Scsi_Host *shost = dev ? dev_to_shost(dev) : NULL;
+
+	if (dev) {
+		WARN_ON(!shost);
+		if (shost)
+			WARN_ON(shost->host_self_blocked);
+	}
+	device_remove_file(dev, &dev_attr_ping_timeout);
+	device_remove_file(dev, &dev_attr_ping_interval);
+	cancel_delayed_work_sync(&rport->ping_work);
+}
+EXPORT_SYMBOL(srp_rport_disable_ping);
+
+/**
+ * srp_disable_tl_fail_timers() - Disable the transport layer failure timers.
+ */
+void srp_disable_tl_fail_timers(struct srp_rport *rport)
+{
+	struct device *dev = rport->dev.parent;
+
+	device_remove_file(dev, &dev_attr_fast_io_fail_tmo);
+	device_remove_file(dev, &dev_attr_dev_loss_tmo);
+	cancel_delayed_work_sync(&rport->fast_io_fail_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+}
+EXPORT_SYMBOL(srp_disable_tl_fail_timers);
+
+/**
+ * srp_stop_rport() - Stop asynchronous work for an rport.
+ */
+void srp_stop_rport(struct srp_rport *rport)
+{
+	srp_rport_disable_ping(rport);
+	srp_disable_tl_fail_timers(rport);
+}
+EXPORT_SYMBOL(srp_stop_rport);
+
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
+ * srp_rport_get_sdev() - Get the SCSI device to be used for pinging.
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
@@ -208,6 +620,15 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
 	rport->roles = ids->roles;
 
+	rport->fast_io_fail_tmo = -1;
+	rport->dev_loss_tmo = 60;
+	INIT_DELAYED_WORK(&rport->ping_work, rport_ping);
+	INIT_DELAYED_WORK(&rport->fast_io_fail_work,
+			  rport_fast_io_fail_timedout);
+	INIT_DELAYED_WORK(&rport->dev_loss_work, rport_dev_loss_timedout);
+	spin_lock_init(&rport->lock);
+	rport->state = SRP_RPORT_LIVE;
+
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
@@ -325,6 +746,13 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->rport_ping_timedout) {
+		i->rport_attrs[count++] = &dev_attr_ping_interval;
+		i->rport_attrs[count++] = &dev_attr_ping_timeout;
+		i->rport_attrs[count++] = &dev_attr_fast_io_fail_tmo;
+		if (ft->rport_delete)
+			i->rport_attrs[count++] = &dev_attr_dev_loss_tmo;
+	}
 	if (ft->rport_delete)
 		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 1a109ff..896b490 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -8,6 +8,16 @@
 #define SRP_RPORT_ROLE_INITIATOR 0
 #define SRP_RPORT_ROLE_TARGET 1
 
+/**
+ * enum srp_rport_state - Rport state.
+ * SRP_RPORT_LIVE: SCSI host logged in.
+ * SRP_RPORT_BLOCKED: SCSI host blocked because of a transport layer issue.
+ */
+enum srp_rport_state {
+	SRP_RPORT_LIVE,
+	SRP_RPORT_BLOCKED,
+};
+
 struct srp_rport_identifiers {
 	u8 port_id[16];
 	u8 roles;
@@ -26,10 +36,25 @@ struct srp_rport {
 	/* for initiator drivers */
 
 	void			*lld_data;	/* LLD private data */
+
+	spinlock_t		lock;
+	struct scsi_device	*sdev;
+	enum srp_rport_state	state;
+
+	int			ping_itv;
+	int			ping_tmo;
+	unsigned long		latest_ping_response;
+	int			fast_io_fail_tmo;
+	int			dev_loss_tmo;
+	struct delayed_work	ping_work;
+	struct delayed_work	fast_io_fail_work;
+	struct delayed_work	dev_loss_work;
 };
 
 struct srp_function_template {
 	/* for initiator drivers */
+	void (*rport_ping_timedout) (struct srp_rport *rport);
+	void (*terminate_rport_io)(struct srp_rport *rport);
 	void (*rport_delete)(struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
@@ -43,6 +68,14 @@ extern void srp_release_transport(struct scsi_transport_template *);
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
+extern void srp_resume_io(struct srp_rport *rport);
+extern void srp_block_rport(struct srp_rport *rport);
+extern void srp_start_tl_fail_timers(struct srp_rport *rport);
+extern void srp_rport_set_sdev(struct srp_rport *rport,
+			       struct scsi_device *sdev);
+extern void srp_rport_disable_ping(struct srp_rport *rport);
+extern void srp_disable_tl_fail_timers(struct srp_rport *rport);
+extern void srp_stop_rport(struct srp_rport *rport);
 
 extern void srp_remove_host(struct Scsi_Host *);
 
-- 
1.7.7


