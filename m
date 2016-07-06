From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 08/21] lpfc: Fix SLI mode 2 config failure
Date: Wed, 06 Jul 2016 12:36:01 -0700
Message-ID: <577d5da1.howAJT6W/zY/7Gi8%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36104 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbcGFTgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:07 -0400
Received: by mail-wm0-f54.google.com with SMTP id f126so185561543wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:06 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id o10sm5158592wjs.38.2016.07.06.12.36.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix SLI mode 2 config failure

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6eef972..b1ddbaa 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4696,6 +4696,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 				"Not supported by adapter.\n");
 	if (rc && mode != 2)
 		rc = lpfc_sli_config_port(phba, 2);
+	else if (rc && mode == 2)
+		rc = lpfc_sli_config_port(phba, 3);
 	if (rc)
 		goto lpfc_sli_hba_setup_error;
 
-- 
2.5.0

