Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9674C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1EC12255F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502033AbgLNQR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501969AbgLNQQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 11:16:49 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968ECC0617A6;
        Mon, 14 Dec 2020 08:15:36 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id u19so17747975edx.2;
        Mon, 14 Dec 2020 08:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hw0yhMKGv6q99QgqW2Zw+1gOXb/pozJzq3xovcwTbP8=;
        b=tlG1fFw6nBimvfUIcmRa7DjMfCWHL2O12ysxo73b5/0e7gmMCFjbrFtqubVbwwUYQ7
         9hED4bzam992KucpipgPiM4LtwKGS8Ey8Y/88IGz1TWbUr1GnpL78xvZtyuhrgcgBYkB
         orJvcXC3LQxt/8FaL1UvBKgFeaBIgiUqRqriZZyeSPZMh3s1eSNu34oOXx9LVQiWb48y
         QCuqLC4xuClKp0bT3uJIHmDaJAXBLaF11goEI/nofAUn4zrgBS+us+dkD1PfS2rE6xIg
         /6k77k8VUUlIwtX2Jdv0c2vCkFfPwXLpuT7EhW+MjfJzpImnvwr0DcK/uT80f93qBkj9
         rHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hw0yhMKGv6q99QgqW2Zw+1gOXb/pozJzq3xovcwTbP8=;
        b=es35lSVkU58QNqfHw54RvybuhjXa6TxstwnqGjL5youOA6XzydL/m7r+XvqtOgauWM
         KlKq06bGcNwC819LXfsmWkOzKImFUzUG90k/lo0svj5VkgHn3eWsD2QblvRJpZjtuIn+
         P9nGxDfdTRzgofzY+kZmZEJPnTLwb8GxhPny6BjlgauoWLVCR1IL1zuo0gNNSIN1Kg6H
         eyNWxW/sycGBbEv0dvxVawUjYeLq2u2D8yyGWWgu0tr/SDz1gUG3qhEKUhmCq5KiFeIK
         jzlOfe7pauKKwbKVLJR1KEADl3EKqit5ppU09EC/jXKGesfaqNfOea+kWNY9CgDiMg6g
         uYZQ==
X-Gm-Message-State: AOAM532y9G05iBXrvoyjk9lcP47MURFQQxPaj90Samu/Prb+Y2uvmBTt
        84wwelUhikipCnNNAKHroVU=
X-Google-Smtp-Source: ABdhPJwQMvLULywfv83gu4oIa+EgERHpH3P8yTIx4cjQFNNCncDM5fTQDaIYchgCDUpF815BYPVwKg==
X-Received: by 2002:a05:6402:142f:: with SMTP id c15mr25668616edx.33.1607962535335;
        Mon, 14 Dec 2020 08:15:35 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id i13sm6646056edu.22.2020.12.14.08.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:15:34 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM UPIU trace
Date:   Mon, 14 Dec 2020 17:15:01 +0100
Message-Id: <20201214161502.13440-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214161502.13440-1-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Distinguish between TM request UPIU and response UPIU in TM UPIU trace,
for the TM response, let TM UPIU trace print its TM response UPIU.

Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 93d820b69617..742f5d11f8e5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -344,8 +344,12 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
-			&descp->input_param1);
+	if (str_t == UFS_TM_SEND)
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
+				  &descp->input_param1);
+	else
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_header,
+				  &descp->output_param1);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
-- 
2.17.1

