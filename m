Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929FAC636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C6A6124B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhGVCyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:22 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:45922 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhGVCyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:18 -0400
Received: by mail-pl1-f176.google.com with SMTP id p17so2940373plf.12
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:34:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TN2n8c+T3e33HdrQA5XnqFz0KO9k6xt/U2JQlTbLFQs=;
        b=HvBfXZ6AfC4ptY15YeE+0c+sMZX5CHtfJCu40yuRxqjc54FHeIl5dUT4+E+KnEFIza
         a6JRNtD13CKL2dsXgv6OTUp/mNxlx1Cd9CvMrMrLkUllXVLifnbrtQIf3SWgclzKDL8j
         mwHju3tiHJfY++/XCUxIAvFOWSrcwJagH5V2HjbtxPrH12SDl1rUrhLQde9rlLoaq5CF
         BuXWUg8kz8bya5FrVvKuLx9tpiLHYJOTkWuzCZQ75aIXyFvvlckRh43UPUoeCobKwZyk
         EmCmQDlX9fWeVT1bV0vGZBtfN2h7vj7ef33Fe1n1OJcjMHLHFzwdpGBrxfWXfzimd0Uy
         tlIA==
X-Gm-Message-State: AOAM531ZiJltasbt4m1+S16XjUq4zSHRYYe/aXATb1W1uNipRhmUQoC5
        gs7P1ywgNn/bGSx1ovb+8Qs=
X-Google-Smtp-Source: ABdhPJxymP5Z+7iq5jxbpZPC1EmjJuD4z2hrEWlhKpB1VKEtUqryVFt7esdOl7XoNlNF6qb1Xeb8xg==
X-Received: by 2002:a65:690f:: with SMTP id s15mr27732240pgq.21.1626924892727;
        Wed, 21 Jul 2021 20:34:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:34:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 01/18] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
Date:   Wed, 21 Jul 2021 20:34:22 -0700
Message-Id: <20210722033439.26550-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If param_offset > buff_len then the memcpy() statement in
ufshcd_read_desc_param() corrupts memory since it copies
256 + buff_len - param_offset bytes into a buffer with size buff_len.
Since param_offset < 256 this results in writing past the bound of the
output buffer.

Fixes: cbe193f6f093 ("scsi: ufs: Fix potential NULL pointer access during memcpy")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 064a44e628d6..6c251afe65f9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3418,9 +3418,11 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	if (is_kmalloc) {
 		/* Make sure we don't copy more data than available */
-		if (param_offset + param_size > buff_len)
-			param_size = buff_len - param_offset;
-		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
+		if (param_offset >= buff_len)
+			ret = -EINVAL;
+		else
+			memcpy(param_read_buf, &desc_buf[param_offset],
+			       min_t(u32, param_size, buff_len - param_offset));
 	}
 out:
 	if (is_kmalloc)
