From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 06/17] lpfc: Fix crash in fcp command completion path.
Date: Wed, 16 Dec 2015 18:11:57 -0500
Message-ID: <5671efbd.clWBAkJdlw7R8CdX%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34182 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbbLPXMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:16 -0500
Received: by mail-pf0-f181.google.com with SMTP id 68so19522161pfc.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:16 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id p86sm7013461pfa.54.2015.12.16.15.12.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix crash in fcp command completion path.

Missed null check.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d51f751..3162469 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3908,9 +3908,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	uint32_t logit = LOG_FCP;
 
 	/* Sanity check on return of outstanding command */
-	if (!(lpfc_cmd->pCmd))
-		return;
 	cmd = lpfc_cmd->pCmd;
+	if (!cmd)
+		return;
 	shost = cmd->device->host;
 
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
-- 
1.7.11.7

