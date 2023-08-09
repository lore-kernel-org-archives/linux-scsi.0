Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C22C04A6A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 13:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjHINrH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 09:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjHINrG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 09:47:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C541EDA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 06:47:04 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RLWVB6bFDz9tXC;
        Wed,  9 Aug 2023 21:43:30 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 9 Aug
 2023 21:46:59 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yuehaibing@huawei.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH -next] scsi: libsas: Remove unused declarations
Date:   Wed, 9 Aug 2023 21:22:49 +0800
Message-ID: <20230809132249.37948-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
removed sas_hae_reset() but not its declaration.
Commit 2908d778ab3e ("[SCSI] aic94xx: new driver") declared but never implemented
other functions.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/scsi/libsas/sas_internal.h | 7 -------
 include/scsi/libsas.h              | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 6f593fa69b58..a6dc7dc07fce 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -41,13 +41,7 @@ struct sas_phy_data {
 
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
-int sas_show_class(enum sas_class class, char *buf);
-int sas_show_proto(enum sas_protocol proto, char *buf);
-int sas_show_linkrate(enum sas_linkrate linkrate, char *buf);
-int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
-
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
-void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
@@ -91,7 +85,6 @@ int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
 int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
 			     u8 *sas_addr, enum sas_device_type *type);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
-void sas_hae_reset(struct work_struct *work);
 
 void sas_free_device(struct kref *kref);
 void sas_destruct_devices(struct asd_sas_port *port);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 159823e0afbf..8557a0caf5fe 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -727,8 +727,6 @@ extern struct device_attribute dev_attr_phy_event_threshold;
 
 int  sas_discover_root_expander(struct domain_device *);
 
-void sas_init_ex_attr(void);
-
 int  sas_ex_revalidate_domain(struct domain_device *);
 
 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
-- 
2.34.1

