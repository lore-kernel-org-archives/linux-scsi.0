From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 07/15] lpfc: Correct reporting of vport state on fdisc
 command failure.
Date: Thu, 21 May 2015 13:55:22 -0400
Message-ID: <555e1c0a.KKafFC5Tv0GZ+C37%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35681 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbbEURz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:27 -0400
Received: by qgew3 with SMTP id w3so45153231qge.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:27 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id r31sm13762682qkr.42.2015.05.21.10.55.26
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct reporting of vport state on fdisc command failure.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 724b61c..b490ef5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8237,7 +8237,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_do_scr_ns_plogi(phba, vport);
 	goto out;
 fdisc_failed:
-	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	if (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS)
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	/* Cancel discovery timer */
 	lpfc_can_disctmo(vport);
 	lpfc_nlp_put(ndlp);
-- 
1.7.11.7

