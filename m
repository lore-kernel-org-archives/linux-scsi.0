From: akpm@linux-foundation.org
Subject: [patch 04/27] drivers/scsi/libsas: use SAM_GOOD
Date: Tue, 20 Jul 2010 15:28:44 -0700
Message-ID: <201007202228.o6KMSihC021717@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070Ab0GTW3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:29:10 -0400
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
@@ -113,7 +113,7 @@ static void sas_ata_task_done(struct sas
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-	} else if (stat->stat != SAM_STAT_GOOD) {
+	} else if (stat->stat != SAM_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
 			SAS_DPRINTK("%s: SAS error %x\n", __func__,
_
