From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: lpfc: Fix a precedence bug in
 lpfc_nvme_io_cmd_wqe_cmpl()
Date: Thu, 12 Oct 2017 23:30:57 +0300
Message-ID: <20171012203057.ixo2ds5i5ecbyv4y@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35509 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdJLUbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2017 16:31:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The ! has higher precedence than the & operation.  I've added
parenthesis so this works as intended.

Fixes: 952c303b329c ("scsi: lpfc: Ensure io aborts interlocked with the target.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 60f0dbd0f192..517ae570e507 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -948,7 +948,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	/* NVME targets need completion held off until the abort exchange
 	 * completes.
 	 */
-	if (!lpfc_ncmd->flags & LPFC_SBUF_XBUSY)
+	if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY))
 		nCmd->done(nCmd);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
