From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/6] mpt2sas: Add a module parameter that permits overriding protection capabilities
Date: Fri, 13 Jan 2012 17:43:02 -0500
Message-ID: <1326494586-17360-3-git-send-email-martin.petersen@oracle.com>
References: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40335 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab2AMWnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2012 17:43:33 -0500
In-Reply-To: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi.Nandigama@lsi.com

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Add a parameter that allows the host protection capabilities mask to be
provided at module load time.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Nagalakshmi.Nandigama@lsi.com
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16b876d..4776ea1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -119,6 +119,11 @@ module_param(diag_buffer_enable, int, 0);
 MODULE_PARM_DESC(diag_buffer_enable, " post diag buffers "
 	"(TRACE=1/SNAPSHOT=2/EXTENDED=4/default=0)");
 
+/* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
+static int prot_mask = 0;
+module_param(prot_mask, int, 0);
+MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
+
 /**
  * struct sense_info - common structure for obtaining sense keys
  * @skey: sense key
@@ -8007,8 +8012,14 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_add_shost_fail;
 	}
 
-	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
-	    | SHOST_DIF_TYPE2_PROTECTION | SHOST_DIF_TYPE3_PROTECTION);
+	/* register EEDP capabilities with SCSI layer */
+	if (prot_mask)
+		scsi_host_set_prot(shost, prot_mask);
+	else
+		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+				   | SHOST_DIF_TYPE2_PROTECTION
+				   | SHOST_DIF_TYPE3_PROTECTION);
+
 	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
 
 	/* event thread */
-- 
1.7.8.3.21.gab8a7

