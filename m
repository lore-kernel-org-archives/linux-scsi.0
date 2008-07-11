From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Fri, 11 Jul 2008 13:37:50 -0500
Message-ID: <200807111838.m6BIc7Ax010898@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:45857 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbYGKSiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 14:38:22 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6BIcEaF012061
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2008 14:38:14 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6BIc87i170608
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2008 12:38:13 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6BIc8Px011177
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2008 12:38:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, miltonm@bga.com


Currently, ipr does not support HDIO_GET_IDENTITY to SATA devices.
An oops occurs if userspace attempts to send the command. Since hald
issues the command, ensure we fail the ioctl in ipr. This is a
temporary solution to the oops. Once the ipr libata EH conversion
is upstream, ipr will fully support HDIO_GET_IDENTITY.

Tested-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
James,

This bug is causing periodic oopses on Power. If there is still time
for 2.6.26, I'd like to get it in. Otherwise we can backport to stable.

Thanks,

Brian

---

 drivers/scsi/ipr.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_sata_no_identify drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_no_identify	2008-07-11 13:27:30.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2008-07-11 13:27:30.000000000 -0500
@@ -71,6 +71,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/libata.h>
+#include <linux/hdreg.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
@@ -4913,8 +4914,11 @@ static int ipr_ioctl(struct scsi_device 
 	struct ipr_resource_entry *res;
 
 	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res && ipr_is_gata(res))
+	if (res && ipr_is_gata(res)) {
+		if (cmd == HDIO_GET_IDENTITY)
+			return -ENOTTY;
 		return ata_scsi_ioctl(sdev, cmd, arg);
+	}
 
 	return -EINVAL;
 }
_
