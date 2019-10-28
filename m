Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7E5CA9EC2
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74B4F208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbfJ1UHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36138 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732323AbfJ1UHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id j22so1646158pgh.3;
        Mon, 28 Oct 2019 13:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utYVDPt8pbKWHU3EARy+Py0gf4nflX/pfjedHEM4HCQ=;
        b=tOa8RoZRqC1UcCvs14tdpelefbIDIRybAr2ZpyvZ8m25ejWvhbVEh7T8fqvwYd6lXk
         g2GgsbWqIzzGXJYUw/MdYV8bg4lv5OZfxhtZf/ZHPCIDoyHnkx7gSkrCsrKJamDuvRZ1
         CGw8NoI7Nd1FlMi15S/0dObpzzHS0QygKsk7Bqt9pY0Pn3W/658l0mV5G7JTK+hWryJK
         Ns7wp4/DMVlhjJJTJWIwWW/z/ABz0toYsJGoDJvuzkdY7knEsGOqlcRk9L2VWaK9WOe2
         MllVyky2mLNjG4IEJfkLdIwgo8Dewm1kfMueRAaKfnrn1NQbhujRPLER/jIcDqoBo6iZ
         3MQQ==
X-Gm-Message-State: APjAAAVkFT8REOro6uSLBP6od6KOFdnnK00f8VQVE6LPmM41t7A4jJq/
        ZbV58CYARRQquzCqsaEcAOc=
X-Google-Smtp-Source: APXvYqzDmF5XMlf4BGtndYka4iTOT+K2ZnnFrxCKvCd2S4EX3AoVvEOC3FeAA86iUE2WNkFBtIiEkQ==
X-Received: by 2002:a17:90a:2ec3:: with SMTP id h3mr1342803pjs.131.1572293237146;
        Mon, 28 Oct 2019 13:07:17 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 6/9] scsi/trace: Use get_unaligned_be*()
Date:   Mon, 28 Oct 2019 13:06:57 -0700
Message-Id: <20191028200700.213753-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes an unintended sign extension on left shifts. From Colin
King: "Shifting a u8 left will cause the value to be promoted to an
integer. If the top bit of the u8 is set then the following conversion to
an u64 will sign extend the value causing the upper 32 bits to be set in
the result."

Fix this by using get_unaligned_be*() instead.

Additionally, fix handling of TRANSFER LENGTH == 0 for READ(6) and
WRITE(6).

Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_trace.c | 128 ++++++++++++--------------------------
 1 file changed, 41 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 0f17e7dac1b0..24c9c504e42c 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -9,7 +9,7 @@
 #include <trace/events/scsi.h>
 
 #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
-#define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
+#define SERVICE_ACTION32(cdb) (get_unaligned_be16(&cdb[8]))
 
 static const char *
 scsi_trace_misc(struct trace_seq *, unsigned char *, int);
@@ -18,15 +18,16 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
+	u32 lba, txlen;
 
-	lba |= ((cdb[1] & 0x1F) << 16);
-	lba |=  (cdb[2] << 8);
-	lba |=   cdb[3];
-	txlen = cdb[4];
+	lba = get_unaligned_be24(&cdb[1]) & 0x1fffff;
+	/*
+	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
+	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
+	 */
+	txlen = cdb[4] ? : 256;
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=%u txlen=%u", lba, txlen);
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -36,17 +37,12 @@ static const char *
 scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
+	u32 lba, txlen;
 
-	lba |= (cdb[2] << 24);
-	lba |= (cdb[3] << 16);
-	lba |= (cdb[4] << 8);
-	lba |=  cdb[5];
-	txlen |= (cdb[7] << 8);
-	txlen |=  cdb[8];
+	lba = get_unaligned_be32(&cdb[2]);
+	txlen = get_unaligned_be16(&cdb[7]);
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	trace_seq_printf(p, "lba=%u txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 
 	if (cdb[0] == WRITE_SAME)
@@ -61,19 +57,12 @@ static const char *
 scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
-
-	lba |= (cdb[2] << 24);
-	lba |= (cdb[3] << 16);
-	lba |= (cdb[4] << 8);
-	lba |=  cdb[5];
-	txlen |= (cdb[6] << 24);
-	txlen |= (cdb[7] << 16);
-	txlen |= (cdb[8] << 8);
-	txlen |=  cdb[9];
-
-	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	u32 lba, txlen;
+
+	lba = get_unaligned_be32(&cdb[2]);
+	txlen = get_unaligned_be32(&cdb[6]);
+
+	trace_seq_printf(p, "lba=%u txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 	trace_seq_putc(p, 0);
 
@@ -84,23 +73,13 @@ static const char *
 scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
-
-	lba |= ((u64)cdb[2] << 56);
-	lba |= ((u64)cdb[3] << 48);
-	lba |= ((u64)cdb[4] << 40);
-	lba |= ((u64)cdb[5] << 32);
-	lba |= (cdb[6] << 24);
-	lba |= (cdb[7] << 16);
-	lba |= (cdb[8] << 8);
-	lba |=  cdb[9];
-	txlen |= (cdb[10] << 24);
-	txlen |= (cdb[11] << 16);
-	txlen |= (cdb[12] << 8);
-	txlen |=  cdb[13];
-
-	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	u64 lba;
+	u32 txlen;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	txlen = get_unaligned_be32(&cdb[10]);
+
+	trace_seq_printf(p, "lba=%llu txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 
 	if (cdb[0] == WRITE_SAME_16)
@@ -115,8 +94,8 @@ static const char *
 scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p), *cmd;
-	sector_t lba = 0, txlen = 0;
-	u32 ei_lbrt = 0;
+	u64 lba;
+	u32 ei_lbrt, txlen;
 
 	switch (SERVICE_ACTION32(cdb)) {
 	case READ_32:
@@ -136,26 +115,12 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 		goto out;
 	}
 
-	lba |= ((u64)cdb[12] << 56);
-	lba |= ((u64)cdb[13] << 48);
-	lba |= ((u64)cdb[14] << 40);
-	lba |= ((u64)cdb[15] << 32);
-	lba |= (cdb[16] << 24);
-	lba |= (cdb[17] << 16);
-	lba |= (cdb[18] << 8);
-	lba |=  cdb[19];
-	ei_lbrt |= (cdb[20] << 24);
-	ei_lbrt |= (cdb[21] << 16);
-	ei_lbrt |= (cdb[22] << 8);
-	ei_lbrt |=  cdb[23];
-	txlen |= (cdb[28] << 24);
-	txlen |= (cdb[29] << 16);
-	txlen |= (cdb[30] << 8);
-	txlen |=  cdb[31];
-
-	trace_seq_printf(p, "%s_32 lba=%llu txlen=%llu protect=%u ei_lbrt=%u",
-			 cmd, (unsigned long long)lba,
-			 (unsigned long long)txlen, cdb[10] >> 5, ei_lbrt);
+	lba = get_unaligned_be64(&cdb[12]);
+	ei_lbrt = get_unaligned_be32(&cdb[20]);
+	txlen = get_unaligned_be32(&cdb[28]);
+
+	trace_seq_printf(p, "%s_32 lba=%llu txlen=%u protect=%u ei_lbrt=%u",
+			 cmd, lba, txlen, cdb[10] >> 5, ei_lbrt);
 
 	if (SERVICE_ACTION32(cdb) == WRITE_SAME_32)
 		trace_seq_printf(p, " unmap=%u", cdb[10] >> 3 & 1);
@@ -170,7 +135,7 @@ static const char *
 scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	unsigned int regions = cdb[7] << 8 | cdb[8];
+	unsigned int regions = get_unaligned_be16(&cdb[7]);
 
 	trace_seq_printf(p, "regions=%u", (regions - 8) / 16);
 	trace_seq_putc(p, 0);
@@ -182,8 +147,8 @@ static const char *
 scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p), *cmd;
-	sector_t lba = 0;
-	u32 alloc_len = 0;
+	u64 lba;
+	u32 alloc_len;
 
 	switch (SERVICE_ACTION16(cdb)) {
 	case SAI_READ_CAPACITY_16:
@@ -197,21 +162,10 @@ scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
 		goto out;
 	}
 
-	lba |= ((u64)cdb[2] << 56);
-	lba |= ((u64)cdb[3] << 48);
-	lba |= ((u64)cdb[4] << 40);
-	lba |= ((u64)cdb[5] << 32);
-	lba |= (cdb[6] << 24);
-	lba |= (cdb[7] << 16);
-	lba |= (cdb[8] << 8);
-	lba |=  cdb[9];
-	alloc_len |= (cdb[10] << 24);
-	alloc_len |= (cdb[11] << 16);
-	alloc_len |= (cdb[12] << 8);
-	alloc_len |=  cdb[13];
-
-	trace_seq_printf(p, "%s lba=%llu alloc_len=%u", cmd,
-			 (unsigned long long)lba, alloc_len);
+	lba = get_unaligned_be64(&cdb[2]);
+	alloc_len = get_unaligned_be32(&cdb[10]);
+
+	trace_seq_printf(p, "%s lba=%llu alloc_len=%u", cmd, lba, alloc_len);
 
 out:
 	trace_seq_putc(p, 0);
-- 
2.24.0.rc0.303.g954a862665-goog

