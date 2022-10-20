Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E592C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 14:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiJTORf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 10:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJTORb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 10:17:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC1D5BC84
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 07:17:30 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MtV6S2gn9zHtdG
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 22:17:20 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 22:17:27 +0800
From:   Yihang Li <liyihang9@huawei.com>
To:     <john.garry@huawei.com>, <linuxarm@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <chenxiang66@hisilicon.com>,
        <prime.zeng@hisilicon.com>, <yangxingui@huawei.com>,
        <liyihang9@huawei.com>
Subject: [PATCH 1/2] scsi: libsas: Add sas_update_linkrate()
Date:   Thu, 20 Oct 2022 22:16:34 +0800
Message-ID: <20221020141635.2479412-2-liyihang9@huawei.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20221020141635.2479412-1-liyihang9@huawei.com>
References: <20221020141635.2479412-1-liyihang9@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support for updates the link rate of all expander devices and
expander SATA PHYs connected to the port and triggers revalidation.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 40 ++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 41 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index a18259f68c40..0cfb98c791c9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2029,6 +2029,46 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
 	return false;
 }
 
+void sas_update_linkrate(struct asd_sas_port *port)
+{
+	struct domain_device *parent, *dev, *n;
+	struct sas_phy *local_phy;
+	struct ex_phy *ex_phy;
+	int phy_id;
+
+	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
+		if (dev_is_expander(dev->dev_type)) {
+			dev->linkrate = port->linkrate;
+			dev->min_linkrate = port->linkrate;
+			dev->max_linkrate = port->linkrate;
+			dev->ex_dev.ex_change_count = -1;
+		}
+
+		local_phy = sas_get_local_phy(dev);
+		if (scsi_is_sas_phy_local(local_phy)) {
+			sas_put_local_phy(local_phy);
+			continue;
+		}
+
+		parent = dev->parent;
+		phy_id = local_phy->number;
+		ex_phy = &parent->ex_dev.ex_phy[phy_id];
+		if (dev_is_sata(dev)) {
+			if (dev->linkrate > parent->min_linkrate) {
+				struct sas_phy_linkrates rates = {
+					.maximum_linkrate = parent->min_linkrate,
+					.minimum_linkrate = parent->min_linkrate,
+				};
+
+				sas_smp_phy_control(parent, phy_id,
+						    PHY_FUNC_LINK_RESET, &rates);
+				ex_phy->phy_change_count = -1;
+			}
+		}
+		sas_put_local_phy(local_phy);
+	}
+}
+
 void async_sas_ex_phy_refresh_linkrate(void *data, async_cookie_t cookie)
 {
 	struct domain_device *dev = data;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 591b217b0813..fc976043a523 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -36,6 +36,7 @@ int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
 
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
+void sas_update_linkrate(struct asd_sas_port *port);
 void async_sas_ex_phy_refresh_linkrate(void *data, async_cookie_t cookie);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
-- 
2.30.0

