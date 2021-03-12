Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7884BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5689A64FDC
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhCLJso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhCLJsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:13 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257DBC0613D7
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:13 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o26so3398589wmc.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=im+Evr3MfJAtsbpRKrSvBZYIR3R8HYWcJI2GsyeTWRU=;
        b=JkPQfsdV/xUWv0SY461qfK3q2bYhcObyx+c/ou41586IJVFZfrMuJnD+5YnywTsdxD
         Nsi2nsbPlwBLnRKD5NTTWEkR5qafEDQ5YApC+ppPswZSr2Ady84u8j+Aw2IYnsnIM2D7
         pmhbl6A2mRnLP9cheVlyVAGpxoiUgjsBNpOW3kWOFDxrK7WUwX/WTqnsmQEC+jKgnhR2
         EKrb3ejNqnB+CGusyX0ZtvKO4bptFsRmyvFgiag41gveYne/umjayMmADrIb7ip/Ht7c
         3gQlV+xjtHcJntAG2lTLogCBuXfPyg/m+bVoLVwMFTqc1caobdHS9A1xvtx9g8MDKqoM
         pIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=im+Evr3MfJAtsbpRKrSvBZYIR3R8HYWcJI2GsyeTWRU=;
        b=R3iuyYZ0Ke974iKRAROHcipAC7XicpxjgcaokNqBK3EY7dg3m8j8FQUkS4XDKSxLy4
         JvvpBbhcagOUVM2k0T/4TUZb0p1llaVD01UXdDo2YnGtPU4cAQ7MJ1HYV2C9aIdToewB
         uop2HskgzlEijnKRcE28xZm8ua8rYu0E5gh/+Y0HbV2HcC2fC7VKtVxU/pb0caSnrW9O
         p9tRzDuHUDHxa6oKcDNE9I2o64EcEVzm81qNDgw35dy8yKmwsml0QKstphrl3YzZ2vet
         J18aTBkGR2LfrHpkxhx2R0JS25XJByLEGCo6gknx5SgsRtGyLgw2G4hLjgvTnNBf6v3w
         lXIw==
X-Gm-Message-State: AOAM531XwAaj5UQQFnwvjcCczjl0UZWkJhfYKIVmsqnzlxty4F6n4oln
        StJwYNAViFOOI4De9H9jhSnzLw==
X-Google-Smtp-Source: ABdhPJwKraMRGttD3+ezeCjP06uDClb3A9wpDqh0KFnDAjD5VPdHwzk8UFFdiN/EBPN0oaUS/nC5qQ==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr12232516wmh.166.1615542491771;
        Fri, 12 Mar 2021 01:48:11 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Christoph Hellwig <hch@lst.de>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 23/30] scsi: initio: Remove unused variable 'prev'
Date:   Fri, 12 Mar 2021 09:47:31 +0000
Message-Id: <20210312094738.2207817-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/initio.c: In function ‘initio_find_busy_scb’:
 drivers/scsi/initio.c:869:30: warning: variable ‘prev’ set but not used [-Wunused-but-set-variable]

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Brian Macy <bmacy@sunshinecomputing.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/initio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 814acc57069dc..926a7045c2e5c 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -866,17 +866,16 @@ static void initio_unlink_busy_scb(struct initio_host * host, struct scsi_ctrl_b
 
 struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun)
 {
-	struct scsi_ctrl_blk *tmp, *prev;
+	struct scsi_ctrl_blk *tmp;
 	u16 scbp_tarlun;
 
 
-	prev = tmp = host->first_busy;
+	tmp = host->first_busy;
 	while (tmp != NULL) {
 		scbp_tarlun = (tmp->lun << 8) | (tmp->target);
 		if (scbp_tarlun == tarlun) {	/* Unlink this SCB              */
 			break;
 		}
-		prev = tmp;
 		tmp = tmp->next;
 	}
 #if DEBUG_QUEUE
-- 
2.27.0

