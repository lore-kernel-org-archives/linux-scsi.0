From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 12/21] lpfc: Correct issues with FAWWN and FDISCs
Date: Wed,  2 Aug 2017 16:36:39 -0700
Message-ID: <20170802233648.4573-13-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34522 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbdHBXiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:38:10 -0400
Received: by mail-qk0-f194.google.com with SMTP id q66so6121336qki.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:38:09 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

When using fabric-assigned WWNs, the switch doesn't like copy of
the FLOGI payload, which includes valid VVL bits, to be used as
the FDISC paylaod.

Rather than wait for corrected switch firmware, ensure the VVL bits
are marked invalid on FDISCs.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9a8808abe61f..f97d578ea6bd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8868,6 +8868,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	pcmd += sizeof(uint32_t); /* Node Name */
 	pcmd += sizeof(uint32_t); /* Node Name */
 	memcpy(pcmd, &vport->fc_nodename, 8);
+	sp->cmn.valid_vendor_ver_level = 0;
 	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
 	lpfc_set_disctmo(vport);
 
-- 
2.13.1
