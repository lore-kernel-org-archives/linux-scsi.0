Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4F5C2BB86
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 00:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FA1217D8
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 00:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kG0j/5lP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgDKAUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Apr 2020 20:20:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51310 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgDKAUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2020 20:20:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id x4so4083055wmj.1;
        Fri, 10 Apr 2020 17:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VFyLS6TU6TdGoqvb1Y1UQYTyXeqkxGElWzmZo9z0wbQ=;
        b=kG0j/5lPIT0wJJbhcgxc2dAl5Tfl7e6TeAD92/k91AO7exflpxnjlMyFxWfTt22woD
         YTghdxJFHYMRVGc9PL+QAUtRBuKCP179vQl8/xRkvGHH0KQ6w5Qg7bNKEqYaNK/C2fm4
         uD/r6LIS+wPazGLVF5KwYFAfs11SJjhaNNXC6cWEmDklSEwCbILlSgumjlkUmWH76q2J
         Hn45t6Yr8j/nr9tlKcP9zhU+JoQItYx+rJuDiN+LVVqHQIYJvh6qgX6jJsNGIEYxQ0Y5
         a0l4Qs7N2P3PZp5Ur0L57bfzLdmtvNew3pjEx8/tU2b4gni9Ct76HIU2nETqYQ89uL5M
         JsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VFyLS6TU6TdGoqvb1Y1UQYTyXeqkxGElWzmZo9z0wbQ=;
        b=JdEhMEr+FN/ly6cMwpR+GBm7F62hXcthDfmkhq2AQyYtK/WeJi2Hy4F+R5qV/yM/+1
         G9la3nzeQKMlfR9uiB0hcsbx4GmePq9PTZ6dcxMrk7E1b4G/SZ2CMlOJFcOBqI6VKdRY
         NHxgfr2O44k6CQJaIfw+Wytt3Icj8rJPAdmbpYmw0cAOIvaCCmpngY3gkSv7Vuprm5nR
         RquB5spZE0AtPqnuyQTd//LcQSa66G53h3rAA7CBH1lV/9zyKpfyeQQWfWRpHlGH5g9r
         65eXrBzE86sJX5xeBbGOy8+rXSljujc5axRTU+hZ2JTHjE4siBoZEfVzeCiUldJSP/A9
         DoeQ==
X-Gm-Message-State: AGi0Pub6furBzWqkdt2a2d86F+2lIsLQ+Qhv1bbG6fWiwE1wOU5aNPF4
        pSNyQQtijnAUOCOXpIcw+dIFsbPPW2hE
X-Google-Smtp-Source: APiQypJgJDkE0YaOts1yUmpKnMHB1M/0Hl9bmGgzG2H6enzHHMuISK4pa38etdgxOUfRh7X8meJFxg==
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr1804343wmc.49.1586564420198;
        Fri, 10 Apr 2020 17:20:20 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-153.as13285.net. [2.102.14.153])
        by smtp.gmail.com with ESMTPSA id b191sm5091594wmd.39.2020.04.10.17.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 17:20:19 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Allison Randal <allison@lohutok.net>,
        Hannes Reinecke <hare@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
Subject: [PATCH 6/9] scsi: libsas: Add missing annotation for sas_ata_qc_issue()
Date:   Sat, 11 Apr 2020 01:19:30 +0100
Message-Id: <20200411001933.10072-7-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse reports a warning at sas_ata_qc_issue()

warning: context imbalance in sas_ata_qc_issue() - unexpected unlock
The root cause is the missing annotation at sas_ata_qc_issue()

Add the missing __must_hold(ap->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/scsi/libsas/sas_ata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index c5a828a041e0..5d716d388707 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -160,6 +160,7 @@ static void sas_ata_task_done(struct sas_task *task)
 }
 
 static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
+	__must_hold(ap->lock)
 {
 	struct sas_task *task;
 	struct scatterlist *sg;
-- 
2.24.1

