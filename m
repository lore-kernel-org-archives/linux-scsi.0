From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] lpfc: fix an '&&' vs '&' typo
Date: Tue, 18 Sep 2012 09:56:47 +0300
Message-ID: <20120918065647.GA31914@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The intent here was clearly to do a bitwise AND similar to the others in
this file.  The current condition is never true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 7ffabb7..65f9fb6 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -634,7 +634,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 			if (irsp->ulpStatus != IOSTAT_LOCAL_REJECT ||
-			    (irsp->un.ulpWord[4] && IOERR_PARAM_MASK) !=
+			    (irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
 			    IOERR_NO_RESOURCES)
 				vport->fc_ns_retry++;
 
