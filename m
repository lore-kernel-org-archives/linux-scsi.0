Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F4DC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5E460FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbhHQJRs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:48 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47642 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4EF8120020;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxeY5QszmYMOPruGd/89hd4F/74QafagIg/0WVeAxNY=;
        b=PDCWZbHpxI6sTGq+FEYWMCpkWz9GEKQyidewHfd9vQfByBvb++3I16YdU5Yo2EO6FpnN6b
        DOHdKLIHtYzjHE12PfY3PcfTLnLApDt5iPpbNR4XXyJsqaQadcK+0dwgx6bS/on8lxPkZG
        F1XwFuZQ2Kq/5fc0oIXcMEOytEJ3qNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxeY5QszmYMOPruGd/89hd4F/74QafagIg/0WVeAxNY=;
        b=x71PTpcJyGBR33sgnznv8UgNG2E9mSMkgpjNnIle0Kc2h5n8wFG3bQL9qZHdJOVQAzPnRG
        8/FV4ydNot8QbxDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 477D0A3BA8;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 4405A518CE93; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 26/51] lpfc: use rport as argument for lpfc_send_taskmgmt()
Date:   Tue, 17 Aug 2021 11:14:31 +0200
Message-Id: <20210817091456.73342-27-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing in a scsi device we should be using the rport;
we already have the target and lun id as parameters, so there's
no need to pass the scsi device, too.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0bbf767f7253..78ca8fa9495f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5981,7 +5981,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 /**
  * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
  * @vport: The virtual port for which this call is being executed.
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @rport: Pointer to remote port
  * @tgt_id: Target ID of remote device.
  * @lun_id: Lun number for the TMF
  * @task_mgmt_cmd: type of TMF to send
@@ -5994,7 +5994,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
  *   0x2002 - Success.
  **/
 static int
-lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
 		   unsigned int tgt_id, uint64_t lun_id,
 		   uint8_t task_mgmt_cmd)
 {
@@ -6007,7 +6007,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	int ret;
 	int status;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode)
 		return FAILED;
 	pnode = rdata->pnode;
@@ -6017,7 +6017,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
-	lpfc_cmd->pCmd = cmnd;
+	lpfc_cmd->pCmd = NULL;
 	lpfc_cmd->ndlp = pnode;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
@@ -6226,7 +6226,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 						FCP_LUN_RESET);
 	if (status != SUCCESS)
 		logit =  LOG_TRACE_EVENT;
@@ -6312,7 +6312,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 					FCP_TARGET_RESET);
 	if (status != SUCCESS) {
 		logit = LOG_TRACE_EVENT;
-- 
2.29.2

