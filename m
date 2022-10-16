Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8F3C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJPUDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJPUD3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:03:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A6B286F8
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:03:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrY015579;
        Sun, 16 Oct 2022 20:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kR2nyLxkkoYrQAFPenTxZ+MOjmgs96Nf4PAvce7NKWk=;
 b=pB/5dPCmZ+jBZCs1yX1dw2tSn7FbW6w1yyG4bbBpQe0ycD+Jt5YjsM3w17AnvhHxAH8e
 HViVBNcTXX7pzsWK9RVIXQQd7lC8eJaj6hx87pqo6Qtsv/22lXTTY7FnTSy1tStkTBuk
 QcMoc6a9CSWY1GA5n7wyVJSHpfxyw6JL/ryGNHWd2hEbWhYuPplJxTSlQNjKh59bu00e
 tc5ClFCKL70ggtC5E1E5DdHD0P8Dr336bhUwTQt4AS5hPDSkdmP/NTgdPQyNyNR8bgJO
 yb7aSiU1ndc9ZN4w3cbUUMrRI+NWLlVCmgwspSTpbPESiojP6SzffaqBx4pdpCBxXSY5 Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSo034322;
        Sun, 16 Oct 2022 20:01:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lneNl5hE0UTrLkqzQdSyTgf9gNm10oiO5K9mny6QarimepeUZ9W/oJCRQhCvj2ecZM9KSnc8PjoJ0sPVDQSyk/xbQd1J/OpsjixyjoCa7wOZ5NUHaI1SFyo2R22SM0muGrLhFDpvkQ3p7bbMqN2RXVGRYuduGvZUB6BCYOWlZrkXZOuP0i1ca8QfXQGQHwF7MwFTLE1fWNETvSUDIgpcs0xUy6fIAr+3mvoz31GOhZZ+L+CWZANlSUDiMKNUa19zFjrC+cYmoCvt+Zl1cTKPqpcQQPeb1NRQP0C3NRqWUTH8nwUjeC6C4HaiDGl2QqLkyGloM502gO4PIrm7IVKBbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kR2nyLxkkoYrQAFPenTxZ+MOjmgs96Nf4PAvce7NKWk=;
 b=Ef3oAasLHq148kG7sRIUaoqdVJEX3dsD2W6G3HYo/eanjyeF5HM04apES5MDta8WZbFoX78Eb6LFr2wNLZSahk9klka/S51sutw/WcyIbxCAHP5OvUh/2HTgm9N7iKb17lFSMq48COzekeHlmRoNOt9TQlLbOK7ArO85J2zw2U2Rkt3Anda5n8VzoY7Vx+qgdsLD1vNM/3WPOMkX9FP5VYKsNzQqJvQO7rdTY0g3SixB6o9BO2rXJ3NBueNqVb6OyFxdgG0tQ3LQwLbZ7Gq9BvFQCPotcxnHFdnzKhS5Ewn18flzhTUtG/Of2EVONv47o+HgbZeNHP4FMFc/vKDY8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kR2nyLxkkoYrQAFPenTxZ+MOjmgs96Nf4PAvce7NKWk=;
 b=zkSkXbMCQ44qD0xb8YbytyxlDFWNYNhMCtLNLdZGznfriWqBJm8kPPraG/YdvR14WQX9FgO/6NSQIkdOGZzFSy1qR8nFOPVp7Lawpa/GTvJu0UibySEVTlKvrdxqiJ4lTqtgpDHDl3jm5u/XiRQOZmaXQnBrCBECooK4wcPvDVo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:01:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:01:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 36/36] scsi: Add kunit tests for scsi_check_passthrough
Date:   Sun, 16 Oct 2022 14:59:46 -0500
Message-Id: <20221016195946.7613-37-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:610:38::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: 368d786f-c1bc-404d-8b59-08daafb1219f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mm6F9bh1whJXaNOKTY0eC4VEIlyZUbsJx+aTHX/Mgadj4EdQMc9Vn4+i157uosgBQ5mBCG7N+Zxzk6Ms89W95N0yZ7nCUgXq73qFgIkcJz5oA0pFxN477JK6ZyA7t5tpgt40Rvuy4TfXqH35+doE5QN+8hV2te+xUIPwLNakkiaXJsVkC0NTuN1HyaFJlHDIuDUPQ9VgTqegkWSH7PvM3vus+5zS9GdtoxKQgSBEu6irbAaCGcmSV9T4rHq4QY/2/tl6ojj6i88eIRrXCI4S8i352DrsjIhYwPqa+/uUPRewVS6/9A1HsNRSSPbT5ZDNreakRCENXOpeOuaBMEsEqhHyOkw5jfwDWU32WI2Ftjy8A8/xSnsDpM9unv0bblf5lcwWIfpIGN5kCcunzH/9qaU4+VQ2L/GGWKn9NLH0KMmzSjszTLPznvTMl7D80sNySfzUbx4uODJGse49u6Nevch16up84kY/Xjd51OKtGRIj4TYGxFa4iReJ2Bdnf3HsakBSus8fVTBpIwcby6OSnmcicMliUjjuMI2KrI+ZQJU5m91eyM/Bmw1uacf9QVwkyo02zFOUNnD20yOQfYjmzdrPMBx0DmW1aG3GeyKhk4ECx6bXqPKxvYOga/TfgzeTcW1DXJqBnLwsGCJpHHCwSaS1Pyw1yGALr4SAvrxwq25IzpwD18gO/shBGpz513cGKUUbsBmzwBJbPWBIE6YROg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Tg2fwtT64PoxlvRllaFJ5sPB49wS6YwYwGXEGiHORrJM38639PyTDrv+C5t?=
 =?us-ascii?Q?bfttC4+js+EGXvoAsEud5NBri6uFXjztTqvAK/e/DBY5Kmp0nCVqZomuTv4g?=
 =?us-ascii?Q?tXDe2hLxIPQKzAjHyYl0O2JfddXbqJ6IfQ3mwika51P+MAGS++abNsNqgnG7?=
 =?us-ascii?Q?iCz0qMrFf66I6NZM40orHkpPSME4HK/VygzNtY1ZwafeQ1r80am+PdOZPmaa?=
 =?us-ascii?Q?Bql/ZMRQSWfJMSj29EgzHM34RyzLRB+lVnjDbLumtlLmPEnPo/1D6gDjOj7V?=
 =?us-ascii?Q?mtzE9uGRRtuTbEvm1sorkTeNqHx4yJwy+z84SOM+OyHMXN+VbiWecqbXpWcX?=
 =?us-ascii?Q?RBa/IgAnEF89mUzI5ZTvp5iPbbA2qoGQoqqNiPDW+OSCdmuJHjodW3GT8hGy?=
 =?us-ascii?Q?2oXkb2XNTiJeC5SzfhiL/w4gsgmqc+ej+JFAqfv8/58WoJtjWhA6oMB8cssT?=
 =?us-ascii?Q?dcjPSoue/6uqxrmccBShKHxXdFf+ic6KdTorZt3rnfm3F7z2B/Qb9RMlisMU?=
 =?us-ascii?Q?H4FaIXWFiFbnd8q1RaPxRG0ejWkG0o5UutFGVev/S5ng7WaDlNuAr0ldiL6m?=
 =?us-ascii?Q?s5B2YAXsVR0XR9CedNnVINVCKU4K17QP/tNCcUz+II2X7lLTq8XAmlGGRX3T?=
 =?us-ascii?Q?8pjM4IvrCOh51ypA/GjHMJ3UQWG85wehCO5x+sJzjqY/+w1A2SPItDCDuWjn?=
 =?us-ascii?Q?h1af6NIZ4AQxwurqLOp2gwc24UJMBmC79R1xNbOSx/hwzGJPyWm2E6wTiYQc?=
 =?us-ascii?Q?4SfRK0JlkS+c8kOwsXHaglafF9ZBdgzt8e84r+YhlaAxvmBzXVEyclGvOO4z?=
 =?us-ascii?Q?R/kWp0xBqi/eoQd43r7az0cgAgyEHPixemh1Mu9BiU1XcTkq3iBee4NkiSL8?=
 =?us-ascii?Q?/3nqWoo+XOv0MRh6ijiWVBRHUAClu7YFFPKqbWQVnCGU4HLWWkrHv6AQ7KvP?=
 =?us-ascii?Q?sIifgA3hjna4Kk2da39SUIbWOkDkTOJkae5WYbXS8sUkDIrqwY+a4V3Gsk6s?=
 =?us-ascii?Q?EdpFgw8flPxoF3zD76H2q3QfpJhe/Ypv0oGaRmxB85h8oZdAr/gcNvVSpyxS?=
 =?us-ascii?Q?GPH7TnWqQx7/x9HLc6NyuzFtYcOIRg1y0rB2ADa1Job8VjWs6NHeyXvFwndU?=
 =?us-ascii?Q?3vdz/2m/g98in4E9w+riUpjXjpkY0bHH7sMxED93xKIuUMAwMYKq03U+3Ie5?=
 =?us-ascii?Q?/2LrFRoBHAMgeCVTcu8ypOkBWMdhluMgk1MUVS4egVm3Bqn4Re4XJpo4Bsik?=
 =?us-ascii?Q?MNEVX2YmHbnB55Tw+T1kL99OmMckg+CFLbfNNIXbgwliRteqRGVeDHSEDOak?=
 =?us-ascii?Q?ECeIT6NrmSMFwETKmlLZ5k9GyuUgVITu8UCGFKI15jVAZK3zSIY9gQUrLIZU?=
 =?us-ascii?Q?vhYXeixb7qQG5pqDtmV9stzmYxcsDkVC1DWmCl2dtYnkjDrGBdRM3y5UC4so?=
 =?us-ascii?Q?Cr2IyyVORLlKz4tduyGVHEdhfouWQm87S7uSKafu55szxjZ9+v4O0GnbslzE?=
 =?us-ascii?Q?X7UxPZZ47h/ZbDXdbAN2nODz1lqGMlUUB4/ksPUClo5YQoJfYSllO58gL/7j?=
 =?us-ascii?Q?YhIN+feL170jWos2fp+HNlGRj37M+4MZOXlrzAsa/5AGkuHyDYhbUDtNAJi5?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368d786f-c1bc-404d-8b59-08daafb1219f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:53.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVOuEc8ti6Xfp/Ej357BxhtJecQ6RzaqKW8VqoObk18fxS9kwQsWVyrUcLD46+WC0ZEQ+zUa7lLGp4OFprAWI0DFeDhBP9IPlam0DcmJKks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: pNaWa2ZPMF0Ynx_S8Drh7RxfT_qx2vZE
X-Proofpoint-GUID: pNaWa2ZPMF0Ynx_S8Drh7RxfT_qx2vZE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig           |   7 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_test_error.c | 150 +++++++++++++++++++++++++++++++++
 3 files changed, 161 insertions(+)
 create mode 100644 drivers/scsi/scsi_test_error.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 03e71e3d5e5b..00f8574a5916 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,13 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	bool "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on SCSI && KUNIT
+        default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2aa162406107..ed37c7eb6cd6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2618,3 +2618,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#if defined(CONFIG_SCSI_KUNIT_TEST)
+#include "scsi_test_error.c"
+#endif
diff --git a/drivers/scsi/scsi_test_error.c b/drivers/scsi/scsi_test_error.c
new file mode 100644
index 000000000000..ecc9a39633e8
--- /dev/null
+++ b/drivers/scsi/scsi_test_error.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the scsi_error.c.
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
+			.result = SCMD_FAILURE_ANY,
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
+	/* Test sense handling */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_TEST_ERROR_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	sc.failures = any_sense_failures;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test host_byte handling */
+	sc.failures = retryable_host_failures;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test any failure */
+	sc.failures = any_failures;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test status handling */
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

