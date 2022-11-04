Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACBEC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKDXYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKDXYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D880B248F6
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7Gc013358;
        Fri, 4 Nov 2022 23:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8X+JWQUV8Od86j1ax9yjgfmge9XaVfHHKHWpm1Ex48Y=;
 b=QC3XdTvfelN/wxJ3KE/7kAzhAJC/HHn4akekzpRx5nX583b4/9WV4Xq5Qlkn8E6DAesa
 JgAxMfNBC+BHKL+HiFr4fEQ8Ssds2ad/AKAmBCd5M1cBXDXXuWMJRoYonuRgLy/7uzqf
 iZUQ84AaWLHYuO3m/XXv8V9YtsUVyJWZ1ONaoH+noIO7nVX0oXblh+uSPSPhi1VX7qle
 he901hRal4NwZ4YlYUQNrW4MOSDPdvyK1hQu1PiS94n3A8ecZ2shqOy9Oo+6V1Y1JnjG
 SeT0lfG1ysKYQx8ylhWS3jyPCntPz9uKqtbXZEp2aMHivphH5NSFrF3IbBYb7vE7jfCZ Qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N9O3K029321;
        Fri, 4 Nov 2022 23:22:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a94r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAW/SrdfBHpReF442XB2p5K5sjhPxGFEMwSW240QTuSPXDJgk/YgGgBHvzWMnoYYJRHEWI3DvaJGgwECBGvxq1n7gq/6j2F24Xzkulb8WUc47e4LGpSwVVE5LqRxqz1QH5k/RTkw+11fQuLPWsCsJHFdjCJW9HnkX4Sjr3ZbHMmYJL5tbX7SyvDrxp/EpF2O1IGfqBaTOIctG0giJYc19H5YwTluIWYSuEyFU72Ugalz4TBZL6E1CkkyXo6ai2IXsDYWjRqyt1TGlZO6d2YZBAOulop8o0b4WNfwyvqGTepQKMiF+lb8O4bzBRDJN/R4pba558y4ZWKK2MoYm9KfFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8X+JWQUV8Od86j1ax9yjgfmge9XaVfHHKHWpm1Ex48Y=;
 b=mBfRfWlpefbVEABJWZ9F1AaX+Iwb7D04GFtWTGhP59gHCm0RhWo5W0oK9nr1jokMgphsjsYJ9MCXkTQRU7BqJ69MnwCK/85fMzD8Slju2f2enYx9ZTO7AYeLKi/1AmrfTgdR2s1ipCuTaCJSLAJjXn4KkQOlwKjUuJe618F/aPkLRqhUEsJC3SbA8QF2/c3iGsnX68kxZ+7d0OzvX9AXnspbeED0EBUpWmadkomIhvESQ7ZWE8/VL2kYQYMG6LvfCNFxBQBScg8uqs8eCBch/bd7hwtjwof5RkbMh4k/2M14aRSHHJ7VmYwsUIVc8VcZELW+0etH8k/2F1V9uuaeig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X+JWQUV8Od86j1ax9yjgfmge9XaVfHHKHWpm1Ex48Y=;
 b=LbrBeYhy0990RtT2P5R5PUY6/x49KlN+pJBdcwJ6QD2ECNQ+6Wbs+MW7quEYl/Ht4dxg1ORBwjU+QA5CQhuO/3Ec5QYiJQrvYdBHCRTCM/hbkrg+TqYJWMLO0+aWTbZsaGUTl0mEGDWJjdHNWC8hCQxVP/WrstPao8es/iPtpyQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 19/35] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Fri,  4 Nov 2022 18:19:11 -0500
Message-Id: <20221104231927.9613-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:610:75::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: f85793cb-edb5-4ab2-b51a-08dabebb5aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbiW8hpviYOLLb3fL5GdH7YSOzDjkxzZEn9WlcmcdVHJrwIEhQUQ8XM/USXOrNSidnG0Fya7zukcox4QBaVtt0Yrr5VtpSqX2TlCJt73GKWUGl0lKwqJDxgLsHj55P6QEPCk9iWANfUIX8EAz+RBsF/XGdzfSjtlSnkPp6fDWF1CIpOcdJPlW8P3bc7LU0oauFHTkK5BocmY6ntXM+ElBlRKY9NILsxLv7Chc1bz7B1MO84+tIBUQoYCyptGDlr+5slGZwgkckp1sjUQbXlhMSe+AvqyTjvUtNFwSKFNX28Jw7MgL8DLqkXfMEjKRbdklY3iJZiOrJKbBWJY3EMM0re3KVQx53+h/PFikuvOHSlZyGl8rTONyeJuk3wC0JrEHcztrR9IEIPjSvUn+domiFKyWVfrg8+4Y8YFroiHLjXg+HP8/0hQBW059fiQLrlY+27IpnQX/xjkx4D8Nb9pkzEN9ygUyZmf0MLyJihOjeRWP2oUphv8T8OGmQNdW7R9dk5bFL/F1ThfiRjaoWaJtZLi7hO8EWJon/mjCcRljPK1ytbcBdX777s4PHO3EhZjGszI90r0ifrWUrDYZbmT4RmsGBCTYePF8y5uTn5Nwph4rLiTsssxjGdf5HKxU17DYFLvnBroBysoSWl2gT5jszJN6GQDYZTivIAgjFFgP1DOXPdSLEJvMF0QcytVocnuVWudXoKvUi+v4nRw2Tvasw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G5R5ZgzXbWAN3N3KAdELl+kyemqGtWJ9RPwiqfcwxtSVafptU9FPrKzQi3V6?=
 =?us-ascii?Q?+nnAPZR0Ao7Wsom7Ngcz28uaVIGRh+MGGxs7PKnoI0OMtmPWvVCtmvkZ3VKT?=
 =?us-ascii?Q?6XTbt5kSFuzVtkSsNVz3qoyARYZyH++eVOCfnat393zk6GGz93FTCDmpqgQb?=
 =?us-ascii?Q?HUK94qSpOveGztor573WgInBWwfAdHRy3KvV6++k1P9/RWduyhHbNEcUMVyM?=
 =?us-ascii?Q?/zMq/l2rsZASkcUL64KDDOWsSpi+VeW16XRKpmZmmHiIz7sPdhO25dSLm2DM?=
 =?us-ascii?Q?rNuJTbNJBrs5Bn9R/KEc5Ga22Y2a28f1Ec5xZwn6JplbVFV0bRdlIxiX0h25?=
 =?us-ascii?Q?FvPDBbnjVvmVvxrpHPHm0s7XwK19x9xEH4U7xGSFZ3g0SIhTWoujcyd6fsvL?=
 =?us-ascii?Q?xBYDU4ck5pwUPbccEgk6zH+bvtJo7t4l6V/GMXAdGWN8obsx8S/689EZBev9?=
 =?us-ascii?Q?LkAMvat11ZyJlb8x4YXui3k3GerGTtt0rkJX5lti5BmKJw6MG+oSmBJvNHyc?=
 =?us-ascii?Q?Yg1Ky4IjbCE+aTj9TqCX5Q7qf8eHGdS3WI6zBMPJ1REKG1pXka8cVeSHOTaf?=
 =?us-ascii?Q?MpS4QZaLNbTWNCwdYssFB4tCLz/4rAGXfmVa8SNw/u6SQ+7IPqjpl8ToIY3a?=
 =?us-ascii?Q?vkFkkKqtLiEfOA3r1V4Y4Y+4dZaevoxLT0UTArhA7F21t8xjuRTgzKBAb2JJ?=
 =?us-ascii?Q?L622+YQytoywlGAtlZ2ZsvPD2NAwL0zZNePDLa12xYoAPZtVdUqlVC/3Pume?=
 =?us-ascii?Q?XHC/UoOwAwB+AV6kJtd6W1NprqIFvx6FizX95NH1qluYCjPtbP4Jcz9dW+W4?=
 =?us-ascii?Q?ZXUEXfiMuhK6Uta/4+q+lRIFqOprKjdpLu0ziqQv4oC/J1cFFTd4MwKEhdpu?=
 =?us-ascii?Q?9OF92msIfCLNKw798qH9NoWmCxOekdS0FzCLQtwhMMMUfmwnsEq73yonNmWy?=
 =?us-ascii?Q?b9V0z7sbBJm6TaVMKvk9kPYrONgP7qkwrXnMktbMWKJukHBFrhqXOcMwdbTg?=
 =?us-ascii?Q?k7mbyNmYVpk+dvYKtS7gF+j3S0MQbsX0UKDMTJDeSuFNbMSsTCZ/s+qNClnG?=
 =?us-ascii?Q?XHlZBegddrpdgsa9IiV5Kb4cBL2orc6AqlSeKEXf98gDU3s4WAAvi7NQhXUA?=
 =?us-ascii?Q?2zyRkwVO42QL8bAkd79iMaZXwQ/9VBjVWb+vZbU7L07DzWqauRlalr8jnbr0?=
 =?us-ascii?Q?ad1/Hf/bDqdDrg13766J+SJFlcqNgUNm/ZVNWdsfUVyyVpm/n28mh8i4X0rE?=
 =?us-ascii?Q?AS7PvrxqQhq+/8p8Cqv1MxfZSSTkZjBTwE0Q+52L9kVhbGM8R1m4n+u/CzWL?=
 =?us-ascii?Q?+Q3fAp2i1zwqH/Yj+bicOzd7lZCcArFjAi5IXJSxYwbb/ynRXKRbyY2ihZHl?=
 =?us-ascii?Q?n77BgXNngl6ACGjV6VPpy7ZhZFf/0EpuuZDMcd7RFw330yxl2D8AganzZwBx?=
 =?us-ascii?Q?AUkECMlMbJrfYOKp/oEtyF7TNNFI1RUPmTIWz9Zq5gCp2NeozaIOkfFRHWWv?=
 =?us-ascii?Q?X6/BVM/4ZWiIkRTwGMYBTGdJyLgPuXTtEhqbg2rtpwVx1XqQtKZET/E0yJRH?=
 =?us-ascii?Q?XVL39DtIoj6AvZVHvGno0IxZFDm1Hbvwa79XrYsnAVDdLHctxnpGVb6ssbGL?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85793cb-edb5-4ab2-b51a-08dabebb5aca
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:51.9148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFAbotoGIPKyCjBzSx8qZ4vristaoGcqlhH5+9oKgqLV50j3k3xiolGElyap7ZZy0qmVcij+Gd5KUaDuodHgKTZCVeqKFvZ9ju5qj46KuZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: OsAMILLrKOOtEtIkigfXJ-SXc93KfWCM
X-Proofpoint-GUID: OsAMILLrKOOtEtIkigfXJ-SXc93KfWCM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 51 ++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58edd5d641f8..ffdb043bda5f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -653,8 +653,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count, result;
-	struct scsi_sense_hdr sshdr;
+	int pass, count, result, i;
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
 
@@ -671,6 +692,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	for (i = 0; i < ARRAY_SIZE(failures); i++) {
+		if (failures[i].sense == UNIT_ATTENTION)
+			failures[i].retries = 0;
+	}
+
 	for (count = 0; count < 3; ++count) {
 		int resid;
 
@@ -686,32 +712,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

