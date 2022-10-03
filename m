Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A48C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJCR5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJCR5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D4E13DE0
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODh0019383;
        Mon, 3 Oct 2022 17:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=VtrK4YnTjLKA60qRL7+bKQOiYwfbqmy6zcwQYEfEMf8=;
 b=2YSjjlJK7tHWbQvsWeS+x+Bxwc8PYyln5B1foRFSBW7D+etwYey186HF66+HaHh5mTf2
 8e6qjg48nbl0m3oilnIbpus+ngAedJnkw+RNuLAcp+G6CqKj49grFFiPgtxqh0P3EP5q
 kZ5H5ObZVUeuOPKiC13v5gBJKINAgMR0XAWHq1fkDTducMmm2hht+nri2iZrOUII4D1y
 43QMNzAewGzSLLMjsfIr1jmUdJtXAVJXDFdXQrtpZCtiGlmy8F03U8tqBE4fx+q4vzji
 nVf4jNDNDRiF++wElSvTxFw4LgR00SpAhdeA6kCKxJyawJJGqelGrIO7LzJJk2Q7ayM3 HA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tmex3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HbkH4028118;
        Mon, 3 Oct 2022 17:54:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdnc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+1/f8UEDFyNTilVKroinN/nP7UxXDrWDaIuP/7pmY2utU1A6ogeu6qzmow+VRBlx396yQv/vHiE0E2OHuSu0V1lchvUNjqSlgsVKAd4OI0OfnTSP+39Ix70wDnNJDN7gCj3GbhIXymLV2qz/D+mXjhfOjC+LNPQL46/zK4tsaHixxpWSVStuUNun1WC9S8QZbTJ7M6dmXYbD3aSVMkUzNeYK2FC1ZRglgNMGUHCqizYtwhyJbGoGtiXXmQwGMaezhicpufN2MBcrUYggSSL4iMByxaumuoUwKNcUWsD2IbEssKa/7/UQr54fJ+6MnMiyxBe9dPYBLbj9AXQcZ5F4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtrK4YnTjLKA60qRL7+bKQOiYwfbqmy6zcwQYEfEMf8=;
 b=UYdjmNcDQBkm8EMAfT0L4r1YXXRZ9hYgJ5RgQOepNuds+lpd7S03o/1JZ9zz3gnOY2IDNhfdm92WdPyHOmpUpQMW0Tw9z3LP+270Q+5kItrpiuQnLRq34FkjZQ8+QkCZXUX0a6vZNBTCb2rupiBVNmX2d3FFJGHwikhT5vT4Rv7Q1QpVyqvslmD8NeThxGO1/m3wo6RRTBV7YM5IchzPosxLKNWxyMKL0h0JxjB5XYn2wjGFblNnScl640VMxXy1VjzO8FgrP5HIn7LBpaDYoH0I1cT2xbZFbses7dQ1n/h4YSkyeMdtYmPhpUrGc9IzleTTMwEstDts94nVE4jIcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtrK4YnTjLKA60qRL7+bKQOiYwfbqmy6zcwQYEfEMf8=;
 b=jZPlBuSyy9or1Lk7jKRV8GvV6nTu9nmmrKCoeqrC0Acj3bxQMeUAJH7N2Yh2C4GdGL4GDDX3+6pf0kvpMKERysW2ZMEpju/D3fMXVDV5QTKiUscTt+1ljaPaSh+3sQTzTiA/WS/M2gpd6F3k69G2N9fcYHIWFF9V6jTrfwPaetY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 30/35] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Mon,  3 Oct 2022 12:53:16 -0500
Message-Id: <20221003175321.8040-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:610:59::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: ad3eb29e-394c-47cf-456d-08daa568457f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G09bvYT/gJspnNLVFWKyTrwXAVao4AEbHbTVKQ7R32JYShq2HXNMtO+38chJtXtOFFCreK2/hwNdjH7FCn6RcfRLGete4ZOTSR6kFNYCwhUIkrApgqQRH7oKmxM5+68eez/sMfjPEG9TOhxNHOi4QCastiaEZ0hdbSYzOj6louyB1zDP5q3215Sgue2mejXU5n9tWxEbP6QyUlxdWD1c4XXPMPDt6rEmjFB6mPEnBqlDrwfKYMX4+ietp5B8E+/ieFAyqjW525nkHOdAj3Bcrm5DSzrLXAkcrdG2/rj1S3Bv/9ggfpRwFmX2bl1LMbWu1D73pP6lyd2ZTlhIJ3nnso29/uwi1BoEched2VFJHK2cYig9lZf7ZKAiX4YwfXChQnP1PkG8mFK68KyUCMQekJwbeZqA6FhOhfar2UtyyEGwz2xuWHbZqmj4WXjKSkvFMXV59gTUSfCZEOfqKDJuHkV7MB2jwjw7q2+v+BEwMKlmB0QYuOtoJwfxKnSDU0RJBAhpSwc3no4sZoDmH52HbmbzxzEe2rFaW+y3p2v4Tl4+LFHcdfkuKryV+WTG6KfKMLAhGwzSlm8pU9VIE015xOLRYu/rQ4fq1WwT2WaU3ZOpsnofK9TO8w424zT+0ViksWQXbue1D4Fo/G5wcaeawRZBwhXgw3XUYbYUu81sYa2hW6kWmUo2fLhGefmOOtx29dWZjIkknOeRVTpcrQdV5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FSFxMZH/0minRF+fJjhklSQRGhRGaYY2tywAYNZApbWj8X0MoDTpIHUaGvPD?=
 =?us-ascii?Q?ZZWOzD1hTgQNLFCdc2Bkj55lvq0x11fJC+p2YLeKGaeVtWRCNXhuyjthJ6EC?=
 =?us-ascii?Q?lDm0e0ZU4RHybYtCpsWxkq5NkTOK254tlZpniO96Skwy5FLgmwAnuH8HENEc?=
 =?us-ascii?Q?boGU4dSXHf7tYuif9Lip6ADxgdEdkmnysWTMYR87StLqWnC30X9juYrRRT3k?=
 =?us-ascii?Q?0Nj5SkXqxOZ0iR5Ygm4vFTV8pTY8sWp4rLVtHaNnQg4YDjsZ6qyoCkrJNyZP?=
 =?us-ascii?Q?j1qH6lHuJBns98Ul9nupU6OaMwsBCo7ndYGAi325YJpEdVDC3ZbTg0DO58LH?=
 =?us-ascii?Q?APMi+Ut9lfe3utwJ65mtfnoAyuXm4Km2BfV6QnuJRRXkmkYNSvD4BhF5k7+U?=
 =?us-ascii?Q?tLbnQXbXZ+tP5GUCLFCxaAfVsS63EHh3BMYv1nIRaijvUNFaBxPvBviSHhW8?=
 =?us-ascii?Q?kRTItEXUWjh8vFaqI9qld+0ZVK0WJq+UUxLtpUGuRsPOXdSWUmis9nzFiyYX?=
 =?us-ascii?Q?eM/G54ZPyBhyBqPO1mPoTiROTeNCwZRT6kknIXI1cCNp8UkzdtZcqWXE5Zwn?=
 =?us-ascii?Q?CM7V829+o2QHwQlADIwXywByFR5U14qg3z1YOlrIn/gmWiJ5DtfWHyDJ/jWg?=
 =?us-ascii?Q?nOS7oqL5G2qoAHj141Sem/y9sIgOWe8qP63BzN0s+kcZggd9ps/ob6v6edGT?=
 =?us-ascii?Q?llzEmKb20L1ZBVGAR99c64eDPjBEjyGdAEL/lnTMxhsmDJEOIAW6BQr+xs7Z?=
 =?us-ascii?Q?0pi/MSmhWL6ZnKzaVAJUa8ysVccnSSCj47of/VQhmiBNCOOheTag/zYz/1Sr?=
 =?us-ascii?Q?jcBxvjDmjiYY/Wk8Tk1E5K0gwbZahWjy0aKEjtS52OpP6CxZotpKO9dL0PPp?=
 =?us-ascii?Q?XdrhzIi77GwVyLRhOLF84EsbF5EkFscN8LBjMmG7gmfSwam5qaMBhhTSFmi2?=
 =?us-ascii?Q?DHck3D5JRL3fKwYDUkMpmteboNz9Q2/5pMx4qc2dTSkDq/A99+p/R7btNBNj?=
 =?us-ascii?Q?cIcxUD5CtJfvJzK/L06tYh4zdzmMZiGxTyLvyIdK38VqKw9aK1ZeyAsq2Mnb?=
 =?us-ascii?Q?pqojQoYBJ0F04JNgxybL9u7NbwfwhOjOX+UajEh9IVBIKP/zxs6hf7LS49qL?=
 =?us-ascii?Q?olEjTY1FCQADXsmZ06F/8nUF8wY4LcIxajl7exTFT8TZa+n5W2+cbqj00JDj?=
 =?us-ascii?Q?3P0RHL3I+rA937d2EGN4wjTvTHQwIQBkawz4PDZpjEycdbOtsQhOZ6dHStFT?=
 =?us-ascii?Q?0wqeUOrxTqoBy3i3fvCU8hzSF9W0YjmXkpFL1HaRYTDKqAPNUE7ATTwe1RM5?=
 =?us-ascii?Q?s/ju/rHzIKmKh26OIn11M7MUxfyf550aZ6BnF0qmxTengEWkK/UepJPWtbwu?=
 =?us-ascii?Q?9w5B57SFYpHqp3QzpMjLbVG89kytdxx9bk3AmdtON7qkwARJqkfqZTJhBXhf?=
 =?us-ascii?Q?1MsedGvDeOsswi9i68UZaMWKhTZtDMZrYwQkv7qxb4COP8fV5G7chLqQ+ZUh?=
 =?us-ascii?Q?62SvKjnZcIaLw1CCHKWsiriRFY/GVgnQ263YeHHQYvtcUcpcfhbJI5jiCgSl?=
 =?us-ascii?Q?jemg3G2SsEkmTgNLgpb9HKo6OMPA+Q5zazwZvn8xz3OPc5UJhlHZyYPm0Gxw?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3eb29e-394c-47cf-456d-08daa568457f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:08.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: soH2oATi7hHqlAv2SGDyJnCtsNcDfHOLA85IRdvRReQpE/X9P8HHe+CBQRd+zkGL+MWx8VJRvGBnPVYx/otJLm+ppaJ2xFG0/vSHId5du8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: H4vlWIitLiSLueqywa9OePljzftEh0nl
X-Proofpoint-GUID: H4vlWIitLiSLueqywa9OePljzftEh0nl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c | 54 +++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c45646da6c71..e3693aa95543 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1420,13 +1420,21 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1495,34 +1503,22 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = scsi_cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = lun_data,
-						.buf_len = length,
-						.sshdr = &sshdr,
-						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
-						.retries = 3 }));
-
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = lun_data,
+					.buf_len = length,
+					.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+					.retries = 3,
+					.failures = failures }));
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.25.1

