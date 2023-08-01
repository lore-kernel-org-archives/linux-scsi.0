Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BA0EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 08:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjHAI6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 04:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjHAI6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 04:58:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185941BD9
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 01:58:35 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RFTTy6mlKzLp1Y;
        Tue,  1 Aug 2023 16:55:50 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.202) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 16:58:32 +0800
From:   Zhu Wang <wangzhu9@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <James.Bottomley@HansenPartnership.com>, <kay.sievers@vrfy.org>,
        <gregkh@suse.de>, <linux-scsi@vger.kernel.org>
CC:     <wangzhu9@huawei.com>
Subject: [PATCH -next] scsi: scsi_transport_sas: fix error handling for dev_set_name
Date:   Tue, 1 Aug 2023 16:58:02 +0800
Message-ID: <20230801085802.227530-1-wangzhu9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.202]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver do not handle the possible returning error of dev_set_name,
if it returned fail, some operations should be rollback or there may be
possible memory leak. For example, we use put_device to free the device
and use kfree to free the memory in the error handle path.

Fixes: 71610f55fa4d ("[SCSI] struct device - replace bus_id with dev_name(), dev_set_name()")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
---
 drivers/scsi/scsi_transport_sas.c | 58 +++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d704c484a251..1eb5d679a334 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -686,6 +686,7 @@ struct sas_phy *sas_phy_alloc(struct device *parent, int number)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct sas_phy *phy;
+	int rc;
 
 	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
 	if (!phy)
@@ -700,10 +701,16 @@ struct sas_phy *sas_phy_alloc(struct device *parent, int number)
 	INIT_LIST_HEAD(&phy->port_siblings);
 	if (scsi_is_sas_expander_device(parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent);
-		dev_set_name(&phy->dev, "phy-%d:%d:%d", shost->host_no,
-			rphy->scsi_target_id, number);
+		rc = dev_set_name(&phy->dev, "phy-%d:%d:%d", shost->host_no,
+				  rphy->scsi_target_id, number);
 	} else
-		dev_set_name(&phy->dev, "phy-%d:%d", shost->host_no, number);
+		rc = dev_set_name(&phy->dev, "phy-%d:%d", shost->host_no, number);
+
+	if (rc) {
+		put_device(&phy->dev);
+		kfree(phy);
+		return NULL;
+	}
 
 	transport_setup_device(&phy->dev);
 
@@ -880,6 +887,7 @@ struct sas_port *sas_port_alloc(struct device *parent, int port_id)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct sas_port *port;
+	int rc;
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
@@ -897,11 +905,17 @@ struct sas_port *sas_port_alloc(struct device *parent, int port_id)
 
 	if (scsi_is_sas_expander_device(parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent);
-		dev_set_name(&port->dev, "port-%d:%d:%d", shost->host_no,
-			     rphy->scsi_target_id, port->port_identifier);
+		rc = dev_set_name(&port->dev, "port-%d:%d:%d", shost->host_no,
+				  rphy->scsi_target_id, port->port_identifier);
 	} else
-		dev_set_name(&port->dev, "port-%d:%d", shost->host_no,
-			     port->port_identifier);
+		rc = dev_set_name(&port->dev, "port-%d:%d", shost->host_no,
+				  port->port_identifier);
+
+	if (rc) {
+		put_device(&port->dev);
+		kfree(port);
+		return NULL;
+	}
 
 	transport_setup_device(&port->dev);
 
@@ -1439,6 +1453,7 @@ struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
 {
 	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
 	struct sas_end_device *rdev;
+	int rc;
 
 	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
@@ -1450,12 +1465,18 @@ struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
 	rdev->rphy.dev.release = sas_end_device_release;
 	if (scsi_is_sas_expander_device(parent->dev.parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent->dev.parent);
-		dev_set_name(&rdev->rphy.dev, "end_device-%d:%d:%d",
-			     shost->host_no, rphy->scsi_target_id,
-			     parent->port_identifier);
+		rc = dev_set_name(&rdev->rphy.dev, "end_device-%d:%d:%d",
+				  shost->host_no, rphy->scsi_target_id,
+				  parent->port_identifier);
+
 	} else
-		dev_set_name(&rdev->rphy.dev, "end_device-%d:%d",
-			     shost->host_no, parent->port_identifier);
+		rc = dev_set_name(&rdev->rphy.dev, "end_device-%d:%d",
+				  shost->host_no, parent->port_identifier);
+	if (rc) {
+		put_device(&rdev->rphy.dev);
+		kfree(rdev);
+		return NULL;
+	}
 	rdev->rphy.identify.device_type = SAS_END_DEVICE;
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
@@ -1480,6 +1501,7 @@ struct sas_rphy *sas_expander_alloc(struct sas_port *parent,
 	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
 	struct sas_expander_device *rdev;
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	int rc;
 
 	BUG_ON(type != SAS_EDGE_EXPANDER_DEVICE &&
 	       type != SAS_FANOUT_EXPANDER_DEVICE);
@@ -1495,8 +1517,16 @@ struct sas_rphy *sas_expander_alloc(struct sas_port *parent,
 	mutex_lock(&sas_host->lock);
 	rdev->rphy.scsi_target_id = sas_host->next_expander_id++;
 	mutex_unlock(&sas_host->lock);
-	dev_set_name(&rdev->rphy.dev, "expander-%d:%d",
-		     shost->host_no, rdev->rphy.scsi_target_id);
+	rc = dev_set_name(&rdev->rphy.dev, "expander-%d:%d",
+			  shost->host_no, rdev->rphy.scsi_target_id);
+	if (rc) {
+		put_device(&rdev->rphy.dev);
+		kfree(rdev);
+		mutex_lock(&sas_host->lock);
+		sas_host->next_expander_id--;
+		mutex_unlock(&sas_host->lock);
+		return NULL;
+	}
 	rdev->rphy.identify.device_type = type;
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
-- 
2.17.1

