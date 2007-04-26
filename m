From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/8] ipr: Handle UA on disk array following an adapter reset
Date: Thu, 26 Apr 2007 16:00:08 -0500
Message-ID: <200704262101.l3QL1KIJ010441@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:60329 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbXDZVBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 17:01:23 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QL1MVD005729
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:22 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1MGa067496
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 15:01:22 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1MmG010611
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 15:01:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


On certain ipr RAID adapters, which are capable of multi-initiator
configurations, the disk array, or VSET, resources will be in a POR
Unit Attention state following an adapter reset. In order for the
midlayer to handle the UA, I must report a bus reset to the logical
disk array bus at the end of an adapter reset.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_vset_ua_handling drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_vset_ua_handling	2007-04-26 09:17:31.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:17:31.000000000 -0500
@@ -5379,6 +5379,7 @@ static int ipr_ioa_reset_done(struct ipr
 			ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_CONFIG_CHANGE, hostrcb);
 	}
 
+	scsi_report_bus_reset(ioa_cfg->host, IPR_VSET_BUS);
 	dev_info(&ioa_cfg->pdev->dev, "IOA initialized.\n");
 
 	ioa_cfg->reset_retries = 0;
_
