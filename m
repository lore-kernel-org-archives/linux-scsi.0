Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC68CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7251E208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbfJ1UHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43616 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731838AbfJ1UHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id 3so7635242pfb.10;
        Mon, 28 Oct 2019 13:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoKV8usW5vpFoZSpVG8vjHvbCZY+ib36Ahb8Zg+4+n4=;
        b=sherXZtGsiNnQeqKaiXtQVs/zhkKKaMgfLmRF7eeLlK89wRXCKa8V6fSt2aESd/bPt
         gR3TGkq0ebSBMmfw/KUasR/xz4SpnmU/mXsXwTUbhi2IpZuF5He7tV3Xr1wNBtNdSuZS
         k0502Tht/nOkrGh9EI662H7ZdP8//aHoG1nIO7O6Ggn637Fe1/4dyvI7L0TxH4t+dCBQ
         Rz1gxyM2UkJYvpAAbwTOputM063VVW4lZXf/572aj8bWozmyLbDxejbM7cpZH4cVMXzr
         U2IHzbGqYl3ZugC1hnbgzE/ZdhZeg0dbjCcjZELZ1CBgcS1ssFNN0OI9MbxzC0ZZu47U
         Bi9Q==
X-Gm-Message-State: APjAAAUsSvOJGynnVY9AbP7/mvzwEFtt/1SPSzpeVGbh9fc+SsgXAuae
        eTk55KVvZlK9p3RE4ooSFp0=
X-Google-Smtp-Source: APXvYqzOTaS1zSkFvfbKOzrkMSJ9jaJxWDxGHh97N7mPKIPSSYNijOyps9dI48qF2742aiRIutwnXQ==
X-Received: by 2002:a63:3104:: with SMTP id x4mr22314986pgx.135.1572293231022;
        Mon, 28 Oct 2019 13:07:11 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Subject: [PATCH 2/9] c6x: Include <linux/unaligned/generic.h> instead of duplicating it
Date:   Mon, 28 Oct 2019 13:06:53 -0700
Message-Id: <20191028200700.213753-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the generic __{get,put}_unaligned_[bl]e() definitions instead of
duplicating these. Since a later patch will add more definitions into
<linux/unaligned/generic.h>, this patch ensures that these definitions
have to be added only once. See also commit a7f626c1948a ("C6X: headers").
See also commit 6510d41954dc ("kernel: Move arches to use common unaligned
access").

Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 arch/c6x/include/asm/unaligned.h | 65 +-------------------------------
 1 file changed, 1 insertion(+), 64 deletions(-)

diff --git a/arch/c6x/include/asm/unaligned.h b/arch/c6x/include/asm/unaligned.h
index b56ba7110f5a..d628cc170564 100644
--- a/arch/c6x/include/asm/unaligned.h
+++ b/arch/c6x/include/asm/unaligned.h
@@ -10,6 +10,7 @@
 #define _ASM_C6X_UNALIGNED_H
 
 #include <linux/swab.h>
+#include <linux/unaligned/generic.h>
 
 /*
  * The C64x+ can do unaligned word and dword accesses in hardware
@@ -100,68 +101,4 @@ static inline void put_unaligned64(u64 val, const void *p)
 
 #endif
 
-/*
- * Cause a link-time error if we try an unaligned access other than
- * 1,2,4 or 8 bytes long
- */
-extern int __bad_unaligned_access_size(void);
-
-#define __get_unaligned_le(ptr) (typeof(*(ptr)))({			\
-	sizeof(*(ptr)) == 1 ? *(ptr) :					\
-	  (sizeof(*(ptr)) == 2 ? get_unaligned_le16((ptr)) :		\
-	     (sizeof(*(ptr)) == 4 ? get_unaligned_le32((ptr)) :		\
-		(sizeof(*(ptr)) == 8 ? get_unaligned_le64((ptr)) :	\
-		   __bad_unaligned_access_size())));			\
-	})
-
-#define __get_unaligned_be(ptr) (__force typeof(*(ptr)))({	\
-	sizeof(*(ptr)) == 1 ? *(ptr) :					\
-	  (sizeof(*(ptr)) == 2 ? get_unaligned_be16((ptr)) :		\
-	     (sizeof(*(ptr)) == 4 ? get_unaligned_be32((ptr)) :		\
-		(sizeof(*(ptr)) == 8 ? get_unaligned_be64((ptr)) :	\
-		   __bad_unaligned_access_size())));			\
-	})
-
-#define __put_unaligned_le(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_le16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_le32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_le64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#define __put_unaligned_be(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_be16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_be32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_be64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
 #endif /* _ASM_C6X_UNALIGNED_H */
-- 
2.24.0.rc0.303.g954a862665-goog

