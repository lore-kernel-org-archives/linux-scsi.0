From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/5] mpt2sas: Add a module parameter that permits overriding protection capabilities
Date: Tue, 28 Aug 2012 14:29:37 -0400
Message-ID: <1346178577-28628-5-git-send-email-martin.petersen@oracle.com>
References: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30915 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2H1SaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 14:30:15 -0400
In-Reply-To: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
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
index bfda0ec..96f4d1f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -123,6 +123,11 @@ static int disable_discovery = -1;
 module_param(disable_discovery, int, 0);
 MODULE_PARM_DESC(disable_discovery, " disable discovery ");
 
+/* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
+static int prot_mask = 0;
+module_param(prot_mask, int, 0);
+MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
+
 /**
  * struct sense_info - common structure for obtaining sense keys
  * @skey: sense key
@@ -8088,8 +8093,14 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
1.7.7.6

