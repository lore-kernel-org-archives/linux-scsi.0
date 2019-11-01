Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFADCA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 21:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEFEF21855
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 21:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKAVO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 17:14:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45708 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAVO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 17:14:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id z4so1826918pfn.12
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 14:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QYHjQvpHKMheIdEbTNCNlAIPweNoH8DGIbiIS45OVdE=;
        b=D11zO+KMpRpBbmLn4ELSCorv5F9QjtIlcJyNxwyEWNH3MWMHn28gQdUBWzEaJ+ihnR
         j+r5jAmjAn4X3KDxyygHi6XskO2BxVWj+xrvZpcamXaRlxUOo7bb+N3jaZ943KOuV8vO
         F7psBi0Gv6SiFiINtebyYuSyGhdrDquWQAC2K2KvoqvnIl0jbth9vaDH30yuOwdaoi0U
         mX+SYeKz8fNEJ8s5XeHlk4mFnv/uUFurA9Qp4+y/4LCkuvX0TyYoefw4OktQZc3cowXH
         4hsOuJKVHcd6aRDlNanToUxmY3NebUCpDM2QaA6VcAhwyPzjo7Qn6TPM257YgaUu91OM
         PCig==
X-Gm-Message-State: APjAAAXkxNyGRqGCQ/gbFp4pPiwwJVPJXoIhLPsGYvBFQv14fb9caNUo
        oxkAKrZ42ZYsfI7UwZR+UAA=
X-Google-Smtp-Source: APXvYqzdVjbBGucZQ+uuLeQv21xCFBXEVHuWUZGO7C8jdx5BqrWmUltJhl/tS+SZ6Fu5ZEAoMMNdOw==
X-Received: by 2002:a63:955a:: with SMTP id t26mr11406342pgn.280.1572642894774;
        Fri, 01 Nov 2019 14:14:54 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s18sm10430113pfc.120.2019.11.01.14.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 14:14:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH] scsi/trace: Use get_unaligned_be*()
Date:   Fri,  1 Nov 2019 14:14:47 -0700
Message-Id: <20191101211447.187151-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_trace.c | 109 +++++++++++---------------------------
 1 file changed, 31 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 0f17e7dac1b0..784ed9a32a0d 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -9,7 +9,7 @@
 #include <trace/events/scsi.h>
 
 #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
-#define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
+#define SERVICE_ACTION32(cdb) (get_unaligned_be16(&cdb[8]))
 
 static const char *
 scsi_trace_misc(struct trace_seq *, unsigned char *, int);
@@ -36,17 +36,12 @@ static const char *
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
@@ -61,19 +56,12 @@ static const char *
 scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
+	u32 lba, txlen;
+
+	lba = get_unaligned_be32(&cdb[2]);
+	txlen = get_unaligned_be32(&cdb[6]);
 
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
+	trace_seq_printf(p, "lba=%u txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 	trace_seq_putc(p, 0);
 
@@ -84,23 +72,13 @@ static const char *
 scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
+	u64 lba;
+	u32 txlen;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	txlen = get_unaligned_be32(&cdb[10]);
 
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
+	trace_seq_printf(p, "lba=%llu txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 
 	if (cdb[0] == WRITE_SAME_16)
@@ -115,8 +93,8 @@ static const char *
 scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p), *cmd;
-	sector_t lba = 0, txlen = 0;
-	u32 ei_lbrt = 0;
+	u64 lba;
+	u32 ei_lbrt, txlen;
 
 	switch (SERVICE_ACTION32(cdb)) {
 	case READ_32:
@@ -136,26 +114,12 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
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
@@ -170,7 +134,7 @@ static const char *
 scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	unsigned int regions = cdb[7] << 8 | cdb[8];
+	unsigned int regions = get_unaligned_be16(&cdb[7]);
 
 	trace_seq_printf(p, "regions=%u", (regions - 8) / 16);
 	trace_seq_putc(p, 0);
@@ -182,8 +146,8 @@ static const char *
 scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p), *cmd;
-	sector_t lba = 0;
-	u32 alloc_len = 0;
+	u64 lba;
+	u32 alloc_len;
 
 	switch (SERVICE_ACTION16(cdb)) {
 	case SAI_READ_CAPACITY_16:
@@ -197,21 +161,10 @@ scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
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
2.24.0.rc1.363.gb1bccd3e3d-goog

