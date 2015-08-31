From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 02/14] lpfc: Remove unnessary cast
Date: Mon, 31 Aug 2015 16:48:09 -0400
Message-ID: <55e4bd89.wnXoOtgVrknAjUqh%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33836 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbHaUsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:25 -0400
Received: by qgtt94 with SMTP id t94so22801481qgt.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:24 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id n10sm9523373qki.24.2015.08.31.13.48.23
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Firo Yang <firogm@gmail.com>

kzalloc() returns a void pointer - no need to cast it in
drivers/scsi/lpfc/lpfc_init.c::lpfc_sli_driver_resource_setup()

Signed-off-by: Firo Yang <firogm@gmail.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1992e74..da9b6fc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4982,8 +4982,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
-- 
1.7.11.7

