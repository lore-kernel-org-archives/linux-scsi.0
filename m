From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 7/8] a100u2w: advansys: initio: Wrong use of SG_ALL
Date: Thu, 17 Jan 2008 18:53:16 +0200
Message-ID: <478F87FC.4000602@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20982 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbYAQQxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:53:20 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  These drivers used the SG_ALL constant, But actually
  meant some other define.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/a100u2w.c  |    3 +--
 drivers/scsi/advansys.c |    8 +++-----
 drivers/scsi/initio.c   |    2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index f608d4a..82d5210 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1068,7 +1068,7 @@ static struct scsi_host_template inia100_template = {
 	.eh_device_reset_handler = inia100_device_reset,
 	.can_queue		= 1,
 	.this_id		= 1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= TOTAL_SG_ENTRY,
 	.cmd_per_lun 		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
@@ -1150,7 +1150,6 @@ static int __devinit inia100_probe_one(struct pci_dev *pdev,
 	shost->max_lun = 16;
 	shost->irq = pdev->irq;
 	shost->this_id = host->scsi_id;	/* Assign HCS index */
-	shost->sg_tablesize = TOTAL_SG_ENTRY;
 
 	/* Initial orc chip           */
 	error = request_irq(pdev->irq, inia100_intr, IRQF_SHARED,
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 492702b..45d58d3 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -13735,13 +13735,11 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	}
 
 	/*
-	 * The value of 'sg_tablesize' can not exceed the SCSI
-	 * mid-level driver definition of SG_ALL. SG_ALL also
-	 * must not be exceeded, because it is used to define the
+	 * The value of 'sg_tablesize' can not exceed the
 	 * size of the scatter-gather table in 'struct asc_sg_head'.
 	 */
-	if (shost->sg_tablesize > SG_ALL) {
-		shost->sg_tablesize = SG_ALL;
+	if (shost->sg_tablesize > ASC_MAX_SG_LIST) {
+		shost->sg_tablesize = ASC_MAX_SG_LIST;
 	}
 
 	ASC_DBG(1, "sg_tablesize: %d\n", shost->sg_tablesize);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 52238ee..02cb133 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2829,7 +2829,7 @@ static struct scsi_host_template initio_template = {
 	.bios_param		= i91u_biosparam,
 	.can_queue		= MAX_TARGETS * i91u_MAXQUEUE,
 	.this_id		= 1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= TOTAL_SG_ENTRY,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-- 
1.5.3.3


