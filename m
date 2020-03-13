Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3883C2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F8C206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCMChb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 22:37:31 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40929 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCMChb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 22:37:31 -0400
Received: by mail-pl1-f195.google.com with SMTP id h11so3486949plk.7
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 19:37:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JFCp6e0kQJxo5K6JbWCw91PTHC+VB30q7KfTslceTus=;
        b=kxQ6aYmBAbiy7hHd3Hbg+gq41UfUtZKSLV60FNpNO0lKDnKv76J5VdBoUS08PgNRjg
         WI6TITw6RizAlYz0WMJgmTgtf/ekv2FUsYiq3uZqAkD0bIi5gUUgJknExb7uX6YKVqhO
         cgvvKgxsno8d0jNQj2pntw344jxzdk4be8tKJrM3GgxWU5+yas8W7xFdii1ZVZV9aDCF
         5/iUgdhzIIKctIZognh/gKzMZV0J6Y0/RYK27xUGJAJhTUXkPzowgQ0dqpuO5Z1Dn2k1
         gMveJui1qCc/MvQo2IE8fKV6XcRHrJKDneD7khezPlahQIae4uh+lc/gyxceKiUo5Gmi
         CaDQ==
X-Gm-Message-State: ANhLgQ2njBsV7Z9hNTq7saz3XY4gBwvse2OpN5zhwTI7lYnT1XCbCRSz
        cK9T+MHi8lI0AvfZN14wWFg=
X-Google-Smtp-Source: ADFU+vvII81CcDuUB82AxGA+lT2ECeW2aIzqIeNbPV4x0/moR06nTo5kk8Qu+ni2CShlq4hm6HXX2w==
X-Received: by 2002:a17:90a:33d1:: with SMTP id n75mr7187445pjb.167.1584067049883;
        Thu, 12 Mar 2020 19:37:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dc2:675a:7f2a:2f89])
        by smtp.gmail.com with ESMTPSA id o129sm3123516pfb.61.2020.03.12.19.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:37:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Subject: [PATCH v2 2/5] c6x: Include <linux/unaligned/generic.h> instead of duplicating it
Date:   Thu, 12 Mar 2020 19:37:15 -0700
Message-Id: <20200313023718.21830-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313023718.21830-1-bvanassche@acm.org>
References: <20200313023718.21830-1-bvanassche@acm.org>
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

Acked-by: Mark Salter <msalter@redhat.com>
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
