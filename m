Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB79C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358372AbiDSXBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347208AbiDSXBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:16 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9C838BDA
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:33 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so3284077pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+DEqcxCsHRV+0HiSYhlEtxBoyz+hIoKEkJidAugI08=;
        b=cBu0ZQh6Io9iyQnBF9whEm3ZCn/GsHL1FE0jco9vVRvx5x4zG1Y0/b/6H4Q1uGsF2s
         HQi5sWtK7wICWA2MAf2f9ovkmWISNukAnhwOreCbUBjH4eHS6QugutNuKjEejU9/xkFw
         YGO+mKqaT2dlKRuGrD9eddoBAcZspWyA+EctYrwLauNA7t3qog+YCyd1W1OesRv8rzSA
         oQNtxuNjo+vjGj39L+Ldycj7ylc4nzxWdgUoLJNU8xVOUNx1gSM8aiSJhoaAWziLKSsv
         u9lRt0/ohLQgyKjSFsNEuFJiQJiNPIdTWSWwA3uWRDKsDfeK1mqiP0R1ogvqsnoNbrsd
         HGwA==
X-Gm-Message-State: AOAM532CNd2HgYVQJPzGymdAUf2cOSJ8lTul7eFxMlSnwOeoIHXZDVqG
        /JkQfnPk6JLI51WSEaPOnV4=
X-Google-Smtp-Source: ABdhPJyMvw6VKc8+KvLBsLoq4l9QwPgaEpkTRWwNvblzd0i7JbLz0EZBkk9R5+67pHXgehRhC5N2ww==
X-Received: by 2002:a17:902:8a8d:b0:157:ab0:a07 with SMTP id p13-20020a1709028a8d00b001570ab00a07mr17648187plo.77.1650409112568;
        Tue, 19 Apr 2022 15:58:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 07/28] scsi: ufs: Use get_unaligned_be16() instead of be16_to_cpup()
Date:   Tue, 19 Apr 2022 15:57:50 -0700
Message-Id: <20220419225811.4127248-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use get_unaligned_be16(...) instead of the equivalent but harder to read
be16_to_cpup((__be16 *)...).

Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d4ef31e1a409..3ec26c9eb1be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7334,7 +7334,7 @@ static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan, char *buff)
 	u16 unit;
 
 	for (i = start_scan; i >= 0; i--) {
-		data = be16_to_cpup((__be16 *)&buff[2 * i]);
+		data = get_unaligned_be16(&buff[2 * i]);
 		unit = (data & ATTR_ICC_LVL_UNIT_MASK) >>
 						ATTR_ICC_LVL_UNIT_OFFSET;
 		curr_uA = data & ATTR_ICC_LVL_VALUE_MASK;
