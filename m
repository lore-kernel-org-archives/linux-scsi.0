Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BDAC5AD4C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 19:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbjKOTds (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 14:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbjKOTds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 14:33:48 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A111BF
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:33:43 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-28094a3b760so756359a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700076823; x=1700681623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y5JBL3VnGMH5v1LTadywTWrQUTYCieW3jYAVxjEJidk=;
        b=WZt+uXxGAhuJmFmV09N1e0ZFn1T2A5xEhogFcapgCoUz0/ZM1soY+nU4THXRv6hrZl
         wifkETdLR1eEFOUjjnvHY1kQeYopp/M0nKNccygfQ0IjKA+7+G/AZqU6rhVn7Lsz7IiR
         l4kxPT6sd6HzGnQMrFo7zDvw4G+IokeXCzkjshGctgTEEnC6h2+B/gPAT4n36HZmNwyp
         eGKVcHx/EoJNcWxTeIRxeTnXpeb/LsMWrfyu4k2L57/zWQv9JClFJhaxvgM1ABUuijJF
         wXVlvL4NOd2KAzpI8ic7j4XYI9jEnsY/9a/e83SdUGoaCQQaWm3vLbT/dGOQsivSt8RM
         4LUw==
X-Gm-Message-State: AOJu0YzpqdO6IXXXgZ21a1LKzLMegjWErbRDJln4aLqFQXfK64OO7r2x
        s5Dp4qR/A/9F74qgAriARuY=
X-Google-Smtp-Source: AGHT+IEX2s/WL+XKIyZmd89DNuUKKzJMaOc90aX6icQgNktEX2qJyDI4e1lJjQoAKKOQfRshVYD7TQ==
X-Received: by 2002:a17:90b:1d11:b0:27d:5946:5e2c with SMTP id on17-20020a17090b1d1100b0027d59465e2cmr11744213pjb.12.1700076822943;
        Wed, 15 Nov 2023 11:33:42 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:56f1:2160:3a2a:2645])
        by smtp.gmail.com with ESMTPSA id g19-20020a17090a579300b00280215e7aebsm203929pji.15.2023.11.15.11.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 11:33:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: bfa: Use the proper data type for BLIST flags
Date:   Wed, 15 Nov 2023 11:33:38 -0800
Message-ID: <20231115193338.2261972-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/bfa/bfad_bsg.c:2553:50: sparse: sparse: incorrect type in initializer (different base types)

Fixes: 2e5a6c3baccd ("scsi: bfa: Convert bfad_reset_sdev_bflags() from a macro into a function")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311031255.lmSPisIk-lkp@intel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 520f9152f3bf..d4ceca2d435e 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2550,7 +2550,7 @@ bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 static void bfad_reset_sdev_bflags(struct bfad_im_port_s *im_port,
 				   int lunmask_cfg)
 {
-	const u32 scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;
+	const blist_flags_t scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;
 	struct bfad_itnim_s *itnim;
 	struct scsi_device *sdev;
 	unsigned long flags;
