From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] fc transport: add permanent_port_name fc_host attribute
Date: Fri, 13 Jan 2006 02:16:54 +0100
Message-ID: <20060113011654.GA6036@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:5507 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1161627AbWAMBRJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 20:17:09 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id k0D1H7Ol221458
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 01:17:07 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0D1H7wA200238
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 02:17:07 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k0D1H7Xg011639
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 02:17:07 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>, James Smart <james.smart@emulex.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

This is a revised patch to add an attribute for the port_name of
the physical port.


Regards,

Andreas


fc transport: add permanent_port_name fc_host attribute

Add fc_host attribute permanent_port_name which is
used to show the port name of the primary port -
the port that initially logged into the fabric.

For a virtual port (registered via the primary port with
FDISC command) it is useful to know not only its (virtual)
port name but also the permanent port name.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/scsi/scsi_transport_fc.c |    4 ++++
 include/scsi/scsi_transport_fc.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

87f9f797aed03adf2109841290f15d74acbbe70b
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 685b997..625f4a6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -295,6 +295,7 @@ static int fc_host_setup(struct transpor
 	 */
 	fc_host_node_name(shost) = -1;
 	fc_host_port_name(shost) = -1;
+	fc_host_permanent_port_name(shost) = -1;
 	fc_host_supported_classes(shost) = FC_COS_UNSPECIFIED;
 	memset(fc_host_supported_fc4s(shost), 0,
 		sizeof(fc_host_supported_fc4s(shost)));
@@ -795,6 +796,8 @@ static FC_CLASS_DEVICE_ATTR(host, suppor
 
 fc_private_host_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
 fc_private_host_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+fc_private_host_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
+			     unsigned long long);
 fc_private_host_rd_attr(symbolic_name, "%s\n", (FC_SYMBOLIC_NAME_SIZE +1));
 fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
@@ -1160,6 +1163,7 @@ fc_attach_transport(struct fc_function_t
 	count=0;
 	SETUP_HOST_ATTRIBUTE_RD(node_name);
 	SETUP_HOST_ATTRIBUTE_RD(port_name);
+	SETUP_HOST_ATTRIBUTE_RD(permanent_port_name);
 	SETUP_HOST_ATTRIBUTE_RD(supported_classes);
 	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
 	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 394f14a..cf3fec8 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -303,6 +303,7 @@ struct fc_host_attrs {
 	/* Fixed Attributes */
 	u64 node_name;
 	u64 port_name;
+	u64 permanent_port_name;
 	u32 supported_classes;
 	u8  supported_fc4s[FC_FC4_LIST_SIZE];
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
@@ -338,6 +339,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->node_name)
 #define fc_host_port_name(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->port_name)
+#define fc_host_permanent_port_name(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->permanent_port_name)
 #define fc_host_supported_classes(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_classes)
 #define fc_host_supported_fc4s(x)	\
@@ -426,6 +429,7 @@ struct fc_function_template {
 	/* host fixed attributes */
 	unsigned long	show_host_node_name:1;
 	unsigned long	show_host_port_name:1;
+	unsigned long	show_host_permanent_port_name:1;
 	unsigned long	show_host_supported_classes:1;
 	unsigned long	show_host_supported_fc4s:1;
 	unsigned long	show_host_symbolic_name:1;
-- 
0.99.9n-g5a22
