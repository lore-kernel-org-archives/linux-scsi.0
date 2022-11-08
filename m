Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CA4C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiKHXd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiKHXd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:33:59 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EFB20F4E
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:33:58 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id f63so14731022pgc.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:33:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=704PJWnopOqaVGnhssGOT3S0dUQA0qS4/DU7F8KMwtM=;
        b=s2aZV7KjoinR7XoIzMwJ4mA8mhopsiAKVr/CTQJ3qJzIRJvvNRwBMVl29zBC+/Z2jx
         N8hRnksYjCudbzvv+zD2mtsDHPIL4gS3Ij/Kgl4NS54v8LgYYWN2nGNr5vTDMNtFmyCo
         7BVOB5t86atepoFYWebWPen+zWaphJsfMKW9xtz0jmHIvgzbvdTnMBixd8aew/t/LOVt
         nZqLqVfdzyppa0K/VACGNS/2LZtd1mZJeZthYzTk8mCjDCT9T7bkLGaYb8d4htBpoIff
         2Mnvmv7LVksKTFbsj50foG53jv7PWeM4tfKSH9vyP3zSb1GQDr1ovOKe4ozA/QJR0uhe
         9eIA==
X-Gm-Message-State: ACrzQf14o26qiGLQ3R9b0mHPMa0X1Yu/ZP5OSJCHjRNmCu8IwnOiQdPC
        KSTTfZ4NJUZuoRSmLF/j2c4=
X-Google-Smtp-Source: AMsMyM7H3Y3AGpJBBJjZbT0y73czJcvQ9ZYccBAT/LPbavDWmOE076T3hXIc/6PvLuESvO9yvgH8SQ==
X-Received: by 2002:a63:df10:0:b0:43b:e82f:e01c with SMTP id u16-20020a63df10000000b0043be82fe01cmr50164641pgg.19.1667950437510;
        Tue, 08 Nov 2022 15:33:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7982a000000b005618189b0ffsm6918088pfl.104.2022.11.08.15.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:33:56 -0800 (PST)
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
Subject: [PATCH v3 1/5] scsi: ufs: Reduce the clock scaling latency
Date:   Tue,  8 Nov 2022 15:33:35 -0800
Message-Id: <20221108233339.412808-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
In-Reply-To: <20221108233339.412808-1-bvanassche@acm.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
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
