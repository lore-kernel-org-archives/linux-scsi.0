From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - scsi_transport_sas.c - display port identifier
Date: Thu, 26 Jan 2006 16:20:02 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1FF10C@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24724 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030226AbWAZXUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 18:20:37 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@SteelEye.com

On Thursday, January 26, 2006 12:35 PM, Christoph Hellwig wrote:

> The port identifier for a given phy could change when phys 
> are removed from
> one port and added to another.  So doing this for the phy is probably
> a bad idea.  Doing it for the rphy should be fine because 
> that object gets
> removed and recreated in that case.
> 

Agreed, that makes sense.  

Here is new patch with only rphy displaying the port_identifier.


Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

--- b/drivers/scsi/scsi_transport_sas.c	2006-01-18 10:07:05.000000000
-0700
+++ a/drivers/scsi/scsi_transport_sas.c	2006-01-26 15:52:38.000000000
-0700
@@ -377,7 +377,7 @@
 /**
  * sas_phy_alloc  --  allocates and initialize a SAS PHY structure
  * @parent:	Parent device
- * @number:	Port number
+ * @number:	Phy index
  *
  * Allocates an SAS PHY structure.  It will be added in the device tree
  * below the device specified by @parent, which has to be either a
Scsi_Host
@@ -595,8 +595,8 @@
 	device_initialize(&rphy->dev);
 	rphy->dev.parent = get_device(&parent->dev);
 	rphy->dev.release = sas_rphy_release;
-	sprintf(rphy->dev.bus_id, "rphy-%d:%d",
-		shost->host_no, parent->number);
+	sprintf(rphy->dev.bus_id, "rphy-%d:%d-%d",
+		shost->host_no, parent->port_identifier,
parent->number);
 	transport_setup_device(&rphy->dev);
 
 	return rphy;
