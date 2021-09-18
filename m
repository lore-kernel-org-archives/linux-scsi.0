Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3BFC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 035DC60F23
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244340AbhIRAIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:06 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:38662 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244661AbhIRAIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:04 -0400
Received: by mail-pg1-f178.google.com with SMTP id w8so11114777pgf.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NC/EWqalxkqTDuCz7rroEbUWr8pdRVm1AKhJg9wwxjU=;
        b=CYc6PxN5fedHUhlS5jYLYVa+7tnJg5iJV7ST4uR2aXlFr2bn1tLKcZtxh51aDtW3kW
         E/nuCN/j+zgRy9eDeM+WCApOxQt+XlSpzLCijX8nDi9Y2Hk/tG2MRlN3Z/y+nhX0wBFD
         g4v39OADY/J4wJvyq7u9QIyqYTCSzDs/W6hsyGJ+tGbZsapKYlqR7aQ6/43lywAJp01i
         dp+aI1TGTBmj7xWGaTd2p9D+bW3Wz5sQyTX32SjHr7X5S/mXlI27uIkG4IX52es9a1UC
         LlnkuvOfd3xOEPBXg6BAXqPfa9JDJz935pVOHRCwU6Z8JoPG0zs2Mo8EnMAFcqepWfsp
         /I5A==
X-Gm-Message-State: AOAM533x42lZvbElIVuW+Xqhbd2bge92wH7ODLXUn8A/AoM2gIXF02v9
        +9rVgMle6GwB99Z+DjZv5I1JABz6GB8=
X-Google-Smtp-Source: ABdhPJw5L3h8qrhLHyl3my/LyI4hmB28YGMAODhUNV08OzQSKXSjpggq9v/okIXRxrtvhI79Ai3plA==
X-Received: by 2002:a65:508a:: with SMTP id r10mr12215216pgp.96.1631923601320;
        Fri, 17 Sep 2021 17:06:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 19/84] advansys: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:02 -0700
Message-Id: <20210918000607.450448-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/advansys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ffb391967573..30d4935f297f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3592,7 +3592,7 @@ static void asc_scsi_done(struct scsi_cmnd *scp)
 {
 	scsi_dma_unmap(scp);
 	ASC_STATS(scp->device->host, done);
-	scp->scsi_done(scp);
+	scsi_done(scp);
 }
 
 static void AscSetBank(PortAddr iop_base, uchar bank)
@@ -8460,7 +8460,6 @@ advansys_queuecommand_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *
 	int asc_res, result = 0;
 
 	ASC_STATS(shost, queuecommand);
-	scp->scsi_done = done;
 
 	asc_res = asc_execute_scsi_cmnd(scp);
 
