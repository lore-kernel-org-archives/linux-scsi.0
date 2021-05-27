Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433CDC4708A
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 07:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 261686128D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 07:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhE0HXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 03:23:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:36646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233922AbhE0HXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 03:23:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622100139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5TrUMDDPxUDMEVSIphjaLjg5YVPRjiknn289NppN0gM=;
        b=WWkljhlNfglxDlrS+2AnUnHRr9htOqaR0KGNSHvuHSCZXI2+ZaKwDPYWNt6FobLBrY1GEu
        duPvgOvOSoKdf0bSgIPdKUiTKZlkFJ/yQD2x59lP5Rdu20VkZBuMUvN90N0wT1EdLBDSBs
        qnhJLMtJ7ap+qJ0cSwcZselwrpbQ2eQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622100139;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5TrUMDDPxUDMEVSIphjaLjg5YVPRjiknn289NppN0gM=;
        b=UlOJQ2MIHTXaP6GAGW/wSBwAq0a8/lXb9tosmVaEtTO3Q6xGVq4giIVXf+ZOKDzQob3swg
        d/DJLLFAghPS7+Cw==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EDE18AAA6;
        Thu, 27 May 2021 07:22:18 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] pcmcia/nsp_cs: Use SAM_STAT_CHECK_CONDITION
Date:   Thu, 27 May 2021 09:22:17 +0200
Message-Id: <20210527072217.117126-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The nsp_cs driver stores the SAM status values in SCp.Status, so
we need to use the non-shifted version SAM_STAT_CHECK_CONDITION.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pcmcia/nsp_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index ac89002646a3..7c0f931e55e8 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -221,7 +221,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	data->CurrentSC		= SCpnt;
 
-	SCpnt->SCp.Status	= CHECK_CONDITION;
+	SCpnt->SCp.Status	= SAM_STAT_CHECK_CONDITION;
 	SCpnt->SCp.Message	= 0;
 	SCpnt->SCp.have_data_in = IO_UNKNOWN;
 	SCpnt->SCp.sent_command = 0;
-- 
2.29.2

