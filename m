Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F65C1B0D9
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2660323428
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLGMuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:50:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:43222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgLGMuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:50:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CC329AE87;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/35] hpsa: do not set COMMAND_COMPLETE
Date:   Mon,  7 Dec 2020 13:48:00 +0100
Message-Id: <20201207124819.95822-17-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

COMMAND_COMPLETE is defined as '0', and it is a SCSI parallel message
to boot. So drop the call to set_msg_byte().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/hpsa.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f10489e4f804..2ccf5596c9cf 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2396,7 +2396,6 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			break;
 		case IOACCEL2_STATUS_SR_UNDERRUN:
 			cmd->result = (DID_OK << 16);		/* host byte */
-			cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
 			ioaccel2_resid = get_unaligned_le32(
 						&c2->error_data.resid_cnt[0]);
 			scsi_set_resid(cmd, ioaccel2_resid);
@@ -2597,8 +2596,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		(c2->sg[0].chain_indicator == IOACCEL2_CHAIN))
 		hpsa_unmap_ioaccel2_sg_chain_block(h, c2);
 
-	cmd->result = (DID_OK << 16); 		/* host byte */
-	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
+	cmd->result = (DID_OK << 16);		/* host byte */
 
 	/* SCSI command has already been cleaned up in SML */
 	if (dev->was_removed) {
-- 
2.16.4

