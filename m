Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9FACCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbjIEXSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbjIEXR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4421B6
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtXrP029033;
        Tue, 5 Sep 2023 23:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fAOCTf0mOfg0GmgaiGHbbYGPWx4hGLLimLoI0hEJihU=;
 b=VkQ9AoFv/hgT2Kek0x3WcNFJZpR6MWffVjCR1+CsiAkXpjU7+8iHfsxkFO+ra5p8J9SS
 jrNweG74O518TP0EigaZGHAEF6DzWJQ+xKZjWiZrSEZFCPgVgexlJvqwuEzObUNVNFx4
 mEx22FLaImhh2kbCJDzfnSNB4VUKcDIY1G1Bq2UFKknZ5jcAvsvFl5gH1ilVhP8yUEnJ
 vnjr5pUP7+7l3X+lB+gNx8da3rXUprSSI/xcXJf6V+fXxfLWPiS9BeKFgamHXfEn8KvJ
 iyK28WQE0g7VqqCEVoKleyV8OtmnsdZfV1r7pPMI+lLDkb83l41F8E6DFquZ1XS3ZjWp CA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdj500w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MD1JR029122;
        Tue, 5 Sep 2023 23:16:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dy64-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqNQTknZk72J7tmbHUMT8JjtR7Sm3DEAi4p9BHbkoWUf4DQXTVAxDMuTO+IkNjywNSeHIRxjGekqmBR8dvGuwRCt6N6Wx9dUPco0xz7NqlR72Hl5/fuKEHwvx4685sXF/UMqA6VZ8xMU06vcUbkVrVjbrPuntleZafXHIBMMXhIjzF9puPDzEkOfm+assyGlPKKi0xFUTwziTSzwu3FL+K2IziDgJ8lj905WoqqvsTZKggeWni+SJ409xW/1PE7nYAsGg1hgbOkQK3RkdqaysqqIfWvymplWPUVaEScLioQdaalr90MvIpEeq8iXprdH0gOnFg9+fNcgv42sZD+rMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAOCTf0mOfg0GmgaiGHbbYGPWx4hGLLimLoI0hEJihU=;
 b=IjJlt5H3LaiZLapD0dbMQAgMx6FHLciLstppmGWD0pFrAmmdku2V8+TSiwX85pTCdHC7howTrzI1yEo4qRyUyBUYrL8QNCNdR3xqC1frzwGC23w1hV9AM0/CIVkppxGTZzmZzjO8Kh2jEOZOvE11QYiyfyX9e9I4/y+hzTlB7KCHMuvndva8pIoUvla+/t+AE4Wolag94nb1bGw16D4+7DCVxXM9RMYlXh3drL4hdK22ZPu6wt7hD+xlDMojn3TmnMpWqUgKMub+Ky8hJXi20zZPFdy8tvLA+vicm6ivZ45hfYByhMFUR05AVUQTKDG3DajOAqyrxM+iHhyhi5H2lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAOCTf0mOfg0GmgaiGHbbYGPWx4hGLLimLoI0hEJihU=;
 b=xLUesZoQxrRyVAQrgRtdd5Dl61S6waszIwFsteJOuBGTcRbTARarN+7Xn5xpR+GxySza1CnQhgi8A3qFIqps7+iEDpxmzhVyzUvu/X8cnKXd5/o1WSDAiDVJcBvKr73LGQ/ZjvD7a5aJbj42QWMMM2xElp+inLymGHV3q0QxDEE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB5287.namprd10.prod.outlook.com (2603:10b6:408:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 27/34] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Tue,  5 Sep 2023 18:15:40 -0500
Message-Id: <20230905231547.83945-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:5:80::46) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e789c3-e3db-4127-9e0a-08dbae66287a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzSJT4pJrK9fYo8h4dXD/p5fTGDpnCAi+LamLIrKZ1CQL5P7t/77HQo7NiiXVqYBeIJrFu3MSz31nAsA2xgRWGVZi2deMd0HVI+OrCr2IEbdubRAvvcLHqUHAwUx6tdsDRmFzUz6e/jEfKxi2CNuVb5ioqAu0DM2d4z35Z3dffqot+5E7M8yP6hg4vSt/3iNZIHgTbsSKrYln78CKe2uzY9qHPAHLkf7WtzppiLu5AYOSgLBxT/gK9Y8Qr+evb2JeecDt4ftgOHmlPJJY/HYNM3WA5LqmLazKbHMWtzQ/4L4PdeWjBVYabXhHoxKR6hIC5HUOc8V1nYWvN9tSU/TajP7IuyWK+MPoXIq+zVAGJjylXEzRHLCDrE8xal68pQmnoBpIcYuy+G+VS0I+HftGkn7pJGi4DliTL5MTteiQmPz2wHkDj99YGifgOnnXtnJ9nQDVMLU4IMDlq/OlARclNV6jjom4GvT9d2v/9iZSD0/2AN3cZMeofd2lFyf1aEofUvsZk1ehXR+ERM7WGaau61aFOR8SwGLdaP+QO2vUH3GH5ydjZQJiZ87e0Q8BU69
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(39860400002)(376002)(1800799009)(451199024)(186009)(5660300002)(8936002)(41300700001)(66556008)(66476007)(316002)(2906002)(66946007)(478600001)(6512007)(6486002)(6506007)(1076003)(107886003)(2616005)(4326008)(8676002)(26005)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CU090Ksj5GNVusYV8F+OrCqMNgzX4PGr0xZEM14g5Gmop/uxivTYTTtDxtAs?=
 =?us-ascii?Q?Za0gxPGsTUH0gTNiFlJbPWGwY1WWqVI5U5twMgO1LO7DURTI69TKelDm+eES?=
 =?us-ascii?Q?deaPUJdojEkrMmtyXKXvFiVjkCmcKnDbeWRQkHyMhhLia8Hbu5cbLp1GjvJX?=
 =?us-ascii?Q?1o+bs6IhcMr1O3aOI2wmYMnCfuUCVAV8jDzszx5LYXKSbAPmVUwFFbvj9sVi?=
 =?us-ascii?Q?wBnTv0fjPaTYJgr2iICHzAUZ/VAT7nSfny9UrLKlcXUxSqWhyE+oPzr+N6AN?=
 =?us-ascii?Q?nnGm7SYJFop4Wz1fUEr2N98h9oJR2josPT65qqVwUjxy1+mYjxabK+rAV4pW?=
 =?us-ascii?Q?i4+Ku96MMuQ2J2MTvA5bSOvINhzuyt4p3aERiLRKlGwNSVtdxutRv/xB4IVo?=
 =?us-ascii?Q?CcZLXpmsNntTT3q8au9azKzbG2LtUB+jNWLK81GobsPNudsjj0JcBT18IoZD?=
 =?us-ascii?Q?nIE9jjsukTMpqPnCTilQUv5O1kH8lwnPp7qUA/RkPPfkPH4CJX+Q4rHAdhbV?=
 =?us-ascii?Q?FPiKQ/qJ1QkqpQyev17VxRfyEaP2WGoS2+G4FJGN15yogmq85XVup3vihNSQ?=
 =?us-ascii?Q?3elTC0tOrwIhBiOSezeCoXs/sdTJYNc0fwVxoeZ0PgEtR57VVdTGJ7bYeC97?=
 =?us-ascii?Q?H36mQ4qydaCxfPo0yd4xGR+29r84vZbNhe/VpHTJNRTqCupz7CpAQplq4cNP?=
 =?us-ascii?Q?JtLX/mV/IRvu1bfxT6Fl3n+5i4F4apRd8JvK10MK6gT2AiRGre84go4RabQw?=
 =?us-ascii?Q?pCaJsqaaK+n4JcWyxbEkrtQkH/CBXdEQRW5dI6THEAIxh8yioaD9P1ssxtGT?=
 =?us-ascii?Q?iOO23ACy1zMhOz4mAKUa8sqNZc3hhKFrV52LCO8HcS2awFY6aOW9/MdfeRaQ?=
 =?us-ascii?Q?SRXjjMtPz+x1HGJ5rXM4m15Xma3580AVb6xnpFi07YF5NzxEBW8xYkHT0jY1?=
 =?us-ascii?Q?yI6+NaihpH8+rpdcPl236eujaR9kSgmJKA/6A22n7QYmjjfmJv9gnZGzocQQ?=
 =?us-ascii?Q?C9s/KtSmvWMDz0VULBM2JyMuN7xiJzEtP1gDKjyReMSfrtDAxMXIO+jnuTPb?=
 =?us-ascii?Q?OvVa5Rco90RWjwgROWNiDoXi0lWLbAhI9OdVUGeEONSb0hbK8WzOIt22ok5T?=
 =?us-ascii?Q?r0YcgE3JE46jYE3mYwDLxR/li8Cy9nltF58VrPNa7R792kYI6EfHj/st7uDG?=
 =?us-ascii?Q?RcolJ7S4pIOWmJJfG2WQ/yvwt9X+fgBVF1qtPL4LAkxgFdaCQag/YDiQn9Fx?=
 =?us-ascii?Q?kgBXVOp6wQZGtV5QndVb+EmMXcYo/3R964TclVuuY0tUGvnNDVmWfJUIwCjA?=
 =?us-ascii?Q?7FDC0RvgedVsJtoAM3cnOMy1pcqx1X7NkMqxj0UYPv2CUvE1CpaCmEgVGjkN?=
 =?us-ascii?Q?Q3Kc6GNkyXm42LItEakwC94d9+N8COuGIh4f1sWKSKCJKOgJQTSz19Y1j5Ii?=
 =?us-ascii?Q?MYc7DyOtO8qOj4lUZ7LISVHPStz2XJaey6DIjlIqTuN8GEsJQIHCgJYbPpZN?=
 =?us-ascii?Q?phQqiNjBIdndatuXRH/7KkaYEQzGY0P5/VrKTIZCbP9dgbKoZR9efgBVmCz6?=
 =?us-ascii?Q?ZYQ/N3jvNdUlF3zQlfdRq0DnkzSdLoWHSRrMDbXbi/CrJRiFHU4Z5DNulpDY?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6W/QhNqXsvr6x2csXRZRAapMurYBfpkdpxIVExX4Asn2IKREy3tnBrqMquxViVRjYkKZdD/pqXszcaKMI/fVb0tV6OYcJDH9h2GM+8shUVLPBVIdklHP5jQ7NrgvHdoyHkzC/d8OOQbVWx/Qt0fJU+ezeFQ5iCE2YaKw6Bjlw3vpXe/RjCwD98Q3MNhepwR0v/yAH4VMOUUE633EfDEYzl3KtCIZ/JcDNTdGPU1KEYfkA6hGcZ3ISZzak8VuvTp2l53uD7UYY/CA5+PCDAoofsz0Z6a6/8kQRMc16DsbtCTy8BTA4BW5pU/aDN6r0j0LiqshJ2YSvQJvPCrymYiNHRazexHNLM9TNr44ZPga/9GpZKj5/oqZLFvzj8DU7O+ZY2OyxArP6LQwQ+KV6cTSXBCRP52DjLmKu/xCmQr6EM9D+H3JdImxooS3E7s0gS1k3dBfdSVsvJqCRdDUw+wiCv2rgeowqihAzAxuuAxJcrsn8maFOMNPkerBMRG8scOr9Ap+TcMfFJob4sn742Sx62Vbt48VCrY2u4RI9nUx4CaXmJ1d9jovOrzq0C0tj50ukXfgzivVBoDWrz9Lh3oygv+7i6ptjp3gPMxjP/VL73m7at0s3KZQOtxQReQf1MokJcxsq7JWIO6bSO8Xn1wWsuTYQQ82dK9WiLR1PvIuJtLhdExTJHPrbAiQzficLueEoT7XRwBN2LHEZbqC/nQmzQ+PtAka0QE3nHXzT+Khvc0uquE+L392jv63yaCz7SqyCvwBXD9SE75KSHInjXWhzXWHRgXXLW//sVi5ZfPvYqcjnrll0WBX0+bYTzlhGT9gy0NzdITQFiKS15fFxfdg7Y59WK9yM2fge0YJ58n1RbPvkHk5Wj8Jp5NbvVxKXO7w
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e789c3-e3db-4127-9e0a-08dbae66287a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:39.3299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCWCFUwbU9WYIVA6Pv7QNf1Vmz0jU1e6G7D/BFrtkgsyGsESBR0sPx754vsxrH0Zdg72MdJiUDbNg9jGu+Od8AnydAw+5UpJz4vpXUKfMsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: xtMBS0BE1qi4xHaYxbnA4nkuLkx8htRa
X-Proofpoint-ORIG-GUID: xtMBS0BE1qi4xHaYxbnA4nkuLkx8htRa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ses.c | 60 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index d7d0c35c58b8..f3d497366af1 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,19 +87,29 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
-				       SES_TIMEOUT, 1, &exec_args);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+			       SES_TIMEOUT, 1, &exec_args);
 	if (unlikely(ret))
 		return ret;
 
@@ -131,19 +141,29 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
-					  bufflen, SES_TIMEOUT, 1, &exec_args);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf, bufflen,
+				  SES_TIMEOUT, 1, &exec_args);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.34.1

