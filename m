Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5A8C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CDB613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhDTCPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:06 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:37629 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDTCPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:04 -0400
Received: by mail-pf1-f170.google.com with SMTP id y62so663265pfg.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HDYlRIC13bmilV/Nq0di6clRroRJ3dRpRLq+wT9d2zs=;
        b=F56ZG9EuPlLOGoRKiHTgGfYN47p4qACYm//14hZghvHzIORm0oDx0Z00J4zGHQjKqo
         6nHrmLmppd/Bo9s3jmL9rnUY6oqDwnFrXRf6F8WL4p7RjwhLYklpGpiWjp5axom+ZdVe
         DiVKMcvbJ82RM4kgLc6UkLVLFkLBRcY8z+P2xMD4EkY/g7ktFOYCR9LJGe/K6LFug0xY
         CH1qkpboGtSYW5aiwNnthlnSgfaf9YxP8P25ec4uzjcW7LPK1fGWVS/rtCfRjbdPAuIo
         BDCOSoBbMWwvNOl+syj3C2lRKE5qi2G7Rb16huDvyefmOOzil0hB7A7WDPWmzGAMkece
         5Uqg==
X-Gm-Message-State: AOAM530O4PwjFgMTcZZLp6rPGdN01HDEcee2XOSGSHwIKFE6kyb52LUl
        u3teO36xv/995+9vwuHMzhE=
X-Google-Smtp-Source: ABdhPJxrwYM0TQbyAL5VIk2GJy8FdgJN5+u1cSQL+MmLgiB4d48pFoY76KiQA9hlF0ZJfaqr+W2trg==
X-Received: by 2002:aa7:95aa:0:b029:256:143:e5d8 with SMTP id a10-20020aa795aa0000b02902560143e5d8mr22167049pfk.67.1618884873886;
        Mon, 19 Apr 2021 19:14:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 111/117] Use the scsi_status union more widely
Date:   Mon, 19 Apr 2021 19:13:56 -0700
Message-Id: <20210420021402.27678-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the type of the SCSI status argument of the following functions
from int into union scsi_status:
* scsi_status_is_good();
* status_byte();
* msg_byte();
* host_byte();
* driver_byte();
* scsi_hostbyte_string();
* scsi_driverbyte_string().

Make all callers of these functions pass a union scsi_result as argument.

Remove the scsi_status_to_int() macro.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/constants.c    |  8 ++++----
 drivers/scsi/scsi_logging.c |  4 ++--
 drivers/scsi/sd.c           |  4 ++--
 include/scsi/scsi.h         | 28 +++++++---------------------
 include/scsi/scsi_dbg.h     | 10 ++++++----
 5 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 84d73f57292b..0ea510b4ca52 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -410,10 +410,10 @@ static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 
-const char *scsi_hostbyte_string(int result)
+const char *scsi_hostbyte_string(union scsi_status result)
 {
 	const char *hb_string = NULL;
-	int hb = host_byte(result);
+	enum host_status hb = host_byte(result);
 
 	if (hb < ARRAY_SIZE(hostbyte_table))
 		hb_string = hostbyte_table[hb];
@@ -421,10 +421,10 @@ const char *scsi_hostbyte_string(int result)
 }
 EXPORT_SYMBOL(scsi_hostbyte_string);
 
-const char *scsi_driverbyte_string(int result)
+const char *scsi_driverbyte_string(union scsi_status result)
 {
 	const char *db_string = NULL;
-	int db = driver_byte(result);
+	enum driver_status db = driver_byte(result);
 
 	if (db < ARRAY_SIZE(driverbyte_table))
 		db_string = driverbyte_table[db];
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 5c994ba1fad8..3cba3ff97559 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -384,8 +384,8 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	char *logbuf;
 	size_t off, logbuf_len;
 	const char *mlret_string = scsi_mlreturn_string(disposition);
-	const char *hb_string = scsi_hostbyte_string(cmd->status.combined);
-	const char *db_string = scsi_driverbyte_string(cmd->status.combined);
+	const char *hb_string = scsi_hostbyte_string(cmd->status);
+	const char *db_string = scsi_driverbyte_string(cmd->status);
 	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8df2f25e4129..756fe99794a7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3812,8 +3812,8 @@ void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
 		     union scsi_status result)
 {
-	const char *hb_string = scsi_hostbyte_string(result.combined);
-	const char *db_string = scsi_driverbyte_string(result.combined);
+	const char *hb_string = scsi_hostbyte_string(result);
+	const char *db_string = scsi_driverbyte_string(result);
 
 	if (hb_string || db_string)
 		sd_printk(KERN_INFO, sdkp,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 18bb1fb2458f..03f047333e52 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -33,20 +33,20 @@ enum scsi_timeouts {
 
 /** scsi_status_is_good - check the status return.
  *
- * @status: the status passed up from the driver (including host and
+ * @scsi_status: the status passed up from the driver (including host and
  *          driver components)
  *
  * This returns true for known good conditions that may be treated as
  * command completed normally
  */
-static inline bool __scsi_status_is_good(int status)
+static inline bool scsi_status_is_good(union scsi_status scsi_status)
 {
 	/*
 	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
 	 * significant in SCSI-3.  For now, we follow the SCSI-2
 	 * behaviour and ignore reserved bits.
 	 */
-	status &= 0xfe;
+	const u8 status = scsi_status.combined & 0xfe;
 	return ((status == SAM_STAT_GOOD) ||
 		(status == SAM_STAT_CONDITION_MET) ||
 		/* Next two "intermediate" statuses are obsolete in SAM-4 */
@@ -56,20 +56,6 @@ static inline bool __scsi_status_is_good(int status)
 		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
-/*
- * If the 'status' argument has type int, unsigned int or union scsi_status,
- * return the combined SCSI status. If the 'status' argument has another type,
- * trigger a compiler error by passing a struct to a context where an integer
- * is expected.
- */
-#define scsi_status_to_int(status)			\
-	__builtin_choose_expr(sizeof(status) == 4,	\
-			      *(int32_t *)&(status),	\
-			      (union scsi_status){})
-
-#define scsi_status_is_good(status)				\
-	__scsi_status_is_good(scsi_status_to_int(status))
-
 
 /*
  * standard mode-select header prepended to all mode-select commands
@@ -148,10 +134,10 @@ enum scsi_disposition {
  *      driver_byte = set by mid-level.
  */
 #define status_byte(result) ((enum sam_status_divided_by_two)	\
-			     ((scsi_status_to_int((result)) >> 1) & 0x7f))
-#define msg_byte(result)    ((scsi_status_to_int((result)) >> 8) & 0xff)
-#define host_byte(result)   ((scsi_status_to_int((result)) >> 16) & 0xff)
-#define driver_byte(result) ((scsi_status_to_int((result)) >> 24) & 0xff)
+			     ((result).b.status >> 1))
+#define msg_byte(result)    ((result).b.msg)
+#define host_byte(result)   ((result).b.host)
+#define driver_byte(result) ((result).b.driver)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 7b196d234626..d3a868b6dd89 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -2,6 +2,8 @@
 #ifndef _SCSI_SCSI_DBG_H
 #define _SCSI_SCSI_DBG_H
 
+#include <scsi/scsi_status.h>
+
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_sense_hdr;
@@ -23,8 +25,8 @@ extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
 extern const char *scsi_mlreturn_string(int);
-extern const char *scsi_hostbyte_string(int);
-extern const char *scsi_driverbyte_string(int);
+extern const char *scsi_hostbyte_string(union scsi_status result);
+extern const char *scsi_driverbyte_string(union scsi_status result);
 #else
 static inline bool
 scsi_opcode_sa_name(int cmd, int sa,
@@ -71,13 +73,13 @@ scsi_mlreturn_string(int result)
 }
 
 static inline const char *
-scsi_hostbyte_string(int result)
+scsi_hostbyte_string(union scsi_status result)
 {
 	return NULL;
 }
 
 static inline const char *
-scsi_driverbyte_string(int result)
+scsi_driverbyte_string(union scsi_status result)
 {
 	return NULL;
 }
