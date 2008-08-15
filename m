From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Fixup desired DMA value for shared memory partitions
Date: Fri, 15 Aug 2008 10:48:47 -0500
Message-ID: <200808151549.m7FFnT3C026014@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:32946 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbYHOPtf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 11:49:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FFnW4l015707
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 11:49:32 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FFnUql071758
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 09:49:30 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FFnTXq026050
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 09:49:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


When running ibmvscsi in a shared memory partition, it must provide
a default value for the amount of DMA resources it will need in order to
perform reasonably well. This was being calculated in sectors rather than
bytes, as it should. This patch fixes this.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_entitlement_fix drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_entitlement_fix	2008-08-14 12:20:15.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-08-14 12:22:13.000000000 -0500
@@ -1636,7 +1636,7 @@ static unsigned long ibmvscsi_get_desire
 	unsigned long desired_io = max_requests * sizeof(union viosrp_iu);
 
 	/* add io space for sg data */
-	desired_io += (IBMVSCSI_MAX_SECTORS_DEFAULT *
+	desired_io += (IBMVSCSI_MAX_SECTORS_DEFAULT * 512 *
 	                     IBMVSCSI_CMDS_PER_LUN_DEFAULT);
 
 	return desired_io;
_
