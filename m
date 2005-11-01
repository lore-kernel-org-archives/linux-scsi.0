From: brking@us.ibm.com
Subject: [PATCH 17/26] ipr: Module parm to disable RAID 0 auto create
Date: Tue, 01 Nov 2005 17:02:01 -0600
Message-ID: <200511012302.jA1N22On022053@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:22232 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751412AbVKAXCD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:02:03 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N238m021389
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:03 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N23Xg538028
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:03 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N22T9022080
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Some ipr adapters will automatically create single device
RAID 0 arrays for all unconfigured RAID capable devices found
at adapter initialization time. This patch adds a module parameter
to disable this behavior.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_disable_runtime_reset drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_disable_runtime_reset	2005-11-01 16:08:07.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-01 16:08:07.000000000 -0600
@@ -93,6 +93,7 @@ static unsigned int ipr_fastfail = 0;
 static unsigned int ipr_transop_timeout = IPR_OPERATIONAL_TIMEOUT;
 static unsigned int ipr_enable_cache = 1;
 static unsigned int ipr_debug = 0;
+static int ipr_auto_create = 1;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -156,6 +157,8 @@ module_param_named(enable_cache, ipr_ena
 MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
 module_param_named(debug, ipr_debug, int, 0);
 MODULE_PARM_DESC(debug, "Enable device driver debugging logging. Set to 1 to enable. (default: 0)");
+module_param_named(auto_create, ipr_auto_create, int, 0);
+MODULE_PARM_DESC(auto_create, "Auto-create single device RAID 0 arrays when initialized (default: 1)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -5919,6 +5922,8 @@ static void __devinit ipr_init_ioa_cfg(s
 	ioa_cfg->pdev = pdev;
 	ioa_cfg->log_level = ipr_log_level;
 	ioa_cfg->doorbell = IPR_DOORBELL;
+	if (!ipr_auto_create)
+		ioa_cfg->doorbell |= IPR_RUNTIME_RESET;
 	sprintf(ioa_cfg->eye_catcher, IPR_EYECATCHER);
 	sprintf(ioa_cfg->trace_start, IPR_TRACE_START_LABEL);
 	sprintf(ioa_cfg->ipr_free_label, IPR_FREEQ_LABEL);
_
