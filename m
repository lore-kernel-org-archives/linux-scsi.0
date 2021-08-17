Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7028C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03D360F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbhHQJRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33314 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbhHQJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5341F21D59;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHukD+fxkR3OwfdNORx0IpX5NUC9llmrrM8RXhfaFzs=;
        b=CzbRbOMgMvL9Rt1IHuMqrJVd06nunvLIChRXusLG5nmGj5/i/OawKBlUpLqGaSA6t5RKfB
        oJgE02Mkr+LGeW3IfL4YfHet7XtaQoYi8uzV5ZBqixgm87jW+YZgeUYW7Pc5nmSooTlPJt
        au8I6L+YJjAEGVcl8ILyZyQ+ASgN4Qc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHukD+fxkR3OwfdNORx0IpX5NUC9llmrrM8RXhfaFzs=;
        b=TxmLxvx0HBI7tDavmmS+kQZARimd/whWUHg8p+Jt+T4fiNpEFrwAX91SwNg5BfUgtSV7+z
        7G7SMDFxCjXQIZDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4D0C2A3BAA;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 4A819518CE95; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 27/51] lpfc: use rport as argument for lpfc_chk_tgt_mapped()
Date:   Tue, 17 Aug 2021 11:14:32 +0200
Message-Id: <20210817091456.73342-28-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We only need the rport structure for lpfc_chk_tgt_mapped().

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 78ca8fa9495f..925f304166f5 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6083,7 +6083,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
 /**
  * lpfc_chk_tgt_mapped -
  * @vport: The virtual port to check on
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @rport: Pointer to fc_rport data structure.
  *
  * This routine delays until the scsi target (aka rport) for the
  * command exists (is present and logged in) or we declare it non-existent.
@@ -6093,19 +6093,20 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
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
@@ -6117,7 +6118,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
 			return SUCCESS;
 		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
-		rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+		rdata = rport->dd_data;
 		if (!rdata)
 			return FAILED;
 		pnode = rdata->pnode;
@@ -6210,7 +6211,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	status = lpfc_chk_tgt_mapped(vport, rport);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0721 Device Reset rport failure: rdata x%px\n", rdata);
@@ -6288,7 +6289,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	status = lpfc_chk_tgt_mapped(vport, rport);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0722 Target Reset rport failure: rdata x%px\n", rdata);
-- 
2.29.2

