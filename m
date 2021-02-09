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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CBDC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1639164EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhBIMkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhBIMjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZS5m008736;
        Tue, 9 Feb 2021 12:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZrhSxDpGiuoIC3wgDeHHH1SB/vn9aAiRH+pEFj/pm/M=;
 b=qPjmaWUS4XSq4bgQZ+uejXCyZb3qp3Axslx1vXmVctM8ReKoSCYirrvpDuOTN5R5C1kR
 4RzsKT4o58H4HxS3tpbHhKpja+FnNedhiG4IpMqNbUlq+OauoOU9okn6RIVBHRwHtrWE
 r7YjuA28LxLgoAtuV63dBKl2WmczN3691sKZ30HhRihGHxsXCv+9UkdwCm6Q1yvks09m
 CbSdJ3LSau3rF9Y1CCzYzaLVkiJTsnMFfrHAW51V36DieTLT2xmTWulkwo3hUTzSKkuX
 VXf4qv2otsrEeod/xOzZnyxWuBvYSNypkLD3P3zATK5fWtM6lNkLMmQ2Tcq2m7oaS6lV +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36hk2kfajh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIP178533;
        Tue, 9 Feb 2021 12:39:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 36j4pnn0cr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0a9U37Xbz0sqI5fBhiRVpxbE+sdfzA5fhxtcWrzHssCZESxtgemOndzVlyLNFtG9FTbDfCQiY4TSmP+wDOWbEgnEERdyCSeMTbADPM4WjKj+PJUneNX+8Ln89JgDChhvE/gzHBfmUTy6j/HpiVk4NPovftONoxyydQzG25o1Vpwla5FcqT/tkHm4eyy7a+WNAUmJaapq4TSkDyMMLlRQUjAmjfiFdP6RD4wnEKxX6i6IUcRhQ/VoDuphflXH9WPm4FdkhXR0Xh8Am9FMtvqGmgADdPkyqiXNZizFcm5nIwRVNZD8MioRZiGiwTiKgZGELxKMP6z+wGI+IsO4/dvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrhSxDpGiuoIC3wgDeHHH1SB/vn9aAiRH+pEFj/pm/M=;
 b=biCjObRhPmOxByk3M43T8ZeEg/BmpA1DWYUBGaXRlFzNH1pZT1RM4KZUgEieWgrz98UGx6JPPs0iC6WQ73QOxCk2IsKRFCPxdgFzL0t5UD24VGsU08ZN+yIqfN9PgyjV75MKfetDCSQOqsHlnDdpFm5WbDTXfB941N/0Da3srDK+obZEPkumH2O2F4DPQ3S42rpQoAwHKfW4f0rNTQ2Z5z7XK+wLFu+utzk7/610ABG91po6KmND6j4RLcGFbUhh4DsUeILhCI45B5yxAmNuEuxZ4P5BOzZDvXECfbc8y9z7w/jMTuepaz/752e87Z7B2xWuLIK5zTuVSXqjBnysCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrhSxDpGiuoIC3wgDeHHH1SB/vn9aAiRH+pEFj/pm/M=;
 b=rHQWUOhH1r70tGWjr5RiqprUMZgJtMUs30C7C4Xx4y6MlukVCjmPoWBUMczSnJxsRiPbFA0FBiLyilLIeKFpesYraLjF1H22KRYQjUlc+HQEYOzilBU0QXjFGx08M6AJ2WNkkZECVxXzEWWdhTKfk2fulIpHY4Eoj+sk6hFk/xU=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 07/13] target: cleanup cmd flag bits
Date:   Tue,  9 Feb 2021 06:38:39 -0600
Message-Id: <20210209123845.4856-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f790b8bb-2390-409b-9777-08d8ccf7ae4a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB260057E4D127BFB76F9478CAF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SWpIDagmsVtyI2CnigSVvHK7m3mYStX+c0SncX+Zgdie6thlAoREY93udVedMYIlbtmdk/nBe6OVz1zs9B464amdFByljkZgMPsDnwIqxRgMiYwIDN2j1Pt/lZ4lEWzA4GzlXpqUk2r20R/vXxNW1+KwC/amzz8j/fD+IkdsAUQW5akLDlM8nW4NtOnBl/wtXYxZT9Yj+YCWspCvgBlSaYCI0qQ7JxxBj3iXFoVnd4bAeGA07ewFp1PuY+J4yX5eBd52ThSkpWhtIjPfusVqCfJy8wzBJvvEBaU0ky9JS5xE+337A0uB96iWTd+EXgKtdCc30GPnPjZmHJGOdpIiTlnUGT0sjf6HUaNKX7ZNopCa/vC3xh5L7i0i5tNnOTXagD8oL05J5CphcX0SZJBT1FHybXRC5i/o9NGsSqGaGho4zQq+3R+IMovTMuHYZuUi8s7E5NZvZ2sPLOc+4N6XawiW5VmgY8juI4w/5kU0Ej6/3IoIQhfsKrMUWOyxkVG0MXPrvTLEh1hO2OgaWNuuYEkGruOE4H2jGIXmjhxUvC+Q4+3pDZdlfZld0cjb5rccPNbvzIV4M0qcBYrJjCMa2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(54906003)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?plCyI+7naSniA/tvxzH36cBDq0yW0GN8weOQKi+G3SBqd+YnDhkXtAdlbRnV?=
 =?us-ascii?Q?HOrb4IkB+7HBrSvUf8+HUYF+nmsITrzJLKnjrDdKoZNgiVPBIm6gGnk22ePa?=
 =?us-ascii?Q?CcMlUBmYGZB6jz8jtC7gVVlDoHxypzcRjfk10FCV6/CpgiwucK+5viuu9SvL?=
 =?us-ascii?Q?jaCkowz5Lc7GgPVib/St7KspDNMks3QgSeZ06z9yXBlIbTAAbE0xYvwUN8z7?=
 =?us-ascii?Q?3PJ8WXeejn9iJ/peKkB7TOytPAsf4ebbBJIDPCR91qmf7Rix0+zCcACaQ9+J?=
 =?us-ascii?Q?/PZd+Zo/NI5JhqomO5cqKCRx19sqy4JGPcVhAxNZXG0hXNVcQXEZUk1WmcPz?=
 =?us-ascii?Q?d8GLNYe60jSp0torxWrU+0o1cQHZvrjrrPNN69ydat+aYFCZhkY0p+M09ZCA?=
 =?us-ascii?Q?MboARe8ZoLmHzQvqakIa8jpwWq5xwRr3a7M/Frxx0r091OsPIMinlQg4dfsT?=
 =?us-ascii?Q?XwV++laPeUCQhIVmhZngh6jo1vfXdH/a9DPVIBrHm9E9VrqkVUBSgMzXXKoE?=
 =?us-ascii?Q?VwfBR2LYM5bZoFy0aKmaiCkx7WrDTKOeg8PbxvPpz0MD3qVm7g0p8uuluce/?=
 =?us-ascii?Q?1gpztn025JZgABXJu+8wYurCAA4r/65XKxC5Yk+ylkCD38bolHvmOw1dW7RM?=
 =?us-ascii?Q?r0Bq4RLyr7STJ2lIh/e47zDHiGHRSciajnCaVzC2aOoqlP/lLfCgsCZSBqXR?=
 =?us-ascii?Q?1Lf0WYYC0+AZ6EXaFXJmv+und2O+ITrffUzkM4sBhUQcz1eV7zCzDqnOjq6C?=
 =?us-ascii?Q?3kYgC2enwKSBaBxxXWNPA0RomqQuyZVfEMRXIgGXOWL+1NK67lb6PjJbIQ1N?=
 =?us-ascii?Q?daq7ybp9Xh39Ms6SWRmFsdNKeSAzhCrfMt/ywD9KSOR8zB7L8QgAXru0SQ/H?=
 =?us-ascii?Q?mE2HfeyXgpYwb+vChWeAUULKkf3h/a5oJwGr8QJaf5m2kajB1exFZNv0njrW?=
 =?us-ascii?Q?fE42rJzVrwbz7I0VqTw5FvroRkGfoNdTaAgS2d/LCGVaQTdzoUzGtErvI3yv?=
 =?us-ascii?Q?EoNHelUirUDM5C0DTe6ry7SliHNJLj8jCRNE+Cg4wy0R4uE5ImetaPYgsGnQ?=
 =?us-ascii?Q?jyZc5EacrF0v2sUerMuyGH2HC2zhOaHlYCeMvzESr2wyvWfR0/0LBGQ6VZAC?=
 =?us-ascii?Q?ZjIOgeFjGYuRTUOa+nogdXVswK+5KNdAaS6dtyVx5cPbOoHUAlTBcgH88Vnn?=
 =?us-ascii?Q?4vo1DxFW4Jr5lX8+neP2ti+xiOEyXlJUYcbdUQJgGjfFmvwnrT41Pu1Tspeh?=
 =?us-ascii?Q?ngnbLVyN/ieKhA+Q9ddBtOtVvDjQ6Ki9xr7DiCcWuh0iRxOhPOYNisqMAOne?=
 =?us-ascii?Q?71iORGjLn6LHJB1wL/4hy3U6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f790b8bb-2390-409b-9777-08d8ccf7ae4a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:02.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8c7w2qzZWB4EI0SIp2Y+SDru5m8gQLNlgqeZuZGU4Ta7lcYOFupGn+72wwcijp64UUSTzT+uGyFYsf1pOuBmjKloqpaHrqFlTKys6ZC8Zl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a couple holes in the cmd flags definitions. This cleans
up the definitions to fix that and make it easier to read.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
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

