Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3D9C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 10:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6660C222E8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 10:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kg+HZKga"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgKBK0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 05:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgKBK0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 05:26:00 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCC8C0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 02:26:00 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 205so1197500wma.4
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 02:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueUgeIECYj+r+SrAYxUIGegHG7aG2+pUTnoP0l5Uui0=;
        b=kg+HZKgasnP2CQ9wyoqXWK99NoN8ZHnOlf1H8R72CMJYmv7ggM+eQjW4w2I1OK80sR
         vPZhqqSxMNZ2rS1p+jputs0nYEw/zjfKpQ+/gDa7qg8zVX0xX9WqGPa/esT0pdAS8Hwf
         delut8CxhT7aU64PDz9BjlqxDNDewvjzotU0RblOg1eZnSuxH847sAhxxYYNKX9LMhLS
         ozdQ1GXQ/LhY1W9Z7frmFJEU4ad+BjEeLv0/l6hhnLFIUD79+FM0gZFIv3hxqxWQvJ00
         xA95/Wf9h4EyD1bj0KamlkcrRUHJ3VI00pFuqp8+ry5EeESn9SJP8XvJOCG3N6rHEuGp
         zX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueUgeIECYj+r+SrAYxUIGegHG7aG2+pUTnoP0l5Uui0=;
        b=awna0iTCtNMmaTBMpBcED/eoTqhlFUK3al35kGdJaqqrOyE7d4xzWoF4mcnb47oLIj
         6k7pd9uan9oq+0ZBUVhbBjC2xL49Rhvo+sfy+PbNPdrWoXva/NkXMQOSxgyqY/sZo7BT
         TiJE20CwkPvdmU1SfkcRgm67vXa28pit0TBHXxDJ2yJzQu+JktALPmp5iG3qP0Pc4ugE
         H+YLhddXqzzv+K76UH88VeX/NL50ThYlle+G0B7oaicbXX15L4YIIv8YnqHJnjJ89Lrj
         1EbfTV0AVIFwyGpsoVxF0mZP2YWre5djm4zSuz9W/QN4F5nycZZfrpuk36rrcPNYcS8b
         iAIw==
X-Gm-Message-State: AOAM531CgeBIHpibqyyuLDDmAHdTMQox8LcCXkPZN6+1biE65CEEvjNy
        st2dx+mbTCj58p4/jMe/gTm22w==
X-Google-Smtp-Source: ABdhPJwHYKHIni03PvUF1w3k2UCA+7maAj1jvGFGNefTUYafEOSDiy92+61qoxOMMt1zn6qNzZVSAg==
X-Received: by 2002:a7b:c3d2:: with SMTP id t18mr17654509wmj.112.1604312759279;
        Mon, 02 Nov 2020 02:25:59 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id o7sm21766730wrp.23.2020.11.02.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:25:58 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 3/3] scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
Date:   Mon,  2 Nov 2020 10:25:44 +0000
Message-Id: <20201102102544.1018706-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102102544.1018706-1-lee.jones@linaro.org>
References: <20201102102544.1018706-1-lee.jones@linaro.org>
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
 drivers/scsi/pm8001/pm8001_hwi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2b7b2954ec31a..cb6959afca7fa 100644
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
@@ -467,7 +467,6 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 	so that the written value will be 0x8090c016.
 	This will ensure only down-spreading SSC is enabled on the SPC.
 	*************************************************************/
-	value = pm8001_cr32(pm8001_ha, 2, 0xd8);
 	pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
 
 	/*set the shifted destination address to 0x0 to avoid error operation */
-- 
2.25.1

