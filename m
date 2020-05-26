Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D14C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 10:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8469C2089D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 10:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="D8ZnHpxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgEZKD6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 06:03:58 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:54518 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgEZKD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 06:03:58 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QA3qrp088507;
        Tue, 26 May 2020 05:03:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590487432;
        bh=zscS9FP/a2BOKezMBhuGRAAlG6YFdt78PB11GvCOr+k=;
        h=From:To:CC:Subject:Date;
        b=D8ZnHpxMyLU3vvQR21UQHPTSLkxlLybpdf440YSzfEddLg+kohq/HTeDUhc0B5jaw
         E3N7Er8nvlcF+n/uzas+rIKm49NiFihSdJw5c1HmXQQJnYsGvvNXydPxKlKlk+e9oY
         hLHOjZ04WIF3MAnIZYax8Q1TLgN3MxZk6azU6s04=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04QA3qsb079732
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 05:03:52 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 05:03:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 05:03:51 -0500
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QA3mdt113528;
        Tue, 26 May 2020 05:03:49 -0500
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>
Subject: [PATCH] scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes
Date:   Tue, 26 May 2020 15:33:40 +0530
Message-ID: <20200526100340.15032-1-vigneshr@ti.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix unwinding of pm_runtime changes when bailing out of driver probe due
to a failure and also on removal of driver.

Fixes: 6979e56cec97 ("scsi: ufs: Add driver for TI wrapper for Cadence UFS IP")
Reported-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 drivers/scsi/ufs/ti-j721e-ufs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index 5216d228cdd9..46bb905b4d6a 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -32,14 +32,14 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(dev);
-		return ret;
+		goto disable_pm;
 	}
 
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(dev, "Cannot claim MPHY clock.\n");
-		return PTR_ERR(clk);
+		goto clk_err;
 	}
 	clk_rate = clk_get_rate(clk);
 	if (clk_rate == 26000000)
@@ -54,16 +54,23 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 				   dev);
 	if (ret) {
 		dev_err(dev, "failed to populate child nodes %d\n", ret);
-		pm_runtime_put_sync(dev);
+		goto clk_err;
 	}
 
 	return ret;
+
+clk_err:
+	pm_runtime_put_sync(dev);
+disable_pm:
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static int ti_j721e_ufs_remove(struct platform_device *pdev)
 {
 	of_platform_depopulate(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return 0;
 }
-- 
2.26.2

