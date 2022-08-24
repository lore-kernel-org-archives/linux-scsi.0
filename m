Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B108DC32792
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Aug 2022 06:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiHXGAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Aug 2022 02:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHXGAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2022 02:00:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B804456A
        for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2022 23:00:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 83B571FABA;
        Wed, 24 Aug 2022 06:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661320834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ThFT0lFo/T1lvLwlXVMvcWQuqnGGzpwMMeqOkKvhCLk=;
        b=HxlXmDr4Jv2JT2zIagQ1VZGFqVBBSF+LWAg00DHHm6Wq0ZG3LjKCgkdLuPJvUVdYbIam6f
        SydD3TFX64gZzsStnqdckL7cYY5Y7FR4Qy5MLRuw/kilIndHxqfQ3diQklgZmEiQJJ00aZ
        /OnGXuCoaCxnkoz9uM9tRK9qMzRQ2iU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661320834;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ThFT0lFo/T1lvLwlXVMvcWQuqnGGzpwMMeqOkKvhCLk=;
        b=kf/pQaN5raDBT12C1dxd705Q9HauaEYJs+wzbidNC8IGFg2Eeocv9+JY7odfY/KyVtuc97
        fpCeXXAOzb+/zVBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 7B9452C142;
        Wed, 24 Aug 2022 06:00:34 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6D05051A9937; Wed, 24 Aug 2022 08:00:34 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE
Date:   Wed, 24 Aug 2022 08:00:33 +0200
Message-Id: <20220824060033.138661-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the driver hits on an internal error condition returning
DID_REQUEUE will cause I/O to be retried on the same ITL nexus.
This will inhibit multipathing, resulting in endless retries
even if the error could have been resolved by using a different
ITL nexus.
So return DID_TRANSPORT_DISRUPTED to allow for multipath to engage
and route I/O to another ITL nexus.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 084c0f9fdc3a..938a5e435943 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4272,7 +4272,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 		    lpfc_cmd->result == IOERR_RPI_SUSPENDED ||
 		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-			cmd->result = DID_REQUEUE << 16;
+			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			break;
 		}
 		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4562,7 +4562,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-				cmd->result = DID_REQUEUE << 16;
+				cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 				break;
 			}
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
-- 
2.35.3

