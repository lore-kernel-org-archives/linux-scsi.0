From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Add support for SCT Write Same
Date: Wed, 08 Jun 2016 23:39:38 -0400
Message-ID: <yq1bn3bjait.fsf@sermon.lab.mkp.net>
References: <1465235890-15703-1-git-send-email-shaun@tancheff.com>
	<1465235890-15703-2-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25245 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbcFIDjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2016 23:39:53 -0400
In-Reply-To: <1465235890-15703-2-git-send-email-shaun@tancheff.com> (Shaun
	Tancheff's message of "Mon, 6 Jun 2016 12:58:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>

>>>>> "Shaun" == Shaun Tancheff <shaun@tancheff.com> writes:

Shaun,

Shaun> SATA drives may support write same via SCT. This is useful for
Shaun> setting the drive contents to a specific pattern (0's).

index 428c03e..c5c8424 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
+#include <linux/ata.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
No ATA stuff in sd.c, please.


@@ -2761,24 +2762,26 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdev = sdkp->device;
 
-	if (sdev->host->no_write_same) {
-		sdev->no_write_same = 1;
-
-		return;
-	}
-
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
-		/* too large values might cause issues with arcmsr */
-		int vpd_buf_len = 64;
-
 		sdev->no_report_opcodes = 1;
 
 		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */

The above comment tells you how to enable WRITE SAME in libata's
SCSI-ATA translation.


-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))

That vpd_buf_len is intentional.

-- 
Martin K. Petersen	Oracle Linux Engineering
