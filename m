Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8552BFA373E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 09:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiJYJt7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 05:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiJYJsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 05:48:36 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70A1136423;
        Tue, 25 Oct 2022 02:48:20 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MxRsY5jf1z6H72c;
        Tue, 25 Oct 2022 17:46:25 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Tue, 25 Oct 2022 11:48:18 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 10:48:14 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <jinpu.wang@cloud.ionos.com>, <hare@suse.de>, <bvanassche@acm.org>,
        <hch@lst.de>, <ming.lei@redhat.com>, <niklas.cassel@wdc.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v3 06/22] scsi: libsas: Improve sas_ex_discover_expander() error handling
Date:   Tue, 25 Oct 2022 18:18:00 +0800
Message-ID: <1666693096-180008-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Errors in function sas_ex_discover_expander() are generally ignored, so add
handling to gracefully handles errors in all cases.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 50 ++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 2907ca5d0ed4..9e33014ec412 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -919,7 +919,6 @@ static struct domain_device *sas_ex_discover_expander(
 	struct sas_rphy *rphy;
 	struct sas_expander_device *edev;
 	struct asd_sas_port *port;
-	int res;
 
 	if (phy->routing_attr == DIRECT_ROUTING) {
 		pr_warn("ex %016llx:%02d:D <--> ex %016llx:0x%x is not allowed\n",
@@ -933,9 +932,11 @@ static struct domain_device *sas_ex_discover_expander(
 		return NULL;
 
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (!phy->port)
+		goto err_put_child;
 
+	if (!sas_port_add(phy->port))
+		goto err_delete_port;
 
 	switch (phy->attached_dev_type) {
 	case SAS_EDGE_EXPANDER_DEVICE:
@@ -948,8 +949,15 @@ static struct domain_device *sas_ex_discover_expander(
 		break;
 	default:
 		rphy = NULL;	/* shut gcc up */
-		BUG();
+		pr_warn("ex unhandled dev type %d %016llx:%02d:D <--> ex %016llx:%02d\n",
+			phy->attached_dev_type,
+			SAS_ADDR(parent->sas_addr), phy_id,
+			SAS_ADDR(phy->attached_sas_addr),
+			phy->attached_phy_id);
 	}
+	if (!rphy)
+		goto err_free_port;
+
 	port = parent->port;
 	child->rphy = rphy;
 	get_device(&rphy->dev);
@@ -967,26 +975,36 @@ static struct domain_device *sas_ex_discover_expander(
 	parent->port->disc.max_level = max(parent->port->disc.max_level,
 					   edev->level);
 	sas_init_dev(child);
+
 	sas_fill_in_rphy(child, rphy);
-	sas_rphy_add(rphy);
+	if (!sas_rphy_add(rphy))
+		goto err_rphy_free;
 
 	spin_lock_irq(&parent->port->dev_list_lock);
 	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
 	spin_unlock_irq(&parent->port->dev_list_lock);
 
-	res = sas_discover_expander(child);
-	if (res) {
-		sas_rphy_delete(rphy);
-		spin_lock_irq(&parent->port->dev_list_lock);
-		list_del(&child->dev_list_node);
-		spin_unlock_irq(&parent->port->dev_list_lock);
-		sas_put_device(child);
-		sas_port_delete(phy->port);
-		phy->port = NULL;
-		return NULL;
-	}
+	if (!sas_discover_expander(child))
+		goto err_rphy_remove;
+
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
 	return child;
+
+err_rphy_remove:
+	spin_lock_irq(&parent->port->dev_list_lock);
+	list_del(&child->dev_list_node);
+	spin_unlock_irq(&parent->port->dev_list_lock);
+	sas_rphy_remove(rphy);
+err_rphy_free:
+	sas_rphy_free(rphy);
+err_free_port:
+	sas_port_free(phy->port);
+err_delete_port:
+	sas_port_delete(phy->port);
+	phy->port = NULL;
+err_put_child:
+	sas_put_device(child);
+	return NULL;
 }
 
 static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
-- 
2.35.3

