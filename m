From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 02/15] lpfc: Correct loss of target discovery after
 cable swap.
Date: Thu, 21 May 2015 13:55:17 -0400
Message-ID: <555e1c05.rC0jgIm4nXsedlru%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36093 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbbEURzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:23 -0400
Received: by qkx62 with SMTP id 62so14710276qkx.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:23 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id m48sm13687590qgd.35.2015.05.21.10.55.21
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct loss of target discovery after cable swap.

Fix incorrect reference counting

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f2db89f..72388a6 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4296,9 +4296,9 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_cleanup_vports_rrqs(vport, ndlp);
 		lpfc_unreg_rpi(vport, ndlp);
-	} else {
-		lpfc_nlp_put(ndlp);
 	}
+
+	lpfc_nlp_put(ndlp);
 	return;
 }
 
-- 
1.7.11.7

