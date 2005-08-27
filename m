From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 9/16]  qla2xxx: Remove redundant call to pci_unmap_sg().
Date: Fri, 26 Aug 2005 19:09:20 -0700 (PDT)
Message-ID: <20050827020920.27275.82790.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:5736 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751617AbVH0CJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:09:21 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Remove redundant call to pci_unmap_sg().

In a corner-case failure where the request-q does not
contain enough entries for a given request, pci_unmap_sg()
would be called twice.  Remove direct call and let the
failure-path logic handle the unmapping.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_iocb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

a1f5bbf1b3a49977421a852127630a37ec5b90b1
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -810,12 +810,8 @@ qla24xx_start_scsi(srb_t *sp)
 			ha->req_q_cnt = ha->request_q_length -
 				(ha->req_ring_index - cnt);
 	}
-	if (ha->req_q_cnt < (req_cnt + 2)) {
-		if  (cmd->use_sg)
-			pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
-					cmd->sc_data_direction);
+	if (ha->req_q_cnt < (req_cnt + 2))
 		goto queuing_error;
-	}
 
 	/* Build command packet. */
 	ha->current_outstanding_cmd = handle;

-- 
Andrew Vasquez
