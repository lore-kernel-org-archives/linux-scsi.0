Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F26FC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F9160234
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhD0Ica (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:49410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235164AbhD0IcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:32:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DC5B8B16C;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/40] scsi: kill message byte
Date:   Tue, 27 Apr 2021 10:30:44 +0200
Message-Id: <20210427083046.31620-39-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove last vestiges of SCSI status message bytes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst |  6 ++---
 drivers/scsi/scsi_lib.c                 |  5 +---
 include/trace/events/scsi.h             | 33 +------------------------
 3 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 2c87eaa36296..8728204e2b76 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -1176,9 +1176,9 @@ Members of interest:
                    of 0 implies a successfully completed command (and all
                    data (if any) has been transferred to or from the SCSI
                    target device). 'result' is a 32 bit unsigned integer that
-                   can be viewed as 4 related bytes. The SCSI status value is
-                   in the LSB. See include/scsi/scsi.h status_byte(),
-                   msg_byte() and host_byte() macros and related constants.
+                   can be viewed as 2 related bytes. The SCSI status value is
+                   in the LSB. See include/scsi/scsi.h status_byte() and
+                   host_byte() macros and related constants.
     sense_buffer
 		 - an array (maximum size: SCSI_SENSE_BUFFERSIZE bytes) that
                    should be written when the SCSI status (LSB of 'result')
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 612decaccfb5..e8617c6bbf7a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -625,10 +625,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 {
 	switch (host_byte(result)) {
 	case DID_OK:
-		/*
-		 * Also check the other bytes than the status byte in result
-		 */
-		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
+		if (scsi_status_is_good(result))
 			return BLK_STS_OK;
 		return BLK_STS_IOERR;
 	case DID_TRANSPORT_FAILFAST:
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 428cca71c2ba..370ade0d4093 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -124,37 +124,6 @@
 		scsi_hostbyte_name(DID_TRANSPORT_DISRUPTED),	\
 		scsi_hostbyte_name(DID_TRANSPORT_FAILFAST))
 
-#define scsi_msgbyte_name(result)	{ result, #result }
-#define show_msgbyte_name(val)					\
-	__print_symbolic(val,					\
-		scsi_msgbyte_name(COMMAND_COMPLETE),		\
-		scsi_msgbyte_name(EXTENDED_MESSAGE),		\
-		scsi_msgbyte_name(SAVE_POINTERS),		\
-		scsi_msgbyte_name(RESTORE_POINTERS),		\
-		scsi_msgbyte_name(DISCONNECT),			\
-		scsi_msgbyte_name(INITIATOR_ERROR),		\
-		scsi_msgbyte_name(ABORT_TASK_SET),		\
-		scsi_msgbyte_name(MESSAGE_REJECT),		\
-		scsi_msgbyte_name(NOP),				\
-		scsi_msgbyte_name(MSG_PARITY_ERROR),		\
-		scsi_msgbyte_name(LINKED_CMD_COMPLETE),		\
-		scsi_msgbyte_name(LINKED_FLG_CMD_COMPLETE),	\
-		scsi_msgbyte_name(TARGET_RESET),		\
-		scsi_msgbyte_name(ABORT_TASK),			\
-		scsi_msgbyte_name(CLEAR_TASK_SET),		\
-		scsi_msgbyte_name(INITIATE_RECOVERY),		\
-		scsi_msgbyte_name(RELEASE_RECOVERY),		\
-		scsi_msgbyte_name(CLEAR_ACA),			\
-		scsi_msgbyte_name(LOGICAL_UNIT_RESET),		\
-		scsi_msgbyte_name(SIMPLE_QUEUE_TAG),		\
-		scsi_msgbyte_name(HEAD_OF_QUEUE_TAG),		\
-		scsi_msgbyte_name(ORDERED_QUEUE_TAG),		\
-		scsi_msgbyte_name(IGNORE_WIDE_RESIDUE),		\
-		scsi_msgbyte_name(ACA),				\
-		scsi_msgbyte_name(QAS_REQUEST),			\
-		scsi_msgbyte_name(BUS_DEVICE_RESET),		\
-		scsi_msgbyte_name(ABORT))
-
 #define scsi_statusbyte_name(result)	{ result, #result }
 #define show_statusbyte_name(val)				\
 	__print_symbolic(val,					\
@@ -316,7 +285,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  "DRIVER_OK",
 		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
-		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
+		  "COMMAND_COMPLETE",
 		  show_statusbyte_name(__entry->result & 0xff))
 );
 
-- 
2.29.2

