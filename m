Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5E4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbiCAOiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbiCAOiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:38:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32896266B
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:37:32 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E27031F3A3;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgeG720mPbg+c7LUkQztRgE+InVkxbT1B4UM/8Zp7fg=;
        b=K77eu3gW6+jEy9BPskYCOK7IzjseO8EcXo2jhvotXGDIz7pujNARUgrVZbQ/DmkyWsQ0fq
        w1gN92+NZBMuG4qoDOQ9dz0APuQHxlPxdJ2W8b0anRPQUJ5VoEvdbBN4pBYPP4OVwYdZW1
        374pFwRVaJICQlZuT4eNWzCxJ3JcI3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145450;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgeG720mPbg+c7LUkQztRgE+InVkxbT1B4UM/8Zp7fg=;
        b=ho/cr2rDlRMQAj9NX89xNdsIXGTDaOK+VGnLXAvqGLuncyWl+Z84MI906p8rIxO5HJJr/C
        S7FZEySktX84KZBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B9659A3B94;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A89A151933CE; Tue,  1 Mar 2022 15:37:30 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 4/5] lpfc: use rport as argument for lpfc_send_taskmgmt()
Date:   Tue,  1 Mar 2022 15:37:17 +0100
Message-Id: <20220301143718.40913-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220301143718.40913-1-hare@suse.de>
References: <20220301143718.40913-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing in a scsi device we should be using the rport;
we already have the target and lun id as parameters, so there's
no need to pass the scsi device, too.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4d55bcb627db..778e40d751ac 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6142,7 +6142,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 /**
  * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
  * @vport: The virtual port for which this call is being executed.
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @rport: Pointer to remote port
  * @tgt_id: Target ID of remote device.
  * @lun_id: Lun number for the TMF
  * @task_mgmt_cmd: type of TMF to send
@@ -6155,7 +6155,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
  *   0x2002 - Success.
  **/
 static int
-lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
 		   unsigned int tgt_id, uint64_t lun_id,
 		   uint8_t task_mgmt_cmd)
 {
@@ -6168,7 +6168,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	int ret;
 	int status;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode)
 		return FAILED;
 	pnode = rdata->pnode;
@@ -6178,7 +6178,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
-	lpfc_cmd->pCmd = cmnd;
+	lpfc_cmd->pCmd = NULL;
 	lpfc_cmd->ndlp = pnode;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
@@ -6387,7 +6387,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 						FCP_LUN_RESET);
 	if (status != SUCCESS)
 		logit =  LOG_TRACE_EVENT;
@@ -6473,7 +6473,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 					FCP_TARGET_RESET);
 	if (status != SUCCESS) {
 		logit = LOG_TRACE_EVENT;
-- 
2.29.2

