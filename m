Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB02FCA9EA3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C476B222C3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504695AbfJRHuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:50:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36798 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504690AbfJRHuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 03:50:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 532E3B822;
        Fri, 18 Oct 2019 07:50:12 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 2/3] lpfc: access nodelist through scsi-specific rdata pointer
Date:   Fri, 18 Oct 2019 09:50:09 +0200
Message-Id: <20191018075010.55653-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191018075010.55653-1-hare@suse.de>
References: <20191018075010.55653-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Access the nodelist through the scsi-specific rdata pointer when
handling SCSI requests.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index bb66dfb8dd71..5f80ec31afb7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -808,8 +808,8 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 static void
 lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 {
-	if ((psb->flags & LPFC_SBUF_BUMP_QDEPTH) && psb->ndlp)
-		atomic_dec(&psb->ndlp->cmd_pending);
+	if ((psb->flags & LPFC_SBUF_BUMP_QDEPTH) && psb->scsi.rdata->pnode)
+		atomic_dec(&psb->scsi.rdata->pnode->cmd_pending);
 
 	psb->flags &= ~LPFC_SBUF_BUMP_QDEPTH;
 	phba->lpfc_release_scsi_buf(phba, psb);
@@ -4580,7 +4580,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	 */
 	lpfc_cmd->scsi.pCmd  = cmnd;
 	lpfc_cmd->scsi.rdata = rdata;
-	lpfc_cmd->ndlp = ndlp;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
 	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
@@ -5035,7 +5034,6 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->scsi.rdata = rdata;
 	lpfc_cmd->scsi.pCmd = cmnd;
-	lpfc_cmd->ndlp = pnode;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
 					   task_mgmt_cmd);
-- 
2.16.4

