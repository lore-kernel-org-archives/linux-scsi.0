Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16527C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E42DB613BC
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhGIU3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:32 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:37417 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGIU3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:31 -0400
Received: by mail-pl1-f172.google.com with SMTP id a14so5626263pls.4
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wpe7pq4aVg7ucsvY4mN5cBs5bzV8w5kf4tTHNcQD3vs=;
        b=ZCRy8A0GH5fMfmmGEpWVW6mY+x9sR7IZo/wPHkMccZP7jMZyp4z2wHxLnNZlLJTbuz
         uxPzo1nJYLsb2TUoeFXSLtQKI5nHoG0I70NPiJ0ZaBI5ZknZKFTRyZgpXymryA0Sgvys
         LsR5RTj3P4Fldqqm0mOVURSaG11lnsmsvx6ojFTThZK6IDOTrTcWz2NXdj5BR3gI2pZI
         vgnKS2eTSjndUMvg9rqmsULXkl4xrT045I0quIl5FPleINmxqD2WbQYllQocnu94Fa2Y
         vX1iO57AXftwkmT+xlsMpZ3VX5/8HzW5QPHXVwnSuyXPtyWnDYL1J4mLmPGKVYzzsZVN
         DBrw==
X-Gm-Message-State: AOAM530my1/34ZlHuPrkNymRZ9KnpH30xH7gSlAWnbRXkLays6hhbQkm
        HlOKlkIzMwEdmpoj+IPzeNA=
X-Google-Smtp-Source: ABdhPJwKNNaaK1ZeHsXVfDmNOI1u3r0tIjqP+pKJSysyXSSKH3FeJtrNOKHxZVOYejTtp71BGYhYxQ==
X-Received: by 2002:a17:902:bb90:b029:11a:cf7c:997c with SMTP id m16-20020a170902bb90b029011acf7c997cmr32268614pls.80.1625862407544;
        Fri, 09 Jul 2021 13:26:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:26:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] fault-inject: Declare the second argument of setup_fault_attr() const
Date:   Fri,  9 Jul 2021 13:26:18 -0700
Message-Id: <20210709202638.9480-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes it possible to pass a const char * argument to
setup_fault_attr() without having to cast away constness.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/fault-inject.h | 2 +-
 lib/fault-inject.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index e525f6957c49..afc649f0102b 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -42,7 +42,7 @@ struct fault_attr {
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
-int setup_fault_attr(struct fault_attr *attr, char *str);
+int setup_fault_attr(struct fault_attr *attr, const char *str);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index ce12621b4275..45520151b32d 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -15,7 +15,7 @@
  * setup_fault_attr() is a helper function for various __setup handlers, so it
  * returns 0 on error, because that is what __setup handlers do.
  */
-int setup_fault_attr(struct fault_attr *attr, char *str)
+int setup_fault_attr(struct fault_attr *attr, const char *str)
 {
 	unsigned long probability;
 	unsigned long interval;
