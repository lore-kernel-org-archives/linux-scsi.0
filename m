From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 09:20:15 -0500
Message-ID: <16639.3097061247$1212416524@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36995 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYFBOUf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 10:20:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, brking@linux.vnet.ibm.com, miltonm@bga.com


Currently, ipr does not support HDIO_GET_IDENTITY to SATA devices.
An oops occurs if userspace attempts to send the command. Since hald
issues the command, ensure we fail the ioctl in ipr. This is a
temporary solution to the oops. Once the ipr libata EH conversion
is upstream, ipr will fully support HDIO_GET_IDENTITY.

Tested-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_sata_no_identify drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_no_identify	2008-06-02 08:46:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2008-06-02 08:46:19.000000000 -0500
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
