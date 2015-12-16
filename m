From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 16/17] lpfc: Use kzalloc instead of kmalloc
Date: Wed, 16 Dec 2015 18:12:07 -0500
Message-ID: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36054 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbbLPXM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:26 -0500
Received: by mail-pa0-f47.google.com with SMTP id q3so11062065pav.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:26 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id o22sm7008516pfi.2.2015.12.16.15.12.24
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From:	Punit Vara <punitvara@gmail.com>

This patch is to the lpfc_els.c which resolves following warning
reported by coccicheck:

WARNING: kzalloc should be used for rdp_context, instead of
kmalloc/memset

Signed-off-by: Punit Vara <punitvara@gmail.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 273a1db..7f5abb8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5016,13 +5016,12 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	if (RDP_NPORT_ID_SIZE !=
 			be32_to_cpu(rdp_req->nport_id_desc.length))
 		goto rjt_logerr;
-	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
+	rdp_context = kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
 	if (!rdp_context) {
 		rjt_err = LSRJT_UNABLE_TPC;
 		goto error;
 	}
 
-	memset(rdp_context, 0, sizeof(struct lpfc_rdp_context));
 	cmd = &cmdiocb->iocb;
 	rdp_context->ndlp = lpfc_nlp_get(ndlp);
 	rdp_context->ox_id = cmd->unsli3.rcvsli3.ox_id;
-- 
1.7.11.7

