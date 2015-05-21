From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 04/15] lpfc: Correct reference counting of rport
Date: Thu, 21 May 2015 13:55:19 -0400
Message-ID: <555e1c07.dPcUVpmrrj6KDZ3q%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34460 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbbEURzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:25 -0400
Received: by qkgx75 with SMTP id x75so61582022qkg.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:24 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id b5sm13764875qkh.36.2015.05.21.10.55.23
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct reference counting of rport

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 72388a6..e93705d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -161,7 +161,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			ndlp->rport = NULL;
 			if (put_node)
 				lpfc_nlp_put(ndlp);
-			put_device(&rport->dev);
+			if (put_rport)
+				put_device(&rport->dev);
 			return;
 		}
 
-- 
1.7.11.7

