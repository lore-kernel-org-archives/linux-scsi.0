Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A862C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJCRzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJCRyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD043F331
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOXet015770;
        Mon, 3 Oct 2022 17:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wLNiwb+Rz0d36Znq1wimxZORUdX0+ai6fN8vPhgbdwU=;
 b=RxbXxjdnTcz+4BH+mDxp2Opruv3F/UQO9dUMJWOWBzjGovAlWvlz5z/yGtDxy07ugqiW
 ScbgE5Jz2ZCjpoENOQ5uv3ahRJYjdLwIuCydqnsmUVKfv4HIy1VP47Cg1PQseaQWgc/9
 LXB+f0kvpZirgxhtYz7hKj58tzEYO36peB41kYpmM8yHdX7UpRY680Cm0Cg9T+JxVOkG
 hZMhNRUjW6M9n271+ZLG1G5//F8c/ZUAk/VSN53dVY3K7WqOf5lQb6d91M1SPbSoXfr2
 tgbRXjH/cqDCu4kOYhwsvx7PZ1bh130AFMSSegcROf2JOvARQ8Jt2ZoLutOalRCQ/4vG /w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea4cw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HSotL030286;
        Mon, 3 Oct 2022 17:53:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09rj2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijciOF8k+GPzip8QOouGy5IJSQCk2BS0+G9z//p7iYG4W77QCgPEfSOdNJKqeMfX68LAlz/9BNlF5Ldjrs1tCSVeYR/o+8cmvgEFPwVYzcMZyNBywFApyQjZOA5FBhXYUy7LwTmeMN2ynggX1TaBJU8Q+7is3wYFi4t0MYoHAlXSKNQ+03MlVhNFF3Y/zWHcMv2NoLzJMdOwv2lrQHVn3YE566mdy29doFbiQTiQDY6/kJZHJ8KUhGZVUIKPmbEt1u4MZQoiMlRACVRF8L6JpLVSbk04IxinC6cJOSpYDjjvkhgZFGdZv5WuPnP22vK6EUY1CCd5LO47F6rsUA+MDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLNiwb+Rz0d36Znq1wimxZORUdX0+ai6fN8vPhgbdwU=;
 b=g8kT4qY7ooJredwBtQa2Zb/+2zd7+fxh7rt5Ic8AcbP73arf/yFqKpozZrgJvQltwV+WOqdmARUgtTQEfrp/xLLKiBmQT07qzfoGF3EQR/6w+W8cD12qRplFkirqQmvLHGCSmkSr5u9/7K/y/obO1YlaO6q6DP8fbJ2QkKKR3VVMGoyTpOBhEHdfSA5xmbSMOQ6bp7/0Nj0Qbfa1GePykeqEcFK8lxBGGi6Xs9A1dF4+BXvtptUMiNguvb/XNJHV7ZViAUK46rC+foLdihDdMvpRSAwvs64MXhHOTYHpdUBibzhfBsKFMU5cFfTZ5CI8mqSVwlMUuXpCHxwnkahqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLNiwb+Rz0d36Znq1wimxZORUdX0+ai6fN8vPhgbdwU=;
 b=pzM5opMHMdYLvuGoygoHEzfJdYM2PQOqsG836QVmAV1TLDqCEDmmqeO/+sokhmZtxVtoq5OjZxPuEa+e7grznqr4o8R27p/+6DqWOSWUz+eh/6gvp0PJd0OWJ/o1pi+6gWoUHrKJFvsaNYu83XXnJwF2YlkUlUGUCmcqtp3BAAA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 20/35] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Mon,  3 Oct 2022 12:53:06 -0500
Message-Id: <20221003175321.8040-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:610:50::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d0a24a-40ac-4b1c-662a-08daa5683cb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XKVldENANsPJ168j2QKBBIU549JbDis1S7nFnefu+4LT3geH163711FEpQpzjTS8juQflNrjXhrIBTRVd6Dav0TdIorSleRVarmpVI7qjeRDDpiCV/Y6YJdVBmO9bbQGPUrh4B6O+dCWdVioYFaMFRMdprz4NMxK0ImzFISCQpRoEe2HYA/BtbDJwkGnmHvfTH+FWiL3T7ZbbsyiMvKMul7TctOVyPiWr6Nd//SzrSQ7jzLTeIuHjjXMXE7uT9/CAbeI9XBx9+rEiT6sA3RQIS5cqPHtJ37A8Yz47WGN49o13THcpr0TsA3UaDj4as2bsxcSAcimJj8RMZv3lw4fkfbre7Hgg9KxvVdXqy9jF/YscsF9qEvMCwSVOJN0RtYab4N07zRjsMjkUyCJwFAbjZSHYQ4k12d9+0JDUP0QFa16LjPsjj11gZmAVugANxUikgtEqJXl+C9+Ryxman+Ni8KBrUKYbGDtQF6J5O/WyFVe2NblMWbS2nvgAPWbhOuQQmuq32FzLrNC877SIT6H5N2Gz23im400ajeokUio90uYs3ld2WETKfbzFBDsqT1BQ+8+ZhPlvITqFcnBUNEwf1v+3LkrAZWEptcxfX+bjSkLiSM2X2i5zKxQbAcZElSCJsfpHbjBEJbxJagvLnB53nVlImECvmpCanfXQDG87RTEu3WaBRCFNCQX10h3g+Sx5EMtcQDUmTghMcBWV9nBYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9m+7j8iCxDK3ex6HJbWln04LFDM15xhPoSeUMkm16EV28Y55+3XMcySR7Uq9?=
 =?us-ascii?Q?C4PmOG9XqrXdP59h7YOqxaSRTX9U/1EqkkX6Jhe9KY/+GmQ7GkQm+fnzxmZU?=
 =?us-ascii?Q?PCzoveXgWRPHjIhUTtjQ1J6ezClh8KdQkIYcq0RJntfjwEFJ5KzPN4sUWFF/?=
 =?us-ascii?Q?4XXsTN1NgfJs7YkdEAWAye/uhwP9TzmzPf+xlPBQQ5LqDA+sGpOpFSjc03vZ?=
 =?us-ascii?Q?uHDri07AInTL8KrCDIlV7HqvOWVgWK6KTo1Bkjd6KU9sMY5U6kfHHSEkXvKJ?=
 =?us-ascii?Q?luYx4eJejUdO8DN6cTJSp7cq2ird1Hq4eNOaFGW9eUiVTwSa3FWZ9EGBUyIK?=
 =?us-ascii?Q?SYaTKU8Jd/FeDN8vOgLdqdOrtS7zR5907U5HdPDcCYGEdPbe73YBk0suOASh?=
 =?us-ascii?Q?4oavCnmA34i6mm5YC3x+O6lVfkS5sg3CFr1vda8l7iLjy/INoRNFHVSn/Q1y?=
 =?us-ascii?Q?cjQrkq9zMbIL6DpWLEOPQimpYK/N/QaSI01iGHaNJRiQD+HgwwmzBBx6ZO8l?=
 =?us-ascii?Q?a1YzkUrZNJ1fT2/fGq2MP09++TX7mIANtUsbil4BadVEQ1EUYJCpenBXpBrO?=
 =?us-ascii?Q?2zdTq6OM2+64GgTq+rQqb1kpjqFP2lOHYeU6/FImhi+hN1mubh1peQk3gt/F?=
 =?us-ascii?Q?iPj4pfpsW1dhtKLhML2zECwazD22Eo3OUymYXqMyjCQEUCeQb2/Jlo4nMH05?=
 =?us-ascii?Q?Q8GXhxaU+S1xltcEs4wL/96y1rSFDVHFsMXX4VYuoh6LJlk5ThSKrMwfhg0B?=
 =?us-ascii?Q?C0riuKvYZDS3aHtB3FhReiFckjByaF6DWgPIc19yNlgh3VQyjMbqyoLfYjzn?=
 =?us-ascii?Q?18hiZOyVDCK0c3M1xxt71AE5Re43e0m0/bF08Lh28DOy7Git9LB5jZurzCgz?=
 =?us-ascii?Q?PiTmKNcv5n8ZwvM5sjRhCQeUQxG9daJ9CcEZTT5x3+W3Rp/Rbgqe9upSQiTs?=
 =?us-ascii?Q?VU1VQqyl+uOLUFEDj27o8b8XEmY6eEBXMhPBeUwMlVPKA7DdhJkorj8KeEtH?=
 =?us-ascii?Q?M0XzNaLi3CQoDv5FZ07Qd8HJP80QsTKaGCsLVuuRx2RZivyyvzq+/crTApey?=
 =?us-ascii?Q?qdS4Y/rQD/lVQ+gP3Fd5vnvLryswalzEad3dQcK+2yXZa+YGqYi4eE9BNGzn?=
 =?us-ascii?Q?OmTZ5HyxWZLCCOqzOy9s0hQ6wPnioZxwqYndtXTL29WXH1OxnT5yEl3arjxg?=
 =?us-ascii?Q?FXAKmALYmU4LasZxulY7Ym6CR7Mti1HzxGgSu7yjlHQDXiuUx+jEGP0rQ3bS?=
 =?us-ascii?Q?rQtAG8cU+YXnECwdmoGaRn5jaqsc5mKXIbT26WlSld9Huzi933SUNiBMV3ee?=
 =?us-ascii?Q?P4YNZk1x5iI7AennwKiYLlEHBiYHIUzguCipf6juYQ720btSlx0KhjK1bdDL?=
 =?us-ascii?Q?3mI7Buq9sjjccEtCgGnZ2fSH5uo80B/VPdK3hr23Q2o3s+NkCXQpTvYRQ0rZ?=
 =?us-ascii?Q?pYxou+rCsNfFWFRjRnou9nqPuWqrvWH6JJiaPlGihY3Q/GhzOens2Dixgm/h?=
 =?us-ascii?Q?kI1WJI7WIIxrYYAuc9puQ9THLEz8U9+KKcwDX5E4qOWUtz3JLaSBblkcjdJh?=
 =?us-ascii?Q?zSKFKMN8ku9hGUAnal6N3ceZll+Vh6h+j4M9+jBNg5fAYqyLgqhjW3glycJO?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d0a24a-40ac-4b1c-662a-08daa5683cb2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:54.0790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbSRI3SQuZz+JCQLRYIjffx/1xAeoBglyduWqboN8j/BVQnHNiocoKHfBxz7rG8/BaW0WJt1B54vmXh/N0kYLTHOcFv0lI//0ps14i9s9j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 8Im56g5jMRoXmzEGafk_XTkd7qZSzXqK
X-Proofpoint-ORIG-GUID: 8Im56g5jMRoXmzEGafk_XTkd7qZSzXqK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 44 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58edd5d641f8..83f33b215e4c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -654,7 +654,28 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result;
-	struct scsi_sense_hdr sshdr;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	*bflags = 0;
 
@@ -686,32 +707,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 						.data_dir = DMA_FROM_DEVICE,
 						.buf = inq_result,
 						.buf_len = try_inquiry_len,
-						.sshdr = &sshdr,
 						.timeout = HZ / 2 +
 							HZ * scsi_inq_timeout,
 						.retries = 3,
-						.resid = &resid }));
+						.resid = &resid,
+						.failures = failures }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.25.1

