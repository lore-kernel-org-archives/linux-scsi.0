From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mptsas: fix phy identifiers
Date: Mon, 17 Oct 2005 15:40:52 +0200
Message-ID: <20051017134052.GA7216@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60346 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751325AbVJQNk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 09:40:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This patch from Eric fixes handling of the phy identifiers in mptsas.
I've split it up from his bigger patch as it should go into 2.6.14
still.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c	2005-10-14 11:59:29.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptsas.c	2005-10-17 14:57:28.000000000 +0200
@@ -257,8 +257,8 @@
 	printk("SAS Address=0x%llX\n", le64_to_cpu(sas_address));
 	printk("Target ID=0x%X\n", pg0->TargetID);
 	printk("Bus=0x%X\n", pg0->Bus);
-	printk("PhyNum=0x%X\n", pg0->PhyNum);
-	printk("AccessStatus=0x%X\n", le16_to_cpu(pg0->AccessStatus));
+	printk("Parent Phy Num=0x%X\n", pg0->PhyNum);
+	printk("Access Status=0x%X\n", le16_to_cpu(pg0->AccessStatus));
 	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
 	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
 	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
@@ -270,7 +270,7 @@
 	printk("---- SAS EXPANDER PAGE 1 ------------\n");
 
 	printk("Physical Port=0x%X\n", pg1->PhysicalPort);
-	printk("PHY Identifier=0x%X\n", pg1->Phy);
+	printk("PHY Identifier=0x%X\n", pg1->PhyIdentifier);
 	printk("Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate);
 	printk("Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate);
 	printk("Hardware Link Rate=0x%X\n", pg1->HwLinkRate);
@@ -604,7 +604,7 @@
 	mptsas_print_expander_pg1(buffer);
 
 	/* save config data */
-	phy_info->phy_id = buffer->Phy;
+	phy_info->phy_id = buffer->PhyIdentifier;
 	phy_info->port_id = buffer->PhysicalPort;
 	phy_info->negotiated_link_rate = buffer->NegotiatedLinkRate;
 	phy_info->programmed_link_rate = buffer->ProgrammedLinkRate;
@@ -825,6 +825,8 @@
 		mptsas_sas_device_pg0(ioc, &port_info->phy_info[i].identify,
 			(MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE <<
 			 MPI_SAS_DEVICE_PGAD_FORM_SHIFT), handle);
+		port_info->phy_info[i].identify.phy_id =
+		    port_info->phy_info[i].phy_id;
 		handle = port_info->phy_info[i].identify.handle;
 
 		if (port_info->phy_info[i].attached.handle) {
@@ -881,6 +883,8 @@
 				(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
 				 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
 				port_info->phy_info[i].identify.handle);
+			port_info->phy_info[i].identify.phy_id =
+			    port_info->phy_info[i].phy_id;
 		}
 
 		if (port_info->phy_info[i].attached.handle) {
