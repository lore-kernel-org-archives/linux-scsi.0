Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6164C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiCAOiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbiCAOiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:38:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324592657
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:37:32 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E31FA218EE;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bPpcU1xwBVbkiZPSfc4eUd3kFZL/CVMiDtkgpl+v38=;
        b=Z76RfnHeOydEEk8r14vrtewGAPfAud/AqxkOQ71hzZhH+asmlj0yL94xgCZPpWyPRWhRAj
        QPJql9M+tlIOpY5UXLbBcvhXXNiFsQ/0HcflarnYpRBypl/q1jywXck20Mq/Jo6R/4ATfc
        2HhSJJzpVWbRh/NdNM8iBTgGHXS/M98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145450;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bPpcU1xwBVbkiZPSfc4eUd3kFZL/CVMiDtkgpl+v38=;
        b=UmQnUEV5rtLEtFiby/Ge/Vs3bQsbjtrWRcIXSd/r+YcIZh585w9PKABPw5taqJwW5/KzAA
        rek4tSdRcNTFu+Aw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A6EF8A3B90;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9898651933C8; Tue,  1 Mar 2022 15:37:30 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 1/5] lpfc: kill lpfc_bus_reset_handler
Date:   Tue,  1 Mar 2022 15:37:14 +0100
Message-Id: <20220301143718.40913-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220301143718.40913-1-hare@suse.de>
References: <20220301143718.40913-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_bus_reset_handler is really just a loop calling
lpfc_target_reset_handler() over all targets, which is what
the error handler will be doing anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 91 -----------------------------------
 1 file changed, 91 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5a3da38a9067..a061b4ed4b00 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6528,95 +6528,6 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	return status;
 }
 
-/**
- * lpfc_bus_reset_handler - scsi_host_template eh_bus_reset_handler entry point
- * @cmnd: Pointer to scsi_cmnd data structure.
- *
- * This routine does target reset to all targets on @cmnd->device->host.
- * This emulates Parallel SCSI Bus Reset Semantics.
- *
- * Return code :
- *  0x2003 - Error
- *  0x2002 - Success
- **/
-static int
-lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
-{
-	struct Scsi_Host  *shost = cmnd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_nodelist *ndlp = NULL;
-	struct lpfc_scsi_event_header scsi_event;
-	int match;
-	int ret = SUCCESS, status, i;
-	u32 logit = LOG_FCP;
-
-	scsi_event.event_type = FC_REG_SCSI_EVENT;
-	scsi_event.subcategory = LPFC_EVENT_BUSRESET;
-	scsi_event.lun = 0;
-	memcpy(scsi_event.wwpn, &vport->fc_portname, sizeof(struct lpfc_name));
-	memcpy(scsi_event.wwnn, &vport->fc_nodename, sizeof(struct lpfc_name));
-
-	fc_host_post_vendor_event(shost, fc_get_event_number(),
-		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
-
-	status = fc_block_scsi_eh(cmnd);
-	if (status != 0 && status != SUCCESS)
-		return status;
-
-	/*
-	 * Since the driver manages a single bus device, reset all
-	 * targets known to the driver.  Should any target reset
-	 * fail, this routine returns failure to the midlayer.
-	 */
-	for (i = 0; i < LPFC_MAX_TARGET; i++) {
-		/* Search for mapped node by target ID */
-		match = 0;
-		spin_lock_irq(shost->host_lock);
-		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-
-			if (vport->phba->cfg_fcp2_no_tgt_reset &&
-			    (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE))
-				continue;
-			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
-			    ndlp->nlp_sid == i &&
-			    ndlp->rport &&
-			    ndlp->nlp_type & NLP_FCP_TARGET) {
-				match = 1;
-				break;
-			}
-		}
-		spin_unlock_irq(shost->host_lock);
-		if (!match)
-			continue;
-
-		status = lpfc_send_taskmgmt(vport, cmnd,
-					i, 0, FCP_TARGET_RESET);
-
-		if (status != SUCCESS) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "0700 Bus Reset on target %d failed\n",
-					 i);
-			ret = FAILED;
-		}
-	}
-	/*
-	 * We have to clean up i/o as : they may be orphaned by the TMFs
-	 * above; or if any of the TMFs failed, they may be in an
-	 * indeterminate state.
-	 * We will report success if all the i/o aborts successfully.
-	 */
-
-	status = lpfc_reset_flush_io_context(vport, 0, 0, LPFC_CTX_HOST);
-	if (status != SUCCESS)
-		ret = FAILED;
-	if (ret == FAILED)
-		logit =  LOG_TRACE_EVENT;
-
-	lpfc_printf_vlog(vport, KERN_ERR, logit,
-			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
-	return ret;
-}
-
 /**
  * lpfc_host_reset_handler - scsi_host_template eh_host_reset_handler entry pt
  * @cmnd: Pointer to scsi_cmnd data structure.
@@ -7203,7 +7114,6 @@ struct scsi_host_template lpfc_template_nvme = {
 	.eh_abort_handler	= lpfc_no_handler,
 	.eh_device_reset_handler = lpfc_no_handler,
 	.eh_target_reset_handler = lpfc_no_handler,
-	.eh_bus_reset_handler	= lpfc_no_handler,
 	.eh_host_reset_handler  = lpfc_no_handler,
 	.slave_alloc		= lpfc_no_slave,
 	.slave_configure	= lpfc_no_slave,
@@ -7228,7 +7138,6 @@ struct scsi_host_template lpfc_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
-- 
2.29.2

