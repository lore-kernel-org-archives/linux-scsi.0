Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01633C43461
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D05F861361
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbhDCXYV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44912 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbhDCXYM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NMvI8099207;
        Sat, 3 Apr 2021 23:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3xOHOUuhPkAQK4C0JJbxkL4699iVaCfBhQgHUG+G2eI=;
 b=rEeWHWILr46Rtq7FGT3SRxb9HKf+NEggiDHr0bNKaZJ1skgUWIsOI0KFTXswp1fu+pfF
 tT4ETtYdebykueW+udhYLkp8FuHpKVLBG8AV5oMg8oGQKFjfKoYPYI8vhtKfeY+c3TDf
 IEEKK9jUxAQQCibp4qnXzfHoVUmabiRnGIWC43HFO1smhsqhMpcVmIJWd3TbggXIGxFz
 2xYOsO7DqxR3vMP8SRACNfAM4atzERe8wp0IziwstQU5u0Q085bQ5abBfeu64c+j3HQg
 ZYtbQXvfyhOSP9OAP/TH0gU/Ta0uqLW8QGv/bso0UrHPqvN5+A7PJ33UkeZuGylyN8og JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKDHO132673;
        Sat, 3 Apr 2021 23:24:01 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2052.outbound.protection.outlook.com [104.47.45.52])
        by aserp3030.oracle.com with ESMTP id 37q1xk81k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJUq4FQYZBG8A89P2OsY97HPciJPqfbNR+VheWJsuZIpqnr9pVrEIiO3dKDZ5d2bd+GpiyUwOrPDajwK52WktqgNLidsAiNZS83Bv6UWC+9QuWciQl++K2E/LyZsqkW6E8hn/5xxqTcQS1NK+YYCfrbKH4DsOVpDRn7LDcsQQhgHrLLE/hx0DcjaWXmHqhBxfYNxAfpJ4fNkiI9cOEkBh+E9y0RxuiO9qNSPC7/FYrFxgxQVg+gn6flOp6kAbEvxvMX8kyLpmoEvnQ5Fk68OlEPpR7NxtWMiAtqPjhJY5Cj/wxzGF87kCheWdE+fMllP88HXfRXQPJXmdamd7R834g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xOHOUuhPkAQK4C0JJbxkL4699iVaCfBhQgHUG+G2eI=;
 b=ggkgpajEwJhKoj7gxmKu2RCJV8FMfNCFdkbRwQLVD0dZct/ezVDSycjHit90kIqOpruuHNeFTNMoY+ysNtzNHb2rN59Bfb1NIC1jbDNKpkPVzRRnfHfupyCDBqJL5uaB9DIVBv9HK0Ngs8V5hH/xP2RSnkvLCU9jxOk3X0Fz8BZc6549aOzsnIdk9Zw8A6PluklbLCZT53QWN0uefLPR5nZ0b9O3UZvaREkcV7CV2UnYOy4DVSdQHquShY2kuHkcjfbgNAoxyorpQ9gFf9Bug4KJTgA5ZURiVzSl9+O60G83a4vyJMxkZYCkbyXWYz9ASq9Y3PeJkj1ycycytnLQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xOHOUuhPkAQK4C0JJbxkL4699iVaCfBhQgHUG+G2eI=;
 b=u4M+nFozV6OmY7bJ1f+zT+8pYuXmtoj1e3h/MYn8MB7ElpHMflGn1Q1PVxUXC0DyOnEGuwH/2s03IhmPVX3BVVvWCWfK4c6aoRnuWu3rmlgUhtrc/c8GNi9RK6m7zPLfyUATtxARL26xRo3kZaRqXtQl0HuxX/KP67O+MWmiEog=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/40] scsi: iscsi_tcp, libcxgbi: use init_cmd_priv/exit_cmd_priv
Date:   Sat,  3 Apr 2021 18:23:04 -0500
Message-Id: <20210403232333.212927-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9893e3b8-da7f-4413-396c-08d8f6f78ed3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526D2E02ABFE0120E56F6D3F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUp2QKoY6eBE7YcyrEblbQ6pWj3BekZv1rUmDxNjvntGj0ufsZqvvyN4kJ2YjRAHvZ6Bg/4dXjVMXaIO0MuRvtn3ZKiHvwnwW6gEH91KgdY2OSaNo1nsrzOJAQv8+pBwqAai5a447CikdlNQTdPqfOhT9d+pqpB8+GYlGi0QZuZDxlXQEqr0UmBklxt4JOFa7SiaRs2ciQeYPq5mWwakhE0JwJR6EVljyjO3b+Y6e1BgC/S/xx8/CL7vUD1LObebfvMruCLr3pShyovjlV0ytCDlhe/pulRB3PTyrXeI0q4amZwOgJOxFWjMh0pVFPdVIH0uCQBQcp2tnXucB0n6tcGkhQ6uCZs6NmwJLeEbASAf3xOLZU5sZUFHQJu5XBi9qijzDMv+SCEi5y1LVJ9Z/PVNIrkmlK7LsjWiIsE6BWxGiTy0qbfSSypfNKJHDnqxlDTCbblDIYjD7Rfh/ep6l17AP41cT54aiaocvmgT87hgQ4aM56r7B9AoZBk7dCu0Vxssui2iy3xF7WrzhoqGRmWBnXy2hxRJVMZ1IZG44W+LdlNyjx9cB4vtgjvnj0EFpX5GvVIeyLDmlcgo+ZJ7iigyqRVBPmetI6pLii43XQ/Hk0b7/jvDeGAX47nKctsD61uPPaXPAz5nALfD/NBY0zhDFXEbHjYVTg8W2pVi+0u+mZUjrKW3z46vRh7y8pX45zgez/tmyXwqeGBTXCGIOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UWfO5pXX1tgV5jdPrptxwAPU/XsLfmmLx7MYn6LANg80198YmOlHA7hjZwZm?=
 =?us-ascii?Q?qIKiiRhC9z0JfO8FJPPsZ4STP81ncq3fr3UL7emB69IwAYwTgoghvyV8y44G?=
 =?us-ascii?Q?D9PZ65oinf+QknZSZfaWG7+wWNk0GNImIebFsKOyuez75w6E/DNDEOcTL0e5?=
 =?us-ascii?Q?BrJTuRxxtV0yDhQ2cJj8QAf3atf4Sh4UWa8Bu3ThTqzwYSRMcxja73Z+YZ37?=
 =?us-ascii?Q?o7gbusvCPVj/uTIak0xrWaBpmhjCEN5bc+Bj5ZJEpvrqjrBtMsiLAPLdbhh4?=
 =?us-ascii?Q?1BcaR4uRhAx91exZwZMfFgrrCQZ5KVIHV3edc/a32Lz6Jp5oJ2dz8gHex9sf?=
 =?us-ascii?Q?HRqdB/vYR9TyywL0GBC9+BtJmISKnoJ/UNgynDlXJsm1EvXpbmd4//KJYJ2i?=
 =?us-ascii?Q?tmQYmIdDNkZJn3RNVGHcebZboOvJG9gA35IOcaIm+VmethNvV8WNFZJQLOQG?=
 =?us-ascii?Q?FWpiQ9g3FAmewxVCB7/1FUr949lU8y66zmcIcCzdx3yF14UCDut69IY/6+vn?=
 =?us-ascii?Q?jplRIj6c/9feOv9qlCzR67+x0BQvYMQMaibHB17VqZWMW41Y4DZNsDVL0M3w?=
 =?us-ascii?Q?RT7TwnSQ9BDGdtjIV1HT6jXNL6ygwZtsXxdv5xXH9NAQI28C7Q8o2pg7kp3B?=
 =?us-ascii?Q?DJacQHX7l7RMGitFXXQEUIP0yDtrsckQBPeQWMd1aZjS1JA38u7YbHnZFQAT?=
 =?us-ascii?Q?HsRtjDzfV4pILT/joSTgWkwzyi4QAc5aRgxEsQERTZMksapUW1zvpazhapr3?=
 =?us-ascii?Q?1AHhGY20kbV+9KqDAnIgAIhR2zNGjT4MgB4UCGB5tSzmUpALD24wbK4P7ZTj?=
 =?us-ascii?Q?cCMAIfL4EczcfGgqivhin2Wa6hH8cj6sQ1sP8upGhBZyA8azPc0TdX4rVYJF?=
 =?us-ascii?Q?wyxSv7o70FeSmHAyGMq3p3I9Zz/3Zl6Q5Mc/sO2K+2CXgGFxS8KjQOrwpml1?=
 =?us-ascii?Q?a4PsCQXkjV0KYen59h7XWfYhrxazgCcE/zA6f6EGcI0VB5Xdyak963tYVR61?=
 =?us-ascii?Q?XKtBeCRSdtOmjGGyNS1AZ/LJKEz9VLhcXTp1/ECcF20EfbShHv2xoWK+qSCP?=
 =?us-ascii?Q?PjOshy+5WViWbl5xv9XwClTqt0UtZlZp56uiXl3le1eznnZL/04UyvhQ7j9Z?=
 =?us-ascii?Q?2cK4Fxx5FAwTp3ZNb/LnEOMiudNRJUREaUxh2fp7lEz+pGIr2VvfCe+SS9F5?=
 =?us-ascii?Q?ywIEe0vXjz2Sr7ifItPiFdM+7/03K6blgIUgMj7e7QCuOX1j7LUfFEfvycLf?=
 =?us-ascii?Q?Wr/xsNDPy4zeR7LAPT0l6lFbPAlpkEnvKknsoH5zzOUPGHOGGw4JNLdcD4oW?=
 =?us-ascii?Q?ghXf7x4SnFrPUZIz7eydf602?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9893e3b8-da7f-4413-396c-08d8f6f78ed3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:58.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qggGNS9nuJS9VcSlQwNF74GnJV70SVvpOmC1W5bIRo2UPE71MXRB0KsutUeLCDXs8xHP9x1UUYkOd04Wf66duSlrBdaWHC5KSzYJmbRRps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: g0bpVOH8LDqRJaF-hNjUpSF9IUhzNVol
X-Proofpoint-ORIG-GUID: g0bpVOH8LDqRJaF-hNjUpSF9IUhzNVol
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implemet init_cmd_priv/exit_cmd_priv/cmd_size to have the block layer
allocate the iscsi structs for the driver

Note: Because for cxgbi we do not have access to the specific session we
are creating cmds for, all sessions get the max of what is on the host but
this is normally going to one so it should not be any different.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   5 ++
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   5 ++
 drivers/scsi/cxgbi/libcxgbi.c      |  10 ---
 drivers/scsi/iscsi_tcp.c           |  11 ++--
 drivers/scsi/libiscsi_tcp.c        | 102 +++++++++++++++--------------
 include/scsi/libiscsi_tcp.h        |   5 +-
 6 files changed, 72 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 37d99357120f..d45babca253a 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -98,6 +98,11 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.dma_boundary	= PAGE_SIZE - 1,
 	.this_id	= -1,
 	.track_queue_depth = 1,
+	.cmd_size	= sizeof(struct iscsi_tcp_task) +
+			  sizeof(struct cxgbi_task_data) +
+			  sizeof(struct iscsi_task),
+	.init_cmd_priv	= iscsi_tcp_init_cmd_priv,
+	.exit_cmd_priv	= iscsi_tcp_exit_cmd_priv,
 };
 
 static struct iscsi_transport cxgb3i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2c3491528d42..d6647fa04851 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -116,6 +116,11 @@ static struct scsi_host_template cxgb4i_host_template = {
 	.dma_boundary	= PAGE_SIZE - 1,
 	.this_id	= -1,
 	.track_queue_depth = 1,
+	.cmd_size	= sizeof(struct iscsi_tcp_task) +
+			  sizeof(struct cxgbi_task_data) +
+			  sizeof(struct iscsi_task),
+	.init_cmd_priv	= iscsi_tcp_init_cmd_priv,
+	.exit_cmd_priv	= iscsi_tcp_exit_cmd_priv,
 };
 
 static struct iscsi_transport cxgb4i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index ecb134b4699f..919451810018 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2727,7 +2727,6 @@ struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *ep,
 	struct cxgbi_hba *chba;
 	struct Scsi_Host *shost;
 	struct iscsi_cls_session *cls_session;
-	struct iscsi_session *session;
 
 	if (!ep) {
 		pr_err("missing endpoint.\n");
@@ -2748,17 +2747,9 @@ struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *ep,
 	if (!cls_session)
 		return NULL;
 
-	session = cls_session->dd_data;
-	if (iscsi_tcp_r2tpool_alloc(session))
-		goto remove_session;
-
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"ep 0x%p, cls sess 0x%p.\n", ep, cls_session);
 	return cls_session;
-
-remove_session:
-	iscsi_session_teardown(cls_session);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(cxgbi_create_session);
 
@@ -2767,7 +2758,6 @@ void cxgbi_destroy_session(struct iscsi_cls_session *cls_session)
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"cls sess 0x%p.\n", cls_session);
 
-	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 }
 EXPORT_SYMBOL_GPL(cxgbi_destroy_session);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dd33ce0e3737..eff5f8456ced 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -883,13 +883,8 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	session = cls_session->dd_data;
 	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
-
-	if (iscsi_tcp_r2tpool_alloc(session))
-		goto remove_session;
 	return cls_session;
 
-remove_session:
-	iscsi_session_teardown(cls_session);
 remove_host:
 	iscsi_host_remove(shost);
 free_host:
@@ -905,7 +900,6 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
-	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 
 	iscsi_host_remove(shost);
@@ -1000,6 +994,11 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_tcp_task) +
+				  sizeof(struct iscsi_sw_tcp_hdrbuf) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= iscsi_tcp_init_cmd_priv,
+	.exit_cmd_priv		= iscsi_tcp_exit_cmd_priv,
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e9ffe3d1a55..73d4fe20ba9d 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1147,68 +1147,75 @@ void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_teardown);
 
-int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session)
+static int iscsi_tcp_calc_max_r2t(struct device *dev, void *data)
 {
-	int i;
-	int cmd_i;
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
+	int *max_r2t = data;
 
-	/*
-	 * initialize per-task: R2T pool and xmit queue
-	 */
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-	        struct iscsi_task *task = session->cmds[cmd_i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
+	if (!iscsi_is_session_dev(dev))
+		return 0;
 
-		/*
-		 * pre-allocated x2 as much r2ts to handle race when
-		 * target acks DataOut faster than we data_xmit() queues
-		 * could replenish r2tqueue.
-		 */
+	cls_session = iscsi_dev_to_session(dev);
+	session = cls_session->dd_data;
+	if (session->max_r2t > *max_r2t)
+		*max_r2t = session->max_r2t;
+	return 0;
+}
 
-		/* R2T pool */
-		if (iscsi_pool_init(&tcp_task->r2tpool,
-				    session->max_r2t * 2, NULL,
-				    sizeof(struct iscsi_r2t_info))) {
-			goto r2t_alloc_fail;
-		}
+int iscsi_tcp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	struct iscsi_task *task;
+	struct iscsi_tcp_task *tcp_task;
+	int max_r2t = 1;
 
-		/* R2T xmit queue */
-		if (kfifo_alloc(&tcp_task->r2tqueue,
-		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL)) {
-			iscsi_pool_free(&tcp_task->r2tpool);
-			goto r2t_alloc_fail;
-		}
-		spin_lock_init(&tcp_task->pool2queue);
-		spin_lock_init(&tcp_task->queue2pool);
-	}
+	iscsi_init_cmd_priv(shost, sc);
 
-	return 0;
+	/*
+	 * cxgbi does not have access to the session so we use the max of all
+	 * sessions on the host.
+	 */
+	device_for_each_child(&shost->shost_gendev, &max_r2t,
+			      iscsi_tcp_calc_max_r2t);
 
-r2t_alloc_fail:
-	for (i = 0; i < cmd_i; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
+	task = scsi_cmd_priv(sc);
+	tcp_task = task->dd_data;
 
-		kfifo_free(&tcp_task->r2tqueue);
+	/*
+	 * pre-allocated x2 as much r2ts to handle race when
+	 * target acks DataOut faster than we data_xmit() queues
+	 * could replenish r2tqueue.
+	 */
+	if (iscsi_pool_init(&tcp_task->r2tpool, max_r2t * 2, NULL,
+			    sizeof(struct iscsi_r2t_info)))
+		return -ENOMEM;
+
+	/* R2T xmit queue */
+	if (kfifo_alloc(&tcp_task->r2tqueue, max_r2t * 4 * sizeof(void *),
+			GFP_KERNEL)) {
 		iscsi_pool_free(&tcp_task->r2tpool);
+		goto r2t_queue_alloc_fail;
 	}
+	spin_lock_init(&tcp_task->pool2queue);
+	spin_lock_init(&tcp_task->queue2pool);
+	return 0;
+
+r2t_queue_alloc_fail:
+	iscsi_pool_free(&tcp_task->r2tpool);
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(iscsi_tcp_r2tpool_alloc);
+EXPORT_SYMBOL_GPL(iscsi_tcp_init_cmd_priv);
 
-void iscsi_tcp_r2tpool_free(struct iscsi_session *session)
+int iscsi_tcp_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		kfifo_free(&tcp_task->r2tqueue);
-		iscsi_pool_free(&tcp_task->r2tpool);
-	}
+	kfifo_free(&tcp_task->r2tqueue);
+	iscsi_pool_free(&tcp_task->r2tpool);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(iscsi_tcp_r2tpool_free);
+EXPORT_SYMBOL_GPL(iscsi_tcp_exit_cmd_priv);
 
 int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf)
 {
@@ -1223,8 +1230,7 @@ int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf)
 		return -EINVAL;
 
 	session->max_r2t = r2ts;
-	iscsi_tcp_r2tpool_free(session);
-	return iscsi_tcp_r2tpool_alloc(session);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_set_max_r2t);
 
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 7c8ba9d7378b..4d502f61a948 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -89,6 +89,9 @@ extern int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 extern void iscsi_tcp_cleanup_task(struct iscsi_task *task);
 extern int iscsi_tcp_task_init(struct iscsi_task *task);
 extern int iscsi_tcp_task_xmit(struct iscsi_task *task);
+extern int iscsi_tcp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+extern int iscsi_tcp_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+
 
 /* segment helpers */
 extern int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn);
@@ -118,8 +121,6 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 extern void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn);
 
 /* misc helpers */
-extern int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session);
-extern void iscsi_tcp_r2tpool_free(struct iscsi_session *session);
 extern int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf);
 extern void iscsi_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 				     struct iscsi_stats *stats);
-- 
2.25.1

