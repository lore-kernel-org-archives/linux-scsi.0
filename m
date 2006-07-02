From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] mptsas: use unnumbered port API and remove driver port
	tracking
Date: Sun, 02 Jul 2006 11:12:30 -0500
Message-ID: <1151856750.3558.28.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16589 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932536AbWGBQMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 12:12:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This allows us to be rid of the machinery in mptsas for creating and
tracking port numbers.  Since mptsas is merely inventing the numbers,
the SAS transport class may as well do it instead.

James

Index: BUILD-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptbase.h	2006-07-01 08:52:38.000000000 -0500
+++ BUILD-2.6/drivers/message/fusion/mptbase.h	2006-07-01 08:52:43.000000000 -0500
@@ -644,7 +644,6 @@
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
-	u8		port_serial_number;
 } MPT_ADAPTER;
 
 /*
Index: BUILD-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptsas.c	2006-07-01 08:52:38.000000000 -0500
+++ BUILD-2.6/drivers/message/fusion/mptsas.c	2006-07-01 08:59:09.000000000 -0500
@@ -144,7 +144,6 @@
  * Specific details on ports, wide/narrow
  */
 struct mptsas_portinfo_details{
-	u8	port_id; 	/* port number provided to transport */
 	u16	num_phys;	/* number of phys belong to this port */
 	u64	phy_bitmask; 	/* TODO, extend support for 255 phys */
 	struct sas_rphy *rphy;	/* transport layer rphy object */
@@ -352,7 +351,7 @@
 
 	dsaswideprintk((KERN_DEBUG "%s: [%p]: port=%02d num_phys=%02d "
 	    	"bitmask=0x%016llX\n",
-		__FUNCTION__, port_details, port_details->port_id,
+		__FUNCTION__, port_details, port_details->port->port_identifier,
 		port_details->num_phys, port_details->phy_bitmask));
 
 	for (i = 0; i < port_info->num_phys; i++, phy_info++) {
@@ -464,7 +463,7 @@
 		dsaswideprintk((KERN_DEBUG
 			"%s: [%p]: port=%d deleting phy = %d\n",
 			__FUNCTION__, port_details,
-			port_details->port_id, i));
+			port_details->port->port_identifier, i));
 		port_details->num_phys--;
 		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
@@ -493,7 +492,6 @@
 				goto out;
 			port_details->num_phys = 1;
 			port_details->port_info = port_info;
-			port_details->port_id = ioc->port_serial_number++;
 			if (phy_info->phy_id < 64 )
 				port_details->phy_bitmask |=
 				    (1 << phy_info->phy_id);
@@ -525,12 +523,8 @@
 				    mptsas_get_port(phy_info_cmp);
 				port_details->starget =
 				    mptsas_get_starget(phy_info_cmp);
-				port_details->port_id =
-					phy_info_cmp->port_details->port_id;
 				port_details->num_phys =
 					phy_info_cmp->port_details->num_phys;
-//				port_info->port_serial_number--;
-				ioc->port_serial_number--;
 				if (!phy_info_cmp->port_details->num_phys)
 					kfree(phy_info_cmp->port_details);
 			} else
@@ -557,7 +551,7 @@
 			"%s: [%p]: phy_id=%02d port_id=%02d num_phys=%02d "
 		    	"bitmask=0x%016llX\n",
 			__FUNCTION__,
-			port_details, i, port_details->port_id,
+			port_details, i, port_details->port->port_identifier,
 			port_details->num_phys, port_details->phy_bitmask));
 		dsaswideprintk((KERN_DEBUG"\t\tport = %p rphy=%p\n",
 			port_details->port, port_details->rphy));
@@ -1608,11 +1602,10 @@
 	if (phy_info->sas_port_add_phy) {
 
 		if (!port) {
-			port = sas_port_alloc(dev,
-			    phy_info->port_details->port_id);
+			port = sas_port_alloc_num(dev);
 			dsaswideprintk((KERN_DEBUG
 			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
-			    port, dev, phy_info->port_details->port_id));
+			    port, dev, port->port_identifier));
 			if (!port) {
 				error = -ENOMEM;
 				goto out;


