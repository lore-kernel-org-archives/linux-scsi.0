From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] scsi: lpfc: fix potential buffer overflow.
Date: Tue, 18 Apr 2017 11:55:51 +0200
Message-ID: <1492509351-25441-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754768AbdDRJzz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 05:55:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com
Cc: dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, emilne@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

This patch fixes a potential buffer overflow in lpfc_nvme_info_show().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 22819af..1ce252f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -181,7 +181,7 @@
 				wwn_to_u64(vport->fc_nodename.u.wwn),
 				phba->targetport->port_id);
 
-		len += snprintf(buf + len, PAGE_SIZE,
+		len += snprintf(buf + len, PAGE_SIZE - len,
 				"\nNVME Target: Statistics\n");
 		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 		len += snprintf(buf+len, PAGE_SIZE-len,
@@ -326,7 +326,7 @@
 	}
 	spin_unlock_irq(shost->host_lock);
 
-	len += snprintf(buf + len, PAGE_SIZE, "\nNVME Statistics\n");
+	len += snprintf(buf + len, PAGE_SIZE - len, "\nNVME Statistics\n");
 	len += snprintf(buf+len, PAGE_SIZE-len,
 			"LS: Xmt %016llx Cmpl %016llx\n",
 			phba->fc4NvmeLsRequests,
-- 
Maurizio Lombardi
