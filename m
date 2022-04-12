Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A86C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358674AbiDLSWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243468AbiDLSW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:22:27 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389CE3DA48
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:09 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso3782010pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+DEqcxCsHRV+0HiSYhlEtxBoyz+hIoKEkJidAugI08=;
        b=rU/56lC/wFBECDu9c4YGk3iidHlybYoRXv2bwfWhJigd+BC65XRw03yrfqbX5MZLWg
         HO4VSS0dZSqw0m2zcg2KIGqqDnmdV2DRXwxquJe+t3AlORlU937c0V3zo9Y232efVGNQ
         uufskuareeztwVV22aeuzQc9hjrDcbRFBTXZw7aTvfsR36ZBEbMhLpD95uh+D5u8Ljxa
         PZrQAPycyI2BciAKsfYmcHrfqLqXzOyspbD20sTmPYp7XpJxqzo8ZcuRX19Rms1J30CY
         oDGAsiibcXF06REkwQI0GzfdPlR4AMLbBEQdwkcNO98UgH96Emwa/iHoLviRaJ5gxndk
         naPg==
X-Gm-Message-State: AOAM531BdALBDKzBM63qltvtAlJ3pQGE7z50RkLfobPP3GK8Y5Vy6pNx
        Kp+UzqzOPb2ii2zZ0VN+wFA=
X-Google-Smtp-Source: ABdhPJx2YmfuhoNEzcaTVFWLFIiQgFiL9osNKuRF3hVuCnWTFAAwL8m5IUv4ZkCOg5dqLvk9Ir3p3w==
X-Received: by 2002:a17:90b:3b50:b0:1c7:5d55:3cb8 with SMTP id ot16-20020a17090b3b5000b001c75d553cb8mr6480314pjb.78.1649787608657;
        Tue, 12 Apr 2022 11:20:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:20:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 07/29] scsi: ufs: Use get_unaligned_be16() instead of be16_to_cpup()
Date:   Tue, 12 Apr 2022 11:18:31 -0700
Message-Id: <20220412181853.3715080-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
