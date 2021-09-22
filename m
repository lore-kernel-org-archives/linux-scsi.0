Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13421C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E862E60F9D
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhIVQ1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:27:55 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:33431 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQ1y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:27:54 -0400
Received: by mail-pj1-f54.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso4160770pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+v5ujaNJjXmcRXqt0UqZBXyj/iRiPSi6W3kLWeZdqW4=;
        b=m3daWNS4kWagYM/3sHyDdQbKnoZYyc/QU/mIy7Y1SMYwsRSzjwOfbrquEW5D6vqowu
         ZTT/VTGztCqFUDBxRg7Usq5oO4A52hZZknrsVyYSjvy3RjZ4I7dGcDbKsiX6r4PsfgFl
         84cVO4Fi4Nr3IgwjLQZw+J51BqsdeofTDHcR2HuDYU1M+TyLKcw0ETwwBWcSCsRBnJO1
         tcIazt0PPWinwd53BWKbe38615X33CupIhnIHsGGCIszdmemRixgGbIBIVmy6W4OzQwn
         hsOgVojbNsaCWp3r5UVknPZLV1nL+lAc7lYGSiFli5JXHBLzuJuigoQT3bVfIuER6RxQ
         NnOg==
X-Gm-Message-State: AOAM532nDL6rgz7kXGDAgtsOZtNEf/heQGxuolqeAlU2Z2BtWBncmBKZ
        8vT6T+rM2au+6wddBl50CAQ=
X-Google-Smtp-Source: ABdhPJygvtGKs64llk6xK+7c/Sora3cx93DulcFqqZwwh99eIDyPVnr5Er/yQEw4uAOry1M/46AJTQ==
X-Received: by 2002:a17:903:4041:b0:13d:b90e:162e with SMTP id n1-20020a170903404100b0013db90e162emr48581pla.34.1632327984656;
        Wed, 22 Sep 2021 09:26:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id p26sm2311697pfw.137.2021.09.22.09.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:26:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Hannes Reinecke <hare@suse.de>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 82/84] target/tcm_loop: Call scsi_done() directly
Date:   Wed, 22 Sep 2021 09:26:00 -0700
Message-Id: <20210922162603.476745-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210922162603.476745-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210922162603.476745-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 52db28d868d5..4407b56aa6d1 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -71,7 +71,7 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	else
-		sc->scsi_done(sc);
+		scsi_done(sc);
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -165,7 +165,7 @@ static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 	return;
 
 out_done:
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 /*
