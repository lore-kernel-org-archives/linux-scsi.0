Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C040CA9EC1
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30E92214B2
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbfJ1UHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46263 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732442AbfJ1UHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:22 -0400
Received: by mail-pl1-f196.google.com with SMTP id q21so6178984plr.13;
        Mon, 28 Oct 2019 13:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xu2MsrFJD4eUUY87eX5Fz+Z25LNa6DOvv39jkp2X8H4=;
        b=mBwcN7PJhZOGf7VCBwtRqLL2lXMzTeQEwbRajQbkAUkBQDYEl8Tn0wj8LQJRFE6j+A
         DbzT/7oKMrDR6+57cqMoGhjwYvbuyp9Wmm7LcqIiOE1/N7aoeidESBHTdbMRZbJlIYLd
         LT+7QOW+HzOEg2s4HnjjxaR4Pr4b7SLqcafGTLa6yCd7Ht9qZ/cy69HEjvtuemDJG/R4
         Yetmyabt6eFNztD7cAGOT49gHE/2hY1kyGtaEGhclRfh8xuVmOpW3/lz5jwMqamuECXy
         aAZNhcdbFAvSYdbLmTgr8hbtNYCklyUuyqytZbPCqKbs8ns01SvoSjhQLMiF+5mM1Ax5
         Emzg==
X-Gm-Message-State: APjAAAXDsjbnM1mRMpMBPf+O9bt0I5LXpaJHLqjn81E+Lh/r+qk0ImfB
        btAqJ4Dg8DRSzNDOsaO6UYE=
X-Google-Smtp-Source: APXvYqxIHZsZXZMeazBK/X4tBg4jFwOvVK/Om3IES/q2EQZzHIDQR/guTFvrwm0mKoYnzsFB+m/u8w==
X-Received: by 2002:a17:902:9a49:: with SMTP id x9mr20916371plv.330.1572293241873;
        Mon, 28 Oct 2019 13:07:21 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Subject: [PATCH 9/9] ASoC/fsl_spdif: Use put_unaligned_be24() instead of open-coding it
Date:   Mon, 28 Oct 2019 13:07:00 -0700
Message-Id: <20191028200700.213753-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes the code easier to read.

Cc: Timur Tabi <timur@kernel.org>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Xiubo Li <Xiubo.Lee@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 sound/soc/fsl/fsl_spdif.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 7858a5499ac5..8e80ae16f566 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -16,6 +16,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
+#include <asm/unaligned.h>
 
 #include <sound/asoundef.h>
 #include <sound/dmaengine_pcm.h>
@@ -173,9 +174,7 @@ static void spdif_irq_uqrx_full(struct fsl_spdif_priv *spdif_priv, char name)
 	}
 
 	regmap_read(regmap, reg, &val);
-	ctrl->subcode[*pos++] = val >> 16;
-	ctrl->subcode[*pos++] = val >> 8;
-	ctrl->subcode[*pos++] = val;
+	put_unaligned_be24(val, &ctrl->subcode[*pos]);
 }
 
 /* U/Q Channel sync found */
-- 
2.24.0.rc0.303.g954a862665-goog

