Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2248EC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378992AbiFPW2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378861AbiFPW16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:27:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA37C5677E
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:27:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJQ3qD029767;
        Thu, 16 Jun 2022 22:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3tlXitOn0SHB1N4sd5qAJGjpI4oLsW3jh6GfhMv2Gas=;
 b=SejoFfnUBe2HVM5evqDgOgNV5WzVedH879eKo+AA33JH38yISOoR4OGjLK2KVx92DsnN
 hFzlCy+FMGkoDg6k9wLyR/zUazWJUZwQE/nCDSqumMup6xPdTlbCAH/nohffipWmUL1t
 FCnpa1Y5Z4KtMh8rHNNXGIdK4j6UUuVgw2j1kyYoJdQjIGRsc1Ba7br9TtKl6UQ0q1xY
 wAC0i3Bt2+ZsgPXJgh94NSlIrfT0Twfp13bfpTOeGvbOwr3KZ75pkjfiolCS/zFyHzL/
 nJRaqKnZ7rsCytm82IWy7GRbObnZ/zKySrvzOXfAg/r6oX9JJX/vhV4e7NrOBNKeo6vj eA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9m7s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMG1fJ013371;
        Thu, 16 Jun 2022 22:27:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7qjfvd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFY54kzlr4NxQZU1L7Ypk7ZtkS2H3k67vfhNw1MLj0SSV7INN1Wf85e4Wqhoh68HJbtMdU0s8JqohFtOtlZmTFGkQaI87Q3EdL1X5btHGjdCpEFv5Tp1cHWCPMqXWe3BKSvJhjyOxFIPI8XlrKzrwS2LdIFnUO6uHRWpu7/cR2j7AMjV3IN48sZebhvDxRKSsTU+qrfEDv87ogpy4tflSX0++NE5jy/iLj+FTQQqxa0KCk8/TkQqS1YLqQFygJEiC09AD6rNVO0e+ZYHat0//i08HCoEos/8BRzSoH6BgidMuRc67QleihvoC86tQ2kX0AH09UnrWu0c/AhayYx5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tlXitOn0SHB1N4sd5qAJGjpI4oLsW3jh6GfhMv2Gas=;
 b=A9Cu2yTohf3u2dM7jFKsPlmKbPQ6yCkmSfJRA7hKbkPbPwx5dz+zQ0MLgfOpfIzTNGPCKemptoBVqotTav5Tq1EZibnM/14q1bZmzY5eqIlPnQmZrr7+MG+4as9DXMbQ3DocQZBhfkyJdyiG64vPom0vxm2WuN3RCmjsnKgIBBK14MtM5d5q521iETY0OsuKqOKmsc1wi6HkdS3E9aHLPJTzQGzmUC01Is/Sfhu6mna9EXNEU0o3iPwgUQ62ygZBAanSBuGEgV7SbwdDCKKDoDzvVOdL+psXiOA4iJG3Gx3tFxU0PvxiCUQaSpytyXC0eSNzDLI4P4ox9CfIqSuxdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tlXitOn0SHB1N4sd5qAJGjpI4oLsW3jh6GfhMv2Gas=;
 b=sDJfPq0qwQpaKVMNOv6vtqu7H8Ahq3LLZSpWi7ML+VF5/sAZoxC31dz0YAdjpjAc+NcoDSvX0CcEnhTdQjFEYl1CIfypcBSCufiN1ZMc648BT2YN9gLZWKdv4ouqGnOLOuESmMhA7n7EXF/QIp4AXyzC+2fOZSl/lsf6oTNitUM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/6] scsi: iscsi: Fix HW conn removal use after free
Date:   Thu, 16 Jun 2022 17:27:33 -0500
Message-Id: <20220616222738.5722-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24ebd1f7-46d9-44e7-510e-08da4fe7710c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12676395F12EFC7F131CF309F1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2RlKB0uhzeDQVEQ0zrABfAjWGCR9owKMThS3U/FQcCOru+0IaW+pq71YzfECbhp+LWDDx+vlF+KD9ilCKF0IxaLxgSArAMfZJJefAQK2Fk6y44qm+WZZblbE16CgHdu0MvhPPkdm+TCqHwTnOlzkpAiMHDo7yPlXFIjv2QOubP2DbLjIzyeiLvsMAXNPbJnJoagOTe4RUx//5LpuN6UTV7uJWqgLM7wGbAljv5vz3mHiG0sYrslNoM32SQePtcc5fvK7aiVI1YOmu1TRkRhEyCrHwg9BbjHgXgCQcyWbWZgCRNVJePRt7jhcYhY+auJGIR9gSO2XqkAscajOHlv8hYe7/wbyexQffT0Z3qm2ZU8tUl+yd5SZ2AfrR+Xwt8oYA9GwGxKHZYBKH7+2ZpVhuqJF219vd0bwSXrc81p5urG+fES0i4pxgVeYcj+ArA1udZ4T++ypBmsI+bgf2TpkEk2QBEUoL3Yr1o9kh5ZBwOU2qJXhg8q/vl1WXDngjOajuW5c1eJnjCX7p9ZCkgJNWjuwQbBmJ+kQF5UA8m4pR2maikW4FM9fM/jUJt2nMxXQquIzBg1petNLgXkrjfskl7pnreD7k37NjVfnCslds44Oj4bXnpCvtmt49ZLC2cScT0AEvNT5nQu54X/8EODM3nbgC1Z4mpPp7np8fjPIFcLW1tL/MTVQ5sp9ErJdPrH37X04+oc5kbCLxx304DCwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(4744005)(5660300002)(83380400001)(107886003)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otyWUHuLaUUg57I8vbtFA7s9QJEFWicYrxMfDrAyOQHcyQjbzzVXZeDb6NKa?=
 =?us-ascii?Q?WLUej68zNqpbYGmN2ahfvLX3oodg6WkrsjSmmlqKzqbzJLA6kjE/m24Tzhwl?=
 =?us-ascii?Q?1Y7/WqaHvqvvOdMmVPGJkul2+929X2CS/i537sk7lcjrLr14re9LhKhtIQQ1?=
 =?us-ascii?Q?XiELhkXTQM42/qkqgmRy1ov/x3rcbwYBVRdrBEu2H1clLHyOzkTKb+Lmn493?=
 =?us-ascii?Q?GlVbRg7mJ7Ishzh//KxeOy/GrNG0N0m4YXZ1pDrQCG/48GBITWszjICsElhs?=
 =?us-ascii?Q?u4wV9Z2/kyKtfeduQue33Ds1szBdexfFoFiDuzA47BhmoL1CRTIPeCCLpQbW?=
 =?us-ascii?Q?OmWPF+sRRqUoe/Td9aM0u82wfvB4Kuttta870n+QAQwmFNYBNoezmGY+Hw0t?=
 =?us-ascii?Q?mlAhjSeez2aqzDrTp2XhyqHiRBVnXJlt3lcb0N+rWWUBXXpWABG0pB0MoRpW?=
 =?us-ascii?Q?QVoRG0/Zd2YsKeqcUS6t8Hwd4gPq/bggImVYxLHn0N9nfXX0kmC+N4aKl4y1?=
 =?us-ascii?Q?9gnTj8wLyiCMnmbiGxwABP+WtaheQSN8L5oQFaLh0tjJeQVbxMTPDZALuTXp?=
 =?us-ascii?Q?qegVOn/y7RMKHvyi5zqh54/kD3ZEWfjCc6SIygDbvPNk3dYgq2/rkZeKTIQ/?=
 =?us-ascii?Q?mn7tY5NgoGfRPLOJLXgEg7kJ2bliGH/HDHykWxPyd+xWI01/Au4HaAENqwnu?=
 =?us-ascii?Q?uO0ziEqnIjw9Pots0iLPUJyCeyy+LfrsooNuJJGtPUy4GbLP57MHF11XqG/L?=
 =?us-ascii?Q?6jEk5rIMwH6PI6Xyd+2eUJFPGBhPWJ1czpRiukL0raJpNJtweFQE30QuYaeb?=
 =?us-ascii?Q?LiOPGqvgq0F2qkMrzk7Oo5rMmuHXTOqWJbbA1wpjamNGG1xPv6ISo8hVDKBe?=
 =?us-ascii?Q?ZBUcmWo9oH0Sk0+tCxN2fR4AsEVbFlMvKFj6agPCYRMChQH8ygYvGyB6zo6r?=
 =?us-ascii?Q?wA1qaqK5CiOvjMZhnJALgkSKfTpWBHfSpfi/2cHyNxmpckSW2+sEvR6TDRal?=
 =?us-ascii?Q?mDrarTwNIEcEefBS6rGGLMu2JmiCf8d7CL8WGheGOeUu6CrX+To3k7yTnO20?=
 =?us-ascii?Q?VntIN2d3zqF4ATXHwecPxvXcK1tcpWukPkSKOtbAemalQndNoscR6h5PVGTc?=
 =?us-ascii?Q?/vfyMWDvhwIA3k2CzREik4yvwTxsUK8P/X5W/8r7+7aOnGlcievEeGnI5vAp?=
 =?us-ascii?Q?ayHhIDIfycZRlWMAEhB834w0hv2YKv6f8/hj3E97UWnYLxUpSpVpOiXFXoL/?=
 =?us-ascii?Q?PZSUBO8Z5XQcPaWuBa5JWOg7w3m2662IQjCdNwZPzv1Z+bFTRoWaBtKCCqQ8?=
 =?us-ascii?Q?xu/oNP58Y2JXQPJ/K4arxVRv5ZDzZs7n7MB08018IDtn5NKdanPfBczzztlb?=
 =?us-ascii?Q?tq1TKiDZ4UL9pEqlYkPZYtfy5Kyyu2khOjXThcn24S+GaUYYJyEXwUI+U5Wr?=
 =?us-ascii?Q?Gw+5WkMPM16WNn8D7UPsxzAi/O753R9cLVIFjNkUikixBx4fd2pxIrQq72SI?=
 =?us-ascii?Q?dZl7o0HiizQ1LScTA+YlUPYVjvM45lUuP+4SDgJM1b2WVdm+rQbcTIuLuxSF?=
 =?us-ascii?Q?czNaHG4Mx1X9qZXDmdDp0lznJNeyVEUflhfOLoaUmQEj/9hC+Bjf33YCSGs3?=
 =?us-ascii?Q?+TsDsXnaoxK5/v4xJrGiG7+WS/ZFCwZ2qDpgD69LO1MHBukTz26CGcj0G3+W?=
 =?us-ascii?Q?3hXRcHFhWvW0Dhns4VIcmRxNwSlDKCibAPujnmaUb7NKxe4utMxIGRt/VEdc?=
 =?us-ascii?Q?KAmBLmyc1n0bitvtKrYQ6JYLXiCnBt8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ebd1f7-46d9-44e7-510e-08da4fe7710c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:48.1049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThaVml9r38ZlBrPuYoPllkVy4gYEArVZyKiM1L3trm8KvmfJnP1h1nkewsHJAw29ILqMG6mD8//hzvFrMY6adLlEI4BChzkg5dZ+vIZjp4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-ORIG-GUID: g7cUX37zFGft-BsfU755rVm9dESjZfkE
X-Proofpoint-GUID: g7cUX37zFGft-BsfU755rVm9dESjZfkE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qla4xxx doesn't remove the connection before the session, the iSCSI
class tries to remove the connection for it. We were doing a
iscsi_put_conn() in the iter function which is not needed and will result
in a use after free because iscsi_remove_conn() will free the connection.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..e6084e158cc0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
-	iscsi_put_conn(iscsi_dev_to_conn(dev));
-
 	return 0;
 }
 
-- 
2.25.1

