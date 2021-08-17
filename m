Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37C6C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F7060F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhHQJRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:25 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33302 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1092721D1C;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRQjIvn88nKilpzDQwexcfZLv6sotDCud9QpMCrTNX8=;
        b=KzWJQ49YunTF46umJTs2luOAF8YCfr0uobd9AE/305B9VvU0O12IoC6mTShruhzjmaig5a
        tZX8fJfSFrvbtRUXVmYz7oQ9jOdvV4whjttGkHDGtVaF//WJpZpvHVFNiD3Kk5oZVQkLDF
        8hnuKNL2N3LPaN3qaGqKSgndG+jo6to=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRQjIvn88nKilpzDQwexcfZLv6sotDCud9QpMCrTNX8=;
        b=WQs13IA47DBr+QCscJzgLDtcD69B3V5Y+SiRsvPmzecqzFYlUhjUqj5eGRrXxyQx1A2lgZ
        V7tBwF/psSsdZnCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 06E49A3BA3;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 03E6F518CE7F; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 16/51] qla2xxx: Do not call fc_block_scsi_eh() during bus reset
Date:   Tue, 17 Aug 2021 11:14:21 +0200
Message-Id: <20210817091456.73342-17-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When calling bus reset the driver will be doing a full SAN resync
anyway, so there is no need to wait for any pending RSCNs; they'll
be re-issued during resync anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 64820a3d34dd..a84a85288c2e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1538,7 +1538,6 @@ static int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
 	unsigned int id;
 	uint64_t lun;
@@ -1554,15 +1553,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
-	if (!fcport) {
-		return ret;
-	}
-
-	ret = fc_block_scsi_eh(cmd);
-	if (ret != 0)
-		return ret;
-	ret = FAILED;
-
 	if (qla2x00_chip_is_down(vha))
 		return ret;
 
-- 
2.29.2

