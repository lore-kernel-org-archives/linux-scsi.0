From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: check for valid scsi cmnd in lpfc_scsi_cmd_iocb_cmpl()
Date: Mon, 13 Nov 2017 08:22:29 +0100
Message-ID: <1510557749-59958-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751377AbdKMHWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Nov 2017 02:22:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the 'host_scribble' backpointer doesn't match we need to
skip processing this command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1a6f122..dfdca1d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3938,6 +3938,8 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 	cmd = lpfc_cmd->pCmd;
 	if (!cmd)
 		return;
+	if (cmd->host_scribble != lpfc_cmd)
+		return;
 	shost = cmd->device->host;
 
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
-- 
1.8.5.6
