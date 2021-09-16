Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FCBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66BC60EE3
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240415AbhIPR5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:57:50 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:44726 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbhIPRzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 13:55:43 -0400
Received: by mail-pj1-f54.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso5335203pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 10:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFOV0RUCon8Pt/zHVqrB7Fkr4w/4rNKga7G+WHj5nts=;
        b=57T30E1eNlzwKXCMnPH2FjMo6qg7oN5o7ksnoHI3uPFWqct/70w6IgG3PLSTEHgZQL
         itQWbIroj1R/6p8D2NJwTwGI9UPwplFpBtP3O6pKbZpH3OK4vScTNw38Min1p/eYH9gT
         G+ESU040DRIg/CN8RC1tQ3heV4jTe9cUoOvEs4iDwcW7B2r1wGP/YoiiyT2EISukUq+M
         RFsVXVD2a+dyuzxnXsDvqAC38VjE4XbCLxJ3nfSzWKBHKNayYyk/yxU98H8F2pO+Zaxj
         zrpL1nrUWq+3lELvGZi1FO4HMSOikHNJAHEdJBNy3y2nh64XYg4DlVnKPXWnnKHBZqnz
         Jyxg==
X-Gm-Message-State: AOAM530QANGgqvkbvxcRxHtK6UTxKDdLfowDNqrAAzXOZgTNPgywVk7c
        R0UORneygcm/A8g4Kgv133A=
X-Google-Smtp-Source: ABdhPJyrfNauS35dxqTgSFaPfeuKal6q0D4V+BARMZF/3s6u5gMeSxYB4i6Gwy6C5YcyHqm+9Mgesg==
X-Received: by 2002:a17:902:dac7:b0:138:cee7:6bbc with SMTP id q7-20020a170902dac700b00138cee76bbcmr5804937plx.0.1631814855244;
        Thu, 16 Sep 2021 10:54:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:72bb:5072:e839:3844])
        by smtp.gmail.com with ESMTPSA id bb17sm3292608pjb.45.2021.09.16.10.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 10:54:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2] scsi: ufs: Unbreak the reset handler
Date:   Thu, 16 Sep 2021 10:54:04 -0700
Message-Id: <20210916175408.2260084-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A command tag is passed as the second argument of the
__ufshcd_transfer_req_compl() call in ufshcd_eh_device_reset_handler()
instead of a bitmask. Fix this by passing a bitmask as argument instead
of a command tag.

Cc: Can Guo <cang@codeaurora.org>
Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Changes compared to v1: fixed patch description.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..d1dc52c76847 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6876,7 +6876,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
+			__ufshcd_transfer_req_compl(hba, 1U << pos, false);
 		}
 	}
 
