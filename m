From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] update: scsi_transport_sas: introduce a sas_port entity
Date: Thu, 01 Jun 2006 16:42:05 -0500
Message-ID: <1149198125.3489.62.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2259 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750883AbWFAVmH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 17:42:07 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k51Lg6a15332
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jun 2006 17:42:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This corrects a few deficiencies in the original ... now I can
add/remove the module and do some unpugging.

James

---

[PATCH] scsi_transport_sas: introduce a sas_port entity

this patch separates out ports and phys, with ports becoming the primary
objects of the tree.  At the moment, this is pretty much an illustration
of how it will be done, with the port having very few actual attributes.
A patch demonstrating this on the aic94xx driver will follow.

James
Index: BUILD-2.6/drivers/scsi/scsi_sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sas_internal.h
+++ BUILD-2.6/drivers/scsi/scsi_sas_internal.h
@@ -2,7 +2,8 @@
 #define _SCSI_SAS_INTERNAL_H
 
 #define SAS_HOST_ATTRS		0
-#define SAS_PORT_ATTRS		17
+#define SAS_PHY_ATTRS		17
+#define SAS_PORT_ATTRS		1
 #define SAS_RPORT_ATTRS		7
 #define SAS_END_DEV_ATTRS	3
 #define SAS_EXPANDER_ATTRS	7
@@ -13,12 +14,14 @@ struct sas_internal {
 	struct sas_domain_function_template *dft;
 
 	struct class_device_attribute private_host_attrs[SAS_HOST_ATTRS];
-	struct class_device_attribute private_phy_attrs[SAS_PORT_ATTRS];
+	struct class_device_attribute private_phy_attrs[SAS_PHY_ATTRS];
+	struct class_device_attribute private_port_attrs[SAS_PORT_ATTRS];
 	struct class_device_attribute private_rphy_attrs[SAS_RPORT_ATTRS];
 	struct class_device_attribute private_end_dev_attrs[SAS_END_DEV_ATTRS];
 	struct class_device_attribute private_expander_attrs[SAS_EXPANDER_ATTRS];
 
 	struct transport_container phy_attr_cont;
+	struct transport_container port_attr_cont;
 	struct transport_container rphy_attr_cont;
 	struct transport_container end_dev_attr_cont;
 	struct transport_container expander_attr_cont;
@@ -28,7 +31,8 @@ struct sas_internal {
 	 * needed by scsi_sysfs.c
 	 */
 	struct class_device_attribute *host_attrs[SAS_HOST_ATTRS + 1];
-	struct class_device_attribute *phy_attrs[SAS_PORT_ATTRS + 1];
+	struct class_device_attribute *phy_attrs[SAS_PHY_ATTRS + 1];
+	struct class_device_attribute *port_attrs[SAS_PORT_ATTRS + 1];
 	struct class_device_attribute *rphy_attrs[SAS_RPORT_ATTRS + 1];
 	struct class_device_attribute *end_dev_attrs[SAS_END_DEV_ATTRS + 1];
 	struct class_device_attribute *expander_attrs[SAS_EXPANDER_ATTRS + 1];
Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c
@@ -174,12 +174,29 @@ static int sas_host_match(struct attribu
 
 static int do_sas_phy_delete(struct device *dev, void *data)
 {
-	if (scsi_is_sas_phy(dev))
+	int pass = (int)(unsigned long)data;
+
+	if (pass == 0 && scsi_is_sas_port(dev))
+		sas_port_delete(dev_to_sas_port(dev));
+	else if (pass == 1 && scsi_is_sas_phy(dev))
 		sas_phy_delete(dev_to_phy(dev));
 	return 0;
 }
 
 /**
+ * sas_remove_children  --  tear down a devices SAS data structures
+ * @dev:	device belonging to the sas object
+ *
+ * Removes all SAS PHYs and remote PHYs for a given object
+ */
+void sas_remove_children(struct device *dev)
+{
+	device_for_each_child(dev, (void *)0, do_sas_phy_delete);
+	device_for_each_child(dev, (void *)1, do_sas_phy_delete);
+}
+EXPORT_SYMBOL(sas_remove_children);
+
+/**
  * sas_remove_host  --  tear down a Scsi_Host's SAS data structures
  * @shost:	Scsi Host that is torn down
  *
@@ -188,13 +205,13 @@ static int do_sas_phy_delete(struct devi
  */
 void sas_remove_host(struct Scsi_Host *shost)
 {
-	device_for_each_child(&shost->shost_gendev, NULL, do_sas_phy_delete);
+	sas_remove_children(&shost->shost_gendev);
 }
 EXPORT_SYMBOL(sas_remove_host);
 
 
 /*
- * SAS Port attributes
+ * SAS Phy attributes
  */
 
 #define sas_phy_show_simple(field, name, format_string, cast)		\
@@ -310,7 +327,7 @@ sas_phy_protocol_attr(identify.target_po
 sas_phy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
 		unsigned long long);
 sas_phy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
-sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", u8);
+//sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", u8);
 sas_phy_linkspeed_attr(negotiated_linkrate);
 sas_phy_linkspeed_attr(minimum_linkrate_hw);
 sas_phy_linkspeed_attr(minimum_linkrate);
@@ -378,6 +395,7 @@ struct sas_phy *sas_phy_alloc(struct dev
 	device_initialize(&phy->dev);
 	phy->dev.parent = get_device(parent);
 	phy->dev.release = sas_phy_release;
+	INIT_LIST_HEAD(&phy->port_siblings);
 	if (scsi_is_sas_expander_device(parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent);
 		sprintf(phy->dev.bus_id, "phy-%d-%d:%d", shost->host_no,
@@ -440,8 +458,8 @@ sas_phy_delete(struct sas_phy *phy)
 {
 	struct device *dev = &phy->dev;
 
-	if (phy->rphy)
-		sas_rphy_delete(phy->rphy);
+	/* this happens if the phy is still part of a port when deleted */
+	BUG_ON(!list_empty(&phy->port_siblings));
 
 	transport_remove_device(dev);
 	device_del(dev);
@@ -464,6 +482,244 @@ int scsi_is_sas_phy(const struct device 
 EXPORT_SYMBOL(scsi_is_sas_phy);
 
 /*
+ * SAS Port attributes
+ */
+#define sas_port_show_simple(field, name, format_string, cast)		\
+static ssize_t								\
+show_sas_port_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_port *port = transport_class_to_sas_port(cdev);	\
+									\
+	return snprintf(buf, 20, format_string, cast port->field);	\
+}
+
+#define sas_port_simple_attr(field, name, format_string, type)		\
+	sas_port_show_simple(field, name, format_string, (type))	\
+static CLASS_DEVICE_ATTR(name, S_IRUGO, show_sas_port_##name, NULL)
+
+sas_port_simple_attr(num_phys, num_phys, "%d\n", int);
+
+static DECLARE_TRANSPORT_CLASS(sas_port_class,
+			       "sas_port", NULL, NULL, NULL);
+
+static int sas_port_match(struct attribute_container *cont, struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+
+	if (!scsi_is_sas_port(dev))
+		return 0;
+	shost = dev_to_shost(dev->parent);
+
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class !=
+			&sas_host_class.class)
+		return 0;
+
+	i = to_sas_internal(shost->transportt);
+	return &i->port_attr_cont.ac == cont;
+}
+
+
+static void sas_port_release(struct device *dev)
+{
+	struct sas_port *port = dev_to_sas_port(dev);
+
+	BUG_ON(!list_empty(&port->phy_list));
+
+	put_device(dev->parent);
+	kfree(port);
+}
+
+static void sas_port_create_link(struct sas_port *port,
+				 struct sas_phy *phy)
+{
+	sysfs_create_link(&port->dev.kobj, &phy->dev.kobj, phy->dev.bus_id);
+	sysfs_create_link(&phy->dev.kobj, &port->dev.kobj, "port");
+}
+
+static void sas_port_delete_link(struct sas_port *port,
+				 struct sas_phy *phy)
+{
+	sysfs_remove_link(&port->dev.kobj, phy->dev.bus_id);
+	sysfs_remove_link(&phy->dev.kobj, "port");
+}
+
+/** sas_port_alloc - allocate and initialize a SAS port structure
+ *
+ * @parent:	parent device
+ * @port_id:	port number
+ *
+ * Allocates a SAS port structure.  It will be added to the device tree
+ * below the device specified by @parent which must be either a Scsi_Host
+ * or a sas_expander_device.
+ *
+ * Returns %NULL on error
+ */
+struct sas_port *sas_port_alloc(struct device *parent, int port_id)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct sas_port *port;
+
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return NULL;
+
+	port->port_identifier = port_id;
+
+	device_initialize(&port->dev);
+
+	port->dev.parent = get_device(parent);
+	port->dev.release = sas_port_release;
+
+	mutex_init(&port->phy_list_mutex);
+	INIT_LIST_HEAD(&port->phy_list);
+
+	if (scsi_is_sas_expander_device(parent)) {
+		struct sas_rphy *rphy = dev_to_rphy(parent);
+		sprintf(port->dev.bus_id, "port-%d:%d:%d", shost->host_no,
+			rphy->scsi_target_id, port->port_identifier);
+	} else
+		sprintf(port->dev.bus_id, "port-%d:%d", shost->host_no,
+			port->port_identifier);
+
+	transport_setup_device(&port->dev);
+
+	return port;
+}
+EXPORT_SYMBOL(sas_port_alloc);
+
+/**
+ * sas_port_add - add a SAS port to the device hierarchy
+ *
+ * @port:	port to be added
+ *
+ * publishes a port to the rest of the system
+ */
+int sas_port_add(struct sas_port *port)
+{
+	int error;
+
+	/* No phys should be added until this is made visible */
+	BUG_ON(!list_empty(&port->phy_list));
+
+	error = device_add(&port->dev);
+
+	if (error)
+		return error;
+
+	transport_add_device(&port->dev);
+	transport_configure_device(&port->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(sas_port_add);
+
+/**
+ * sas_port_free  --  free a SAS PORT
+ * @port:	SAS PORT to free
+ *
+ * Frees the specified SAS PORT.
+ *
+ * Note:
+ *   This function must only be called on a PORT that has not
+ *   sucessfully been added using sas_port_add().
+ */
+void sas_port_free(struct sas_port *port)
+{
+	transport_destroy_device(&port->dev);
+	put_device(&port->dev);
+}
+EXPORT_SYMBOL(sas_port_free);
+
+/**
+ * sas_port_delete  --  remove SAS PORT
+ * @port:	SAS PORT to remove
+ *
+ * Removes the specified SAS PORT.  If the SAS PORT has an
+ * associated phys, unlink them from the port as well.
+ */
+void sas_port_delete(struct sas_port *port)
+{
+	struct device *dev = &port->dev;
+	struct sas_phy *phy, *tmp_phy;
+
+	if (port->rphy) {
+		sas_rphy_delete(port->rphy);
+		port->rphy = NULL;
+	}
+
+	mutex_lock(&port->phy_list_mutex);
+	list_for_each_entry_safe(phy, tmp_phy, &port->phy_list,
+				 port_siblings) {
+		sas_port_delete_link(port, phy);
+		list_del_init(&phy->port_siblings);
+	}
+	mutex_unlock(&port->phy_list_mutex);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+EXPORT_SYMBOL(sas_port_delete);
+
+/**
+ * scsi_is_sas_port --  check if a struct device represents a SAS port
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a SAS Port, %0 else
+ */
+int scsi_is_sas_port(const struct device *dev)
+{
+	return dev->release == sas_port_release;
+}
+EXPORT_SYMBOL(scsi_is_sas_port);
+
+/**
+ * sas_port_add_phy - add another phy to a port to form a wide port
+ * @port:	port to add the phy to
+ * @phy:	phy to add
+ *
+ * When a port is initially created, it is empty (has no phys).  All
+ * ports must have at least one phy to operated, and all wide ports
+ * must have at least two.  The current code makes no difference
+ * between ports and wide ports, but the only object that can be
+ * connected to a remote device is a port, so ports must be formed on
+ * all devices with phys if they're connected to anything.
+ */
+void sas_port_add_phy(struct sas_port *port, struct sas_phy *phy)
+{
+	BUG_ON(!list_empty(&phy->port_siblings));
+	mutex_lock(&port->phy_list_mutex);
+	sas_port_create_link(port, phy);
+	list_add_tail(&phy->port_siblings, &port->phy_list);
+	port->num_phys++;
+	mutex_unlock(&port->phy_list_mutex);
+}
+EXPORT_SYMBOL(sas_port_add_phy);
+
+/**
+ * sas_port_delete_phy - remove a phy from a port or wide port
+ * @port:	port to remove the phy from
+ * @phy:	phy to remove
+ *
+ * This operation is used for tearing down ports again.  It must be
+ * done to every port or wide port before calling sas_port_delete.
+ */
+void sas_port_delete_phy(struct sas_port *port, struct sas_phy *phy)
+{
+	mutex_lock(&port->phy_list_mutex);
+	sas_port_delete_link(port, phy);
+	list_del_init(&phy->port_siblings);
+	port->num_phys--;
+	mutex_unlock(&port->phy_list_mutex);
+}
+EXPORT_SYMBOL(sas_port_delete_phy);
+
+/*
  * SAS remote PHY attributes.
  */
 
@@ -755,7 +1011,7 @@ static void sas_end_device_release(struc
  * Returns:
  *	SAS PHY allocated or %NULL if the allocation failed.
  */
-struct sas_rphy *sas_end_device_alloc(struct sas_phy *parent)
+struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
 {
 	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
 	struct sas_end_device *rdev;
@@ -769,7 +1025,7 @@ struct sas_rphy *sas_end_device_alloc(st
 	rdev->rphy.dev.parent = get_device(&parent->dev);
 	rdev->rphy.dev.release = sas_end_device_release;
 	sprintf(rdev->rphy.dev.bus_id, "end_device-%d:%d-%d",
-		shost->host_no, parent->port_identifier, parent->number);
+		shost->host_no, parent->port_identifier, parent->port_identifier);
 	rdev->rphy.identify.device_type = SAS_END_DEVICE;
 	transport_setup_device(&rdev->rphy.dev);
 
@@ -785,7 +1041,7 @@ EXPORT_SYMBOL(sas_end_device_alloc);
  * Returns:
  *	SAS PHY allocated or %NULL if the allocation failed.
  */
-struct sas_rphy *sas_expander_alloc(struct sas_phy *parent,
+struct sas_rphy *sas_expander_alloc(struct sas_port *parent,
 				    enum sas_device_type type)
 {
 	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
@@ -823,7 +1079,7 @@ EXPORT_SYMBOL(sas_expander_alloc);
  */
 int sas_rphy_add(struct sas_rphy *rphy)
 {
-	struct sas_phy *parent = dev_to_phy(rphy->dev.parent);
+	struct sas_port *parent = dev_to_sas_port(rphy->dev.parent);
 	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_identify *identify = &rphy->identify;
@@ -896,7 +1152,7 @@ void
 sas_rphy_delete(struct sas_rphy *rphy)
 {
 	struct device *dev = &rphy->dev;
-	struct sas_phy *parent = dev_to_phy(dev->parent);
+	struct sas_port *parent = dev_to_sas_port(dev->parent);
 	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
@@ -953,7 +1209,7 @@ static int sas_user_scan(struct Scsi_Hos
 
 	mutex_lock(&sas_host->lock);
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
-		struct sas_phy *parent = dev_to_phy(rphy->dev.parent);
+		struct sas_port *parent = dev_to_sas_port(rphy->dev.parent);
 
 		if (rphy->identify.device_type != SAS_END_DEVICE ||
 		    rphy->scsi_target_id == -1)
@@ -989,16 +1245,19 @@ static int sas_user_scan(struct Scsi_Hos
 #define SETUP_OPTIONAL_RPORT_ATTRIBUTE(field, func)			\
 	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, i->f->func)
 
-#define SETUP_PORT_ATTRIBUTE(field)					\
+#define SETUP_PHY_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, 1)
 
-#define SETUP_OPTIONAL_PORT_ATTRIBUTE(field, func)			\
+#define SETUP_PORT_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
+
+#define SETUP_OPTIONAL_PHY_ATTRIBUTE(field, func)			\
 	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, i->f->func)
 
-#define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
+#define SETUP_PHY_ATTRIBUTE_WRONLY(field)				\
 	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, 1)
 
-#define SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(field, func)		\
+#define SETUP_OPTIONAL_PHY_ATTRIBUTE_WRONLY(field, func)		\
 	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, i->f->func)
 
 #define SETUP_END_DEV_ATTRIBUTE(field)					\
@@ -1034,6 +1293,11 @@ sas_attach_transport(struct sas_function
 	i->phy_attr_cont.ac.match = sas_phy_match;
 	transport_container_register(&i->phy_attr_cont);
 
+	i->port_attr_cont.ac.class = &sas_port_class.class;
+	i->port_attr_cont.ac.attrs = &i->port_attrs[0];
+	i->port_attr_cont.ac.match = sas_port_match;
+	transport_container_register(&i->port_attr_cont);
+
 	i->rphy_attr_cont.ac.class = &sas_rphy_class.class;
 	i->rphy_attr_cont.ac.attrs = &i->rphy_attrs[0];
 	i->rphy_attr_cont.ac.match = sas_rphy_match;
@@ -1052,30 +1316,35 @@ sas_attach_transport(struct sas_function
 	i->f = ft;
 
 	count = 0;
+	SETUP_PORT_ATTRIBUTE(num_phys);
 	i->host_attrs[count] = NULL;
 
 	count = 0;
-	SETUP_PORT_ATTRIBUTE(initiator_port_protocols);
-	SETUP_PORT_ATTRIBUTE(target_port_protocols);
-	SETUP_PORT_ATTRIBUTE(device_type);
-	SETUP_PORT_ATTRIBUTE(sas_address);
-	SETUP_PORT_ATTRIBUTE(phy_identifier);
-	SETUP_PORT_ATTRIBUTE(port_identifier);
-	SETUP_PORT_ATTRIBUTE(negotiated_linkrate);
-	SETUP_PORT_ATTRIBUTE(minimum_linkrate_hw);
-	SETUP_PORT_ATTRIBUTE(minimum_linkrate);
-	SETUP_PORT_ATTRIBUTE(maximum_linkrate_hw);
-	SETUP_PORT_ATTRIBUTE(maximum_linkrate);
-
-	SETUP_PORT_ATTRIBUTE(invalid_dword_count);
-	SETUP_PORT_ATTRIBUTE(running_disparity_error_count);
-	SETUP_PORT_ATTRIBUTE(loss_of_dword_sync_count);
-	SETUP_PORT_ATTRIBUTE(phy_reset_problem_count);
-	SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(link_reset, phy_reset);
-	SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(hard_reset, phy_reset);
+	SETUP_PHY_ATTRIBUTE(initiator_port_protocols);
+	SETUP_PHY_ATTRIBUTE(target_port_protocols);
+	SETUP_PHY_ATTRIBUTE(device_type);
+	SETUP_PHY_ATTRIBUTE(sas_address);
+	SETUP_PHY_ATTRIBUTE(phy_identifier);
+	//SETUP_PHY_ATTRIBUTE(port_identifier);
+	SETUP_PHY_ATTRIBUTE(negotiated_linkrate);
+	SETUP_PHY_ATTRIBUTE(minimum_linkrate_hw);
+	SETUP_PHY_ATTRIBUTE(minimum_linkrate);
+	SETUP_PHY_ATTRIBUTE(maximum_linkrate_hw);
+	SETUP_PHY_ATTRIBUTE(maximum_linkrate);
+
+	SETUP_PHY_ATTRIBUTE(invalid_dword_count);
+	SETUP_PHY_ATTRIBUTE(running_disparity_error_count);
+	SETUP_PHY_ATTRIBUTE(loss_of_dword_sync_count);
+	SETUP_PHY_ATTRIBUTE(phy_reset_problem_count);
+	SETUP_OPTIONAL_PHY_ATTRIBUTE_WRONLY(link_reset, phy_reset);
+	SETUP_OPTIONAL_PHY_ATTRIBUTE_WRONLY(hard_reset, phy_reset);
 	i->phy_attrs[count] = NULL;
 
 	count = 0;
+	SETUP_PORT_ATTRIBUTE(num_phys);
+	i->port_attrs[count] = NULL;
+
+	count = 0;
 	SETUP_RPORT_ATTRIBUTE(rphy_initiator_port_protocols);
 	SETUP_RPORT_ATTRIBUTE(rphy_target_port_protocols);
 	SETUP_RPORT_ATTRIBUTE(rphy_device_type);
@@ -1117,6 +1386,7 @@ void sas_release_transport(struct scsi_t
 
 	transport_container_unregister(&i->t.host_attrs);
 	transport_container_unregister(&i->phy_attr_cont);
+	transport_container_unregister(&i->port_attr_cont);
 	transport_container_unregister(&i->rphy_attr_cont);
 	transport_container_unregister(&i->end_dev_attr_cont);
 	transport_container_unregister(&i->expander_attr_cont);
@@ -1135,9 +1405,12 @@ static __init int sas_transport_init(voi
 	error = transport_class_register(&sas_phy_class);
 	if (error)
 		goto out_unregister_transport;
-	error = transport_class_register(&sas_rphy_class);
+	error = transport_class_register(&sas_port_class);
 	if (error)
 		goto out_unregister_phy;
+	error = transport_class_register(&sas_rphy_class);
+	if (error)
+		goto out_unregister_port;
 	error = transport_class_register(&sas_end_dev_class);
 	if (error)
 		goto out_unregister_rphy;
@@ -1151,6 +1424,8 @@ static __init int sas_transport_init(voi
 	transport_class_unregister(&sas_end_dev_class);
  out_unregister_rphy:
 	transport_class_unregister(&sas_rphy_class);
+ out_unregister_port:
+	transport_class_unregister(&sas_port_class);
  out_unregister_phy:
 	transport_class_unregister(&sas_phy_class);
  out_unregister_transport:
@@ -1164,6 +1439,7 @@ static void __exit sas_transport_exit(vo
 {
 	transport_class_unregister(&sas_host_class);
 	transport_class_unregister(&sas_phy_class);
+	transport_class_unregister(&sas_port_class);
 	transport_class_unregister(&sas_rphy_class);
 	transport_class_unregister(&sas_end_dev_class);
 	transport_class_unregister(&sas_expander_class);
Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h
+++ BUILD-2.6/include/scsi/scsi_transport_sas.h
@@ -3,6 +3,7 @@
 
 #include <linux/transport_class.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
 
 struct scsi_transport_template;
 struct sas_rphy;
@@ -55,7 +56,6 @@ struct sas_phy {
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate_hw;
 	enum sas_linkrate	maximum_linkrate;
-	u8			port_identifier;
 
 	/* internal state */
 	unsigned int		local_attached : 1;
@@ -66,8 +66,8 @@ struct sas_phy {
 	u32			loss_of_dword_sync_count;
 	u32			phy_reset_problem_count;
 
-	/* the other end of the link */
-	struct sas_rphy		*rphy;
+	/* for the list of phys belonging to a port */
+	struct list_head	port_siblings;
 };
 
 #define dev_to_phy(d) \
@@ -124,6 +124,24 @@ struct sas_expander_device {
 #define rphy_to_expander_device(r) \
 	container_of((r), struct sas_expander_device, rphy)
 
+struct sas_port {
+	struct device		dev;
+
+	u8			port_identifier;
+	int			num_phys;
+
+	/* the other end of the link */
+	struct sas_rphy		*rphy;
+
+	struct mutex		phy_list_mutex;
+	struct list_head	phy_list;
+};
+
+#define dev_to_sas_port(d) \
+	container_of((d), struct sas_port, dev)
+#define transport_class_to_sas_port(cdev) \
+	dev_to_sas_port((cdev)->dev)
+
 /* The functions by which the transport class and the driver communicate */
 struct sas_function_template {
 	int (*get_linkerrors)(struct sas_phy *);
@@ -133,6 +151,7 @@ struct sas_function_template {
 };
 
 
+void sas_remove_children(struct device *);
 extern void sas_remove_host(struct Scsi_Host *);
 
 extern struct sas_phy *sas_phy_alloc(struct device *, int);
@@ -141,13 +160,21 @@ extern int sas_phy_add(struct sas_phy *)
 extern void sas_phy_delete(struct sas_phy *);
 extern int scsi_is_sas_phy(const struct device *);
 
-extern struct sas_rphy *sas_end_device_alloc(struct sas_phy *);
-extern struct sas_rphy *sas_expander_alloc(struct sas_phy *, enum sas_device_type);
+extern struct sas_rphy *sas_end_device_alloc(struct sas_port *);
+extern struct sas_rphy *sas_expander_alloc(struct sas_port *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);
 extern int sas_rphy_add(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
 extern int scsi_is_sas_rphy(const struct device *);
 
+struct sas_port *sas_port_alloc(struct device *, int);
+int sas_port_add(struct sas_port *);
+void sas_port_free(struct sas_port *);
+void sas_port_delete(struct sas_port *);
+void sas_port_add_phy(struct sas_port *, struct sas_phy *);
+void sas_port_delete_phy(struct sas_port *, struct sas_phy *);
+int scsi_is_sas_port(const struct device *);
+
 extern struct scsi_transport_template *
 sas_attach_transport(struct sas_function_template *);
 extern void sas_release_transport(struct scsi_transport_template *);


