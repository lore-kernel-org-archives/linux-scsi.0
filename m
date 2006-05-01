From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] lpfc: sparse NULL warnings
Date: Mon, 1 May 2006 15:04:27 -0700
Message-ID: <20060501150427.8e5e2608.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:63426 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932295AbWEAWCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2006 18:02:05 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 1 May 2006 15:02:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

Resend -- was this lost?  I don't see it in the scsi-misc tree.

Begin forwarded message:
Date: Wed, 29 Mar 2006 11:19:27 -0800
From: "Randy.Dunlap" <rdunlap@xenotime.net>
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, hch@infradead.org
Subject: [PATCH] lpfc: sparse NULL warnings


From: Randy Dunlap <rdunlap@xenotime.net>

Fix sparse warnings: use NULL instead of 0 for pointers:
drivers/scsi/lpfc/lpfc_els.c:827:56: warning: Using plain integer as NULL pointer
drivers/scsi/lpfc/lpfc_els.c:2781:18: warning: Using plain integer as NULL pointer
drivers/scsi/lpfc/lpfc_els.c:2782:18: warning: Using plain integer as NULL pointer
drivers/scsi/lpfc/lpfc_init.c:951:21: warning: Using plain integer as NULL pointer
drivers/scsi/lpfc/lpfc_init.c:956:20: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/lpfc/lpfc_els.c  |    6 +++---
 drivers/scsi/lpfc/lpfc_init.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2616-g16.orig/drivers/scsi/lpfc/lpfc_els.c
+++ linux-2616-g16/drivers/scsi/lpfc/lpfc_els.c
@@ -824,7 +824,7 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
-	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, 0, did,
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, NULL, did,
 								ELS_CMD_PLOGI);
 	if (!elsiocb)
 		return 1;
@@ -2778,8 +2778,8 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
 
 	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	xri = (uint16_t) ((unsigned long)(pmb->context1));
-	pmb->context1 = 0;
-	pmb->context2 = 0;
+	pmb->context1 = NULL;
+	pmb->context2 = NULL;
 
 	if (mb->mbxStatus) {
 		mempool_free( pmb, phba->mbox_mem_pool);
--- linux-2616-g16.orig/drivers/scsi/lpfc/lpfc_init.c
+++ linux-2616-g16/drivers/scsi/lpfc/lpfc_init.c
@@ -948,12 +948,12 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 					"10-port ", "PCIe"};
 			break;
 		default:
-			m = (typeof(m)){ 0 };
+			m = (typeof(m)){ NULL };
 			break;
 		}
 		break;
 	default:
-		m = (typeof(m)){ 0 };
+		m = (typeof(m)){ NULL };
 		break;
 	}
 


---

