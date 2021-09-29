Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B10C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 595B7611C3
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344944AbhI2WNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:13:37 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:41715 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347072AbhI2WNg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:13:36 -0400
Received: by mail-pf1-f178.google.com with SMTP id k17so3158457pff.8
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+v5ujaNJjXmcRXqt0UqZBXyj/iRiPSi6W3kLWeZdqW4=;
        b=jdurOd3CM7pFJM2OsyM0PNj/+wtD3cIBwCL5wk5MvbIWDxqoEkzZg0fZukVkw3y3b4
         ZYv4ZhLaXZ2xZgp4oF4dvb15ix46M/1TabJzDggmp9Q/BYBiBjFSJp3nm+u8tkisDEmn
         mKkwYxos1akuaj7o4Mb3kowTaqAFdhv/d1glqzdYy3JZHD4IE/03Qn6EIi0DXTfxOt6Y
         yAsZvdn/M8WYSdl6riv1Gz3OH+rgo2UyoItWQBL303wa8CHd22ePlsmhW2hobhEH4DHA
         WlrvLLmC2+fzbkZznC/CXQOUCkhdzKSM+aO54k3X+Jj3r0T4t1VoSTC6rC0oWsN29eS0
         oMFQ==
X-Gm-Message-State: AOAM530tL9OFKc0oEQry9TBNovpOOyjXiAQZY/hd1sQ1K6Y0UMZUn8GC
        Y44Vaq1L85OTLgkz0s7v0Xg=
X-Google-Smtp-Source: ABdhPJzSk5ef71+kMLwUxtx5PccWbgvHBUQi3wbYfkBlVQlSv7RgZPVwRRwbBygJshJxdZL1cKvLkw==
X-Received: by 2002:aa7:93c9:0:b0:43c:f4f5:aac2 with SMTP id y9-20020aa793c9000000b0043cf4f5aac2mr792609pff.11.1632953515017;
        Wed, 29 Sep 2021 15:11:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id 139sm706461pfz.35.2021.09.29.15.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:11:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Christie <michael.christie@oracle.com>,
        Johan Hovold <johan@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH v2 82/84] target/tcm_loop: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:11:33 -0700
Message-Id: <20210929221138.3511208-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
