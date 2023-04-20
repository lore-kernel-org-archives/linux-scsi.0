Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2050C77B73
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Apr 2023 14:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjDTOep (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 10:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjDTOel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 10:34:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCAB40C0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 07:34:34 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q2Kny2VLBznd0m;
        Thu, 20 Apr 2023 22:30:46 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 20 Apr
 2023 22:34:31 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 3/3] scsi: libsas: Simplify sas_check_parent_topology()
Date:   Thu, 20 Apr 2023 22:33:39 +0800
Message-ID: <20230420143339.2769414-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230420143339.2769414-1-yanaijie@huawei.com>
References: <20230420143339.2769414-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
 drivers/scsi/libsas/sas_expander.c | 94 +++++++++++++++++-------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index bbf73e74530e..be8171f39de3 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1239,11 +1239,58 @@ static int sas_check_eeds(struct domain_device *child,
 	return res;
 }
 
-/* Here we spill over 80 columns.  It is intentional.
- */
-static int sas_check_parent_topology(struct domain_device *child)
+static int sas_check_phy_topology(struct domain_device *child,
+				  struct ex_phy *parent_phy)
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
+			} else if (child_phy->routing_attr != TABLE_ROUTING) {
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
@@ -1258,7 +1305,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 
 	for (i = 0; i < parent_ex->num_phys; i++) {
 		struct ex_phy *parent_phy = &parent_ex->ex_phy[i];
-		struct ex_phy *child_phy;
+		int ret;
 
 		if (parent_phy->phy_state == PHY_VACANT ||
 		    parent_phy->phy_state == PHY_NOT_PRESENT)
@@ -1267,42 +1314,9 @@ static int sas_check_parent_topology(struct domain_device *child)
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

