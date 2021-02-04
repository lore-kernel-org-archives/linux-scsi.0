Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A0DC43332
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41E364F44
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhBDLhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:37:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbhBDLgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYqI4072846;
        Thu, 4 Feb 2021 11:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=UIG79us5tdcxA1pQAmmj93qpmV8RiUwAZv7vyNg/YH4=;
 b=Hn0n9IgkNXo3aDymRwbez3nnYo9+UVKeAyR6MPL7pxVEyO+e3Vv/KVdv2cKhyIiFgROT
 /7UFjR1pfBS4Ckgexs0Ai8zbCGgur8WHgj4NHzG3uzcyos6Gd3jBNXY2kqYbRiXOZng4
 Y4Brynb0SN4D41hBuqf4bTvarZw5YAInQ99dktb0/oPunF3qEwND2XBpc1U7Tx4lrFB9
 GcQdrFDHec97xXX0zZCxsnMZWp8r5MRwXRFhd/jzZZtqt3OWouKpkIdKSTJDHlEWW5Rd
 kDDWKmuld5voj5fCI2ybk7dku1Fuy7fxAmGrXhejAA5f6uDZiLF/tORW22pyfQA1eBr1 pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvr7h0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYfZX134897;
        Thu, 4 Feb 2021 11:35:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 36dhd187uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFAe+GffOYx2PGm65Up/VE4laqdS8LHl65NsGdK86R6hpsmumJfseiqdseKIprwi3KfPig2Hzyw2saM3m4JxRrnZL5qwjn1GVM+NvfFczDiXdOqbLh2b2JYosMWT+YL8VpSGp8HOF7Iz0DXeh6jBE/QCbGOmd5sYbXrhK9coF+UXfZplRB7UrxbZV5XgBTNc8qLFv5mjxWfLqqpLvStpn7nID4KZGluJfWC8uSpvMjBPrZ43IK9ERFF+rVoFfks7VEA2v7SQrUofaBOE05Gm6xwJhMZNHZ7IeMO1/xQs9Vb5ISIVBEs3vsqy9I00lNyRJyWCxNy3G3Xdj/DIN1yT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIG79us5tdcxA1pQAmmj93qpmV8RiUwAZv7vyNg/YH4=;
 b=O18/nDtZ8hV0lew2fKV9FMDFXpuQFndxTBGb5L6ZLA2RuzonUJlMUO+e2ZAV7XFSJVGClKG5saVskDKgdwkXDTpbVU96MILMpEI+98878Mktf9FEUg09oU+UTY7NS/UNI8tk4gbQQLaxkV2mPYheISBLF5lsQ3tmrvbRP4mlxRIoELu21xX39M/IFaRt/LSaCB59XL61zkd1KADMzriiN9t4WpTMzh8dSXkW4y3VndeeP5f+KN9AFiw1f27pl7YFr3ExwPFETQc5vi0DAX2hoNayFL02G7LI8m2W5XVSqmgrxuGdJ+yW7GHHl2DnidPJQkHER7amnkld3idLRjfTGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIG79us5tdcxA1pQAmmj93qpmV8RiUwAZv7vyNg/YH4=;
 b=lqmEx9DxJ36908r6yYlUV6vdUN1sOoS8QYhpLl5zkJvrEgmbu4l65I4NUSBHI2ZVZnk0AEdj+egvLdS0T1eawRwLk3ehG/M2BxIJk0orxAyG05Y5FXY17uw/vGPdTsxs88hwih8sTK3f2V+SjW7gyFQmgDBKjLAq7DdLF+8MCZA=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:31 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/11] target: cleanup cmd flag bits
Date:   Thu,  4 Feb 2021 05:35:08 -0600
Message-Id: <20210204113513.93204-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6702da38-a0ed-4506-80ae-08d8c900f9fc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480A1D1892A6A65D66436F2F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QP/G9CYjkWKHxIG7q9oFr6Qc3ZDnVCgH9rWiojsmEWqXTxBoe07rwr70ZcoSkdi2Um87y6bQr35IqLbBZ/sIOcAWH+jNsUTwBNgTSaQYsuMTHt5bnYD1fNJLv/jIBbJQgJHRLYgcT8NlnQA3iguj28b9axIslYc+5w1uzza5+caSgasguBUeS7Ux6TVNAdlHHVBghzsgCxbkQnPCyS2IVLz5pcbRcbUeX7VA6Ul4KLytjYIPrP8m/dkV08S7789UEP6M/e0WDsP0pmN+On0QJHvldoutpmoY1hZjfEDREeEKIaFF/mHQe4zkk3Q1rfVwCBQbwhvv7X9dxpPaDYyv3CPu6VZo3FG4VyF+u4W93+4DGEP1d63pT1cE3st7NHnkN8/yajSU9EA8Gazy9UyHNUoQ4MKBHKhAq1F+9R/0WlJUvLmR0pvCcip1VoIxTH1C09wBFwevozCOlfV+PjUsalkRr5kJohN1io/RDEGmzguSR0k6dl+DsbHyDjxkN3sUmKOs9KPFJBfbuLV8uXc+ef0H2jIU0Ktc15idg1n79r11P36nKhfyHO4Z2kfcmrnVitjFN5xOktw7rNzOSwTpEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GSxU/IzpEYjXdCO8prjhE0PWiBM7tfsZ+LaCrv2kkbX5EKtrcuePPZtW7n/H?=
 =?us-ascii?Q?LQ/LxUPVijxU3fth8hjTh9gLQsuym6m/Yz5deF2Utw0PhxluKFoeBHyaOlzV?=
 =?us-ascii?Q?ppA9JiRWbFdni6qCLQr/zqLXEngM/y60xRbcBJfHTbsmZYy8apx16J9sKC+W?=
 =?us-ascii?Q?ePZUCa3CLCVtIijAaI84m6ug4xzYJCmoAzYub5YL91Gt2ilXTyxJRgmPKEM/?=
 =?us-ascii?Q?BouAWpCCaiFcye9wVAT/+VWXZKxg9UpZoMrrKGSxIbkFzpzUTlCk4kBRxV/4?=
 =?us-ascii?Q?tx6ApBlrRu6MbDlshaox+uBSw6ZrmNuCaBhpaMBLKKVp36/f+RPrbmInV3tc?=
 =?us-ascii?Q?HjcTJ22qzjLNX6MtpobPqaJ6HTKkfeYyi2MQ1JmyDSf48kFgpD3xplAVFdRM?=
 =?us-ascii?Q?UnclaA+DnHqnNrHSwlkZzgdTbT9yYOlhdTLmrqGSDxKkD9U+KlnZSFlkOuQM?=
 =?us-ascii?Q?RQlkyAQJR7+MbDAr+vW5RdkLheqefnp6NaQGeamGd0wb+lgXuhUiA2kgiGq3?=
 =?us-ascii?Q?GUramKLHQcMncnMt0uBfub9a+5aftQ2WlfsHowf0k8FCGBo321zx4nqiJXnF?=
 =?us-ascii?Q?VJD/c3q+XLcHI4pUa+zdrcJa2Hq9YtWARcAAtJSCtPGFyTa2x0mpst2h4vuU?=
 =?us-ascii?Q?/a3Uv8RR/V+0J9/8nObNqE+GHLB5jjaGAfON9qC3vKyU2dn+v41K93VBR9Co?=
 =?us-ascii?Q?8AVG+iNei7uT2jIkNa+YzSBaqcSXljihgLhvznBgvce2/mNeOPHJ6puk/1r3?=
 =?us-ascii?Q?U4oBOxad9qC+4r8zQfuec4Hy2i1wTuqCLWVQ+k64F9lMeLNKuTj2yCoMen3d?=
 =?us-ascii?Q?dyZr0ecZmVt7sWUOeHYRflBYqeibor4jF0dQ9vq8tsu9py5hk+xSnlj/vYz6?=
 =?us-ascii?Q?qYzb81HfRkhM8ZskK2QAgVAX6m04upPeIlYYNs2cA5u7gnP8SaCgMBKBkgf/?=
 =?us-ascii?Q?daL9GAJF9NpjNUiD8oGnBdesqNkwVYxujHs/dVSpDG9sN8EJNj4f0ypRegRI?=
 =?us-ascii?Q?S+0COBlCihMG4pbd1r9Rsp5dKjNrLgXl3jmQEs1y2u2umphoOTgu1rAfr2Ad?=
 =?us-ascii?Q?lM6QLmnwcGwoE3tMiL5UlzPabu24h8w+lB1/8KZgdPcGV669mtOLh9Z2Fm64?=
 =?us-ascii?Q?drA78V/RrldTdpAo4wIzKg0SRQpnTSDTx0Zin1SyiP5u+0T1UXVmtFOh8Fka?=
 =?us-ascii?Q?MiQFwyhB9PoJKYDHWHCLOti5tKCy/A+sFH3A/ijBb4l75KYt1X36Ej/ySyMY?=
 =?us-ascii?Q?v9PFv5iFlpQG7BlKb15c3+GI6JvRClbYu4elf6+6HQVQ2Z4aau+4GcvUTlEV?=
 =?us-ascii?Q?jP/uI6R9e889TlBTY4rurmr9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6702da38-a0ed-4506-80ae-08d8c900f9fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:30.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGR2l910axstBY9JouWG/E2ieA/9Dh+iI/15SosIfGyIZzCDR4OvHbuXmcZrxlqCzDMHCNzEiyUvbMRF5UBCb+aPp3KULEz2ONZh6ChL4xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a couple holes in the cmd flags definitions. This cleans
up the definitions to fix that and make it easier to read.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/target/target_core_base.h | 38 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 97138bff14d1..b7f92a15cd1c 100644
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

