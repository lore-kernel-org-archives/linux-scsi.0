From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 18:13:57 +0100
Message-ID: <20050119171357.GA16136@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49115 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261783AbVASROK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 12:14:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, greg@kroah.com

I think the hardware_version, firmware_version, rom_version and
driver_version don't belong into the FC transport class, there's
nothign specific to FC or even SCSI specific in them.

If you want these attributes talk to Greg about fiding a place in
the common driver model code for them.

p.s. I was surprised to find no Emulex copyright notices in the FC
transport implementation fields, I suspect you should add them.


--- 1.13/drivers/scsi/scsi_transport_fc.c	2005-01-12 17:08:53 +01:00
+++ edited/drivers/scsi/scsi_transport_fc.c	2005-01-19 18:17:03 +01:00
@@ -270,16 +270,8 @@ static int fc_setup_host_transport_attrs
 		sizeof(fc_host_symbolic_name(shost)));
 	fc_host_supported_speeds(shost) = FC_PORTSPEED_UNKNOWN;
 	fc_host_maxframe_size(shost) = -1;
-	memset(fc_host_hardware_version(shost), 0,
-		sizeof(fc_host_hardware_version(shost)));
-	memset(fc_host_firmware_version(shost), 0,
-		sizeof(fc_host_firmware_version(shost)));
 	memset(fc_host_serial_number(shost), 0,
 		sizeof(fc_host_serial_number(shost)));
-	memset(fc_host_opt_rom_version(shost), 0,
-		sizeof(fc_host_opt_rom_version(shost)));
-	memset(fc_host_driver_version(shost), 0,
-		sizeof(fc_host_driver_version(shost)));
 
 	fc_host_port_id(shost) = -1;
 	fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
@@ -546,11 +538,7 @@ fc_private_host_rd_attr_cast(node_name, 
 fc_private_host_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
 fc_private_host_rd_attr(symbolic_name, "%s\n", (FC_SYMBOLIC_NAME_SIZE +1));
 fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
-fc_private_host_rd_attr(hardware_version, "%s\n", (FC_VERSION_STRING_SIZE +1));
-fc_private_host_rd_attr(firmware_version, "%s\n", (FC_VERSION_STRING_SIZE +1));
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
-fc_private_host_rd_attr(opt_rom_version, "%s\n", (FC_VERSION_STRING_SIZE +1));
-fc_private_host_rd_attr(driver_version, "%s\n", (FC_VERSION_STRING_SIZE +1));
 
 
 /* Dynamic Host Attributes */
@@ -787,11 +775,7 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
 	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
 	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
-	SETUP_HOST_ATTRIBUTE_RD(hardware_version);
-	SETUP_HOST_ATTRIBUTE_RD(firmware_version);
 	SETUP_HOST_ATTRIBUTE_RD(serial_number);
-	SETUP_HOST_ATTRIBUTE_RD(opt_rom_version);
-	SETUP_HOST_ATTRIBUTE_RD(driver_version);
 
 	SETUP_HOST_ATTRIBUTE_RD(port_id);
 	SETUP_HOST_ATTRIBUTE_RD(port_type);
--- 1.9/include/scsi/scsi_transport_fc.h	2005-01-12 17:08:53 +01:00
+++ edited/include/scsi/scsi_transport_fc.h	2005-01-19 18:17:24 +01:00
@@ -197,11 +197,7 @@ struct fc_host_attrs {
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
 	u32 supported_speeds;
 	u32 maxframe_size;
-	char hardware_version[FC_VERSION_STRING_SIZE];
-	char firmware_version[FC_VERSION_STRING_SIZE];
 	char serial_number[FC_SERIAL_NUMBER_SIZE];
-	char opt_rom_version[FC_VERSION_STRING_SIZE];
-	char driver_version[FC_VERSION_STRING_SIZE];
 
 	/* Dynamic Attributes */
 	u32 port_id;
