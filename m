Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E673AC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C172764E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhBLHcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhBLHaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PdPd017139;
        Fri, 12 Feb 2021 07:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QDy8hj3yRDluwHoSztDRMd1wA0TD7pqfHS9AOJWkYnA=;
 b=GeXXZG5lbmSOQxB9SHRa5AhoXjkmlIJTSlUc17xGlY+iWrm62Si1WoXBfLzdWIASx0LE
 tEN+DQ2jZq1qAv2exWYcllujRMtKm/+IgqJXzI8LYCRkov2AYNlx9FV5qZlmx5+19Yw4
 Jc+RLJ9CTYyJYkejX+p3oAi4f/qgJIx4IrBMN11VXjge3LI0Rb1xhZ/LbQZUPLtbusoO
 FbGNO7ymEKD7kKLfAZ1xINPkz0sO4jc9LdN00ttC59f2mJL1JpvCR6IJCktTOrXujZsA
 mpRnVW7Bulq/FZYOpDfPaCcy3PzRvwLHS98SE0T6tBgXpVBv+I0ElYsak/ws+cZJArad ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36mv9dvcut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QA0U090287;
        Fri, 12 Feb 2021 07:27:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3030.oracle.com with ESMTP id 36j4psn5w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBk0qOWvYd+ciD62UjZd2IO9UPyQiO2hQmSoUUH2dxLd8Nl9CbtZ/cqZYuLKFoyhENwUU42duBi+6pH0Bk4px0JgLeESsXKJjSlr258qJiGkT5mu8hxgv6T1V2KXsX3dK297KfnU6o5wA0KwAWQJSlkkbac7WfnpdyRdTdCMunJbcdTwsMw4tRC6B/QZ6j8g9RNfx6QTL7iNH6AH3OBOjZ5kDQewcj587Q2H/aleE0cpC+3fNiBgBlSwKrHkc0UYLoZxvBQvLwVZNeMTw8lc5whZcibZxyLlWhunovrMjcAzTwjQKWNb4jRzXGJ3uQWUJlcaK17xMvX0QdPBeMy7nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDy8hj3yRDluwHoSztDRMd1wA0TD7pqfHS9AOJWkYnA=;
 b=QKjJ8A4ZEAKOQ5zRbP2O9xGAX6d9IPFybLY/iDbrPldy7aqSQk/W9KRF1Y42gvpv17TBeNHLEwPpKNVlu819aOVQpd+oeHJQsSGySLeEv1N69HfXptZMRcNoDmy6Fa6dxulEaz7pHxHUK7m/MXz8Ir1Lsx0kAW3ca/QSwy5+8akZhKjQIDQShJzhO+gwQSIme4EEcFP5K8ljiMdH5MZpq8UsuhHpCGLdYu3OnTYBvaIBZpvMF1yO+N3ndqn3PJLB3sHHvQDrNu09/ORzJmXIyAFThe5Ih62bbMTiRMwAyfDYwtP3Pok5NKB3GOdoBBXIQc30WMDq2wmgVpFk4jFi/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDy8hj3yRDluwHoSztDRMd1wA0TD7pqfHS9AOJWkYnA=;
 b=TpfG6djtGoRx88AqVRPllOJXi7WXtmYky0xj8Uq/V9DXoJ40EcIDmoKwQGe65r5Bs/3HHCaIHiqx0v4E+nK6Kk9qjAR32jf+7RdP8q2IZMA0Hlu3lp3tBh835x9+mpMSeZ2WcRwZWME+aMmxXNEZ2/FpgRpOavxqGzCtNy2nPDc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:13 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 20/25] target: cleanup cmd flag bits
Date:   Fri, 12 Feb 2021 01:26:37 -0600
Message-Id: <20210212072642.17520-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b5f2265-c0c7-4e51-ddc1-08d8cf279da2
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB525471CF6A9F7E0509ACFEBDF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leFa/LYQ3ORGqes9EInLd5iQJ2F5CK953BwnxKINLztg+fMJaSG4gxTloLaTczYftRsEBCg6Tfl0dFGpQ/cRFiapOKcsYLREPQjjZlO2EkLhcDwoq7qXz6/9iUydYBBf6EFcOGJHaWPAq0vjeAXXqb/BNGGpL8XIobcQ5y7VIL4O4UpOgeEjWVIG0V6kHNPlyvSjTjKoGC27gwtgqPh/YANbqoKlAaRh6+6PtFyneZorUVmoRtgE38fWjAEOGeckw7Q+V5clgPmbzrsCtw7WcogrkomxbSKI2LAyXPPtc2Ku/3zIg64zIhNF4EZWsPiUN+QmCiDp3GCG0qZlasgjpZCLxAEZqqlZ7JqdlVpMekMzOG0eDkhkZ1bHlzfmVub2fqI5mGFw88hP7Sd9fuZ8Sm2VsD0V5RPM03rVuTtp7JV8GT0fHoC8zuJSKSppujEqHqn7nGn614ttVHniGueePp59H3cow5GiH1T3+pZ4fzCtDAT0qrZPbFJtj9SH6Urp7yjdU6rIgBgbiUPKN3Y6+DnicvWa6XQ7wJOBsEFVvl8hVROZ46qkZO3n7rYKbT3SLUCGdKuErRWOOLXsD5198g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7/ZUTd4hr9EJsC1yF82K9MfE7xiYdZezDY4b20pBl68kTIqRPYWOUx/CG2b2?=
 =?us-ascii?Q?TwZ46xFwobH0tPXg+d423VwB4lp4+z3LUhK08/kVY+/ZSPTYyMBV4E2BGs8Z?=
 =?us-ascii?Q?IPpJdC1x0tCma5mNg7LlzUCxHsVhfL9S0JhwWcIGYsuanmnbH1rW4SwxKfjF?=
 =?us-ascii?Q?x+56BK9+jQo6FDXnd3RnV/a66KylrmZV9590mLS/Dg47QzShwwYLClPNnNxm?=
 =?us-ascii?Q?Hb4iHfKwZtQk8ybGJifSckC8AOtDBUJjnkn7lObZlU3T8mZ/YobJhXjGxTHf?=
 =?us-ascii?Q?hWrSLcLdLRtEAFHNAEGZzr/vcvW8PECePa4iD0Tg235FXOBZ0h0lQieAzx8X?=
 =?us-ascii?Q?tAabu+F/uYfuhrE5Vpfx408RNybLpcspvHr2mHwyZ4jz4okota6X/HAsea79?=
 =?us-ascii?Q?c5U12S+DkJjJ7XH26UVZk9hjvFbojhJl9YM0iWFYlquEnw211mzG0dKgBwrS?=
 =?us-ascii?Q?9XbAfq6ljSNKPVbglQGupBKhxJH2CxcZxgQBnZ2BnyyGWwPS+0gcYA1MNvCh?=
 =?us-ascii?Q?fVqq+2aOnsg5DCUBTBv840PZ7TTZgePuqTwUd2xr0VmvpYaIYfpbtU7HR7JW?=
 =?us-ascii?Q?7Mn33y6nwamtWOgOapHHEm8T/etx1KHtW2G+id3ZbTBuVcRT3rHWMTOjbO6H?=
 =?us-ascii?Q?mKvPHytp7xgLxFYlK3OfkqvnoGpIYbkVPcsOfw9ZIT9iSthhM3oRfv+XS2MZ?=
 =?us-ascii?Q?YWdsV7vnodE6HvxzNc9TcLcLdbzTwKesDStAYxtysuJXrLlHfSQbarozpyJL?=
 =?us-ascii?Q?I3Ed44cpfe2HkuiEi4krKfxgozrHdPDkBsVLT1NGFuabZpev6tOJBRfWxm6f?=
 =?us-ascii?Q?6zs3Ki2uif9xdjSd/alnq80vaEYliRIRYneIR2jl6QqJ3yZ3pFjVRjV5VxjF?=
 =?us-ascii?Q?dvzNVMMIEoic9iZ+mcX3iE/cE1DV+lv1IVEtlv8gf0Xm8GPXuAvydpUYC1rg?=
 =?us-ascii?Q?kKggt2oOT7kaJ5FrW0Pmcfd8vRgC+8VdcxtdsCiAUTFoMFw+eyLh8f6Z0ybw?=
 =?us-ascii?Q?l5FGlSUoRIYzrmYa/tnGNn1H8OtsBX4Cd8O2kUV6ifUDGjR3b+EucWSTcAuj?=
 =?us-ascii?Q?Qf3xXSyeU67ttHiOztYV2IEw88V0qw04l3DX/xnYB/GxcClmF4N1RPd2RP9y?=
 =?us-ascii?Q?tckRpeMkG95J84jjr45AyxgXjzADoQO2GfIr8Fe64SBQv1HhALz+YW6cPD7a?=
 =?us-ascii?Q?5AdSO/7/qEWjgY37AhV1On8vR/t1PjQZr92BZ+teLiWBU3OcA3Hx4tQJHFnb?=
 =?us-ascii?Q?awQrlG8c+IDgK+shNJpqcPM99zTDzQJg7t20Wv6Pjxbc4UsozGwf1lOHm72K?=
 =?us-ascii?Q?G7QWiDaQw8GU62BBwu6AvVGB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5f2265-c0c7-4e51-ddc1-08d8cf279da2
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:13.0594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGuL/6I3AHPl6hViyoXooloJjaRQPOxfhp35x1DXlQXIXXYYZHCWmXVAUQxN1xqdCEQvdWZ9pxX5a0ql7sFpQem1vACvwXVFHvsoMqJewT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a couple holes in the cmd flags definitions. This cleans
up the definitions to fix that and make it easier to read.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/target/target_core_base.h | 38 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 815de4c97230..5e6703ca102d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -127,25 +127,25 @@ enum transport_state_table {
 
 /* Used for struct se_cmd->se_cmd_flags */
 enum se_cmd_flags_table {
-	SCF_SUPPORTED_SAM_OPCODE	= 0x00000001,
-	SCF_TRANSPORT_TASK_SENSE	= 0x00000002,
-	SCF_EMULATED_TASK_SENSE		= 0x00000004,
-	SCF_SCSI_DATA_CDB		= 0x00000008,
-	SCF_SCSI_TMR_CDB		= 0x00000010,
-	SCF_FUA				= 0x00000080,
-	SCF_SE_LUN_CMD			= 0x00000100,
-	SCF_BIDI			= 0x00000400,
-	SCF_SENT_CHECK_CONDITION	= 0x00000800,
-	SCF_OVERFLOW_BIT		= 0x00001000,
-	SCF_UNDERFLOW_BIT		= 0x00002000,
-	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
-	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
-	SCF_COMPARE_AND_WRITE		= 0x00080000,
-	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
-	SCF_ACK_KREF			= 0x00400000,
-	SCF_USE_CPUID			= 0x00800000,
-	SCF_TASK_ATTR_SET		= 0x01000000,
-	SCF_TREAT_READ_AS_NORMAL	= 0x02000000,
+	SCF_SUPPORTED_SAM_OPCODE		= (1 << 0),
+	SCF_TRANSPORT_TASK_SENSE		= (1 << 1),
+	SCF_EMULATED_TASK_SENSE			= (1 << 2),
+	SCF_SCSI_DATA_CDB			= (1 << 3),
+	SCF_SCSI_TMR_CDB			= (1 << 4),
+	SCF_FUA					= (1 << 5),
+	SCF_SE_LUN_CMD				= (1 << 6),
+	SCF_BIDI				= (1 << 7),
+	SCF_SENT_CHECK_CONDITION		= (1 << 8),
+	SCF_OVERFLOW_BIT			= (1 << 9),
+	SCF_UNDERFLOW_BIT			= (1 << 10),
+	SCF_ALUA_NON_OPTIMIZED			= (1 << 11),
+	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC	= (1 << 12),
+	SCF_COMPARE_AND_WRITE			= (1 << 13),
+	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC	= (1 << 14),
+	SCF_ACK_KREF				= (1 << 15),
+	SCF_USE_CPUID				= (1 << 16),
+	SCF_TASK_ATTR_SET			= (1 << 17),
+	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
 };
 
 /*
-- 
2.25.1

