Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5BDC001DE
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 12:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjGYM7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjGYM7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 08:59:36 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A61173B
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 05:59:35 -0700 (PDT)
Received: from dggpemm100011.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R9H9Q1NvGzLnxV;
        Tue, 25 Jul 2023 20:56:58 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm100011.china.huawei.com (7.185.36.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 20:59:32 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 20:59:31 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <changyuanl@google.com>,
        <pranavpp@google.com>, <yangyingliang@huawei.com>
Subject: [PATCH] scsi: pm80xx: fix error return code in pm8001_pci_probe()
Date:   Tue, 25 Jul 2023 20:57:06 +0800
Message-ID: <20230725125706.566990-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If pm8001_init_sas_add() fails, return error code in pm8001_pci_probe().

Fixes: 14a8f116cdc0 ("scsi: pm80xx: Add GET_NVMD timeout during probe")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 2e886c1d867d..4995e1ef4e0e 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1181,7 +1181,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		pm80xx_set_thermal_config(pm8001_ha);
 	}
 
-	if (pm8001_init_sas_add(pm8001_ha))
+	rc = pm8001_init_sas_add(pm8001_ha);
+	if (rc)
 		goto err_out_shost;
 	/* phy setting support for motherboard controller */
 	rc = pm8001_configure_phy_settings(pm8001_ha);
-- 
2.25.1

