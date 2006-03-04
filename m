From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] first cut at infrastructure for handling different device
	types in the sas class
Date: Fri, 03 Mar 2006 22:05:03 -0600
Message-ID: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59878 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932107AbWCDEFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 23:05:15 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k24453219861
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 23:05:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This one actually does the end devices, since that's all I really have
to work with in my setup.  However, I can do the expanders in the same
way.  The idea is to make the rphy embedded in the enveloping device
structure, so the code which doesn't care about type can still treat the
code as a simple rphy, and the code that does care can cast out to the
device type.

Temporarily, because mptsas doesn't do this, I've put a flag in to
indicate whether the rphy is enveloped or not, however, if we enforce
this for everything, then eventually that would go away.

The example just creates a separate class for sas_end_device with some
simple properties from the end device port page:

hobholes:/sys/class# ls sas_rphy/
rphy-0:0-4  rphy-0:1-5  rphy-0:2-6  rphy-0:3-7

hobholes:/sys/class# ls sas_end_device/
rphy-0:0-4  rphy-0:1-5  rphy-0:2-6  rphy-0:3-7

hobholes:/sys/class# ls sas_end_device/rphy-0\:0-4/
device                      I_T_nexus_loss_timeout  uevent
initiator_response_timeout  ready_led_meaning

If everyone's OK with this, I'll do expanders next.

James

diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index cd10c52..f1339c4 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -204,13 +204,6 @@ static int sas_get_port_device(struct sa
 		return -ENODEV;
 	}
 	phy = container_of(port->phy_list.next, struct asd_sas_phy, port_phy_el);
-	rphy = sas_rphy_alloc(phy->phy);
-	if (!rphy) {
-		spin_unlock_irqrestore(&port->phy_list_lock, flags);
-		kfree(dev);
-		return -ENODEV;
-	}
-	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	spin_lock(&phy->frame_rcvd_lock);
 	memcpy(dev->frame_rcvd, phy->frame_rcvd, min(sizeof(dev->frame_rcvd),
 					     (size_t)phy->frame_rcvd_size));
@@ -237,6 +230,13 @@ static int sas_get_port_device(struct sa
 
 	sas_init_dev(dev);
 
+	rphy = dev->dev_type == SAS_END_DEV ? sas_rphy_end_device_alloc(phy->phy) : sas_rphy_alloc(phy->phy);
+	if (!rphy) {
+		spin_unlock_irqrestore(&port->phy_list_lock, flags);
+		kfree(dev);
+		return -ENODEV;
+	}
+	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
 	rphy->identify.sas_address = SAS_ADDR(dev->sas_addr);
 	rphy->identify.initiator_port_protocols = dev->iproto;
diff --git a/drivers/scsi/sas/sas_scsi_host.c b/drivers/scsi/sas/sas_scsi_host.c
index af5fa7e..39ee259 100644
--- a/drivers/scsi/sas/sas_scsi_host.c
+++ b/drivers/scsi/sas/sas_scsi_host.c
@@ -569,6 +569,8 @@ int sas_slave_configure(struct scsi_devi
 	dev = sdev_to_domain_dev(scsi_dev);
 	sas_ha = dev->port->ha;
 
+	sas_read_port_mode_page(scsi_dev);
+
 	if (scsi_dev->tagged_supported) {
 		scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
 		scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 434f395..a9b3750 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -39,6 +39,7 @@
 #define SAS_HOST_ATTRS		0
 #define SAS_PORT_ATTRS		17
 #define SAS_RPORT_ATTRS		7
+#define SAS_END_DEV_ATTRS	3
 
 struct sas_internal {
 	struct scsi_transport_template t;
@@ -47,9 +48,11 @@ struct sas_internal {
 	struct class_device_attribute private_host_attrs[SAS_HOST_ATTRS];
 	struct class_device_attribute private_phy_attrs[SAS_PORT_ATTRS];
 	struct class_device_attribute private_rphy_attrs[SAS_RPORT_ATTRS];
+	struct class_device_attribute private_end_dev_attrs[SAS_END_DEV_ATTRS];
 
 	struct transport_container phy_attr_cont;
 	struct transport_container rphy_attr_cont;
+	struct transport_container end_dev_attr_cont;
 
 	/*
 	 * The array of null terminated pointers to attributes
@@ -58,6 +61,7 @@ struct sas_internal {
 	struct class_device_attribute *host_attrs[SAS_HOST_ATTRS + 1];
 	struct class_device_attribute *phy_attrs[SAS_PORT_ATTRS + 1];
 	struct class_device_attribute *rphy_attrs[SAS_RPORT_ATTRS + 1];
+	struct class_device_attribute *end_dev_attrs[SAS_END_DEV_ATTRS + 1];
 };
 #define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)
 
@@ -588,6 +592,73 @@ sas_rphy_simple_attr(identify.sas_addres
 		unsigned long long);
 sas_rphy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
 
+/* only need 8 bytes of data plus header (4 or 8) */
+#define BUF_SIZE 64
+
+int sas_read_port_mode_page(struct scsi_device *sdev)
+{
+	char *buffer = kzalloc(BUF_SIZE, GFP_KERNEL), *msdata;
+	struct sas_rphy *rphy = target_to_rphy(sdev->sdev_target);
+	struct sas_rphy_end_device *rdev;
+	struct scsi_mode_data mode_data;
+	int res, error;
+
+	BUG_ON(rphy->identify.device_type != SAS_END_DEVICE);
+
+	rdev = rphy_to_end_device(rphy);
+
+	if (!buffer)
+		return -ENOMEM;
+
+	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+			      &mode_data, NULL);
+
+	error = -EINVAL;
+	if (!scsi_status_is_good(res))
+		goto out;
+
+	msdata = buffer +  mode_data.header_length +
+		mode_data.block_descriptor_length;
+
+	if (msdata - buffer > BUF_SIZE - 8)
+		goto out;
+
+	error = 0;
+
+	rdev->ready_led_meaning = msdata[2] & 0x10 ? 1 : 0;
+	rdev->I_T_nexus_loss_timeout = (msdata[4] << 8) + msdata[5];
+	rdev->initiator_response_timeout = (msdata[6] << 8) + msdata[7];
+
+ out:
+	kfree(buffer);
+	return error;
+}
+EXPORT_SYMBOL(sas_read_port_mode_page);
+
+#define sas_end_dev_show_simple(field, name, format_string, cast)	\
+static ssize_t								\
+show_sas_end_dev_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_rphy *rphy = transport_class_to_rphy(cdev);		\
+	struct sas_rphy_end_device *rdev = rphy_to_end_device(rphy);	\
+									\
+	return snprintf(buf, 20, format_string, cast rdev->field);	\
+}
+
+#define sas_end_dev_simple_attr(field, name, format_string, type)	\
+	sas_end_dev_show_simple(field, name, format_string, (type))	\
+static SAS_CLASS_DEVICE_ATTR(end_dev, name, S_IRUGO, 			\
+		show_sas_end_dev_##name, NULL)
+
+sas_end_dev_simple_attr(ready_led_meaning, ready_led_meaning, "%d\n", int);
+sas_end_dev_simple_attr(I_T_nexus_loss_timeout, I_T_nexus_loss_timeout,
+			"%d\n", int);
+sas_end_dev_simple_attr(initiator_response_timeout, initiator_response_timeout,
+			"%d\n", int);
+
+static DECLARE_TRANSPORT_CLASS(sas_end_dev_class,
+			       "sas_end_device", NULL, NULL, NULL);
+
 static DECLARE_TRANSPORT_CLASS(sas_rphy_class,
 		"sas_rphy", NULL, NULL, NULL);
 
@@ -610,6 +681,35 @@ static int sas_rphy_match(struct attribu
 	return &i->rphy_attr_cont.ac == cont;
 }
 
+static int sas_end_dev_match(struct attribute_container *cont,
+			     struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+	struct sas_rphy *rphy;
+	int r;
+
+	if (!scsi_is_sas_rphy(dev))
+		return 0;
+	dev_printk(KERN_ERR, dev, "IN SAS END DEV MATCH\n");
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
+	r = &i->end_dev_attr_cont.ac == cont &&
+		rphy->identify.device_type == SAS_END_DEVICE &&
+		/* FIXME: remove contained eventually */
+		rphy->contained;
+	dev_printk(KERN_ERR, dev, "ABOUT TO RETURN %d\n", r);
+	return r;
+}
+
 static void sas_rphy_release(struct device *dev)
 {
 	struct sas_rphy *rphy = dev_to_rphy(dev);
@@ -650,6 +750,40 @@ struct sas_rphy *sas_rphy_alloc(struct s
 EXPORT_SYMBOL(sas_rphy_alloc);
 
 /**
+ * sas_rphy_end_device_alloc - allocate an rphy for an end device
+ *
+ * Allocates an SAS remote PHY structure, connected to @parent.
+ *
+ * Returns:
+ *	SAS PHY allocated or %NULL if the allocation failed.
+ */
+struct sas_rphy *sas_rphy_end_device_alloc(struct sas_phy *parent)
+{
+	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
+	struct sas_rphy_end_device *rdev;
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
+	sprintf(rdev->rphy.dev.bus_id, "rphy-%d:%d-%d",
+		shost->host_no, parent->port_identifier, parent->number);
+	rdev->rphy.identify.device_type = SAS_END_DEVICE;
+	/* FIXME: mark the rphy as being contained in a larger structure */
+	rdev->rphy.contained = 1;
+	transport_setup_device(&rdev->rphy.dev);
+
+	return &rdev->rphy;
+}
+EXPORT_SYMBOL(sas_rphy_end_device_alloc);
+
+
+/**
  * sas_rphy_add  --  add a SAS remote PHY to the device hierachy
  * @rphy:	The remote PHY to be added
  *
@@ -807,51 +941,35 @@ static int sas_user_scan(struct Scsi_Hos
  * Setup / Teardown code
  */
 
-#define SETUP_RPORT_ATTRIBUTE(field)					\
-	i->private_rphy_attrs[count] = class_device_attr_##field;	\
-	i->private_rphy_attrs[count].attr.mode = S_IRUGO;		\
-	i->private_rphy_attrs[count].store = NULL;			\
-	i->rphy_attrs[count] = &i->private_rphy_attrs[count];	\
-	count++
+#define SETUP_TEMPLATE(attrb, field, perm, test)				\
+	i->private_##attrb[count] = class_device_attr_##field;		\
+	i->private_##attrb[count].attr.mode = perm;			\
+	i->private_##attrb[count].store = NULL;				\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
+
+
+#define SETUP_RPORT_ATTRIBUTE(field) 					\
+	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, 1)
 
 #define SETUP_OPTIONAL_RPORT_ATTRIBUTE(field, func)			\
-	i->private_rphy_attrs[count] = class_device_attr_##field;	\
-	i->private_rphy_attrs[count].attr.mode = S_IRUGO;		\
-	i->private_rphy_attrs[count].store = NULL;			\
-	i->rphy_attrs[count] = &i->private_rphy_attrs[count];		\
-	if (i->f->func)							\
-		count++
+	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, i->f->func)
 
 #define SETUP_PORT_ATTRIBUTE(field)					\
-	i->private_phy_attrs[count] = class_device_attr_##field;	\
-        i->private_phy_attrs[count].attr.mode = S_IRUGO;		\
-        i->private_phy_attrs[count].store = NULL;			\
-        i->phy_attrs[count] = &i->private_phy_attrs[count];		\
-	count++
+	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, 1)
 
 #define SETUP_OPTIONAL_PORT_ATTRIBUTE(field, func)			\
-	i->private_phy_attrs[count] = class_device_attr_##field;	\
-        i->private_phy_attrs[count].attr.mode = S_IRUGO;		\
-        i->private_phy_attrs[count].store = NULL;			\
-        i->phy_attrs[count] = &i->private_phy_attrs[count];		\
-	if (i->f->func)							\
-		count++
+	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, i->f->func)
 
 #define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
-	i->private_phy_attrs[count] = class_device_attr_##field;	\
-	i->private_phy_attrs[count].attr.mode = S_IWUGO;		\
-	i->private_phy_attrs[count].show = NULL;			\
-	i->phy_attrs[count] = &i->private_phy_attrs[count];		\
-	count++
+	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, 1)
 
 #define SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(field, func)		\
-	i->private_phy_attrs[count] = class_device_attr_##field;	\
-	i->private_phy_attrs[count].attr.mode = S_IWUGO;		\
-	i->private_phy_attrs[count].show = NULL;			\
-	i->phy_attrs[count] = &i->private_phy_attrs[count];		\
-	if (i->f->func)							\
-		count++
+	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, i->f->func)
 
+#define SETUP_END_DEV_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(end_dev_attrs, field, S_IRUGO, 1)
 
 /**
  * sas_attach_transport  --  instantiate SAS transport template
@@ -885,6 +1003,11 @@ sas_attach_transport(struct sas_function
 	i->rphy_attr_cont.ac.match = sas_rphy_match;
 	transport_container_register(&i->rphy_attr_cont);
 
+	i->end_dev_attr_cont.ac.class = &sas_end_dev_class.class;
+	i->end_dev_attr_cont.ac.attrs = &i->end_dev_attrs[0];
+	i->end_dev_attr_cont.ac.match = sas_end_dev_match;
+	transport_container_register(&i->end_dev_attr_cont);
+
 	i->f = ft;
 
 	count = 0;
@@ -923,6 +1046,12 @@ sas_attach_transport(struct sas_function
 				       get_bay_identifier);
 	i->rphy_attrs[count] = NULL;
 
+	count = 0;
+	SETUP_END_DEV_ATTRIBUTE(end_dev_ready_led_meaning);
+	SETUP_END_DEV_ATTRIBUTE(end_dev_I_T_nexus_loss_timeout);
+	SETUP_END_DEV_ATTRIBUTE(end_dev_initiator_response_timeout);
+	i->end_dev_attrs[count] = NULL;
+
 	return &i->t;
 }
 EXPORT_SYMBOL(sas_attach_transport);
@@ -956,9 +1085,14 @@ static __init int sas_transport_init(voi
 	error = transport_class_register(&sas_rphy_class);
 	if (error)
 		goto out_unregister_phy;
+	error = transport_class_register(&sas_end_dev_class);
+	if (error)
+		goto out_unregister_rphy;
 
 	return 0;
 
+ out_unregister_rphy:
+	transport_class_unregister(&sas_rphy_class);
  out_unregister_phy:
 	transport_class_unregister(&sas_phy_class);
  out_unregister_transport:
@@ -973,6 +1107,7 @@ static void __exit sas_transport_exit(vo
 	transport_class_unregister(&sas_host_class);
 	transport_class_unregister(&sas_phy_class);
 	transport_class_unregister(&sas_rphy_class);
+	transport_class_unregister(&sas_end_dev_class);
 }
 
 MODULE_AUTHOR("Christoph Hellwig");
diff --git a/include/scsi/sas/sas_discover.h b/include/scsi/sas/sas_discover.h
index 1584d4e..2be414e 100644
--- a/include/scsi/sas/sas_discover.h
+++ b/include/scsi/sas/sas_discover.h
@@ -86,7 +86,6 @@ struct sata_device {
 struct end_device {
 	u8     ms_10:1;
 	u8     ready_led_meaning:1;
-	u8     rl_wlun:1;
 	u16    itnl_timeout; 	  /* 0 if you do not know it */
 	u16    iresp_timeout;
 };
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 95e2132..96ede6e 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -82,6 +82,10 @@ struct sas_rphy {
 	struct sas_identify	identify;
 	struct list_head	list;
 	u32			scsi_target_id;
+	/* temporary expedient: mark the rphy as being contained 
+	 * within a type specific rphy
+	 * FIXME: pull this out when everything uses the containers */
+	unsigned		contained:1;
 };
 
 #define dev_to_rphy(d) \
@@ -90,6 +94,19 @@ struct sas_rphy {
 	dev_to_rphy((cdev)->dev)
 #define rphy_to_shost(rphy) \
 	dev_to_shost((rphy)->dev.parent)
+#define target_to_rphy(targ) \
+	dev_to_rphy((targ)->dev.parent)
+
+struct sas_rphy_end_device {
+	struct sas_rphy		rphy;
+	/* flags */
+	unsigned		ready_led_meaning:1;
+	/* parameters */
+	u16			I_T_nexus_loss_timeout;
+	u16			initiator_response_timeout;
+};
+#define rphy_to_end_device(r) \
+	container_of((r), struct sas_rphy_end_device, rphy)
 
 
 /* The functions by which the transport class and the driver communicate */
@@ -110,6 +127,7 @@ extern void sas_phy_delete(struct sas_ph
 extern int scsi_is_sas_phy(const struct device *);
 
 extern struct sas_rphy *sas_rphy_alloc(struct sas_phy *);
+extern struct sas_rphy *sas_rphy_end_device_alloc(struct sas_phy *);
 void sas_rphy_free(struct sas_rphy *);
 extern int sas_rphy_add(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
@@ -118,5 +136,6 @@ extern int scsi_is_sas_rphy(const struct
 extern struct scsi_transport_template *
 sas_attach_transport(struct sas_function_template *);
 extern void sas_release_transport(struct scsi_transport_template *);
+int sas_read_port_mode_page(struct scsi_device *);
 
 #endif /* SCSI_TRANSPORT_SAS_H */


