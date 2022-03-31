Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658C8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242515AbiCaWhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240705AbiCaWhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:37:22 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0190E1D12E7
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:32 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id gb19so774749pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4A+TBim3Fz0aqjHOD1CVEaEGAn/QMddHwt4X2PVjwKU=;
        b=NtKlo+m4VEk1+ZbDPe6J5pJQfkQI2k0Vx8TwAN6xLBXQzskzlCWy4rIJ88dwpqVF9N
         Gd1jY0CJcrgEPMYUXS0pTjPQKFAcMasPsODqe0GFd8KbVRxYc6+A3JDKa1a9gCvXppa0
         IN0p5koxlPWJFscIy2OoSFN0Hz3vM7m1zBUKgPcU6Rq/F2bE8jiW+exWjYFofrj7Iq2e
         E3cPGvkD0vqI8kyNhMG3qs9nekniiFjFfJIUe+8I6xZn/xvY+v60neLHdReFRwx7za29
         5joXFOtz70L27gvdMfPrPsRF0dfKkNtID5YTggwavfxjW1OGCTnTm/nsj+LrUz93BfKn
         Qfww==
X-Gm-Message-State: AOAM532vgK+zf9upD0nDjsuRL4U+X1zQ7eydJk0YLmYEa5J8LPUs8Gr6
        hFvspwDwaJXRarjDBfCvNiNhArBaZr4=
X-Google-Smtp-Source: ABdhPJzGnigXIKgOvEJ8R/Iv6ckhBjtBiD180dGXN/2LZ/clZX86EuBRxUvQBh82KQ+dXodMGMoC9g==
X-Received: by 2002:a17:902:d4cf:b0:154:2416:218e with SMTP id o15-20020a170902d4cf00b001542416218emr7438173plg.60.1648766132381;
        Thu, 31 Mar 2022 15:35:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 06/29] scsi: ufs: Use get_unaligned_be16() instead of be16_to_cpup()
Date:   Thu, 31 Mar 2022 15:34:01 -0700
Message-Id: <20220331223424.1054715-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use get_unaligned_be16(...) instead of the equivalent but harder to read
be16_to_cpup((__be16 *)...).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eddaa57b6aad..016734e987bf 100644
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
