Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588D0C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 11:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA78D2224B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 11:57:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eaBdGU3R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgKPKl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 05:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKPKl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 05:41:27 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E116FC0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2020 02:41:26 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a65so23170915wme.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2020 02:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GNUQO66qrdOdHSIIOO/s1hb0xndxqjBt91UQm30+zSM=;
        b=eaBdGU3RDogVhMoxMVTWKeu5mCzcJ6EkO8wmaLAffBpNuaRTr0/bYPye/tXTGVA/YJ
         L8BSx6nD+tYs5O25wmLBv0Kvz+Vl/I+7vjxPjWQLcrdyT5tq4/rgtJiVBF44h2gi00X9
         kwfkMIx0yLKM5p5bTprZ8xdcgCcjzOE7iSDdXBjWqDrT6m5cx1HWO700kRVq37o4Cj0s
         x/9fIDCU4AGoPFmtWnhuk3ltC4ShrEBqsuXRdxBoUkAw1+4b7YHZRxlLWz7S5CtzY7Cm
         qBuVIGaqu0gVeNl1DpufDrmA/1K3OVAZWaOHsza6XOG6W40xjGwdpIaC8zVHuOa6Ev2Y
         RsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GNUQO66qrdOdHSIIOO/s1hb0xndxqjBt91UQm30+zSM=;
        b=KR/5Af2i4qO7s9W30RSpzWsOIyQfy5/+LFBSupTbyYJfwROt9MLecaf8amVDQvAo7K
         escejvspRohVCw6/063bxFBovFKCtJL7m1MQ88mBejSCshmlyCJAyRu6m2Gc5S1vBcxN
         ePuYGYTFKV9uQh3ejHLF/zz2+YZxmxtZI1B2OP3cmDJ0R1om1wApnbZtD1vYNO2Gt8Sf
         Q2vkQ7CEXnrG6YnEny/tTvcSR+crW/OQfmFRwrT2jXbIvHh/q/PdeknfINTAPdhD+aPl
         HjQgm3ArYyWhh1wb9CF7FGuyT+CcVOq8UkdVLO85wj4nbcdfEY7LSV6LUV3y5eCg3BNw
         8gVA==
X-Gm-Message-State: AOAM532p+DY41Ot6+Iy4R7pohuiUXUB6KJ1wBy2xOzA4DMzrMgWs3DLg
        B0ybu0pm+bzosNKRLlbySaxBvA==
X-Google-Smtp-Source: ABdhPJzBKk5BZ8yxuZV6z8Js1n1trQRG3UwxA+uVCz99sq20IQ7B/qzTBNeeceyyb3JEzQwM02hQdA==
X-Received: by 2002:a1c:2c2:: with SMTP id 185mr14991445wmc.103.1605523285546;
        Mon, 16 Nov 2020 02:41:25 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id o197sm18729720wme.17.2020.11.16.02.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 02:41:24 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/1] scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
Date:   Mon, 16 Nov 2020 10:41:19 +0000
Message-Id: <20201116104119.816527-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hasn't been used since 2009.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_hwi.c: In function ‘mpi_set_phys_g3_with_ssc’:
 drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable ‘value’ set but not used [-Wunused-but-set-variable]

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2054c2b03d928..0a1e09b1cd580 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -416,7 +416,7 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue)
 static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 				     u32 SSCbit)
 {
-	u32 value, offset, i;
+	u32 offset, i;
 	unsigned long flags;
 
 #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
@@ -467,7 +467,7 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 	so that the written value will be 0x8090c016.
 	This will ensure only down-spreading SSC is enabled on the SPC.
 	*************************************************************/
-	value = pm8001_cr32(pm8001_ha, 2, 0xd8);
+	pm8001_cr32(pm8001_ha, 2, 0xd8);
 	pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
 
 	/*set the shifted destination address to 0x0 to avoid error operation */
-- 
2.25.1

