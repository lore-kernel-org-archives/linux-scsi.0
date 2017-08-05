From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 11/20] lpfc: Correct issues with FAWWN and FDISCs
Date: Fri,  4 Aug 2017 17:47:22 -0700
Message-ID: <20170805004731.1335-12-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34918 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdHEAsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:01 -0400
Received: by mail-pg0-f68.google.com with SMTP id l64so3110138pge.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:01 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

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
