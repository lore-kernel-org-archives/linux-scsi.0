Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A5EC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 08:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359516AbiFPICW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 04:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358853AbiFPICV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 04:02:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4E75D66B
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 01:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5iws/iIQWdnEWYYHAW3DfMD8oeL0ePrNZOhwKQGS1O3S1i0SnwpH123v5rjyqm58shw0RphkXRK0qcKID3h6wfEQBtgoRYabmCSQKmZe8YEFJHQ7gwzDCbxw1xtNUiuCf/bUsXO9lE2nz9DRVaGDcjGVgewBthPNQd0SzGJH8h6LODB5+yrkUKB2LMzo9krrKGCde0OfFVUf47MOKsBqGnR7vyJjhDHRnFQ2AeU/Lh5eG4arBtS0rusjp0Fdp5f8wZ5V60fs4PdcuJ2ZxfqHBLCq/FZWJ/Fn28XnjgzsxTivxJc5lPcTfneF49Vl/Jzkh+zpQQfO+sWgzCocp/rwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veqI/8px5DEBPpwJXGkPiU7eViLf3QiG+G3Bq9pAEZs=;
 b=oX+3xIOBIR98ETqHZXVixJ9s/ibL1zJtirfQ6ZHtN06DvupwjbSvArlWoP/LbmJwGfvVEqqakjOUOauKQIoq+PY9xl+5p+Lf6xZ0DYuUiA3Fnadp4U+S6eR3S9cib7yMchY7BS4/py3PmAtOzd+2yekhWE4zMnHRLw0fySZ6xHuVl4jYggtM9tPNEw+jXOP8J0NisAXxVxovLk6L4CQ7k/jcEtLKkl5iCwHXUzcZEqPDfuWR9A1yNvwruP2gIWJ8aRpsuvUKdR9VyfiGklgrXIRzydxyQMy4ZugXaeGDOIt6KGt/ftIOE+YMZrj8kshpI06RVxHzktBhhVvkLif7rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veqI/8px5DEBPpwJXGkPiU7eViLf3QiG+G3Bq9pAEZs=;
 b=F+zKwFkkc2HWYf3iiw/+3PHFBpBVG6pxs0J2XEiQwAQJL6zNrhYl8y7Sm8x1OcYy/KUWggqLuJSoSCif8nUf5DSClyrAoUHwX/6fMTG0ubOdBCqref96IRBQjcZHcJGRfIc8e4I8mRbdu4YmhU2EZaUHubxr/GFo18ndoWTWQ0T9zqRAfSCCriZYpCyu3UZk7LNSpR7YA6SAU0sRhWvW+1h+Ts+CCk5O6J1KS2zbrFtCWmtuguuc9aL1bFqGrDD0mHv5mZhR4O/T8MPoUwZFB4Dzu2lVTJRtz26JZBkSQXeOHiliwV6TyJLC/BQFrLRZMLVpMzt1QGYkr0rwq/E3CA==
Received: from DM3PR12CA0094.namprd12.prod.outlook.com (2603:10b6:0:55::14) by
 DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.14; Thu, 16 Jun 2022 08:02:14 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::fa) by DM3PR12CA0094.outlook.office365.com
 (2603:10b6:0:55::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Thu, 16 Jun 2022 08:02:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 08:02:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 16 Jun 2022 08:02:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 16 Jun 2022 01:02:12 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Thu, 16 Jun 2022 01:02:10 -0700
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <michael.christie@oracle.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] scsi: iscsi: Make iscsi_unregister_transport() return void
Date:   Thu, 16 Jun 2022 11:02:10 +0300
Message-ID: <20220616080210.18531-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef4151ac-e450-4a38-726c-08da4f6e8641
X-MS-TrafficTypeDiagnostic: DM6PR12MB4155:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB41557840867D1E5412C2817BDEAC9@DM6PR12MB4155.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PpziL56/S3C7e9BUjxsKIKZidJGV8O+2BoARiXLCVU6b2fUnuyu8cS77YlfNO5aw5dpMXUmm2abSbkmdugdSsqWNm8lUdFBIUGw0tbNpJfZuJbKxB3L5bV5+Zfpcjilwo5JlL4oFfGNU6hJtVIyUzjAcOdd0wi4kmr22SX4P1tx4QV1hbLCLg+0j0u1p7GGwLNOQ26qWKAkStAKSylsuryYh4q5dYitkTphvqUC74Rc2+6p2bH3DOf5CB3Uighz/WHNv9ZvARWBRWCeVyLvKI9jpbWM+Jq0hNEaJHgVxl658rWq09az4HWnj1IovVvDOK0EuIId2X0101aN+56vCVzCEVYXSjbiPK9LKUyyF8Ut9ALNjxRCSbQXeQtA1s798zBxW8EKd5/MtSv152IiJjrPBMDijbzihMpyvREkVV1Ke9hhP8uKquyUzzSQRKiO7R5WznoQ/DPOcxybWkBFNbu7sRUJgFKOGo58qY9CVzoQFHk2GBrP0b1L69zpdeQtOReINlVI56AZaSuDvBzBoRCNmgvORZW5pMpYUuE/yeDf26w0OBBLcAgFbCT8ryc/dJJlhYkIsyHpOTc3/bk8l4umWGdrNzokluu0SUxaNpKOVQmdbO9RDwk2Huxhly1rPwJ7wwFXJKX1CiX+U4e63QnM1MASXmrZFBVOwxcBfE0rFCu4e21ta8fUeyC0BtxNl+7T/TjEx1/r73rzA/5yR4w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(8936002)(508600001)(110136005)(356005)(4326008)(316002)(1076003)(40460700003)(54906003)(5660300002)(81166007)(8676002)(70206006)(70586007)(83380400001)(36860700001)(426003)(2616005)(47076005)(107886003)(86362001)(186003)(26005)(82310400005)(2906002)(36756003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 08:02:14.2373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4151ac-e450-4a38-726c-08da4f6e8641
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function always returns 0. We can make it return void to simplify
the code. Also, no caller ever checks the return value of this function.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +---
 include/scsi/scsi_transport_iscsi.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..5601633837cc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4807,7 +4807,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 }
 EXPORT_SYMBOL_GPL(iscsi_register_transport);
 
-int iscsi_unregister_transport(struct iscsi_transport *tt)
+void iscsi_unregister_transport(struct iscsi_transport *tt)
 {
 	struct iscsi_internal *priv;
 	unsigned long flags;
@@ -4830,8 +4830,6 @@ int iscsi_unregister_transport(struct iscsi_transport *tt)
 	sysfs_remove_group(&priv->dev.kobj, &iscsi_transport_group);
 	device_unregister(&priv->dev);
 	mutex_unlock(&rx_queue_mutex);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_unregister_transport);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 9acb8422f680..695396a5f607 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -162,7 +162,7 @@ struct iscsi_transport {
  * transport registration upcalls
  */
 extern struct scsi_transport_template *iscsi_register_transport(struct iscsi_transport *tt);
-extern int iscsi_unregister_transport(struct iscsi_transport *tt);
+extern void iscsi_unregister_transport(struct iscsi_transport *tt);
 
 /*
  * control plane upcalls
-- 
2.18.1

