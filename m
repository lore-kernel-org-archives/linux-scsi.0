Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2E8CA9ED0
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F04722086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfJaLFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:37466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727543AbfJaLFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15997B37F;
        Thu, 31 Oct 2019 11:05:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/24] scsi: do not use DRIVER_INVALID
Date:   Thu, 31 Oct 2019 12:04:45 +0100
Message-Id: <20191031110452.73463-18-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DID_ERROR instead of DRIVER_INVALID, as it really doesn't
matter if the driver or the device didn't understand the command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    |  3 +--
 drivers/scsi/hptiop.c       |  2 +-
 drivers/scsi/mvumi.c        | 10 +++++-----
 drivers/scsi/vmw_pvscsi.c   | 18 +++++++++---------
 include/scsi/scsi.h         |  2 --
 include/trace/events/scsi.h |  3 +--
 6 files changed, 17 insertions(+), 21 deletions(-)

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
index 6a2561f26e38..2cfb58c2e175 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -761,7 +761,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 		break;
 
 	default:
-		scp->result = DRIVER_INVALID << 24 | DID_ABORT << 16;
+		scp->result = (DID_ERROR << 16);
 		break;
 	}
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 91eb879692c3..cbeb1c0e62f2 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1306,20 +1306,20 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 
 	switch (ob_frame->req_status) {
 	case SAM_STAT_GOOD:
-		scmd->result |= DID_OK << 16;
+		set_host_byte(scmd, DID_OK);
 		break;
 	case SAM_STAT_BUSY:
-		scmd->result |= DID_BUS_BUSY << 16;
+		set_host_byte(scmd, DID_BUS_BUSY);
 		break;
 	case SAM_STAT_CHECK_CONDITION:
-		scmd->result |= (DID_OK << 16);
+		set_host_byte(scmd, DID_OK);
 		if (ob_frame->rsp_flag & CL_RSP_FLAG_SENSEDATA) {
 			memcpy(cmd->scmd->sense_buffer, ob_frame->payload,
 				sizeof(struct mvumi_sense_data));
 		}
 		break;
 	default:
-		scmd->result |= (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+		set_host_byte(scmd, DID_ABORT);
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
index 74e5ed940952..e988a8c3fc7f 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -572,25 +572,25 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_LINKED_COMMAND_COMPLETED:
 		case BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG:
 			/* If everything went fine, let's move on..  */
-			cmd->result = (DID_OK << 16);
+			set_host_byte(cmd, DID_OK);
 			break;
 
 		case BTSTAT_DATARUN:
 		case BTSTAT_DATA_UNDERRUN:
 			/* Report residual data in underruns */
 			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
-			cmd->result = (DID_ERROR << 16);
+			set_host_byte(cmd, DID_ERROR);
 			break;
 
 		case BTSTAT_SELTIMEO:
 			/* Our emulation returns this for non-connected devs */
-			cmd->result = (DID_BAD_TARGET << 16);
+			set_host_byte(cmd, DID_BAD_TARGET);
 			break;
 
 		case BTSTAT_LUNMISMATCH:
 		case BTSTAT_TAGREJECT:
 		case BTSTAT_BADMSG:
-			cmd->result = (DRIVER_INVALID << 24);
+			cmd->result = 0;
 			/* fall through */
 
 		case BTSTAT_HAHARDWARE:
@@ -601,25 +601,25 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_HASOFTWARE:
 		case BTSTAT_BUSFREE:
 		case BTSTAT_SENSFAILED:
-			cmd->result |= (DID_ERROR << 16);
+			set_host_byte(cmd, DID_ERROR);
 			break;
 
 		case BTSTAT_SENTRST:
 		case BTSTAT_RECVRST:
 		case BTSTAT_BUSRESET:
-			cmd->result = (DID_RESET << 16);
+			set_host_byte(cmd, DID_RESET);
 			break;
 
 		case BTSTAT_ABORTQUEUE:
-			cmd->result = (DID_BUS_BUSY << 16);
+			set_host_byte(cmd, DID_BUS_BUSY);
 			break;
 
 		case BTSTAT_SCSIPARITY:
-			cmd->result = (DID_PARITY << 16);
+			set_host_byte(cmd, DID_PARITY);
 			break;
 
 		default:
-			cmd->result = (DID_ERROR << 16);
+			set_host_byte(cmd, DID_ERROR);
 			scmd_printk(KERN_DEBUG, cmd,
 				    "Unknown completion status: 0x%x\n",
 				    btstat);
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

