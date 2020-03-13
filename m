Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B428CC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 967E7205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCMUbU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:31:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46981 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgCMUbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 16:31:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id w12so4799350pll.13
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 13:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=acXix1dMvHPscClIQWXZ2n3qrNKFs7S2sFNBTdps6+U=;
        b=loHRacRwClDegnvFf7J9gCx3rA9wJwMROlp04onyQah8y79i6jhk66MHhFwpeGo95j
         EppZYkyR8nsDlyzdbGxZbIHaKQMvYtdQ4kN0fnQIqnd1k//0hRX+BgzkYyRYQeMfWjrO
         yA5sg7x27Gd9n27ZJoXoSiD1ZHnB1IQiCONpiFKOfclJQFOQ+kMFG9Ysi45EMqmycsWM
         edV5KBhYZtq2byd+NnRincl7IlF7WyHQjsBcCElIRfRZ9Bq0V+X5dE54G3P5Y/x0AfNw
         corCdDHBCBz0ASkyKdbz59gtQQRc9GgGiDUa5Xr70narUjV1W5tM0Mjp2kS63qr9O0VR
         kctQ==
X-Gm-Message-State: ANhLgQ2BDsuFSCHQ8h1AezuRkLPKZSTNSZ7aoIK7xuCc9DykBAhDQg6J
        vSD0l/+UpPjYkPJpuUfpU5U=
X-Google-Smtp-Source: ADFU+vut7WuT5PL54Z7DdzsON1LW0uQOxA5UxJq2iGBIge1B3pgh0a5Umxf0oP4c+zYr+CkIGUu2hA==
X-Received: by 2002:a17:90b:3745:: with SMTP id ne5mr11427818pjb.156.1584131478876;
        Fri, 13 Mar 2020 13:31:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id m12sm12656000pjf.25.2020.03.13.13.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 13:31:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v3 5/5] scsi/trace: Use get_unaligned_be24()
Date:   Fri, 13 Mar 2020 13:31:02 -0700
Message-Id: <20200313203102.16613-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313203102.16613-1-bvanassche@acm.org>
References: <20200313203102.16613-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This makes the SCSI tracing code slightly easier to read.

Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_trace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index ac35c301c792..41a950075913 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -18,11 +18,9 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	u32 lba = 0, txlen;
+	u32 lba, txlen;
 
-	lba |= ((cdb[1] & 0x1F) << 16);
-	lba |=  (cdb[2] << 8);
-	lba |=   cdb[3];
+	lba = get_unaligned_be24(&cdb[1]) & 0x1fffff;
 	/*
 	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
 	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
