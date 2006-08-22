From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] Add SATA support to libsas
Date: Tue, 22 Aug 2006 12:26:45 -0500
Message-ID: <1156267605.19615.4.camel@mulgrave.il.steeleye.com>
References: <44DBE943.4080303@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:4055 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S932290AbWHVR0w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 13:26:52 -0400
In-Reply-To: <44DBE943.4080303@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 2006-08-10 at 19:19 -0700, Darrick J. Wong wrote:
> +static inline void sas_mark_dev_sata(struct domain_device *dev)
> +{
> +       dev->rphy->identify = dev->port->phy->identify;
> +       dev->rphy->identify.initiator_port_protocols =
> SAS_PROTOCOL_SATA;
> +       dev->rphy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
> +       dev->rphy->identify.device_type = SAS_END_DEVICE;
> +       memcpy(&dev->rphy->identify.sas_address, dev->sas_addr,
> SAS_ADDR_SIZE);
> +}

Actually, this is wrong: you can't memcpy from dev->sas_addr to
identify.sas_addr the former is a big endian u8[8] and the latter is a
u64.  However, the function is unnecessary anyway.  We already have a
sas_fill_in_rphy that does all of this.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2006-08-21 21:30:38.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2006-08-21 21:49:22.000000000 -0500
@@ -398,15 +398,6 @@
 	spin_unlock_irqrestore(&port->phy_list_lock, flags);
 }
 
-static inline void sas_mark_dev_sata(struct domain_device *dev)
-{
-	dev->rphy->identify = dev->port->phy->identify;
-	dev->rphy->identify.initiator_port_protocols = SAS_PROTOCOL_SATA;
-	dev->rphy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
-	dev->rphy->identify.device_type = SAS_END_DEVICE;
-	memcpy(&dev->rphy->identify.sas_address, dev->sas_addr, SAS_ADDR_SIZE);
-}
-
 #define ATA_IDENTIFY_DEV         0xEC
 #define ATA_IDENTIFY_PACKET_DEV  0xA1
 #define ATA_SET_FEATURES         0xEF
@@ -490,7 +481,7 @@
 	sas_satl_register_dev(dev);
 	*/
 	
-	sas_mark_dev_sata(dev);
+	sas_fill_in_rphy(dev, dev->rphy);
 
 	res = sas_rphy_add(dev->rphy);
 	if (res)


