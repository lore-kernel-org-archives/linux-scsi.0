Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC52C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 07:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiLDH4Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 02:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiLDH4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 02:56:08 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603DD175AE
        for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2022 23:56:07 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NPzVv3NbQzRpd2;
        Sun,  4 Dec 2022 15:55:19 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 4 Dec
 2022 15:56:05 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 5/6] scsi: libsas: factor out sas_ata_add_dev()
Date:   Sun, 4 Dec 2022 16:16:42 +0800
Message-ID: <20221204081643.3835966-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221204081643.3835966-1-yanaijie@huawei.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out sas_ata_add_dev() and put it in sas_ata.c since it is a sata
related interface. Also follow the standard coding style to define an
inline empty function when CONFIG_SCSI_SAS_ATA is not enabled.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c      | 62 ++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_expander.c | 54 +-------------------------
 include/scsi/sas_ata.h             |  9 +++++
 3 files changed, 73 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 01b6175a8960..f440203eb280 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -677,6 +677,68 @@ void sas_probe_sata(struct asd_sas_port *port)
 
 }
 
+int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
+		    struct domain_device *child, int phy_id)
+{
+	struct sas_rphy *rphy;
+	int ret;
+
+	if (child->linkrate > parent->min_linkrate) {
+		struct sas_phy *cphy = child->phy;
+		enum sas_linkrate min_prate = cphy->minimum_linkrate,
+			parent_min_lrate = parent->min_linkrate,
+			min_linkrate = (min_prate > parent_min_lrate) ?
+					parent_min_lrate : 0;
+		struct sas_phy_linkrates rates = {
+			.maximum_linkrate = parent->min_linkrate,
+			.minimum_linkrate = min_linkrate,
+		};
+
+		pr_notice("ex %016llx phy%02d SATA device linkrate > min pathway connection rate, attempting to lower device linkrate\n",
+			  SAS_ADDR(child->sas_addr), phy_id);
+		ret = sas_smp_phy_control(parent, phy_id,
+					  PHY_FUNC_LINK_RESET, &rates);
+		if (ret) {
+			pr_err("ex %016llx phy%02d SATA device could not set linkrate (%d)\n",
+			       SAS_ADDR(child->sas_addr), phy_id, ret);
+			return ret;
+		}
+		pr_notice("ex %016llx phy%02d SATA device set linkrate successfully\n",
+			  SAS_ADDR(child->sas_addr), phy_id);
+		child->linkrate = child->min_linkrate;
+	}
+	ret = sas_get_ata_info(child, phy);
+	if (ret)
+		return ret;
+
+	sas_init_dev(child);
+	ret = sas_ata_init(child);
+	if (ret)
+		return ret;
+
+	rphy = sas_end_device_alloc(phy->port);
+	if (!rphy)
+		return ret;
+
+	rphy->identify.phy_identifier = phy_id;
+	child->rphy = rphy;
+	get_device(&rphy->dev);
+
+	list_add_tail(&child->disco_list_node, &parent->port->disco_list);
+
+	ret = sas_ata_notify_lldd_dev_found(child);
+	if (ret) {
+		pr_notice("notify lldd for device %16llx at %016llx:%02d returned 0x%x\n",
+			  SAS_ADDR(child->sas_addr),
+			  SAS_ADDR(parent->sas_addr), phy_id, ret);
+		sas_rphy_free(child->rphy);
+		list_del(&child->disco_list_node);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void sas_ata_flush_pm_eh(struct asd_sas_port *port, const char *func)
 {
 	struct domain_device *dev, *n;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 82ea7560a888..747f4fc795f4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -785,61 +785,11 @@ static struct domain_device *sas_ex_discover_end_dev(
 	sas_ex_get_linkrate(parent, child, phy);
 	sas_device_set_phy(child, phy->port);
 
-#ifdef CONFIG_SCSI_SAS_ATA
 	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
-		if (child->linkrate > parent->min_linkrate) {
-			struct sas_phy *cphy = child->phy;
-			enum sas_linkrate min_prate = cphy->minimum_linkrate,
-				parent_min_lrate = parent->min_linkrate,
-				min_linkrate = (min_prate > parent_min_lrate) ?
-					       parent_min_lrate : 0;
-			struct sas_phy_linkrates rates = {
-				.maximum_linkrate = parent->min_linkrate,
-				.minimum_linkrate = min_linkrate,
-			};
-			int ret;
-
-			pr_notice("ex %016llx phy%02d SATA device linkrate > min pathway connection rate, attempting to lower device linkrate\n",
-				   SAS_ADDR(child->sas_addr), phy_id);
-			ret = sas_smp_phy_control(parent, phy_id,
-						  PHY_FUNC_LINK_RESET, &rates);
-			if (ret) {
-				pr_err("ex %016llx phy%02d SATA device could not set linkrate (%d)\n",
-				       SAS_ADDR(child->sas_addr), phy_id, ret);
-				goto out_free;
-			}
-			pr_notice("ex %016llx phy%02d SATA device set linkrate successfully\n",
-				  SAS_ADDR(child->sas_addr), phy_id);
-			child->linkrate = child->min_linkrate;
-		}
-		res = sas_get_ata_info(child, phy);
-		if (res)
-			goto out_free;
-
-		sas_init_dev(child);
-		res = sas_ata_init(child);
+		res = sas_ata_add_dev(parent, phy, child, phy_id);
 		if (res)
 			goto out_free;
-		rphy = sas_end_device_alloc(phy->port);
-		if (!rphy)
-			goto out_free;
-		rphy->identify.phy_identifier = phy_id;
-
-		child->rphy = rphy;
-		get_device(&rphy->dev);
-
-		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
-
-		res = sas_ata_notify_lldd_dev_found(child);
-		if (res) {
-			pr_notice("notify lldd for device %16llx at %016llx:%02d returned 0x%x\n",
-				  SAS_ADDR(child->sas_addr),
-				  SAS_ADDR(parent->sas_addr), phy_id, res);
-			goto out_list_del;
-		}
-	} else
-#endif
-	  if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
+	} else if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
 		child->dev_type = SAS_END_DEVICE;
 		rphy = sas_end_device_alloc(phy->port);
 		/* FIXME: error handling */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index a3857595ba55..23a0853a5a0a 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -37,6 +37,8 @@ int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int smp_ata_check_ready_type(struct ata_link *link);
 int sas_ata_notify_lldd_dev_found(struct domain_device *dev);
+int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
+		    struct domain_device *child, int phy_id);
 #else
 
 
@@ -109,6 +111,13 @@ static inline int sas_ata_notify_lldd_dev_found(struct domain_device *dev)
 	pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
 	return -ENXIO;
 }
+static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
+				  struct domain_device *child, int phy_id)
+{
+	pr_notice("ATA is not enabled, target proto 0x%x at %016llx:0x%x\n",
+		  phy->attached_tproto, SAS_ADDR(parent->sas_addr), phy_id);
+	return -ENODEV;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.31.1

