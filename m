From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] sas_ata: don't copy aic94xx's sactive to ata_port
Date: Tue, 14 Nov 2006 10:29:23 -0800
Message-ID: <455A0B03.1080907@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:11679 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S966260AbWKNS3b
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Nov 2006 13:29:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Since the aic94xx sequencer assigns its own NCQ tags to ATA commands, it
no longer makes any sense to copy the sactive field in the STP response
to ata_port->sactive, as that will confuse libata.  Also, libata seems
to be capable of managing sactive on its own.

The attached patch gets rid of one of the causes of the BUG messages in
ata_qc_new, and should apply against jejb's aic94xx-sas git tree.

--

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index ca49d3e..9580d81 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -108,7 +108,6 @@ static void sas_ata_task_done(struct sas
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-		dev->sata_dev.ap->sactive = resp->sactive;
 	} else if (stat->stat != SAM_STAT_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
