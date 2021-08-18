Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECD4C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0202461058
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhHRJKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 05:10:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54734 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhHRJJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 05:09:10 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9F2D31FF8F;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629277711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jasCYoTQSante0B03rZR5hnYIqUY+XQmJp9qACF5208=;
        b=RqW+VsdnZvgWtGfYkfc6JJQ1r6LAMurveraQj1t+NuCGx02/8yaFNUNV1g2fwUT5im1yLm
        uIk4dZL03UFnGgEYzB4pqszfnWU17yqrrvP3ugf3ztVEvvyTKFwfcd7+UnzI1ULPV3wrkH
        0UvOBCNCvQJuGlAoGimseaq44nELcHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629277711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jasCYoTQSante0B03rZR5hnYIqUY+XQmJp9qACF5208=;
        b=GUYfj1r+8QqSaX+QdhxwnBHL5+0NQuD0B9yZimnGJ9HPTc3w2jcKVLxy4D0pQtLi7ypk0B
        YQS8IxDoNQ8ZlmCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 93F7CA3B93;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8478E518CF56; Wed, 18 Aug 2021 11:08:31 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 1/5] lpfc: kill lpfc_bus_reset_handler
Date:   Wed, 18 Aug 2021 11:08:23 +0200
Message-Id: <20210818090827.134342-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210818090827.134342-1-hare@suse.de>
References: <20210818090827.134342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_bus_reset_handler is really just a loop calling
lpfc_target_reset_handler() over all targets, which is what
the error handler will be doing anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 91 -----------------------------------
 1 file changed, 91 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ee4ff4855866..56ccc66d3d5f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6367,95 +6367,6 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
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
@@ -7035,7 +6946,6 @@ struct scsi_host_template lpfc_template_nvme = {
 	.eh_abort_handler	= lpfc_no_handler,
 	.eh_device_reset_handler = lpfc_no_handler,
 	.eh_target_reset_handler = lpfc_no_handler,
-	.eh_bus_reset_handler	= lpfc_no_handler,
 	.eh_host_reset_handler  = lpfc_no_handler,
 	.slave_alloc		= lpfc_no_slave,
 	.slave_configure	= lpfc_no_slave,
@@ -7060,7 +6970,6 @@ struct scsi_host_template lpfc_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
-- 
2.29.2

