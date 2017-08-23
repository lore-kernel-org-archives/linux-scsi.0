From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 11/20] lpfc: Correct issues with FAWWN and FDISCs
Date: Wed, 23 Aug 2017 16:55:40 -0700
Message-ID: <20170823235549.2883-12-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35590 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdHWX4W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:22 -0400
Received: by mail-wm0-f68.google.com with SMTP id x79so1065382wma.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:22 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
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
index 6de470e158ef..8d8fbfab0c9f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8860,6 +8860,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	pcmd += sizeof(uint32_t); /* Node Name */
 	pcmd += sizeof(uint32_t); /* Node Name */
 	memcpy(pcmd, &vport->fc_nodename, 8);
+	sp->cmn.valid_vendor_ver_level = 0;
 	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
 	lpfc_set_disctmo(vport);
 
-- 
2.13.1
