Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C64C001E0
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 02:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbjHOC5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 22:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjHOC5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 22:57:39 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47DE7A
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 19:57:38 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RPwp12d0sztRwG;
        Tue, 15 Aug 2023 10:54:01 +0800 (CST)
Received: from localhost.localdomain (10.175.103.91) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 15 Aug 2023 10:57:36 +0800
From:   Jialin Zhang <zhangjialin11@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-scsi@vger.kernel.org>, <megaraidlinux.pdl@broadcom.com>,
        <liwei391@huawei.com>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 1/3] scsi: mvumi: Use pci_dev_id() to simplify the code
Date:   Tue, 15 Aug 2023 10:54:17 +0800
Message-ID: <20230815025419.3523236-2-zhangjialin11@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230815025419.3523236-1-zhangjialin11@huawei.com>
References: <20230815025419.3523236-1-zhangjialin11@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500021.china.huawei.com (7.185.36.109)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PCI core API pci_dev_id() can be used to get the BDF number for a pci
device. We don't need to compose it mannually. Use pci_dev_id() to
simplify the code a little bit.

Signed-off-by: Jialin Zhang <zhangjialin11@huawei.com>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 73aa7059b556..97f9d2fa6429 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2490,7 +2490,7 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mhba->pdev = pdev;
 	mhba->shost = host;
-	mhba->unique_id = pdev->bus->number << 8 | pdev->devfn;
+	mhba->unique_id = pci_dev_id(pdev);
 
 	ret = mvumi_init_fw(mhba);
 	if (ret)
-- 
2.25.1

