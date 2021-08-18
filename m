Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD93CC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8592D6108E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhHRJKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 05:10:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37046 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhHRJJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 05:09:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A0C1622013;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629277711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5DRSwZs5JiIaBrLPjn28fvoW5J8kelhCfwavgOM2aU=;
        b=Djiw82tiBAH1dBXX7lAx4utHXTaiQVJIS3MwFi7Spd0JrUSrazwBaHJztUAaMB8zmTjlBd
        4TxDxtDDwvl1EB6XqyBOcP6XgsPeYXkNsbEl9tUFfut4V/2NiL2vuH+id12RJj7EM9Mpst
        Vg3/zXxrWrF7wAPfk7YzmokrFl0wQ5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629277711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5DRSwZs5JiIaBrLPjn28fvoW5J8kelhCfwavgOM2aU=;
        b=OyFSfnzvpNf5v18lZtE9F1VndHDrWx1xjikhn35mkUE7PT5XG1A1lSCT9kEQkLoFEjV4sE
        pwiTp7e2sqQBZIAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9A349A3B99;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 86BD5518CF58; Wed, 18 Aug 2021 11:08:31 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 2/5] lpfc: drop lpfc_no_handler()
Date:   Wed, 18 Aug 2021 11:08:24 +0200
Message-Id: <20210818090827.134342-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210818090827.134342-1-hare@suse.de>
References: <20210818090827.134342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The default SCSI EH action for a non-existing EH callback is to
return FAILED, so having a callback just returning FAILED is pointless.

Cc: James Smart <james.smart@broadcom.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

