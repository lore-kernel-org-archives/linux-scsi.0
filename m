Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A225C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 17:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbiFMRXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 13:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbiFMRXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 13:23:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E3B33371
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 05:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPgbHG7USJyA7Hayg9s/yxrf9s3168OqJOFeB/BH0Mj7Oeqe3aQH9/jsAX6wMHZS9Resaf4X0951SgpmrEi0qoSbt7/WNSPnI3ob3PTtpcqNG56AgOHSE+Uva2B2FPTNA18zXDIQhxc7E8+YyCqcpxQTdKN4A4pOOT+oNu0BMWI4fbJvsG8uDVzhJdgi7Hb37XxWnZngdJzwzNbEPbzblQcL4mzUNJMl1fTBsRTazSS4pjDF1MY2i5nKTMMhgyGFFuOeCYDRwUIj+oYZqYrYjp7062vdMJREAB+yqJw7OtEOX2vpokFSDHIYng4Q5Pu6jAen9qlj+aO1TyBXre2wjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfHfwN8SF+UBgstKHQ+cEOqH6R+ZAnRgX/HwtgXBvzc=;
 b=Q67QG6naefv+OgEmeCuVmeZgtR3N+sE0FmoK0pxqAV1zTJp3FMQKpDMT4+tjYbxVIya+j5D/872Ih6bC1kt3+tXYGFnqw6T7enOcc/r8wn6ujFax+fTcoczYL1/VzgQZ5GvJDUzk2JAok/XFmABvEUM91pB0vOMJMfMTkikrjPK4X47ChyH4+z3CE/qXBrqWjgP3E4D+c7MAgpbwna8iz++I1FIhiG6go2oUQronsE7Z+hmUr2zIhzDh02jIaDa57XdCXKSJorqiSMLnCUHB8N9tbfXVNEOa3uoYv3xV8Mw8FBuXvimO+dOpI3XcOJaodRvtMAVya7B5z8BnLi2pmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=suse.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfHfwN8SF+UBgstKHQ+cEOqH6R+ZAnRgX/HwtgXBvzc=;
 b=gbJNjzKNnqsyypqH+s3a3nWS4+mBgqEqDlO+hZ8p12FR0u6tYVPdLdvo4Le0OSLmd4dlcCCrJWBD1rMSaS/oFrMjUfxfF9ryWZH+BXL9F+N6qJdMz4dTukHLU7zyu3iJ8d9pRA39uF71WIn2k8rye4DKKGEBOEtZF6ResPs+vHKj5IGjvI6kY7Ej4JU/WkiY4XtN4oVgrydrDhw5sLXdXNriOk4XV7XhL0JCyXVz8Y6lgRd0ygz+ATTuhtycBd0+osEWXGMCc/MhPV6xk9UbbNAUDvgo0RPEQOadWv2pTliV30TA0jFXS6Us7UeB5prR725y2KElOCJ6PAbNqb+EvQ==
Received: from DM6PR10CA0010.namprd10.prod.outlook.com (2603:10b6:5:60::23) by
 DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Mon, 13 Jun 2022 12:39:04 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::65) by DM6PR10CA0010.outlook.office365.com
 (2603:10b6:5:60::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15 via Frontend
 Transport; Mon, 13 Jun 2022 12:39:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 12:39:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 12:39:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 05:39:02 -0700
Received: from rsws38-eth1.mtr.labs.mlnx (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 05:39:00 -0700
From:   Sergey Gorenko <sergeygo@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>
CC:     <linux-scsi@vger.kernel.org>, Sergey Gorenko <sergeygo@nvidia.com>,
        "Max Gurtovoy" <mgurtovoy@nvidia.com>
Subject: [PATCH] scsi: iscsi: Exclude zero from the endpoint ID range
Date:   Mon, 13 Jun 2022 15:38:54 +0300
Message-ID: <20220613123854.55073-1-sergeygo@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b02d39e6-edf9-493c-66c4-08da4d39b341
X-MS-TrafficTypeDiagnostic: DM4PR12MB5230:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52306B09620E1D143ACEFF52BFAB9@DM4PR12MB5230.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdMdZmIuqfqH8SyJ02wkvjlHsA5aqed9Uk2BSXMQuiB3YiB6Floje6I7rxhe4tGE64ND8d6bX3GqqY9upe7hocrWTX5axqAy10yiQGfKgQZLzbsQ/tomws8+8yNy25v1ibfu8alBq9bRLqbRXQfMW84TSS1V7sCB1983dnRUfj6bRwprlxJ+B6m2WnSjUCPYbVMgThdRYtDXnHNLPk/mHBCEcwTwi9G6hhZn5qo8I8OJwmIAC0D9M04331Fv33B7oGaNmRETN5Cl5pa4wXAQ55UrzJuWIFmUoBQDoFja1ibEMk+OVBnrsJ+k58zKRNCwOkKqyTyhiqHxWWO5iTJWmpJc1lOCM7VEdASmVKBrnlsVQaJTROd9geM+5FHCw4V7u5+v3lNaCu/HVV2ypSIgFPwfmcUiU9/5FzxNLZiqcmRJZzgUfC/YQI1CiAfN4R3SdiyV8RKcjRyK8zqQD3V33U9p03KkQegTjdOtkM2VFMYEP97ooCmwP7YRidQnJxNurcVOzlfexzCzsljtjcvgyNqMJxJulOjR2BcppthEMJO/Y19dA1W/K9l3DPUO/POcjDPqVqQPk5JyawT/HkXeD/3KpXC9q0EITttRd2rYgdqQeRYxw1U8sCkmQ0CHqbGbSyt+k20KykynKloi6iscnq0Zs00yZ/UmeaPzP8kYolz6nigD/GPdDjTCgztXodLEIgUilDe4MP+GmqDfP5gMIg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(36756003)(186003)(40460700003)(81166007)(508600001)(8936002)(2906002)(5660300002)(356005)(110136005)(6666004)(86362001)(316002)(83380400001)(336012)(47076005)(426003)(26005)(4326008)(2616005)(8676002)(82310400005)(70586007)(70206006)(107886003)(54906003)(36860700001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 12:39:04.0979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b02d39e6-edf9-493c-66c4-08da4d39b341
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kernel returns an endpoint ID as r.ep_connect_ret.handle in the
iscsi_uevent. The iscsid validates a received endpoint ID and treats
zero as an error. The commit referenced in the fixes line changed the
endpoint ID range, and zero is always assigned to the first endpoint ID.
So, the first attempt to create a new iSER connection always fails.

Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Sergey Gorenko <sergeygo@nvidia.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..5d21f07456c6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -212,7 +212,12 @@ iscsi_create_endpoint(int dd_size)
 		return NULL;
 
 	mutex_lock(&iscsi_ep_idr_mutex);
-	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+
+	/*
+	 * First endpoint id should be 1 to comply with user space
+	 * applications (iscsid).
+	 */
+	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
 	if (id < 0) {
 		mutex_unlock(&iscsi_ep_idr_mutex);
 		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
-- 
2.34.1

