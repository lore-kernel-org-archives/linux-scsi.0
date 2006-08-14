From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc transport: convert fc_host symbolic_name attribute to a
	dynamic attribute
Date: Mon, 14 Aug 2006 08:20:25 -0400
Message-ID: <1155558025.3734.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53674 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1752019AbWHNMUc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 08:20:32 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ECKUCQ005646
	for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 05:20:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-08-08 10:11:53.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-08-14 08:13:09.000000000 -0400
@@ -815,7 +815,6 @@ fc_private_host_rd_attr_cast(node_name, 
 fc_private_host_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
 fc_private_host_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
 			     unsigned long long);
-fc_private_host_rd_attr(symbolic_name, "%s\n", (FC_SYMBOLIC_NAME_SIZE +1));
 fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
 
@@ -858,6 +857,7 @@ fc_host_rd_attr(port_id, "0x%06x\n", 20)
 fc_host_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
 fc_host_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
 fc_host_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+fc_host_rd_attr(symbolic_name, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
 
 
 /* Private Host Attributes */
@@ -1223,7 +1223,6 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(permanent_port_name);
 	SETUP_HOST_ATTRIBUTE_RD(supported_classes);
 	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
-	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
 	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
 	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
 	SETUP_HOST_ATTRIBUTE_RD(serial_number);
@@ -1234,6 +1233,7 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(active_fc4s);
 	SETUP_HOST_ATTRIBUTE_RD(speed);
 	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
+	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
 
 	/* Transport-managed attributes */
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-08-08 10:12:16.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2006-08-14 08:13:09.000000000 -0400
@@ -409,6 +409,7 @@ struct fc_function_template {
 	void	(*get_host_active_fc4s)(struct Scsi_Host *);
 	void	(*get_host_speed)(struct Scsi_Host *);
 	void	(*get_host_fabric_name)(struct Scsi_Host *);
+	void	(*get_host_symbolic_name)(struct Scsi_Host *);
 
 	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
 	void	(*reset_fc_host_stats)(struct Scsi_Host *);
@@ -445,7 +446,6 @@ struct fc_function_template {
 	unsigned long	show_host_permanent_port_name:1;
 	unsigned long	show_host_supported_classes:1;
 	unsigned long	show_host_supported_fc4s:1;
-	unsigned long	show_host_symbolic_name:1;
 	unsigned long	show_host_supported_speeds:1;
 	unsigned long	show_host_maxframe_size:1;
 	unsigned long	show_host_serial_number:1;
@@ -456,6 +456,7 @@ struct fc_function_template {
 	unsigned long	show_host_active_fc4s:1;
 	unsigned long	show_host_speed:1;
 	unsigned long	show_host_fabric_name:1;
+	unsigned long	show_host_symbolic_name:1;
 };
 
 


