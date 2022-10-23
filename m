Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C822EC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJWDJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJWDIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:08:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32701733D2
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MEQLhV018071;
        Sun, 23 Oct 2022 03:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uUBZYOqaE9VdbwFOZ94L4akeroQTWGS6NvOmHvPkkP8=;
 b=GBc77VrETC4qQeIpgNPaj5jq1D085uf7rY7pRCqddn/FCOR3UvSJF+0u6HOnZtMwhoet
 X2NTlqXseKSFm6ljQbimeA2Chh7NGPxGzaGzUKkDmA3N6KJRcVgyDqU0qYL+pQr93MDC
 I4iMDdE6Wfprfy7P11DJpMbm84Di0FYEtnQ0f1w0u4PeYe+hohtXL4/5v4/nK1l4xmZe
 hx/KpltJRsEkTLybdFuBS/tFNHVtl3lGtP9+PIz4Cx/llCsK1rjCwvhljS9nQFP22h3T
 cyfUHZ5JkVei8yNTp3EsWI5Wst35XX+mVRsOS26VemKXvlgvnm7ioJie6Tmkwq/2uAvp SQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741h872-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJW0fZ032103;
        Sun, 23 Oct 2022 03:05:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30aud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsACtTV01l2g0cziDau+MxPijmzoDbpw876ybeWQPJ9yvxgyIuJWff0fNsB8kl+4aFu/KuD7w0qO88lq4Bma8wK9CcITYuXDIG1+Bp+Ufd5jZ9JRLxH/fixyjTlyWWZ523udNujofITcdJpBBMIaQFKJIXLRuR+HORsOL8XpjfeXWpEdCJxganRzmj/JEfTI4r3wmPrZXz31CZYQTkGfB93seK/JDLZxF1g57siUd9z5sKZ93Ze3mZkXoZVzeHAHWNj1IgSTrzBnAIHjNUgD/Jd+H7M0Asg1CnHf5TXpcm8aLPNWTTiOG4mS/UJFA2E1dp0hiz3ycXXIzEjBTzbn8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUBZYOqaE9VdbwFOZ94L4akeroQTWGS6NvOmHvPkkP8=;
 b=X+srNL4j097naYIBdMNNeQcEjj57rpc7L+QAVHFqji5/p6V1T7xleOkgfttv7eoSmoowfsD8/RLPCTsZdZChlp5rO6NIv1oNX9i6pkbAek36Drm9cCyxCIHvn6DTQRB39kGLFhUlUtX7aJKmS2QBAwsoLfj4poce+yD+cUVIGdLKMxalNVuHiabt/attFN5AFcJ4HYdudG05t4JLWqRewrFEAWsACwIQQ47TWOBrpLu1Vw6sHZNVXK83fYj+n1rYSq0tVW0/tb1yMix78ayavDFhj1rNHK87x9iPkGQrznlWo+IMYf12yccMuc71ae/6QgX+r3MCK+E3+MqTubTUKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUBZYOqaE9VdbwFOZ94L4akeroQTWGS6NvOmHvPkkP8=;
 b=p4UCBA7WDD2gpkJBy7OJIeSMcocMAm0WEdm4CPA0AvcMk9irUdi+zjVSXAtTlV1jbXONWkQ22NyzWmh59gg6a759MwqPl1Dqkb/VhCUI7hqijIsWpoHEWRkUSHnZM/x5hbvuvMaBA8Lfts6uicEQ/LaS9F14yUtJaDkVYY5wTt8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:05:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:05:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 30/35] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Sat, 22 Oct 2022 22:03:58 -0500
Message-Id: <20221023030403.33845-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:610:cc::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ab1380-7216-4f23-806b-08dab4a35c0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMEML46bNcvLrYm20mYV4sm3D1HoGJebj96fnMnYzPYE1pCrZOqDZG+m60RKysjwM0sEw9K65IN5+euGKRaOP1tFrNzspDnoTPv2FfiFTW2vGgpG/jPi5qxtUEBzw7lMewM2rut7c5JlM55hDcOUR8YQq+2YRAFZZ6/Tl8Z4ZARzsV0791cS0lGFbQRTZ5RiluHzOCyJo7O/xpqIQ+U7SxZTSrmb2Vc+mndQBhXkb+aO6TE2nP+srsDarhjbODUDyzlNiziEMAeLCLKk/jwPW+VRkNytSiAkNQ1yB1zWjIYV4YV8aki007WzAdj4Mw0JT7T03qzzrUgLnMSW/nRxrnIBV92p4xkFSziqKl7JhLtkjLySOZwmTAvo8HBtC1bQWYtmsum0k4oQRv4VXqlkv4MKKcXEGT2lHktoLKvNywWxJY/pMcTL7f0k1LFWzwMb2Nv/wVw+J1W3y/YLHTqxv0ZYTCAY/ulz8D6FCZX325kJfmkQGksCzwxIREN8Ing8fQao7IvA1tX/00VedVY6KZVW5k2viRxh/91JYbNgI9JdWViyn+8Fgx6vQHk7PE78nHRwwQ+CiVruabcVNdbS3N0XYLgZfwKobPLNU/CkjqYEc5rbdLkP5OU2Q3uRvUYYb6Shy8loUCQ5He1k8aJk1wMZnVFQ6Q2Hd0WFXR+2B25JjtsMhZDorrHHk6fziFy0oJJKTxbpJxa2ITk5m0Ve8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NuyRyZdLnUpkm02WKcBRi0YR6Du6eLKLVw0SsZtycYKS3cXqikkq3pcQM4g?=
 =?us-ascii?Q?G5MWlNwFmcSzEM2msdyDNXxFuaO4LdnUaewEYSnk8Ft3vek/gbNPI/vdZ2Kz?=
 =?us-ascii?Q?wPNEJEFe3fa15zbYtZmLQshZdG2GpDSQHatr3Gf+xNQMcI2TXr7vRWg54EQI?=
 =?us-ascii?Q?tyJ/++b218msErT59dW9nlp+WdOcDS1PW/UBpXvBdI89Us8h5VBlNMW8QcEu?=
 =?us-ascii?Q?4UrYaqIJNPHxkphRElBV6OicqFu1GdEBjVOutbscV/CmtZ/g8Yu9wGIhXLxj?=
 =?us-ascii?Q?xxclNTJCiewBrFanxlx8YJP9jQeK1xFDwQ/WQU4pxTU7/z1p3E2YUv6n7VZX?=
 =?us-ascii?Q?CPZ76r0uTkzaH4QPUq/edzgBETfAUSLj60yfwMXl+STq4QpUKcxC5lM3iRhN?=
 =?us-ascii?Q?y+UYRJUGmzQodgMMZFidJqNdWCzetsgPUuHaiytXx9d6jL48FQn8ItpTRKJu?=
 =?us-ascii?Q?DAA5twsFsErOPD3WPHrmOCkDjZQ+h4syvQQ6TtAsr5BwRuvc7kvtlQun7N4q?=
 =?us-ascii?Q?TEgpQSk3abPfLpGA8+z4QVahTs+9sssO3N1TOiAhD85bOv6LsM8Il9uNpEMj?=
 =?us-ascii?Q?DrSCRiCzs8i/Od1f3ZdWjU6lLWF/b9OmpHhPMXUIbpOy+itlu3kRJ4uzqrCE?=
 =?us-ascii?Q?hDm3Ea1D4qpv2LWE9rEu6cziD9cbygnFDq7nq/gNl0FwCykoQYcECBOKYfI5?=
 =?us-ascii?Q?Cop09sTWlpTFGsfhWy6hABeQ6ol8J0ws2mxQOHWky1Nq7LmJpij28M5ptsoA?=
 =?us-ascii?Q?1yObzBct01xlbDyA/zPlQ801Rplj3d6zTZ0orDpvWEI+kMXUl4hgmScS7Xyu?=
 =?us-ascii?Q?tvvUOFpEKUaYIw4r9AA/7PCFFPtLnVqcUWLrolRme7ucq4V9P/V7C4T9xjBb?=
 =?us-ascii?Q?tfdNIi0kdDYc5y7BGBL+F+LDXtP0LrB0Hv/T6uKzQjXEc2lc6SSFFRlc1ZnM?=
 =?us-ascii?Q?x3ERpJGmrfgOBOfuScHTgmDXMozThfv6mKu4m9VjqHyouVCFiigDuvcJxwhK?=
 =?us-ascii?Q?GO5C5VbDv5UbCuHXFJbuitpshtA1kTTt/US4Nyw4qImZTorX+8viiO0iyMH4?=
 =?us-ascii?Q?IVhihJCAm+raQux1f1k4enPhuFvyLXPmQrUEpmuAn8F3XVxhW0FxDxCMZR+V?=
 =?us-ascii?Q?gqj4CG7qeBHA3Ns/qeSWR0aWKDbfaew3WcaQXsayPds/SJNJ4VcbVU+Oy8eM?=
 =?us-ascii?Q?8KTKxq/VzKYpeTW/ApPdDavwi7o7zrqUD+CNywBd+Cn8K+zYJbgr8+HzTjmg?=
 =?us-ascii?Q?Yqr2R9cVmllzruWq1kU//VdRe832nbi/ZAgA/CRmwPRVmRuEnsfs7rH1vMJK?=
 =?us-ascii?Q?4TdkVa8gffxNA2PhDFqJGawTxd3FqEDcQ33M2LMH3oXq9fCuRxlRb7CUeHbm?=
 =?us-ascii?Q?KGTgHB4fvPYFHBHBwAln5Q5zXTddv8duPBHwRekOgkSrPy6Gby0aSWg5UHVj?=
 =?us-ascii?Q?iuzmBaKAV1rrgWfvorCDVlAwwnXEe/F1V/FE1tseepERpe/yo3gNMnXvuPGo?=
 =?us-ascii?Q?RxVAgLXMA5JZnEYIpjLWLP+H+RlvwIAnkPVaQIY+NBK1wYVPOZt+VWfgLr/j?=
 =?us-ascii?Q?IshgKWBO5uEO03DjvGLyRUpUEwao9FU0heFsnG9x94ABzstv9tA4dRh6yoO1?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ab1380-7216-4f23-806b-08dab4a35c0d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:54.4497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIV13asrvTAw8CgFZmDl/tEzuoAvrg3IutAWaQC5wNorToBn/nb8wQ7SiMit8oJbbTGi9dKHiqwfTL4omnACmspvlyCGyFmQhPQE8UWOnIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: 7-BHvOk41MFZ9-1fP-WOCbb3qpIAtR8I
X-Proofpoint-ORIG-GUID: 7-BHvOk41MFZ9-1fP-WOCbb3qpIAtR8I
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

