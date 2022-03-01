Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60705C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiCAOi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiCAOiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:38:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8EF270D
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:37:32 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ED3681F448;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GgD/LhzHYNfTByZnocrYDNwh/QHCAL2Vj8E7iXvuebI=;
        b=gvhXqR5cEbSZHrj1JvZYij5nhFtF/1/y/Xt+7rlLdDdXN4r5jci0agct3q3iIXMAti7+sP
        arFplnXSRYuRQSHjIm6FTKCqgkApvXhJAYusarbjvbRnnqWWSMgpEZ3tzK879/kn5iYG5W
        9VNkO9at1xwej9TyHKYGuFRBMc3ad4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145450;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GgD/LhzHYNfTByZnocrYDNwh/QHCAL2Vj8E7iXvuebI=;
        b=MyQuD4txauJLlbqLjnigA2tefJjzc+zYMqOCJQqqLV9cR/6wlly8jrEcCabrPLykNLim0t
        X4TDnYfiz4UdzsDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E29EDA3B97;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id ADC2651933D0; Tue,  1 Mar 2022 15:37:30 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 5/5] lpfc: use rport as argument for lpfc_chk_tgt_mapped()
Date:   Tue,  1 Mar 2022 15:37:18 +0100
Message-Id: <20220301143718.40913-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220301143718.40913-1-hare@suse.de>
References: <20220301143718.40913-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We only need the rport structure for lpfc_chk_tgt_mapped().

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 778e40d751ac..79453dc6593d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6244,7 +6244,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
 /**
  * lpfc_chk_tgt_mapped -
  * @vport: The virtual port to check on
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @rport: Pointer to fc_rport data structure.
  *
  * This routine delays until the scsi target (aka rport) for the
  * command exists (is present and logged in) or we declare it non-existent.
@@ -6254,19 +6254,20 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
  *  0x2002 - Success
  **/
 static int
-lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
+lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 {
 	struct lpfc_rport_data *rdata;
-	struct lpfc_nodelist *pnode;
+	struct lpfc_nodelist *pnode = NULL;
 	unsigned long later;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			"0797 Tgt Map rport failure: rdata x%px\n", rdata);
 		return FAILED;
 	}
 	pnode = rdata->pnode;
+
 	/*
 	 * If target is not in a MAPPED state, delay until
 	 * target is rediscovered or devloss timeout expires.
@@ -6278,7 +6279,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
 			return SUCCESS;
 		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
-		rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+		rdata = rport->dd_data;
 		if (!rdata)
 			return FAILED;
 		pnode = rdata->pnode;
@@ -6371,7 +6372,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	status = lpfc_chk_tgt_mapped(vport, rport);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0721 Device Reset rport failure: rdata x%px\n", rdata);
@@ -6449,7 +6450,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	status = lpfc_chk_tgt_mapped(vport, rport);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0722 Target Reset rport failure: rdata x%px\n", rdata);
-- 
2.29.2

