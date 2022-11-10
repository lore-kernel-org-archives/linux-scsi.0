Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFA0C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 15:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiKJPM6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 10:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKJPM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 10:12:57 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B35303FD
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 07:12:56 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7QLM6ndjzHvjh;
        Thu, 10 Nov 2022 23:12:27 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 23:12:53 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 10 Nov
 2022 23:12:53 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <storagedev@microchip.com>
CC:     <don.brace@microchip.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <yangyingliang@huawei.com>
Subject: [PATCH] scsi: hpsa: fix error handling in hpsa_add_sas_host()
Date:   Thu, 10 Nov 2022 23:11:29 +0800
Message-ID: <20221110151129.394389-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Here is implenmention of hpsa_sas_port_add_phy():
hpsa_sas_port_add_phy()
  ...
  sas_phy_add()  -> may return error here
  sas_port_add_phy()
  ...

Here is implenmention of hpsa_free_sas_phy():
hpsa_free_sas_phy()
  ...
  sas_port_delete_phy()
  sas_phy_delete()
  ...

If hpsa_sas_port_add_phy() returns error, hpsa_free_sas_phy()
can not be called free the memory, because the port and the
phy have not been added yet. So replace it with sas_phy_free()
and kfree() to avoid kernel crash in this case.

Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f8e832b1bc46..b3f195467e97 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9786,7 +9786,8 @@ static int hpsa_add_sas_host(struct ctlr_info *h)
 	return 0;
 
 free_sas_phy:
-	hpsa_free_sas_phy(hpsa_sas_phy);
+	sas_phy_free(hpsa_sas_phy->phy);
+	kfree(hpsa_sas_phy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 free_sas_node:
-- 
2.25.1

