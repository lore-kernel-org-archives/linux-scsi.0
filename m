Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6622C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJWDIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJWDHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39463719A7
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKulHJ017954;
        Sun, 23 Oct 2022 03:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yB27jQcUF2zXTtkKhvr44dhiLfcalsbsAH8HoWWRqDU=;
 b=VvLqJjNi1m+TMGBpnrIjk11CuHVIaWmiIOPvov2to6a0+YmaQoF+/xFOPH3GEwU34/hP
 jFKdqbRdxiUG9sOd+Itl6ioqxNyrpFET8jvhCgoDDRhqgsGB1wdkoiH8YNMR/tIqElGi
 QEs6uThVdyAFUVCH6TowoHu1j/I8xaIZLG0th6wt4WfX4qs9VpqvTSe9/muAij9Oi4B7
 9Tbk9y2f63M+GRVozl75fcZaGnPg3P8rYU02EJuiPDjqKPGGDLX6PMwppREV383c+Czb
 A1bgYMhtzkF94EelLsmmET41nhYPzkJ5QNmNaFdFdFVGbmXFI6jp9q6m9e3PTsU6VgKN DQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MHYQBh003674;
        Sun, 23 Oct 2022 03:04:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBvIcvBcaFky06bHFUn/h3hqYGhY2bO0a1Z4EjPpYVAmkz5adPwH/HNtRZaxgUEGEq48XH9VRQG9Y1Q5FZln8kHlaT+/crr7Y9BXBOsUL5aCTODILp4oBW//s7iz1LJtKDI8nEZvRZR8NXM3FCu7MgE2cgSQYaqtGH1BIY2Ma7krdNrMa6ylEOAhxeeV3FgqNQhfpAsJfbIslyxnbG/Xofb6m2kBlYkNU83eOoumbQKqsrkrL70vI7WeNQbfMf46IzFL6C8dLtHcJF6P9CV25+1VnfZAUZ20XnqN+zPqDie9d9f60QTCRMlc5hCGq/QNOPWIwVA6sri5/GaRh92ENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yB27jQcUF2zXTtkKhvr44dhiLfcalsbsAH8HoWWRqDU=;
 b=MD9SRuB4atW3ScT03kFJQZjh1C3dkIKbgNrUgomsJPbALTefnncIvQtI6LmRRF8Ypm2TDXfni1g0jjiCGwdk4PiXV72AG8owIsta5yNeUTmyjjb/0+UMME9+/tvLKthfr6SZ8ZK3j64pTAGuKZipVnztuwFMVyGxjwUhDHNiS2VQTuwBIUE7/P60v6yjCnBNo9OQ4o/Y2GOU7fr/DGGHrQSF8arLxo/BrPaZbA8t9cVN7ZQSnp0Pj8URhFh/OJpTjjwdfWysKEZPJN1QdRaKCdbxS3AH5TGq02HGYE68y0xwxj4no//0wE0TbNCJ3IF7Tain5O6oxuuWi+0EkbYW8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yB27jQcUF2zXTtkKhvr44dhiLfcalsbsAH8HoWWRqDU=;
 b=i1htVwEWi1yLFqgTEYourQdJdWV2OWWCbdVO8iBd5OjNAhTijdDkP9kZi0CZXr+3dOS5JOUi5Z5jdgWH739U6ptlfHXO5Aaz/8WENteMkntalsBXg9OHk/P7Hwl2J6za0U+itwYG1Jph/ktY3dwzCpVVyA10z/1hzu9KowfIQRA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 27/35] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Sat, 22 Oct 2022 22:03:55 -0500
Message-Id: <20221023030403.33845-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0056.namprd18.prod.outlook.com
 (2603:10b6:610:55::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: cf79bc2f-742d-409f-3b79-08dab4a3592f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGvoJJgq8qxGnR/rwVlK6s1hho08pT172HNlfoZC9+UKhYnE0Mzbc4VOUPMffypKxF+vOKPYqKu6W06mx8khDWGsrcOjWQEffWzgvCUeiRTjbZkiYaB5OYr3tm/MBe4txpWs4F1avYEZ08ACJyn6dn6w4tmVEvqCM1O3XzXUjeBs04L67Zx8LAeaJbwhNsScOf/6fODS661MKs8Z0qmobpHBKxGcDYlX6uyIRHpk0serAewQIre8ENzFo2QZFicPTjeXUvl20+B6Jvh6r7kTC4zdX1sCHX9MYTejwYwfxK3/ns948fvKo0RWua5LpmXj1T6rV+ai7vxEETdkXjatpBAou1JqdYSviQYt+HMgUjYt7u2/NEGdBqm7tCl3k+Km2OdQdBDkFq2NCo8EP/otT4ZqOlTnEW3X8vwECHWmXrVin5NaQazZNTbnr1YpAn/qoRr2sEP79j4U+latEoEwiPosnnO0F2JMOZ4sc6iNfUZKV7Kq/9oB1AFTE7X1fEyaoC38p5uqA0noFnpl85TMhBgY48kyXMG673W7XIpKIMTs/+IrDIId0Kixrolql3p2YTlVfCKpfSKVJdRim3biLmCiaWy06PpbOeoXX4ZJkmXg8M8R0z15zUCWWAjRqzDmaRNWQsGplFecDRUHQ94YVriah08pnWYMEbiLJhAv/5KfSmDp1FCsyjsEPWV2CCyQ3OIoNmHlcJyIrXXNg4QvHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dua/R838WaZwdX+JVsGEo9LCvLK7F/sv8c2rETJqnsKLk3HjA6v2fqCsOLpa?=
 =?us-ascii?Q?G+8+E2gInoGzj5oikzovwd6uXRjxh5ckqIUXvs2zzyOms8OGfi5ux4GIISRy?=
 =?us-ascii?Q?ITr3oYKelRDfutYafa9MS6K0YEgt804P1G2xsctm3jxsGN6dxUh8VslP6+ZU?=
 =?us-ascii?Q?DyHmD32E1Qg7be7CIwj9Ww4kJPnHjD7Smv7NwkluPaoaVDFBJ2uLsvs8q9Pe?=
 =?us-ascii?Q?iwPc99Ui6FgqRh1XgQuYFwx2U2XzZlLLpdV+l7SLaSpKtMUcA+collSwUtDq?=
 =?us-ascii?Q?hmzHkjAHrzQPuBWCcRVKRa3nFxmB9SdQDO5hZjJctI25x+CzDBJpL/Gf3Ftf?=
 =?us-ascii?Q?CkHe1iAw5vzSmJWV0W8RApT1OOv+4/KW2u2qkVloWubzXJYAw3dj8LtyhfJX?=
 =?us-ascii?Q?EvPaJWUvvQYdW5aC6UjB0kHpyv/iRy/0WyOO4dYQkl83AGW6a8u2iqZYk5+2?=
 =?us-ascii?Q?lW9biAJdAYxxuNJvZnUhATyUrNaeuW8d6tkVzxc/N9XTY5hvymyRqwkOxG2f?=
 =?us-ascii?Q?vsLKKKVGLOriSfJM3Im4TQeggaQ2EaAHzMqWxpRKSHXQYl6pZ0YaTSAFjhG0?=
 =?us-ascii?Q?vOUKxlGk/mEVdNcLVQGbzzET5d3VtwqoQ7xklReUwvOr4mVQu5L514+bNUFv?=
 =?us-ascii?Q?+6qgAmgs9KB0+QOtlMvlxqVsOykDW+ZUjRraG7tsGMEXukyIM19s4xV0o8Si?=
 =?us-ascii?Q?l8Vq8yHJ7kq6/VULcILRmHECFA9o/gb60Bq2zWurBT0jDQvTC79YbGbVvJCd?=
 =?us-ascii?Q?c5CQsKJJ07YH3E6G01NNrj4t7MkhGw157ZQR+VJerAi87OIRsl6ZUacak8Wg?=
 =?us-ascii?Q?NNFonHF+fB1dIdE+PR9Ben1Rpn0VimakhX6aN+G2GOtH4WAVIw8STt7wWHS2?=
 =?us-ascii?Q?vZVeH0Dtjc/NpbXghs223UQfI8sK1xzSMnv6OnVgdBXZ9Nra47kkP+FTjlqd?=
 =?us-ascii?Q?SGoZRDREG1OIueZT+dWCjI9+p1WabAj5wST1SMZktLgE/kttnM7uB6vFrLqe?=
 =?us-ascii?Q?tz/Z7SCZq9pI87JHSSCia1ezrgsU743eaAhJq7R8sScGT5LkF4fKF666mHdw?=
 =?us-ascii?Q?tNFoRxvEw804bp05Qgtow9VyKlRWliKSdHjPBGt8ssVfrxuSJxUGZl4es/pQ?=
 =?us-ascii?Q?j1i66MVF7V/4ntTnSm//nRLKhcJpnyni+Vk4SXSopXdeqC1F9d/EHmx21R7N?=
 =?us-ascii?Q?3msDjIsr2YvG954zbonaJGE8IuiOLX8EXfEsG+oaW85tc46WyuobURR/YvCb?=
 =?us-ascii?Q?LxV2aVICuyKhDRegAg8xflfZAL03ipgNnv8tYyOVpn8pp9k7V3fs8A/QRTNE?=
 =?us-ascii?Q?bLjby3VkSZJDl0IBwdZGLsXaZ3njJFYe8kPdt33rIiW11MrVrDuwZ8yXe9se?=
 =?us-ascii?Q?3G7E7gYxAxYfWQsHUYoxppmcXTImtYtCkCMA0TURGW2LiQTwo7abqNhfdZxQ?=
 =?us-ascii?Q?D1zigmpandi5JiQdIC6pfLCKqbSfnXmxLeyHGtP9Fb7YrBihMVXMXWIykqF5?=
 =?us-ascii?Q?PVsygRrdzQdpdJ6iK4SseNlUg/f+uinXC4G+g1kETz6XAfioA2JocTdpNWS4?=
 =?us-ascii?Q?g6zSC1IiAgEyYJhy2CJq5rclir8DzWoq+VuIedHa6GTPfg/ZZe+geJ0LTaU/?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf79bc2f-742d-409f-3b79-08dab4a3592f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:49.6845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzNdK0OZpXl9An+d84i6leB/uDt9IEjoG8nORlEUtqtkUQkDZJo6NjFnH7wLCVfogbkjKhwq7gsKQ3KdCu8nNoZ2MZORJVaACB+TNj/0Vto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: aY5L8FNMC2qt5q6CnJNB3xRenDkCuOlj
X-Proofpoint-ORIG-GUID: aY5L8FNMC2qt5q6CnJNB3xRenDkCuOlj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 700b41c856c9..424acbb812df 100644
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
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{},
+	};
+	static const u8 cmd[10] = { SYNCHRONIZE_CACHE };
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

