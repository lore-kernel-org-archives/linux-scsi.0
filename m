From: akpm@linux-foundation.org
Subject: [patch 11/19] drivers/scsi/libsas: use SAM_GOOD
Date: Mon, 21 Dec 2009 16:27:49 -0800
Message-ID: <200912220027.nBM0RnEG005391@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbZLVAcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:32:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk

From: Julia Lawall <julia@diku.dk>

The field stat->stat should be compared to SAM_GOOD, not SAM_STAT_GOOD, as
done elsewhere in the same function.  Both constants have the same value.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libsas/sas_ata.c~drivers-scsi-libsas-use-sam_good drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~drivers-scsi-libsas-use-sam_good
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -112,7 +112,7 @@ static void sas_ata_task_done(struct sas
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-	} else if (stat->stat != SAM_STAT_GOOD) {
+	} else if (stat->stat != SAM_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
 			SAS_DPRINTK("%s: SAS error %x\n", __func__,
_
