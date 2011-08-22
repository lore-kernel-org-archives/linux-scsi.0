From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 07/10] FC Transport: Add Fabric Attributes
Date: Mon, 22 Aug 2011 15:48:58 -0700
Message-ID: <20110822224858.1854.80404.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33367 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1HVWs7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:48:59 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds some FC Fabric attributes. They're added
in the same style that all other FC Transport attributes
are defined.

The interesting attributes are 'dev_loss_tmo' and 'selected'.

It might be desirable to make 'dev_loss_tmo' a module parameter
as the rport's device loss timeout value is.

It might be desireable to make 'selected' writable with a
callback to the LLD. This would allow the user to override
the kernel's selection.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/scsi_transport_fc.c |  222 ++++++++++++++++++++++++++++++++++----
 include/scsi/scsi_transport_fc.h |   43 +++++++
 2 files changed, 241 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 86600e0..8a28be9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -60,8 +60,12 @@ static void fc_bsg_goose_queue(struct fc_rport *);
  * dev_loss_tmo: the default number of seconds that the FC transport
  *   should insulate the loss of a remote port.
  *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
+ *
+ * fab_dev_loss_tmo: the default number of seconds that the FC transport
+ *   should insulate the loss of a fabric.
  */
 static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
+static unsigned int fc_fab_dev_loss_tmo = 600;          /* seconds */
 
 module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
@@ -71,6 +75,13 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
 		 " fast_io_fail_tmo is not set.");
 
+module_param_named(fab_dev_loss_tmo, fc_fab_dev_loss_tmo,
+		   uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(fab_dev_loss_tmo,
+		 "Maximum number of seconds that the FC transport should"
+		 " insulate the loss of a fabric. Once this value is"
+		 " exceeded, the fabric is removed.");
+
 /*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
@@ -110,6 +121,16 @@ static int get_fc_##title##_match(const char *table_key,		\
 	return 1; /* failure */						\
 }
 
+static struct {
+	enum fabric_state value;
+	char              *name;
+} fabric_state_names[] = {
+	{ FC_FABRICSTATE_UNKNOWN,      "Unknown" },
+	{ FC_FABRICSTATE_DISCONNECTED, "Disconnected" },
+	{ FC_FABRICSTATE_CONNECTED,    "Connected" },
+};
+fc_enum_name_search(fabric_state, fabric_state, fabric_state_names)
+#define FABRIC_STATE_MAX_NAMELEN 50
 
 /* Convert fc_port_type values to ascii string name */
 static struct {
@@ -131,7 +152,6 @@ fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
 /* Reuse fc_port_type enum function for vport_type */
 #define get_fc_vport_type_name get_fc_port_type_name
 
-
 /* Convert fc_host_event_code values to ascii string name */
 static const struct {
 	enum fc_host_event_code		value;
@@ -314,8 +334,8 @@ static void fc_scsi_scan_rport(struct work_struct *work);
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
 #define FC_HOST_NUM_ATTRS	22
-#define FC_PORT_NUM_ATTRS       1
-#define FC_FABRIC_NUM_ATTRS     1
+#define FC_PORT_NUM_ATTRS       2
+#define FC_FABRIC_NUM_ATTRS     13
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -504,6 +524,25 @@ static DECLARE_TRANSPORT_CLASS(fc_fabric_class,
 			       NULL,
 			       NULL);
 
+/*
+ * dev_loss_tmo attribute
+ */
+static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
+{
+	char *cp;
+
+	*val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) || (*val < 0))
+		return -EINVAL;
+	/*
+	 * Check for overflow; dev_loss_tmo is u32
+	 */
+	if (*val > UINT_MAX)
+		return -EINVAL;
+
+	return 0;
+}
+
 #define fc_private_port_show_function(field, format_string, sz, cast)	\
 static ssize_t								\
 show_fc_port_##field(struct device *dev,				\
@@ -545,7 +584,12 @@ show_fc_fabric_##field(struct device *dev,				\
 #define fc_fabric_rd_attr_cast(field, format_string, sz, cast)		\
 	fc_fabric_show_function(field, format_string, sz, (cast))	\
 	static FC_DEVICE_ATTR(fabric, field, S_IRUGO,			\
-		      show_fc_fabric_##field, NULL)
+			      show_fc_fabric_##field, NULL)
+
+#define fc_fabric_rd_attr(field, format_string, sz)			\
+	fc_fabric_show_function(field, format_string, sz, )		\
+	static FC_DEVICE_ATTR(fabric, field, S_IRUGO,			\
+			      show_fc_fabric_##field, NULL)
 
 #define SETUP_FABRIC_ATTRIBUTE_RD(field)				\
 	i->private_fabric_attrs[count] = device_attr_fabric_##field;	\
@@ -555,8 +599,135 @@ show_fc_fabric_##field(struct device *dev,				\
 	if (i->f->show_fabric_##field)					\
 		count++
 
+#define SETUP_PRIVATE_FABRIC_ATTRIBUTE_RW(field)			\
+{									\
+	i->private_fabric_attrs[count] = device_attr_fabric_##field;	\
+	i->fabric_attrs[count] = &i->private_fabric_attrs[count];	\
+	count++;							\
+}
+
+#define SETUP_PRIVATE_FABRIC_ATTRIBUTE_RD(field)                       \
+	i->private_fabric_attrs[count] = device_attr_fabric_##field;    \
+	i->private_fabric_attrs[count].attr.mode = S_IRUGO;             \
+	i->private_fabric_attrs[count].store = NULL;                    \
+	i->fabric_attrs[count] = &i->private_fabric_attrs[count];       \
+	count++
+
 fc_fabric_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+fc_fabric_rd_attr_cast(switch_name, "0x%llx\n", 20, unsigned long long);
+fc_fabric_rd_attr(pri, "%u\n", 20);
+fc_fabric_rd_attr(e_d_tov, "%u\n", 20);
+fc_fabric_rd_attr(r_a_tov, "%u\n", 20);
+fc_fabric_rd_attr(csp_flags, "%d\n", 20);
+fc_fabric_rd_attr(selected, "%u\n", 20);
+
+#define fc_private_fabric_show_function(field, format_string, sz, cast)	\
+static ssize_t								\
+show_fc_fabric_##field(struct device *dev,				\
+		       struct device_attribute *attr, char *buf)	\
+{									\
+	struct fc_fabric *fabric = transport_class_to_fabric(dev);	\
+	return snprintf(buf, sz, format_string, cast fabric->field);	\
+}
+
+#define fc_private_fabric_rd_attr(field, format_string, sz)		\
+	fc_private_fabric_show_function(field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fabric, field, S_IRUGO,			\
+			      show_fc_fabric_##field, NULL)
+
+fc_private_fabric_rd_attr(fc_map, "%x\n", 20);
+fc_private_fabric_rd_attr(vfid, "%d\n", 20);
+fc_private_fabric_rd_attr(mac, "%pM\n", 20);
+fc_private_fabric_rd_attr(fka_period, "%d\n", 20);
+
+static ssize_t show_fabric_state(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct fc_fabric *fabric = transport_class_to_fabric(dev);
+	const char *name;
+	name = get_fc_fabric_state_name(fabric->state);
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, FABRIC_STATE_MAX_NAMELEN, "%s\n", name);
+}
+static FC_DEVICE_ATTR(fabric, state, S_IRUGO, show_fabric_state, NULL);
+
+static int fc_fabric_set_dev_loss_tmo(struct fc_fabric *fabric,
+				      unsigned long val)
+{
+	struct Scsi_Host *shost = fabric_to_shost(fabric);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	if (fabric->state == FC_FABRICSTATE_DISCONNECTED)
+		return -EBUSY;
+	/*
+	 * Check for overflow; dev_loss_tmo is u32
+	 */
+	if (val > UINT_MAX)
+		return -EINVAL;
+
+	i->f->set_fabric_dev_loss_tmo(fabric, val);
+	return 0;
+}
+
+fc_fabric_show_function(dev_loss_tmo, "%d\n", 20, )
+static ssize_t
+store_fc_fabric_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct fc_fabric *fabric = transport_class_to_fabric(dev);
+	unsigned long val;
+	int rc;
+
+	rc = fc_str_to_dev_loss(buf, &val);
+	if (rc)
+		return rc;
+
+	rc = fc_fabric_set_dev_loss_tmo(fabric, val);
+	if (rc)
+		return rc;
+	return count;
+}
+static FC_DEVICE_ATTR(fabric, dev_loss_tmo, S_IRUGO | S_IWUSR,
+		      show_fc_fabric_dev_loss_tmo,
+		      store_fc_fabric_dev_loss_tmo);
+
+#define SETUP_PRIVATE_PORT_ATTRIBUTE_RW(field)				\
+{								\
+	i->private_port_attrs[count] = device_attr_port_##field;	\
+	i->port_attrs[count] = &i->private_port_attrs[count];		\
+	count++;							\
+}
+
+static ssize_t
+store_fc_private_port_fab_dev_loss_tmo(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct fc_port *port = transport_class_to_port(dev);
+	struct Scsi_Host *shost = port_to_shost(port);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fabric *fabric;
+	unsigned long val, flags;
+	int rc;
 
+	rc = fc_str_to_dev_loss(buf, &val);
+	if (rc)
+		return rc;
+
+	fc_port_fab_dev_loss_tmo(port) = val;
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(fabric, &fc_host->fabrics, peers)
+		fc_fabric_set_dev_loss_tmo(fabric, val);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return count;
+}
+
+fc_private_port_show_function(fab_dev_loss_tmo, "%d\n", 20, );
+static FC_DEVICE_ATTR(port, fab_dev_loss_tmo, S_IRUGO | S_IWUSR,
+		      show_fc_port_fab_dev_loss_tmo,
+		      store_fc_private_port_fab_dev_loss_tmo);
 
 /*
  * Netlink Infrastructure
@@ -917,25 +1088,6 @@ static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
 
 /* Dynamic Remote Port Attributes */
 
-/*
- * dev_loss_tmo attribute
- */
-static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
-{
-	char *cp;
-
-	*val = simple_strtoul(buf, &cp, 0);
-	if ((*cp && (*cp != '\n')) || (*val < 0))
-		return -EINVAL;
-	/*
-	 * Check for overflow; dev_loss_tmo is u32
-	 */
-	if (*val > UINT_MAX)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int fc_rport_set_dev_loss_tmo(struct fc_rport *rport,
 				     unsigned long val)
 {
@@ -2363,6 +2515,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	 */
 	count = 0;
 	SETUP_PORT_ATTRIBUTE_RD(maxframe_size);
+	SETUP_PRIVATE_PORT_ATTRIBUTE_RW(fab_dev_loss_tmo);
 	BUG_ON(count > FC_PORT_NUM_ATTRS);
 
 	i->port_attrs[count] = NULL;
@@ -2372,6 +2525,18 @@ fc_attach_transport(struct fc_function_template *ft)
 	 */
 	count = 0;
 	SETUP_FABRIC_ATTRIBUTE_RD(fabric_name);
+	SETUP_FABRIC_ATTRIBUTE_RD(switch_name);
+	SETUP_FABRIC_ATTRIBUTE_RD(fc_map);
+	SETUP_FABRIC_ATTRIBUTE_RD(vfid);
+	SETUP_FABRIC_ATTRIBUTE_RD(mac);
+	SETUP_FABRIC_ATTRIBUTE_RD(pri);
+	SETUP_FABRIC_ATTRIBUTE_RD(fka_period);
+	SETUP_FABRIC_ATTRIBUTE_RD(e_d_tov);
+	SETUP_FABRIC_ATTRIBUTE_RD(r_a_tov);
+	SETUP_FABRIC_ATTRIBUTE_RD(csp_flags);
+	SETUP_FABRIC_ATTRIBUTE_RD(selected);
+	SETUP_PRIVATE_FABRIC_ATTRIBUTE_RD(state);
+	SETUP_PRIVATE_FABRIC_ATTRIBUTE_RW(dev_loss_tmo);
 	BUG_ON(count > FC_FABRIC_NUM_ATTRS);
 
 	i->fabric_attrs[count] = NULL;
@@ -3785,7 +3950,7 @@ struct fc_port *fc_port_add(struct Scsi_Host *shost)
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 	fcport->supported_speeds = FC_PORTSPEED_UNKNOWN;
 	fcport->speed = FC_PORTSPEED_UNKNOWN;
-	fcport->fab_dev_loss_tmo = 600; /* default to 10mins */
+	fcport->fab_dev_loss_tmo = fc_fab_dev_loss_tmo;
 	memset(fcport->supported_fc4s, 0,
 	       sizeof(fcport->supported_fc4s));
 	memset(fcport->active_fc4s, 0,
@@ -3958,6 +4123,15 @@ struct fc_fabric *fc_fabric_create(struct Scsi_Host *shost,
 	INIT_WORK(&fabric->fabric_delete_work, fc_fabric_final_delete);
 	INIT_DELAYED_WORK(&fabric->dev_loss_work, fc_timeout_deleted_fabric);
 	fabric->dev_loss_tmo = port->fab_dev_loss_tmo;
+	fabric->fabric_name = -1;
+	fabric->switch_name = -1;
+	fabric->fc_map = -1;
+	fabric->vfid = -1;
+	memset(fabric->mac, 0, sizeof(*fabric->mac));
+	fabric->pri = -1;
+	fabric->fka_period = -1;
+	fabric->r_a_tov = -1;
+	fabric->e_d_tov = -1;
 
 	/* Setup internal structures */
 	fabric->id = atomic_inc_return(&fc_fabric_next_id) - 1;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 4195b77..81f96ba 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -28,6 +28,7 @@
 #define SCSI_TRANSPORT_FC_H
 
 #include <linux/sched.h>
+#include <linux/if_ether.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_netlink.h>
 
@@ -274,6 +275,16 @@ struct fc_fabric {
 
 	/* Fixed Attributes */
 	u64 fabric_name;
+	u64 switch_name;
+	u32 fc_map;
+	u16 vfid;
+	u8  mac[ETH_ALEN];
+	u8 pri;
+	u32 fka_period;
+	unsigned int e_d_tov;
+	unsigned int r_a_tov;
+	u16 csp_flags;
+	u8 selected;
 };
 
 #define dev_to_fabric(d)				\
@@ -290,10 +301,24 @@ static inline void *fc_fabric_priv(const struct fc_fabric *fcfabric)
 	dev_to_port((x)->dev.parent)
 #define fabric_to_shost(x)			\
 	port_to_shost(fc_fabric_to_port(x))
+#define fc_fabric_state(x)			\
+	((x)->state)
 #define fc_fabric_fabric_name(x)		\
 	((x)->fabric_name)
+#define fc_fabric_switch_name(x)		\
+	((x)->switch_name)
+#define fc_fabric_pri(x)			\
+	((x)->pri)
+#define fc_fabric_e_d_tov(x)			\
+	((x)->e_d_tov)
+#define fc_fabric_r_a_tov(x)			\
+	((x)->r_a_tov)
+#define fc_fabric_csp_flags(x)			\
+	((x)->csp_flags)
 #define fc_fabric_dev_loss_tmo(x)		\
 	((x)->dev_loss_tmo)
+#define fc_fabric_selected(x)			\
+	((x)->selected)
 
 /*
  * FC Virtual Port Attributes
@@ -738,6 +763,14 @@ struct fc_bsg_job {
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
 	void	(*get_fabric_fabric_name)(struct fc_fabric *);
+	void	(*get_fabric_switch_name)(struct fc_fabric *);
+	void    (*get_fabric_pri)(struct fc_fabric *);
+	void    (*get_fabric_e_d_tov)(struct fc_fabric *);
+	void    (*get_fabric_r_a_tov)(struct fc_fabric *);
+	void    (*get_fabric_csp_flags)(struct fc_fabric *);
+	void    (*get_fabric_dev_loss_tmo)(struct fc_fabric *);
+	void	(*set_fabric_dev_loss_tmo)(struct fc_fabric *, u32);
+	void    (*get_fabric_selected)(struct fc_fabric *);
 
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
 	void	(*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
@@ -800,7 +833,17 @@ struct fc_function_template {
 	/* fabric fixed attributes */
 	int  (*fabric_match)(struct fc_fabric *, struct fc_fabric *);
 	unsigned long show_fabric_fabric_name:1;
+	unsigned long show_fabric_switch_name:1;
+	unsigned long show_fabric_fc_map:1;
+	unsigned long show_fabric_vfid:1;
+	unsigned long show_fabric_mac:1;
+	unsigned long show_fabric_pri:1;
+	unsigned long show_fabric_fka_period:1;
 	unsigned long show_fabric_dev_loss_tmo:1;
+	unsigned long show_fabric_e_d_tov:1;
+	unsigned long show_fabric_r_a_tov:1;
+	unsigned long show_fabric_csp_flags:1;
+	unsigned long show_fabric_selected:1;
 
 	/* remote port fixed attributes */
 	unsigned long	show_rport_maxframe_size:1;

