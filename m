Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4B2C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 209F7610A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhHSJUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:20:01 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60720 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhHSJUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:20:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 48E9E220B4;
        Thu, 19 Aug 2021 09:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/sqV+nQxqbJIMMRrsdw8yQaLaaKoJ2csMtVAjuKcDo=;
        b=gLN30aKljpTigl1o5yTkLd2UCivj1gMqjLSE/Wikf6HpxjyEdHKNDHJ/1K++TUlS/yP3/o
        cVunjj5XxqYgMGbFb70gGAhzp4hoNt/EB0iFV/JVkZQJ1FH5qqnUR4mt73Kdt7cn67o0bg
        UOLikrJDK4tQciMJEqd4dvMtAHTHvrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/sqV+nQxqbJIMMRrsdw8yQaLaaKoJ2csMtVAjuKcDo=;
        b=I0dBzR0/GnQ7ePkTQUjMdYbswjgKeQ1VNN6WHHmXUeloyqPVncRbzA8bsYoiDpMbjQ2bDc
        5CDW7jfQskXdrhAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 85D10A3B9F;
        Thu, 19 Aug 2021 09:19:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 30ECE518D298; Thu, 19 Aug 2021 11:19:24 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] qla2xxx: Do not call fc_block_scsi_eh() during bus reset
Date:   Thu, 19 Aug 2021 11:19:11 +0200
Message-Id: <20210819091913.94436-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091913.94436-1-hare@suse.de>
References: <20210819091913.94436-1-hare@suse.de>
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
index 868037c7d608..54254bd3a7d7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1499,7 +1499,6 @@ static int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
 	unsigned int id;
 	uint64_t lun;
@@ -1515,15 +1514,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
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

