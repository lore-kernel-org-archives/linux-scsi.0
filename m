Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A840FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379156AbiFPWqW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379133AbiFPWqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4686213F
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIe3jq009842;
        Thu, 16 Jun 2022 22:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3VA3icLDYUvlEczZcTorlDcaSbBLkdOZhbgydxfayYk=;
 b=RN9V3BLMJTXdyfUIbLn0aSKjmfnludz/48vIIbEroqcX6BgwvLr7Fi/vk56gAV/qpgjr
 i73WqPVP9ojb9IytylmarROrq5xCnSuy87FnhrQkG83PJvlDmOWf/psI5oB+3JYMPMQE
 nNDRaT6DphD9QYDC6FtNSANl7jz2YNXMOtuWqjtvzkFw2AxnrB3eQE/RnjA1s+U6Pmwa
 Ij9bsp/2Vl+draPdnXQqc33nSku7xyyF8aSd9PvWCWnAaxrrUh/V2clc6T6RKiHngSwh
 Ik/g4TH7Gkc3kGGtNvMQluqNWchqIWy+MbM51hv6bwBhk61mEzr/Pkf1m3lGdezraiU7 0w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktmhk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaOYe035621;
        Thu, 16 Jun 2022 22:46:09 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmq4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0lENTGmwxmu6P7bx2Ix27bvMBSNvXt1Pj8uu1KpXW/S2ZeFYKPy69/n1IUpN4p+/d2fhG8qM07t5wlHfnPcBcmo5TTcVTKMj3chrv2uclIdzMdMQ3lqWfM9RzFxt18mutUtaoM0UJIPXTTu7uRWBrpNrm0bBiuoGh92suJ3SGNu7PMp3NyVUpDzyK7dII2hZfy9eHe7SYl6F7Da3OqPZo6I0Mlaw5uJMruq3hF9NtE8x2bsy/ZN5UELJQ30/H53l7O/v5Liv7ToRkOruj09JNQSvp/+J4Zq2TSTzfca+dltzckeSGflkKtnuSQ2Fg+NeYermlfcOnz5ZEGOw+VCyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VA3icLDYUvlEczZcTorlDcaSbBLkdOZhbgydxfayYk=;
 b=GTFwSSPGj/584gDlOi4noKRKfvxQlmrZDWM8nLEq29felfigpnZ8tglzkNqDttpdHV7474zZZ71mADKM/YVFJPorekbxbZQ4FaCf6GVXiJ71XYc/fpMMrok/KPwkFC50/i01b+sPGBoNxgWTMy7hsL7nhgStPsgTN9YxReDeKqwHdAgSI3i22xM5NlnHPTGBGbfmj/dcybqKEPR0IVsiQllh24s52CS/wVCMff/aehhNcQur1sNzNWNiUeKI9O61Ec4AJd0PoBNMmjHBBY098y1quLDiHntPRfciO74le6papQ7g+QjVF/9XruW7zVCVsXTDUoYxkS8Zs8AQrugtQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VA3icLDYUvlEczZcTorlDcaSbBLkdOZhbgydxfayYk=;
 b=hDs635L/1RVRr9QqzkYR8/d+ZmFcUVYbg4oEcE+g4P+Dm24kxnB1zExxyKircKcCBHsvCqzfT5C+nS1EW0+a+LFk/yB6W/xRfrf7fXEvc38rzBrkMJDhh3aZUqQKJgRLFWErepNhVuYeUw9lCNAocrKJCR34+UyBr92Yl7jomfA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/9] scsi: iscsi_tcp: Tell net when there's more data
Date:   Thu, 16 Jun 2022 17:45:52 -0500
Message-Id: <20220616224557.115234-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9aa495a-d296-459d-dda8-08da4fea007c
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5617776911BDE75F037339A1F1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8A9n7604pMoYLDdJTKVklD9LUgKawa7I5/AeOMjOo4egpO79FzxPxabxCHDx3T1i07HfvFf2IO8z86hzoKlm8uBVqFCoo/ncAbFdjH83Bi8y0gGi3M9XLpt/oJhSkaaMrUhiNwk+HUybvm2CGOpyiGHS5kDkOPg5E6R9xLkXqO0lU/01uJYqLriDPHC13fhZV5Xl95hj3OO+t47kDbufqSF5AVPDJPeB+1RDDvShjAPkpAL3aJvKY7E/Z4rNMtgzKQW2pPfqwa7Sev788nvGJMdKRfwoJ0/XrUtAU/Pff5algIW4sDgVUok+ioAz957QIIoxzQ6JaJ41JDRtJxg75QEtHOIbnH7i9/AEEQS5pNCauJC3w7lzdmI2hr2tNq7qXwZkXTZi8euwK6Q5v3RLlDKHlFyhjV4qMBpeSXEbyLRiqtIkn4JvvroH8sUNbDSw1e1ZVN555K8mKqiDfsiXf+Fn1yGEIDhs0/ft5fKHNEXuosyc507YPYVwaX793pZ4kXySctijdcN4ktaprxwk6F15zgZmj6xeWfIOq/jJ5pv6rSY/YOwsy5M/in1bnF+htJa31CwohFGqNaquvYyvHnna3ejhKMrIqSq61HS75mD29wzhCQYmq9kI5Qbt4MPMwWD7PIXJ/UFYpNIDvmQycGU3i23UElnXUs8PPommCHQM5HQ44/Rc7ogQFwJdNILfjTqOWW7Gu6xRV3ovmRCDXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(4744005)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(107886003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OGJ9Xy3r2VEt4PIsFX/9wRwDCYrtb7IQphDphxMIiyv6ovbJzwvedqE9ZtEY?=
 =?us-ascii?Q?irJmNmGL9lZkFrBVYXMCxP4alVCyw/6D6qH7M4oFkY9fiifJvhjxxkY+QFJx?=
 =?us-ascii?Q?EOMrFS+reUsV0b1GRnRnDlXw2HJ+iUXvpzg3jBD7ZIi9aBZhijPVPeROcy1q?=
 =?us-ascii?Q?1JCNBwueUlGPQGnqrfyfLGzkfH8lQNl4H8TDVxZVH1OVpT3JUVWBdYFGm9iS?=
 =?us-ascii?Q?OvVstoz5rqU/1gXfrgObcvtXsrVezlzF/bQ/YJYb7pMPAhR5M5uyKT7/Xv37?=
 =?us-ascii?Q?tWUFX/JpX0V4UBfnwpTKoiIAH1moHEEcYjLVUYpWxM7tFq84bwVurjTKz/Gh?=
 =?us-ascii?Q?X4lPSJvsGYLzqjy9jSW+iGVJs71ANvHHDvCizIAByjIOiYnksMSkh0mcOnqX?=
 =?us-ascii?Q?/g7ubNtS6W/5+tSstDQlPUAvKc2nJBRNGCEOZz/+p7/wxfJUtLhUWjMKveG+?=
 =?us-ascii?Q?I/XglbvSVi+j6+Wex3kOLNg3g+sk11H6CJowD1JnzhlsPKmUXAkdAQ5eHUDv?=
 =?us-ascii?Q?uAQk+6wPrUO1/qvG23pa71HIAguGHqanSpUG3qyBEGBW7HuL7I9Uzp96CB1C?=
 =?us-ascii?Q?T1CFIX4Ob8FICWN1LqgzKQhQNK1uDjE7yjn1kVGb0m177L2+Y4JUzi6b1stq?=
 =?us-ascii?Q?BKYBaMmdj+j+sXWglRMy64p03YgXLeNOGfmAk9ZYPqTYZBBFAPIUK4r7DVHg?=
 =?us-ascii?Q?PUFpqvLFY/nxRGMUuWdsA5jUAIwud73Im/YP/jrwxXkI6AJfLqNbNSqcqNEL?=
 =?us-ascii?Q?0XXKtzcrJ7MbnUl0Cm3jS23LoAD/guSn6W9Bgkx7ljVTv/UqgIuViQUHUazO?=
 =?us-ascii?Q?WPGCbidR22/hImQ2PHkViax+1fii8yapS5OWyuMd4Lw4p/Rzx+6MXbbGreg4?=
 =?us-ascii?Q?V49oW7KpgBSJMIO4aXHKvJCzFZ0KkTrX2hX6PBO1t0C1gkmIOynWjhd9DZ8n?=
 =?us-ascii?Q?KPQGJ7QuYOVZOGQF+5nq2K6JBk94qBy4TwB1oUOMi1A/t9qGUFZ0mhWy7dGh?=
 =?us-ascii?Q?UN3SnDtAa48zeuutBy+x9GuC7kFVr24O0LdesYXYPKXVSe7Jjdt5cotSoNA6?=
 =?us-ascii?Q?R+zPmvE4HszaEtRimc3T4cs4pCf0aflBIwRjCawfUWgdURc/suA0/Q/THGUe?=
 =?us-ascii?Q?KcY6Cd04opxBeBu/bzAO+hElMkdyKZO4MXGB/kkxQCQU1umeQDaQXD/5xjJB?=
 =?us-ascii?Q?BFmL7PLw2QheJhXS1hm2aCd42bDLsda+e92vBZ2Nez/q/+tRWuSQAmV7yQ+O?=
 =?us-ascii?Q?JG1wZ9acxP59CKL2fcOZyJazyLTrWkcdA/ym2fc2weWFlM4C0FvOlxqpaK66?=
 =?us-ascii?Q?keIT5hSnpOIhMC7cZjVUQhA/yNhg4LwE8UiR/1C5WJwkZgDnNeno596u9G/n?=
 =?us-ascii?Q?GKAOU+MUP20qiqotVpukelh6wLCyJcJESs/jHa2cTjIqN+Ujic9oLegMTUTq?=
 =?us-ascii?Q?3FLKTsK4ZtxooFTzDJlRFn18QtkPrtnYVkMAY1gRJcY26a+y9xn5rIOjTs0r?=
 =?us-ascii?Q?hrH/zmjgaZCIikorGldU5SBp3kxU2K7OAx5ZnokDKyowSJ/hhSGn8izYM69s?=
 =?us-ascii?Q?98cqwvnaFBLhSfXwyeHbns24J2CmKQmIUsE4u7nHC/3RP7r0FoDt34d5QwXj?=
 =?us-ascii?Q?0URfw52eNxHulsaRUfYNifICp86UIHmQgN+Iguwk+J2s5Lfx/cSMJnn+rfv/?=
 =?us-ascii?Q?wqQbIYxoUq5hSCMDTEE1Y5snAoEMmP8JY5iO69Su6FYj9U1/8GuWCblG7Mzo?=
 =?us-ascii?Q?fouXr13l5Zx5PBOiYhfli3coj7XbWqc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9aa495a-d296-459d-dda8-08da4fea007c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:07.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTnCjEsKDvyQ8ZkVgNnHkjtCK8IJWBtPSkdFGGfOcciOGTl71969QSwIUHPlRa9n5nji+OAB8DbhEZObG62LMpRulG4TlAFVvVuo0EhwLlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: 4XspC2gTlVK5yz2TEFZfBKpwSy_c1B5_
X-Proofpoint-ORIG-GUID: 4XspC2gTlVK5yz2TEFZfBKpwSy_c1B5_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have more data set the MSG_SENDPAGE_NOTLAST in case we go down the
sendpage path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index d6d329fbbfcc..df38c6c10aa9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
+			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		if (tcp_sw_conn->queue_recv)
 			flags |= MSG_DONTWAIT;
-- 
2.25.1

