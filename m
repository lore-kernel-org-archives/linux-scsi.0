Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5BDC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F2B60F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhHQJRS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47382 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BF42820010;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wE+IuMR3maVKhzxjUCj0UsBdatXqeF1DUTIU1dkY5e4=;
        b=LBdSHUStqdoz+KakDUd3DpQ/x0I5eQ39Nbn9KxOShjx7s/KL6Qi97BZQBnSZXSnm4c49hv
        5LdDNqQah4AjF+VtDPZBnovJ+Sf4vcMuNW4Yj4+vUetUp3iXyx/kq6veJ/SL4hEvXhEfh1
        rhbmR6WWi/i4gle54xBnGPxpu+EsJv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wE+IuMR3maVKhzxjUCj0UsBdatXqeF1DUTIU1dkY5e4=;
        b=YSGNuGAGn9mY7RGdGC1qAVtwj9I/qy97ysNd8k1+G0bnhq8jMQ2ttjBb1L9iySs9CKQ04B
        xqxsWjJq/1R1PABw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B34BAA3B93;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A1595518CE63; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 02/51] lpfc: drop lpfc_no_handler()
Date:   Tue, 17 Aug 2021 11:14:07 +0200
Message-Id: <20210817091456.73342-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The default SCSI EH action for a non-existing EH callback is to
return FAILED, so having a callback just returning FAILED is pointless.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 56ccc66d3d5f..48b932608ffb 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6925,12 +6925,6 @@ lpfc_no_command(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static int
-lpfc_no_handler(struct scsi_cmnd *cmnd)
-{
-	return FAILED;
-}
-
 static int
 lpfc_no_slave(struct scsi_device *sdev)
 {
@@ -6943,10 +6937,6 @@ struct scsi_host_template lpfc_template_nvme = {
 	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_no_command,
-	.eh_abort_handler	= lpfc_no_handler,
-	.eh_device_reset_handler = lpfc_no_handler,
-	.eh_target_reset_handler = lpfc_no_handler,
-	.eh_host_reset_handler  = lpfc_no_handler,
 	.slave_alloc		= lpfc_no_slave,
 	.slave_configure	= lpfc_no_slave,
 	.scan_finished		= lpfc_scan_finished,
-- 
2.29.2

