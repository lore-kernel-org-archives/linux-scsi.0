Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741CCC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DE65206E2
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592447728;
	bh=sL7nnOiPPke7mDInqqUlQbXdMGaBvrJTRd++L4TPlhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nw9gAe60ZlG2VSaJaiml2v9Nr984aUTKVHX+uOCJgZIqJvZdYV/qjp2vgCGxZo5E3
	 YrcK6YReZQNKbca3keGrO2vvI3JKq/L1ssg5brzbn+Vtmw0y0CZ1rq1iYMhb5bLPem
	 THrTuyZvKefJaaARogWVTCtTrX/XLeF/H2h0P9lo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbgFRCfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgFRBOR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4365221E6;
        Thu, 18 Jun 2020 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442856;
        bh=sL7nnOiPPke7mDInqqUlQbXdMGaBvrJTRd++L4TPlhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGmw2KYKc8SJ8E1QfF54zprnrJc+f2OanAoFhvIWVHtfPqPzWmBWw70JPCB8xhmGQ
         LOg9QXwG2RyDzQJXzhPSgKqV/0/xqh+iofBSE8uvMuXDU79iDW4Cv4qsnLGk5nsZz9
         gwzo4mZHYXt3KhOkVuLBMEPpOUGqCORxkHVOnXlw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 286/388] scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes
Date:   Wed, 17 Jun 2020 21:06:23 -0400
Message-Id: <20200618010805.600873-286-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 22617e21633142dd2b81541cb3b95d6fb59aa85f ]

Fix unwinding of pm_runtime changes when bailing out of driver probe due to
a failure and also on removal of driver.

Link: https://lore.kernel.org/r/20200526100340.15032-1-vigneshr@ti.com
Fixes: 6979e56cec97 ("scsi: ufs: Add driver for TI wrapper for Cadence UFS IP")
Reported-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.25.1

