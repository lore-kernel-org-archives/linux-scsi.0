From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] fc transport: new attributes for NPIV
Date: Thu, 5 Jan 2006 10:01:56 +0100
Message-ID: <20060105090155.GA11208@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:39663 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1752121AbWAEJCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 04:02:25 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id k05920Ws127012
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 09:02:02 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k059207M122854
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 10:02:00 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k05920nA015220
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 10:02:00 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

From: Andreas Herrmann <aherrman@de.ibm.com>

[PATCH] fc transport: new attributes for NPIV

With NPort-Id-Virtualization (NPIV) "virtual" ports can be
registered at an FC switch using one physical FC port.
Using FDISC an already logged in port can login additional
ports to the Fabric. Each addtional port gets assigned a
new destination ID (see FDISC description in FC-FS).
For problem determination it is useful to know not only the
virtual port name and its associated port id but also the
port name and port id of the physical port - the port that
initially logged into the Fabric.

I suggest to add new attributes (physical_port_name and
physical_port_id) to scsi_transport_fc.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/scsi/scsi_transport_fc.c |    7 +++++++
 include/scsi/scsi_transport_fc.h |    9 +++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

8f1f64a50977add786fdd14a0cbc13aae4bfa89f
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 685b997..365529a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -295,6 +295,7 @@ static int fc_host_setup(struct transpor
 	 */
 	fc_host_node_name(shost) = -1;
 	fc_host_port_name(shost) = -1;
+	fc_host_physical_port_name(shost) = -1;
 	fc_host_supported_classes(shost) = FC_COS_UNSPECIFIED;
 	memset(fc_host_supported_fc4s(shost), 0,
 		sizeof(fc_host_supported_fc4s(shost)));
@@ -306,6 +307,7 @@ static int fc_host_setup(struct transpor
 		sizeof(fc_host_serial_number(shost)));
 
 	fc_host_port_id(shost) = -1;
+	fc_host_physical_port_id(shost) = -1;
 	fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 	fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
 	memset(fc_host_active_fc4s(shost), 0,
@@ -795,6 +797,8 @@ static FC_CLASS_DEVICE_ATTR(host, suppor
 
 fc_private_host_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
 fc_private_host_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+fc_private_host_rd_attr_cast(physical_port_name, "0x%llx\n", 20,
+			     unsigned long long);
 fc_private_host_rd_attr(symbolic_name, "%s\n", (FC_SYMBOLIC_NAME_SIZE +1));
 fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
@@ -835,6 +839,7 @@ static FC_CLASS_DEVICE_ATTR(host, speed,
 
 
 fc_host_rd_attr(port_id, "0x%06x\n", 20);
+fc_host_rd_attr(physical_port_id, "0x%06x\n", 20);
 fc_host_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
 fc_host_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
 fc_host_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
@@ -1160,6 +1165,7 @@ fc_attach_transport(struct fc_function_t
 	count=0;
 	SETUP_HOST_ATTRIBUTE_RD(node_name);
 	SETUP_HOST_ATTRIBUTE_RD(port_name);
+	SETUP_HOST_ATTRIBUTE_RD(physical_port_name);
 	SETUP_HOST_ATTRIBUTE_RD(supported_classes);
 	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
 	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
@@ -1168,6 +1174,7 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(serial_number);
 
 	SETUP_HOST_ATTRIBUTE_RD(port_id);
+	SETUP_HOST_ATTRIBUTE_RD(physical_port_id);
 	SETUP_HOST_ATTRIBUTE_RD(port_type);
 	SETUP_HOST_ATTRIBUTE_RD(port_state);
 	SETUP_HOST_ATTRIBUTE_RD(active_fc4s);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 394f14a..13a8171 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -303,6 +303,7 @@ struct fc_host_attrs {
 	/* Fixed Attributes */
 	u64 node_name;
 	u64 port_name;
+	u64 physical_port_name;
 	u32 supported_classes;
 	u8  supported_fc4s[FC_FC4_LIST_SIZE];
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
@@ -312,6 +313,7 @@ struct fc_host_attrs {
 
 	/* Dynamic Attributes */
 	u32 port_id;
+	u32 physical_port_id;
 	enum fc_port_type port_type;
 	enum fc_port_state port_state;
 	u8  active_fc4s[FC_FC4_LIST_SIZE];
@@ -338,6 +340,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->node_name)
 #define fc_host_port_name(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->port_name)
+#define fc_host_physical_port_name(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->physical_port_name)
 #define fc_host_supported_classes(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_classes)
 #define fc_host_supported_fc4s(x)	\
@@ -352,6 +356,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->serial_number)
 #define fc_host_port_id(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->port_id)
+#define fc_host_physical_port_id(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->physical_port_id)
 #define fc_host_port_type(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->port_type)
 #define fc_host_port_state(x)	\
@@ -388,6 +394,7 @@ struct fc_function_template {
 	void 	(*get_starget_port_id)(struct scsi_target *);
 
 	void 	(*get_host_port_id)(struct Scsi_Host *);
+	void 	(*get_host_physical_port_id)(struct Scsi_Host *);
 	void	(*get_host_port_type)(struct Scsi_Host *);
 	void	(*get_host_port_state)(struct Scsi_Host *);
 	void	(*get_host_active_fc4s)(struct Scsi_Host *);
@@ -426,6 +433,7 @@ struct fc_function_template {
 	/* host fixed attributes */
 	unsigned long	show_host_node_name:1;
 	unsigned long	show_host_port_name:1;
+	unsigned long	show_host_physical_port_name:1;
 	unsigned long	show_host_supported_classes:1;
 	unsigned long	show_host_supported_fc4s:1;
 	unsigned long	show_host_symbolic_name:1;
@@ -434,6 +442,7 @@ struct fc_function_template {
 	unsigned long	show_host_serial_number:1;
 	/* host dynamic attributes */
 	unsigned long	show_host_port_id:1;
+	unsigned long	show_host_physical_port_id:1;
 	unsigned long	show_host_port_type:1;
 	unsigned long	show_host_port_state:1;
 	unsigned long	show_host_active_fc4s:1;
-- 
0.99.9n-g58e3
