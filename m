Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D04CC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0153C613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhDTAJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:29 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:33737 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhDTAJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:24 -0400
Received: by mail-pj1-f42.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso396850pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whJsAS9htkGRzQXBS/tSKYd43Iy7ue3su31g2t7WCcM=;
        b=If06DCUSg3b6VLbwulAPXauRdUdTnWpT4P0H5Tzw1oSuNnmzu+8LhXkTDa3ArbxVoN
         aBvVZHQJSLah9hOnknmPZnstNltRab8SrHTsGrOGqLjlsLEkfAax+x7OV+vbZamDFhZI
         FAD1ZzI/EEvSVTCa5Bl9XLO91hrbwvADEReJZAXqlyo0DIwM0ahpIdNsuNwKYEOqdbNt
         WStFvbzoZyIFmzpCcTNAefS3Thk3ICJPxmrPZLT4/Qju6c8BwA7pTe1mFqx7WVToQVyt
         Qw8CC9llEp91ukWD6/KemE86P0+0PHYy9f4bAjqhiKn/qQMJzluHds64l8k5ep9uXq7U
         uaVw==
X-Gm-Message-State: AOAM530kpO/9SL5249ShPlJoikyCczSVL2Vtz6jUDkhxXdGptX1ZuPIU
        JYvD+v1WH7rgehMEx83pGtU=
X-Google-Smtp-Source: ABdhPJzanq7mSp7HT8BKhhi7jClvvXNc3HMzOQcavPJKVcWDbREt/KUhpdrA2vsISUOZrinDI7cEKw==
X-Received: by 2002:a17:90b:34b:: with SMTP id fh11mr1843337pjb.105.1618877334121;
        Mon, 19 Apr 2021 17:08:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:08:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 002/117] Introduce enums for the SAM, message, host and driver status codes
Date:   Mon, 19 Apr 2021 17:06:50 -0700
Message-Id: <20210420000845.25873-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the compiler to verify whether SAM, message, host and driver status
codes are used correctly. Add the attribute "__packed" to these enum
definitions such that instances of the new enum types only occupy a single
byte.

Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c  |  2 +
 include/scsi/scsi.h        | 84 ++---------------------------------
 include/scsi/scsi_cmnd.h   | 11 +++--
 include/scsi/scsi_proto.h  | 53 ++++++++++++----------
 include/scsi/scsi_status.h | 91 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 133 insertions(+), 108 deletions(-)
 create mode 100644 include/scsi/scsi_status.h

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9afd65eb2c8b..54213c37806b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1775,6 +1775,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		fallthrough;
 	case DID_SOFT_ERROR:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
+	default:
+		break;
 	}
 
 	if (status_byte(scmd->result) != CHECK_CONDITION)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 246ced401683..c9ccb6b45b76 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
+#include <scsi/scsi_status.h>
 
 struct scsi_cmnd;
 
@@ -90,92 +91,14 @@ static inline int scsi_is_wlun(u64 lun)
 
 
 /*
- *  MESSAGE CODES
+ * Extended message codes. See also chapter 16 in SPI-5.
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
@@ -210,7 +133,8 @@ enum scsi_disposition {
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
  */
-#define status_byte(result) (((result) >> 1) & 0x7f)
+#define status_byte(result) ((enum sam_status_divided_by_two)	\
+			     (((result) >> 1) & 0x7f))
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index adb8df40b942..202106e7c814 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -12,6 +12,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_request.h>
+#include <scsi/scsi_status.h>
 
 struct Scsi_Host;
 struct scsi_driver;
@@ -313,22 +314,24 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
 #define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
 	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
 
-static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_status_byte(struct scsi_cmnd *cmd,
+				   enum sam_status status)
 {
 	cmd->result = (cmd->result & 0xffffff00) | status;
 }
 
-static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_msg_byte(struct scsi_cmnd *cmd, enum msg_byte status)
 {
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
-static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_host_byte(struct scsi_cmnd *cmd, enum host_status status)
 {
 	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
 }
 
-static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_driver_byte(struct scsi_cmnd *cmd,
+				   enum driver_status status)
 {
 	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
 }
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c36860111932..e970fecfeaa1 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -11,6 +11,7 @@
 #define _SCSI_PROTO_H_
 
 #include <linux/types.h>
+#include <linux/compiler_attributes.h>
 
 /*
  *      SCSI opcodes
@@ -187,20 +188,22 @@ struct scsi_varlen_cdb_hdr {
 };
 
 /*
- *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
- *  T10/1561-D Revision 4 Draft dated 7th November 2002.
+ *  SCSI Architecture Model (SAM) status codes. Taken from SAM-6 draft
+ *  revision 7 dated 17 February 2021.
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
+	SAM_STAT_INTERMEDIATE			= 0x10, /* obsolete in SAM-4 */
+	SAM_STAT_INTERMEDIATE_CONDITION_MET	= 0x14, /* obsolete in SAM-4 */
+	SAM_STAT_RESERVATION_CONFLICT		= 0x18,
+	SAM_STAT_COMMAND_TERMINATED		= 0x22,	/* obsolete in SAM-3 */
+	SAM_STAT_TASK_SET_FULL			= 0x28,
+	SAM_STAT_ACA_ACTIVE			= 0x30,
+	SAM_STAT_TASK_ABORTED			= 0x40,
+} __packed;
 
 /*
  *  Status codes. These are deprecated as they are shifted 1 bit right
@@ -209,17 +212,19 @@ struct scsi_varlen_cdb_hdr {
  *  above.
  */
 
-#define GOOD                 0x00
-#define CHECK_CONDITION      0x01
-#define CONDITION_GOOD       0x02
-#define BUSY                 0x04
-#define INTERMEDIATE_GOOD    0x08
-#define INTERMEDIATE_C_GOOD  0x0a
-#define RESERVATION_CONFLICT 0x0c
-#define COMMAND_TERMINATED   0x11
-#define QUEUE_FULL           0x14
-#define ACA_ACTIVE           0x18
-#define TASK_ABORTED         0x20
+enum sam_status_divided_by_two {
+	GOOD                 = 0x00,
+	CHECK_CONDITION      = 0x01,
+	CONDITION_GOOD       = 0x02,
+	BUSY                 = 0x04,
+	INTERMEDIATE_GOOD    = 0x08,
+	INTERMEDIATE_C_GOOD  = 0x0a,
+	RESERVATION_CONFLICT = 0x0c,
+	COMMAND_TERMINATED   = 0x11,
+	QUEUE_FULL           = 0x14,
+	ACA_ACTIVE           = 0x18,
+	TASK_ABORTED         = 0x20,
+} __packed;
 
 #define STATUS_MASK          0xfe
 
diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
new file mode 100644
index 000000000000..da2ba825f981
--- /dev/null
+++ b/include/scsi/scsi_status.h
@@ -0,0 +1,91 @@
+#ifndef _SCSI_SCSI_STATUS_H
+#define _SCSI_SCSI_STATUS_H
+
+#include <linux/types.h>
+#include <linux/compiler_attributes.h>
+#include <scsi/scsi_proto.h>
+
+/*
+ * Message codes. See also table 60 "Link control message codes" in SPI-5.
+ * See also table 47 "Link control message codes" in SPI-2.
+ */
+enum msg_byte {
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
+} __packed;
+
+/* Host byte codes. */
+enum host_status {
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
+} __packed;
+
+/* Driver byte codes. */
+enum driver_status {
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
+} __packed;
+
+#endif /* _SCSI_SCSI_STATUS_H */
