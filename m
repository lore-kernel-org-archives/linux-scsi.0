Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326DFC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 04:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F8C610A8
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 04:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhIBENx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 00:13:53 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:38454 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhIBENv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 00:13:51 -0400
Received: by mail-pg1-f170.google.com with SMTP id w8so579819pgf.5
        for <linux-scsi@vger.kernel.org>; Wed, 01 Sep 2021 21:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9W8nDTMKS5gFT9I4bisxgvy1PZnIm19AK7z14cQi5M=;
        b=li14A4aZL3rAg6NDzfOySxvP4yLtIcBRs9SaHpBpDWyxcMlybOroYql/8vKFpHjq29
         SnPGsn3WPfC7B1vQj+8K8YQEClfLpAOycp7eU9QPrDLI7pyw9JkpfK89FlD1PPP6VY4h
         sz+rNcPKt9m8Xko2vmxEGAne+gB5Z8FCq03F5PhZvwz3r/rIuSlfqfOUameyteWKsmsi
         35YXB02FI2y48ineO1wT+YWzpJvZ27e9JUM9xliRB0Xe244e9NHDeYjfY2fHAKrTPYvs
         afvdhwCsUezlrck1PbsNTAWtMaSPExH+fxv5Nsoj6fTDjVMT2e5+tEuLkNXqlCF5pVsB
         5ejA==
X-Gm-Message-State: AOAM530hRijHijCr9TLjNr4vQ2NbpyclrZOLqtyCOj4LVi4mbYZW9fGp
        Vm3UDKdkXWqTnSiw8tj15Pc=
X-Google-Smtp-Source: ABdhPJwjIUSmxTwurNZeV6pE6PVFrb5A370lll4KwxlIGpuPyj6H2bU5Gze2xkcn9vT0jNr2Obkrzg==
X-Received: by 2002:a63:f346:: with SMTP id t6mr1174414pgj.345.1630555973895;
        Wed, 01 Sep 2021 21:12:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:5ce2:256e:6b4e:6b2d])
        by smtp.gmail.com with ESMTPSA id v7sm444099pjg.34.2021.09.01.21.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 21:12:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Eitan Cohen <eitancohen456@gmail.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH sg3_utils] sg_xcopy: Improve the code for building a CSCD descriptor
Date:   Wed,  1 Sep 2021 21:12:47 -0700
Message-Id: <20210902041247.15958-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the maximum length of the designator field in an identification CSCD
descriptor is 20 bytes, accept designators with a length of up to 20 bytes.

Since the upper four bits of byte 4 in a CSCD descriptor are reserved, use
mask 0x0f instead of 0x1f for that byte.

Since the upper two bits of byte 5 in a CSCD descriptor are reserved, use
mask 0x3f for that byte.

Compile-tested only.

Cc: Eitan Cohen <eitancohen456@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/sg_xcopy.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/src/sg_xcopy.c b/src/sg_xcopy.c
index e691a73ef4c9..dff565a2eab8 100644
--- a/src/sg_xcopy.c
+++ b/src/sg_xcopy.c
@@ -1075,27 +1075,27 @@ desc_from_vpd_id(int sg_fd, uint8_t *desc, int desc_len,
         if (verbose > 2)
             pr2serr("    Desc %d: assoc %u desig %u len %d\n", off, assoc,
                     desig, i_len);
-        /* Descriptor must be less than 16 bytes */
-        if (i_len > 16)
+        /* Designator length must be <= 20. */
+        if (i_len > 20)
             continue;
-        if (desig == 3) {
+        if (desig == /*NAA=*/3) {
             best = bp;
             best_len = i_len;
             break;
         }
-        if (desig == 2) {
+        if (desig == /*EUI64=*/2) {
             if (!best || f_desig < 2) {
                 best = bp;
                 best_len = i_len;
                 f_desig = 2;
             }
-        } else if (desig == 1) {
+        } else if (desig == /*T10*/1) {
             if (!best || f_desig == 0) {
                 best = bp;
                 best_len = i_len;
                 f_desig = desig;
             }
-        } else if (desig == 0) {
+        } else if (desig == /*vend.spec.=*/0) {
             if (!best) {
                 best = bp;
                 best_len = i_len;
@@ -1108,9 +1108,10 @@ desc_from_vpd_id(int sg_fd, uint8_t *desc, int desc_len,
             decode_designation_descriptor(best, best_len);
         if (best_len + 4 < desc_len) {
             memset(desc, 0, 32);
-            desc[0] = 0xe4;
+            desc[0] = 0xe4; /* Identification Descriptor */
             memcpy(desc + 4, best, best_len + 4);
-            desc[4] &= 0x1f;
+            desc[4] &= 0x0f; /* code set */
+	    desc[5] &= 0x3f; /* association and designator type */
             if (pad)
                 desc[28] = 0x4;
             sg_put_unaligned_be24((uint32_t)block_size, desc + 29);
