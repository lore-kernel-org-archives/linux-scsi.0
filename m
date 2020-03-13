Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BEAC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68DB205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCMUbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:31:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45726 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 16:31:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id m15so5623963pgv.12
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 13:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iN3qkX6NvKTw6IJ/ZhDggD0rP3c1udu6efCDJQAx7eA=;
        b=djJpSIY8MuqUnZQqWAJWXqweHYiStULD083H4ci18NlvS3Rn+aQNzPqsOl6i71u9sE
         +tUTNjJF9Tmmf/rP4Hyakuibuvv90cWOGu1wie9El+ItCGaKrrOLULxtsljJ4o3nGQSl
         Z/iQkytB1gfi0dTP094Ppq41hHmk4g4DNTwDvgwVHvnIEJ1LUxag2kqj6SSu/TGtjg6X
         2SKi+piiHMVaojUm9JYFbK6flCSK85Gw1CKkrMfWYVb1N3KdnA8Tb6p5ebCqeEMDRsy2
         I3jDzAwJ4+1uCbTLYo76/b1P6MUhgQb8wj2+99OVZd4PIdNY5wtFd0H9xaU4oopCvxwF
         J79g==
X-Gm-Message-State: ANhLgQ2bImlvhprZfKIK6Nei0O+78R3Es0yYRTYuzAdaOIFkMU1hlt13
        BinNHLPar0e/klj+19CPNqI=
X-Google-Smtp-Source: ADFU+vuU1NUWz9rQftHd6nvnnQ8iJjc5IDA+hXZqHJKTPECFPpqvruMFtasYdf5e5sNuA6H5lz0uFw==
X-Received: by 2002:a63:e053:: with SMTP id n19mr15263159pgj.64.1584131472147;
        Fri, 13 Mar 2020 13:31:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id m12sm12656000pjf.25.2020.03.13.13.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 13:31:11 -0700 (PDT)
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
Subject: [PATCH v3 1/5] linux/unaligned/byteshift.h: Remove superfluous casts
Date:   Fri, 13 Mar 2020 13:30:58 -0700
Message-Id: <20200313203102.16613-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313203102.16613-1-bvanassche@acm.org>
References: <20200313203102.16613-1-bvanassche@acm.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
