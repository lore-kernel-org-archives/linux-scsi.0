Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350C7C432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C20160FDA
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhHRJJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 05:09:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37052 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhHRJJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 05:09:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A7E3B22037;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629277711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIdYiy0iKbBHORTIyHejjSEDgXXb1z4nGKs8ir/Djz4=;
        b=Lx7wlvbA4s40UROPBdVq1rr+Gw2gsyc1u9qzg8pzEO/mixpUeTfhh72q+st9SKLsVi7boL
        rBuVvq7KaPKZlpAMz8VfacTo5P8YySvJ40aZPPzrhOAnYJmayhm+9MK4ztfeZj7ILwlJ/H
        9i2/cWsU7f4WCnTPbx4gReFQ2J8OxFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629277711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIdYiy0iKbBHORTIyHejjSEDgXXb1z4nGKs8ir/Djz4=;
        b=DOHYAm9wAV7lk4tirst2a4KgefSmw7IklMKF2glvHe9yyaUn9tDoqEiuWx5UmFHNvRBs70
        VOdl1dONrV+DKpBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9F303A3B9A;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8DA77518CF5C; Wed, 18 Aug 2021 11:08:31 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 4/5] lpfc: use rport as argument for lpfc_send_taskmgmt()
Date:   Wed, 18 Aug 2021 11:08:26 +0200
Message-Id: <20210818090827.134342-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210818090827.134342-1-hare@suse.de>
References: <20210818090827.134342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing in a scsi device we should be using the rport;
we already have the target and lun id as parameters, so there's
no need to pass the scsi device, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 9fc1e303f0eb..184ca2a90414 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5980,7 +5980,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 /**
  * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
  * @vport: The virtual port for which this call is being executed.
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @rport: Pointer to remote port
  * @tgt_id: Target ID of remote device.
  * @lun_id: Lun number for the TMF
  * @task_mgmt_cmd: type of TMF to send
@@ -5993,7 +5993,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
  *   0x2002 - Success.
  **/
 static int
-lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
 		   unsigned int tgt_id, uint64_t lun_id,
 		   uint8_t task_mgmt_cmd)
 {
@@ -6006,7 +6006,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	int ret;
 	int status;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode)
 		return FAILED;
 	pnode = rdata->pnode;
@@ -6016,7 +6016,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
-	lpfc_cmd->pCmd = cmnd;
+	lpfc_cmd->pCmd = NULL;
 	lpfc_cmd->ndlp = pnode;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
@@ -6225,7 +6225,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 						FCP_LUN_RESET);
 	if (status != SUCCESS)
 		logit =  LOG_TRACE_EVENT;
@@ -6311,7 +6311,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 					FCP_TARGET_RESET);
 	if (status != SUCCESS) {
 		logit = LOG_TRACE_EVENT;
-- 
2.29.2

