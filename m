Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDB3C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKDXZZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKDXYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACB225C73
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7eT012102;
        Fri, 4 Nov 2022 23:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uUBZYOqaE9VdbwFOZ94L4akeroQTWGS6NvOmHvPkkP8=;
 b=uk156CXO74OO8qkYRm+TtK74gzCipj6b0i2eY8OCK2UssOqez9em6J7HfFHSqukT+mQa
 3mir/CXZvfxNqvLWTTB3j66ayVVySMQh3w68UG0GoUbBASCQ05AcZ+7ob+Y8STjgM5uE
 aWMkHlqf1X5mBivuBJ+1XwfGABw59Cy5ae+drgb8/HX3S6DCM9TneJnCQa88qb7gsWgP
 d7SCxFCgr5R52iLYKViwA3ZgKEXjshlAzJz5dOv6063G/iB1U7RurEwrV1j2YHTXpzCv
 TF5il8uKVi85Y4xJcGyA7NO0QMdDSbGkRvguReyLrUQzsgbHQ6KogrMPZVnsZSsIaoQB kQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4MWN2s016504;
        Fri, 4 Nov 2022 23:22:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4ta83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2V+1rIur5sQD9PUnoSxvNITXxtXaOwbZdQSToWm5xlvsTAb0UNWRY0nOZW/cEGtOQCSpYwTTT9iaUfAVjjtL9dndfbcFZVGhJ4B5LfCJ/DIoBrqt/5Ic9SxQiaUPfc8OuFpG5TW5Mz5gUgPLeuG9PbeP5pCmbm/C/wiyDt+dtd/3aHVEF0viILaRY9/eYmpxLfkAG0giAVPy1BhoXTP0ovOM5xn2NUL2nHG/C14/5zr/vv8kCRTNWcFGwQxZ9PjDuNDmUHrvwTCNNsqJBYVGznXyL0JVAzLKY4wIdh7LUPPcCNitlY9SuRer2O8K06vIaCkQbpFOQyjrCltRxcgAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUBZYOqaE9VdbwFOZ94L4akeroQTWGS6NvOmHvPkkP8=;
 b=L6FXZa2QWbStjxCiLELtaZuakvMdg4DB2KNC43QvC4BiyOvHp5IOaBA8KeiKEbjuSJ2RdZ5TgRRFS00HwAzOUGysQdro40s7d5PO3drbl6qWD8EcXOAINssq1khg+JGSGjjsCyuo0+OQ0siD35aEKT4+OmGqGtVZTYO8syNxsq5KVNfqUjjfH4sW2GfCb5bxW0mK2sqs8RXnO0s00orpexJD5Wko/v/aK3xKHcqiXT17D2Kqdbc04NvoSYAJhIRP1z6FMsl1mqWwdzOJ9F0qhihIilscbR9h6GqCvSWNRqdls6wybDuLYHfdZna85sX7/YKNNCe0COvZOnBAdIXCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUBZYOqaE9VdbwFOZ94L4akeroQTWGS6NvOmHvPkkP8=;
 b=cX8PdBcZztm65fS2alIpsDdu4FxFc0+Uh1IyRhvK6Fvf47eb7mRXWJTSiPDmlIqMY9XyhAwye5ktxPfXY9BDti8G7El6LO9rbXT0LNCNd/CU8eZSy6bFqAFp09hbfRIEisqZabjpCPxh0iRBM69Nf8oLYsd5lLN/VcCwXQXR8xs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 29/35] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Fri,  4 Nov 2022 18:19:21 -0500
Message-Id: <20221104231927.9613-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 87cd9208-b6b7-4037-0dfa-08dabebb6922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPZj9Sa2381yCn3FK1kmpvil8f1eC2kiMeUfT1AX9SgYNPlj30F0sdOWYZg8cKh/6xW+1Py6TStOhO3M0GCVDCDG/zOiSFgJpFLMQZUQ69gsYumBZERDvA4lcKf0vwwKF7OjjJaSxAAz+mE6eAs3m/LzhZQHDSGt5FG9ODWaTqr00OBiXKG/IAsJjpLjpM9A01kwYh+Ojs1vDhQYBcnL2yOKssHpBX6vaibNy7b2tnpcW6j2AdJdyrB9+p/2FMxIT18sU2kIbQ9TljpbwRaeTzjm+BsaMhvNZx7t7SM1LCqhVVPnr00wVRbzd7iKjBVROX6Ord6QWw0O3X1vIVXzlMn7Iw9hf3G7v6lVv9IuWNcTTqwBB3sDCKF3DV9sYYOOYp/4sde5x7qdNyG/HNwoUSsVfiVLdxc4u/a5uMlDFU5pkzmyMJn6dGLHiwIPNGGka0FHIw9CwqBZstwO03ui7udhlEt5oJKipZnF1MPssDQE5p/boKT6pQnb+aDCMUg8YMeMZraE9tYOYPUfPS9SkWSj9QAZrWQqijnGL18FpAWziWhroEs2ozbt/Po2sWTB6p6UMZbM4yxB/vWtKNKXnhEWgFuA4/oViUr7Kg2IaWsItbb/Lct9IqBRKgPxEu+BsbWO1yS6CyIC6r38cPk+oI7vs1WScCCsPX5fSvWAVHLXv0Z4QS7JS0H4VxnDafs7MGfCSKi0+Bd11hSpEusmxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1JL0GbQgXbEM66qJqk0d1OHUt7j66oJmNrEBbtGH6ulAltvW9fHqRZiqTwTA?=
 =?us-ascii?Q?17eVYQJXJm30z+pFPtK1dUfrTusYE1wvLAxnLP+5JDcyXc7ba3R3Epf1aby9?=
 =?us-ascii?Q?Az8ewEzD1lzhmAOSLqoJADkdpe7JM5A1mSK+iPl9iA2YRquaa0g75qqfbfs4?=
 =?us-ascii?Q?UD7Ky/5HwYfx+huCvju9ir+/UG7LGfOTOly9bn7ChBXoCW47LtiFLnqkK1e6?=
 =?us-ascii?Q?3IKg3ZiSRpmcEmB9I6QGScZU4OARpIo0TsqxrmjoLjcsUNMKYUveSRP6C0Br?=
 =?us-ascii?Q?3jWV0ry/1t93AMgNyaGa5X3k2cmNhJ0ERr2z88d9kNJIeJzvHUmI8SnKaPeq?=
 =?us-ascii?Q?h+FTz/6p1oay54xVUsi2O1xCCe6AyQeju5+ulwzASilZD5SHmf73DoQEUF+i?=
 =?us-ascii?Q?GZCG90osIgbXgznLOhUl2w+EzU/x5qYoV4nfsmbMVeOa8gazJe7OdTpLIMHP?=
 =?us-ascii?Q?cNCg9aRKK+K3hmUi0yWCfG4GY21vQ+xBavYeogCShKgFbVZhSb0Oc5H6z6pg?=
 =?us-ascii?Q?fRidsFCfyGiBTXc3sLQfc4ZiDRZNahdmIuKJJRpfer50msGBXj/00DoXW5fI?=
 =?us-ascii?Q?Ofl9eZiZJbuShUING2Vi5DQGr3QjNfxY1+rCyiENT0B+euVMdhHU0MBgp+wG?=
 =?us-ascii?Q?GPnqebF4Tq1R0yWuVE1TJfTQSAG2HZWSkxKPYqdPdVyk6LUCdTl9dAo3tusc?=
 =?us-ascii?Q?n6mBrc5p9J3pT3giIroLP8m7Nl5OvFjrpSrUpeBItr2n5TULdx1ugMmOu4AH?=
 =?us-ascii?Q?O/ie6BDTHLfevt5sPLIiypaSQg1MN9QkurzkkxBfTVOXm+YxsqnKycTCbmtA?=
 =?us-ascii?Q?cQfipwfOPH29qUjOLhm13NIGjx8wYtDlUABYdK1twFZSDYQUXVgKxbdMJbic?=
 =?us-ascii?Q?24XViJF5lRfMZDiz2TuqDpHf5YPoonY4ubSSLTjYlaAjWBuuq6/2kGJR2i83?=
 =?us-ascii?Q?czaIEMB0HSiT4N1snWapyviVNDeDKIsa5ZQsMvkUUiD0RoC9ZithUTi+ZhnB?=
 =?us-ascii?Q?OOMM8FAaKqUaD2x5aRk+jdMD6crgUhfegdUpZm47LI2c5JULkGWAlpfOMkD8?=
 =?us-ascii?Q?Ri5IBVL064XwvFTT5a0HqDDza928k7AmVQu/sXMtRttKNm6vdKyKD7eBoOrx?=
 =?us-ascii?Q?GDkH74jGKsVyEmvSeGc9CjwKbAj0Rgm0YH2p0c7HTVqfmbPz5+X9Ehwo0bgt?=
 =?us-ascii?Q?ri6OkB9WLqvGLl3GQM23Q5o7qWj3oPAfF2KXSsZ3H5vxkYQTHInVbQV94IxR?=
 =?us-ascii?Q?7If3+mxVZN7YvXaRe6u2ckbKKd+y3P36w4KEbwD+IG5hCelZNm5hX34uRbJU?=
 =?us-ascii?Q?6JQxOgIRxz69miIxqOjiISE6ACRjacDNfR6FW25Nh0Zzo11lWOcfKBQh0tgI?=
 =?us-ascii?Q?9YsbbFu4oumXIQutfPMT636rqkCNIvRph4Ygw6AbRkq9PTGffmYkM1JX0Lol?=
 =?us-ascii?Q?rRCbXLWLdCYQxvjDs5YHssMt6IQ2suueEZCVTTj1c/5pvKu9n12G5RkYjRuE?=
 =?us-ascii?Q?nHy0HZfwIozlLJlDrJucDF+Tlut32yAxmKMzZMmaQA/Bj9NBJi2b45LutLpA?=
 =?us-ascii?Q?uImhNnbQe2fz5Q2ZkMiDrvszU30q0vnNuI8IhTDoQMJbAtWynfd7I1oKyHOQ?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cd9208-b6b7-4037-0dfa-08dabebb6922
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:15.9441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LWXd/j4H9xNXM9THdC8ysIua7IRU84YHkvNvFHAEZ6AgpBAuFLosxtQSngXBTE6kwg6oN8FBYKhgAxYYgppIIUCh6Jx8WzyvgrjrioHPoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-GUID: T-mn1dRfps4xzgpdXykqH7iBtZHEGNgS
X-Proofpoint-ORIG-GUID: T-mn1dRfps4xzgpdXykqH7iBtZHEGNgS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c | 68 +++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 28d53efc192b..1da0d2687c6e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1425,13 +1425,32 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	int ret = 0;
+	int ret = 0, i;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any oher errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1500,34 +1519,25 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
+	for (i = 0; i < ARRAY_SIZE(failures); i++)
+		failures[i].retries = 0;
 
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

