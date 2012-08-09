From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 19/20] srp_transport: Add transport layer error handling
Date: Thu, 09 Aug 2012 16:02:45 +0000
Message-ID: <5023DF25.8010401@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add the necessary functions in the SRP transport module to allow
an SRP initiator driver to implement transport error handling.
This includes:
- Support for implementing fast_io_fail_tmo, the time that should
  elapse after having detected a transport layer problem and
  before failing I/O.
- Support for implementing dev_loss_tmo, the time that should
  elapse after having detected a transport layer problem and
  before removing a remote port.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |   17 +++
 drivers/scsi/scsi_transport_srp.c            |  199 +++++++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h            |   11 ++-
 3 files changed, 224 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index b36fb0d..2f14a5b 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -5,6 +5,23 @@ Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Instructs an SRP initiator to disconnect from a target and to
 		remove all LUNs imported from that target.
 
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
+Date:		January 1, 2012
+KernelVersion:	3.7
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before removing a target port.
+		Zero means immediate removal.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/fast_io_fail_tmo
+Date:		January 1, 2012
+KernelVersion:	3.7
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before failing I/O. Zero means
+		immediate removal. A negative value will disable this
+		behavior.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index f379c7f..965a91f 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -2,6 +2,7 @@
  * SCSI RDMA (SRP) transport class
  *
  * Copyright (C) 2007 FUJITA Tomonori <tomof-HInyCGIudOg@public.gmane.org>
+ * Copyright (C) 2012 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -30,6 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
+#include "scsi_priv.h"
 #include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
@@ -38,7 +40,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 3
+#define SRP_RPORT_ATTRS 5
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -54,6 +56,10 @@ struct srp_internal {
 
 #define	dev_to_rport(d)	container_of(d, struct srp_rport, dev)
 #define transport_class_to_srp_rport(dev) dev_to_rport((dev)->parent)
+static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
+{
+	return dev_to_shost(r->dev.parent);
+}
 
 static int srp_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
@@ -134,6 +140,186 @@ static ssize_t store_srp_rport_delete(struct device *dev,
 
 static DEVICE_ATTR(delete, S_IWUSR, NULL, store_srp_rport_delete);
 
+/**
+ * srp_tmo_valid() - Check timeout combination validity.
+ *
+ * If no fast I/O fail timeout has been configured then the device loss timeout
+ * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O fail timeout has
+ * been configured then it must be below the device loss timeout.
+ */
+static int srp_tmo_valid(int fast_io_fail_tmo, unsigned dev_loss_tmo)
+{
+	return (fast_io_fail_tmo < 0 &&
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
+	return sprintf(buf, "%u\n", rport->dev_loss_tmo);
+}
+
+static ssize_t store_srp_rport_dev_loss_tmo(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res;
+	unsigned dev_loss_tmo;
+
+	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
+	res = kstrtouint(ch, 0, &dev_loss_tmo);
+	if (res)
+		goto out;
+	res = srp_tmo_valid(rport->fast_io_fail_tmo, dev_loss_tmo);
+	if (res)
+		goto out;
+	rport->dev_loss_tmo = dev_loss_tmo;
+	res = count;
+out:
+	return res;
+}
+
+static DEVICE_ATTR(dev_loss_tmo, S_IRUGO | S_IWUSR,
+		   show_srp_rport_dev_loss_tmo,
+		   store_srp_rport_dev_loss_tmo);
+
+/**
+ * rport_fast_io_fail_timedout() - Fast I/O failure timeout handler.
+ *
+ * Unblocks the SCSI host.
+ */
+static void rport_fast_io_fail_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport =
+		container_of(to_delayed_work(work), struct srp_rport,
+			     fast_io_fail_work);
+	struct Scsi_Host *shost;
+	struct srp_internal *i;
+
+	pr_err("SRP transport: fast_io_fail_tmo (%ds) expired - unblocking %s.\n",
+	       rport->fast_io_fail_tmo, dev_name(&rport->dev));
+
+	shost = rport_to_shost(rport);
+	i = to_srp_internal(shost->transportt);
+	/* Involve the LLDD if possible to terminate all io on the rport. */
+	if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+
+	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
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
+	struct srp_rport *rport =
+		container_of(to_delayed_work(work), struct srp_rport,
+			     fast_io_fail_work);
+	struct Scsi_Host *shost;
+	struct srp_internal *i;
+
+	pr_err("SRP transport: dev_loss_tmo (%ds) expired - removing %s.\n",
+	       rport->dev_loss_tmo, dev_name(&rport->dev));
+
+	shost = rport_to_shost(rport);
+	i = to_srp_internal(shost->transportt);
+	BUG_ON(!i->f);
+	BUG_ON(!i->f->rport_delete);
+
+	i->f->rport_delete(rport);
+}
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
+	queue_delayed_work(system_long_wq, &rport->dev_loss_work,
+			   1UL * rport->dev_loss_tmo * HZ);
+}
+EXPORT_SYMBOL(srp_start_tl_fail_timers);
+
+void srp_stop_tl_fail_timers(struct srp_rport *rport)
+{
+	cancel_delayed_work_sync(&rport->fast_io_fail_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+}
+EXPORT_SYMBOL(srp_stop_tl_fail_timers);
+
+/**
+ * srp_stop_rport() - Stop asynchronous work for an rport.
+ */
+void srp_stop_rport(struct srp_rport *rport)
+{
+	struct device *dev = rport->dev.parent;
+
+	device_remove_file(dev, &dev_attr_fast_io_fail_tmo);
+	device_remove_file(dev, &dev_attr_dev_loss_tmo);
+	srp_stop_tl_fail_timers(rport);
+	scsi_target_unblock(rport->dev.parent, SDEV_RUNNING);
+}
+EXPORT_SYMBOL(srp_stop_rport);
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -210,6 +396,12 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
 	rport->roles = ids->roles;
 
+	rport->fast_io_fail_tmo = -1;
+	rport->dev_loss_tmo = 60;
+	INIT_DELAYED_WORK(&rport->fast_io_fail_work,
+			  rport_fast_io_fail_timedout);
+	INIT_DELAYED_WORK(&rport->dev_loss_work, rport_dev_loss_timedout);
+
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
@@ -327,8 +519,11 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
-	if (ft->rport_delete)
+	if (ft->rport_delete) {
+		i->rport_attrs[count++] = &dev_attr_dev_loss_tmo;
+		i->rport_attrs[count++] = &dev_attr_fast_io_fail_tmo;
 		i->rport_attrs[count++] = &dev_attr_delete;
+	}
 	i->rport_attrs[count++] = NULL;
 	BUG_ON(count > ARRAY_SIZE(i->rport_attrs));
 
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index ff0f04a..170bace 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -23,11 +23,17 @@ struct srp_rport {
 
 	/* for initiator drivers */
 
-	void *lld_data;	/* LLD private data */
+	void			*lld_data;	/* LLD private data */
+
+	int			fast_io_fail_tmo;
+	unsigned		dev_loss_tmo;
+	struct delayed_work	fast_io_fail_work;
+	struct delayed_work	dev_loss_work;
 };
 
 struct srp_function_template {
 	/* for initiator drivers */
+	void (*terminate_rport_io)(struct srp_rport *rport);
 	void (*rport_delete)(struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
@@ -41,6 +47,9 @@ extern void srp_release_transport(struct scsi_transport_template *);
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
+extern void srp_start_tl_fail_timers(struct srp_rport *rport);
+extern void srp_stop_tl_fail_timers(struct srp_rport *rport);
+extern void srp_stop_rport(struct srp_rport *rport);
 
 extern void srp_remove_host(struct Scsi_Host *);
 
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
