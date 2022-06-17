Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB5ACCA47E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 03:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379948AbiFQDE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 23:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379932AbiFQDEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 23:04:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2898D66239;
        Thu, 16 Jun 2022 20:04:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H2FfUh029754;
        Fri, 17 Jun 2022 03:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VgHA/P94hSpyCMkBhq/zeRDLloxOsL+c1yH1W1x5ceY=;
 b=WexBLk1/4As+4ncImsIzZGOyT621FaqLNr4WW8WzmCq8MgFjE1j5/wvlSrECdH7nP0mE
 I/bmBN6gOs8lWo6EzK7qDE9six5ascW4c1L8XEmniW69g+PzX1kYiQ8UetseXoEX/rx7
 M7KC/CiIlTdaqdIx6EJ16iX5PKdymm1wxbKe/YSIu/5K/zh8UfKwvYicypdGQwsON0hl
 dS8tbdxyfuia5RHSXqovrfxZWGYr4XJ0+U9yRnNxpNImC/MnNxwRNfVU1xRJyalW/3X4
 yRVoWTn7DKMbESdmwOnTjtZiySsg/qg2DDv6Gomfs8onuU3NRmV5pXxQT8I56nNUylKW HA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9mgxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2tlKB019489;
        Fri, 17 Jun 2022 03:04:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwcq8hg-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVz7uXYAlu+xjpfQLpd2OeGOMgO6SiBpSgHb+34r1IR0XCRLOneNkcJXU7Zw+Y/63fjbAAZuDInoWI1uOdLz3b1faNSPyD91gogLpkbobpvgYqCOwYcgCNUYWs2JcftUj6OX11fxdxRNmogIqyiU5+JXuSl+Bngm4BALCP5k9kvPXNqGwhB8mjCHwaoaTcP28G9Bex2DmtQabI+nusrNRe/qNcjUFGRcR5PecByb9SlfE8TU28mrdMw1uXNVi0YKV6C7dyoy3/bAm8Omj+LDB0gMhdQjFlDgnINNeH6XmcZ5kUGl+00dgu69HAlyGfdIfVuzLImB0K34eo1gXE23tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgHA/P94hSpyCMkBhq/zeRDLloxOsL+c1yH1W1x5ceY=;
 b=YM4l2JsJQHldPvYaL25YJrT5r8OLfEaWN3KeIFGEE+YlYUQIyn1gB81tDpMB8VZ55uXt2GQtFNE9s9VCZ8eJHjI/8HKyca4GLJhhi6DJRFGBk4biXbgxDCtOPpGpeUBOrea+1pNSRlM4fFlayYAU9/2unDBgTTf2Ls79ReNlK37CXZwo7We6D/Rx5oyhBlTkAyMRB4YLVSmymDYL1iJeq+oEayXGOfoGYMdQ95aOczl3+KWUnZk0GAN5OTKSdyDsUOOZgYKizPS70eGHG/+uC7g6WYhAj/3dG6zItvI9TI2bNQmlKTjzB1AFAHio0cj4msoKdweg/h74RxAXBL53Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgHA/P94hSpyCMkBhq/zeRDLloxOsL+c1yH1W1x5ceY=;
 b=klMXkmjyrehaEvaGfm4xL5JT5f2W5uew6gyWpX8XYz8zS5F2symVIejRqyTRaPikMSUc8udjLm+aX3PsvJynzSO/o5/N2BGL70b0Y2tlhoGE6cHuz5CC4gf40x6iOIMxrk9z61oOf6dda0+F1CS6ohgKMLSES6lfayivFnn0VCs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Fri, 17 Jun 2022 03:04:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Fri, 17 Jun 2022
 03:04:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/4] scsi: target: Fix WRITE_SAME NDOB handling in iblock
Date:   Thu, 16 Jun 2022 22:04:38 -0500
Message-Id: <20220617030440.116427-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617030440.116427-1-michael.christie@oracle.com>
References: <20220617030440.116427-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:3:13d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55d6bb49-a763-4e27-c723-08da500e2423
X-MS-TrafficTypeDiagnostic: MWHPR10MB1280:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB128069AD05CF16D4231167F6F1AF9@MWHPR10MB1280.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FV8bkN3KgC3KFpl6D4BGn7b5o9oELLEbTfloTmrH4fddmVS0CENmvSSdyTMgAhuVMsBcjddGjYZ1hOe82/zxMjPyzGD9S13KIUWWIre1xrIBIYowMmeHlL/Wf6S7/hbA6YBeV4sqh9ELAudytk36ucw6Vgh1Fopf5jMuZX3F3wMj9ccSiqvWDFy2bM58SNTBXoe3AHFsmH6d9a8ghuDALXvTkL03u0RkE3KAWITPiU+MBoGJnDAn2xbvR5hnGfBTjWdhH76t4dL8tsF1m8UiV43k82/UdKPbEAKYCiT9R2o8x9yVcvZGUG3YPOoUUoS+uQLouJo5io+WL1jxIQehEgjqFED+nB7C5M7wK+nPRSpREFFpZpwwyp/PZgCYiQ2f62TDqFdEromV7wqQzzKlfs53VILkFGLH/kY0R0INcvSQBtQgvF59xmlSFe9x1nsJgDHaFnOTGLD36jH+h3WGWGj2Ker44Huz2SJu8SQxtLp5XMQctpFXhoDRzfPZ9idEE5Fbr4HhQPStZS40+scZURy8IdqSuZTYA7d0OyV1jVeuNR32jdQzeSr42fdrXGsipRaaY8dhEHHcjsDrCBNaB6TlwalaKcGeq9ztde0AUekavyvdD1QgwFixHPsXUenmFw5AZmWY4TqtNucIO6qLN8bS/c9PQFFn6Syiqcfu+46jvNM5QFnACSUULfgLcTWNHz/tZDS0lm0phWR6Ridig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8936002)(6666004)(6506007)(6486002)(6512007)(508600001)(186003)(26005)(66946007)(52116002)(38100700002)(2906002)(38350700002)(1076003)(86362001)(66556008)(36756003)(107886003)(8676002)(2616005)(4326008)(316002)(83380400001)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bC1HBWDO2h7/5hfQsGcSgsl7Y5F+wtueQX625rSPg+9p57gcxBwa/CsXmrH+?=
 =?us-ascii?Q?i7Z1fi8rZAyTibhdZB0Xn1Bs6x920pGL6rDITvcKX7K6Y3UvPRUyyl+jRge2?=
 =?us-ascii?Q?ymufb+y03YYL3y7pJ1a82xdt9P630tMhWWd3duA8tBTiXWntC8Js/KV/I799?=
 =?us-ascii?Q?r6x+be2LQ+3Uv5PsKPOMrGQe6vRW+MlysvLp9KOclh2de2xssCb4S0cmDNbG?=
 =?us-ascii?Q?LIEuzQsrRW/B82DfO4x69el/F+RB/ggjXNvd3U+T94Ssb5WCKrT50l23Z7Qy?=
 =?us-ascii?Q?fQYWOileXs4M2J37rjBK9npS/z2V8iJGMnufxiOKKIWGtKDMZz+anaD4MApx?=
 =?us-ascii?Q?LjWEYSBsEX5rWgK8UWbuj6UAW1dtIGffr05EDD6/3PaxvoH4mxMKcP/U7s+f?=
 =?us-ascii?Q?CESjKoYVn4S6hQ4HAhEvslVIdq7cnKamgK+I2sqC/YfBBGD1Q2+//Eqk7dkv?=
 =?us-ascii?Q?VD7ixu6DS4M9tZWBP1UufmmnM0hEPMw2BZG86cdmNxOyXrpncQy0deqqVrJ+?=
 =?us-ascii?Q?8tfhNzgnQHvtn9uI1ZCA/n0P43sg6WqvHDenahcqyaURIjbyTF9mJZMinjrM?=
 =?us-ascii?Q?dFFj0lvr9fWESs5isQsziJO5yFLeYOeC3IioQxTSPd5CbxdDje2gTDS7q7Kg?=
 =?us-ascii?Q?xYkonW373viQC2EaiEWiE8hO1r5wvVdG9xjDu3OCqimNi7vLHFG0enT9K5J/?=
 =?us-ascii?Q?ifC+T0bTi0+2v/QQfrSuhYllOmJzgVfq7RCkn33uUhCtb6Jd13ECmgImfY9Z?=
 =?us-ascii?Q?LMaan+Kmq8T+yJRrzsZgBa5QxhUGu8JiXMk7OPwf4FjZrHSqLaRspB91u/5F?=
 =?us-ascii?Q?G90kfv83oxAT8aXE+GABo5PF9jOlvm5KA0cEOaINJi7cUHtd+z3hP1iBV4tZ?=
 =?us-ascii?Q?Zc/FAWGOMxC2AOMgeEyLGuSTZUP5U2x16b76hPljWduYXbPITMePa4osHKoS?=
 =?us-ascii?Q?DE8tCwV49CszKdTnZSyvBIXaOJ0tUMexE+EqFlSZZjp0/ZdCcz+GjM7b+8Rk?=
 =?us-ascii?Q?HK+LrdISGPX/eqpnKeXTvez6zLw30ryUksZeYOKK5ZzzGw+CSchix+g0FfPQ?=
 =?us-ascii?Q?wUzsJUIx2UVbmFwrH2vvkQgR/yKAfrVSiM7KPKcGy/1lOy5r0w10XrMAltvd?=
 =?us-ascii?Q?i4XPQVis3MRc38ukic0cMpou4AA9+WM1e21ZmTbAiBGqcsearFB5CalT5yA8?=
 =?us-ascii?Q?nrBC/pX0aVoarYvVzZtpB3UYJRhu4JC5+QLuGu0DIh6JamGKbQ1vKY6WgD2p?=
 =?us-ascii?Q?eQeCVuRVfKhEI+cum3Z9jb717epdKuxRCer2sorV1CchWuzilDWyfIRBXMG6?=
 =?us-ascii?Q?T+N7ye+OS5gQ3boDxPn7WnYJtn9VPjCS6qO7LQjQroTd8yXf3Douue/ID4+b?=
 =?us-ascii?Q?u2D8XfeqVG8Ng8YiQWV+qDmL6YDfdaFCKo3/M/zGfkZQ4LaafJekAw5s3UFp?=
 =?us-ascii?Q?8ybJj87UrgRoMy8Jaz9QJOyuYeG5RiZFAaTWcBqwRkVj/N1Cv9lXaqZtZOci?=
 =?us-ascii?Q?kv5/7SKEs4kv75zpWRzRGCoSxxiS6zseei+K8JxzCXojAKZIHyy0D8lgtvJ4?=
 =?us-ascii?Q?OgIsriizNiCqsP84UR1G947vZQsctxcpJ87dY/2P2px28AmuJxSfiouVo3r8?=
 =?us-ascii?Q?FA6wff8SGDA87xSFrzN4CaGyjWbgxEi3LSa1bJbAk3dWAsLRSqS3JH0mUH+Q?=
 =?us-ascii?Q?oEnI3MgFqo7zwEdtu/LZehMoK/rsGWWyLLQd88TI96KdbIw6l3XtvVV4lVvp?=
 =?us-ascii?Q?mGMQVVKbCaOAFMIvBMxvoZ+8miidsu0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d6bb49-a763-4e27-c723-08da500e2423
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 03:04:49.3997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mub2vr2B0W9o3/+KJtPgbvLoIHIHiIT1xKtf4n4brF0n9K6uFmvfEJlT1KQn5+T1FhOaxnGFet78CGaPhtQm+9tU5a92I3eZo30ahMkTwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_02:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170012
X-Proofpoint-ORIG-GUID: pmmAR1WZnNj052feGvRpsO6uF2UodMVj
X-Proofpoint-GUID: pmmAR1WZnNj052feGvRpsO6uF2UodMVj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If NDOB is set we don't have a buffer and we will crash when we access
the t_data_sg. This has us allocate a page to use for the data
buffer that gets passed to the block layer. For the
iblock_execute_zero_out case we just add a check for if NDOB was set.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 36 ++++++++++++++++++++++++-----
 drivers/target/target_core_iblock.h |  1 +
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 378c80313a0f..767ed2e9474b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -320,6 +320,9 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 		status = SAM_STAT_GOOD;
 
 	target_complete_cmd(cmd, status);
+
+	if (ibr->pg)
+		__free_page(ibr->pg);
 	kfree(ibr);
 }
 
@@ -444,13 +447,17 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
+iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd,
+			bool ndob)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *sg = &cmd->t_data_sg[0];
 	unsigned char *buf, *not_zero;
 	int ret;
 
+	if (ndob)
+		goto issue_zero;
+
 	buf = kmap(sg_page(sg)) + sg->offset;
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -464,6 +471,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	if (not_zero)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+issue_zero:
 	ret = blkdev_issue_zeroout(bdev,
 				target_to_linux_sector(dev, cmd->t_task_lba),
 				target_to_linux_sector(dev,
@@ -481,13 +489,15 @@ iblock_execute_write_same(struct se_cmd *cmd)
 {
 	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
 	struct iblock_req *ibr;
-	struct scatterlist *sg;
+	struct scatterlist *sg, ndob_sg;
+	struct page *pg = NULL;
 	struct bio *bio;
 	struct bio_list list;
 	struct se_device *dev = cmd->se_dev;
 	sector_t block_lba = target_to_linux_sector(dev, cmd->t_task_lba);
 	sector_t sectors = target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd));
+	bool ndob = cmd->t_task_cdb[1] & 0x01;
 
 	if (cmd->prot_op) {
 		pr_err("WRITE_SAME: Protection information with IBLOCK"
@@ -497,7 +507,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	sg = &cmd->t_data_sg[0];
 
 	if (cmd->t_data_nents > 1 ||
-	    sg->length != cmd->se_dev->dev_attrib.block_size) {
+	    (sg && sg->length != cmd->se_dev->dev_attrib.block_size)) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
 			" block_size: %u\n", cmd->t_data_nents, sg->length,
 			cmd->se_dev->dev_attrib.block_size);
@@ -505,14 +515,26 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	}
 
 	if (bdev_write_zeroes_sectors(bdev)) {
-		if (!iblock_execute_zero_out(bdev, cmd))
+		if (!iblock_execute_zero_out(bdev, cmd, ndob))
 			return 0;
 	}
 
+	if (ndob) {
+		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pg)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+		sg_init_table(&ndob_sg, 1);
+		sg_set_page(&ndob_sg, pg, cmd->se_dev->dev_attrib.block_size,
+			    0);
+		sg = &ndob_sg;
+	}
+
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!ibr)
-		goto fail;
+		goto fail_free_pg;
 	cmd->priv = ibr;
+	ibr->pg = pg;
 
 	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE);
 	if (!bio)
@@ -548,7 +570,9 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		bio_put(bio);
 fail_free_ibr:
 	kfree(ibr);
-fail:
+fail_free_pg:
+	if (pg)
+		__free_page(pg);
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 8c55375d2f75..0f3cf72b544b 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -14,6 +14,7 @@
 struct iblock_req {
 	refcount_t pending;
 	atomic_t ib_bio_err_cnt;
+	struct page *pg;
 } ____cacheline_aligned;
 
 #define IBDF_HAS_UDEV_PATH		0x01
-- 
2.25.1

