Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65A5C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 20:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE978611C2
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 20:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhESUW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 16:22:26 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41761 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhESUWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 16:22:25 -0400
Received: by mail-pg1-f179.google.com with SMTP id t30so10248892pgl.8
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 13:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztPPd3INkbmgPeFhAZR1nkL0dIMDdjV8ZJYXkaKrN7w=;
        b=SKLsx0/6qWjOLsfF+bc4uCDyu+ZIDaZZQcxV8cnsB1RsqVLq8gCAw9R/yUeV/zU2hR
         PpCZkTXN6zNdFB5zXxDXLim3FNu8JFw2T9wuAaW1Hi17ZHyXcs9wbcPfykbDgcbm5NqN
         5Wl1Kqpt6kgwwr0JrnX0Y+v4y0UfxD+wRxrGTyLfucWG9t/3MkzGxYp+rfm2hFGGtG6A
         SNU+rrPyYaB6jCRHZ6JoiSzXzWWIQqzhAEREtYMSJaQv6malMKy2tcRQLdyHvfZmDf3U
         N6rCSA/5unEcEcCR8e2dUJaZZMQ+ZmRZTRQNT46tLkDTs84RVUNhTPT1AOKm9A52mqcV
         Dkeg==
X-Gm-Message-State: AOAM530yjSko0ypPlSl9Qq+n4gLP33oOKbf9KANhzjfL6iSySYz83f+O
        ZQf8DXoom96ZhqZsL7HE2nI=
X-Google-Smtp-Source: ABdhPJyF8h3K5KLPB4HNTotSbO2SdQeKTN/k09o3QFFd3sCJL/KAlDKGEKc8/5G46eqEQKJJmCgdKQ==
X-Received: by 2002:a63:1626:: with SMTP id w38mr905033pgl.420.1621455665497;
        Wed, 19 May 2021 13:21:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:db5a:2bf3:3617:be1c])
        by smtp.gmail.com with ESMTPSA id o4sm220338pfk.15.2021.05.19.13.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 13:21:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/2] ufs: Suppress false positive unhandled interrupt messages
Date:   Wed, 19 May 2021 13:20:57 -0700
Message-Id: <20210519202058.12634-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519202058.12634-1-bvanassche@acm.org>
References: <20210519202058.12634-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From ufshcd_transfer_req_compl():
<quote>Resetting interrupt aggregation counters first and reading the
DOOR_BELL afterward allows us to handle all the completed requests.
In order to prevent other interrupts starvation the DB is read once
after reset. The down side of this solution is the possibility of
false interrupt if device completes another request after resetting
aggregation and before reading the DB.</quote>

This patch prevents that ufshcd_intr() reports a false positive
"Unhandled interrupt" message if the above scenario is triggered.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c541b6953863..d330eae02890 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6454,7 +6454,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	}
 
 	if (enabled_intr_status && retval == IRQ_NONE &&
-				!ufshcd_eh_in_progress(hba)) {
+	    (!(enabled_intr_status & UTP_TRANSFER_REQ_COMPL) ||
+	     hba->outstanding_reqs) && !ufshcd_eh_in_progress(hba)) {
 		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
 					__func__,
 					intr_status,
