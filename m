From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 20/21] lpfc: correct nvme sg segment count check
Date: Fri, 29 Sep 2017 17:34:46 -0700
Message-ID: <20170930003447.10747-21-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:51494 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752650AbdI3AfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:15 -0400
Received: by mail-qt0-f196.google.com with SMTP id q4so1597539qtq.8
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:35:14 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The internal cfg flag is actually smaller, by 1 (for a partial page sge),
than the sg list maintained by the driver. Thus the check on sg segments
errored out when it shouldn't have

Ensure the check is +1

Note: having a value that is less than what it really is is bogus.
 Correcting it now would be a significant rework. Add this item to the
 list to be refactored in the merge with efct.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 040af28073bb..05ab731c408a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1149,12 +1149,12 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 		first_data_sgl = sgl;
 		lpfc_ncmd->seg_cnt = nCmd->sg_cnt;
-		if (lpfc_ncmd->seg_cnt > phba->cfg_nvme_seg_cnt) {
+		if (lpfc_ncmd->seg_cnt > phba->cfg_nvme_seg_cnt + 1) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 					"6058 Too many sg segments from "
 					"NVME Transport.  Max %d, "
 					"nvmeIO sg_cnt %d\n",
-					phba->cfg_nvme_seg_cnt,
+					phba->cfg_nvme_seg_cnt + 1,
 					lpfc_ncmd->seg_cnt);
 			lpfc_ncmd->seg_cnt = 0;
 			return 1;
-- 
2.13.1
