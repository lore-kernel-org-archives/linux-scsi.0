Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBF0C64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 08:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjB0IQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 03:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB0IQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 03:16:14 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701741C330
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 00:16:13 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id az36so3668181wmb.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 00:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M50trv07sqauBaQDrLtb3meCS90aP4izbTWS/AZv9IU=;
        b=meZ4kd9dD52gWqZCRyCOKDpanSx9uGztwbZvRO3ti585g1sJnPMuTOrlHlgOc+QmPX
         Aq87dz3a0CzsKaz3PeHBBMNm5+KKml84ofVv1jlrMqhPzI1h1McE/mDLzMqkXMz3X2iY
         z0WW+5D6xu/R5+CWmHIauJcCyGg/uisVq5ZUwKPOg3GMiRwPYzuRRpzFafHkGWReh7Jn
         GJf44zjBY/z49qStotl0R+spkdA4JwgJcBqWtYJxglT7zgGb7AFLde/i/82P83EbdO/m
         TjNFtkuAlbQUAzDEm3ZFI3OEXpNhBQ/WCMrYEAmi69/ZsSHtb+r8HN5YCF7nUQe308Er
         oGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M50trv07sqauBaQDrLtb3meCS90aP4izbTWS/AZv9IU=;
        b=f3oSMuFaU7ruhgZRVpSWWxzinooFpmo4vaP4xX0cwXecgeOYdcj594KUeUZHkOZPDs
         asHGE56dFkkGN4563iHZ50hQ1ZmUkBrTyV1UfvjsdF66av7eefnXwB2GHj89U/sHwCh6
         8ChkiQxkXCcOzsmuaLxWuMfk8IwTB2AErzWuSaCEvmPkKE6hKq/MwzxK0yuraMMBe028
         6l/ulnJOjcYV1GDTr+YLNw3oe7wTzyvAewFo7E1nwxyWruQvAQzARmhMifXsy/WlCer3
         rRdABhhrcXsa91VO7GR9j7hAWBHefoGQuvg8ODmSnMYC/1tUUSs/chjBK2AFKlEe2ubM
         uiPQ==
X-Gm-Message-State: AO0yUKWncK/NHrdeTdm9CMm5FSQ5IAqhpJrdxRyyuB3H05I8d8AM2TwW
        Vh0JaJri8wlKNiBvwSh94Y0=
X-Google-Smtp-Source: AK7set8iI53loB3E/8w80WpEc5lbMr+myMo2MFk0tloH3q9OTolGF1L83RHwOh63DAw31nSzX9ISSg==
X-Received: by 2002:a05:600c:3088:b0:3eb:29fe:7b9b with SMTP id g8-20020a05600c308800b003eb29fe7b9bmr6903528wmn.9.1677485771905;
        Mon, 27 Feb 2023 00:16:11 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a1-20020a05600c224100b003e118684d56sm12014328wmm.45.2023.02.27.00.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 00:16:11 -0800 (PST)
Date:   Mon, 27 Feb 2023 11:16:07 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     quic_asutoshd@quicinc.com
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: core: mcq: Configure resource regions
Message-ID: <Y/xmx5xpbjUJlNxy@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Asutosh Das,

The patch c263b4ef737e: "scsi: ufs: core: mcq: Configure resource
regions" from Jan 13, 2023, leads to the following Smatch static
checker warning:

drivers/ufs/host/ufs-qcom.c:1455 ufs_qcom_mcq_config_resource() warn: passing zero to 'PTR_ERR'
drivers/ufs/host/ufs-qcom.c:1469 ufs_qcom_mcq_config_resource() info: returning a literal zero is cleaner

drivers/ufs/host/ufs-qcom.c
    1425 static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
    1426 {
    1427         struct platform_device *pdev = to_platform_device(hba->dev);
    1428         struct ufshcd_res_info *res;
    1429         struct resource *res_mem, *res_mcq;
    1430         int i, ret = 0;
    1431 
    1432         memcpy(hba->res, ufs_res_info, sizeof(ufs_res_info));
    1433 
    1434         for (i = 0; i < RES_MAX; i++) {
    1435                 res = &hba->res[i];
    1436                 res->resource = platform_get_resource_byname(pdev,
    1437                                                              IORESOURCE_MEM,
    1438                                                              res->name);
    1439                 if (!res->resource) {
    1440                         dev_info(hba->dev, "Resource %s not provided\n", res->name);
    1441                         if (i == RES_UFS)
    1442                                 return -ENOMEM;
    1443                         continue;
    1444                 } else if (i == RES_UFS) {
    1445                         res_mem = res->resource;
    1446                         res->base = hba->mmio_base;
    1447                         continue;
    1448                 }
    1449 
    1450                 res->base = devm_ioremap_resource(hba->dev, res->resource);
    1451                 if (IS_ERR(res->base)) {
    1452                         dev_err(hba->dev, "Failed to map res %s, err=%d\n",
    1453                                          res->name, (int)PTR_ERR(res->base));
    1454                         res->base = NULL;
                                 ^^^^^^^^^^^^^^^^

--> 1455                         ret = PTR_ERR(res->base);
                                 ^^^^^^^^^^^^^^^^^^^^^^^^
Need to preserve the error code beforse setting this to NULL.

    1456                         return ret;
    1457                 }
    1458         }
    1459 
    1460         /* MCQ resource provided in DT */
    1461         res = &hba->res[RES_MCQ];
    1462         /* Bail if MCQ resource is provided */
    1463         if (res->base)
    1464                 goto out;
    1465 
    1466         /* Explicitly allocate MCQ resource from ufs_mem */
    1467         res_mcq = devm_kzalloc(hba->dev, sizeof(*res_mcq), GFP_KERNEL);
    1468         if (!res_mcq)
    1469                 return ret;

Return -ENOMEM;

    1470 
    1471         res_mcq->start = res_mem->start +
    1472                          MCQ_SQATTR_OFFSET(hba->mcq_capabilities);
    1473         res_mcq->end = res_mcq->start + hba->nr_hw_queues * MCQ_QCFG_SIZE - 1;
    1474         res_mcq->flags = res_mem->flags;
    1475         res_mcq->name = "mcq";
    1476 
    1477         ret = insert_resource(&iomem_resource, res_mcq);
    1478         if (ret) {
    1479                 dev_err(hba->dev, "Failed to insert MCQ resource, err=%d\n",
    1480                         ret);
    1481                 goto insert_res_err;
    1482         }
    1483 
    1484         res->base = devm_ioremap_resource(hba->dev, res_mcq);
    1485         if (IS_ERR(res->base)) {
    1486                 dev_err(hba->dev, "MCQ registers mapping failed, err=%d\n",
    1487                         (int)PTR_ERR(res->base));
    1488                 ret = PTR_ERR(res->base);
    1489                 goto ioremap_err;
    1490         }
    1491 
    1492 out:
    1493         hba->mcq_base = res->base;
    1494         return 0;
    1495 ioremap_err:
    1496         res->base = NULL;
    1497         remove_resource(res_mcq);
    1498 insert_res_err:
    1499         devm_kfree(hba->dev, res_mcq);

No need to call devm_kfree().  The whole point of devm_ is that it's
automatic.

    1500         return ret;
    1501 }

regards,
dan carpenter
