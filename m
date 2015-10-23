From: Punit Vara <punitvara@gmail.com>
Subject: [PATCH 1/2] scsi: lpfc: Use kzalloc instead of kmalloc
Date: Sat, 24 Oct 2015 01:33:52 +0530
Message-ID: <1445630633-14209-2-git-send-email-punitvara@gmail.com>
References: <1445630633-14209-1-git-send-email-punitvara@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445630633-14209-1-git-send-email-punitvara@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch is to the lpfc_els.c which resolves following warning
reported by coccicheck:

WARNING: kzalloc should be used for rdp_context, instead of
kmalloc/memset

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 36bf58b..422c800 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4990,7 +4990,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	if (RDP_NPORT_ID_SIZE !=
 			be32_to_cpu(rdp_req->nport_id_desc.length))
 		goto rjt_logerr;
-	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
+	rdp_context = kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
 	if (!rdp_context) {
 		rjt_err = LSRJT_UNABLE_TPC;
 		goto error;
-- 
2.5.3
