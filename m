Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33867C77B75
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 09:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjDUJjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 05:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjDUJi4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 05:38:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9891AD0B
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2023 02:38:53 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q2q9t4wqtzSwJN;
        Fri, 21 Apr 2023 17:34:42 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 21 Apr
 2023 17:38:51 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 2/3] scsi: libsas: Remove an empty branch in sas_check_parent_topology()
Date:   Fri, 21 Apr 2023 17:37:43 +0800
Message-ID: <20230421093744.1583609-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421093744.1583609-1-yanaijie@huawei.com>
References: <20230421093744.1583609-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is an empty "All good" branch in sas_check_parent_topology(). We can
reverse the test statement and remove the empty branch.

Moreover, factor out a helper sas_check_edge_expander_topo() to make
the code more readable.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 56 ++++++++++++++++++------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index e6101a511cc7..1b4eb01d14ec 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1240,6 +1240,37 @@ static int sas_check_eeds(struct domain_device *child,
 	return res;
 }
 
+static int sas_check_edge_expander_topo(struct domain_device *child,
+					struct ex_phy *parent_phy)
+{
+	struct expander_device *child_ex = &child->ex_dev;
+	struct expander_device *parent_ex = &child->parent->ex_dev;
+	struct ex_phy *child_phy;
+
+	child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
+
+	if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		if (parent_phy->routing_attr != SUBTRACTIVE_ROUTING ||
+		    child_phy->routing_attr != TABLE_ROUTING)
+			goto error;
+	} else if (parent_phy->routing_attr == SUBTRACTIVE_ROUTING) {
+		if (child_phy->routing_attr == SUBTRACTIVE_ROUTING)
+			return sas_check_eeds(child, parent_phy, child_phy);
+		else if (child_phy->routing_attr != TABLE_ROUTING)
+			goto error;
+	} else if (parent_phy->routing_attr == TABLE_ROUTING) {
+		if (child_phy->routing_attr != SUBTRACTIVE_ROUTING &&
+		    (child_phy->routing_attr != TABLE_ROUTING ||
+		     !child_ex->t2t_supp || !parent_ex->t2t_supp))
+			goto error;
+	}
+
+	return 0;
+error:
+	sas_print_parent_topology_bug(child, parent_phy, child_phy);
+	return -ENODEV;
+}
+
 /* Here we spill over 80 columns.  It is intentional.
  */
 static int sas_check_parent_topology(struct domain_device *child)
@@ -1272,29 +1303,8 @@ static int sas_check_parent_topology(struct domain_device *child)
 
 		switch (child->parent->dev_type) {
 		case SAS_EDGE_EXPANDER_DEVICE:
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
-				if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||
-				    (child_phy->routing_attr == TABLE_ROUTING &&
-				     child_ex->t2t_supp && parent_ex->t2t_supp)) {
-					/* All good */;
-				} else {
-					sas_print_parent_topology_bug(child, parent_phy, child_phy);
-					res = -ENODEV;
-				}
-			}
+			if (sas_check_edge_expander_topo(child, parent_phy))
+				res = -ENODEV;
 			break;
 		case SAS_FANOUT_EXPANDER_DEVICE:
 			if (parent_phy->routing_attr != TABLE_ROUTING ||
-- 
2.31.1

