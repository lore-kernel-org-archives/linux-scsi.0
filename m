Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A14DC4708E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 23:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiLAXKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiLAXKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 18:10:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEADEBDCF1
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 15:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669936127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPrzspswmnM04Pzvw/sX2KvWfaVbj7fPyU5av4wS70Y=;
        b=b9FG7Ljwvl90d5edMdy76ArbmSRBMyCQO7avuznTHuVsjHN194e5ocO2xzw1LexbH0UIOq
        SLdRmbFNWpRnUX8HJ29y8BY+VHULXmRkrAp9Sx3yx9apA7ZrGYElO16jdYXcwiOm/JzwZx
        yfUjexvdAfdVImL94vBrMz4kMRNQfW4=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-92-3EmKW4lDMVKIcm-LGPI7Qw-1; Thu, 01 Dec 2022 18:08:45 -0500
X-MC-Unique: 3EmKW4lDMVKIcm-LGPI7Qw-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-14355480b19so1499451fac.12
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 15:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPrzspswmnM04Pzvw/sX2KvWfaVbj7fPyU5av4wS70Y=;
        b=v9z6961i/SRaMzmsfQ3gFrUgNCQrxv3RbWRXCzOUQWq9R5na3NCHf73dd5O4lF/5pY
         F1/LuowuKJpinxN7EP0w4jAZMXdtUIWm32/ez5ITgZ6DSIyGWtKYDTxLRgbjcJMvV4LP
         hakRq2UxW+DuTDKF6ZNdFWq+ihDh22tx4yNif8zim6pRck6lhp4KJ3saA/wH9948vBSX
         0AZOdV8mDW08Un96tKQ8Yx51gX3W+dLki3pvKXIZkhCoDTv6FqPXDbxAlkuTv3Z5CXK3
         XoDIehoPQv1/Pu/5jK/No1JWVNWx4jMbZaCqoJF2DmeUtQu+/2JRvy4UyMX7N8oAneiE
         rgJg==
X-Gm-Message-State: ANoB5pnjsMgJHw1ndeVAb0/yYMuhc/NK8prZC5R0wJZ2CCKD+2SFB5VG
        LmInFDKpjbXaZk1ooLBwp1rsaJDpvBNU/+mwbyqcY6Qluto7m6p+aZqq9kfJz1bac1rIH22lEhQ
        6ZupHMD91OZ2TtP3hI1f2VQ==
X-Received: by 2002:a4a:960d:0:b0:49f:e673:83e with SMTP id q13-20020a4a960d000000b0049fe673083emr23060996ooi.11.1669936124505;
        Thu, 01 Dec 2022 15:08:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5YlOgKdDN8wHAmpjNDhFeopPIS0YT5zwTbSpx4fpb8bL8HSsnIOoDDopUdZlbaSXKTV+oKew==
X-Received: by 2002:a4a:960d:0:b0:49f:e673:83e with SMTP id q13-20020a4a960d000000b0049fe673083emr23060981ooi.11.1669936124291;
        Thu, 01 Dec 2022 15:08:44 -0800 (PST)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id y22-20020a4ade16000000b0049fb2a96de4sm2320393oot.0.2022.12.01.15.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:08:43 -0800 (PST)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, p.zabel@pengutronix.de,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 1/4] scsi: ufs: ufs-qcom: Drop unnecessary NULL checks
Date:   Thu,  1 Dec 2022 17:08:07 -0600
Message-Id: <20221201230810.1019834-2-ahalaney@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201230810.1019834-1-ahalaney@redhat.com>
References: <20221201230810.1019834-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code path is only called through one function, and the hba
struct is already accessed in ufshcd_vops_dbg_register_dump() prior to
calling so there is no way for it to be NULL.

Likewise, the print_fn callback is always supplied within this driver
and is always provided.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ad1415e10b6..70e25f9f8ca8 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1202,15 +1202,6 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
 	u32 reg;
 	struct ufs_qcom_host *host;
 
-	if (unlikely(!hba)) {
-		pr_err("%s: hba is NULL\n", __func__);
-		return;
-	}
-	if (unlikely(!print_fn)) {
-		dev_err(hba->dev, "%s: print_fn is NULL\n", __func__);
-		return;
-	}
-
 	host = ufshcd_get_variant(hba);
 	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
 		return;
-- 
2.38.1

