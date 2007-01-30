From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/12] sas_ata: Satisfy libata qc function locking requirements
Date: Tue, 30 Jan 2007 01:18:35 -0800
Message-ID: <20070130091835.31530.6765.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48754 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965435AbXA3JQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:04 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9G2H3022902
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:02 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9G2kr293938
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:02 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9G27W016746
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:02 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


ata_qc_complete and ata_sas_queuecmd require that the port lock be held
when they are called.  sas_ata doesn't do this, leading to BUG messages
about qc tags newly allocated qc tags already being in use.  This patch
fixes the locking, which should clean up the rest of those messages.

So far I've tested this against an IBM x206m with two SATA disks with no
BUG messages and no other signs of things going wrong, and the machine
finally passed the pounder stress test.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c       |    4 ++++
 drivers/scsi/libsas/sas_scsi_host.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index de42b5b..0bb1a14 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -92,7 +92,9 @@ static void sas_ata_task_done(struct sas
 	struct task_status_struct *stat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)stat->buf;
 	enum ata_completion_errors ac;
+	unsigned long flags;
 
+	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
 	if (stat->stat == SAS_PROTO_RESPONSE) {
 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
 		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
@@ -113,6 +115,8 @@ static void sas_ata_task_done(struct sas
 	}
 
 	ata_qc_complete(qc);
+	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
+
 	list_del_init(&task->list);
 	sas_free_task(task);
 }
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2cd478a..fee9c10 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -213,8 +213,12 @@ int sas_queuecommand(struct scsi_cmnd *c
 		struct sas_task *task;
 
 		if (dev_is_sata(dev)) {
+			unsigned long flags;
+
+			spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
 			res = ata_sas_queuecmd(cmd, scsi_done,
 					       dev->sata_dev.ap);
+			spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 			goto out;
 		}
 
