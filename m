Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B0C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiKDX0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiKDXZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:25:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A5C2610E
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:25:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Khr76032446;
        Fri, 4 Nov 2022 23:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=EbNd0LS5doD9Zn9IS7Pq0qJg+Y/krwuitf1gqDy8Mmk=;
 b=1Epkc1n0LZxLlo50miQ9nXOwTatK+sdgGoys1zx8mVCmTgJblh1kfW5geRpJjOCh3sNh
 Y/sG5P6oA6g4s7IoI6Sdws1x18v18cgbyN7L8683EaEDeAd3bcb2AdMgzeL2B2T98Rw0
 usOZbbJgFocopViE52eeXtqfdYpfNsux2FI4mF/Rn2/QToxX27S5zNMvRVo46rqfMIOE
 pG+hNdcOb3QbH3jqXmB1dIqb1PsAFZQN82h1M6WF6QjCXevvKNKbQEPIfrGACYc46yDA
 ti+x1x3d/Sra/CPFs58MEY1PGPQi9bwv5THdVRgHayVDQeY5kr+qDxh6Xgt8B5J9LnWz pQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty398ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:23:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JwIpk023290;
        Fri, 4 Nov 2022 23:23:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwp0ag9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:23:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOodxPQ5RtM86lslediOfqebdODcGBZA2VVnf1BBnQJYDW54Gul88AWcRlJx/J0347GsCQlsVjY/G6zgxbGsxmLCgVeQNbU0LJcG7vogcbPEAGhhGMq61jDmiYJOOPuwtcItPqlGoT7tplJCwDUCguGtrsz5IOuEcH3cO8mASUgzne5+kOKI5HU3iu2a59xJk/5cZOggvuZevCg608GOLRF2NK5dH2sRatMMat9HhBZ5SOdUEfLgbM4dnAdc02T0MB6/tYnRhWrnRyoo0chB1kfCK1sdOHNWprO/jRIBP9VCPQrluKhCZQ+h8Z79T/PeoHAp4M9C+3WHwUaTUiC3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbNd0LS5doD9Zn9IS7Pq0qJg+Y/krwuitf1gqDy8Mmk=;
 b=ZpEce4gSIOtBcoeMaDBgva3bPcuYsHJSqlMvZd7YggHR9KA8rZjpYMcNl0PWdMzWM261U01sGNvhA0tS6+li9cMaHCyd7OTzUlbk/94DjDi/HDr63CFnUdhInk38xEKYKY8F4X37yP/yEX81dgJsYtXnGwFDmpBtcFmkrKNLkGDWGciWWNlb6S20aWYxausEMDoYpOOSqhC/y03rHU4oGYjYV9HJuBeGuvxysM4NUBxusFHZ9Za+4P7NcNBwtu+hd+5Itsr6jcUj86x+yj7BUbSaqILjqkge4j5spIDg9vKfol6VyV2Z/G1IzmgWOXK90wHCP6kSYaJtfiXM2psRwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbNd0LS5doD9Zn9IS7Pq0qJg+Y/krwuitf1gqDy8Mmk=;
 b=nDjr4v87vmhJ3DvFwi1AWXdqqmzYB+58ATd5E1UURp+d+EDKEfkQiDcskVgCUD/AgGdERam16aWOqmjBcQM924lzRW5SmIUbsJjgthBsfWFmTqzvGWLdjUoGNzl/DQJQ8e6d/QcXPYv4nmKPYrAesgTroma+SEHPHJBfZ46zBXo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:23:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:23:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 35/35] scsi: Add kunit tests for scsi_check_passthrough
Date:   Fri,  4 Nov 2022 18:19:27 -0500
Message-Id: <20221104231927.9613-36-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:610:76::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: ecc1bb85-5db3-4e97-a249-08dabebb6e43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4t8k7ROlM/hkooCX9WV8zlXNrZpw4T2Wima1xZnF9KYgrllIFTHhCp4/HaZLcXXUzdihwGa1okx44m7gDxHz0qiXb9WKenFeSAyMCYnrupBhHoZKeFJekWZcl7CJ78MjKFPV9D+4fT3K2PGGt46uqaXPEO0FhJIDujLyWHO1qFWAlNX1ogKqlNC6FCw/HtEY4RYjFSf/Ft0PuSsPsovD7IGbyvWQbpimQN0uhYlKXn6TBdYQM+hBVNjJ5WkpcDTdNwf4/T8wSm+JNtFeTAHf+cmSfYc/vLQKeZbwDV9O8hepyYuaNQlMCBnDMCZ/2OgJXkcam5N81O8HyGdrEUMuj4J8oYnVYZhOH9gsKq6BlL17NECSAJ3Cn9T1Hc9CbnH6ijRsFhaM4P+iQgkgCBMyDzZPORtQtA3n6J5SuGLf75K16KoW8SrgzOPYonEzsuKqgOJs6OlfcOlm1vZMGlAT8nrHcdWK42QSnLDHSB81COZ2EW5H2Xp5ej+fY7gsPnPJ8Km32AQVt+pX1fneMSaojGog8dUGRMU1ydMldj8gG/M41GgoT4rgR8Ta4AzONIE8ucs/9RI4wwEfwK15rVVS9TMwJv8aU2Rrg4R0koWvh49ZRuRFlNeZGnfITronLpW2ma0jnVMT2NnGbZKWObnaBzqgPLLerzP/rhLngqA7hJa39NzN3tZ4mROkBi1zaATqOQWunUgX6ccDHGfUR/9yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vquw6xRLCe8XnfYqx81s6Ui3IURZwd3d37TsZRZboUfY+IungxLZcp6tB1H3?=
 =?us-ascii?Q?jJfqAsh3X1NuS7FZ2U2LY29ksPazxo0w+wE+ja0RvOtOyyZK6/RLII/NMN+E?=
 =?us-ascii?Q?CLAKNjMtrHj8zhdRNZVlhNEY8PvOI3XYdqG3DQA0G+JWlT8bJ/eKnudpe5PZ?=
 =?us-ascii?Q?LePTL+ef1lTyQJO2zPeYjxqMgcUNJ4Iz6ja3Gqzv3SHRTR9B7BDM/2lp9CKr?=
 =?us-ascii?Q?VgZB4v69bdquEm5gnsjCqXDfZyotTENn5aY366y7G3wD1Lns1Z+xgfDyTw0a?=
 =?us-ascii?Q?bH5sZFlp31FQ5c2z3WG6pDkvQ8Ale809MwAyI8b1d73IpmVtF/cGENdaw+C7?=
 =?us-ascii?Q?tXbhq9Yr7L1wVy85wYOdNo1oFq1WtBLYfco5whBO7nmbjvLIV9q8VKNee/Sp?=
 =?us-ascii?Q?Z4E7bZ2edzW+rV7Oynw/vlafuYEZxOnLQhPJYkoUHwccGefgG55T0fIS0+PT?=
 =?us-ascii?Q?vuJciT+XkHT34OZxP9IuOu++YsrpMGNO/XqWu43eJKbPS32c/mcDBdwggL+T?=
 =?us-ascii?Q?wv03g9RK9AgV5W0gkcQwgAK88yiOiKWVYkKJ39vDzoBlfCr6yUd9+Sp7AZRo?=
 =?us-ascii?Q?2n0ZsWiYymMfOcpmcEfLcLFJyAYNs1cHRKnAU+cxhpUtJQgQAp1P8MCW+Vbx?=
 =?us-ascii?Q?+V+auHGkILIAFb0LU6JJxrO7lyK3yD0ldofiRDm5bYX38NFOFdiNks0/Sg/e?=
 =?us-ascii?Q?A4nDysrkCGnajkl6prAQCczJ8y83SQtHITUrzwmPwdd/Roy0Ct6XedDJh9k1?=
 =?us-ascii?Q?fxTGEEjZhupxfFRKB8oFIO/GsZ3Bx6iHNj2o4Tj50TtXeQPnRVwqUxvyqjuW?=
 =?us-ascii?Q?lW808io3YgIMQr/B9AAM+3z9ykUtWETX3ycV8t0BOGsEd2ghgTyagvC2n4fl?=
 =?us-ascii?Q?iTaB3Yqkqg6NHxpz/FX3UY59/Mh5xVIJuChP9f2U2xX7I1mLEGCISLKSZwoO?=
 =?us-ascii?Q?Xarl9/GK2pRMX3X3rW0qr/zf2jgiShKSDn+gJOWJGTQGbV8N36OO1As4BpPM?=
 =?us-ascii?Q?Pf1iToNxZruMfVNFcJNKGLem6F25flzEyShmrSG3bAnzUFB/TYxrXJel/kwa?=
 =?us-ascii?Q?lWXPW9dJVBnEHO4bJxo8Z3focUFLSx6zTqzwmFAi7BcnEJoV144PzWPRnA0A?=
 =?us-ascii?Q?MSPSH/fXuDRE62VfDb4jVzCIDvy1cPlcYMbzelQxwRiZ69tQIIPrjufye6OM?=
 =?us-ascii?Q?HRjTTpnlkncOWcZGWeSMIceb+eIDqFcB/yRcKVf8wK1A57zrlBZ6jtzZ2W/g?=
 =?us-ascii?Q?vMPYuZVlsytLyff83G53L7NF3Y4v9i395GlAS1gkVjQrErHoHG1wsikeKit4?=
 =?us-ascii?Q?iPLvsUv9DR+PAIVLr7v3wkcMfRo0PySn940IkCmqm6GavHtiZWWXq6EduKZG?=
 =?us-ascii?Q?BQrRpFdG9opk+Z73nG0CzdnUJw0POxYYldqZ9kLMokUzA2mtLhjt0VCxT3Ri?=
 =?us-ascii?Q?urGX6/zp28JkUiqPZlcxp4j3pmc8l5/8BQ8pqt1Y3+0CiblFrb8eMu+BSBff?=
 =?us-ascii?Q?EpHGWtCTEDW3C9mCigrJj7Ejb6WN1271RZbLulQPAr8FpnU9wyr7iWkiAawN?=
 =?us-ascii?Q?tHkHrxqzWH1LzcGFtYFpz3ojwRxv+Y29NQD6Z5P2ZB30GsPBpQexPKlic0K0?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc1bb85-5db3-4e97-a249-08dabebb6e43
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:24.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKOuPd8VK2ADzyzWM0C8Z176i7sn931sdfY2BZVHV3Sj/UeP63eKC495o3Yhhc9zL93h3mRDqWdCRynpSqfdzjvpaf16Qeh86H8lQOmz4mY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: Teh1NvzJb-tKhuY6bVbitiy8MBdryYHt
X-Proofpoint-GUID: Teh1NvzJb-tKhuY6bVbitiy8MBdryYHt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig           |   9 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 171 +++++++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 03e71e3d5e5b..52147a848824 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,15 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	tristate "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 77d7ad07645a..8d1a34a8bb3d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2613,3 +2613,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#if defined(CONFIG_SCSI_KUNIT_TEST)
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..23a2e7edc5eb
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_error.c.
+ *
+ * Copyright (C) 2022, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+
+#define SCSI_TEST_ERROR_MAX_ALLOWED 3
+
+static void scsi_test_error_check_passthough(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failures[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
+	struct scsi_failure retryable_host_failures[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_status_failures[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_sense_failures[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+		.failures = multiple_sense_failures,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_TEST_ERROR_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	sc.failures = any_sense_failures;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* reset retries so we can retest */
+	for (i = 0; i < ARRAY_SIZE(multiple_sense_failures); i++)
+		multiple_sense_failures[i].retries = 0;
+
+	/* Test no retries allowed */
+	sc.failures = multiple_sense_failures;
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* No matching host byte entry */
+	sc.failures = retryable_host_failures;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	sc.failures = any_failures;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test any status handling */
+	sc.failures = any_status_failures;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+}
+
+static struct kunit_case scsi_test_error_cases[] = {
+	KUNIT_CASE(scsi_test_error_check_passthough),
+	{},
+};
+
+static struct kunit_suite scsi_test_error_suite = {
+	.name = "scsi_error",
+	.test_cases = scsi_test_error_cases,
+};
+
+kunit_test_suite(scsi_test_error_suite);
-- 
2.25.1

