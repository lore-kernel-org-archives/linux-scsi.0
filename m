Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E38AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D706207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vpj7nJwM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgGUQm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730803AbgGUQmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF7C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:53 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 22so3481783wmg.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y0yJDqT6Xp8JtjeqnfKAiYDb/27vGgP/5g9qR0UQVcc=;
        b=vpj7nJwMcmyqh1hH5dO2AgjOuj9y6uO8GlHINh7dZQyfXyUKHXtajYv84lf5KlXu8E
         YUqLkcXi7DQt4zYaUzH5uDysC28gKvYB4oKOnAR1T6phHAD+OGZ5ivxN/jxeiKtduU7O
         EDTKN6B67YiCWMAj/CEKHHa9B0Budc621JejRk65Vu9VBT3ZF4X+3sHHl9BR63WmUAEX
         0arouQ5cpcJRcUIDThTpMmYq8RsvAFBAO9WRZIUTesy2HEVcI/Xl66We4IwA8g+8tms6
         cLG0uWP4bFPo7MuSkX+YgsNChi/DFOC03SHrTrJP0MnoRA4GHuJPpAWfdAL+8IDjCQXn
         pCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0yJDqT6Xp8JtjeqnfKAiYDb/27vGgP/5g9qR0UQVcc=;
        b=gGqZVS2oHI/uDFLV+FaxFc0kpdcJVND6R4DfJtdzKe6rQ8zSYP78t8mVxAk3UL5XLZ
         gpDUysW1ubTEXKXzs3v++af2ZZmDLj4XmcHn6zTzE7KaQHJCsRpAiQCnfnc9q3MlQd2r
         OJtHI1/fDwp2W5taTnTEVWwaF0xJxO8B37pREu5b2++/nVmuHjoAr2fov372rSuqTZ6G
         kd9bFyYC48zi2wV34vzOy+ncCIldZa55DMs+WPj+gFI6aIlO2FU7wZF9adIHmIDl68fq
         4PFAYtKSQl2mTML14LF6tD46Vp8K61IUq613i6l21aChaiyy7py0ap2DrR9R52L7aUV+
         zRxg==
X-Gm-Message-State: AOAM5335Sbg+8nQqUbQ4sMRYjBUprPSJg8bTlZ6Ty14//WRexyao0Xf4
        xg/xWUFWcSIa/+yVxbefnO0cQA==
X-Google-Smtp-Source: ABdhPJzJihRx0V2jdHmHDMBHu0RUsVP37nPvGr85wQ/2VNV6HiCXV/odM5/Fzz7Q6hSQth+xz0NGRA==
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr5020503wml.142.1595349771749;
        Tue, 21 Jul 2020 09:42:51 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:51 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jason Yan <yanaijie@huawei.com>, Marvell <kewei@marvell.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 39/40] scsi: mvsas: mv_init: Move 'core_nr' inside #ifdef and remove unused variable 'res_flag'
Date:   Tue, 21 Jul 2020 17:41:47 +0100
Message-Id: <20200721164148.2617584-40-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only declare 'core_nr' if its conditions for use are met.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/mvsas/mv_init.c: In function ‘mvs_interrupt’:
 drivers/scsi/mvsas/mv_init.c:180:6: warning: variable ‘core_nr’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/mvsas/mv_init.c: In function ‘mvs_ioremap’:
 drivers/scsi/mvsas/mv_init.c:302:36: warning: variable ‘res_flag’ set but not used [-Wunused-but-set-variable]

Cc: Jason Yan <yanaijie@huawei.com>
Cc: Marvell <kewei@marvell.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mvsas/mv_init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index b0de3bdb01db0..3b450319cc11e 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -177,15 +177,17 @@ static void mvs_tasklet(unsigned long opaque)
 
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
-	u32 core_nr;
 	u32 stat;
 	struct mvs_info *mvi;
 	struct sas_ha_struct *sha = opaque;
 #ifndef CONFIG_SCSI_MVSAS_TASKLET
 	u32 i;
-#endif
+#else
+	u32 core_nr;
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+#endif
+
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
 	if (unlikely(!mvi))
@@ -299,7 +301,7 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 
 int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 {
-	unsigned long res_start, res_len, res_flag, res_flag_ex = 0;
+	unsigned long res_start, res_len, res_flag_ex = 0;
 	struct pci_dev *pdev = mvi->pdev;
 	if (bar_ex != -1) {
 		/*
@@ -327,7 +329,6 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 		goto err_out;
 	}
 
-	res_flag = pci_resource_flags(pdev, bar);
 	mvi->regs = ioremap(res_start, res_len);
 
 	if (!mvi->regs) {
-- 
2.25.1

