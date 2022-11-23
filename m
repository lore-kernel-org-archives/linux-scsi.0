Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB4DC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 07:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiKWHvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 02:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiKWHuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 02:50:09 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E05FA72A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:53 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so1195187pjs.4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff060FMlh2MHBX3ga6yMFYN0UyVEYS40VqwmLXF4PCQ=;
        b=DJBZrYbtm9X/QLJ/W0BggBinY/2j9h/csY7y1RXj4ibeLojZMPOM79qLxjtvmX+0ef
         qHTZgJHFtB32vZURoOJwLrNnSQaX+2bXlf8zHuE6hiZvRxi7W+LWnTCMbLdSEjKKDFtr
         rKUTqK0DqmheaA9m8c6D41qw7p4fLNAiNy+PHR04AEaVDVbk5EpB+rRgUXGybW134Dfa
         o4VjElLklHUuz5FiE57L+c8177u3W7udeCaUt7iGmyf7sLEWBSAQ7XWXEHHDp0xcZmxV
         BS/SqxE5y3XMtTkm4XOZMcntYbiHkMT+O69Uqzk1+oWlwsjgpd+I94tXWMAjZ+a6pFNg
         B6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff060FMlh2MHBX3ga6yMFYN0UyVEYS40VqwmLXF4PCQ=;
        b=bYdKqAGLmNr5trVSGR6H5ffxfltgHyumYmuATo5nAr3vtMam92wveMH23pbmADb5rK
         ZZtfmSM7EbInEaLGKQVfLxG6pfRtjjvaSViasH8U63VYKGecgVoj9kpzRtQ8LcIq9QVV
         526uUGW9pjdd6uZiG+oxBv6yFqh8V4D7D+dzJZY3gHdqdWYgZ/gX9cMWxWWzU1yWFZWX
         1k0vDjwKbQrQSsVR0lU6Z1MooHYXq2ZufVUa6UgkmD/K5Nh2wKM4gYyjYgA++y9KSXy8
         94Ar4/2muKCXFudJHL+EXjXZnBmZ5ZZPok9ZM7yneQV+cMXBoKCM2n8CIWL77z+/fpjY
         teCg==
X-Gm-Message-State: ANoB5pmdFyu79XaunLfDvsitEzbL/+H9e/6kpi2Y2hbW52gyHelKl7+w
        5JSaFfmxm2++kTHmzmV78aEQ
X-Google-Smtp-Source: AA0mqf7JrTjVi6IhOYnAnZ7BbIJkXhoSI7J/05AMbqHKIqgMfOzWmGZ4ebVDRyq5ynhxhMb8SwK5Cg==
X-Received: by 2002:a17:90a:73c2:b0:200:a7b4:6511 with SMTP id n2-20020a17090a73c200b00200a7b46511mr28487090pjk.101.1669189792943;
        Tue, 22 Nov 2022 23:49:52 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.0])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902a51000b001869f2120a5sm13334059plq.34.2022.11.22.23.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:49:52 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 13/20] scsi: ufs: ufs-qcom: Use dev_err_probe() for printing probe error
Date:   Wed, 23 Nov 2022 13:18:19 +0530
Message-Id: <20221123074826.95369-14-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
References: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make use of dev_err_probe() for printing the probe error.

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8bb0f4415f1a..38e2ed749d75 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1441,9 +1441,9 @@ static int ufs_qcom_probe(struct platform_device *pdev)
 	/* Perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
 	if (err)
-		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+		return dev_err_probe(dev, err, "ufshcd_pltfrm_init() failed\n");
 
-	return err;
+	return 0;
 }
 
 /**
-- 
2.25.1

