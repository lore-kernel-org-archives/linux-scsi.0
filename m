Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8338FC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 06:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C59E613B9
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 06:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhFPGkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 02:40:21 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7325 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhFPGkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 02:40:19 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4b4j2Lpgz6y7X;
        Wed, 16 Jun 2021 14:34:13 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:38:04 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:38:03 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "Sesidhar Baddela" <sebaddel@cisco.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "Adaptec OEM Raid Solutions" <aacraid@microsemi.com>,
        Brian King <brking@us.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Hannes Reinecke <hare@suse.de>,
        "Manish Rangankar" <mrangankar@marvell.com>,
        Adam Radford <aradford@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 17/20] scsi: aic94xx: remove unnecessary oom message
Date:   Wed, 16 Jun 2021 14:37:11 +0800
Message-ID: <20210616063714.778-18-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210616063714.778-1-thunder.leizhen@huawei.com>
References: <20210616063714.778-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
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


