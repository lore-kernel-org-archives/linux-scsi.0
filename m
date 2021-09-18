Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CF5C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C2960F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbhIRAID (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:03 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:42584 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243765AbhIRAIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:02 -0400
Received: by mail-pg1-f176.google.com with SMTP id q68so11096367pga.9
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9y+txsS9VujeSeg9jJeByWd57Kl+f4BwuNejPl7mZVM=;
        b=pdxFAkqEIshxiyLGLbDTS9H7KVacX6V5huShPnDmbnKe+x1H6wBwW20G6GUy53bDt9
         SgZU1j+SwI8KREQ/4LnjVdFqMQSMkY+uwUQclkCNRxxqHAfHqqbuYsWfaCRGV86F14GI
         LVlRUv5UiKCvpjhsJTa1wlGxiyp2YTwyMoPpYjql18t+6MN47Dc1SaKs2NUjmBr8HWCa
         /Mt7lPdskZnqkWkEOgKFLDkc0x8yJv1IrGpljmem9WspoI6WUqKI3ARTPRPtgAuAsWup
         57jgzydcRKSslbT/GqZYECxt5vqqmJos+EHwPWSmrYJK/gd4AX6A0FyPHILoGIKye2BS
         kh+A==
X-Gm-Message-State: AOAM530eHD4W7QFGbFooZXXUyQkbNCQSOIJ22hR9YhKcQmbmIqQgwvrI
        aWNtGut242ULaQaDlxXx6nH+W0I+Zbg=
X-Google-Smtp-Source: ABdhPJwDjz4M2kXg3VMZe+MpvVP32kiWElK5sL0Qb0cTqT/RbqfD510mUrwsgfrMLucg7KoZr1uPlw==
X-Received: by 2002:a62:b610:0:b0:3ff:c3ae:439c with SMTP id j16-20020a62b610000000b003ffc3ae439cmr13040732pff.53.1631923599915;
        Fri, 17 Sep 2021 17:06:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 18/84] acornscsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:01 -0700
Message-Id: <20210918000607.450448-19-bvanassche@acm.org>
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
 drivers/scsi/arm/acornscsi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 4a84599ff491..bb6f287113a5 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -856,13 +856,10 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 		}
 	}
 
-	if (!SCpnt->scsi_done)
-	    panic("scsi%d.H: null scsi_done function in acornscsi_done", host->host->host_no);
-
 	clear_bit(SCpnt->device->id * 8 +
 		  (u8)(SCpnt->device->lun & 0x7), host->busyluns);
 
-	SCpnt->scsi_done(SCpnt);
+	scsi_done(SCpnt);
     } else
 	printk("scsi%d: null command in acornscsi_done", host->host->host_no);
 
@@ -2479,7 +2476,6 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
     }
 #endif
 
-    SCpnt->scsi_done = done;
     SCpnt->host_scribble = NULL;
     SCpnt->result = 0;
     SCpnt->tag = 0;
