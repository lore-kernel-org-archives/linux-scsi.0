From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/2] fusion :  shost max_id not set in VMWare guest os
Date: Mon, 19 Mar 2007 10:30:43 -0600
Message-ID: <20070319163043.GA28055@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33553 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030371AbXCSQhq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 12:37:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

[PATCH 1/2] fusion :  shost max_id not set in VMWare guest os

In vmware guest os with emulated LSI 53c1030, the port facts config page is
not having MaxDevices initialized to 16 devices. Instead its set to zero.
Thereforewhen driver loads, no devices are scanned for from scsi_scan_host.
Prior to the3.04.04 driver, shost max_id was set to hard coded value MPT_MAX_SCSI_DEVICES. After that release, support for greater than 255 targets was added, and the driver was taking the target count from the port facts instead.  With this patch we will restore the hard coded values for SPI, but at the same time use the settingsneeded for SAS and Fibre Channel.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-03-15 18:20:01.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-03-18 12:05:54.000000000 -0600
@@ -2570,8 +2570,19 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 	pfacts->MaxPersistentIDs = le16_to_cpu(pfacts->MaxPersistentIDs);
 	pfacts->MaxLanBuckets = le16_to_cpu(pfacts->MaxLanBuckets);
 
-	max_id = (ioc->bus_type == SAS) ? pfacts->PortSCSIID :
-	    pfacts->MaxDevices;
+	switch (ioc->bus_type) {
+	case SAS:
+		max_id = pfacts->PortSCSIID;
+		break;
+	case FC:
+		max_id = pfacts->MaxDevices;
+		break;
+	case SPI:
+	default:
+		max_id = MPT_MAX_SCSI_DEVICES;
+		break;
+	}
+
 	ioc->devices_per_bus = (max_id > 255) ? 256 : max_id;
 	ioc->number_of_buses = (ioc->devices_per_bus < 256) ? 1 : max_id/256;
 
