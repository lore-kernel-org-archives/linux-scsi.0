From: akpm@linux-foundation.org
Subject: [patch 08/10] drivers/scsi/mvsas.c: fix build warnings
Date: Fri, 18 Apr 2008 13:57:26 -0700
Message-ID: <200804182057.m3IKvQtS015394@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762413AbYDRU6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 16:58:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, kewei@marvell.com, oliver.pntr@gmail.com

From: Andrew Morton <akpm@linux-foundation.org>

powerpc:

drivers/scsi/mvsas.c: In function 'mvs_update_phyinfo':
drivers/scsi/mvsas.c:2536: warning: format '%llX' expects type 'long long unsigned int', but argument 5 has type 'u64'
drivers/scsi/mvsas.c:2536: warning: format '%llX' expects type 'long long unsigned int', but argument 6 has type 'u64'

we do not know what type the architecture uses to implement u64 hence we
cannot print them directly.

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Ke Wei <kewei@marvell.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvsas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-build-warnings drivers/scsi/mvsas.c
--- a/drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-build-warnings
+++ a/drivers/scsi/mvsas.c
@@ -2822,7 +2822,9 @@ static void mvs_update_phyinfo(struct mv
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"phy[%d] Get Attached Address 0x%llX ,"
 			" SAS Address 0x%llX\n",
-			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
+			i,
+			(unsigned long long)phy->att_dev_sas_addr,
+			(unsigned long long)phy->dev_sas_addr);
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"Rate = %x , type = %d\n",
 			sas_phy->linkrate, phy->phy_type);
_
