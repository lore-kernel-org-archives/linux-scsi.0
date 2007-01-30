From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/12] libsas: Accept SAM_GOOD for ATAPI devices in sas_ata_task_done
Date: Tue, 30 Jan 2007 01:18:49 -0800
Message-ID: <20070130091849.31530.37223.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33399 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457AbXA3JQS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:18 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9GHTd007457
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:17 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GGT4236032
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:16 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GGxK031014
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:16 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


A sas_task sent to an ATAPI devices returns SAM_GOOD if successful.
Therefore, we should treat this the same way we treat ATA commands
that succeed.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2bb619e..20f3a5e 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -100,7 +100,7 @@ static void sas_ata_task_done(struct sas
 	dev = qc->ap->private_data;
 
 	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-	if (stat->stat == SAS_PROTO_RESPONSE) {
+	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_GOOD) {
 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
 		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
 		dev->sata_dev.sstatus = resp->sstatus;
