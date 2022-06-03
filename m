Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B628CC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 06:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbiFCG4N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241729AbiFCG4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 02:56:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F9238BF7;
        Thu,  2 Jun 2022 23:56:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2535ehw2004306;
        Fri, 3 Jun 2022 06:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=XxeV+g9OOCUAQKwPOG1ndqYkYGA56rE5ElkgDcEEgFg=;
 b=g2gGZFl35F55XxpjTvLy6x28PxbEcLZ7aMqXJ1yM1gLZ5FjtYQMstvsiNHhxNWMN6GZN
 ZaKpFkzXbbmUfQXKLe/8fSdcOyslvtrCQPBVmrDFQvxRURWov5OvYOkwL2+lTymCPmRP
 ot+GNghe9dxAxzssk+PFa4h7EYkKkCbsnnobr9DN22mmQldBnd8IkaO3sUibOl/sFfCN
 5XrRfH5GWh0Lt3Fe+RjllVSSQtA+JV7QlFl2xnJfaO82mjcC7emz2JLpxfF2ql6YUh6M
 6AdH8tjH5ZrOfDzNbCsy/65HCdR6WbPhG7CN1p6d3Rbebif9+7KVwsDvvajWVxn3oLiS eQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gf08e198j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2536q0XS027501;
        Fri, 3 Jun 2022 06:55:48 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8k25ntm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKw61AMbRTnQesRP1uAf5lg1vNnbIyss7imHZRwe2BURmrYfyvyakg1e8GenEcpOKqiunufxOXtDy0SASZL4JTpjqx/VqMI1QSr7IN6u4MhfrLwvKWH0C448xGwL0Se5S4qDer58UWolDL25Lh5oQ8EKTlz+x7hRTMyrghO+FySv5sCLV0jxDYNEJcdACWzEyq5tb5ZfCspT/IL9NbmaTYcRJWsRNxvCWLG6fRpdjNNPTaPhZFndvYcErrWVwzTMIiUcy5OzrVNhZgt6PTVBvVtEcqPtYoAorXAbINf4LQ4RnonG0yuAnODMIzqtrKzrCh18biUCT71oxM1thmRC8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxeV+g9OOCUAQKwPOG1ndqYkYGA56rE5ElkgDcEEgFg=;
 b=dWvpDgdBQuboEQK6sR36Cn/zbHMK+tfiFTJ8iugebOn2NFhwoLlGFBUefMGfFF0zYae2lF6Oi2l+ny1Gc+Z+oM6lc3RBIAZmm8C4dEmyVyQxmHQxtu4OdwvzxKskxNt8QSMmpBZF6L+gtmGTO1+x+y+RPSoXM/hhoFQuMcEXpgO/tbxdlj0VgER5wB5RLkVbBrhboRaJWHzqCFFl7UqPO+oBDMt5LVBwlfZoPvv+rxjp77og/XDBeLvbqy0sL2oCsWkibLV9INo6sICqj/9V+/I6S11Ew57lJxzLTg8HkKK56AmTT2ox/xhVXYxpXk+QFPKt50U9nbZeOnbGOGTnmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxeV+g9OOCUAQKwPOG1ndqYkYGA56rE5ElkgDcEEgFg=;
 b=MLplRCLwCCLmimgeROcV/0iLCZpyqmen25vUQ0ERJ5zGiMPY4CtioadfTx891GtF+PD81C6c+cR1jV1VPShiIsjyyJKXFaQKmbyzQiyg8zMMgxB4c8tOZqlOiX/exY0YC8hw5xE7pZaBNinyHjr3YRsvXTn7ggn+fXfbLJTo7oE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/11] scsi: target: Rename sbc_ops to exec_cmd_ops
Date:   Fri,  3 Jun 2022 01:55:26 -0500
Message-Id: <20220603065536.5641-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bb12f8c-d5f9-450d-33bc-08da452e15bb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB278934B16DCA53AFDE3AC298F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAO8eR703Op82WTF3hb0uBbuFcuTwbbMtams+rV7omrEVIHwnknuaawx6GshvZI/rHJMyOsq7aQdSsmQFsGhBaCulzaZTKebGYhpNBamp2sS7277ezwnsJAQ+o09+0HO9M1jTA/WTZiNAleqB6VV8w1jSStSXM3ABALINMVxWISK78vlMz+RPhIJUdbDer0QdJ5W2HQMBak4OFrh7I89agQMRo/0py4RzXhHiAYW6/sIBYDtkKy0tDbp8tkGp569w2YZED2lgKW0bv3qzyo38t+o8QcQM+Vu+1BYVgOtq8CnHGBAXFfA7XyhsNISfFZzaA4kP43s0z+yG2ZUZ9Ip9zdkZqe/sYsrYVwrH9j0g65DVGO65yOFUVsgXFyUxNpUH9UFUUo1LBEgzNWcN/69syPAJLRb44dVGaR4ueWEXJ1rmivhfPLYHN22xGy/FzQOBV5QhdZ3cGgwskLJ48DTEosUNeCgcPUarcxmT6FtIotBuO9OiUx/kna325CDQm2gPPJ5yZyyXVd28KGyW7ukJ28wDE160eOa9zDoqWVu4G895DX5UtLW/LS//UJgDmH0ulQBdJCu6KBh/noru5LvuUIsHtObBCB3zOb1cr7XE6xEib3EMB97SOCRoUiATiHOYfaAw6+3iuvZ4OEIUfcFR+YLZhb4W24W67/VlUeDIpeorhwaDJXIwitbhM4257jqBnHNb2b1nXjkgf7WB/QFSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LL2JU0ZDPRD7ZuvjsiYQuzv91hsxt0wf+vceUSbD7gcEPeSW2F3jbWx3h8a6?=
 =?us-ascii?Q?QmVNEKUZprrFNsdhe2mkR4Ebvl4TKEUDq/Stypu5IR5u91T97tUVlr1mJsK3?=
 =?us-ascii?Q?UTzagPkZe+GU2myEAD1SFjDVXYg0vXXd2ZVxv2QuZcYhN2oZdlDzvkc643F8?=
 =?us-ascii?Q?rx2iZFM6hWYYjHnFCVkBFrPh8gzkcXm6Ljt9iiBecIRoPNkCAdMKMMDbpbHD?=
 =?us-ascii?Q?FQYMmJ9QvHgyGaKPLGKqwkQ9AK7ixg1MLp3AEd5e6fQxhAS8ZlH67D74a9HS?=
 =?us-ascii?Q?xQRKMRR8AJ7dh3H42492ds8gvlKAzQ3pPKYZq/VQHSo1/EaRiR+5ZnhzNkCY?=
 =?us-ascii?Q?sG4d15DXj3LR5GooPd5+xZzt6K0rvVt5MpMNMdNzP4Lod+xhx0lIFBO6O/tN?=
 =?us-ascii?Q?LRruBqx6ZJOUOK6dCPt0Lp54nLnWc2Hgpg1FYCxx1jJoCSGk57zbkS0uI4Aw?=
 =?us-ascii?Q?/UEUN4hWnnyPZK37EO/SZ2eU7Bh3HzVusVu6x1QKGyBd0ejL2+5097NmxD5K?=
 =?us-ascii?Q?PuytXhcQw6iGQQXaKrxFwOASUByDDkNrzt9VdhU/HepG2/YZnJkqGtFeJ49W?=
 =?us-ascii?Q?ReNzjVlmRuQyf9L+nsxiVUXxEJu1PE3b5jnr1UiuCOyk/addU0b3/L11LXv/?=
 =?us-ascii?Q?j7HDyQYTx+og1aPikF/MbPgGX+fzZnY11bARdeJpY7ig91g4Uq+bvQOHSo9T?=
 =?us-ascii?Q?T8Nnm7EkErrPqM587jNcgmCwrTp1ZazuKAJ2IZ0UaENy2UDnhl2QTMjEAJN/?=
 =?us-ascii?Q?Lug44RKuPf0+a1/eckovDAydQ2L6dBYB/p+94Y2VwBp31+u/NGNyOvMYeXFu?=
 =?us-ascii?Q?uP9YR3Dmr/7J/VM5ktgL1xeDdyt3F2jAcC0jlWx5/faVbSyPH1Edd2+6vhg9?=
 =?us-ascii?Q?+Y+I41L0RjSFkBwGKlvAZssGIN1yAmQq3iJHjjLRGfVWeDe9c4dlrUpFJRUs?=
 =?us-ascii?Q?w5e9T93ry6qEAaYZ/mkf/CAa5tx8MACNQZ4ZoeJAMUNEZAl8tmsckE0ogMnD?=
 =?us-ascii?Q?93kFFYKSo4LZcq+t7gAFU952fu5hY49BzmJIIx9WI4f7/kEMn64ceeRglSwO?=
 =?us-ascii?Q?sSjVnew00CbWmX1P6aJgt9qmWklZ8o5Xq/eVoJVWXRI01j7H0TMyuw35e+61?=
 =?us-ascii?Q?jmT3jXILSIMnDzcdTvx6tZpMR55utdXe1xXzr7b2WRS6KyXTFwff7CezoBms?=
 =?us-ascii?Q?uUvVCSuajGPGUE0AF/aCbWHPiWgmeeBfP0txBUxGQoFhnhjTBrnN0Z/jkChl?=
 =?us-ascii?Q?DDGnM1VDYXNOMMafNhhSgaUkd3w6KDaD8Rk++ZG0Fx/0eeB1Y6nr8ilW+20U?=
 =?us-ascii?Q?jTYon+ajA5LC/HPoqjsSVG6igZFMryfKNfIKNdPJs9gOQ9FY9hLtOHJ0u/a1?=
 =?us-ascii?Q?jq9ekbTlTCc4lNREzB0hrzqoiVeyvxKEMqfeFY6CCBuLaedHfuygFoHmvEMm?=
 =?us-ascii?Q?XOZ74vGvMNT1njKWKxNEIh6xgSuQq2MKwj+SpACXDnSac4XJbGnrseP29wbu?=
 =?us-ascii?Q?B9kmAscWCZvY69ykUE0/g96+ouqy7ZbA3+zhMYPElea04yGysT1lkxt3VfPq?=
 =?us-ascii?Q?nl7LyjpmND88qDlH8rrQXIepv5RpwvdzyR2KdLv3P9ucTHzsYE65ItHiYRMK?=
 =?us-ascii?Q?NMqHzf9Gs0w4hOimI4g2X0yVXXTfv+2mZU8yUQEvC8m6IKz7Cgf+0eZOKyEK?=
 =?us-ascii?Q?x36oJzAZ/9Jeyq+urQt/JJl1ZmCMEFM4rGsswvUUgdoI1cCDDNQH1pXvK+vS?=
 =?us-ascii?Q?oTnsIwQqNRKGYn5fZUFWQeekoUa4URU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb12f8c-d5f9-450d-33bc-08da452e15bb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:46.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvZ2bhMeAuhbbvSmv6TrxtmoY/7BTDlTI0vcG+GFw00C2i4ULexosBMMrX0Oi8hGtQ/mB4PUOtdWhMzUdSupn0ppfEwcAopcfjU1ygp8qdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: LFBZ-pwQHIw-Dvhm8RgRRGnsglZUq_l5
X-Proofpoint-ORIG-GUID: LFBZ-pwQHIw-Dvhm8RgRRGnsglZUq_l5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow us to call the block layer's pr_ops from the
backends. This will require allowing the backends to hook into the cmd
processing for SPC commands, so this renames sbc_ops to a more generic
exec_cmd_ops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_file.c    |  4 ++--
 drivers/target/target_core_iblock.c  |  4 ++--
 drivers/target/target_core_rd.c      |  4 ++--
 drivers/target/target_core_sbc.c     | 13 +++++++------
 include/target/target_core_backend.h |  4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8190b840065f..4f00563c5016 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -900,7 +900,7 @@ static void fd_free_prot(struct se_device *dev)
 	fd_dev->fd_prot_file = NULL;
 }
 
-static struct sbc_ops fd_sbc_ops = {
+static struct exec_cmd_ops fd_exec_cmd_ops = {
 	.execute_rw		= fd_execute_rw,
 	.execute_sync_cache	= fd_execute_sync_cache,
 	.execute_write_same	= fd_execute_write_same,
@@ -910,7 +910,7 @@ static struct sbc_ops fd_sbc_ops = {
 static sense_reason_t
 fd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &fd_sbc_ops);
+	return sbc_parse_cdb(cmd, &fd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops fileio_ops = {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 87ede165ddba..9b0d788f6744 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -871,7 +871,7 @@ static unsigned int iblock_get_io_opt(struct se_device *dev)
 	return bdev_io_opt(bd);
 }
 
-static struct sbc_ops iblock_sbc_ops = {
+static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_rw		= iblock_execute_rw,
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
@@ -881,7 +881,7 @@ static struct sbc_ops iblock_sbc_ops = {
 static sense_reason_t
 iblock_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
+	return sbc_parse_cdb(cmd, &iblock_exec_cmd_ops);
 }
 
 static bool iblock_get_write_cache(struct se_device *dev)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6648c1c90e19..6f67cc09c2b5 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -643,14 +643,14 @@ static void rd_free_prot(struct se_device *dev)
 	rd_release_prot_space(rd_dev);
 }
 
-static struct sbc_ops rd_sbc_ops = {
+static struct exec_cmd_ops rd_exec_cmd_ops = {
 	.execute_rw		= rd_execute_rw,
 };
 
 static sense_reason_t
 rd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &rd_sbc_ops);
+	return sbc_parse_cdb(cmd, &rd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops rd_mcp_ops = {
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ca1b2312d6e7..e08d06dacbfc 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -192,7 +192,7 @@ EXPORT_SYMBOL(sbc_get_write_same_sectors);
 static sense_reason_t
 sbc_execute_write_same_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
@@ -279,7 +279,8 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
+		     struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
@@ -404,7 +405,7 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 static sense_reason_t
 sbc_execute_rw(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 
 	return ops->execute_rw(cmd, cmd->t_data_sg, cmd->t_data_nents,
 			       cmd->data_direction);
@@ -620,7 +621,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 static sense_reason_t
 sbc_compare_and_write(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 	int rc;
@@ -818,7 +819,7 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 }
 
 sense_reason_t
-sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
+sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
@@ -1167,7 +1168,7 @@ EXPORT_SYMBOL(sbc_get_device_type);
 static sense_reason_t
 sbc_execute_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 675f3a1fe613..4e6cf1bf3b87 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -61,7 +61,7 @@ struct target_backend_ops {
 	struct configfs_attribute **tb_dev_action_attrs;
 };
 
-struct sbc_ops {
+struct exec_cmd_ops {
 	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
 				     u32, enum dma_data_direction);
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
@@ -85,7 +85,7 @@ sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
 sense_reason_t	spc_emulate_inquiry_std(struct se_cmd *, unsigned char *);
 sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
 
-sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
+sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
 u32	sbc_get_device_type(struct se_device *dev);
 sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
-- 
2.25.1

