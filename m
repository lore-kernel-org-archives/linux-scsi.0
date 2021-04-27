Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2E9C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D8B600D4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhD0IcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235112AbhD0Ibv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:31:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 44E65B007;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/40] scsi: do not use DRIVER_INVALID
Date:   Tue, 27 Apr 2021 10:30:16 +0200
Message-Id: <20210427083046.31620-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no point in returning DID_ABORT together with DRIVER_INVALID,
as the caller couldn't care less where the abort originated.
So drop the use of DRIVER_INVALID.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hptiop.c     | 2 +-
 drivers/scsi/mvumi.c      | 4 ++--
 drivers/scsi/vmw_pvscsi.c | 3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index db4c7a7ff4dd..61cda7b7624f 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -760,7 +760,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 		goto skip_resid;
 
 	default:
-		scp->result = DRIVER_INVALID << 24 | DID_ABORT << 16;
+		scp->result = DID_ABORT << 16;
 		break;
 	}
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index f61250545025..6bb03d7a254d 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1320,7 +1320,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		}
 		break;
 	default:
-		scmd->result |= (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+		scmd->result |= (DID_ABORT << 16);
 		break;
 	}
 
@@ -2127,7 +2127,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	else
 		atomic_dec(&mhba->fw_outstanding);
 
-	scmd->result = (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+	scmd->result = (DID_ABORT << 16);
 	scmd->SCp.ptr = NULL;
 	if (scsi_bufflen(scmd)) {
 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index f0707eaad9f7..f57f8bc037d2 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -601,9 +601,6 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_LUNMISMATCH:
 		case BTSTAT_TAGREJECT:
 		case BTSTAT_BADMSG:
-			cmd->result = (DRIVER_INVALID << 24);
-			fallthrough;
-
 		case BTSTAT_HAHARDWARE:
 		case BTSTAT_INVPHASE:
 		case BTSTAT_HATIMEOUT:
-- 
2.29.2

