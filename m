Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B699C432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2915661053
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhHRJKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 05:10:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54746 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhHRJJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 05:09:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A886B1FF99;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629277711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/w78bU5BTISl6mKqzMILw4ZOv0wl8D2lSw/v3klZTfQ=;
        b=rlGu3ucpre9boK5g+s6S6Flx2ChK75zvTa/eKGuuj4wlfMpvoEstxuJ61VCjDWA1ju/r+O
        RW6j77fjp6Td1R9TieSvGA+u8iX4eiZQcpnQ4Po+OafKpHrfdEamgx1wGrzGJgC9X1Kw9V
        yv9g7ySj70/EDml8ZlV3mSpuY2d9MyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629277711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/w78bU5BTISl6mKqzMILw4ZOv0wl8D2lSw/v3klZTfQ=;
        b=yemVEYMSovGl/6Eq2v4ADq796h8u67kaeSFeKlnmlze4CxevkhpLSJv9hemsZrL/I+dljm
        puschMB4a/gon8AQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A07B5A3B9E;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8A47D518CF5A; Wed, 18 Aug 2021 11:08:31 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 3/5] lpfc: use fc_block_rport()
Date:   Wed, 18 Aug 2021 11:08:25 +0200
Message-Id: <20210818090827.134342-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210818090827.134342-1-hare@suse.de>
References: <20210818090827.134342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
will be removed as argument for SCSI EH functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 48b932608ffb..9fc1e303f0eb 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6187,6 +6187,7 @@ static int
 lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
@@ -6196,7 +6197,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	int status;
 	u32 logit = LOG_FCP;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0798 Device Reset rdata failure: rdata x%px\n",
@@ -6204,7 +6205,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_rport(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -6261,6 +6262,7 @@ static int
 lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
@@ -6273,7 +6275,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0799 Target Reset rdata failure: rdata x%px\n",
@@ -6281,7 +6283,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_rport(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-- 
2.29.2

