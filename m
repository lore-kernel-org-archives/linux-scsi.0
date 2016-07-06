From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 05/21] lpfc: Reject RDP ELS if port has no login
Date: Wed, 06 Jul 2016 12:35:58 -0700
Message-ID: <577d5d9e.DGbam2YjJ7SVt9GU%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36087 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbcGFTgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:05 -0400
Received: by mail-wm0-f41.google.com with SMTP id f126so185560689wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:04 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id q71sm7168067wme.17.2016.07.06.12.36.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Reject RDP ELS if port has no login

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 02e3a1f..861270e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5243,6 +5243,12 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			 be32_to_cpu(rdp_req->nport_id_desc.nport_id),
 			 be32_to_cpu(rdp_req->nport_id_desc.length));
 
+	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED) &&
+	    !phba->cfg_enable_SmartSAN) {
+		rjt_err = LSRJT_UNABLE_TPC;
+		rjt_expl = LSEXP_PORT_LOGIN_REQ;
+		goto error;
+	}
 	if (sizeof(struct fc_rdp_nport_desc) !=
 			be32_to_cpu(rdp_req->rdp_des_length))
 		goto rjt_logerr;
-- 
2.5.0

