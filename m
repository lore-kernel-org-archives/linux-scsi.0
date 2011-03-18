From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 1/8] bnx2fc: Avoid holding cq_lock when iounmap() is
 called
Date: Thu, 17 Mar 2011 17:13:26 -0700
Message-ID: <1300407206.644.404.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4417 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1CRANl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>Nithin Sujir <nsujir@broadcom.com>

With kernel debugging enabled, holding cq_lock when calling
bnx2fc_free_session_resc() which calls iounmap() leads to a warning
stack trace [INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected].
iounmap() grabs a HARDIRQ-unsafe vmlist lock, so holding
spin_lock_bh(cq_lock) when calling iounmap() will trigger the LOCKDEP
warning.  Since cq_lock is required only to guard against deletion, hold
the lock just before freeing the cq.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 7ea93af..7cc05e4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -304,10 +304,8 @@ static void bnx2fc_upload_session(struct fcoe_port *port,
 				" not sent to FW\n");
 
 	/* Free session resources */
-	spin_lock_bh(&tgt->cq_lock);
 	bnx2fc_free_session_resc(hba, tgt);
 	bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
-	spin_unlock_bh(&tgt->cq_lock);
 }
 
 static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
@@ -830,11 +828,13 @@ static void bnx2fc_free_session_resc(struct bnx2fc_hba *hba,
 		tgt->rq = NULL;
 	}
 	/* Free CQ */
+	spin_lock_bh(&tgt->cq_lock);
 	if (tgt->cq) {
 		dma_free_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
 				    tgt->cq, tgt->cq_dma);
 		tgt->cq = NULL;
 	}
+	spin_unlock_bh(&tgt->cq_lock);
 	/* Free SQ */
 	if (tgt->sq) {
 		dma_free_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
-- 
1.7.0.6




