From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] lpfc: Read buffer overflow
Date: Sun, 02 Aug 2009 10:08:57 +0200
Message-ID: <4A754999.90208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:40218 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZHBIFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2009 04:05:47 -0400
Received: by ey-out-2122.google.com with SMTP id 9so783200eyd.37
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2009 01:05:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index e0b4992..ade2df6 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -762,7 +762,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
 	int i;
 	if (vports == NULL)
 		return;
-	for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
+	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
 		scsi_host_put(lpfc_shost_from_vport(vports[i]));
 	kfree(vports);
 }
