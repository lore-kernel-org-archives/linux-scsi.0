From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [RFC 1/2] scsi_transport_fc: Add HBAAPI v2 attributes to fc_rport
 structure.
Date: Thu, 28 Oct 2010 12:15:53 -0400
Message-ID: <alpine.LFD.2.00.1010281215020.2885@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:17594 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0J1QP4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 12:15:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds the following fc_rport attributes so that the FC transport
will export more attributes which can be read by HBAAPI compatible libraries:

- active_fc4s
- fabric_name
- maxframe_size
- port_type
- speed
- supported_fc4s
- supported_speeds
- symbolic_name

These attributes are fixed attributes and would be set by the low-level device
driver before it calls fc_remote_port_rolechg().
---
  drivers/scsi/scsi_transport_fc.c |   67 +++++++++++++++++++++++++++++++++++++-
  include/scsi/scsi_transport_fc.h |   25 +++++++++++---
  2 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..6af4602 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -311,7 +311,7 @@ static void fc_scsi_scan_rport(struct work_struct *work);
   * Increase these values if you add attributes
   */
  #define FC_STARGET_NUM_ATTRS 	3
-#define FC_RPORT_NUM_ATTRS	10
+#define FC_RPORT_NUM_ATTRS	17
  #define FC_VPORT_NUM_ATTRS	9
  #define FC_HOST_NUM_ATTRS	22

@@ -826,6 +826,57 @@ show_fc_rport_supported_classes (struct device *dev,
  static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
  		show_fc_rport_supported_classes, NULL);

+static ssize_t
+show_fc_rport_supported_fc4s(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	return (ssize_t)show_fc_fc4s(buf, rport->supported_fc4s);
+}
+static FC_DEVICE_ATTR(rport, supported_fc4s, S_IRUGO,
+		show_fc_rport_supported_fc4s, NULL);
+
+static ssize_t
+show_fc_rport_supported_speeds(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+
+	if (rport->supported_speeds  == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(rport->supported_speeds, buf);
+}
+static FC_DEVICE_ATTR(rport, supported_speeds, S_IRUGO,
+		show_fc_rport_supported_speeds, NULL);
+
+static ssize_t
+show_fc_rport_speed(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+
+	if (rport->speed == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(rport->speed, buf);
+}
+static FC_DEVICE_ATTR(rport, speed, S_IRUGO, show_fc_rport_speed, NULL);
+
+static ssize_t
+show_fc_rport_active_fc4s(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	return (ssize_t)show_fc_fc4s(buf, rport->active_fc4s);
+}
+static FC_DEVICE_ATTR(rport, active_fc4s, S_IRUGO, show_fc_rport_active_fc4s,
+		NULL);
+
+fc_private_rport_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
+fc_private_rport_rd_attr(symbolic_name, "%s\n", FC_SYMBOLIC_NAME_SIZE);
+fc_private_rport_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+
  /* Dynamic Remote Port Attributes */

  /*
@@ -2239,6 +2290,13 @@ fc_attach_transport(struct fc_function_template *ft)
  	count=0;
  	SETUP_RPORT_ATTRIBUTE_RD(maxframe_size);
  	SETUP_RPORT_ATTRIBUTE_RD(supported_classes);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(supported_fc4s);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(supported_speeds);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(speed);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(active_fc4s);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_type);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(symbolic_name);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(fabric_name);
  	SETUP_RPORT_ATTRIBUTE_RW(dev_loss_tmo);
  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(node_name);
  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
@@ -2581,6 +2639,13 @@ fc_rport_create(struct Scsi_Host *shost, int channel,

  	rport->maxframe_size = -1;
  	rport->supported_classes = FC_COS_UNSPECIFIED;
+	memset(rport->supported_fc4s, 0, sizeof(rport->supported_fc4s));
+	rport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+	rport->port_type = FC_PORTTYPE_UNKNOWN;
+	rport->speed = FC_PORTSPEED_UNKNOWN;
+	memset(rport->active_fc4s, 0, sizeof(rport->active_fc4s));
+	memset(rport->symbolic_name, 0, sizeof(rport->symbolic_name));
+	rport->fabric_name = -1;
  	rport->dev_loss_tmo = fc_host->dev_loss_tmo;
  	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
  	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 59816fe..33cf3df 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -320,10 +320,23 @@ struct device_attribute dev_attr_rport_##_name = 	\
   * managed by the transport w/o driver interaction.
   */

+/* Size arguments used for rport and host attributes */
+#define FC_FC4_LIST_SIZE		32
+#define FC_SYMBOLIC_NAME_SIZE		256
+#define FC_VERSION_STRING_SIZE		64
+#define FC_SERIAL_NUMBER_SIZE		80
+
  struct fc_rport {	/* aka fc_starget_attrs */
  	/* Fixed Attributes */
  	u32 maxframe_size;
  	u32 supported_classes;
+	u8  supported_fc4s[FC_FC4_LIST_SIZE];
+	u32 supported_speeds;
+	enum fc_port_type port_type;
+	u32 speed;
+	u8  active_fc4s[FC_FC4_LIST_SIZE];
+	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	u64 fabric_name;

  	/* Dynamic Attributes */
  	u32 dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
@@ -470,11 +483,6 @@ enum fc_host_event_code  {
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
@@ -680,6 +688,13 @@ struct fc_function_template {
  	/* remote port fixed attributes */
  	unsigned long	show_rport_maxframe_size:1;
  	unsigned long	show_rport_supported_classes:1;
+	unsigned long	show_rport_supported_fc4s:1;
+	unsigned long	show_rport_supported_speeds:1;
+	unsigned long	show_rport_port_type:1;
+	unsigned long   show_rport_speed:1;
+	unsigned long   show_rport_active_fc4s:1;
+	unsigned long   show_rport_symbolic_name:1;
+	unsigned long	show_rport_fabric_name:1;
  	unsigned long   show_rport_dev_loss_tmo:1;

  	/*
-- 
1.6.4.2

