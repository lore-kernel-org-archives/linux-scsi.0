From: "Rajan, Mukesh" <Mukesh.Rajan@Emulex.Com>
Subject: [PATCH] Add attributes to FC transport
Date: Fri, 6 Aug 2004 13:46:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E70881386D@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60076 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S268255AbUHFUrR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2004 16:47:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'andrew.vasquez@qlogic.com'" <andrew.vasquez@qlogic.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>

Hi,

We would like to export certain HBA attributes such as Port Type, Port
Speed etc via sysfs in the lpfc driver. These attributes are more
representative of the transport layer and it will benefit from including
them as generic FC transport attributes. Also the patch corrects the
illegal values of node_name, port_name and port_id to zero, which are the
accepted NULL values as per the FC-GS-4 standards.

Please apply.

Thanks,
Mukesh

diff -ur linux-2.6.7/drivers/scsi/scsi_transport_fc.c
linux-2.6.7patch/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.7/drivers/scsi/scsi_transport_fc.c	2004-07-27
11:09:00.000000000 -0700
+++ linux-2.6.7patch/drivers/scsi/scsi_transport_fc.c	2004-08-05
16:43:24.000000000 -0700
@@ -28,7 +28,7 @@
 
 static void transport_class_release(struct class_device *class_dev);
 
-#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_NUM_ATTRS 	10	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always
on"
 				 * attributes */
 
@@ -61,11 +61,16 @@
 
 static int fc_setup_transport_attrs(struct scsi_device *sdev)
 {
-	/* I'm not sure what values are invalid.  We should pick some
invalid
-	 * values for the defaults */
-	fc_node_name(sdev) = -1;
-	fc_port_name(sdev) = -1;
-	fc_port_id(sdev) = -1;
+	fc_node_name(sdev) = 0;
+	fc_port_name(sdev) = 0;
+	fc_port_id(sdev) = 0;
+	fc_port_type(sdev) = 0;
+	fc_port_state(sdev) = 0;
+	fc_port_supported_classes(sdev) = 0;
+	memset(fc_port_active_fc4types(sdev), 0, 32);
+	fc_port_speed(sdev) = 0;
+	fc_port_maxframe_size(sdev) = 0;
+	fc_fabric_name(sdev) = 0;
 
 	return 0;
 }
@@ -125,6 +130,187 @@
 fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
+fc_transport_rd_attr(port_maxframe_size, "%u\n");
+fc_transport_rd_attr_cast(fabric_name, "0x%llx\n", unsigned long long);
+
+static ssize_t
+show_fc_transport_port_type(struct class_device *cdev, char *buf)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct fc_transport_attrs *tp;
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);
+
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;
+
+	if (i->f->get_port_type)
+		i->f->get_port_type(sdev);
+
+	switch (tp->port_type) {
+
+	case FCHBA_PORTTYPE_UNKNOWN:
+		return sprintf(buf, "Unknown\n");
+		
+	case FCHBA_PORTTYPE_OTHER:
+		return sprintf(buf, "Other\n");
+
+	case FCHBA_PORTTYPE_NOTPRESENT:
+		return sprintf(buf, "Not present\n");
+
+	case FCHBA_PORTTYPE_NPORT:
+		return sprintf(buf, "NPORT\n");
+	
+	case FCHBA_PORTTYPE_NLPORT:
+		return sprintf(buf, "NLPORT\n");
+	
+	case FCHBA_PORTTYPE_FLPORT:
+		return sprintf(buf, "FLPORT\n");
+
+	case FCHBA_PORTTYPE_FPORT:
+		return sprintf(buf, "FPORT\n");
+	
+	case FCHBA_PORTTYPE_LPORT:
+		return sprintf(buf, "LPORT\n");
+
+	case FCHBA_PORTTYPE_PTP:
+		return sprintf(buf, "PTP\n");
+	}
+
+	return 0;
+}
+
+static CLASS_DEVICE_ATTR(port_type, S_IRUGO, show_fc_transport_port_type,
NULL);
+
+static ssize_t
+show_fc_transport_port_state(struct class_device *cdev, char *buf)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct fc_transport_attrs *tp;
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);
+
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;
+
+	if (i->f->get_port_state)
+		i->f->get_port_state(sdev);
+
+	switch (tp->port_state) {
+
+	case FCHBA_PORTSTATE_UNKNOWN:
+		return sprintf(buf, "Unknown\n");
+
+	case FCHBA_PORTSTATE_ONLINE:
+		return sprintf(buf, "Online\n");
+	
+	case FCHBA_PORTSTATE_OFFLINE:
+		return sprintf(buf, "Offline\n");
+
+	case FCHBA_PORTSTATE_BYPASSED:
+		return sprintf(buf, "Bypassed\n");
+
+	case FCHBA_PORTSTATE_DIAGNOSTICS:
+		return sprintf(buf, "Diagnostics\n");
+	
+	case FCHBA_PORTSTATE_LINKDOWN:
+		return sprintf(buf, "Linkdown\n");
+	
+	case FCHBA_PORTSTATE_ERROR:
+		return sprintf(buf, "Error\n");
+
+	case FCHBA_PORTSTATE_LOOPBACK:
+		return sprintf(buf, "Loopback\n");
+	}
+
+	return 0;
+
+}
+
+static CLASS_DEVICE_ATTR(port_state, S_IRUGO, show_fc_transport_port_state,
+
NULL);
+
+static ssize_t
+show_fc_transport_port_supported_classes(struct class_device *cdev, char
*buf)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct fc_transport_attrs *tp;
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);
+	int len = 0;
+
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;
+
+	if (i->f->get_port_supported_classes)
+		i->f->get_port_supported_classes(sdev);
+
+	if (tp->port_supported_classes & FCHBA_COS_CLASS1)
+		len += sprintf(buf, "o Class 1\n");
+	if (tp->port_supported_classes & FCHBA_COS_CLASS2)
+		len += sprintf(buf+len, "o Class 2\n");
+	if (tp->port_supported_classes & FCHBA_COS_CLASS3)
+		len += sprintf(buf+len, "o Class 3\n");
+
+	return len;
+}
+
+static CLASS_DEVICE_ATTR(port_supported_classes, S_IRUGO,
+				show_fc_transport_port_supported_classes,
NULL);
+
+static ssize_t
+show_fc_transport_port_active_fc4types(struct class_device *cdev, char
*buf)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct fc_transport_attrs *tp;
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);
+	int j, len = 0;
+
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;
+
+	if (i->f->get_port_active_fc4types)
+		i->f->get_port_active_fc4types(sdev);
+
+	len += sprintf(buf, "0x ");
+
+	for (j = 0; j < 32; j++)
+		len += sprintf(buf+len , "%x ",
tp->port_active_fc4types[j]);
+	
+	len += sprintf(buf+len,"\n");
+
+	return len;
+}
+
+static CLASS_DEVICE_ATTR(port_active_fc4types, S_IRUGO,
+				 show_fc_transport_port_active_fc4types,
NULL);
+
+static ssize_t
+show_fc_transport_port_speed(struct class_device *cdev, char *buf)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct fc_transport_attrs *tp;
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);
+
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;
+
+	if (i->f->get_port_speed)
+		i->f->get_port_speed(sdev);
+
+	switch (tp->port_speed) {
+	
+	case FCHBA_PORTSPEED_UNKNOWN:
+		return sprintf(buf, "Unknown\n");
+	case FCHBA_PORTSPEED_1GBIT:
+		return sprintf(buf, "1 Gigabit\n");
+	case FCHBA_PORTSPEED_2GBIT:
+		return sprintf(buf, "2 Gigabit\n");
+	case FCHBA_PORTSPEED_4GBIT:
+		return sprintf(buf, "4 Gigabit\n");
+	case FCHBA_PORTSPEED_10GBIT:
+		return sprintf(buf, "10 Gigabit\n");
+	case FCHBA_PORTSPEED_NOT_NEGOTIATED:
+		return sprintf(buf, "Not Negotiated\n");
+	}
+	return 0;
+}
+
+static CLASS_DEVICE_ATTR(port_speed, S_IRUGO, show_fc_transport_port_speed,
+
NULL);
+		
 
 #define SETUP_ATTRIBUTE_RD(field)				\
 	i->private_attrs[count] = class_device_attr_##field;	\
@@ -165,6 +351,13 @@
 	SETUP_ATTRIBUTE_RD(port_id);
 	SETUP_ATTRIBUTE_RD(port_name);
 	SETUP_ATTRIBUTE_RD(node_name);
+	SETUP_ATTRIBUTE_RD(port_type);
+	SETUP_ATTRIBUTE_RD(port_state);
+	SETUP_ATTRIBUTE_RD(port_supported_classes);
+	SETUP_ATTRIBUTE_RD(port_active_fc4types);
+	SETUP_ATTRIBUTE_RD(port_speed);
+	SETUP_ATTRIBUTE_RD(port_maxframe_size);
+	SETUP_ATTRIBUTE_RD(fabric_name);
 
 	BUG_ON(count > FC_NUM_ATTRS);
 
diff -ur linux-2.6.7/include/scsi/scsi_transport_fc.h
linux-2.6.7patch/include/scsi/scsi_transport_fc.h
--- linux-2.6.7/include/scsi/scsi_transport_fc.h	2004-07-26
18:26:36.000000000 -0700
+++ linux-2.6.7patch/include/scsi/scsi_transport_fc.h	2004-08-05
16:42:46.000000000 -0700
@@ -24,29 +24,90 @@
 
 struct scsi_transport_template;
 
+#define FCHBA_PORTTYPE_UNKNOWN		1
+#define FCHBA_PORTTYPE_OTHER		2   /* Other */
+#define FCHBA_PORTTYPE_NOTPRESENT	3   /* Not present */
+#define FCHBA_PORTTYPE_NPORT		5   /* Fabric  */
+#define FCHBA_PORTTYPE_NLPORT		6   /* Public Loop */
+#define FCHBA_PORTTYPE_FLPORT		7
+#define FCHBA_PORTTYPE_FPORT		8   /* Fabric Port */
+#define FCHBA_PORTTYPE_LPORT		20  /* Private Loop */
+#define FCHBA_PORTTYPE_PTP		21  /* Point to Point */
+
+#define FCHBA_PORTSTATE_UNKNOWN		1   /* Unknown */
+#define FCHBA_PORTSTATE_ONLINE		2   /* Operational */
+#define FCHBA_PORTSTATE_OFFLINE		3   /* User Offline */
+#define FCHBA_PORTSTATE_BYPASSED	4   /* Bypassed */
+#define FCHBA_PORTSTATE_DIAGNOSTICS	5   /* In diagnostics mode */
+#define FCHBA_PORTSTATE_LINKDOWN	6   /* Link Down */
+#define FCHBA_PORTSTATE_ERROR		7   /* Port Error */
+#define FCHBA_PORTSTATE_LOOPBACK	8   /* Loopback */
+
+#define FCHBA_COS_CLASS1	1   /* CLASS 1 */
+#define FCHBA_COS_CLASS2	2   /* CLASS 2 */
+#define FCHBA_COS_CLASS3	4   /* CLASS 3 */
+
+#define FCHBA_PORTSPEED_UNKNOWN		0   /* Unknown - transceiver
+						     incable of reporting */
+#define FCHBA_PORTSPEED_1GBIT		1   /* 1 GBit/sec */
+#define FCHBA_PORTSPEED_2GBIT		2   /* 2 GBit/sec */
+#define FCHBA_PORTSPEED_10GBIT		4   /* 10 GBit/sec */
+#define FCHBA_PORTSPEED_4GBIT		8   /* 4 GBit/sec */
+#define FCHBA_PORTSPEED_NOT_NEGOTIATED	5   /* Speed not established */
+
+
+
 struct fc_transport_attrs {
-	int port_id;
 	uint64_t node_name;
 	uint64_t port_name;
+	uint32_t port_id;
+	uint32_t port_type;
+	uint32_t port_state;
+	uint32_t port_supported_classes;
+	uint8_t  port_active_fc4types[32];
+	uint32_t port_speed;
+	uint32_t port_maxframe_size;
+	uint64_t fabric_name;
 };
 
 /* accessor functions */
-#define fc_port_id(x)	(((struct fc_transport_attrs
*)&(x)->transport_data)->port_id)
 #define fc_node_name(x)	(((struct fc_transport_attrs
*)&(x)->transport_data)->node_name)
 #define fc_port_name(x)	(((struct fc_transport_attrs
*)&(x)->transport_data)->port_name)
+#define fc_port_id(x)	(((struct fc_transport_attrs
*)&(x)->transport_data)->port_id)
+#define fc_port_type(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->port_type)
+#define fc_port_state(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->port_state)
+#define fc_port_supported_classes(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->port_supported_classes)
+#define fc_port_active_fc4types(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->port_active_fc4types)
+#define fc_port_speed(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->port_speed)
+#define fc_port_maxframe_size(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->port_maxframe_size)
+#define fc_fabric_name(x) (((struct fc_transport_attrs
*)&(x)->transport_data)->fabric_name)
 
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
-	void 	(*get_port_id)(struct scsi_device *);
 	void	(*get_node_name)(struct scsi_device *);
 	void	(*get_port_name)(struct scsi_device *);
+	void 	(*get_port_id)(struct scsi_device *);
+	void	(*get_port_type)(struct scsi_device *);
+	void	(*get_port_state)(struct scsi_device *);
+	void	(*get_port_supported_classes)(struct scsi_device *);
+	void	(*get_port_active_fc4types)(struct scsi_device *);
+	void	(*get_port_speed)(struct scsi_device *);
+	void	(*get_port_maxframe_size)(struct scsi_device *);
+	void	(*get_fabric_name)(struct scsi_device *);
 	/* The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport
 	 * class */
-	unsigned long	show_port_id:1;
 	unsigned long	show_node_name:1;
 	unsigned long	show_port_name:1;
+	unsigned long	show_port_id:1;
+	unsigned long	show_port_type:1;
+	unsigned long	show_port_state:1;
+	unsigned long	show_port_supported_classes:1;
+	unsigned long	show_port_active_fc4types:1;
+	unsigned long	show_port_speed:1;
+	unsigned long	show_port_maxframe_size:1;
+	unsigned long	show_fabric_name:1;
 	/* Private Attributes */
 };
