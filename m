Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB3BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 253E760F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344464AbhIRAJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:06 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:33734 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344983AbhIRAIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:54 -0400
Received: by mail-pg1-f174.google.com with SMTP id u18so11194144pgf.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=txLAJwLYhTryQgGnGEr6eB9vbHzMYtYNm6oiDJR1cFU=;
        b=z5kC51IWQQ1K2whUlQKhqKDHjfsB87nXCvLF/B3S6paVHySSyMdkulQqoFey2g9sbs
         MNDvKaRC+f7p1gbXv6RCJuqso0M3CoOEAx9xtF5DIWVffCJpB0xO16O8/U3qNhWFI41Z
         9qUoI9ZY4l7BnjP1Nk5IbF3iZGp1wcpetxRQbXlbVx30cUSCYlOMk/RIktrl+M2EBqyj
         0yuflmee7AvjSkoPhx4HSa8VcgWvh6ptPmmY9YVjWbHjRf6j1q1u7uiCc+dQWn5FXU9L
         00uae5krPrqYsv961sOZ8o6b9R/GyPWFdODEtABsUQ8cLv4ZOZfMXgJENIqdmmqfKbB6
         Xr9A==
X-Gm-Message-State: AOAM5336ie5o83xAsuQ6WGgy8jjytemW4i9inkIiIzo3Cxks81o/iNA8
        smWlTixR38W5GWqTRLbfKwU=
X-Google-Smtp-Source: ABdhPJyZVAjFnHNgpUE9zbVm+hna4Ompwz2mZogSQFTuVNyehu10utwCsqN09t/Li0fZc8PooCeQIg==
X-Received: by 2002:a62:e70c:0:b0:43e:2de6:b09d with SMTP id s12-20020a62e70c000000b0043e2de6b09dmr13458435pfh.9.1631923651707;
        Fri, 17 Sep 2021 17:07:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 45/84] libsas: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:28 -0700
Message-Id: <20210918000607.450448-46-bvanassche@acm.org>
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
 drivers/scsi/libsas/sas_scsi_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2bf37151623e..d337fdf1b9ca 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -125,7 +125,7 @@ static void sas_scsi_task_done(struct sas_task *task)
 	}
 
 	sas_end_task(sc, task);
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
@@ -198,7 +198,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	else
 		cmd->result = DID_ERROR << 16;
 out_done:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sas_queuecommand);
