From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 09/10] FC Transport: Add FC Port Attributes
Date: Mon, 22 Aug 2011 15:49:09 -0700
Message-ID: <20110822224909.1854.21481.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61235 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab1HVWtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:49:09 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds additional attributes to the FC Port
structure. These attributes are mostly FCoE related and
were chosen because they were members of 'struct fcoe_ctlr'
that is used in libfcoe.

Previous attributes on 'struct fc_port' were for fixed
features of the port. This patch adds "FIP controller"
members to 'strcut fc_port' and exposes them to the user
as r-- attributes.

An alternative aproach would be to create a "controller"
device that could be attached to the fc_host and exposed
as a separate device in sysfs.

The fc_host, fc_port and "controller" are all 1:1 in
regards to eachother. Is there a reason to keep these
devices separate? Should all port and controller attributes
be merged into the fc_host?

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/scsi_transport_fc.c |  180 +++++++++++++++++++++++++++++++-------
 include/scsi/scsi_transport_fc.h |   54 +++++++++++
 2 files changed, 202 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8a28be9..4ee4640 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -122,6 +122,17 @@ static int get_fc_##title##_match(const char *table_key,		\
 }
 
 static struct {
+	enum mac_mode value;
+	char          *name;
+} mac_mode_names[] = {
+	{ MAC_MODE_UNKNOWN, "Unknown" },
+	{ MAC_MODE_SPMA,    "SPMA" },
+	{ MAC_MODE_FPMA,    "FPMA" },
+};
+fc_enum_name_search(mac_mode, mac_mode, mac_mode_names)
+#define MAC_MODE_MAX_NAMELEN 50
+
+static struct {
 	enum fabric_state value;
 	char              *name;
 } fabric_state_names[] = {
@@ -334,7 +345,7 @@ static void fc_scsi_scan_rport(struct work_struct *work);
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
 #define FC_HOST_NUM_ATTRS	22
-#define FC_PORT_NUM_ATTRS       2
+#define FC_PORT_NUM_ATTRS       13
 #define FC_FABRIC_NUM_ATTRS     13
 
 struct fc_internal {
@@ -543,31 +554,6 @@ static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
 	return 0;
 }
 
-#define fc_private_port_show_function(field, format_string, sz, cast)	\
-static ssize_t								\
-show_fc_port_##field(struct device *dev,				\
-		     struct device_attribute *attr, char *buf)		\
-{									\
-	struct fc_port *port = transport_class_to_port(dev);		\
-	return snprintf(buf, sz, format_string, cast port->field);	\
-}
-
-#define fc_private_port_rd_attr(field, format_string, sz)		\
-	fc_private_port_show_function(field, format_string, sz, )	\
-	static FC_DEVICE_ATTR(port, field, S_IRUGO,			\
-		      show_fc_port_##field, NULL)
-
-#define SETUP_PORT_ATTRIBUTE_RD(field)					\
-	i->private_port_attrs[count] = device_attr_port_##field;	\
-	i->private_port_attrs[count].attr.mode = S_IRUGO;		\
-	i->private_port_attrs[count].store = NULL;			\
-	i->port_attrs[count] = &i->private_port_attrs[count];		\
-	if (i->f->show_port_##field)					\
-		count++
-
-fc_private_port_rd_attr(maxframe_size, "%u bytes\n", 20);
-
-
 #define fc_fabric_show_function(field, format_string, sz, cast)		\
 static ssize_t								\
 show_fc_fabric_##field(struct device *dev,				\
@@ -606,11 +592,11 @@ show_fc_fabric_##field(struct device *dev,				\
 	count++;							\
 }
 
-#define SETUP_PRIVATE_FABRIC_ATTRIBUTE_RD(field)                       \
-	i->private_fabric_attrs[count] = device_attr_fabric_##field;    \
-	i->private_fabric_attrs[count].attr.mode = S_IRUGO;             \
-	i->private_fabric_attrs[count].store = NULL;                    \
-	i->fabric_attrs[count] = &i->private_fabric_attrs[count];       \
+#define SETUP_PRIVATE_FABRIC_ATTRIBUTE_RD(field)			\
+	i->private_fabric_attrs[count] = device_attr_fabric_##field;	\
+	i->private_fabric_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_fabric_attrs[count].store = NULL;			\
+	i->fabric_attrs[count] = &i->private_fabric_attrs[count];	\
 	count++
 
 fc_fabric_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
@@ -693,13 +679,122 @@ static FC_DEVICE_ATTR(fabric, dev_loss_tmo, S_IRUGO | S_IWUSR,
 		      show_fc_fabric_dev_loss_tmo,
 		      store_fc_fabric_dev_loss_tmo);
 
+#define fc_port_show_function(field, format_string, sz, cast)		\
+static ssize_t								\
+show_fc_port_##field(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct fc_port *port = transport_class_to_port(dev);		\
+	struct fc_internal *i = to_fc_internal(port->t);		\
+	if (i->f->get_port_##field)					\
+		i->f->get_port_##field(port);				\
+	return snprintf(buf, sz, format_string,				\
+			cast fc_port_##field(port));			\
+}
+
+#define fc_port_rd_attr(field, format_string, sz)			\
+	fc_port_show_function(field, format_string, sz, )		\
+	static FC_DEVICE_ATTR(port, field, S_IRUGO,			\
+			      show_fc_port_##field, NULL)
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
 #define SETUP_PRIVATE_PORT_ATTRIBUTE_RW(field)				\
-{								\
+{									\
 	i->private_port_attrs[count] = device_attr_port_##field;	\
 	i->port_attrs[count] = &i->private_port_attrs[count];		\
 	count++;							\
 }
 
+#define SETUP_PRIVATE_PORT_ATTRIBUTE_RD(field)				\
+	i->private_port_attrs[count] = device_attr_port_##field;	\
+	i->private_port_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_port_attrs[count].store = NULL;			\
+	i->port_attrs[count] = &i->private_port_attrs[count];		\
+	count++
+
+fc_private_port_rd_attr(maxframe_size, "%u bytes\n", 20);
+
+fc_port_rd_attr(sol_time, "%lu\n", 20);
+fc_port_rd_attr(sel_time, "%lu\n", 20);
+fc_port_rd_attr(port_ka_time, "%lu\n", 20);
+fc_port_rd_attr(ctlr_ka_time, "%lu\n", 20);
+fc_port_rd_attr(probe_tries, "%u\n", 20);
+fc_port_rd_attr(port_dest_addr, "%pM\n", 20);
+fc_port_rd_attr(ctlr_src_addr, "%pM\n", 20);
+
+static ssize_t
+show_mac_mode(struct device *dev, struct device_attribute *attr,
+	      char *buf)
+{
+	struct fc_port *port = transport_class_to_port(dev);
+	const char *name;
+	name = get_fc_mac_mode_name(port->mode);
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, MAC_MODE_MAX_NAMELEN, "%s\n", name);
+}
+static FC_DEVICE_ATTR(port, mac_mode, S_IRUGO, show_mac_mode, NULL);
+
+static ssize_t
+show_fc_port_supported_classes(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct fc_port *port = transport_class_to_port(dev);
+
+	if (fc_port_supported_classes(port) == FC_COS_UNSPECIFIED)
+		return snprintf(buf, 20, "unspecified\n");
+
+	return get_fc_cos_names(fc_port_supported_classes(port), buf);
+}
+static FC_DEVICE_ATTR(port, supported_classes, S_IRUGO,
+		      show_fc_port_supported_classes, NULL);
+
+static ssize_t
+show_fc_port_supported_fc4s(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct fc_port *port = transport_class_to_port(dev);
+	return (ssize_t)show_fc_fc4s(buf, fc_port_supported_fc4s(port));
+}
+static FC_DEVICE_ATTR(port, supported_fc4s, S_IRUGO,
+		      show_fc_port_supported_fc4s, NULL);
+
+static ssize_t
+show_fc_port_supported_speeds(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct fc_port *port = transport_class_to_port(dev);
+
+	if (fc_port_supported_speeds(port) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fc_port_supported_speeds(port), buf);
+}
+static FC_DEVICE_ATTR(port, supported_speeds, S_IRUGO,
+		      show_fc_port_supported_speeds, NULL);
+
 static ssize_t
 store_fc_private_port_fab_dev_loss_tmo(struct device *dev,
 				       struct device_attribute *attr,
@@ -2514,7 +2609,19 @@ fc_attach_transport(struct fc_function_template *ft)
 	 * Setup FC Port Attributes.
 	 */
 	count = 0;
+	SETUP_PORT_ATTRIBUTE_RD(supported_classes);
+	SETUP_PORT_ATTRIBUTE_RD(supported_fc4s);
+	SETUP_PORT_ATTRIBUTE_RD(supported_speeds);
 	SETUP_PORT_ATTRIBUTE_RD(maxframe_size);
+	SETUP_PORT_ATTRIBUTE_RD(sol_time);
+	SETUP_PORT_ATTRIBUTE_RD(sel_time);
+	SETUP_PORT_ATTRIBUTE_RD(port_ka_time);
+	SETUP_PORT_ATTRIBUTE_RD(ctlr_ka_time);
+	SETUP_PORT_ATTRIBUTE_RD(probe_tries);
+	SETUP_PORT_ATTRIBUTE_RD(port_dest_addr);
+	SETUP_PORT_ATTRIBUTE_RD(ctlr_src_addr);
+
+	SETUP_PRIVATE_PORT_ATTRIBUTE_RD(mac_mode);
 	SETUP_PRIVATE_PORT_ATTRIBUTE_RW(fab_dev_loss_tmo);
 	BUG_ON(count > FC_PORT_NUM_ATTRS);
 
@@ -2535,6 +2642,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_FABRIC_ATTRIBUTE_RD(r_a_tov);
 	SETUP_FABRIC_ATTRIBUTE_RD(csp_flags);
 	SETUP_FABRIC_ATTRIBUTE_RD(selected);
+
 	SETUP_PRIVATE_FABRIC_ATTRIBUTE_RD(state);
 	SETUP_PRIVATE_FABRIC_ATTRIBUTE_RW(dev_loss_tmo);
 	BUG_ON(count > FC_FABRIC_NUM_ATTRS);
@@ -3957,6 +4065,14 @@ struct fc_port *fc_port_add(struct Scsi_Host *shost)
 	       sizeof(fcport->active_fc4s));
 	memset(fcport->serial_number, 0,
 	       sizeof(fcport->serial_number));
+	fcport->sol_time = 0;
+	fcport->sel_time = 0;
+	fcport->port_ka_time = 0;
+	fcport->ctlr_ka_time = 0;
+	fcport->probe_tries = 0;
+	memset(fcport->port_dest_addr, 0, sizeof(*fcport->port_dest_addr));
+	memset(fcport->ctlr_src_addr, 0, sizeof(*fcport->ctlr_src_addr));
+	fcport->mode = MAC_MODE_UNKNOWN;
 
 	/* Setup internal structures */
 	fcport->id = atomic_inc_return(&fc_port_next_id) - 1;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 81f96ba..b6df11e 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -193,6 +193,12 @@ struct fc_vport_identifiers {
 	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
 };
 
+enum mac_mode {
+	MAC_MODE_UNKNOWN = 0,
+	MAC_MODE_SPMA,
+	MAC_MODE_FPMA,
+};
+
 struct fc_port {
 	u32                             id;
 	struct device                   dev;
@@ -208,6 +214,16 @@ struct fc_port {
 	u8 active_fc4s[FC_FC4_LIST_SIZE];
 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
 
+	unsigned long sol_time;
+	unsigned long sel_time;
+	unsigned long port_ka_time;
+	unsigned long ctlr_ka_time;
+
+	enum mac_mode mode;
+	u8 probe_tries;
+	u8 port_dest_addr[ETH_ALEN]; /* Redundant? */
+	u8 ctlr_src_addr[ETH_ALEN]; /* Redundant? */
+
 	/*
 	 * FCoE supported_speeds and speed can change on
 	 * a link event so they are dynamic.
@@ -237,6 +253,22 @@ struct fc_port {
 	((x)->active_fc4s)
 #define fc_port_system_hostname(x)		\
 	((x)->system_hostname)
+#define fc_port_sol_time(x)			\
+	((x)->sol_time)
+#define fc_port_sel_time(x)			\
+	((x)->sel_time)
+#define fc_port_port_ka_time(x)			\
+	((x)->port_ka_time)
+#define fc_port_ctlr_ka_time(x)			\
+	((x)->ctlr_ka_time)
+#define fc_port_mode(x)				\
+	((x)->mode)
+#define fc_port_probe_tries(x)			\
+	((x)->probe_tries)
+#define fc_port_port_dest_addr(x)		\
+	((x)->port_dest_addr)
+#define fc_port_ctlr_src_addr(x)		\
+	((x)->ctlr_src_addr)
 #define fc_port_supported_speeds(x)		\
 	((x)->supported_speeds)
 #define fc_port_speed(x)			\
@@ -772,6 +804,14 @@ struct fc_function_template {
 	void	(*set_fabric_dev_loss_tmo)(struct fc_fabric *, u32);
 	void    (*get_fabric_selected)(struct fc_fabric *);
 
+	void    (*get_port_sol_time)(struct fc_port *);
+	void    (*get_port_sel_time)(struct fc_port *);
+	void    (*get_port_port_ka_time)(struct fc_port *);
+	void    (*get_port_ctlr_ka_time)(struct fc_port *);
+	void    (*get_port_probe_tries)(struct fc_port *);
+	void    (*get_port_port_dest_addr)(struct fc_port *);
+	void    (*get_port_ctlr_src_addr)(struct fc_port *);
+
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
 	void	(*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
 
@@ -828,8 +868,22 @@ struct fc_function_template {
 	 */
 
 	/* port fixed attributes */
+	unsigned long show_port_supported_classes:1;
+	unsigned long show_port_supported_fc4s:1;
+	unsigned long show_port_supported_speeds:1;
 	unsigned long show_port_maxframe_size:1;
 
+	/* port dynamic attributes */
+	unsigned long show_port_sol_time:1;
+	unsigned long show_port_sel_time:1;
+	unsigned long show_port_port_ka_time:1;
+	unsigned long show_port_ctlr_ka_time:1;
+	unsigned long show_port_map_dest:1;
+	unsigned long show_port_spma:1;
+	unsigned long show_port_probe_tries:1;
+	unsigned long show_port_port_dest_addr:1;
+	unsigned long show_port_ctlr_src_addr:1;
+
 	/* fabric fixed attributes */
 	int  (*fabric_match)(struct fc_fabric *, struct fc_fabric *);
 	unsigned long show_fabric_fabric_name:1;

