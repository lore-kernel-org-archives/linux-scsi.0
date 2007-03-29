From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 02/12] ipr: Remove auto RAID create module parameter
Date: Thu, 29 Mar 2007 12:42:47 -0500
Message-ID: <200703291742.l2THglM6018053@d03av04.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47082 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934278AbXC2Rmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:42:50 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THgmXC012376
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:42:48 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THgmx7170560
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:42:48 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THgmZl018106
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:42:48 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Remove the auto RAID 0 array creation module parameter, since
support for this function has been removed from the firmware.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    5 -----
 1 files changed, 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_remove_auto_create drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_remove_auto_create	2007-03-23 15:21:41.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-23 15:21:41.000000000 -0500
@@ -92,7 +92,6 @@ static unsigned int ipr_fastfail = 0;
 static unsigned int ipr_transop_timeout = 0;
 static unsigned int ipr_enable_cache = 1;
 static unsigned int ipr_debug = 0;
-static int ipr_auto_create = 1;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -159,8 +158,6 @@ module_param_named(enable_cache, ipr_ena
 MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
 module_param_named(debug, ipr_debug, int, 0);
 MODULE_PARM_DESC(debug, "Enable device driver debugging logging. Set to 1 to enable. (default: 0)");
-module_param_named(auto_create, ipr_auto_create, int, 0);
-MODULE_PARM_DESC(auto_create, "Auto-create single device RAID 0 arrays when initialized (default: 1)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -7116,8 +7113,6 @@ static void __devinit ipr_init_ioa_cfg(s
 	ioa_cfg->pdev = pdev;
 	ioa_cfg->log_level = ipr_log_level;
 	ioa_cfg->doorbell = IPR_DOORBELL;
-	if (!ipr_auto_create)
-		ioa_cfg->doorbell |= IPR_RUNTIME_RESET;
 	sprintf(ioa_cfg->eye_catcher, IPR_EYECATCHER);
 	sprintf(ioa_cfg->trace_start, IPR_TRACE_START_LABEL);
 	sprintf(ioa_cfg->ipr_free_label, IPR_FREEQ_LABEL);
_
