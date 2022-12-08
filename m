Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA74DC4167B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 23:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiLHXor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHXoT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 18:44:19 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7F160B49
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 15:44:07 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so6284120pje.5
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2022 15:44:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wrtxazSPAT5yr8DbLGN4jpmxy6tfSJFDHl+FTDD3yJE=;
        b=gYmS5LkOoumNazfUHrgnH2y6f7sj8uHVxmO4c8cNBfvIo26yfQtrLkZ+fzrABfU6Bl
         CevK1oiCgxZhtNjgAnNgNiluZjEHiZ5TtN+kFPQCLZvLptSJm2VX5PfqdbcF5U4STn36
         UefQeiwEZkcD1yh3Ao4TRsiQaHjaldFmLkzh8PdkZpR13p3aY8qABy4t62I+NVz3yyT7
         9ipCDw9cLHlsvMxKXznkIbmHIHXMkdr5FulY7rfS6CgwkOOtLGL3PxkHuF70qEIW1Uyg
         DF6Mw6KGAW2CXTnJJNoJo2ktZTOByJOYhTJZ0Ev+q9bmTuMJDYKQcwwPWsTR6MvE4IVg
         QtZQ==
X-Gm-Message-State: ANoB5pmcQo6/SFWlzi6cE03nEGAp2qSG9lRcer+JZgLA3mL3TwLPHUxW
        nKwz/NvZwSs/ROjMyjaLFIY=
X-Google-Smtp-Source: AA0mqf7hhGvYtwep41eIAeVKSOeay9TeTINWeTkkRpzjgHEb2eI1WgqbY4KlAFY8+xIaCA16d2bglg==
X-Received: by 2002:a05:6a21:1644:b0:9d:efbe:a11d with SMTP id no4-20020a056a21164400b0009defbea11dmr4866883pzb.45.1670543047397;
        Thu, 08 Dec 2022 15:44:07 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090a2f8f00b00213d28a6dedsm148553pjd.13.2022.12.08.15.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 15:44:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v5 1/3] scsi: ufs: Reduce the clock scaling latency
Date:   Thu,  8 Dec 2022 15:43:56 -0800
Message-Id: <20221208234358.252031-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
In-Reply-To: <20221208234358.252031-1-bvanassche@acm.org>
References: <20221208234358.252031-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wait at most 20 ms before rechecking the doorbells instead of waiting
for a potentially long time between doorbell checks.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2dbe24977822..b5d9088b7de3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1154,7 +1154,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		}
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		schedule();
+		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
 			timeout = true;
