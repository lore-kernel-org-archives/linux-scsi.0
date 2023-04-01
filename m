Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6664EC77B6D
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Apr 2023 08:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbjDAIQE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Apr 2023 04:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbjDAIQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Apr 2023 04:16:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DACFAD0C
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 01:16:00 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PpVJR0YZlz17LsY;
        Sat,  1 Apr 2023 16:12:39 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Sat, 1 Apr
 2023 16:15:57 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 3/3] scsi: libsas: Simplify sas_check_parent_topology()
Date:   Sat, 1 Apr 2023 16:15:26 +0800
Message-ID: <20230401081526.1655279-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230401081526.1655279-1-yanaijie@huawei.com>
References: <20230401081526.1655279-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out a new helper sas_check_phy_topology() to simplify
sas_check_parent_topology(). And centralize the calling of
sas_print_parent_topology_bug().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 95 +++++++++++++++++-------------
 1 file changed, 55 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c0841652f0e0..bffcccdbda6b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1238,11 +1238,59 @@ static int sas_check_eeds(struct domain_device *child,
 	return res;
 }
 
-/* Here we spill over 80 columns.  It is intentional.
- */
-static int sas_check_parent_topology(struct domain_device *child)
+
+static int sas_check_phy_topology(struct domain_device *child, struct ex_phy *parent_phy)
 {
 	struct expander_device *child_ex = &child->ex_dev;
+	struct ex_phy *child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
+	struct expander_device *parent_ex = &child->parent->ex_dev;
+	bool print_topology_bug = false;
+	int res = 0;
+
+	switch (child->parent->dev_type) {
+	case SAS_EDGE_EXPANDER_DEVICE:
+		if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+			if (parent_phy->routing_attr != SUBTRACTIVE_ROUTING ||
+				child_phy->routing_attr != TABLE_ROUTING) {
+				res = -ENODEV;
+				print_topology_bug = true;
+			}
+		} else if (parent_phy->routing_attr == SUBTRACTIVE_ROUTING) {
+			if (child_phy->routing_attr == SUBTRACTIVE_ROUTING) {
+				res = sas_check_eeds(child, parent_phy, child_phy);
+			}
+			else if (child_phy->routing_attr != TABLE_ROUTING) {
+				res = -ENODEV;
+				print_topology_bug = true;
+			}
+		} else if (parent_phy->routing_attr == TABLE_ROUTING) {
+			if (child_phy->routing_attr != SUBTRACTIVE_ROUTING &&
+			    (child_phy->routing_attr != TABLE_ROUTING ||
+			    !child_ex->t2t_supp || !parent_ex->t2t_supp)) {
+				res = -ENODEV;
+				print_topology_bug = true;
+			}
+		}
+		break;
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		if (parent_phy->routing_attr != TABLE_ROUTING ||
+		    child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
+			res = -ENODEV;
+			print_topology_bug = true;
+		}
+		break;
+	default:
+		break;
+	}
+
+	if (print_topology_bug)
+		sas_print_parent_topology_bug(child, parent_phy, child_phy);
+
+	return res;
+}
+
+static int sas_check_parent_topology(struct domain_device *child)
+{
 	struct expander_device *parent_ex;
 	int i;
 	int res = 0;
@@ -1257,7 +1305,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 
 	for (i = 0; i < parent_ex->num_phys; i++) {
 		struct ex_phy *parent_phy = &parent_ex->ex_phy[i];
-		struct ex_phy *child_phy;
+		int ret;
 
 		if (parent_phy->phy_state == PHY_VACANT ||
 		    parent_phy->phy_state == PHY_NOT_PRESENT)
@@ -1266,42 +1314,9 @@ static int sas_check_parent_topology(struct domain_device *child)
 		if (!sas_phy_match_dev_addr(child, parent_phy))
 			continue;
 
-		child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
-
-		switch (child->parent->dev_type) {
-		case SAS_EDGE_EXPANDER_DEVICE:
-			if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
-				if (parent_phy->routing_attr != SUBTRACTIVE_ROUTING ||
-				    child_phy->routing_attr != TABLE_ROUTING) {
-					sas_print_parent_topology_bug(child, parent_phy, child_phy);
-					res = -ENODEV;
-				}
-			} else if (parent_phy->routing_attr == SUBTRACTIVE_ROUTING) {
-				if (child_phy->routing_attr == SUBTRACTIVE_ROUTING) {
-					res = sas_check_eeds(child, parent_phy, child_phy);
-				} else if (child_phy->routing_attr != TABLE_ROUTING) {
-					sas_print_parent_topology_bug(child, parent_phy, child_phy);
-					res = -ENODEV;
-				}
-			} else if (parent_phy->routing_attr == TABLE_ROUTING) {
-				if (child_phy->routing_attr != SUBTRACTIVE_ROUTING &&
-				    (child_phy->routing_attr != TABLE_ROUTING ||
-				     !child_ex->t2t_supp || !parent_ex->t2t_supp)) {
-					sas_print_parent_topology_bug(child, parent_phy, child_phy);
-					res = -ENODEV;
-				}
-			}
-			break;
-		case SAS_FANOUT_EXPANDER_DEVICE:
-			if (parent_phy->routing_attr != TABLE_ROUTING ||
-			    child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
-				sas_print_parent_topology_bug(child, parent_phy, child_phy);
-				res = -ENODEV;
-			}
-			break;
-		default:
-			break;
-		}
+		ret = sas_check_phy_topology(child, parent_phy);
+		if (ret)
+			res = ret;
 	}
 
 	return res;
-- 
2.31.1

