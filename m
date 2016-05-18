From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aacraid: do not activate events on non-SRC adapters
Date: Wed, 18 May 2016 10:16:51 +0200
Message-ID: <1463559411-100841-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbcERIQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2016 04:16:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Only SRC-based adapters support the AifReqEvent function, so
there is no point in trying to activate it on older, non-SRC
based adapters.
Doing so lead to crashes on older adapters.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/aacraid.h |  5 +++++
 drivers/scsi/aacraid/linit.c   | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 8f90d9e..969c312 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -621,6 +621,11 @@ struct aac_driver_ident
 #define AAC_QUIRK_SCSI_32	0x0020
 
 /*
+ * SRC based adapters support the AifReqEvent functions
+ */
+#define AAC_QUIRK_SRC 0x0040
+
+/*
  *	The adapter interface specs all queues to be located in the same
  *	physically contiguous block. The host structure that defines the
  *	commuication queues will assume they are each a separate physically
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a943bd2..79871f3 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -236,10 +236,10 @@ static struct aac_driver_ident aac_drivers[] = {
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Catch All */
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Rocket Catch All */
 	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID           ", 2 }, /* Adaptec NEMER/ARK Catch All */
-	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec PMC Series 6 (Tupelo) */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec PMC Series 7 (Denali) */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec PMC Series 8 */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec PMC Series 9 */
+	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 6 (Tupelo) */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 7 (Denali) */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 8 */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC } /* Adaptec PMC Series 9 */
 };
 
 /**
@@ -1299,7 +1299,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		shost->this_id = shost->max_id;
 
-	aac_intr_normal(aac, 0, 2, 0, NULL);
+	if (aac_drivers[index].quirks & AAC_QUIRK_SRC)
+		aac_intr_normal(aac, 0, 2, 0, NULL);
 
 	/*
 	 * dmb - we may need to move the setting of these parms somewhere else once
-- 
1.8.5.6

