From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add preliminary expander support to the sas transport class
Date: Mon, 13 Mar 2006 13:50:04 -0600
Message-ID: <1142279404.3238.28.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41104 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750807AbWCMTuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Mar 2006 14:50:16 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2DJo4228639
	for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2006 14:50:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch makes expanders appear as labelled objects with properties in
the SAS tree.

I've also modified the phy code to make expander phys appear labelled by
host number, expander number and phy index.

So, for my current config, you see something like this in sysfs:

/sys/class/scsi_host/host1/device/phy-1:4/expander-1:0/phy-1-0:12/rphy-1:0-12/target1:0:1

And the expander properties are:

jejb@sparkweed> cd /sys/class/sas_expander/expander-1\:0/
jejb@sparkweed> for f in *; do echo -n $f ": "; cat $f; done
component_id : 29024
component_revision_id : 4
component_vendor_id : VITESSE 
device : cat: device: Is a directory
level : 0
product_id : VSC7160 Eval Brd
product_rev : 4   
uevent : cat: uevent: Permission denied
vendor_id : VITESSE 

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 3eb11a1..5a70d04 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -40,6 +40,7 @@
 #define SAS_PORT_ATTRS		17
 #define SAS_RPORT_ATTRS		7
 #define SAS_END_DEV_ATTRS	3
+#define SAS_EXPANDER_ATTRS	7
 
 struct sas_internal {
 	struct scsi_transport_template t;
@@ -49,10 +50,12 @@ struct sas_internal {
 	struct class_device_attribute private_phy_attrs[SAS_PORT_ATTRS];
 	struct class_device_attribute private_rphy_attrs[SAS_RPORT_ATTRS];
 	struct class_device_attribute private_end_dev_attrs[SAS_END_DEV_ATTRS];
+	struct class_device_attribute private_expander_attrs[SAS_EXPANDER_ATTRS];
 
 	struct transport_container phy_attr_cont;
 	struct transport_container rphy_attr_cont;
 	struct transport_container end_dev_attr_cont;
+	struct transport_container expander_attr_cont;
 
 	/*
 	 * The array of null terminated pointers to attributes
@@ -62,6 +65,7 @@ struct sas_internal {
 	struct class_device_attribute *phy_attrs[SAS_PORT_ATTRS + 1];
 	struct class_device_attribute *rphy_attrs[SAS_RPORT_ATTRS + 1];
 	struct class_device_attribute *end_dev_attrs[SAS_END_DEV_ATTRS + 1];
+	struct class_device_attribute *expander_attrs[SAS_EXPANDER_ATTRS + 1];
 };
 #define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)
 
@@ -69,6 +73,7 @@ struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
 	u32 next_target_id;
+	u32 next_expander_id;
 };
 #define to_sas_host_attrs(host)	((struct sas_host_attrs *)(host)->shost_data)
 
@@ -173,6 +178,7 @@ static int sas_host_setup(struct transpo
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
 	sas_host->next_target_id = 0;
+	sas_host->next_expander_id = 0;
 	return 0;
 }
 
@@ -407,7 +413,12 @@ struct sas_phy *sas_phy_alloc(struct dev
 	device_initialize(&phy->dev);
 	phy->dev.parent = get_device(parent);
 	phy->dev.release = sas_phy_release;
-	sprintf(phy->dev.bus_id, "phy-%d:%d", shost->host_no, number);
+	if (scsi_is_sas_expander_device(parent)) {
+		struct sas_rphy *rphy = dev_to_rphy(parent);
+		sprintf(phy->dev.bus_id, "phy-%d-%d:%d", shost->host_no,
+			rphy->scsi_target_id, number);
+	} else
+		sprintf(phy->dev.bus_id, "phy-%d:%d", shost->host_no, number);
 
 	transport_setup_device(&phy->dev);
 
@@ -635,6 +646,9 @@ int sas_read_port_mode_page(struct scsi_
 }
 EXPORT_SYMBOL(sas_read_port_mode_page);
 
+static DECLARE_TRANSPORT_CLASS(sas_end_dev_class,
+			       "sas_end_device", NULL, NULL, NULL);
+
 #define sas_end_dev_show_simple(field, name, format_string, cast)	\
 static ssize_t								\
 show_sas_end_dev_##name(struct class_device *cdev, char *buf)		\
@@ -656,8 +670,33 @@ sas_end_dev_simple_attr(I_T_nexus_loss_t
 sas_end_dev_simple_attr(initiator_response_timeout, initiator_response_timeout,
 			"%d\n", int);
 
-static DECLARE_TRANSPORT_CLASS(sas_end_dev_class,
-			       "sas_end_device", NULL, NULL, NULL);
+static DECLARE_TRANSPORT_CLASS(sas_expander_class,
+			       "sas_expander", NULL, NULL, NULL);
+
+#define sas_expander_show_simple(field, name, format_string, cast)	\
+static ssize_t								\
+show_sas_expander_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_rphy *rphy = transport_class_to_rphy(cdev);		\
+	struct sas_expander_device *edev = rphy_to_expander_device(rphy); \
+									\
+	return snprintf(buf, 20, format_string, cast edev->field);	\
+}
+
+#define sas_expander_simple_attr(field, name, format_string, type)	\
+	sas_expander_show_simple(field, name, format_string, (type))	\
+static SAS_CLASS_DEVICE_ATTR(expander, name, S_IRUGO, 			\
+		show_sas_expander_##name, NULL)
+
+sas_expander_simple_attr(vendor_id, vendor_id, "%s\n", char *);
+sas_expander_simple_attr(product_id, product_id, "%s\n", char *);
+sas_expander_simple_attr(product_rev, product_rev, "%s\n", char *);
+sas_expander_simple_attr(component_vendor_id, component_vendor_id,
+			 "%s\n", char *);
+sas_expander_simple_attr(component_id, component_id, "%u\n", unsigned int);
+sas_expander_simple_attr(component_revision_id, component_revision_id, "%u\n",
+			 unsigned int);
+sas_expander_simple_attr(level, level, "%d\n", int);
 
 static DECLARE_TRANSPORT_CLASS(sas_rphy_class,
 		"sas_rphy", NULL, NULL, NULL);
@@ -706,6 +745,32 @@ static int sas_end_dev_match(struct attr
 		rphy->contained;
 }
 
+static int sas_expander_match(struct attribute_container *cont,
+			      struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+	struct sas_rphy *rphy;
+
+	if (!scsi_is_sas_rphy(dev))
+		return 0;
+	shost = dev_to_shost(dev->parent->parent);
+	rphy = dev_to_rphy(dev);
+
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class !=
+			&sas_host_class.class)
+		return 0;
+
+	i = to_sas_internal(shost->transportt);
+	return &i->expander_attr_cont.ac == cont &&
+		(rphy->identify.device_type == SAS_EDGE_EXPANDER_DEVICE ||
+		 rphy->identify.device_type == SAS_FANOUT_EXPANDER_DEVICE) &&
+		/* FIXME: remove contained eventually */
+		rphy->contained;
+}
+
 static void sas_rphy_release(struct device *dev)
 {
 	struct sas_rphy *rphy = dev_to_rphy(dev);
@@ -778,6 +843,46 @@ struct sas_rphy *sas_end_device_alloc(st
 }
 EXPORT_SYMBOL(sas_end_device_alloc);
 
+/**
+ * sas_expander_alloc - allocate an rphy for an end device
+ *
+ * Allocates an SAS remote PHY structure, connected to @parent.
+ *
+ * Returns:
+ *	SAS PHY allocated or %NULL if the allocation failed.
+ */
+struct sas_rphy *sas_expander_alloc(struct sas_phy *parent,
+				    enum sas_device_type type)
+{
+	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
+	struct sas_expander_device *rdev;
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+
+	BUG_ON(type != SAS_EDGE_EXPANDER_DEVICE &&
+	       type != SAS_FANOUT_EXPANDER_DEVICE);
+
+	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
+	if (!rdev) {
+		put_device(&parent->dev);
+		return NULL;
+	}
+
+	device_initialize(&rdev->rphy.dev);
+	rdev->rphy.dev.parent = get_device(&parent->dev);
+	rdev->rphy.dev.release = sas_rphy_release;
+	mutex_lock(&sas_host->lock);
+	rdev->rphy.scsi_target_id = sas_host->next_expander_id++;
+	mutex_unlock(&sas_host->lock);
+	sprintf(rdev->rphy.dev.bus_id, "expander-%d:%d",
+		shost->host_no, rdev->rphy.scsi_target_id);
+	rdev->rphy.identify.device_type = type;
+	/* FIXME: mark the rphy as being contained in a larger structure */
+	rdev->rphy.contained = 1;
+	transport_setup_device(&rdev->rphy.dev);
+
+	return &rdev->rphy;
+}
+EXPORT_SYMBOL(sas_expander_alloc);
 
 /**
  * sas_rphy_add  --  add a SAS remote PHY to the device hierachy
@@ -809,11 +914,10 @@ int sas_rphy_add(struct sas_rphy *rphy)
 	    (identify->target_port_protocols &
 	     (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA)))
 		rphy->scsi_target_id = sas_host->next_target_id++;
-	else
-		rphy->scsi_target_id = -1;
 	mutex_unlock(&sas_host->lock);
 
-	if (rphy->scsi_target_id != -1) {
+	if (identify->device_type == SAS_END_DEVICE &&
+	    rphy->scsi_target_id != -1) {
 		scsi_scan_target(&rphy->dev, parent->port_identifier,
 				rphy->scsi_target_id, ~0, 0);
 	}
@@ -967,6 +1071,9 @@ static int sas_user_scan(struct Scsi_Hos
 #define SETUP_END_DEV_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(end_dev_attrs, field, S_IRUGO, 1)
 
+#define SETUP_EXPANDER_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(expander_attrs, expander_##field, S_IRUGO, 1)
+
 /**
  * sas_attach_transport  --  instantiate SAS transport template
  * @ft:		SAS transport class function template
@@ -1004,6 +1111,11 @@ sas_attach_transport(struct sas_function
 	i->end_dev_attr_cont.ac.match = sas_end_dev_match;
 	transport_container_register(&i->end_dev_attr_cont);
 
+	i->expander_attr_cont.ac.class = &sas_expander_class.class;
+	i->expander_attr_cont.ac.attrs = &i->expander_attrs[0];
+	i->expander_attr_cont.ac.match = sas_expander_match;
+	transport_container_register(&i->expander_attr_cont);
+
 	i->f = ft;
 
 	count = 0;
@@ -1048,6 +1160,16 @@ sas_attach_transport(struct sas_function
 	SETUP_END_DEV_ATTRIBUTE(end_dev_initiator_response_timeout);
 	i->end_dev_attrs[count] = NULL;
 
+	count = 0;
+	SETUP_EXPANDER_ATTRIBUTE(vendor_id);
+	SETUP_EXPANDER_ATTRIBUTE(product_id);
+	SETUP_EXPANDER_ATTRIBUTE(product_rev);
+	SETUP_EXPANDER_ATTRIBUTE(component_vendor_id);
+	SETUP_EXPANDER_ATTRIBUTE(component_id);
+	SETUP_EXPANDER_ATTRIBUTE(component_revision_id);
+	SETUP_EXPANDER_ATTRIBUTE(level);
+	i->expander_attrs[count] = NULL;
+
 	return &i->t;
 }
 EXPORT_SYMBOL(sas_attach_transport);
@@ -1064,6 +1186,7 @@ void sas_release_transport(struct scsi_t
 	transport_container_unregister(&i->phy_attr_cont);
 	transport_container_unregister(&i->rphy_attr_cont);
 	transport_container_unregister(&i->end_dev_attr_cont);
+	transport_container_unregister(&i->expander_attr_cont);
 
 	kfree(i);
 }
@@ -1085,9 +1208,14 @@ static __init int sas_transport_init(voi
 	error = transport_class_register(&sas_end_dev_class);
 	if (error)
 		goto out_unregister_rphy;
+	error = transport_class_register(&sas_expander_class);
+	if (error)
+		goto out_unregister_end_dev;
 
 	return 0;
 
+ out_unregister_end_dev:
+	transport_class_unregister(&sas_end_dev_class);
  out_unregister_rphy:
 	transport_class_unregister(&sas_rphy_class);
  out_unregister_phy:
@@ -1105,6 +1233,7 @@ static void __exit sas_transport_exit(vo
 	transport_class_unregister(&sas_phy_class);
 	transport_class_unregister(&sas_rphy_class);
 	transport_class_unregister(&sas_end_dev_class);
+	transport_class_unregister(&sas_expander_class);
 }
 
 MODULE_AUTHOR("Christoph Hellwig");
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 8fded43..2943ccc 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -108,6 +108,25 @@ struct sas_end_device {
 #define rphy_to_end_device(r) \
 	container_of((r), struct sas_end_device, rphy)
 
+struct sas_expander_device {
+	int    level;
+
+	#define SAS_EXPANDER_VENDOR_ID_LEN	8
+	char   vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
+	#define SAS_EXPANDER_PRODUCT_ID_LEN	16
+	char   product_id[SAS_EXPANDER_PRODUCT_ID_LEN+1];
+	#define SAS_EXPANDER_PRODUCT_REV_LEN	4
+	char   product_rev[SAS_EXPANDER_PRODUCT_REV_LEN+1];
+	#define SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN	8
+	char   component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN+1];
+	u16    component_id;
+	u8     component_revision_id;
+
+	struct sas_rphy		rphy;
+
+};
+#define rphy_to_expander_device(r) \
+	container_of((r), struct sas_expander_device, rphy)
 
 /* The functions by which the transport class and the driver communicate */
 struct sas_function_template {
@@ -128,6 +147,7 @@ extern int scsi_is_sas_phy(const struct 
 
 extern struct sas_rphy *sas_rphy_alloc(struct sas_phy *);
 extern struct sas_rphy *sas_end_device_alloc(struct sas_phy *);
+extern struct sas_rphy *sas_expander_alloc(struct sas_phy *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);
 extern int sas_rphy_add(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
@@ -138,4 +158,15 @@ sas_attach_transport(struct sas_function
 extern void sas_release_transport(struct scsi_transport_template *);
 int sas_read_port_mode_page(struct scsi_device *);
 
+static inline int
+scsi_is_sas_expander_device(struct device *dev)
+{
+	struct sas_rphy *rphy;
+	if (!scsi_is_sas_rphy(dev))
+		return 0;
+	rphy = dev_to_rphy(dev);
+	return rphy->identify.device_type == SAS_FANOUT_EXPANDER_DEVICE ||
+		rphy->identify.device_type == SAS_EDGE_EXPANDER_DEVICE;
+}
+
 #endif /* SCSI_TRANSPORT_SAS_H */


James



