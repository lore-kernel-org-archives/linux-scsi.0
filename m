From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 3/9] lpfc: Fix crash when unregistering default rpi.
Date: Thu, 31 Mar 2016 14:12:29 -0700
Message-ID: <56fd92bd.d4MkUkUnxSqHCqvq%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34756 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561AbcCaVMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:33 -0400
Received: by mail-pf0-f178.google.com with SMTP id x3so77741668pfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:33 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id fw9sm15543838pac.21.2016.03.31.14.12.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix crash when unregistering default rpi.

The default rpi completion handler does back to back puts to force the
removal of the ndlp. This ends up calling lpfc_unreg_rpi after the
reference count is at 0.

Fix:  Check the reference count of the ndlp before getting the ref to
make sure we are not getting a reference on a removed object.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 25b5dcd..b3bf230 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4545,7 +4545,8 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				    (!(vport->load_flag & FC_UNLOADING)) &&
 				    (bf_get(lpfc_sli_intf_if_type,
 				     &phba->sli4_hba.sli_intf) ==
-				      LPFC_SLI_INTF_IF_TYPE_2)) {
+				      LPFC_SLI_INTF_IF_TYPE_2) &&
+				    (atomic_read(&ndlp->kref.refcount) > 0)) {
 					mbox->context1 = lpfc_nlp_get(ndlp);
 					mbox->mbox_cmpl =
 						lpfc_sli4_unreg_rpi_cmpl_clr;
-- 
2.5.0

