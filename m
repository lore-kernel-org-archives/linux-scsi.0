Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6E6C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 22:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiKVW0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiKVW0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 17:26:37 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6457A376
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:37 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d20so14978858plr.10
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=704PJWnopOqaVGnhssGOT3S0dUQA0qS4/DU7F8KMwtM=;
        b=e5GWyi8DW+mWFPib1LEAUcwHjFM9Xp4MDW8J4W+jrfxUjviUBXrjDuWN5dNrre3fEs
         JYqrePfbilkIpmTllC+wboCCsu9l0v4/9AhqricdgWejXW5CN+/FCADS6U3xFdShCKbM
         A9+tzJBRXdAJEUug6iUJyU2drPIMu0Zb8Vb8AGQ187Iau6KVbatPfvkxvtGF62K8t572
         QhY4k10dTb3485ONA30xwcwLFVQ/TgZFDZCjcb4oAoCX3By8iy+/SnwtChF726seL8en
         dXTRKpIDwxM0W9acxojZrIFR52AZS2BwdPicxz7NgoeFWQ03rNf8wNUhdYIF/y18xB2C
         kTAA==
X-Gm-Message-State: ANoB5pkOU9GcYdS8tgo5BdFJmHF/fADvVaFNLcZYLL0Bu2GeiiiMIHk1
        bbwaybWxd+mwM2mRojn3d4A=
X-Google-Smtp-Source: AA0mqf4M3LyUUnLqK18S/GnkZ8ORHGVy8HYeOlwOMGWpKWt5ZoGBkRJ2yQdRidnn18z66fnyBKpeGA==
X-Received: by 2002:a17:902:9a03:b0:186:9f20:e7e2 with SMTP id v3-20020a1709029a0300b001869f20e7e2mr5973594plp.174.1669155996431;
        Tue, 22 Nov 2022 14:26:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b00172973d3cd9sm12539551plb.55.2022.11.22.14.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:26:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 1/5] scsi: ufs: Reduce the clock scaling latency
Date:   Tue, 22 Nov 2022 14:26:13 -0800
Message-Id: <20221122222617.3449081-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221122222617.3449081-1-bvanassche@acm.org>
References: <20221122222617.3449081-1-bvanassche@acm.org>
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
index 768cb49d269c..81c20e315dba 100644
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
