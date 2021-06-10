Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0C4C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 07:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F54613D0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 07:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhFJHsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:48:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9061 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFJHsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 03:48:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0wv95GJzzYsZV;
        Thu, 10 Jun 2021 15:43:17 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:46:08 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:46:07 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: aic94xx: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 15:46:01 +0800
Message-ID: <20210610074601.15659-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes scripts/checkpatch.pl warning:
WARNING: Possible unnecessary 'out of memory' message

Remove it can help us save a bit of memory.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 4 +---
 drivers/scsi/aic94xx/aic94xx_sds.c  | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index a195bfe9eccc073..9edd6008bbdec03 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -725,10 +725,8 @@ static int asd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	asd_dev = &asd_pcidev_data[asd_id];
 
 	asd_ha = kzalloc(sizeof(*asd_ha), GFP_KERNEL);
-	if (!asd_ha) {
-		asd_printk("out of memory\n");
+	if (!asd_ha)
 		goto Err_put;
-	}
 	asd_ha->pcidev = dev;
 	asd_ha->sas_ha.dev = &asd_ha->pcidev->dev;
 	asd_ha->sas_ha.lldd_ha = asd_ha;
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 297a66770260ccf..1b46f0018e0bfe5 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -342,10 +342,8 @@ int asd_read_ocm(struct asd_ha_struct *asd_ha)
 		return -1;
 
 	dir = kmalloc(sizeof(*dir), GFP_KERNEL);
-	if (!dir) {
-		asd_printk("no memory for ocm dir\n");
+	if (!dir)
 		return -ENOMEM;
-	}
 
 	err = asd_read_ocm_dir(asd_ha, dir, 0);
 	if (err)
-- 
2.26.0.106.g9fadedd


