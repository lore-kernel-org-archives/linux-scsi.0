From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 04/12] ipr: Enable logging of debug error data for all devices
Date: Thu, 29 Mar 2007 12:43:01 -0500
Message-ID: <200703291743.l2THh3o8029555@d03av02.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35087 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308AbXC2RnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:43:05 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THh4fI019499
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THh4vU122546
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THh3D1029594
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:04 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


The ipr driver has a sysfs attribute which can be used to
adjust the logging level of the driver for error events.
The error response data for commands can be dumped by
increasing the logging level of the ipr driver. This
currently only works for JBOD passthrough devices.
This patch enables this function for all devices, including
RAID devices, to aid in debugging problems.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_dump_vset_ioasa drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dump_vset_ioasa	2007-03-23 15:24:12.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-23 15:24:12.000000000 -0500
@@ -4473,6 +4473,9 @@ static void ipr_dump_ioasa(struct ipr_io
 		if (ioasa->ilid != 0)
 			return;
 
+		if (!ipr_is_gscsi(res))
+			return;
+
 		if (ipr_error_table[error_index].log_ioasa == 0)
 			return;
 	}
@@ -4632,11 +4635,11 @@ static void ipr_erp_start(struct ipr_ioa
 		return;
 	}
 
-	if (ipr_is_gscsi(res))
-		ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
-	else
+	if (!ipr_is_gscsi(res))
 		ipr_gen_sense(ipr_cmd);
 
+	ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
+
 	switch (ioasc & IPR_IOASC_IOASC_MASK) {
 	case IPR_IOASC_ABORTED_CMD_TERM_BY_HOST:
 		if (ipr_is_naca_model(res))
_
