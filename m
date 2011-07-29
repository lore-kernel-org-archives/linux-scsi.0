From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 6/7] FC Transport: Add API for LLDs to add FC port and FC
 fabric devices
Date: Fri, 29 Jul 2011 16:38:54 -0700
Message-ID: <20110729233854.12794.71997.stgit@localhost6.localdomain6>
References: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47663 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1G2Xiz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 19:38:55 -0400
In-Reply-To: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, giridhar.malavali@qlogic.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: neerav.parikh@intel.com

This patch extends the FC Transport API to LLDs to allow
them to create FC Port and FC Fabric devices that will be
represented in sysfs.

The FC Port device is intended to contain attributes describing
FC/FCoE properties of the physical port.

The FC Fabric device is intended to contain attributes describing
FC/FCoE properties of a FC switch or FCoE switch. The term "fabric"
is used very loosly.

The Attribute Container code is used to create these new devices
and their attributes and these extensions should be in line with
the other classes of devices defined by the FC Transport.

Notes:

The FC Port is 1:1 with the FC Host. This begs the question if
the FC Port is necessary or if those attributes should simply
be added to the FC Host.

Temporary fabric's are needed when calling fc_fabric_add so that
the FC Transport can look for duplicates in its list of fabrics.
A match routine can be provided by the LLD to compare fabrics. An
FCoE LLD may have differen criteria to match FCFs than a purely
FC LLD would. This can all be up-leveled to the FC Transport if
we want different selection modes at that layer.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/scsi_transport_fc.c |  578 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_fc.h |  150 ++++++++++
 2 files changed, 719 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1b21491..ce5849c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -314,6 +314,8 @@ static void fc_scsi_scan_rport(struct work_struct *work);
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
 #define FC_HOST_NUM_ATTRS	22
+#define FC_PORT_NUM_ATTRS       1
+#define FC_FABRIC_NUM_ATTRS     1
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -326,9 +328,18 @@ struct fc_internal {
 	 *     structures - used for mid-layer interaction.
 	 *
 	 * The attribute containers for the starget and host are are
-	 * part of the midlayer. As the remote port is specific to the
-	 * fc transport, we must provide the attribute container.
+	 * part of the midlayer. As the FC port, FC fabrics and
+	 * remote ports are specific to the fc transport, we must
+	 * provide the attribute container.
 	 */
+	struct transport_container port_attr_cont;
+	struct device_attribute private_port_attrs[FC_PORT_NUM_ATTRS];
+	struct device_attribute *port_attrs[FC_PORT_NUM_ATTRS + 1];
+
+	struct transport_container fabric_attr_cont;
+	struct device_attribute private_fabric_attrs[FC_FABRIC_NUM_ATTRS];
+	struct device_attribute *fabric_attrs[FC_FABRIC_NUM_ATTRS + 1];
+
 	struct device_attribute private_starget_attrs[
 							FC_STARGET_NUM_ATTRS];
 	struct device_attribute *starget_attrs[FC_STARGET_NUM_ATTRS + 1];
@@ -415,6 +426,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	INIT_LIST_HEAD(&fc_host->rports);
 	INIT_LIST_HEAD(&fc_host->rport_bindings);
 	INIT_LIST_HEAD(&fc_host->vports);
+	INIT_LIST_HEAD(&fc_host->fabrics);
 	fc_host->next_rport_number = 0;
 	fc_host->next_target_id = 0;
 	fc_host->next_vport_number = 0;
@@ -480,6 +492,72 @@ static DECLARE_TRANSPORT_CLASS(fc_vport_class,
 			       NULL,
 			       NULL);
 
+static DECLARE_TRANSPORT_CLASS(fc_port_class,
+			       "fc_port",
+			       NULL,
+			       NULL,
+			       NULL);
+
+static DECLARE_TRANSPORT_CLASS(fc_fabric_class,
+			       "fc_fabric",
+			       NULL,
+			       NULL,
+			       NULL);
+
+#define fc_private_port_show_function(field, format_string, sz, cast)	\
+static ssize_t								\
+show_fc_port_##field(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct fc_port *port = transport_class_to_port(dev);		\
+	return snprintf(buf, sz, format_string, cast port->field);	\
+}
+
+#define fc_private_port_rd_attr(field, format_string, sz)		\
+	fc_private_port_show_function(field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(port, field, S_IRUGO,			\
+		      show_fc_port_##field, NULL)
+
+#define SETUP_PORT_ATTRIBUTE_RD(field)					\
+	i->private_port_attrs[count] = device_attr_port_##field;	\
+	i->private_port_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_port_attrs[count].store = NULL;			\
+	i->port_attrs[count] = &i->private_port_attrs[count];		\
+	if (i->f->show_port_##field)					\
+		count++
+
+fc_private_port_rd_attr(maxframe_size, "%u bytes\n", 20);
+
+
+#define fc_fabric_show_function(field, format_string, sz, cast)		\
+static ssize_t								\
+show_fc_fabric_##field(struct device *dev,				\
+		       struct device_attribute *attr, char *buf)	\
+{									\
+	struct fc_fabric *fabric = transport_class_to_fabric(dev);	\
+	struct fc_internal *i = to_fc_internal(fabric->t);		\
+	if (i->f->get_fabric_##field)					\
+		i->f->get_fabric_##field(fabric);			\
+	return snprintf(buf, sz, format_string,				\
+			cast fc_fabric_##field(fabric));		\
+}
+
+#define fc_fabric_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_fabric_show_function(field, format_string, sz, (cast))	\
+	static FC_DEVICE_ATTR(fabric, field, S_IRUGO,			\
+		      show_fc_fabric_##field, NULL)
+
+#define SETUP_FABRIC_ATTRIBUTE_RD(field)				\
+	i->private_fabric_attrs[count] = device_attr_fabric_##field;	\
+	i->private_fabric_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_fabric_attrs[count].store = NULL;			\
+	i->fabric_attrs[count] = &i->private_fabric_attrs[count];	\
+	if (i->f->show_fabric_##field)					\
+		count++
+
+fc_fabric_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+
+
 /*
  * Netlink Infrastructure
  */
@@ -647,9 +725,15 @@ static __init int fc_transport_init(void)
 
 	atomic_set(&fc_event_seq, 0);
 
-	error = transport_class_register(&fc_host_class);
+	error = transport_class_register(&fc_port_class);
 	if (error)
 		return error;
+	error = transport_class_register(&fc_fabric_class);
+	if (error)
+		goto unreg_port_class;
+	error = transport_class_register(&fc_host_class);
+	if (error)
+		goto unreg_fabric_class;
 	error = transport_class_register(&fc_vport_class);
 	if (error)
 		goto unreg_host_class;
@@ -667,6 +751,10 @@ unreg_vport_class:
 	transport_class_unregister(&fc_vport_class);
 unreg_host_class:
 	transport_class_unregister(&fc_host_class);
+unreg_fabric_class:
+	transport_class_unregister(&fc_fabric_class);
+unreg_port_class:
+	transport_class_unregister(&fc_port_class);
 	return error;
 }
 
@@ -676,6 +764,8 @@ static void __exit fc_transport_exit(void)
 	transport_class_unregister(&fc_rport_class);
 	transport_class_unregister(&fc_host_class);
 	transport_class_unregister(&fc_vport_class);
+	transport_class_unregister(&fc_fabric_class);
+	transport_class_unregister(&fc_port_class);
 }
 
 /*
@@ -2014,6 +2104,85 @@ static int fc_vport_match(struct attribute_container *cont,
 	return &i->vport_attr_cont.ac == cont;
 }
 
+/**
+ * fc_port_dev_release() - Release the FC port memory
+ * @dev: Pointer to the FC port's embedded device
+ *
+ * Called when the last FC port reference is released.
+ */
+static void fc_port_dev_release(struct device *dev)
+{
+	struct fc_port *port = dev_to_port(dev);
+
+	put_device(port->dev.parent);
+	port->dev.parent = NULL;
+	kfree(port);
+}
+
+int dev_is_fc_port(const struct device *dev)
+{
+	return dev->release == fc_port_dev_release;
+}
+EXPORT_SYMBOL(dev_is_fc_port);
+
+static int fc_port_match(struct attribute_container *cont,
+			 struct device *dev)
+{
+	struct fc_port *port;
+	struct fc_internal *i;
+
+	if (!dev_is_fc_port(dev))
+		return 0;
+	port = dev_to_port(dev);
+
+	if (!port->t || port->t->host_attrs.ac.class
+	    != &fc_host_class.class)
+		return 0;
+
+	i = to_fc_internal(port->t);
+
+	return &i->port_attr_cont.ac == cont;
+}
+
+/**
+ * fc_fabric_dev_release() - Release the FC port memory
+ * @dev: Pointer to the FC fabric's embedded device
+ *
+ * Called when the last FC fabric reference is released.
+ */
+static void fc_fabric_dev_release(struct device *dev)
+{
+	struct fc_fabric *fabric = dev_to_fabric(dev);
+
+	put_device(fabric->dev.parent);
+	fabric->dev.parent = NULL;
+	kfree(fabric);
+}
+
+int dev_is_fc_fabric(const struct device *dev)
+{
+	return dev->release == fc_fabric_dev_release;
+}
+EXPORT_SYMBOL(dev_is_fc_fabric);
+
+static int fc_fabric_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct fc_fabric *fabric;
+	struct fc_internal *i;
+
+	if (!dev_is_fc_fabric(dev))
+		return 0;
+	fabric = dev_to_fabric(dev);
+
+	if (!fabric->t || fabric->t->host_attrs.ac.class
+	    != &fc_host_class.class)
+		return 0;
+
+	i = to_fc_internal(fabric->t);
+
+	return &i->fabric_attr_cont.ac == cont;
+}
 
 /**
  * fc_timed_out - FC Transport I/O timeout intercept handler
@@ -2166,6 +2335,16 @@ fc_attach_transport(struct fc_function_template *ft)
 	i->vport_attr_cont.ac.match = fc_vport_match;
 	transport_container_register(&i->vport_attr_cont);
 
+	i->port_attr_cont.ac.attrs = &i->port_attrs[0];
+	i->port_attr_cont.ac.class = &fc_port_class.class;
+	i->port_attr_cont.ac.match = fc_port_match;
+	transport_container_register(&i->port_attr_cont);
+
+	i->fabric_attr_cont.ac.attrs = &i->fabric_attrs[0];
+	i->fabric_attr_cont.ac.class = &fc_fabric_class.class;
+	i->fabric_attr_cont.ac.match = fc_fabric_match;
+	transport_container_register(&i->fabric_attr_cont);
+
 	i->f = ft;
 
 	/* Transport uses the shost workq for scsi scanning */
@@ -2180,6 +2359,24 @@ fc_attach_transport(struct fc_function_template *ft)
 	i->t.it_nexus_response = fc_it_nexus_response;
 
 	/*
+	 * Setup FC Port Attributes.
+	 */
+	count = 0;
+	SETUP_PORT_ATTRIBUTE_RD(maxframe_size);
+	BUG_ON(count > FC_PORT_NUM_ATTRS);
+
+	i->port_attrs[count] = NULL;
+
+	/*
+	 * Setup FC Fabric Attributes.
+	 */
+	count = 0;
+	SETUP_FABRIC_ATTRIBUTE_RD(fabric_name);
+	BUG_ON(count > FC_FABRIC_NUM_ATTRS);
+
+	i->fabric_attrs[count] = NULL;
+
+	/*
 	 * Setup SCSI Target Attributes.
 	 */
 	count = 0;
@@ -2281,6 +2478,8 @@ void fc_release_transport(struct scsi_transport_template *t)
 	transport_container_unregister(&i->t.host_attrs);
 	transport_container_unregister(&i->rport_attr_cont);
 	transport_container_unregister(&i->vport_attr_cont);
+	transport_container_unregister(&i->port_attr_cont);
+	transport_container_unregister(&i->fabric_attr_cont);
 
 	kfree(i);
 }
@@ -2372,7 +2571,6 @@ fc_flush_devloss(struct Scsi_Host *shost)
 	flush_workqueue(fc_host_devloss_work_q(shost));
 }
 
-
 /**
  * fc_remove_host - called to terminate any fc_transport-related elements for a scsi host.
  * @shost:	Which &Scsi_Host
@@ -2393,6 +2591,7 @@ fc_remove_host(struct Scsi_Host *shost)
 {
 	struct fc_vport *vport = NULL, *next_vport = NULL;
 	struct fc_rport *rport = NULL, *next_rport = NULL;
+	struct fc_fabric *fabric = NULL, *next_fabric = NULL;
 	struct workqueue_struct *work_q;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
@@ -2418,8 +2617,20 @@ fc_remove_host(struct Scsi_Host *shost)
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
+	/* Remove any fabrics */
+	list_for_each_entry_safe(fabric, next_fabric,
+				 &fc_host->fabrics, peers) {
+		list_del(&fabric->peers);
+		fabric->state = FC_FABRICSTATE_DISCONNECTED;
+		fc_queue_work(shost, &fabric->fabric_delete_work);
+	}
+
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	/* Remove the fc port */
+	if (fc_host->port)
+		fc_port_del(fc_host->port);
+
 	/* flush all scan work items */
 	scsi_flush_work(shost);
 
@@ -3509,6 +3720,365 @@ fc_vport_sched_delete(struct work_struct *work)
 			vport->channel, stat);
 }
 
+/**
+ * fc_port_del() - Delete a FC port and its subtree from sysfs
+ * @fcport: A pointer to the port to be deleted
+ *
+ * Deletes a FC port and any fabrics attached
+ * to it. Deleting fabrics will cause their childen
+ * to be deleted as well.
+ *
+ * The port is detached from sysfs and it's resources
+ * are freed, but the memory is not freed until its
+ * last reference is released.
+ *
+ * This routine expects no locks to be held before
+ * calling.
+ */
+void fc_port_del(struct fc_port *fcport)
+{
+	struct Scsi_Host *shost = port_to_shost(fcport);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+
+	fc_host->port = NULL;
+
+	transport_unregister_device(&fcport->dev);
+	device_del(&fcport->dev);
+	put_device(&fcport->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_port_del);
+
+static atomic_t fc_port_next_id;
+
+/**
+ * fc_port_add() - Add a FC port to sysfs
+ * @shost: The SCSI Host that the port will be a child of
+ *
+ * This routine allocates a FC port object with some additional memory
+ * for the LLD. The FC port is initialized, added to sysfs and then
+ * attributes are added to it.
+ */
+struct fc_port *fc_port_add(struct Scsi_Host *shost)
+{
+	struct fc_internal *fci = to_fc_internal(shost->transportt);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_port *fcport;
+	unsigned long flags;
+	int error = 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (fc_host->port) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		goto out;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+
+	fcport = kzalloc(sizeof(struct fc_port) + fci->f->dd_fcport_size,
+			 GFP_KERNEL);
+	if (!fcport)
+		goto out;
+
+	/* Initialize members */
+	memset(fcport->system_hostname, 0, sizeof(fcport->system_hostname));
+	fcport->maxframe_size = -1;
+	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	fcport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+	fcport->speed = FC_PORTSPEED_UNKNOWN;
+	fcport->fab_dev_loss_tmo = 600; /* default to 10mins */
+	memset(fcport->supported_fc4s, 0,
+	       sizeof(fcport->supported_fc4s));
+	memset(fcport->active_fc4s, 0,
+	       sizeof(fcport->active_fc4s));
+	memset(fcport->serial_number, 0,
+	       sizeof(fcport->serial_number));
+
+	/* Setup internal structures */
+	fcport->id = atomic_inc_return(&fc_port_next_id) - 1;
+	dev_set_name(&fcport->dev, "port%d", fcport->id);
+	device_initialize(&fcport->dev);
+	fcport->dev.parent = get_device(&shost->shost_gendev);
+	fcport->dev.release = fc_port_dev_release;
+	fcport->t = shost->transportt;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	fc_host->port = fcport;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	error = device_add(&fcport->dev);
+	if (error)
+		goto out_del;
+
+	transport_register_device(&fcport->dev);
+	transport_configure_device(&fcport->dev);
+
+	/*
+	 * system_hostname may be set through sysfs, but
+	 * not updated by the lld
+	 */
+//	FC_SETUP_COND_ATTR_RW(fcport, system_hostname);
+//	FC_SETUP_COND_ATTR_RW(fcport, fab_dev_loss_tmo);
+
+//	FC_SETUP_COND_ATTR_RD(fcport, maxframe_size);
+//	FC_SETUP_COND_ATTR_RD(fcport, supported_speeds);
+//	FC_SETUP_COND_ATTR_RD(fcport, supported_fc4s);
+//	FC_SETUP_COND_ATTR_RD(fcport, active_fc4s);
+//	FC_SETUP_COND_ATTR_RD(fcport, supported_classes);
+//	FC_SETUP_COND_ATTR_RD(fcport, serial_number);
+//	FC_SETUP_COND_ATTR_RD(fcport, speed);
+
+//	BUG_ON(count > FC_PORT_NUM_ATTRS);
+//	FC_CREATE_ATTRS(fcport, count);
+
+//	if (error || count != 0)
+//		goto out_del_dev;
+
+	return fcport;
+
+//out_del_dev:
+//	device_del(&fcport->dev);
+out_del:
+	put_device(&shost->shost_gendev);
+	kfree(fcport);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fc_port_add);
+
+/**
+ * fc_fabric_final_delete() - Final delete routine
+ * @work: The FC fabric's embedded work struct
+ *
+ * Delete the fabric's N_Port, which will in turn delete
+ * any FC vports on the fabric. Finally, remove the device
+ * from sysfs and drop the last reference.
+ */
+static void fc_fabric_final_delete(struct work_struct *work)
+{
+	struct fc_fabric *fabric =
+		container_of(work, struct fc_fabric,
+			     fabric_delete_work);
+	struct fc_port *port = fc_fabric_to_port(fabric);
+	struct Scsi_Host *shost = fabric_to_shost(fabric);
+	struct fc_internal *fci = to_fc_internal(shost->transportt);
+	unsigned long flags;
+
+	/*
+	 * Cancel any outstanding timers. These should really exist
+	 * only when rmmod'ing the LLDD and we're asking for
+	 * immediate termination of the rports
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (fabric->flags & FC_FABRIC_DEVLOSS_PENDING) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (!cancel_delayed_work(&fabric->dev_loss_work))
+			fc_flush_devloss(shost);
+		spin_lock_irqsave(shost->host_lock, flags);
+		fabric->flags &= ~FC_FABRIC_DEVLOSS_PENDING;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (fci->f->fabric_destroy)
+		fci->f->fabric_destroy(port, fabric);
+
+	/* TODO: Need to remove the scsi_host, or will the caller do that? */
+
+	transport_unregister_device(&fabric->dev);
+	device_del(&fabric->dev);
+	put_device(&fabric->dev); /* self-reference */
+}
+
+/**
+ * fc_timeout_deleted_fabric() - Delete a fabric when the devloss timer fires
+ * @work: The FC fabric's embedded work struct
+ *
+ * Removes the fabric from the FC port's list of fabrics and
+ * queues the final deletion.
+ */
+static void fc_timeout_deleted_fabric(struct work_struct *work)
+{
+	struct fc_fabric *fabric =
+		container_of(work, struct fc_fabric, dev_loss_work.work);
+	struct Scsi_Host *shost = fabric_to_shost(fabric);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	fabric->flags &= ~FC_FABRIC_DEVLOSS_PENDING;
+
+	if (fabric->state == FC_FABRICSTATE_CONNECTED) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return;
+	}
+
+	dev_printk(KERN_ERR, &fabric->dev,
+		   "FC fabric connection time out: removing fabric\n");
+
+	list_del(&fabric->peers);
+	fc_queue_work(shost, &fabric->fabric_delete_work);
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/**
+ * fc_fabric_del() - Delete a FC fabric
+ * @fabric: Pointer to the fabric which is to be deleted
+ *
+ * Queues the FC fabric on the devloss workqueue
+ */
+void fc_fabric_del(struct fc_fabric *fabric)
+{
+	struct Scsi_Host *shost = fabric_to_shost(fabric);
+	int timeout = fabric->dev_loss_tmo;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (fabric->state != FC_FABRICSTATE_CONNECTED) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return;
+	}
+
+	fabric->state = FC_FABRICSTATE_DISCONNECTED;
+	fabric->flags |= FC_FABRIC_DEVLOSS_PENDING;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	fc_queue_devloss_work(shost, &fabric->dev_loss_work,
+			      timeout * HZ);
+}
+EXPORT_SYMBOL(fc_fabric_del);
+
+int fc_fabric_fcf_match(struct fc_fabric *fabric,
+			struct fc_fabric *new_fabric)
+{
+	/* stub */
+	return 1;
+}
+
+static atomic_t fc_fabric_next_id;
+/**
+ * fc_fabric_create() - Allocate a new FC Fabric
+ * @shost: The Scsi Host associated with the to-be-created fabric
+ * @port:  The FC Port that will be the parent of the to-be-created fabric
+ */
+struct fc_fabric *fc_fabric_create(struct Scsi_Host *shost,
+				   struct fc_port *port)
+{
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *fci = to_fc_internal(shost->transportt);
+	struct fc_fabric *fabric;
+	unsigned long flags;
+	int error = 0;
+	int size;
+
+	size = (sizeof(struct fc_fabric) + fci->f->dd_fcfabric_size);
+	fabric = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!fabric))
+		goto out;
+
+	/* Initialize members */
+	INIT_WORK(&fabric->fabric_delete_work, fc_fabric_final_delete);
+	INIT_DELAYED_WORK(&fabric->dev_loss_work, fc_timeout_deleted_fabric);
+	fabric->dev_loss_tmo = port->fab_dev_loss_tmo;
+//TODO	fabric->fabric_name = new_fabric->fabric_name;
+
+	/* Setup internal structures */
+	fabric->id = atomic_inc_return(&fc_fabric_next_id) - 1;
+	dev_set_name(&fabric->dev, "fabric%d", fabric->id);
+	device_initialize(&fabric->dev);
+	fabric->dev.parent = get_device(&port->dev);
+	fabric->dev.release = fc_fabric_dev_release;
+	fabric->t = port->t;
+
+	fabric->state = FC_FABRICSTATE_CONNECTED;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_add_tail(&fabric->peers, &fc_host->fabrics);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	error = device_add(&fabric->dev);
+	if (error)
+		goto out_del_dev;
+
+	transport_register_device(&fabric->dev);
+	transport_configure_device(&fabric->dev);
+
+//	FC_SETUP_COND_ATTR_RD(fcfabric, dev_loss_tmo);
+
+//	FC_SETUP_ATTR_RD_NS(fcfabric, max_npiv_vports);
+//	FC_SETUP_ATTR_RD_NS(fcfabric, npiv_vports_inuse);
+//	FC_SETUP_ATTR_RW_NS(fcfabric, vport_create);
+//	FC_SETUP_ATTR_RW_NS(fcfabric, vport_delete);
+
+//	BUG_ON(count > FC_FABRIC_NUM_ATTRS);
+//	FC_CREATE_ATTRS(fcfabric, count);
+
+//	if (error || count != 0)
+//		goto out_del_dev;
+
+	if (fci->f->fabric_create)
+		fci->f->fabric_create(port, fabric);
+
+	return fabric;
+
+out_del_dev:
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&fabric->peers);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(&port->dev);
+	kfree(fabric);
+out:
+	return NULL;
+}
+
+/**
+ * fc_fabric_add() - Add a FC fabric to sysfs
+ * @port:       The FC port that the fabric is to be added to
+ * @new_fabric: The new fabric to add
+ *
+ * Expects the port lock to be held
+ * (TODO: should the lock be held? fc_remote_port_add doesn't
+ *  have it held. Does either approach have a clear advantage?
+ *
+ */
+struct fc_fabric *fc_fabric_add(struct fc_port *port,
+				struct fc_fabric *new_fabric)
+{
+	struct Scsi_Host *shost = port_to_shost(port);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *fci = to_fc_internal(port->t);
+	struct fc_fabric *fabric;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	list_for_each_entry(fabric, &fc_host->fabrics, peers) {
+		if (fci->f->fabric_match(fabric, new_fabric)) {
+			if (fabric->state == FC_FABRICSTATE_CONNECTED)
+				goto out;
+
+			fabric->flags &= ~FC_FABRIC_DEVLOSS_PENDING;
+			fabric->state = FC_FABRICSTATE_CONNECTED;
+
+			if (!cancel_delayed_work(&fabric->dev_loss_work))
+				fc_flush_devloss(shost);
+			else
+				goto out;
+		}
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	fabric = fc_fabric_create(shost, port);
+	return fabric;
+
+out:
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return fabric;
+}
+EXPORT_SYMBOL(fc_fabric_add);
+
 
 /*
  * BSG support
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 2a65167..7af4bc8 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -33,6 +33,11 @@
 
 struct scsi_transport_template;
 
+#define FC_FC4_LIST_SIZE		32
+#define FC_SYMBOLIC_NAME_SIZE		256
+#define FC_VERSION_STRING_SIZE		64
+#define FC_SERIAL_NUMBER_SIZE		80
+
 /*
  * FC Port definitions - Following FC HBAAPI guidelines
  *
@@ -187,6 +192,120 @@ struct fc_vport_identifiers {
 	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
 };
 
+struct fc_port {
+	u32                             id;
+	struct device                   dev;
+	struct scsi_transport_template  *t;
+
+	/* Fixed Attributes */
+	u8   supported_fc4s[FC_FC4_LIST_SIZE];
+	u32  maxframe_size;
+	u32  supported_classes;
+	char serial_number[FC_SERIAL_NUMBER_SIZE];
+
+	/* Dynamic Attributes*/
+	u8 active_fc4s[FC_FC4_LIST_SIZE];
+	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
+
+	/*
+	 * FCoE supported_speeds and speed can change on
+	 * a link event so they are dynamic.
+	 */
+	u32 supported_speeds;
+	u32 speed;
+
+	int fab_dev_loss_tmo;
+};
+#define dev_to_port(d)				\
+	container_of((d), struct fc_port, dev)
+#define transport_class_to_port(dev)		\
+	dev_to_port(dev->parent)
+#define port_to_shost(x)			\
+	dev_to_shost((x)->dev.parent)
+#define fc_port_id(x)				\
+	((x)->id)
+#define fc_port_supported_fc4s(x)		\
+	((x)->supported_fc4s)
+#define fc_port_maxframe_size(x)		\
+	((x)->maxframe_size)
+#define fc_port_supported_classes(x)		\
+	((x)->supported_classes)
+#define fc_port_serial_number(x)		\
+	((x)->serial_number)
+#define fc_port_active_fc4s(x)			\
+	((x)->active_fc4s)
+#define fc_port_system_hostname(x)		\
+	((x)->system_hostname)
+#define fc_port_supported_speeds(x)		\
+	((x)->supported_speeds)
+#define fc_port_speed(x)			\
+	((x)->speed)
+#define fc_port_fab_dev_loss_tmo(x)		\
+	((x)->fab_dev_loss_tmo)
+static inline void *fc_port_priv(const struct fc_port *fcport)
+{
+	return (void *)(fcport + 1);
+}
+
+/* bit field values for struct fc_fabric "flags" field */
+#define FC_FABRIC_DEVLOSS_PENDING 0x01
+
+/* fabric states */
+enum fabric_state {
+	FC_FABRICSTATE_UNKNOWN,
+	FC_FABRICSTATE_DISCONNECTED,
+	FC_FABRICSTATE_CONNECTED,
+};
+
+struct fc_fabric {
+	u32                             id;
+	struct device                   dev;
+	struct list_head                peers;
+	struct work_struct              fabric_delete_work;
+	struct delayed_work             dev_loss_work;
+	u32                             dev_loss_tmo;
+	struct scsi_transport_template  *t;
+
+	/*
+	 * TODO: What is most appropriate for these, enum, mask?
+	 */
+	u8 flags;
+	enum fabric_state state;
+
+	/* Fixed Attributes */
+	u64 fabric_name;
+};
+
+#define dev_to_fabric(d)				\
+	container_of((d), struct fc_fabric, dev)
+#define transport_class_to_fabric(dev)		\
+	dev_to_fabric(dev->parent)
+static inline void *fc_fabric_priv(const struct fc_fabric *fcfabric)
+{
+	return (void *)(fcfabric + 1);
+}
+
+/* parentage should never be missing */
+#define fc_fabric_to_port(x)			\
+	dev_to_port((x)->dev.parent)
+#define fabric_to_shost(x)			\
+	port_to_shost(fc_fabric_to_port(x))
+#define fc_fabric_fabric_name(x)		\
+	((x)->fabric_name)
+#define fc_fabric_dev_loss_tmo(x)		\
+	((x)->dev_loss_tmo)
+#define fc_fabric_max_npiv_vports(x)		\
+	((x)->max_npiv_vports)
+#define fc_fabric_next_vport_number(x)		\
+	((x)->next_vport_number)
+#define fc_fabric_npiv_vports_inuse(x)		\
+	((x)->npiv_vports_inuse)
+#define fc_fabric_vports(x)			\
+	((x)->vports)
+/*
+#define fcfabric_to_fcport(x)			\
+	dev_to_fcport((x)->dev.parent)
+*/
 /*
  * FC Virtual Port Attributes
  *
@@ -470,11 +589,6 @@ enum fc_host_event_code  {
  * managed by the transport w/o driver interaction.
  */
 
-#define FC_FC4_LIST_SIZE		32
-#define FC_SYMBOLIC_NAME_SIZE		256
-#define FC_VERSION_STRING_SIZE		64
-#define FC_SERIAL_NUMBER_SIZE		80
-
 struct fc_host_attrs {
 	/* Fixed Attributes */
 	u64 node_name;
@@ -505,6 +619,8 @@ struct fc_host_attrs {
 	struct list_head rports;
 	struct list_head rport_bindings;
 	struct list_head vports;
+	struct list_head fabrics;
+	struct fc_port *port;
 	u32 next_rport_number;
 	u32 next_target_id;
 	u32 next_vport_number;
@@ -565,6 +681,10 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->rport_bindings)
 #define fc_host_vports(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->vports)
+#define fc_host_fabrics(x)					\
+	(((struct fc_host_attrs *)(x)->shost_data)->fabrics)
+#define fc_host_port(x)						\
+	(((struct fc_host_attrs *)(x)->shost_data)->port)
 #define fc_host_next_rport_number(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->next_rport_number)
 #define fc_host_next_target_id(x) \
@@ -628,6 +748,8 @@ struct fc_bsg_job {
 
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
+	void	(*get_fabric_fabric_name)(struct fc_fabric *);
+
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
 	void	(*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
 
@@ -666,10 +788,16 @@ struct fc_function_template {
 	int	(*bsg_timeout)(struct fc_bsg_job *);
 
 	/* allocation lengths for host-specific data */
+	u32                             dd_fcport_size;
+	u32                             dd_fcfabric_size;
 	u32	 			dd_fcrport_size;
 	u32	 			dd_fcvport_size;
 	u32				dd_bsg_size;
 
+	/* Fabric addition/removal LLD callbacks */
+	int (*fabric_create)(struct fc_port *, struct fc_fabric *);
+	int (*fabric_destroy)(struct fc_port *, struct fc_fabric *);
+
 	/*
 	 * The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
@@ -677,6 +805,14 @@ struct fc_function_template {
 	 * class
 	 */
 
+	/* port fixed attributes */
+	unsigned long show_port_maxframe_size:1;
+
+	/* fabric fixed attributes */
+	int  (*fabric_match)(struct fc_fabric *, struct fc_fabric *);
+	unsigned long show_fabric_fabric_name:1;
+	unsigned long show_fabric_dev_loss_tmo:1;
+
 	/* remote port fixed attributes */
 	unsigned long	show_rport_maxframe_size:1;
 	unsigned long	show_rport_supported_classes:1;
@@ -793,6 +929,10 @@ struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
 void fc_remove_host(struct Scsi_Host *);
+struct fc_port *fc_port_add(struct Scsi_Host *);
+void fc_port_del(struct fc_port *);
+struct fc_fabric *fc_fabric_add(struct fc_port *, struct fc_fabric *);
+void fc_fabric_del(struct fc_fabric *);
 struct fc_rport *fc_remote_port_add(struct Scsi_Host *shost,
 			int channel, struct fc_rport_identifiers  *ids);
 void fc_remote_port_delete(struct fc_rport  *rport);

