From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 07/19] lpfc: Fix IO failure during hba reset testing with nvme io.
Date: Wed, 24 Jan 2018 14:45:36 -0800
Message-ID: <20180124224548.9530-8-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:43640 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933045AbeAXWqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:07 -0500
Received: by mail-qt0-f193.google.com with SMTP id s3so14626045qtb.10
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:07 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

A stress test repeatedly resetting the adapter while performing
io would eventually report I/O failures and missing nvme namespaces.

The driver was setting the nvmefc_fcp_req->private pointer to NULL
during the IO completion routine before upcalling done().
If the transport was also running an abort for that IO, the driver
would fail the abort with message 6140. Failing the abort is not
allowed by the nvme-fc transport, as it mandates that the io must be
returned back to the transport. As that does not happen, the transport
controller delete has an outstanding reference and can't complete
teardown.

Remove the NULL'ing of the private pointer in the nvmefc request.
The driver simply overwrites this value on each IO start.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 81e3a4f10c3c..92643ffa79c3 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -804,7 +804,6 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	struct nvme_fc_cmd_iu *cp;
 	struct lpfc_nvme_rport *rport;
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	struct lpfc_nvme_lport *lport;
 	unsigned long flags;
 	uint32_t code, status;
@@ -980,8 +979,6 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
 	}
 #endif
-	freqpriv = nCmd->private;
-	freqpriv->nvme_buf = NULL;
 
 	/* NVME targets need completion held off until the abort exchange
 	 * completes unless the NVME Rport is getting unregistered.
-- 
2.13.1
