From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] mpt2sas: Add a module parameter that permits overriding protection capabilities
Date: Mon, 20 Feb 2012 20:36:23 -0500
Message-ID: <1329788184-6477-3-git-send-email-martin.petersen@oracle.com>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33338 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2BUBgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 20:36:38 -0500
In-Reply-To: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi.Nandigama@lsi.com, Eric.Moore@lsi.com

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Add a parameter that allows the host protection capabilities mask to be
provided at module load time.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Nagalakshmi.Nandigama@lsi.com
Cc: Eric.Moore@lsi.com
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 9085d3e..f398300 100644
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

