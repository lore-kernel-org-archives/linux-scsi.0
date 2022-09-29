Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5342EC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiI2Czn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbiI2CzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20F74DF01
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:55:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiSq2020738;
        Thu, 29 Sep 2022 02:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=cUtDsNMaSNLvfZ7McXC+iMhKitg4ItEn6sfOiTcSQA0=;
 b=FScY3fvTWjRhk3lrGOdeRrY4zSs667BNLfC0L7c73fGqJLnDyafOqIdey62o3AnYHttK
 x+gkzsR1gt0UmPWrGulek1Y1VyoKOIZTHfnY9x6Zk3yZC5aEFLOJ0t34LhsTRXJYAwlQ
 bZiNU8VKXf6/vvfa4fuEo4Lr40JDzTjTCXTZu0j7BQkYp3r9NAUK9qCHg9Pt1hpdDqNK
 GxXkJgDL4/6T29bmWlCn9xg2VZDp59EGRaXgWH+04YYfSuZvtvajv8Zvbs/54LMBOoRz
 +lD689S3HoNzyYBQ/HZUKTB7QSxO7QwQf5Ho7X7a1t6AW1D2EFGIniXaPN0z6GXatXC9 LA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SN2DnV039536;
        Thu, 29 Sep 2022 02:54:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRKfU/wXzD22Mtn8vhpRb20mFs2d4CcryqXf/tj5nxKCSy/MjtkacjAiKqA/DIGuIa/IE6ecnU7/YsG6FwhJfnL9snMUbswjWFqc/Ixk1KLn5RBVurMj7a5xhJSp0kaKE++sMOBylFkjxPrWjP4CclrdvRkvsqOzWBG9XX5hYdQD3uvpKksfYOesYzFt86WCaSn+ihEft55CJI6ezMGi2A1TcoJaP8wEDbvZjmgmomfaNhoG5ZbuvTBP1C4mYmdUo9g2PNjml1UgrO3uW5O3IfZMVkBxVns1LRFbhNk2NJsrJnCWYFTl0+ponWYdVgp7b7ysMw0WPRSUTpjhW+xLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cUtDsNMaSNLvfZ7McXC+iMhKitg4ItEn6sfOiTcSQA0=;
 b=ekUzXFYmHW6bB11tSi3Rg7qY4pzKtBDQ2tOs7TP2Y3fWMEH1STWyLsdfC8vFOrOKfJlIyns2sTFpK0vw/wQ4XC+CSdnD/l0rYuyQk5SiW1NlHPVEo5efPk6wLUdP/HiPVxG48rVJhfqpYVVS6GBGO8lwG4plQ59NKlI4CppuO16xGHSGRB7hTnR/JobvX3KIjAtO+/XqqIni1bLWzQNi3wPh2FC+cgf2lDbLmY+f+r3slAVd7AJGiPi+eaBQ0qPs0Q1Kf8zrzS3To0kS0M2G076ahIyR0cIM9qr6uM9XYV1h3hQw5DdI/4223BZDYn2DC9QXoZLVsii284MMIqAnfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUtDsNMaSNLvfZ7McXC+iMhKitg4ItEn6sfOiTcSQA0=;
 b=a2erT56J6OcaAOCJj2ZWGVcf8dV5nhD3DLAFTptRZDfybfbKS1yM+Q8XrCWmbeqwVr5q7mHqWdqbVhLQiYPhhaOgaQz+67TVojY32caNpu8bZydnedgmg3XuF1+ma/N4EjttmAWWh6sLm24V1hXaF+EiFt7QiBpY4h2wF7If54M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 27/35] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Wed, 28 Sep 2022 21:53:59 -0500
Message-Id: <20220929025407.119804-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:610:54::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8dd0e8-e6a1-48df-f915-08daa1c5fb7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4s+EljFVKdNjwu4Zbra0k/sdfAjWgbzyyLD97O+pCbu7iJiTr0k71oPnaNyEL0eRV4drdzVBDXOb0ToaqOsKtdjdEaSI9uADKMjIDBFlZAnznBiWT3ATB5TIN16fPoIWVvImfK8T1FwXFaEzLPAco+9DtpSMImgM4d6faFPYrLqJnIZSwbNHnnu3n4Qqizb1u2F4v/PdURpfTH5vKkcGL/vei6Rg/U66K7LsXHNQuWYr/Xt6m1GvFqh5W/rFiM9aCkAacc7RUuw9RizMtMYrqUxB2zdvvh2IpVwT5TrdyLM4VJXABFgKvA67PK2ko/aNgD+9g3hNd8DPeHLPFQMCoTr68HJQ4T1CTJfQZ7S+IqqymnFLpDTwPkJTHblS6cVwoOlVsnjLeyYZYHTjck0gbU/5i2kIfb0375xDC9mTCmKu1uZoSwDRtRCfJ3bnGhzgGceonSUJAMWvaBaCJz/l0h+ej/uJpWEYFqzdosi33xiTQ1368r0lMiY/XUQ4zf5cHU/QX1ippdWK19FnqTO56ocSJUNNgqZEYQ7OyfRabo6wcYDWV/fQTB15BI8uCXV30jPoMJXp/iTAdlc0LLkHXpOnt/aOupbLmwlpc5U80EsOlxrx+LwiqRY12HWuI++P8JVvshy+pYVj2/deGWwUDAFhbwMthCl4S/AyQe2U9jtxqe59UJXfB5tzWZ4PksBPbWW/6X7NYlctOhMvXphkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gnx7hxxu0t855qrrs33luDil3RMYa40MCSSsm5ne/s60a3Oy/flFiy02880M?=
 =?us-ascii?Q?7m0LXhgbjwJjRW9GJi/TXJpwPkE1MZMbcV4Lg5T7onx8RQDA1Aoq8ghPYY05?=
 =?us-ascii?Q?v6sw0Tiay1F7ZdLExzY1FyxwVPVw5YrHuefj5UQYUKd4HGOVa5W6h0fhpRhj?=
 =?us-ascii?Q?+xR3DAsniRQdsXoSeXuD9wZ1MB4zJlSwPpmvTrq/E5SoJjilVEbHmypiLOcJ?=
 =?us-ascii?Q?lOfXDMwsTML0zTTRBPJwYWi7DE73nKM9BDLWU31986IFdjnpUJQjplSS70iY?=
 =?us-ascii?Q?hk5v877dARuUVGZCDfGBN4vs43fx/9Lue3lSBBlPMlc3STQhjEw/d0YdMeaB?=
 =?us-ascii?Q?f1NAfqVaca+hkm2qmtkjdUA6L0yya7KgF2aEG4YPRHG8sUadpLJA1KaVYWu6?=
 =?us-ascii?Q?/pNrDVzQbW7WWeypDiSW9BuMB2OAspoMlXRyQeRNwqe8YI6038QrO9iievXY?=
 =?us-ascii?Q?Juw35kedPDxXHkkW8a1uakRe/Gt9b9DWMMqnSvMCCE9L8wYEIulHbSyYymhW?=
 =?us-ascii?Q?BYIpdD4OwH6lHY/ndVn5xcCSHXwsrqq/Uu2UZsfFQpqWi/WLGlHSXyklZxWh?=
 =?us-ascii?Q?yLvvXE0EjJXzepoziblFp7b1nGPDxxazjCajWO/EKAOzT6TnRuo5XwHhdZWj?=
 =?us-ascii?Q?Z/dpFRDdx/ylPJgYZDybzXLn/SwhkGB6JeUoWM5ivUKzYTjMQzOLFyHUARBX?=
 =?us-ascii?Q?16U+k2okJ+e3gGiFUGQBhT69P45rZvNNiybQc2Q89thKxPD8ryo8yCr4PZoV?=
 =?us-ascii?Q?g691VKhIgXN4/t5ZTQywY791cnja7aoSVRCtojxM7IuZcY5ALHbGBn9WEvS0?=
 =?us-ascii?Q?8UWXiEmZM7TL4R1x14ZOb1/scjyAtQXu7YDie7BPXurGcNBTPBOOc5a6leA8?=
 =?us-ascii?Q?dflQaE3iFNqJtMq1zyy2f/bOuMr6uGYqkUFpsMM4lTmCDLmDnaDppcKUfFvo?=
 =?us-ascii?Q?z2p/YuMrTJ2OHyID1uvpyWxv3ZfY+1uEsmCqjgkEYotRw07Y4fiZJ+ROsCjU?=
 =?us-ascii?Q?YOu/6U87nsIUyaBg7AdWfGtlt03alUqTblSslK8l4oPBBcvnlagbtBkzcRjc?=
 =?us-ascii?Q?XbTaipafoXdGsYyOoAJfbyar+4hjoftfZhvnzmPRgYaKc+r2wHVKT7hD5G82?=
 =?us-ascii?Q?wezq/ky5DItzulSvDe5z7NlxxcTNx47PVmhWJvG6PzozGFdSabOkwAw7C7nz?=
 =?us-ascii?Q?X+6xO+n69c5oLVpg6QaU2CXU4L/PQgEueduxtY4T9LiodgM4i/lzmo+c6dVd?=
 =?us-ascii?Q?PLv3Jsvr2+OQ9JKIKdr/uXpTO3Al+f2A5bDtj7XYp5CUd46B0isRuOFxO4C3?=
 =?us-ascii?Q?AZo28lpDFZwtUvhxgwQIayHfk5za2iuXF8iFMffRWLaz2hgo6/eFNitK637Y?=
 =?us-ascii?Q?wX0sQ95k8FmL9qv+VsMzcEw8o1JJm/u3T3ew9qIKZp8xuAQGkunwcVfx+UGv?=
 =?us-ascii?Q?ce3NbVO4AtUXNkEDBTOdT+QdyBKbqWFb9wVv0YfgbnmN2bYrPlki3Z7sQzZJ?=
 =?us-ascii?Q?BhItJ+6Sinr52MDTpB3BK5IQb4DQTYRtZqgXHjRxMu+hNWH2TFRCUikMlBVl?=
 =?us-ascii?Q?ylM4lsLtB5q1DsuojfNY1z7POvitHwvwYM6fD/4Q67yeG+k4FlqHsS+C0IKX?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8dd0e8-e6a1-48df-f915-08daa1c5fb7f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:52.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLUzH6modX/TTkSPJNA9HicpbtSEnqzH2RFXU8AY5NglwNElaCXtT1zqIZappSj4jnx+UBF1QmbRUyNkmC0wJY36VFrNysMVfEOqscNki18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: yOre60d_rZH_9LL6P3WvugSLYilR7EPK
X-Proofpoint-GUID: yOre60d_rZH_9LL6P3WvugSLYilR7EPK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 716e0c8ffa57..cacfdde545f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1580,11 +1580,19 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
-	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_ANY,
+		},
+		{},
+	};
+	unsigned char cmd[10] = { SYNCHRONIZE_CACHE };
+	int res;
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
@@ -1593,26 +1601,18 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (!sshdr)
 		sshdr = &my_sshdr;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdp,
-					.cmd = cmd,
-					.data_dir = DMA_NONE,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = sdkp->max_retries,
-					.req_flags = RQF_PM }));
-		if (res == 0)
-			break;
-	}
-
+	/*
+	 * Leave the rest of the command zero to indicate flush everything.
+	 */
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdp,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = sshdr,
+				.timeout = timeout,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM,
+				.failures = failures }));
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.25.1

