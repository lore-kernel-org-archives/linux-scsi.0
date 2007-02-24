From: James Smart <James.Smart@Emulex.Com>
Subject: [RFC] FC Transport support for vports based on NPIV
Date: Fri, 23 Feb 2007 22:47:57 -0500
Message-ID: <1172288877.5483.4.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58510 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249AbXBWWY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Feb 2007 17:24:58 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l1NMOurs009203
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2007 14:24:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's the first pass at an RFC for NPIV-based virtual ports within the
FC transport.

The patch adds the following:

 - Addition of a new fc_vport object and class.
   The vport object is to be inserted into the device tree, and then
   new scsi_host object created as a child of the vport. Below the 
   child scsi_host will be rports, targets, etc. The parent is allowed
   to be configurable, so that we could move it over under a VM-based
   object tree. 

   Here's an example of a vport object tree, using the scsi_host object
   for the physical adapter as the vport's parent.

   The typical Physical Port's Scsi_Host:
     /sys/devices/.../host17/
   and it has the typical decendent tree:
     /sys/devices/.../host17/rport-17:0-0/target17:0:0/17:0:0:0:
   and then the vport is created on the Physical Port:
     /sys/devices/.../host17/vport-17:0-0
   and the vport's Scsi_Host is then created:
     /sys/devices/.../host17/vport-17:0-0/host18
   and then the rest of the tree progresses, such as:
     /sys/devices/.../host17/vport-17:0-0/host18/rport-18:0-0/target18:0:0/18:0:0:0:

 - LLDD's indicate support for NPIV ports by supplying a vport_create
   function in the transport template.  When they supply the routine,
   they are also signing up for the following:
     fc_host max_npiv_ports attribute: set by LLDD, on the fc_host for
        the physical adapter, to indicate the driver/adapters maximum.

   The vport creation process is perfomed in 2 steps. The first obtains
   all information necessary to describe the virtual port, the physical
   port is created on, and the device tree object it is to be bound to.
   The expectation is that in the future - an SGIOv4 ioctl will be made
   to supply the full set of vport data. In the near term, a simple
   "create" sysfs variable exists, with defaults much of the vport data.
   The vport data includes the following:
     A reference to the "parent" device object that the vport is to be
        instanted upon.
     A reference to the physical port it is to be created upon
     WWPN and WWNN to use for the vport
     The FC4 roles that are to be supported on the vport
     The type of vport to create. Could support NPIV or Virtual Fabric.
        Only NPIV is supported currently.
     Symbolic Name data: It is highly useful to register symbolic data
        with the switch so that an admin viewing the switch mgmt displays
	can tell that a virtual port exists, and is say bound to Virtual
	Machine Z.  This string is to be appended to whatever string the
	driver typically uses when registering a Symbolic Port Name
	string with the switch.
   
   The transport fields the request to create the vport, validates the
   fc_host has resources, then allocates and builds up the vport object,
   linking it to the indicated parent. The transport then calls the LLDD
   to create the vport, passing the pointer to the newly allocated object.
   The LLDD performs the NPIV step, and for FCP Initiator roles, calls
   scsi_host_alloc(), calls scsi_add_host(newshost, &vport->dev), calls
   scsi_add_host, initializes the fc_host entity, and from then on,
   acts normally on the scsi_host/fc_host bound to the vport. I recommend
   a separate fc_transport_template to be used for all vport Scsi_Hosts,
   which does not contain the callbacks for vport support.
   (I have sample code for anyone that is interested).

   Similarly for the delete path. A request is made, either by SGIOv4,
   or via a write to a "delete" sysfs variable, the transport locates
   the vport to be termianted, calls the LLDD to teardown the vport
   (which in turn should result in a fc_remove_host() and scsi_remove_host()
   on the vport's Scsi_host). After LLDD teardown, the transport tears
   down the vport object.

 - For the fc_host, the following attributes were added:
     fc_host npiv_vports_inuse:  indicates how many npiv ports have
        been instantiated on an fc_host.
     fc_host vport_create:  a write-only attr that is a "simple" create
        interface. A "<WWPN>:<WWNN>" string is written to the attribute,
	which creates a vport with the role of FCP_initiator.
     fc_host vport_delete: a write-only attr that is a "simple" delete
        interface. A "<WWPN>:<WWNN>" string is written to the attribute,
	to identify the vport to be terminated.

 - For the vport, the following attributes exist:
     vport_state: indicates the current state of the vport.
             If all has been successful, it is in an ACTIVE state. If it was
	     not able to be created, the state will reflect the error that
	     stopped it's creation - e.g. FABRIC_NOSUPPORT.
     vport_last_state:  As it is very useful to track prior
             failure reasons, this reports the previous state of the vport.
     node_name: 
     port_name: 
     roles: Indicates the FC4 role to be assumed on the vport.
     vport_id: reflects the creator's simple numeric handle
     vport_type: Reflects the type of virtual port (allow for NPIV-based
             vports, as well as Virtual Fabric-based vports). Only NPIV
	     type is supported currently.
     symbolic_name: the string, appended to the driver's symbolic port
             name string, which is registered with the switch to identify
	     the port.
     vport_delete:  a write-only attr to request the vport to be deleted.
     vport_disable: a write-only attr (1=disable, 0=enable) to request
             the driver to enable to disable the virtual port.

 - The fc_remove_host() functin is updated to remove the vports as well
   as the rports.

 - Port Type - expanded to include NPIV type
      Physical ports would set port_type to FC_PORTTYPE_NPORT, while the
      NPIV vports would set it to FC_PORTTYPE_NPIV.
 - Port Role - renamed the "rport" reference, as it applies to all ports


-- james s



diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2007-02-05 15:51:13.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2007-02-22 18:20:12.000000000 -0500
@@ -19,7 +19,7 @@
  *
  *  ========
  *
- *  Copyright (C) 2004-2005   James Smart, Emulex Corporation
+ *  Copyright (C) 2004-2007   James Smart, Emulex Corporation
  *    Rewrite for host, target, device, and remote port attributes,
  *    statistics, and service functions...
  *
@@ -38,6 +38,9 @@
 #include "scsi_priv.h"
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
+static int fc_vport_create(struct Scsi_Host *shost, int channel,
+	struct device *pdev, struct fc_vport_identifiers  *ids,
+	struct fc_vport **vport);
 
 /*
  * Redefine so that we can have same named attributes in the
@@ -91,10 +94,14 @@ static struct {
 	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
 	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
 	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection" },
+	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
 };
 fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
 #define FC_PORTTYPE_MAX_NAMELEN		50
 
+/* Reuse fc_port_type enum function for vport_type */
+#define get_fc_vport_type_name get_fc_port_type_name
+
 
 /* Convert fc_host_event_code values to ascii string name */
 static const struct {
@@ -140,6 +147,27 @@ fc_enum_name_search(port_state, fc_port_
 #define FC_PORTSTATE_MAX_NAMELEN	20
 

+/* Convert fc_vport_state values to ascii string name */
+static struct {
+	enum fc_vport_state	value;
+	char			*name;
+} fc_vport_state_names[] = {
+	{ FC_VPORT_UNKNOWN,		"Unknown" },
+	{ FC_VPORT_ACTIVE,		"Active" },
+	{ FC_VPORT_DISABLED,		"Disabled" },
+	{ FC_VPORT_LINKDOWN,		"Linkdown" },
+	{ FC_VPORT_NO_FABRIC_SUPP,	"No Fabric Support" },
+	{ FC_VPORT_NO_FABRIC_RSCS,	"No Fabric Resources" },
+	{ FC_VPORT_FABRIC_LOGOUT,	"Fabric Logout" },
+	{ FC_VPORT_FABRIC_REJ_WWN,	"Fabric Rejected WWN" },
+};
+fc_enum_name_search(vport_state, fc_vport_state, fc_vport_state_names)
+#define FC_VPORTSTATE_MAX_NAMELEN	24
+
+/* Reuse fc_vport_state enum function for vport_last_state */
+#define get_fc_vport_last_state_name get_fc_vport_state_name
+
+
 /* Convert fc_tgtid_binding_type values to ascii string name */
 static const struct {
 	enum fc_tgtid_binding_type	value;
@@ -218,16 +246,16 @@ show_fc_fc4s (char *buf, u8 *fc4_list)
 }
 

-/* Convert FC_RPORT_ROLE bit values to ascii string name */
+/* Convert FC_PORT_ROLE bit values to ascii string name */
 static const struct {
 	u32 			value;
 	char			*name;
-} fc_remote_port_role_names[] = {
-	{ FC_RPORT_ROLE_FCP_TARGET,	"FCP Target" },
-	{ FC_RPORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
-	{ FC_RPORT_ROLE_IP_PORT,	"IP Port" },
+} fc_port_role_names[] = {
+	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
+	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
+	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
 };
-fc_bitfield_name_search(remote_port_roles, fc_remote_port_role_names)
+fc_bitfield_name_search(port_roles, fc_port_role_names)
 
 /*
  * Define roles that are specific to port_id. Values are relative to ROLE_MASK.
@@ -251,7 +279,8 @@ static void fc_scsi_scan_rport(struct wo
  */
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	10
-#define FC_HOST_NUM_ATTRS	17
+#define FC_VPORT_NUM_ATTRS	10
+#define FC_HOST_NUM_ATTRS	21
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -277,6 +306,10 @@ struct fc_internal {
 	struct transport_container rport_attr_cont;
 	struct class_device_attribute private_rport_attrs[FC_RPORT_NUM_ATTRS];
 	struct class_device_attribute *rport_attrs[FC_RPORT_NUM_ATTRS + 1];
+
+	struct transport_container vport_attr_cont;
+	struct class_device_attribute private_vport_attrs[FC_VPORT_NUM_ATTRS];
+	struct class_device_attribute *vport_attrs[FC_VPORT_NUM_ATTRS + 1];
 };
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
@@ -330,6 +363,7 @@ static int fc_host_setup(struct transpor
 		sizeof(fc_host->supported_fc4s));
 	fc_host->supported_speeds = FC_PORTSPEED_UNKNOWN;
 	fc_host->maxframe_size = -1;
+	fc_host->max_npiv_vports = 0;
 	memset(fc_host->serial_number, 0,
 		sizeof(fc_host->serial_number));
 
@@ -347,8 +381,11 @@ static int fc_host_setup(struct transpor
 
 	INIT_LIST_HEAD(&fc_host->rports);
 	INIT_LIST_HEAD(&fc_host->rport_bindings);
+	INIT_LIST_HEAD(&fc_host->vports);
 	fc_host->next_rport_number = 0;
 	fc_host->next_target_id = 0;
+	fc_host->next_vport_number = 0;
+	fc_host->npiv_vports_inuse = 0;
 
 	snprintf(fc_host->work_q_name, KOBJ_NAME_LEN, "fc_wq_%d",
 		shost->host_no);
@@ -387,6 +424,16 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
 			       NULL);
 
 /*
+ * Setup and Remove actions for virtual ports are handled
+ * in the service functions below.
+ */
+static DECLARE_TRANSPORT_CLASS(fc_vport_class,
+			       "fc_vports",
+			       NULL,
+			       NULL,
+			       NULL);
+
+/*
  * Module Parameters
  */
 
@@ -584,6 +631,9 @@ static __init int fc_transport_init(void
 	error = transport_class_register(&fc_host_class);
 	if (error)
 		return error;
+	error = transport_class_register(&fc_vport_class);
+	if (error)
+		return error;
 	error = transport_class_register(&fc_rport_class);
 	if (error)
 		return error;
@@ -594,6 +644,7 @@ static void __exit fc_transport_exit(voi
 {
 	transport_class_unregister(&fc_transport_class);
 	transport_class_unregister(&fc_rport_class);
+	transport_class_unregister(&fc_vport_class);
 	transport_class_unregister(&fc_host_class);
 }
 
@@ -799,9 +850,9 @@ show_fc_rport_roles (struct class_device
 			return snprintf(buf, 30, "Unknown Fabric Entity\n");
 		}
 	} else {
-		if (rport->roles == FC_RPORT_ROLE_UNKNOWN)
+		if (rport->roles == FC_PORT_ROLE_UNKNOWN)
 			return snprintf(buf, 20, "unknown\n");
-		return get_fc_remote_port_roles_names(rport->roles, buf);
+		return get_fc_port_roles_names(rport->roles, buf);
 	}
 }
 static FC_CLASS_DEVICE_ATTR(rport, roles, S_IRUGO,
@@ -911,6 +962,250 @@ fc_starget_rd_attr(port_id, "0x%06x\n", 
 

 /*
+ * FC Virtual Port Attribute Management
+ */
+
+#define fc_vport_show_function(field, format_string, sz, cast)		\
+static ssize_t								\
+show_fc_vport_##field (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	if ((i->f->get_vport_##field) &&				\
+	    !(vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)))	\
+		i->f->get_vport_##field(vport);				\
+	return snprintf(buf, sz, format_string, cast vport->field); 	\
+}
+
+#define fc_vport_store_function(field)					\
+static ssize_t								\
+store_fc_vport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	int val;							\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	char *cp;							\
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	i->f->set_vport_##field(vport, val);				\
+	return count;							\
+}
+
+#define fc_vport_rd_attr(field, format_string, sz)			\
+	fc_vport_show_function(field, format_string, sz, )		\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			 show_fc_vport_##field, NULL)
+
+#define fc_vport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_vport_show_function(field, format_string, sz, (cast))	\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			  show_fc_vport_##field, NULL)
+
+#define fc_vport_rw_attr(field, format_string, sz)			\
+	fc_vport_show_function(field, format_string, sz, )		\
+	fc_vport_store_function(field)					\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
+			show_fc_vport_##field,				\
+			store_fc_vport_##field)
+
+#define fc_vport_rd_enum_attr(title, maxlen)				\
+static ssize_t								\
+show_fc_vport_##title (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	const char *name;						\
+	if ((i->f->get_##title) &&					\
+	    !(vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)))	\
+		return -EBUSY;						\
+	i->f->get_##title(vport);					\
+	name = get_fc_##title##_name(vport->title);			\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+static FC_CLASS_DEVICE_ATTR(vport, title, S_IRUGO,			\
+			show_fc_vport_##title, NULL)
+	/* Note: above function differs - function # built from field */
+
+
+#define fc_private_vport_show_function(field, format_string, sz, cast)	\
+static ssize_t								\
+show_fc_vport_##field (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	return snprintf(buf, sz, format_string, cast vport->field); 	\
+}
+
+#define fc_private_vport_store_u32_function(field)			\
+static ssize_t								\
+store_fc_vport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	u32 val;							\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	char *cp;							\
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	vport->field = val;						\
+	return count;							\
+}
+
+
+#define fc_private_vport_rd_attr(field, format_string, sz)		\
+	fc_private_vport_show_function(field, format_string, sz, )	\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			 show_fc_vport_##field, NULL)
+
+#define fc_private_vport_rd_attr_cast(field, format_string, sz, cast)	\
+	fc_private_vport_show_function(field, format_string, sz, (cast)) \
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			  show_fc_vport_##field, NULL)
+
+#define fc_private_vport_rw_u32_attr(field, format_string, sz)		\
+	fc_private_vport_show_function(field, format_string, sz, )	\
+	fc_private_vport_store_u32_function(field)			\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
+			show_fc_vport_##field,				\
+			store_fc_vport_##field)
+
+
+#define fc_private_vport_rd_enum_attr(title, maxlen)			\
+static ssize_t								\
+show_fc_vport_##title (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	const char *name;						\
+	name = get_fc_##title##_name(vport->title);			\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+static FC_CLASS_DEVICE_ATTR(vport, title, S_IRUGO,			\
+			show_fc_vport_##title, NULL)
+
+
+#define SETUP_VPORT_ATTRIBUTE_RD(field)					\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_vport_attrs[count].store = NULL;			\
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	if (i->f->get_##field)						\
+		count++
+	/* NOTE: Above MACRO differs: checks function not show bit */
+
+#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(field)				\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_vport_attrs[count].store = NULL;			\
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	count++
+
+#define SETUP_VPORT_ATTRIBUTE_WR(field)					\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	if (i->f->field)						\
+		count++
+	/* NOTE: Above MACRO differs: checks function */
+
+#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RW(field)				\
+{									\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	count++;							\
+}
+
+
+/* The FC Transport Virtual Port Attributes: */
+
+/* Fixed Virtual Port Attributes */
+
+/* Dynamic Virtual Port Attributes */
+
+fc_vport_rd_enum_attr(vport_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_vport_rd_enum_attr(vport_last_state, FC_VPORTSTATE_MAX_NAMELEN);
+
+
+/* Private Virtual Port Attributes */
+
+fc_private_vport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_private_vport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+
+static ssize_t
+show_fc_vport_roles (struct class_device *cdev, char *buf)
+{
+	struct fc_vport *vport = transport_class_to_vport(cdev);
+
+	if (vport->roles == FC_PORT_ROLE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	return get_fc_port_roles_names(vport->roles, buf);
+}
+static FC_CLASS_DEVICE_ATTR(vport, roles, S_IRUGO, show_fc_vport_roles, NULL);
+
+fc_private_vport_rw_u32_attr(vport_id, "0x%08x\n", 20);
+fc_private_vport_rd_enum_attr(vport_type, FC_PORTTYPE_MAX_NAMELEN);
+fc_private_vport_rd_attr(symbolic_name, "%s\n", FC_VPORT_SYMBOLIC_NAMELEN + 1);
+
+static ssize_t
+store_fc_vport_delete(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(cdev);
+	int stat;
+
+	stat = fc_vport_terminate(vport);
+	if (stat)
+		return stat;
+
+	return count;
+}
+static FC_CLASS_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
+			NULL, store_fc_vport_delete);
+
+
+/*
+ * Enable/Disable vport
+ *  Write "1" to disable, write "0" to enable
+ */
+static ssize_t
+store_fc_vport_disable(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(cdev);
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int stat;
+
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
+		return -EBUSY;
+
+	if (*buf == '0') {
+		if (vport->vport_state != FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else if (*buf == '1') {
+		if (vport->vport_state == FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else
+		return -EINVAL;
+
+	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
+	return stat ? stat : count;
+}
+static FC_CLASS_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
+			NULL, store_fc_vport_disable);
+
+
+/*
  * Host Attribute Management
  */
 
@@ -1002,6 +1297,13 @@ static FC_CLASS_DEVICE_ATTR(host, title,
 	if (i->f->show_host_##field)					\
 		count++
 
+#define SETUP_HOST_ATTRIBUTE_RD_NS(field)				\
+	i->private_host_attrs[count] = class_device_attr_host_##field;	\
+	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_host_attrs[count].store = NULL;			\
+	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	count++
+
 #define SETUP_HOST_ATTRIBUTE_RW(field)					\
 	i->private_host_attrs[count] = class_device_attr_host_##field;	\
 	if (!i->f->set_host_##field) {					\
@@ -1089,6 +1391,7 @@ fc_private_host_rd_attr_cast(port_name, 
 fc_private_host_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
 			     unsigned long long);
 fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_private_host_rd_attr(max_npiv_vports, "%u\n", 20);
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
 

@@ -1209,6 +1512,9 @@ store_fc_private_host_issue_lip(struct c
 static FC_CLASS_DEVICE_ATTR(host, issue_lip, S_IWUSR, NULL,
 			store_fc_private_host_issue_lip);
 
+fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);
+
+
 /*
  * Host Statistics Management
  */
@@ -1284,7 +1590,6 @@ fc_reset_statistics(struct class_device 
 static FC_CLASS_DEVICE_ATTR(host, reset_statistics, S_IWUSR, NULL,
 				fc_reset_statistics);
 
-
 static struct attribute *fc_statistics_attrs[] = {
 	&class_device_attr_host_seconds_since_last_reset.attr,
 	&class_device_attr_host_tx_frames.attr,
@@ -1315,6 +1620,148 @@ static struct attribute_group fc_statist
 	.attrs = fc_statistics_attrs,
 };
 
+
+/* Host Vport Attributes */
+
+static int
+fc_parse_wwn(const char *ns, u64 *nm)
+{
+	unsigned int i, j;
+	u8 wwn[8];
+
+	memset(wwn, 0, sizeof(wwn));
+
+	/* Validate and store the new name */
+	for (i=0, j=0; i < 16; i++) {
+		if ((*ns >= 'a') && (*ns <= 'f'))
+			j = ((j << 4) | ((*ns++ -'a') + 10));
+		else if ((*ns >= 'A') && (*ns <= 'F'))
+			j = ((j << 4) | ((*ns++ -'A') + 10));
+		else if ((*ns >= '0') && (*ns <= '9'))
+			j = ((j << 4) | (*ns++ -'0'));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	*nm = wwn_to_u64(wwn);
+
+	return 0;
+}
+
+
+/*
+ * "Short-cut" sysfs variable to create a new vport on a FC Host.
+ * Input is a string of the form "<WWPN>:<WWNN>". Other attributes
+ * will default to a NPIV-based FCP_Initiator w/ no vport_id;
+ * The WWNs are specified as hex characters, and may *not* contain
+ * any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fc_host_vport_create(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct fc_vport_identifiers vid;
+	struct fc_vport *vport;
+	unsigned int cnt=count;
+	int stat;
+
+printk("JWS-%s: enter\n", __FUNCTION__);
+	memset(&vid, 0, sizeof(vid));
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &vid.port_name);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &vid.node_name);
+	if (stat)
+		return stat;
+
+	vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+	/* vid.vport_id is already zero */
+	vid.vport_type = FC_PORTTYPE_NPIV;
+	/* vid.symbolic_name is already zero/NULL's */
+
+	stat = fc_vport_create(shost, 0 /*FIXME*/, &shost->shost_gendev, &vid, &vport);
+printk("JWS-%s: exit\n", __FUNCTION__);
+	memset(&vid, 0, sizeof(vid));
+	return stat ? stat : count;
+}
+static FC_CLASS_DEVICE_ATTR(host, vport_create, S_IWUSR, NULL,
+			store_fc_host_vport_create);
+
+
+/*
+ * "Short-cut" sysfs variable to delete a vport on a FC Host.
+ * Vport is identified by a string containing "<WWPN>:<WWNN>".
+ * The WWNs are specified as hex characters, and may *not* contain
+ * any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fc_host_vport_delete(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_vport *vport;
+	u64 wwpn, wwnn;
+	unsigned long flags;
+	unsigned int cnt=count;
+	int stat, match;
+
+printk("JWS-%s: enter\n", __FUNCTION__);
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &wwpn);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &wwnn);
+	if (stat)
+		return stat;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	match = 0;
+	list_for_each_entry(vport, &fc_host->vports, peers) {
+		if ((vport->channel == 0) && /*FIXME*/
+		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
+			match = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (!match)
+		return -ENODEV; 
+
+	stat = fc_vport_terminate(vport);
+printk("JWS-%s: exit\n", __FUNCTION__);
+	return stat ? stat : count;
+}
+static FC_CLASS_DEVICE_ATTR(host, vport_delete, S_IWUSR, NULL,
+			store_fc_host_vport_delete);
+
+
+
 static int fc_host_match(struct attribute_container *cont,
 			  struct device *dev)
 {
@@ -1386,6 +1833,43 @@ static int fc_rport_match(struct attribu
 }
 

+static void fc_vport_dev_release(struct device *dev)
+{
+	struct fc_vport *vport = dev_to_vport(dev);
+printk("JWS-%s: enter - release references on parent\n", __FUNCTION__);
+	put_device(dev->parent);		/* release kobj parent */
+	kfree(vport);
+printk("JWS-%s: exit\n", __FUNCTION__);
+}
+
+int scsi_is_fc_vport(const struct device *dev)
+{
+	return dev->release == fc_vport_dev_release;
+}
+EXPORT_SYMBOL(scsi_is_fc_vport);
+
+static int fc_vport_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct fc_vport *vport;
+	struct Scsi_Host *shost;
+	struct fc_internal *i;
+
+	if (!scsi_is_fc_vport(dev))
+		return 0;
+	vport = dev_to_vport(dev);
+
+	shost = vport_to_shost(vport);
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
+	    != &fc_host_class.class)
+		return 0;
+
+	i = to_fc_internal(shost->transportt);
+
+	return &i->vport_attr_cont.ac == cont;
+}
+
+
 /**
  * fc_timed_out - FC Transport I/O timeout intercept handler
  *
@@ -1471,6 +1955,11 @@ fc_attach_transport(struct fc_function_t
 	i->rport_attr_cont.ac.match = fc_rport_match;
 	transport_container_register(&i->rport_attr_cont);
 
+	i->vport_attr_cont.ac.attrs = &i->vport_attrs[0];
+	i->vport_attr_cont.ac.class = &fc_vport_class.class;
+	i->vport_attr_cont.ac.match = fc_vport_match;
+	transport_container_register(&i->vport_attr_cont);
+
 	i->f = ft;
 
 	/* Transport uses the shost workq for scsi scanning */
@@ -1504,6 +1993,10 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
 	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
 	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
+	if (ft->vport_create) {
+		SETUP_HOST_ATTRIBUTE_RD_NS(max_npiv_vports);
+		SETUP_HOST_ATTRIBUTE_RD_NS(npiv_vports_inuse);
+	}
 	SETUP_HOST_ATTRIBUTE_RD(serial_number);
 
 	SETUP_HOST_ATTRIBUTE_RD(port_id);
@@ -1519,6 +2012,10 @@ fc_attach_transport(struct fc_function_t
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
 	if (ft->issue_fc_host_lip)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
+	if (ft->vport_create)
+		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
+	if (ft->vport_delete)
+		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
 
 	BUG_ON(count > FC_HOST_NUM_ATTRS);
 
@@ -1544,6 +2041,25 @@ fc_attach_transport(struct fc_function_t
 
 	i->rport_attrs[count] = NULL;
 
+	/*
+	 * Setup Virtual Port Attributes.
+	 */
+	count=0;
+	SETUP_VPORT_ATTRIBUTE_RD(vport_state);
+	SETUP_VPORT_ATTRIBUTE_RD(vport_last_state);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(node_name);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(port_name);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(roles);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RW(vport_id);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_type);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(symbolic_name);
+	SETUP_VPORT_ATTRIBUTE_WR(vport_delete);
+	SETUP_VPORT_ATTRIBUTE_WR(vport_disable);
+
+	BUG_ON(count > FC_VPORT_NUM_ATTRS);
+
+	i->vport_attrs[count] = NULL;
+
 	return &i->t;
 }
 EXPORT_SYMBOL(fc_attach_transport);
@@ -1666,9 +2182,27 @@ fc_flush_devloss(struct Scsi_Host *shost
 void
 fc_remove_host(struct Scsi_Host *shost)
 {
+	struct fc_vport *vport, *next_vport;
 	struct fc_rport *rport, *next_rport;
 	struct workqueue_struct *work_q;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	unsigned long flags;
+	int stat;
+
+	/* Remove any vports */
+	list_for_each_entry_safe(vport, next_vport,
+			&fc_host->vports, peers) {
+		/* this must be called synchronously */
+		stat = fc_vport_terminate(vport);
+		if (stat)
+			dev_printk(KERN_ERR, vport->dev.parent,
+				"%s: %s could not be deleted created via "
+				"shost%d channel %d\n", __FUNCTION__,
+				vport->dev.bus_id, vport->shost->host_no,
+				vport->channel);
+	}
+
+	spin_lock_irqsave(shost->host_lock, flags);
 
 	/* Remove any remote ports */
 	list_for_each_entry_safe(rport, next_rport,
@@ -1685,6 +2219,8 @@ fc_remove_host(struct Scsi_Host *shost)
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/* flush all scan work items */
 	scsi_flush_work(shost);
 
@@ -1837,7 +2373,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	rport->number = fc_host->next_rport_number++;
-	if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 		rport->scsi_target_id = fc_host->next_target_id++;
 	else
 		rport->scsi_target_id = -1;
@@ -1862,7 +2398,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
-	if (rport->roles & FC_RPORT_ROLE_FCP_TARGET) {
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
 		/* initiate a scan of the target */
 		rport->flags |= FC_RPORT_SCAN_PENDING;
 		scsi_queue_work(shost, &rport->scan_work);
@@ -1987,7 +2523,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 				 * prior to the timer expiring. If the timer
 				 * fires, the target will be torn down.
 				 */
-				if (!(ids->roles & FC_RPORT_ROLE_FCP_TARGET))
+				if (!(ids->roles & FC_PORT_ROLE_FCP_TARGET))
 					return rport;
 
 				/* restart the target */
@@ -2066,7 +2602,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 				memset(rport->dd_data, 0,
 						fci->f->dd_fcrport_size);
 
-			if (rport->roles & FC_RPORT_ROLE_FCP_TARGET) {
+			if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
 				/* initiate a scan of the target */
 				rport->flags |= FC_RPORT_SCAN_PENDING;
 				scsi_queue_work(shost, &rport->scan_work);
@@ -2214,11 +2750,11 @@ fc_remote_port_rolechg(struct fc_rport  
 	int create = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (roles & FC_RPORT_ROLE_FCP_TARGET) {
+	if (roles & FC_PORT_ROLE_FCP_TARGET) {
 		if (rport->scsi_target_id == -1) {
 			rport->scsi_target_id = fc_host->next_target_id++;
 			create = 1;
-		} else if (!(rport->roles & FC_RPORT_ROLE_FCP_TARGET))
+		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
 			create = 1;
 	}
 
@@ -2286,7 +2822,7 @@ fc_timeout_deleted_rport(struct work_str
 	 * FCP target. If not, tear down the scsi_target on it.
 	 */
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
-	    !(rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
+	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
 		dev_printk(KERN_ERR, &rport->dev,
 			"blocked FC remote port time out: no longer"
 			" a FCP target, removing starget\n");
@@ -2330,7 +2866,7 @@ fc_timeout_deleted_rport(struct work_str
 	 */
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
-	rport->roles = FC_RPORT_ROLE_UNKNOWN;
+	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 
 	/* remove the identifiers that aren't used in the consisting binding */
@@ -2399,7 +2935,7 @@ fc_scsi_scan_rport(struct work_struct *w
 	unsigned long flags;
 
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
-	    (rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
 		scsi_scan_target(&rport->dev, rport->channel,
 			rport->scsi_target_id, SCAN_WILD_CARD, 1);
 	}
@@ -2410,6 +2946,210 @@ fc_scsi_scan_rport(struct work_struct *w
 }
 

+/**
+ * fc_vport_create - allocates and creates a FC virtual port.
+ * @shost:	scsi host the virtual port is connected to.
+ * @channel:	Channel on shost port connected to.
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ *
+ * Allocates and creates the vport structure, calls the parent host
+ * to instantiate the vport, the completes w/ class and sysfs creation.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+static int
+fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
+	struct fc_vport_identifiers  *ids, struct fc_vport **ret_vport)
+{
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *fci = to_fc_internal(shost->transportt);
+	struct fc_vport *vport;
+	struct device *dev;
+	unsigned long flags;
+	size_t size;
+	int error;
+
+	*ret_vport = NULL;
+
+printk("JWS-%s: enter\n", __FUNCTION__);
+	if ( ! fci->f->vport_create)
+		return -ENOENT;
+
+printk("JWS-%s: alloc vport\n", __FUNCTION__);
+	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
+	vport = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!vport)) {
+		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		return -ENOMEM;
+	}
+
+printk("JWS-%s: vport is 0x%p\n", __FUNCTION__, vport);
+	vport->vport_state = FC_VPORT_UNKNOWN;
+	vport->vport_last_state = FC_VPORT_UNKNOWN;
+	vport->node_name = ids->node_name;
+	vport->port_name = ids->port_name;
+	vport->roles = ids->roles;
+	vport->vport_id = ids->vport_id;
+	vport->vport_type = ids->vport_type;
+	if (fci->f->dd_fcvport_size)
+		vport->dd_data = &vport[1];
+printk("JWS-%s: vport data is 0x%p\n", __FUNCTION__, &vport[1]);
+	vport->shost = shost;
+	vport->channel = channel;
+	vport->flags = FC_VPORT_CREATING;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+printk("JWS-%s: inuse %d vs max %d\n", __FUNCTION__, fc_host->npiv_vports_inuse, fc_host->max_npiv_vports);
+	if (fc_host->npiv_vports_inuse >= fc_host->max_npiv_vports) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		kfree(vport);
+		return -ENOSPC;
+	}
+	fc_host->npiv_vports_inuse++;
+	vport->number = fc_host->next_vport_number++;
+	list_add_tail(&vport->peers, &fc_host->vports);
+	get_device(&shost->shost_gendev);	/* for fc_host->vport list */
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	dev = &vport->dev;
+printk("JWS-%s: H%d/C%d/Vport%d - device_initialize()\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	device_initialize(dev);			/* takes self reference */
+	dev->parent = get_device(pdev);		/* takes parent reference */
+	dev->release = fc_vport_dev_release;
+	sprintf(dev->bus_id, "vport-%d:%d-%d",
+		shost->host_no, channel, vport->number);
+printk("JWS-%s: H%d/C%d/Vport%d - transport_setup_device()\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	transport_setup_device(dev);
+
+printk("JWS-%s: H%d/C%d/Vport%d - device_add()\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	error = device_add(dev);
+	if (error) {
+		printk(KERN_ERR "FC Virtual Port device_add failed\n");
+		goto delete_vport;
+	}
+printk("JWS-%s: H%d/C%d/Vport%d - transport_device_add()\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	transport_add_device(dev);
+printk("JWS-%s: H%d/C%d/Vport%d - transport_configure_add()\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	transport_configure_device(dev);
+
+printk("JWS-%s: H%d/C%d/Vport%d - Call LLDD vport_create() - PN %lld NN %lld\n", __FUNCTION__, shost->host_no, channel, vport->number, vport->port_name, vport->node_name);
+	error = fci->f->vport_create(vport);
+	if (error) {
+		printk(KERN_ERR "FC Virtual Port LLDD Create failed\n");
+		goto delete_vport_all;
+	}
+
+printk("JWS-%s: H%d/C%d/Vport%d - SUCCESS\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	spin_lock_irqsave(shost->host_lock, flags);
+	vport->flags &= ~FC_VPORT_CREATING;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	dev_printk(KERN_NOTICE, pdev,
+			"%s created via shost%d channel %d", dev->bus_id,
+			shost->host_no, channel);
+
+	*ret_vport = vport;
+
+	return 0;
+
+delete_vport_all:
+printk("JWS-%s: H%d/C%d/Vport%d - FAIL - vport all\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	transport_remove_device(dev);
+	device_del(dev);
+delete_vport:
+printk("JWS-%s: H%d/C%d/Vport%d - FAIL - vport\n", __FUNCTION__, shost->host_no, channel, vport->number);
+	transport_destroy_device(dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&vport->peers);
+	put_device(&shost->shost_gendev);	/* for fc_host->vport list */
+	fc_host->npiv_vports_inuse--;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(dev->parent);
+	kfree(vport);
+
+	return error;
+}
+
+
+/**
+ * fc_vport_terminate - Admin App or LLDD requests termination of a vport
+ * @vport:	fc_vport to be terminated
+ *
+ * Calls the LLDD vport_delete() function, then deallocates and removes
+ * the vport from the shost and object tree.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+int
+fc_vport_terminate(struct fc_vport *vport)
+{
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct device *dev = &vport->dev;
+	unsigned long flags;
+	int stat;
+
+printk("JWS-%s: enter vport %p\n", __FUNCTION__, vport);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (vport->flags & FC_VPORT_CREATING) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+printk("JWS-%s: vport %p in create state \n", __FUNCTION__, vport);
+		return -EBUSY;
+	}
+	if (vport->flags & (FC_VPORT_DEL)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+printk("JWS-%s: vport %p in delete state \n", __FUNCTION__, vport);
+		return -EALREADY;
+	}
+	vport->flags |= FC_VPORT_DELETING;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+printk("JWS-%s: vport %p calling LLDD_delete\n", __FUNCTION__, vport);
+	if (i->f->vport_delete)
+		stat = i->f->vport_delete(vport);
+	else
+		stat = -ENOENT;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	vport->flags &= ~FC_VPORT_DELETING;
+	if (!stat) {
+printk("JWS-%s: vport %p LLDD_delete successful\n", __FUNCTION__, vport);
+		vport->flags |= FC_VPORT_DELETED;
+		list_del(&vport->peers);
+		fc_host->npiv_vports_inuse--;
+		put_device(&shost->shost_gendev);  /* for fc_host->vport list */
+	}
+else printk("JWS-%s: vport %p LLDD_delete failed - %d\n", __FUNCTION__, vport, stat);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (stat)
+		return stat;
+
+printk("JWS-%s: vport %p transport_remove_device()\n", __FUNCTION__, vport);
+	transport_remove_device(dev);
+printk("JWS-%s: vport %p device_del()\n", __FUNCTION__, vport);
+	device_del(dev);
+printk("JWS-%s: vport %p transport_destroy_device()\n", __FUNCTION__, vport);
+	transport_destroy_device(dev);
+
+	/*
+	 * Removing our self-reference should mean our
+	 * release function gets called, which will drop the remaining
+	 * parent reference and free the data structure.
+	 */
+printk("JWS-%s: vport %p remove self reference\n", __FUNCTION__, vport);
+	put_device(dev);			/* for self-reference */
+
+	return 0; /* SUCCESS */
+}
+
+
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2007-02-05 15:51:22.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2007-02-20 17:07:39.000000000 -0500
@@ -19,7 +19,7 @@
  *
  *  ========
  *
- *  Copyright (C) 2004-2005   James Smart, Emulex Corporation
+ *  Copyright (C) 2004-2007   James Smart, Emulex Corporation
  *    Rewrite for host, target, device, and remote port attributes,
  *    statistics, and service functions...
  *
@@ -62,8 +62,10 @@ enum fc_port_type {
 	FC_PORTTYPE_NLPORT,		/* (Public) Loop w/ FLPort */
 	FC_PORTTYPE_LPORT,		/* (Private) Loop w/o FLPort */
 	FC_PORTTYPE_PTP,		/* Point to Point w/ another NPort */
+	FC_PORTTYPE_NPIV,		/* VPORT based on NPIV */
 };
 
+
 /*
  * fc_port_state: If you alter this, you also need to alter scsi_transport_fc.c
  * (for the ascii descriptions).
@@ -83,6 +85,23 @@ enum fc_port_state {
 };
 

+/*
+ * fc_vport_state: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_vport_state {
+	FC_VPORT_UNKNOWN,
+	FC_VPORT_ACTIVE,
+	FC_VPORT_DISABLED,
+	FC_VPORT_LINKDOWN,
+	FC_VPORT_NO_FABRIC_SUPP,
+	FC_VPORT_NO_FABRIC_RSCS,
+	FC_VPORT_FABRIC_LOGOUT,
+	FC_VPORT_FABRIC_REJ_WWN,
+};
+
+
+
 /* 
  * FC Classes of Service
  * Note: values are not enumerated, as they can be "or'd" together
@@ -122,15 +141,123 @@ enum fc_tgtid_binding_type  {
 };
 
 /*
- * FC Remote Port Roles
+ * FC Port Roles
  * Note: values are not enumerated, as they can be "or'd" together
  * for reporting (e.g. report roles). If you alter this list,
  * you also need to alter scsi_transport_fc.c (for the ascii descriptions).
  */
-#define FC_RPORT_ROLE_UNKNOWN			0x00
-#define FC_RPORT_ROLE_FCP_TARGET		0x01
-#define FC_RPORT_ROLE_FCP_INITIATOR		0x02
-#define FC_RPORT_ROLE_IP_PORT			0x04
+#define FC_PORT_ROLE_UNKNOWN			0x00
+#define FC_PORT_ROLE_FCP_TARGET			0x01
+#define FC_PORT_ROLE_FCP_INITIATOR		0x02
+#define FC_PORT_ROLE_IP_PORT			0x04
+
+/* The following are for compatibility */
+#define FC_RPORT_ROLE_UNKNOWN			FC_PORT_ROLE_UNKNOWN
+#define FC_RPORT_ROLE_FCP_TARGET		FC_PORT_ROLE_FCP_TARGET
+#define FC_RPORT_ROLE_FCP_INITIATOR		FC_PORT_ROLE_FCP_INITIATOR
+#define FC_RPORT_ROLE_IP_PORT			FC_PORT_ROLE_IP_PORT
+
+
+
+/*
+ * fc_vport_identifiers: This set of data contains all elements
+ * to uniquely identify and instantiate a FC virtual port.
+ *
+ * Notes:
+ *   symbolic_name: The driver is to append the symbolic_name string data
+ *      to the symbolic_node_name data that it generates by default.
+ *      the resulting combination should then be registered with the switch.
+ *      It is expected that things like Xen may stuff a VM title into
+ *      this field.
+ */
+#define FC_VPORT_SYMBOLIC_NAMELEN		64
+struct fc_vport_identifiers {
+	u64 node_name;
+	u64 port_name;
+	u32 roles;
+	u32 vport_id;
+	enum fc_port_type vport_type;	/* only FC_PORTTYPE_NPIV allowed */ 
+	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
+};
+
+/* Macro for use in defining Virtual Port attributes */
+#define FC_VPORT_ATTR(_name,_mode,_show,_store)				\
+struct class_device_attribute class_device_attr_vport_##_name = 	\
+	__ATTR(_name,_mode,_show,_store)
+
+
+/*
+ * FC Virtual Port Attributes
+ *
+ * This structure exists for each FC port is a virtual FC port. Virtual
+ * ports share the physical link with the Physical port. Each virtual
+ * ports has a unique presense on the SAN, and may be instantiated via
+ * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
+ * unique presense, each vport has it's own view of the fabric, 
+ * authentication priviledge, and priorities.
+ *
+ * A virtual port may support 1 or more FC4 roles. Typically it is a
+ * FCP Initiator. It could be a FCP Target, or exist sole for an IP over FC
+ * roles. FC port attributes for the vport will be reported on any
+ * fc_host class object allocated for an FCP Initiator.
+ *
+ * --
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after receiving the fc_vport structure
+ * via the vport_create() call from the transport.
+ * The transport fully manages all get functions w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ * Private attributes are transport-managed values. They are fully
+ * managed by the transport w/o driver interaction.
+ */
+
+struct fc_vport {
+	/* Fixed Attributes */
+
+	/* Dynamic Attributes */
+	enum fc_vport_state vport_state;
+	enum fc_vport_state vport_last_state;
+
+	/* Private (Transport-managed) Attributes */
+	u64 node_name;
+	u64 port_name;
+	u32 roles;
+	u32 vport_id;		/* Admin Identifier for the vport */
+	enum fc_port_type vport_type;
+	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
+
+	/* exported data */
+	void *dd_data;			/* Used for driver-specific storage */
+
+	/* internal data */
+	struct Scsi_Host *shost;	/* Physical Port Parent */
+	unsigned int channel;
+	u32 number;
+	u8 flags;
+	struct list_head peers;
+	struct device dev;
+} __attribute__((aligned(sizeof(unsigned long))));
+
+/* bit field values for struct fc_vport "flags" field: */
+#define FC_VPORT_CREATING		0x01
+#define FC_VPORT_DELETING		0x02
+#define FC_VPORT_DELETED		0x04
+#define FC_VPORT_DEL			0x06	/* Any DELETE state */
+
+#define	dev_to_vport(d)				\
+	container_of(d, struct fc_vport, dev)
+#define transport_class_to_vport(classdev)	\
+	dev_to_vport(classdev->dev)
+#define vport_to_shost(v)			\
+	(v->shost)
+#define vport_to_shost_channel(v)		\
+	(v->channel)
+#define vport_to_parent(v)			\
+	(v->dev.parent)
 

 /*
@@ -147,6 +274,7 @@ struct fc_rport_identifiers {
 	u32 roles;
 };
 
+
 /* Macro for use in defining Remote Port attributes */
 #define FC_RPORT_ATTR(_name,_mode,_show,_store)				\
 struct class_device_attribute class_device_attr_rport_##_name = 	\
@@ -341,6 +469,7 @@ struct fc_host_attrs {
 	u8  supported_fc4s[FC_FC4_LIST_SIZE];
 	u32 supported_speeds;
 	u32 maxframe_size;
+	u16 max_npiv_vports;
 	char serial_number[FC_SERIAL_NUMBER_SIZE];
 
 	/* Dynamic Attributes */
@@ -359,8 +488,11 @@ struct fc_host_attrs {
 	/* internal data */
 	struct list_head rports;
 	struct list_head rport_bindings;
+	struct list_head vports;
 	u32 next_rport_number;
 	u32 next_target_id;
+	u32 next_vport_number;
+	u16 npiv_vports_inuse;
 
 	/* work queues for rport state manipulation */
 	char work_q_name[KOBJ_NAME_LEN];
@@ -386,6 +518,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_speeds)
 #define fc_host_maxframe_size(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->maxframe_size)
+#define fc_host_max_npiv_vports(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->max_npiv_vports)
 #define fc_host_serial_number(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->serial_number)
 #define fc_host_port_id(x)	\
@@ -410,10 +544,16 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->rports)
 #define fc_host_rport_bindings(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->rport_bindings)
+#define fc_host_vports(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->vports)
 #define fc_host_next_rport_number(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->next_rport_number)
 #define fc_host_next_target_id(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->next_target_id)
+#define fc_host_next_vport_number(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->next_vport_number)
+#define fc_host_npiv_vports_inuse(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->npiv_vports_inuse)
 #define fc_host_work_q_name(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->work_q_name)
 #define fc_host_work_q(x) \
@@ -450,8 +590,15 @@ struct fc_function_template {
 	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
 	void	(*terminate_rport_io)(struct fc_rport *);
 
+	void	(*get_vport_state)(struct fc_vport *);
+	void	(*get_vport_last_state)(struct fc_vport *);
+    	int  	(*vport_create)(struct fc_vport *);
+	int	(*vport_disable)(struct fc_vport *, bool);
+	int  	(*vport_delete)(struct fc_vport *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
+	u32	 			dd_fcvport_size;
 
 	/* 
 	 * The driver sets these to tell the transport class it
@@ -510,7 +657,7 @@ fc_remote_port_chkready(struct fc_rport 
 
 	switch (rport->port_state) {
 	case FC_PORTSTATE_ONLINE:
-		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
+		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
 			result = DID_IMM_RETRY << 16;
@@ -565,5 +712,6 @@ void fc_host_post_vendor_event(struct Sc
 	 *   be sure to read the Vendor Type and ID formatting requirements
 	 *   specified in scsi_netlink.h
 	 */
+int fc_vport_terminate(struct fc_vport *vport);
 
 #endif /* SCSI_TRANSPORT_FC_H */


