Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BEFCA9ED3
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 318EB20656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfKDJCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:57306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728287AbfKDJCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33EC4B4B7;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 44/52] scsi: do not use DRIVER_INVALID
Date:   Mon,  4 Nov 2019 10:01:43 +0100
Message-Id: <20191104090151.129140-45-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DID_ERROR instead of DRIVER_INVALID, as it really doesn't
matter if the driver or the device didn't understand the command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 3 +--
 drivers/scsi/hptiop.c       | 2 +-
 drivers/scsi/mvumi.c        | 4 ++--
 drivers/scsi/vmw_pvscsi.c   | 3 ---
 include/scsi/scsi.h         | 2 --
 include/trace/events/scsi.h | 3 +--
 6 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 1780837ea11e..1cee98534bfd 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -407,8 +407,7 @@ static const char * const hostbyte_table[]={
 "DID_NEXUS_FAILURE" };
 
 static const char * const driverbyte_table[]={
-"DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
-"DRIVER_INVALID"};
+"DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR"};
 
 const char *scsi_hostbyte_string(int result)
 {
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 6a2561f26e38..e940d297fb96 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -761,7 +761,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 		break;
 
 	default:
-		scp->result = DRIVER_INVALID << 24 | DID_ABORT << 16;
+		scp->result = (DID_ABORT << 16);
 		break;
 	}
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 91eb879692c3..c53e74e796d8 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1319,7 +1319,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		}
 		break;
 	default:
-		scmd->result |= (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+		scmd->result |= (DID_ABORT << 16);
 		break;
 	}
 
@@ -2126,7 +2126,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	else
 		atomic_dec(&mhba->fw_outstanding);
 
-	scmd->result = (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+	scmd->result = (DID_ABORT << 16);
 	scmd->SCp.ptr = NULL;
 	if (scsi_bufflen(scmd)) {
 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 74e5ed940952..76ed02f4920b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -590,9 +590,6 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_LUNMISMATCH:
 		case BTSTAT_TAGREJECT:
 		case BTSTAT_BADMSG:
-			cmd->result = (DRIVER_INVALID << 24);
-			/* fall through */
-
 		case BTSTAT_HAHARDWARE:
 		case BTSTAT_INVPHASE:
 		case BTSTAT_HATIMEOUT:
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 274cc9e77634..4afb5e8a0a58 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -170,8 +170,6 @@ static inline int scsi_is_wlun(u64 lun)
 #define DRIVER_MEDIA        0x03
 #define DRIVER_ERROR        0x04
 
-#define DRIVER_INVALID      0x05
-
 /*
  * Internal return values.
  */
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index a1b4da442c5c..83bc7d97a469 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -131,8 +131,7 @@
 		scsi_driverbyte_name(DRIVER_BUSY),		\
 		scsi_driverbyte_name(DRIVER_SOFT),		\
 		scsi_driverbyte_name(DRIVER_MEDIA),		\
-		scsi_driverbyte_name(DRIVER_ERROR),		\
-		scsi_driverbyte_name(DRIVER_INVALID))
+		scsi_driverbyte_name(DRIVER_ERROR))
 
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
-- 
2.16.4

