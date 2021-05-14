Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A75C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B69613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhENVgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:13 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:36423 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbhENVgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:09 -0400
Received: by mail-pg1-f179.google.com with SMTP id c21so262730pgg.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a3coYQIcBTlo1XaJGE3yro/uqrzUQPfOtJ8NMxeL2f4=;
        b=bo71krpr5lpdGS+rzi/mKViran/TFF+xN4cjmtLELlRrGd21BXrhujCHZLdbk2N/Qy
         p5NddVyD4qFMKrgYms+dZZAdnqGo7qhpzY/pfWVejYXlw3p8oNKwDsnUAHoWylC6aapy
         E3AmU2EmtMNJwvtBVCKxl+R1MIIeVWN4RkZqOOWlDp+2beHdpPinR1OfY3UQBahdY/Mz
         J2tjzRBNoGE53gUiCG/pf/mk5vg6sR+cyiEFaWoO1IbuQWxEgDDA5a1HqIqlMqjMLrwe
         PTz9aGkLzEUgc4cznJ4B1kh3/pRN72rdyRyNxUtEzV8zqImH1HihEWuAD3zGOIFOiNOY
         c7kQ==
X-Gm-Message-State: AOAM532Q5tgf5RbSxGbsBmfushDJ6lg3kyIUk55B1/DCnAfbBwpZ5LDb
        FAQF5NaIM/Gy551Ul+pGujC830GMQUJKSQ==
X-Google-Smtp-Source: ABdhPJyJDGYtnkMIsjyogMpL4UuuL+z2Gs9eyA3W5PbukMdlZCacCP7+F8bhBru6SRwM0f/DdeqKbQ==
X-Received: by 2002:a63:6f4e:: with SMTP id k75mr13960280pgc.434.1621028097030;
        Fri, 14 May 2021 14:34:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 29/50] mvumi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:44 -0700
Message-Id: <20210514213356.5264-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9d5743627604..0bdea0da8d4b 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -702,7 +702,7 @@ static int mvumi_host_reset(struct scsi_cmnd *scmd)
 	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
 
 	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scmd->request->tag, scmd->cmnd[0], scmd->retries);
+			blk_req(scmd)->tag, scmd->cmnd[0], scmd->retries);
 
 	return mhba->instancet->reset_host(mhba);
 }
