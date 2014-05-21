From: James Smart <james.smart@emulex.com>
Subject: [PATCH V2 2/5] lpfc 10.2.8001.0: Fix for initializing RRQ bitmap
Date: Wed, 21 May 2014 08:05:10 -0400
Message-ID: <1400673910.16422.8.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:54024 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaEUMFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 08:05:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix for initializing RRQ bitmap


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    3 +++
 1 file changed, 3 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2014-05-12 09:45:34.361083584 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2014-05-12 09:49:33.334095621 -0400
@@ -5634,6 +5634,9 @@ lpfc_nlp_init(struct lpfc_vport *vport,
 		ndlp->active_rrqs_xri_bitmap =
 				mempool_alloc(vport->phba->active_rrq_pool,
 					      GFP_KERNEL);
+		if (ndlp->active_rrqs_xri_bitmap)
+			memset(ndlp->active_rrqs_xri_bitmap, 0,
+			       ndlp->phba->cfg_rrq_xri_bitmap_sz);
 	}
 
 


