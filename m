Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C7CC47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 02:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3211D61185
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 02:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhEXC4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 22:56:47 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:33702 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhEXC4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 22:56:47 -0400
Received: by mail-pf1-f182.google.com with SMTP id f22so11284930pfn.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 19:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8LPe2eACbDGTMCznigKT0jGOTPIupMRIfThcsTE6zjM=;
        b=icj4anksosQoEFdRIIWTT1PoYrNOxLjAkTx6HTCBVMI8iM1GucOLrV6cWzAai9vKMy
         0D/ST6cPEmw/6tRX3g2aH5yI9Hkci+cpGINUq5aUelxa3gx5XwMPH7ZXP3Z9vf6UbH2R
         kGsi2kyXWIwpHb+whJh93THNN7Aqejg7akrBAv6kLjVyF533RXRiQ5fMG+PHhOH7/66t
         Ou2YidzDJbEApWLIotwG1g/+3X8nrHPl5oZnaZ8D0rBsyaBgqLidcNPfz8zaaKEXknOk
         BOu02R7xENLJLA+Wtg4S8pve7qYDkldMJwReQgrkV2Q8ApWdgWmuve2VsBkjzrdj8xDy
         lE3A==
X-Gm-Message-State: AOAM532stowgl2flp8SAJYK+uxiTbj7PhaDHT5XMogr26eOxYLu8rajY
        ImZ3LtNCNNcJDY5a1qd4gS4=
X-Google-Smtp-Source: ABdhPJzvOfwR7GInfnLKFevHFavBPxcxMHMRAs64dNmlG1sVo28oZFaw/hupUcEk9Renb0/xZ5gJ7w==
X-Received: by 2002:a05:6a00:14cb:b029:2be:1466:5a28 with SMTP id w11-20020a056a0014cbb02902be14665a28mr21934464pfu.55.1621824918693;
        Sun, 23 May 2021 19:55:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g8sm13272926pju.6.2021.05.23.19.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 19:55:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 2/3] Introduce enums for the SAM, message, host and driver status codes
Date:   Sun, 23 May 2021 19:54:56 -0700
Message-Id: <20210524025457.11299-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524025457.11299-1-bvanassche@acm.org>
References: <20210524025457.11299-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it possible for the compiler to verify whether SAM, message, host
and driver status codes are used correctly.

Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/constants.c           |  4 +-
 drivers/target/target_core_pscsi.c |  2 +-
 include/scsi/scsi.h                | 81 +--------------------------
 include/scsi/scsi_proto.h          | 24 ++++----
 include/scsi/scsi_status.h         | 89 ++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 93 deletions(-)
 create mode 100644 include/scsi/scsi_status.h

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 84d73f57292b..28ef83868478 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -412,8 +412,8 @@ static const char * const driverbyte_table[]={
 
 const char *scsi_hostbyte_string(int result)
 {
+	enum scsi_host_status hb = host_byte(result);
 	const char *hb_string = NULL;
-	int hb = host_byte(result);
 
 	if (hb < ARRAY_SIZE(hostbyte_table))
 		hb_string = hostbyte_table[hb];
@@ -423,8 +423,8 @@ EXPORT_SYMBOL(scsi_hostbyte_string);
 
 const char *scsi_driverbyte_string(int result)
 {
+	enum scsi_driver_status db = driver_byte(result);
 	const char *db_string = NULL;
-	int db = driver_byte(result);
 
 	if (db < ARRAY_SIZE(driverbyte_table))
 		db_string = driverbyte_table[db];
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f2a11414366d..6e08673dc583 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1044,7 +1044,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 	struct se_cmd *cmd = req->end_io_data;
 	struct pscsi_plugin_task *pt = cmd->priv;
 	int result = scsi_req(req)->result;
-	u8 scsi_status = status_byte(result) << 1;
+	enum sam_status scsi_status = status_byte(result) << 1;
 
 	if (scsi_status != SAM_STAT_GOOD) {
 		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 7f392405991b..268fe1730d6b 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
+#include <scsi/scsi_status.h>
 
 struct scsi_cmnd;
 
@@ -64,92 +65,14 @@ static inline int scsi_is_wlun(u64 lun)
 
 
 /*
- *  MESSAGE CODES
+ * Extended message codes.
  */
-
-#define COMMAND_COMPLETE    0x00
-#define EXTENDED_MESSAGE    0x01
 #define     EXTENDED_MODIFY_DATA_POINTER    0x00
 #define     EXTENDED_SDTR                   0x01
 #define     EXTENDED_EXTENDED_IDENTIFY      0x02    /* SCSI-I only */
 #define     EXTENDED_WDTR                   0x03
 #define     EXTENDED_PPR                    0x04
 #define     EXTENDED_MODIFY_BIDI_DATA_PTR   0x05
-#define SAVE_POINTERS       0x02
-#define RESTORE_POINTERS    0x03
-#define DISCONNECT          0x04
-#define INITIATOR_ERROR     0x05
-#define ABORT_TASK_SET      0x06
-#define MESSAGE_REJECT      0x07
-#define NOP                 0x08
-#define MSG_PARITY_ERROR    0x09
-#define LINKED_CMD_COMPLETE 0x0a
-#define LINKED_FLG_CMD_COMPLETE 0x0b
-#define TARGET_RESET        0x0c
-#define ABORT_TASK          0x0d
-#define CLEAR_TASK_SET      0x0e
-#define INITIATE_RECOVERY   0x0f            /* SCSI-II only */
-#define RELEASE_RECOVERY    0x10            /* SCSI-II only */
-#define TERMINATE_IO_PROC   0x11            /* SCSI-II only */
-#define CLEAR_ACA           0x16
-#define LOGICAL_UNIT_RESET  0x17
-#define SIMPLE_QUEUE_TAG    0x20
-#define HEAD_OF_QUEUE_TAG   0x21
-#define ORDERED_QUEUE_TAG   0x22
-#define IGNORE_WIDE_RESIDUE 0x23
-#define ACA                 0x24
-#define QAS_REQUEST         0x55
-
-/* Old SCSI2 names, don't use in new code */
-#define BUS_DEVICE_RESET    TARGET_RESET
-#define ABORT               ABORT_TASK_SET
-
-/*
- * Host byte codes
- */
-
-#define DID_OK          0x00	/* NO error                                */
-#define DID_NO_CONNECT  0x01	/* Couldn't connect before timeout period  */
-#define DID_BUS_BUSY    0x02	/* BUS stayed busy through time out period */
-#define DID_TIME_OUT    0x03	/* TIMED OUT for other reason              */
-#define DID_BAD_TARGET  0x04	/* BAD target.                             */
-#define DID_ABORT       0x05	/* Told to abort for some other reason     */
-#define DID_PARITY      0x06	/* Parity error                            */
-#define DID_ERROR       0x07	/* Internal error                          */
-#define DID_RESET       0x08	/* Reset by somebody.                      */
-#define DID_BAD_INTR    0x09	/* Got an interrupt we weren't expecting.  */
-#define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer            */
-#define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry  */
-#define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count  */
-#define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
-				 * without decrementing the retry count	   */
-#define DID_TRANSPORT_DISRUPTED 0x0e /* Transport error disrupted execution
-				      * and the driver blocked the port to
-				      * recover the link. Transport class will
-				      * retry or fail IO */
-#define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
-#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
-				 * other paths */
-#define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
-				 * paths might yield different results */
-#define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
-#define DID_MEDIUM_ERROR  0x13  /* Medium error */
-#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
-#define DRIVER_OK       0x00	/* Driver status                           */
-
-/*
- *  These indicate the error that occurred, and what is available.
- */
-
-#define DRIVER_BUSY         0x01
-#define DRIVER_SOFT         0x02
-#define DRIVER_MEDIA        0x03
-#define DRIVER_ERROR        0x04
-
-#define DRIVER_INVALID      0x05
-#define DRIVER_TIMEOUT      0x06
-#define DRIVER_HARD         0x07
-#define DRIVER_SENSE	    0x08
 
 /*
  * Internal return values.
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 5c106c4f249e..84d4a3a14963 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -190,17 +190,19 @@ struct scsi_varlen_cdb_hdr {
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
  */
-#define SAM_STAT_GOOD            0x00
-#define SAM_STAT_CHECK_CONDITION 0x02
-#define SAM_STAT_CONDITION_MET   0x04
-#define SAM_STAT_BUSY            0x08
-#define SAM_STAT_INTERMEDIATE    0x10
-#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
-#define SAM_STAT_RESERVATION_CONFLICT 0x18
-#define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
-#define SAM_STAT_TASK_SET_FULL   0x28
-#define SAM_STAT_ACA_ACTIVE      0x30
-#define SAM_STAT_TASK_ABORTED    0x40
+enum sam_status {
+	SAM_STAT_GOOD				= 0x00,
+	SAM_STAT_CHECK_CONDITION		= 0x02,
+	SAM_STAT_CONDITION_MET			= 0x04,
+	SAM_STAT_BUSY				= 0x08,
+	SAM_STAT_INTERMEDIATE			= 0x10,
+	SAM_STAT_INTERMEDIATE_CONDITION_MET	= 0x14,
+	SAM_STAT_RESERVATION_CONFLICT		= 0x18,
+	SAM_STAT_COMMAND_TERMINATED		= 0x22,	/* obsolete in SAM-3 */
+	SAM_STAT_TASK_SET_FULL			= 0x28,
+	SAM_STAT_ACA_ACTIVE			= 0x30,
+	SAM_STAT_TASK_ABORTED			= 0x40,
+};
 
 /*
  *  Status codes. These are deprecated as they are shifted 1 bit right
diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
new file mode 100644
index 000000000000..66d2d421ad2d
--- /dev/null
+++ b/include/scsi/scsi_status.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _SCSI_SCSI_STATUS_H
+#define _SCSI_SCSI_STATUS_H
+
+#include <linux/types.h>
+#include <scsi/scsi_proto.h>
+
+/* Message codes. */
+enum scsi_msg_byte {
+	COMMAND_COMPLETE	= 0x00,
+	EXTENDED_MESSAGE	= 0x01,
+	SAVE_POINTERS		= 0x02,
+	RESTORE_POINTERS	= 0x03,
+	DISCONNECT		= 0x04,
+	INITIATOR_ERROR		= 0x05,
+	ABORT_TASK_SET		= 0x06,
+	MESSAGE_REJECT		= 0x07,
+	NOP			= 0x08,
+	MSG_PARITY_ERROR	= 0x09,
+	LINKED_CMD_COMPLETE	= 0x0a,
+	LINKED_FLG_CMD_COMPLETE	= 0x0b,
+	TARGET_RESET		= 0x0c,
+	ABORT_TASK		= 0x0d,
+	CLEAR_TASK_SET		= 0x0e,
+	INITIATE_RECOVERY	= 0x0f,            /* SCSI-II only */
+	RELEASE_RECOVERY	= 0x10,            /* SCSI-II only */
+	TERMINATE_IO_PROC	= 0x11,            /* SCSI-II only */
+	CLEAR_ACA		= 0x16,
+	LOGICAL_UNIT_RESET	= 0x17,
+	SIMPLE_QUEUE_TAG	= 0x20,
+	HEAD_OF_QUEUE_TAG	= 0x21,
+	ORDERED_QUEUE_TAG	= 0x22,
+	IGNORE_WIDE_RESIDUE	= 0x23,
+	ACA			= 0x24,
+	QAS_REQUEST		= 0x55,
+
+	/* Old SCSI2 names, don't use in new code */
+	BUS_DEVICE_RESET	= TARGET_RESET,
+	ABORT			= ABORT_TASK_SET,
+};
+
+/* Host byte codes. */
+enum scsi_host_status {
+	DID_OK		= 0x00,	/* NO error                                */
+	DID_NO_CONNECT	= 0x01,	/* Couldn't connect before timeout period  */
+	DID_BUS_BUSY	= 0x02,	/* BUS stayed busy through time out period */
+	DID_TIME_OUT	= 0x03,	/* TIMED OUT for other reason              */
+	DID_BAD_TARGET	= 0x04,	/* BAD target.                             */
+	DID_ABORT	= 0x05,	/* Told to abort for some other reason     */
+	DID_PARITY	= 0x06,	/* Parity error                            */
+	DID_ERROR	= 0x07,	/* Internal error                          */
+	DID_RESET	= 0x08,	/* Reset by somebody.                      */
+	DID_BAD_INTR	= 0x09,	/* Got an interrupt we weren't expecting.  */
+	DID_PASSTHROUGH	= 0x0a,	/* Force command past mid-layer            */
+	DID_SOFT_ERROR	= 0x0b,	/* The low level driver just wish a retry  */
+	DID_IMM_RETRY	= 0x0c,	/* Retry without decrementing retry count  */
+	DID_REQUEUE	= 0x0d,	/* Requeue command (no immediate retry) also
+				 * without decrementing the retry count	   */
+	DID_TRANSPORT_DISRUPTED = 0x0e, /* Transport error disrupted execution
+					 * and the driver blocked the port to
+					 * recover the link. Transport class will
+					 * retry or fail IO */
+	DID_TRANSPORT_FAILFAST = 0x0f, /* Transport class fastfailed the io */
+	DID_TARGET_FAILURE = 0x10, /* Permanent target failure, do not retry on
+				    * other paths */
+	DID_NEXUS_FAILURE = 0x11,  /* Permanent nexus failure, retry on other
+				    * paths might yield different results */
+	DID_ALLOC_FAILURE = 0x12,  /* Space allocation on the device failed */
+	DID_MEDIUM_ERROR = 0x13,  /* Medium error */
+	DID_TRANSPORT_MARGINAL = 0x14, /* Transport marginal errors */
+};
+
+/* Driver byte codes. */
+enum scsi_driver_status {
+	DRIVER_OK	= 0x00,
+
+	DRIVER_BUSY	= 0x01,
+	DRIVER_SOFT	= 0x02,
+	DRIVER_MEDIA	= 0x03,
+	DRIVER_ERROR	= 0x04,
+
+	DRIVER_INVALID	= 0x05,
+	DRIVER_TIMEOUT	= 0x06,
+	DRIVER_HARD	= 0x07,
+	DRIVER_SENSE	= 0x08,
+};
+
+#endif /* _SCSI_SCSI_STATUS_H */
