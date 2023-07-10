Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8848AEB64D9
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 21:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjGJVpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 17:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjGJVpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 17:45:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB70B11B;
        Mon, 10 Jul 2023 14:44:58 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AK66on002883;
        Mon, 10 Jul 2023 21:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=rEv0onX3fW5jMnxA3neUiq/z5bDsGdbzPE+gq+sG0lk=;
 b=wtFt6OvJScY+EE1kh0HDh4PZETSrxXrRWvT5LXxtWEIrdqlX75/x3JjLwFyo/ygDuc6u
 iT8bPfqTbmVOxUVpvq5WjXQXK3UVHvkT8l9oDvBpxVD9eul4aHnzKRhsDXHzQr+I6RpS
 la7QCTnd+s/WVxeGwlhE5MSaOLgTYyt+MwjGMzvFc17Wq2WqpuCj/b3Bfti7EZXxr6Wi
 nto8Dj1D6IUGvSE9u8OtFnuQEjjZKc/pozjLzLjnjMe6v34cQDYAE86MrCRiRIDcvcO7
 qn/rMVyrhpYhGqPNoUyvfDy7LmQXLfDg4TpmF0VLPIkwuAbRa3Ug9H1xsmtuN7WYvZsc SA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xuj0vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ALBLIr035522;
        Mon, 10 Jul 2023 21:44:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx841g2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOkArik3Zk4od41rS9v8pRilSFpKNKb25PMYORJ89C+OH6QVJX2kpUH3zbDkaimhT/ybmLLcoTtWHxO+tLEXv+Lo9FlPZug4DUm2WJZFy+ihjW6a97DeC9xCnU4uW+lbAdrHLclr7q+wwdUIBGCmvO5ksuqEp3s0M2bqWMw2pCaeOO/t2tqdZJnbAPZy9o98/3Bm3xkw89NE3b50PKh0XxjynTm/YrgPy3FUGA0uRLo0FSoO1tquX205xFQcCWCdy+J9MgS2BrBzCrqG6EQu1Aq5J+pxjBRQ/PN7SLEqEUIxryy4Qav/0Ha7CsxAPx1dfOWhS5e6sq0vsuJ83wqY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEv0onX3fW5jMnxA3neUiq/z5bDsGdbzPE+gq+sG0lk=;
 b=g2qPb3w3Bl1IRe6u3eyWcFv409UrtTK3ilhOh0OUAy5n/e9+ATwbel6bG/YOuktYDdTLqR9V+E1jrvSOJkIc1BQy/pq7z7vAvC9LFeE4cVDmR5BkKhu+cjRaDmvmeOAmD93OdNXMlTx/cJa6ZH6+FiwXyLMiMTNaUGBnSchhkp+Dwo0OSYOT2/7wQe2Te6Q0ZhZtZGerbRvqXy1/my9iWSB15p9bd+MUOgIF0b7v80CKFIo0UIoRntmqJiOzsE4v14eIjm/0aKQJkC2wlO/NL68XRPkKiJ2umk5TyUtQXQ16SdBpGzPjxzebNizNywA7yKHUBSHwcc/LqCdCwVhbVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEv0onX3fW5jMnxA3neUiq/z5bDsGdbzPE+gq+sG0lk=;
 b=BPFb/+AGVVpDVb46Ll89XSTmtBOTEWihgjCeNi9Vpv+lhynp50FAu7PZNiIehtCKB/lNJN1xA7pe77aCCJ8gvN89oF8TdyrD157dgWIEE5Qx5QQon0vOZ1PJ+SEBzlK4QdKmZSEqgYTN7SFZC8l53M+qDSETED1Ydn3Ehli396M=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by BN0PR10MB5080.namprd10.prod.outlook.com (2603:10b6:408:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Mon, 10 Jul
 2023 21:44:55 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 21:44:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/5] scsi: target: Export fabric driver direct submit settings
Date:   Mon, 10 Jul 2023 16:44:42 -0500
Message-Id: <20230710214442.6718-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710214442.6718-1-michael.christie@oracle.com>
References: <20230710214442.6718-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:610:4e::21) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|BN0PR10MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f7c69e-6255-4099-936c-08db818ee607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZDr+SOhEJmhmDtWI23SC0fdkr5XZq3/UULdsKTb7LeA9NSSHNU6j251scB8dArqkQASamUkoZBEI46+ZMwAbt+rgzP70+sDaheCcsTECag/rXzhQKRXKdc49yckGJdbU1YBsDkAG19M9dvcRxu7hhHsDaMMmxE8cq7c2wYuSVm3St+RmtxCBOm05J430Cqt7ua5XkKlXHYh8rQ0fkBhfy74pGwTmYoLRArzh1sEv7UWKKHYJoe6JxfytePuelaboC+wXLM0n98xFinbl9PBso6TnFNXjEknAYyuK3pRg9SEplz8ByJITlmPhhH1SjovEaDjA8molCAjVCmEp/tpuKhir8saMIxJkNWZWUg5xMo069QQHKW7Mxat1FsHKwra8aNCJAPK1ag9BnEUOwxXEHGNFs2aZCpM97sXSRpNjdEVcS414V+PjAADvAv8BM15INoOpx22Z7VFv+jfYTiHbMpwuH9uCe6xJHhVdvb6YUyfdzZuEmrm2B1pQrmE1Zu656JwvQ0dWeM3OD2HB+PRH8vzurAhmHFoOKcyfhL2ChnyhvUuMMRh44jaM0Qw7igQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(478600001)(6666004)(6486002)(8936002)(8676002)(41300700001)(2906002)(316002)(38100700002)(6512007)(5660300002)(26005)(186003)(86362001)(36756003)(107886003)(2616005)(1076003)(6506007)(66946007)(4326008)(66556008)(66476007)(450100002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uri2svEyNGvAewRIovQWiQQlo6eVUIDBfF1GjB7F2KIhLE2gCTrYjrcjfCef?=
 =?us-ascii?Q?QNVHhntIrRAZ7JglHuFhabBujGbirQZEgk1bEM5QGKIMPWQob4o9jnUbQzsI?=
 =?us-ascii?Q?6amHQykQB2siz+AlsLf7+PxhsJ8r+2jqPiHaEQeTJlp0BFdXie+iGLptpkPz?=
 =?us-ascii?Q?kxUuBUxFWQEuR/MVlPyEhGXCa/69oL29Z2Vzj53MoKD7kAUTVxAUuWVMWvvO?=
 =?us-ascii?Q?39UaG71QcY6lvWC5FG3klnMSVoXxZIGsPrwIkELIR4EZNR4B3JLLaS+4B5S3?=
 =?us-ascii?Q?R+8J+IhDxTW3jlOneiWL9oyRiq4zrsRKfn+1uX+wg6ebcfRpQg11WNvjNDRR?=
 =?us-ascii?Q?Vevw0pGzo+4TCne3qo2hh8JSvsicyRD8zTq4npQZ/kBohmFdFBfv+dDJMspc?=
 =?us-ascii?Q?bfSmIThyyWYrkd/QAVZSYmIB9g5mKxCFES6vLlDr51S91NVK1K9n2+2n63ql?=
 =?us-ascii?Q?dGoT8pn2iKbWPXICNWHzaj+kTdpi7YxwjzKK/AUgIJTh/1/mx1sVdKouTJmB?=
 =?us-ascii?Q?A2rJYuHrY0s0D1Qr2t6tSEmqOeJAudND5aUdKgQSDEz82u3NS1eEB/TCtzC3?=
 =?us-ascii?Q?NakMKqM+ei0G6oI4j73DEpIj88eksM1zRoVbGTT6921h9oodKgo69f3Qit3G?=
 =?us-ascii?Q?Tvj1gllrfSHGJpL6n9tkmsghMVIR5GtKtt66CQJQXL7FSuHlJPCBCCjsE3kI?=
 =?us-ascii?Q?4+LhoVKfGFF/8/Tb0ax4mG+/Ev2ZsGfzOm5CnUyqoDt87WD0qrFGotEQJUem?=
 =?us-ascii?Q?o97mhK8hdR+gXIc52BQE9LeBl6Y8unO1N24UHKUE+54MF8APK2K2NLOqhLQj?=
 =?us-ascii?Q?veB+uMQ1JvsLc84R53B7yFYoNVy5sFg+wrAUyZijoNW2qDTc5sat646kDLup?=
 =?us-ascii?Q?oaFbF/ngkAIFhanMfaKM/FlpoO3buPhq0BFJXXg/5hBP/AzAXo97YwBDbD/a?=
 =?us-ascii?Q?G95JH7nR2iUm00rWMVjQP41z6fjheu2zdInwfK1n+a+ZBdzqoYvH8jm/GYow?=
 =?us-ascii?Q?Q3o/AAm4NItw2ehpBCJR40uIYBCavublMfbkktlFOlG8qkfCxjF/eA6d5K78?=
 =?us-ascii?Q?1KaimHuidTCW3itzMrq3NOv7RkFwQ9/FmKjyJZ+MXcdGosYTBClojDfg4HX8?=
 =?us-ascii?Q?DnXUcTcOemS/KOytN5KkLbw9ehQv4zEKlxprRZIgTNEA/K6mr+GDWs0gaVz1?=
 =?us-ascii?Q?N6df53X7jBn8xjA46MeNAkw1uNRklT/AcCP+A5EtIhHRtyxiTgVOHX3bYNO2?=
 =?us-ascii?Q?St6zLH+tMwbS4JQHrcOa0MgKHBjw0E3e90FrsjLBMv7bLE5MhHMG8TJLmcXA?=
 =?us-ascii?Q?g5SpAZY6stS/P9xIxYXMNMNponZ4Bi5eOzJUMFCRYw+djTKYlMRIFNJ+136h?=
 =?us-ascii?Q?d0gogykgLnnRa2A3/tpA+N/hWDt26tOm/8DlU5gwoRyJpSO1BRm6L9mgSmql?=
 =?us-ascii?Q?etPutWKDEudur9JNdE5ooesG8pr6am2ucP3WzOXPMyt6j88w76gkiv2faIHu?=
 =?us-ascii?Q?RM3PDvK1/3C0hlSAwMItLPbVZwH7dbTK/bshY1vZ2/lGQ6ThJ3BIIPzuqJxW?=
 =?us-ascii?Q?hXrVEB+fv1gFK576tHryd4ZcBNGFuy6JhLF61Vl/CP8f7YEELfDdpTHAkcJ+?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5nCGWM2mhU+SoGPr1M3nodJ48cadBH+8Z4/SXxAaDuFATq16mqUexpWXqWqKMoFqoz/yEuePRlenk8QE9xIlc0oiO8o/+EstMjf1QPonX1g8JQX7ZPpToV7tKq+byzoeu+pTZmYxCJsP+rJN3AiCkp+3IrYBxERxXmoxuDREyOOOYqVFLzcajf4go5aOVxt2pnklPmvZXdAZj8FTpMle7o4g5w1P8uI/ACHAos5Ko47hjOqamRQJIX6alcOAMG9tltMzX3DgYHehFUcjjMiE2hdSEu3w1e0ENSUD5t8wD4JSkO/yPZM3VYPzGJW9tCXg5n3/KK1fr+qYwb86PQTK9aXG1uPTsj3KJshjaBmycS554HAdtxiAaD5rgIHv3VJURjMbJZdDgvH5GdQLrpPcf4x1GsJm4reyCT6pJle7qApX/w4QODQzQn0Y2LaqrnKMDv4SgnAPCg/WC+l3+BxqZ8APwO9l5q+i4/vYrPvJaZplHhYludodrsi3e2NkNstTvR5qONDn3WMyG7VNbIRHVv8qF3K2efiHhOdaY8eWmMD9On/WH2j/PAZrWYu91huFhi7nrZ2lxzw85K/YUWPtEzHRd9jyF+Q8jm/O4BOnCP2XK028EpwcM18mDhUXOiESM8Ex/PXWIPo5amz6Z0xeTGQy2lrwDuPxbSRh8+TOEknIkSbZrtGHqVQ+at7IprLkjgS7JOmmgct2sB2noSxZaKNEWFoyhh1RvPQ8coLdCYSC7jFJLezLGDSjH3eJaKzbSex0z0LJ0CzINoMJ0BG7Hg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f7c69e-6255-4099-936c-08db818ee607
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 21:44:54.9565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1WI7Cz3P62dcJ1rDBoyhrD+pYRsiMq6ZVMdoVjCZMag3OZ5dYMEEPwqyixxBW9p9fLwXMCQiKIFSeCpHXiGroT1vaFh+z5x36L94kQINds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_16,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307100198
X-Proofpoint-GUID: NepdpNVmOBNZpHteInS2gnPOSaMyMRK6
X-Proofpoint-ORIG-GUID: NepdpNVmOBNZpHteInS2gnPOSaMyMRK6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This exports the fabric driver's direct submit settings, so users know
what the driver supports. It will be helpful when they are exporting
a device through different targets and one doesn't support direct
submission.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c | 22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index b7c637644cd4..6fd6a9135dca 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -1065,8 +1065,30 @@ target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
 }
 CONFIGFS_ATTR(target_fabric_wwn_, cmd_completion_affinity);
 
+static ssize_t
+target_fabric_wwn_default_to_direct_submit_show(struct config_item *item,
+						char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sprintf(page, "%u\n", wwn->wwn_tf->tf_ops->default_direct_submit);
+}
+CONFIGFS_ATTR_RO(target_fabric_wwn_, default_to_direct_submit);
+
+static ssize_t
+target_fabric_wwn_direct_submit_supported_show(struct config_item *item,
+					       char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sprintf(page, "%u\n", wwn->wwn_tf->tf_ops->direct_submit_supp);
+}
+CONFIGFS_ATTR_RO(target_fabric_wwn_, direct_submit_supported);
+
 static struct configfs_attribute *target_fabric_wwn_param_attrs[] = {
 	&target_fabric_wwn_attr_cmd_completion_affinity,
+	&target_fabric_wwn_attr_default_to_direct_submit,
+	&target_fabric_wwn_attr_direct_submit_supported,
 	NULL,
 };
 
-- 
2.34.1

