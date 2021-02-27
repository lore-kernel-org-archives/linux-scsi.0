Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76406C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BCE864ED5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhB0RLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:11:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhB0RFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:05:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGx0ov175562;
        Sat, 27 Feb 2021 17:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=E9Wvj0H2DHQ+uysGDfmPsFtvTmQoayJyUcuQ5991k3g=;
 b=l/5beY5SqA1bYZcQd4yPsfx7bQ4trjfyUzHqagdFR3Mo1RqrhMo4X4/XQFdr2itd6YFr
 xILjRbNvEO33kNL5vhDPETNwExb7IAp1JxicdR5NVhuSdZbB058KZ5bcOVnHH35w88Od
 BPUwuoXM8wl22MoNKSK1D+L9o4vCJ+z99U8uHSeXQngWcUfYGpulqArwlTTPFC8L+J0r
 CzuRRlRf8qRmRlV6hNVUJ2GRX/oyUxlAfTDRVnN9IDDeqAjvy8NnP7fUietKaeoQt0U4
 /4G3I08bk0HdqFsjxSLUYKcbsv13PYjeHHlgejOqWr1SO26UTHEd2b+PoeAHSpNJCwI2 Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqmrptd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbh173209;
        Sat, 27 Feb 2021 17:00:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQJnsyxqv6y6gOsPcED9ZdUblWW7qPV2TogqZowH97yYAOnefp9WiHoqY2jUCBTxOlvJ041068/UgqLKryAqx+2CHb0KQbTdykWrbl9zonNJ1Yyq2paiRs3LCsTafOiLA3XG43w1NKfvXHTsR/iIGzkbZX5QYQ9wTZxrNAva4NNnmsU4PoduKxx7ibEC0mPa9STiHBAYLSRv5hR8m4GY/TKBai8khKs+CrgU24HqqIFS/zUwhyXrV9j2V4jwveBiGxq6W5u1J4bS5x1gJufvEHQa4xVZmU/tjhrBGt8hUhT3LbrNSsVf3vH3bcjb6YVue/WKLwtHYr0ZwoP9i9JySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9Wvj0H2DHQ+uysGDfmPsFtvTmQoayJyUcuQ5991k3g=;
 b=d2pcdXQNIVs4T3i5wYgQVPzRNN/GtyYVwn7FlMdr01+z8PlMMHa5Q8G3wNYRaoF+DzZMtrCIsEN+RLcN5pXrnXfYlkq/7AS4D3Dz8E5lNyd/V7uuirk4SkXfDqS4ck///M3RWkFg/YSO/f5QsRovSxBPHq/UwP4Um5sQrfTfgJCoWHyde2g+AqbdSXWvR2FmqVnzDwBe4nS7wYm9suy36MX0tPvpTCjygjPpR2kz5EydfZ2JSJjyNlf11Z/0m7bTzAdeNKb4K9miylttbZtlCc+pYFi2Lcw30HRb3rmKfu/mZrmwe4FDP/bdc17rkMgFd5UfvrJJK24PQtwWyhw0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9Wvj0H2DHQ+uysGDfmPsFtvTmQoayJyUcuQ5991k3g=;
 b=pnx75hPvOB/uHIh9wVM4atFm3dNSr9z/O8i9B9CfoKKCXWuIepuLZcxcswF2irCcckbbDWR62aSYwZhJI3gnElgy/VEu/fohr6x0Rkew5jNV4ZOmwAxjxUmWK0ohFatKafZCtEfQlikqHj0/9Qibmd2zeT8l2kCj0/fJrhSy9Zk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2538.namprd10.prod.outlook.com (2603:10b6:5:b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 17:00:33 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 20/25] target: cleanup cmd flag bits
Date:   Sat, 27 Feb 2021 11:00:01 -0600
Message-Id: <20210227170006.5077-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2af9a3c6-4d09-4a88-2197-08d8db4131eb
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB2538F3456837DAD69A0829B5F19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNOqb5w0I1yDl+u318JoBsuB4GEGpQ4MlEHx3DVBgfJDdgJsRYCHRdgLAAhQAZY1FdwSVj9YtoqtqT7V7HqO4aiiEVYIkBtGwbeYpoVUuHzesEcqSCsdJOk2FAMJ/+VEdXwkavJjxr07oB2esoxIaL3z2iJ2IN3XYLzJS8tmZDu2Whj0iE+w2vCNrspJvi3ZRznsYEr6S6ae00VyUeY16A0Kd3FDKV0QBu5hqLZpAgF2owcEmmEmCRci7VqrElR/3S+5NcmoeTjjX96qJpouRBo47gPqDg21oaKDfF0k+dopEfils4KjiUESq0Gxdul7PvpMZirZzYVyCtYKJpmJjrctsHD+Yem1kISPX7aeGu/JZD0gidBSMNduyI2khmrrYZc5wTYO+A5izkqqnb5rv+zamUTUHwMott7dFqE01IZTD4hKn54g8MD6s7IDvxl5/n6Ddt7q9lvvQZ5rnSu26OMF6EzX9olbej3rANLxVAfCwYtvrsp0bS0i6UGiQBgyxduejR909ZYTWl+ghidZmgAp0k8gA7LOVTd9tT14NvXT2x7IUZ09Swjb9gGblJeVtnWxFmKFLSjkPzbGJCGUkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(54906003)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f1wUxfG17ki3DLUU+rrzRqdh7ZTisz8P2ZtHg93QpFOUA8Dc6FXxCpGCy/oT?=
 =?us-ascii?Q?bXrXhdVlJgMbDu72FxDlQixH6r6U0x0PZjJAgQlov1Gg21xa7iz0fDX2dK68?=
 =?us-ascii?Q?1m5+WJU9oiEqlhaxMQj18y6ng5Tdc6zZDDUPPAdeGoUII07WGQjqv89FtaS2?=
 =?us-ascii?Q?mj6u6OEOJEp6LdiFYvd7GRYbmXLt4e4KB//woW+eX8fLIulsnRu5vvGKwSkj?=
 =?us-ascii?Q?e0kJoxV+vxYm/gq5uFF0pYfkwSVvL8mRly69ztiQVgGxg2keXoEM88PAQTnZ?=
 =?us-ascii?Q?Wb13/rk4l6qI0DkDj5eva8jpf1NyG3Yh3CtRLRkVxReWT6nO8qhrkdW9m1PK?=
 =?us-ascii?Q?loRYFpE7l2dltzUmlSuNvPvxZE32WgKuyq+njMXFk4zrwvag+Arr/CdBS1qH?=
 =?us-ascii?Q?P5zxe4thfK7vNgW28iuu7aKqIHf80LryBjv13ASS1rHsi0miAZxVmH8MYFZM?=
 =?us-ascii?Q?Z9iVPEW8HFZ/mcLrIlJ6y5L6TFToW0VV37faKJGXPy//4l710dz49E2x7aSw?=
 =?us-ascii?Q?4PngzdB4edbh9TnU/cR0SG30JBfcl4lAcPQfLz34FdII1tpiweWMQT8No6rB?=
 =?us-ascii?Q?GWQjr6bZRuzLsgrJjEoblaxjxraoPhZJ5gb0KBZJo/xngUhkJrTPa2ejo81h?=
 =?us-ascii?Q?Ep1CZ/A5n2P3O5Fj8hSPiNEA7l/p2nNL2XVULqMctJdBP09+j21u2vdHxQjY?=
 =?us-ascii?Q?Eh2CbeQ9K32TNWcuazCi6dLVzeELkJTMvN2TwFVjybfUuikR8lfFM4++U/8r?=
 =?us-ascii?Q?X17UX783BIAwljBMdhPoBw+OjUhpD6+X2Nrwn2Y6H7S1yHy1U4+oQsiTmhgZ?=
 =?us-ascii?Q?jAplNGyXn+cH3PdfUyMl1eAxoI4Gc544crC9gFQi0Fy//eZpKq/jMLLmkrbP?=
 =?us-ascii?Q?wX263VUHXZZrhPAKfnbWCUBbH40cUYUcp+Ksd20XDHjLZVMOAfi5Y1EGsChD?=
 =?us-ascii?Q?3Y0u146UO5O37CR/nytO5EvGraRAhhbEBdJdMLBJ6IGKUpajRrOcE7Eq42Si?=
 =?us-ascii?Q?RzdRKY32xAwmPWkEIOQCvnQxhZ0gVWezFbJqEw+e/D0/w+rQhgfaVw/Qk7ee?=
 =?us-ascii?Q?026dn0DK5srkrMmFogm4RNsq4MYd4m44faa5AExQswQse2rQ0IOHsR9Au5Qx?=
 =?us-ascii?Q?LnsxRBGxf4OZ9C2OeoNY4WDCknF+z4RX3YoEE2ERNoBpo1OduXjr3fHj38lA?=
 =?us-ascii?Q?HrsdznYunvloopMKDWL+z1r+Ce8FIC4g/rYjxFkLAGO74KkwKf33v+ZZNa/P?=
 =?us-ascii?Q?hF5hDiESbTXdydK1/kgdF2hwt083+D3NJg2jPo3jp0gR+q6El0Uhxjl4CsPs?=
 =?us-ascii?Q?DwPKrZzYiY4fH1vneAgaqrMH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af9a3c6-4d09-4a88-2197-08d8db4131eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:33.1584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79sOci/vMCI6tbUpYw1T/OrR1OrYDrNPdrl8i3yOCCnEbhodO3nrgF42DE2LhrIQTveqElKvJOBOwb+SMUOXG2yCbK55GrylJRdbdXC02Qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a couple holes in the cmd flags definitions. This cleans
up the definitions to fix that and make it easier to read.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

