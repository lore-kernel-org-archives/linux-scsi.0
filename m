From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsi: Correct DMA mapping leak
Date: Thu, 22 Jan 2009 13:40:09 -0600
Message-ID: <20090122194009.GB14767@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60930 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbZAVTkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 14:40:11 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0MJeTum022532
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 14:40:29 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0MJeA37192372
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 14:40:10 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0MJe9ek019956
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 14:40:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Brian King <brking@linux.vnet.ibm.com>

The ibmvscsi client driver is not unmapping the SCSI command after
encountering a DMA mapping error while trying to map an indirect
scattergather list for the event pool.  This leads to a leak of DMA
entitlement that could result in the device failing future DMA operations
in a CMO environment.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -432,6 +432,7 @@ static int map_sg_data(struct scsi_cmnd 
 				sdev_printk(KERN_ERR, cmd->device,
 				            "Can't allocate memory "
 				            "for indirect table\n");
+			scsi_dma_unmap(cmd);
 			return 0;
 		}
 	}
