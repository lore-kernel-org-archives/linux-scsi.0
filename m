Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5993DC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C0161357
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGIUaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:21 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:41807 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:21 -0400
Received: by mail-pg1-f178.google.com with SMTP id s18so11095549pgg.8
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u7hdX1IGozbVQmxDnRSj4g5f98A7CGIm/ZiAB+3KnEA=;
        b=XOGKOqhbTrs9zhp4fKyn0ff+EAtrMXxGsCdbYTr9uWv/aaMUb+KzGTLN449Rc0E98R
         bsM5gQnCWFNQpllvf7zbugZ5Wva4C8K4gagrFV1Wy44Fcc5g7SLySI3Xcy7fbAp5c5GS
         gUHV+zzGjCUFSisxdIStOpzDqarkrO8FOtZpFKRG+b6fmUQnJHk5VU7KNpLtTd07Yom8
         3VHzj+tU/r/L8G6zko3xqMd+GYpFVsIV2gNn/jExfTOkvRDtuwPx0DXo4+g9i1JNGs0K
         eb8+P9wdP2KvHt6gIIsSADDrToM+VH0D0oQzdMDsfNf/TPHfbK/AZXz/Vu+yLqOsE50k
         BMVw==
X-Gm-Message-State: AOAM53092UDY56mtA93c3OYzeYMBHgKdqrUKFNVypKjp3EcOWRkZCu+d
        kmMvdI2HKTih8Is2BE8Evpo=
X-Google-Smtp-Source: ABdhPJwDDiEn1bybQxLZPtbJjMnn4qCtA+zctCl2sbV9BWadWhRNB9qrr7tmfTuUJ77Z/Y1QQzvw1w==
X-Received: by 2002:a63:d811:: with SMTP id b17mr39853908pgh.286.1625862457358;
        Fri, 09 Jul 2021 13:27:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 12/19] scsi: ufs: Remove a local variable
Date:   Fri,  9 Jul 2021 13:26:31 -0700
Message-Id: <20210709202638.9480-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the local variable 'utrlcnr'. This patch does not change any
functionality.

Cc: Avri Altman <avri.altman@wdc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0cb84a744dad..83a32b71240e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5240,7 +5240,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 {
-	unsigned long completed_reqs = 0;
+	unsigned long completed_reqs;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5254,14 +5254,11 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 		ufshcd_reset_intr_aggr(hba);
 
 	if (use_utrlcnr) {
-		u32 utrlcnr;
-
-		utrlcnr = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_COMPL);
-		if (utrlcnr) {
-			ufshcd_writel(hba, utrlcnr,
+		completed_reqs = ufshcd_readl(hba,
+					      REG_UTP_TRANSFER_REQ_LIST_COMPL);
+		if (completed_reqs)
+			ufshcd_writel(hba, completed_reqs,
 				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
-			completed_reqs = utrlcnr;
-		}
 	} else {
 		unsigned long flags;
 		u32 tr_doorbell;
