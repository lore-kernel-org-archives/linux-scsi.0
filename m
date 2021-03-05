Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CC3C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 09:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABE764F69
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 09:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCEJON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 04:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCEJOF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 04:14:05 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913BDC061574;
        Fri,  5 Mar 2021 01:14:05 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id j12so1548544pfj.12;
        Fri, 05 Mar 2021 01:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4zEE7rqrK3goJLrxJadwawdflEcIk4A0CqTQec6iyds=;
        b=Kx4x3Cc3LsPrKyHpdcTnHmDMM1eHkVYfQnKItph3uxOwNmd6qVQgw651IpyCCk6bJD
         GVfzi5DFVZpJcE/9lvNN4I9vpgecFoDU6U/aILIJsFC8Rp3DOZ570QjE7mEkuRf+swyJ
         brqcwgZAxuHqqzZycGhDQAmv/v250lpLQNb8dVgx8/Xae0o7nAr63Zo3c66UkhTPPjBo
         BM5fMoA5zuOTQIvVBGbCJw8g46mkja1dsu5wJYK/eYKRCumY4AL46Q/RHDd4O6/uXqb5
         WjwHq7g5iMH4FMPOajkFY9uV0XYSd8B7etynSSVjLETforv9hVCe5uc5cW3g167+Wl9Q
         mxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4zEE7rqrK3goJLrxJadwawdflEcIk4A0CqTQec6iyds=;
        b=Awn29SW7McLaDeeWzuOuBzXnuxhEOCAcZZypv3rb1mT7h5GWPOC5ZepEinfinUVAX0
         fIesvO//1wZtGjC6u2UVTq2wAa/BEVoLUqbIKa2E3pMMn45GGWDtxbvv7BoDVUokaTmX
         tpJEdTy3cpjtZdDNLVdSm1kKzPMo2REfo662VVLjyTo5oZgSap+Pm57IqqYSdpBHIfzj
         2b4NOf9ElzypOhUhkmFosOTlGFbNy0vB9ucglBqridd8SUpSVp719ofv77HDFtbFeokQ
         VGwgXf44elydZFoaQpjU6pSurtnXyImhMR0HFkVApu2wn4yuMs2doxD0DZPpPRpdnL8o
         KCtw==
X-Gm-Message-State: AOAM533kc8qW5QGmYqVmKnE8Jk1lVRbm2NpHt+CMVE1Tov+19a5/+zPC
        0ct5Gz586y6NU5fdcjh2/K0=
X-Google-Smtp-Source: ABdhPJwEBq+wJr2WgZsr2R5XNMcQXCEmmZcnKDrXvixiB7fslPTCQ7eG/vQrapqM2CuZRGi+IYll8w==
X-Received: by 2002:a62:1997:0:b029:1ed:5de5:5f1c with SMTP id 145-20020a6219970000b02901ed5de55f1cmr7984327pfz.14.1614935645227;
        Fri, 05 Mar 2021 01:14:05 -0800 (PST)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id gz12sm1717617pjb.33.2021.03.05.01.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:14:04 -0800 (PST)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, cang@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-kernel@vger.kernel.org, huyue2@yulong.com,
        zhangwen@yulong.com, zbestahu@163.com
Subject: [PATCH] scsi: ufs: Remove redundant WB enabling check in ufshcd_wb_toggle_flush()
Date:   Fri,  5 Mar 2021 17:12:53 +0800
Message-Id: <20210305091253.314-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

Note that ufshcd_wb_toggle_flush() will be called only in
ufshcd_wb_config() which have already checked if WB is allowed.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 721f55d..2c49344 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5484,8 +5484,7 @@ static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 	u8 index;
 	enum query_opcode opcode;
 
-	if (!ufshcd_is_wb_allowed(hba) ||
-	    hba->dev_info.wb_buf_flush_enabled == enable)
+	if (hba->dev_info.wb_buf_flush_enabled == enable)
 		return 0;
 
 	if (enable)
-- 
1.9.1

