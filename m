Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E3DC04E69
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 18:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjHNSuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 14:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjHNSuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 14:50:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC13F1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 11:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692038957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Gp3M5Azj+TRHJSQxak5e6jqixExltDd4LGqwek74hI=;
        b=IYtA1oJyxbfLODvpGiJLRSsD/rDS7fvJ4TzCL+pXbp0vJOVjfkjPQtrwceK3BCBPW7iVu+
        oLGzwMkNl/9+gqbm4xTSkrgG8cOm4/0/UR2qQRsO2iJ2zkceVgh3Kjo6Rxm2Rd8Cl/RUv0
        0M2GS2rwaQAL0FM/ZXqvBEE4f48gtfc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-iRHK0jwMMCGM4O_V0_KyaQ-1; Mon, 14 Aug 2023 14:49:15 -0400
X-MC-Unique: iRHK0jwMMCGM4O_V0_KyaQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-58c4d30c349so7525547b3.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 11:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692038644; x=1692643444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Gp3M5Azj+TRHJSQxak5e6jqixExltDd4LGqwek74hI=;
        b=YcSawiJLQg/8fD/Jo5IBs9P5cj4G2FGukzLsbcXIHifbfMdKbKJ5TsMRV+fe1iCLXo
         SL5WCFRegvzyYlEwZSAILO1Hy+3+BdgEAQ66ieltM668XcRcs0GHicQH4VTb7Z6VI4lo
         draXFfCPEj+Y0+c8v3H/+F/bQtVRkBod2unIEG546dbjwL+HHbEN5ICucCI0pmAXUof0
         3onSOurS3b1X2FV07sl1tULsyJOWrzNsvISxkcnF1v94BQK6ZM7kZZb+xhVhugIbRg03
         pYvLo9FjTZhfq7DhHUaf0+fr0C0w+168R9ekG041koCeTGrQB+KvEqn/oOgTqyeiak4P
         HRcg==
X-Gm-Message-State: AOJu0Yx63wMdyiGvXBzRYfJiRgb5f8Y6gaW2Z+6Jccbs+foIZXakBRLm
        zM3DTqjpfVXi/ihJyir0qANFKX2RVsQ8wRi0Sr0P/NLmHYZKDR6QwB+5rYdMTlv0M9dQQ6TFrwB
        bIcHqqz0IkQFiUimQpEI4dA==
X-Received: by 2002:a25:5f05:0:b0:d43:18d7:e292 with SMTP id t5-20020a255f05000000b00d4318d7e292mr10598596ybb.32.1692038644200;
        Mon, 14 Aug 2023 11:44:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGguQmeB10V/5AccRVyZd0dd7vr6MgAslQXlaCOlGjUzVLf76JAbZjfOrHJFSTqf8yAC1Plxg==
X-Received: by 2002:a25:5f05:0:b0:d43:18d7:e292 with SMTP id t5-20020a255f05000000b00d4318d7e292mr10598588ybb.32.1692038643975;
        Mon, 14 Aug 2023 11:44:03 -0700 (PDT)
Received: from brian-x1.. (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id x131-20020a25ce89000000b00d674f3e2891sm1864387ybe.40.2023.08.14.11.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:44:02 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@hugovil.com, quic_nguyenb@quicinc.com
Subject: [PATCH v3 2/2] scsi: ufs: host: convert to dev_err_probe() in pltfrm_init
Date:   Mon, 14 Aug 2023 14:43:52 -0400
Message-ID: <20230814184352.200531-3-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814184352.200531-1-bmasney@redhat.com>
References: <20230814184352.200531-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert ufshcd_pltfrm_init() over to use dev_err_probe() to avoid
the following log message on bootup due to an -EPROBE_DEFER return
code:

    ufshcd-qcom 1d84000.ufs: Initialization failed

While this line is changed, let's also go ahead and add the error code
to the message as well.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
Changes since v2
- Add error code to message

Changes since v1
- None

 drivers/ufs/host/ufshcd-pltfrm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 0b7430033047..c81a14f9eaf5 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -373,7 +373,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
-		dev_err(dev, "Initialization failed\n");
+		dev_err_probe(dev, err, "Initialization failed with error %d\n",
+			      err);
 		goto dealloc_host;
 	}
 
-- 
2.41.0

