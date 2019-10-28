Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2258CA9EC1
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B860621744
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbfJ1UHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41770 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730671AbfJ1UHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id p26so3510159pfq.8;
        Mon, 28 Oct 2019 13:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oOA/uRu5K9VdzGvhcHy12M8llL+HEp7gWLqCP1nZnMA=;
        b=SjWuoScMwX2gN7niIvQ/fNCLbVWTEPEOz7Wr5Fj4D1beav/ascmXknLsJK54Foa2I7
         a4JmIdB/vg/mNCYGseGGheo8MK8UfVAi1nTAw8BbC7yy1z3KgCvRwju2GtTc57/9RbzS
         W0gOQ9aLy4SM3/KsWOW3UvxYvk2XPhAMndEANbVwXyjAd9JQl0JdLKjfAgqxjSrLephB
         83UGTBfFrB9g5o8vzRC0yx8nCixqpH4wY6rpyIEh4nE04RQYrZcrY+RLyneLr1uTq2/4
         qcWAUkvb4lvc4OrPQUjjNBdG9obrKQTwq4Fj6JbLjxLBIWcUwa2ZGqYFy0BinOIoMD4b
         1zqA==
X-Gm-Message-State: APjAAAWJRcp5r4ZYyB49IWbVgVItORhn1A7mXLVKiWqKjrp93clc0p6K
        Og4vqF1vIp+HKxQPNvJ5J4g=
X-Google-Smtp-Source: APXvYqzR7cM3Oy8iNmb2QJQmMCkdK4EBQCOhhozNfYxkHl3svNryldFKMAeadMFKCBhDNNziq2el9w==
X-Received: by 2002:a62:1d8d:: with SMTP id d135mr22746869pfd.172.1572293229424;
        Mon, 28 Oct 2019 13:07:09 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/9] linux/unaligned/byteshift.h: Remove superfluous casts
Date:   Mon, 28 Oct 2019 13:06:52 -0700
Message-Id: <20191028200700.213753-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The C language supports casting a void pointer into a non-void pointer
implicitly. Remove explicit void pointer to non-void pointer casts because
these are superfluous.

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/unaligned/be_byteshift.h | 6 +++---
 include/linux/unaligned/le_byteshift.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/unaligned/be_byteshift.h b/include/linux/unaligned/be_byteshift.h
index 8bdb8fa01bd4..c43ff5918c8a 100644
--- a/include/linux/unaligned/be_byteshift.h
+++ b/include/linux/unaligned/be_byteshift.h
@@ -40,17 +40,17 @@ static inline void __put_unaligned_be64(u64 val, u8 *p)
 
 static inline u16 get_unaligned_be16(const void *p)
 {
-	return __get_unaligned_be16((const u8 *)p);
+	return __get_unaligned_be16(p);
 }
 
 static inline u32 get_unaligned_be32(const void *p)
 {
-	return __get_unaligned_be32((const u8 *)p);
+	return __get_unaligned_be32(p);
 }
 
 static inline u64 get_unaligned_be64(const void *p)
 {
-	return __get_unaligned_be64((const u8 *)p);
+	return __get_unaligned_be64(p);
 }
 
 static inline void put_unaligned_be16(u16 val, void *p)
diff --git a/include/linux/unaligned/le_byteshift.h b/include/linux/unaligned/le_byteshift.h
index 1628b75866f0..2248dcb0df76 100644
--- a/include/linux/unaligned/le_byteshift.h
+++ b/include/linux/unaligned/le_byteshift.h
@@ -40,17 +40,17 @@ static inline void __put_unaligned_le64(u64 val, u8 *p)
 
 static inline u16 get_unaligned_le16(const void *p)
 {
-	return __get_unaligned_le16((const u8 *)p);
+	return __get_unaligned_le16(p);
 }
 
 static inline u32 get_unaligned_le32(const void *p)
 {
-	return __get_unaligned_le32((const u8 *)p);
+	return __get_unaligned_le32(p);
 }
 
 static inline u64 get_unaligned_le64(const void *p)
 {
-	return __get_unaligned_le64((const u8 *)p);
+	return __get_unaligned_le64(p);
 }
 
 static inline void put_unaligned_le16(u16 val, void *p)
-- 
2.24.0.rc0.303.g954a862665-goog

