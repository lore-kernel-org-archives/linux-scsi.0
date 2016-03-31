From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 5/9] lpfc: Fix Device discovery failures during switch
 reboot test.
Date: Thu, 31 Mar 2016 14:12:31 -0700
Message-ID: <56fd92bf.Ou+OQ7Y8yg+FaEDT%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33306 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbcCaVMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:35 -0400
Received: by mail-pf0-f171.google.com with SMTP id 4so77810450pfd.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:35 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id wh9sm15551050pab.8.2016.03.31.14.12.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix Device discovery failures during switch reboot test.

When the switch is rebooted, the lpfc driver fails to log
into the fabric, and Unexpected timeout message is seen.

Fix: Do not issue RegVFI if the FLOGI was internally aborted.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7f5abb8..27dcde9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1069,7 +1069,10 @@ stop_rr_fcf_flogi:
 					lpfc_sli4_unreg_all_rpis(vport);
 				}
 			}
-			lpfc_issue_reg_vfi(vport);
+
+			/* Do not register VFI if the driver aborted FLOGI */
+			if (!lpfc_error_lost_link(irsp))
+				lpfc_issue_reg_vfi(vport);
 			lpfc_nlp_put(ndlp);
 			goto out;
 		}
-- 
2.5.0

