Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200DEC1975A
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 036E1206F7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgCMCh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 22:37:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36254 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCMCh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 22:37:29 -0400
Received: by mail-pf1-f194.google.com with SMTP id i13so4288316pfe.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 19:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IBQKvkaGfO86Bh6U7W3UvRuoWwjSpJY4eiulxf2d5Lk=;
        b=nB2SUi2/8A1bf8eo7J3H1GQsFwwROzw4iUnUXw8+XVW5y9Qm3E9wGJHj4G2gGwWofv
         2NKdM84fwNVJ9hNShCjSatj6JULS1AQzya7uHL3vvX5bGuVNvkNuqj62jzubmFSJg1J0
         /h3qkyDFxEgGw6+sCZK57Jtw+42GU7F16Z0BOaESQ+gVfTsSy6ROAVh9YMGNnYim3bml
         Tsh0LpD5yml2Rpdv2IrT/n0vwrP54S2v0t69xOgB5cORZfFv25fcWJYPFqwsl/iq3zqc
         gamfMEkgkOIH+EVKzn+9nZBtAVHdBHvly0PfIb59EVhORTr/Zz/YmEm0fhr+w3dr6Pae
         ZalA==
X-Gm-Message-State: ANhLgQ0XIDSxji6S+sgLDWB7hpumQv7mZjOfqKg2w0hGv4OV2kN5hA3b
        v/IjgbmC/CS+iK3f5CBcKk6Qyl/g7WM=
X-Google-Smtp-Source: ADFU+vv1fIS/p9KyO7iqIKdCfxHm76lI459I5NctNllVojCZxnn0mFUBovDczzs82t3cOX9nnOn1ZA==
X-Received: by 2002:a62:15cc:: with SMTP id 195mr9607527pfv.276.1584067048425;
        Thu, 12 Mar 2020 19:37:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dc2:675a:7f2a:2f89])
        by smtp.gmail.com with ESMTPSA id o129sm3123516pfb.61.2020.03.12.19.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:37:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/5] linux/unaligned/byteshift.h: Remove superfluous casts
Date:   Thu, 12 Mar 2020 19:37:14 -0700
Message-Id: <20200313023718.21830-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313023718.21830-1-bvanassche@acm.org>
References: <20200313023718.21830-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The C language supports implicitly casting a void pointer into a non-void
pointer. Remove explicit void pointer to non-void pointer casts because
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
