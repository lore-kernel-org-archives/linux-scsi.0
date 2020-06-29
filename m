Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94FFC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90776206E9
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403977AbgF2Vn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgF2Sht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:37:49 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F69DC0307BF
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 09:10:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d4so8513181pgk.4
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 09:10:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlQWlBCNOVUz5rnKN/A0l9ccTp1Tr+uhfNqQfaAVD3w=;
        b=sa+I3ptICK2ncSZ3O3v5a7/fy1hIESZWgxAqkYg+kmo1XD9J1Owx3yZT58CXFtsUWy
         TX89W3NV/YDY/foqSmbzMOlN5VUiczsz9OlWBLovPx2rJ2NNyeGXnN+8gr3aXE3DzVr5
         /OIaxKO3dAAzV4CwP58RpM0QE0hCYvgUoXB0llC9wO0AXg4UYIZHNkvkuO1UbcndhhPO
         NJn+foz5B5IKC2+jvdkbHsMZw80Yo4/9K3g/N2zniVBLLAdM82n2b85ctUmD81lKjHym
         RGB/IlsTLmoW1ujdJGE29EElsm1rrOi1JLsrb7v2kVSHq3zrPY3RBFmKcaTd3Di3ZG5O
         sy8A==
X-Gm-Message-State: AOAM531U4R18aibFl//haPAwwExnl6SnGVrGXqWPsk7WsgkoE758EIxU
        QBrK8A4kHmYbeYj3qbsFTEU=
X-Google-Smtp-Source: ABdhPJz9aDksWYFvkX5t3mASZH1UeQfv+Qrn8X07syxTLUSuwZarzCkzTAchWvAJeMlBgVqnaEJBNQ==
X-Received: by 2002:a65:4908:: with SMTP id p8mr10823336pgs.214.1593447057702;
        Mon, 29 Jun 2020 09:10:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 199sm238328pgc.79.2020.06.29.09.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:10:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ch: Do not read past the end of vendor_labels[]
Date:   Mon, 29 Jun 2020 09:10:51 -0700
Message-Id: <20200629161051.14943-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following gcc 10 compiler error:

In function 'memcpy',
    inlined from 'ch_ioctl' at drivers/scsi/ch.c:666:4:
./include/linux/string.h:377:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
  377 |    __read_overflow2();
      |    ^~~~~~~~~~~~~~~~~~

Cc: Hannes Reinecke <hare@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ch.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index b81b397366db..b675a01380eb 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -651,19 +651,23 @@ static long ch_ioctl(struct file *file,
 		memset(&vparams,0,sizeof(vparams));
 		if (ch->counts[CHET_V1]) {
 			vparams.cvp_n1  = ch->counts[CHET_V1];
-			memcpy(vparams.cvp_label1,vendor_labels[0],16);
+			strncpy(vparams.cvp_label1, vendor_labels[0],
+				ARRAY_SIZE(vparams.cvp_label1));
 		}
 		if (ch->counts[CHET_V2]) {
 			vparams.cvp_n2  = ch->counts[CHET_V2];
-			memcpy(vparams.cvp_label2,vendor_labels[1],16);
+			strncpy(vparams.cvp_label2, vendor_labels[1],
+				ARRAY_SIZE(vparams.cvp_label2));
 		}
 		if (ch->counts[CHET_V3]) {
 			vparams.cvp_n3  = ch->counts[CHET_V3];
-			memcpy(vparams.cvp_label3,vendor_labels[2],16);
+			strncpy(vparams.cvp_label3, vendor_labels[2],
+				ARRAY_SIZE(vparams.cvp_label3));
 		}
 		if (ch->counts[CHET_V4]) {
 			vparams.cvp_n4  = ch->counts[CHET_V4];
-			memcpy(vparams.cvp_label4,vendor_labels[3],16);
+			strncpy(vparams.cvp_label4, vendor_labels[3],
+				ARRAY_SIZE(vparams.cvp_label4));
 		}
 		if (copy_to_user(argp, &vparams, sizeof(vparams)))
 			return -EFAULT;
