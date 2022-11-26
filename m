Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888A5C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 08:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKZIhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Nov 2022 03:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKZIhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Nov 2022 03:37:06 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6F21DA65
        for <linux-scsi@vger.kernel.org>; Sat, 26 Nov 2022 00:36:58 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NK4k20cSXzqSQ9;
        Sat, 26 Nov 2022 16:32:58 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 16:36:55 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <linuxdrivers@attotech.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] gpio/rockchip: Add missing of_node_put() in rockchip_gpiolib_register()
Date:   Sat, 26 Nov 2022 16:35:06 +0800
Message-ID: <20221126083506.5952-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

rockchip_gpiolib_register() get the device_node by of_get_parent() with
refcount incremented. Add of_node_put() on it before exitting
rockchip_gpiolib_register(). So as rockchip_gpio_probe().

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/gpio/gpio-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 870910bb9dd3..3c1e303aaca8 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -610,6 +610,7 @@ static int rockchip_gpiolib_register(struct rockchip_pin_bank *bank)
 			return -ENODATA;
 
 		pctldev = of_pinctrl_get(pctlnp);
+		of_node_put(pctlnp);
 		if (!pctldev)
 			return -ENODEV;
 
@@ -712,6 +713,7 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pctldev = of_pinctrl_get(pctlnp);
+	of_node_put(pctlnp);
 	if (!pctldev)
 		return -EPROBE_DEFER;
 
-- 
2.17.1

