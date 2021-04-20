Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D281C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A609613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhDTAJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:40 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:33747 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhDTAJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:35 -0400
Received: by mail-pj1-f44.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso397057pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79+a0zx2d10lGrNZLu+wNPOn483f4ZCAusJAz9pOTtA=;
        b=Ik28RayT+qkKrqdA8ckgFqeCjiaalXxx8Rw0Gg7HuqvuUcVfm5lwcKy01jDrMri3jU
         ZE/i5L+GDLaGbsiO4S5ji8PPCu8oWVdoeQTZKYcb8yOt9T4m/723ndamG1lHBW1RRjGw
         a+HLZ1duhJOGflIlgcIH6odEBgGNJetm/U6bCOxlldTxJZEdO/Pf3JSx8a3taWQgYtYO
         4jIbs25o0nwKuW6GRWFbgJrv1kE+YPVkWEnyuAWN9sd+skuREayRXwO9ARjO8ACH+YTD
         PDavdTdWRHz4buDtYcGP9POhRJF8pYrcGTNxDjZhvl4NgaFA8EBrQDz5Lpafh51PYGLI
         V6hQ==
X-Gm-Message-State: AOAM5303cUUk+pDXHmY+/y5/Fa94pR7fUkqqyHxFfS8Al/5Flf+l/dWX
        cW477FvByyBbpXrzfxxkauo=
X-Google-Smtp-Source: ABdhPJxX03UBivf3aV/cQwU4iB/W/NcI0D8+iovDYBzR0Mj6fpWthWlBXoM57M/pt2bfedL7Vbi+KA==
X-Received: by 2002:a17:90a:150e:: with SMTP id l14mr1824946pja.208.1618877344898;
        Mon, 19 Apr 2021 17:09:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Can Guo <cang@codeaurora.org>,
        James Smart <james.smart@broadcom.com>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH 011/117] Introduce the scsi_status union
Date:   Mon, 19 Apr 2021 17:06:59 -0700
Message-Id: <20210420000845.25873-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the scsi_status union, a data structure that will be used in the
next patches to replace SCSI status codes represented as an integer. Define
that data structure as follows:

	union scsi_status {
		int32_t combined;
		struct {
	#if defined(__BIG_ENDIAN)
			enum driver_status driver;
			enum host_status host;
			enum msg_byte msg;
			enum sam_status status;
	#elif defined(__LITTLE_ENDIAN)
			enum sam_status status;
			enum msg_byte msg;
			enum host_status host;
			enum driver_status driver;
	#else
	#error Endianness?
	#endif
		} b;
	};

The 'combined' member makes it easy to convert existing SCSI code. The
'status', 'msg', 'host' and 'driver' enable access of individual SCSI
status fields in a type-safe fashion.

Change 'int result;' into the following to enable converting one driver at
a time:

	union {
		int result;
		union scsi_status status;
	};

A later patch will remove the outer union and 'int result;'.

Also to enable converting one driver at a time, make scsi_status_is_good(),
status_byte(), msg_byte(), host_byte() and driver_byte() accept an int or
union scsi_status as argument. A later patch will make this function and
these macros accept the scsi_status union only.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: James Smart <james.smart@broadcom.com>
Cc: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c              |  9 +++++++++
 include/linux/bsg-lib.h          |  6 +++++-
 include/scsi/scsi.h              | 24 +++++++++++++++++++-----
 include/scsi/scsi_bsg_iscsi.h    |  6 +++++-
 include/scsi/scsi_cmnd.h         | 14 +++++++++-----
 include/scsi/scsi_eh.h           |  7 ++++++-
 include/scsi/scsi_request.h      |  6 +++++-
 include/scsi/scsi_status.h       | 29 +++++++++++++++++++++++++++++
 include/uapi/scsi/scsi_bsg_fc.h  | 10 ++++++++++
 include/uapi/scsi/scsi_bsg_ufs.h | 11 +++++++++++
 10 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e9e2f0e15ac8..4f71f2005be4 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -763,10 +763,19 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
+#define TEST_STATUS ((union scsi_status){.combined = 0x01020308})
+
 static int __init init_scsi(void)
 {
 	int error;
 
+	BUILD_BUG_ON(sizeof(union scsi_status) != 4);
+	BUILD_BUG_ON(TEST_STATUS.combined != 0x01020308);
+	BUILD_BUG_ON(driver_byte(TEST_STATUS) != 1);
+	BUILD_BUG_ON(host_byte(TEST_STATUS) != 2);
+	BUILD_BUG_ON(msg_byte(TEST_STATUS) != 3);
+	BUILD_BUG_ON(status_byte(TEST_STATUS) != 4);
+
 	error = scsi_init_procfs();
 	if (error)
 		goto cleanup_queue;
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 960988d42f77..f934afc45760 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -11,6 +11,7 @@
 
 #include <linux/blkdev.h>
 #include <scsi/scsi_request.h>
+#include <scsi/scsi_status.h>
 
 struct request;
 struct device;
@@ -52,7 +53,10 @@ struct bsg_job {
 	struct bsg_buffer request_payload;
 	struct bsg_buffer reply_payload;
 
-	int result;
+	union {
+		int		  result; /* do not use in new code */
+		union scsi_status status;
+	};
 	unsigned int reply_payload_rcv_len;
 
 	/* BIDI support */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index c9ccb6b45b76..18bb1fb2458f 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -39,7 +39,7 @@ enum scsi_timeouts {
  * This returns true for known good conditions that may be treated as
  * command completed normally
  */
-static inline int scsi_status_is_good(int status)
+static inline bool __scsi_status_is_good(int status)
 {
 	/*
 	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
@@ -56,6 +56,20 @@ static inline int scsi_status_is_good(int status)
 		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
+/*
+ * If the 'status' argument has type int, unsigned int or union scsi_status,
+ * return the combined SCSI status. If the 'status' argument has another type,
+ * trigger a compiler error by passing a struct to a context where an integer
+ * is expected.
+ */
+#define scsi_status_to_int(status)			\
+	__builtin_choose_expr(sizeof(status) == 4,	\
+			      *(int32_t *)&(status),	\
+			      (union scsi_status){})
+
+#define scsi_status_is_good(status)				\
+	__scsi_status_is_good(scsi_status_to_int(status))
+
 
 /*
  * standard mode-select header prepended to all mode-select commands
@@ -134,10 +148,10 @@ enum scsi_disposition {
  *      driver_byte = set by mid-level.
  */
 #define status_byte(result) ((enum sam_status_divided_by_two)	\
-			     (((result) >> 1) & 0x7f))
-#define msg_byte(result)    (((result) >> 8) & 0xff)
-#define host_byte(result)   (((result) >> 16) & 0xff)
-#define driver_byte(result) (((result) >> 24) & 0xff)
+			     ((scsi_status_to_int((result)) >> 1) & 0x7f))
+#define msg_byte(result)    ((scsi_status_to_int((result)) >> 8) & 0xff)
+#define host_byte(result)   ((scsi_status_to_int((result)) >> 16) & 0xff)
+#define driver_byte(result) ((scsi_status_to_int((result)) >> 24) & 0xff)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index 6b8128005af8..d18e7e061927 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -13,6 +13,7 @@
  */
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_status.h>
 
 /*
  * iSCSI Transport SGIO v4 BSG Message Support
@@ -82,7 +83,10 @@ struct iscsi_bsg_reply {
 	 * msg and status fields. The per-msgcode reply structure
 	 * will contain valid data.
 	 */
-	uint32_t result;
+	union {
+		uint32_t	  result; /* do not use in new code */
+		union scsi_status status;
+	};
 
 	/* If there was reply_payload, how much was recevied ? */
 	uint32_t reply_payload_rcv_len;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 202106e7c814..539be97b0a7d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -140,7 +140,11 @@ struct scsi_cmnd {
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
 
-	int result;		/* Status code from lower level driver */
+	/* Status code from lower level driver */
+	union {
+		int		  result; /* do not use in new code. */
+		union scsi_status status;
+	};
 	int flags;		/* Command flags */
 	unsigned long state;	/* Command completion state */
 
@@ -317,23 +321,23 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
 static inline void set_status_byte(struct scsi_cmnd *cmd,
 				   enum sam_status status)
 {
-	cmd->result = (cmd->result & 0xffffff00) | status;
+	cmd->status.b.status = status;
 }
 
 static inline void set_msg_byte(struct scsi_cmnd *cmd, enum msg_byte status)
 {
-	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
+	cmd->status.b.msg = status;
 }
 
 static inline void set_host_byte(struct scsi_cmnd *cmd, enum host_status status)
 {
-	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
+	cmd->status.b.host = status;
 }
 
 static inline void set_driver_byte(struct scsi_cmnd *cmd,
 				   enum driver_status status)
 {
-	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
+	cmd->status.b.driver = status;
 }
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 468094254b3c..dcd66bb9a1ba 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -6,6 +6,8 @@
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_status.h>
+
 struct scsi_device;
 struct Scsi_Host;
 
@@ -31,7 +33,10 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
 struct scsi_eh_save {
 	/* saved state */
-	int result;
+	union {
+		int		  result; /* do not use in new code */
+		union scsi_status status;
+	};
 	unsigned int resid_len;
 	int eh_eflags;
 	enum dma_data_direction data_direction;
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index b06f28c74908..83f5549cc74c 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -3,6 +3,7 @@
 #define _SCSI_SCSI_REQUEST_H
 
 #include <linux/blk-mq.h>
+#include <scsi/scsi_status.h>
 
 #define BLK_MAX_CDB	16
 
@@ -10,7 +11,10 @@ struct scsi_request {
 	unsigned char	__cmd[BLK_MAX_CDB];
 	unsigned char	*cmd;
 	unsigned short	cmd_len;
-	int		result;
+	union {
+		int		  result; /* do not use in new code */
+		union scsi_status status;
+	};
 	unsigned int	sense_len;
 	unsigned int	resid_len;	/* residual count */
 	int		retries;
diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
index da2ba825f981..120f5a43d2ed 100644
--- a/include/scsi/scsi_status.h
+++ b/include/scsi/scsi_status.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler_attributes.h>
+#include <asm/byteorder.h>
 #include <scsi/scsi_proto.h>
 
 /*
@@ -88,4 +89,32 @@ enum driver_status {
 	DRIVER_SENSE	= 0x08,
 } __packed;
 
+/**
+ * SCSI status passed by LLDs to the midlayer.
+ * @combined: One of the following:
+ *	- A (driver, host, msg, status) quadruplet encoded as a 32-bit integer.
+ *	- A negative Unix error code.
+ *	- In the IDE code, a positive value that represents an error code, an
+ *	  error counter or a bitfield.
+ * @b: SCSI status code.
+ */
+union scsi_status {
+	int32_t combined;
+	struct {
+#if defined(__BIG_ENDIAN)
+		enum driver_status driver;
+		enum host_status host;
+		enum msg_byte msg;
+		enum sam_status status;
+#elif defined(__LITTLE_ENDIAN)
+		enum sam_status status;
+		enum msg_byte msg;
+		enum host_status host;
+		enum driver_status driver;
+#else
+#error Endianness?
+#endif
+	} b;
+};
+
 #endif /* _SCSI_SCSI_STATUS_H */
diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
index 3ae65e93235c..419db719fe8e 100644
--- a/include/uapi/scsi/scsi_bsg_fc.h
+++ b/include/uapi/scsi/scsi_bsg_fc.h
@@ -9,6 +9,9 @@
 #define SCSI_BSG_FC_H
 
 #include <linux/types.h>
+#ifdef __KERNEL__
+#include <scsi/scsi_status.h>
+#endif
 
 /*
  * This file intended to be included by both kernel and user space
@@ -291,7 +294,14 @@ struct fc_bsg_reply {
 	 *    msg and status fields. The per-msgcode reply structure
 	 *    will contain valid data.
 	 */
+#ifdef __KERNEL__
+	union {
+		__u32		  result; /* do not use in new kernel code */
+		union scsi_status status;
+	};
+#else
 	__u32 result;
+#endif
 
 	/* If there was reply_payload, how much was recevied ? */
 	__u32 reply_payload_rcv_len;
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index d55f2176dfd4..3dfe5a5a0842 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -9,6 +9,10 @@
 #define SCSI_BSG_UFS_H
 
 #include <linux/types.h>
+#ifdef __KERNEL__
+#include <scsi/scsi_status.h>
+#endif
+
 /*
  * This file intended to be included by both kernel and user space
  */
@@ -95,7 +99,14 @@ struct ufs_bsg_reply {
 	 * msg and status fields. The per-msgcode reply structure
 	 * will contain valid data.
 	 */
+#ifdef __KERNEL__
+	union {
+		__u32		  result; /* do not use in new kernel code */
+		union scsi_status status;
+	};
+#else
 	__u32 result;
+#endif
 
 	/* If there was reply_payload, how much was received? */
 	__u32 reply_payload_rcv_len;
