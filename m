Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DC0C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 17:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6618164EB7
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 17:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhB1RCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 12:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhB1RCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 12:02:06 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB2C061788;
        Sun, 28 Feb 2021 09:01:26 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gt32so12244426ejc.6;
        Sun, 28 Feb 2021 09:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BMOPT37fnakvBunZ8XC0WYfWKMh6h5+h+w227EOuVKw=;
        b=RKrTvJXrHoWinwWtdLcnR9FACjdw9kBEuiB4sD4CeOQoBIsTsAMxV7RS1v6m5DUfJW
         XhqYzJYs5jmt4EnKh7IONO3xDn9lydYuPbt9XpGhIBlh+JsKoBgKKYpaMk5h8onKVPPP
         +sG7OI7XY/w9UIFSzoKIj8LigmMmeGT/uT/SsqwSP+pp8q4IoyWFwCjudGMrWeTrILOs
         S016kSdAg7Z2UIG/YYXh10c07ZG216VMsHR9KELG+a1Afe5HbD6AEjrt04OA7cNI5Btr
         ig3NXuhFNzObI+G6EZ8mPWMaIZtQkhj+uyIABkdB3VqauyWJ0IXBtsH/4zHROcZ+932W
         n9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BMOPT37fnakvBunZ8XC0WYfWKMh6h5+h+w227EOuVKw=;
        b=SyqGebcJqoaKcIe1PuYK0dZGoQPBqmljgJ8i+f+VOXOnrCRPXSdFNupo1tOpW5/D1N
         Ltwv/ZMldMBwOynqn+o12UNOZt5e7xCHr8+SFqeSy/IWgcZQ65zEfXPVUYwEHeiGQDdX
         CgqKOWGDWAz66PXaqB3foxxhjbLHqSP3Saas12cA3ckGWBt8YjylVCCimWepg2aGEr6M
         L0krWEq+NyZEyLrbyDjIfTjPmrT0siwSOrFnbAJnz5UnGYdU/zOfldhRz7MaogSJxwgM
         PG2ESGLJ+EW30qGOaKagFlSvHHbcOhMRdaLz+SL1h2mKXeTyC0gWUV3i9AQsQOrwh2zh
         JE0w==
X-Gm-Message-State: AOAM530ytBpEPAkO+RNlINosBTbDf8E6/SBkiok5C2zjy1GNrv3mlZMw
        RQJBv/YTVoY8I2STHEyaGnc36Lb74A==
X-Google-Smtp-Source: ABdhPJy1s864frZyG5KmBIaTKOXdbLOArJate9zFizZlre2IOoKe93aDfgqfshYhFtVqx7PvqT4Khg==
X-Received: by 2002:a17:907:e8c:: with SMTP id ho12mr12185817ejc.435.1614531684893;
        Sun, 28 Feb 2021 09:01:24 -0800 (PST)
Received: from localhost.localdomain ([46.53.249.223])
        by smtp.gmail.com with ESMTPSA id pk5sm10464220ejb.119.2021.02.28.09.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 09:01:24 -0800 (PST)
Date:   Sun, 28 Feb 2021 20:01:22 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH 05/11] pragma once: convert drivers/scsi/qla2xxx/qla_target.h
Message-ID: <YDvMYoYcHN5wVDpo@localhost.localdomain>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From 1f58b4923ca9bfb8b1e73554d3793ee98ab58a77 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 9 Feb 2021 17:14:25 +0300
Subject: [PATCH 05/11] pragma once: convert drivers/scsi/qla2xxx/qla_target.h

This file has broken include guard which is not obvious just by looking
at the code. Convert it manually. I think I got #endif right.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/qla2xxx/qla_target.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 10e5e6c8087d..923910dd1809 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -15,10 +15,7 @@
  * This is the global def file that is useful for including from the
  * target portion.
  */
-
-#ifndef __QLA_TARGET_H
-#define __QLA_TARGET_H
-
+#pragma once
 #include "qla_def.h"
 #include "qla_dsd.h"
 
@@ -116,7 +113,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -244,6 +240,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
@@ -1082,5 +1079,3 @@ extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
 void qlt_send_resp_ctio(struct qla_qpair *, struct qla_tgt_cmd *, uint8_t,
     uint8_t, uint8_t, uint8_t);
-
-#endif /* __QLA_TARGET_H */
-- 
2.29.2

