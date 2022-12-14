Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3861CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 13:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbiLNNRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 08:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiLNNR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 08:17:29 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E424B205D8
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 05:17:27 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NXG8q1CYWzlVmD;
        Wed, 14 Dec 2022 21:16:27 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 21:17:25 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 5/5] scsi: libsas: factor out sas_ex_add_dev()
Date:   Wed, 14 Dec 2022 21:38:08 +0800
Message-ID: <20221214133808.1649122-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221214133808.1649122-1-yanaijie@huawei.com>
References: <20221214133808.1649122-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out sas_ex_add_dev() to be consistent with sas_ata_add_dev() and
unify the error handling.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_expander.c | 68 +++++++++++++++++-------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0e4e09a0286a..dc670304f181 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -751,13 +751,46 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
 	child->pathways = min(child->pathways, parent->pathways);
 }
 
+static int sas_ex_add_dev(struct domain_device *parent, struct ex_phy *phy,
+			  struct domain_device *child, int phy_id)
+{
+	struct sas_rphy *rphy;
+	int res;
+
+	child->dev_type = SAS_END_DEVICE;
+	rphy = sas_end_device_alloc(phy->port);
+	if (!rphy)
+		return -ENOMEM;
+
+	child->tproto = phy->attached_tproto;
+	sas_init_dev(child);
+
+	child->rphy = rphy;
+	get_device(&rphy->dev);
+	rphy->identify.phy_identifier = phy_id;
+	sas_fill_in_rphy(child, rphy);
+
+	list_add_tail(&child->disco_list_node, &parent->port->disco_list);
+
+	res = sas_notify_lldd_dev_found(child);
+	if (res) {
+		pr_notice("notify lldd for device %016llx at %016llx:%02d returned 0x%x\n",
+			  SAS_ADDR(child->sas_addr),
+			  SAS_ADDR(parent->sas_addr), phy_id, res);
+		sas_rphy_free(child->rphy);
+		list_del(&child->disco_list_node);
+		return res;
+	}
+
+	return 0;
+}
+
 static struct domain_device *sas_ex_discover_end_dev(
 	struct domain_device *parent, int phy_id)
 {
 	struct expander_device *parent_ex = &parent->ex_dev;
 	struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
 	struct domain_device *child = NULL;
-	struct sas_rphy *rphy;
 	int res;
 
 	if (phy->attached_sata_host || phy->attached_sata_ps)
@@ -787,44 +820,21 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
 		res = sas_ata_add_dev(parent, phy, child, phy_id);
-		if (res)
-			goto out_free;
 	} else if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
-		child->dev_type = SAS_END_DEVICE;
-		rphy = sas_end_device_alloc(phy->port);
-		/* FIXME: error handling */
-		if (unlikely(!rphy))
-			goto out_free;
-		child->tproto = phy->attached_tproto;
-		sas_init_dev(child);
-
-		child->rphy = rphy;
-		get_device(&rphy->dev);
-		rphy->identify.phy_identifier = phy_id;
-		sas_fill_in_rphy(child, rphy);
-
-		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
-
-		res = sas_discover_end_dev(child);
-		if (res) {
-			pr_notice("sas_discover_end_dev() for device %016llx at %016llx:%02d returned 0x%x\n",
-				  SAS_ADDR(child->sas_addr),
-				  SAS_ADDR(parent->sas_addr), phy_id, res);
-			goto out_list_del;
-		}
+		res = sas_ex_add_dev(parent, phy, child, phy_id);
 	} else {
 		pr_notice("target proto 0x%x at %016llx:0x%x not handled\n",
 			  phy->attached_tproto, SAS_ADDR(parent->sas_addr),
 			  phy_id);
-		goto out_free;
+		res = -ENODEV;
 	}
 
+	if (res)
+		goto out_free;
+
 	list_add_tail(&child->siblings, &parent_ex->children);
 	return child;
 
- out_list_del:
-	sas_rphy_free(child->rphy);
-	list_del(&child->disco_list_node);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
-- 
2.31.1

