Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D39C4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLNXu5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLNXum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:50:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402484874E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:50:26 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMx7OH000616;
        Wed, 14 Dec 2022 23:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Didlr3hOCl54gPWFPXYCkcabz0z8XfYqU051YAwPV+M=;
 b=XGAObBREqNRSkTSAJzmlily6Hbp75nnlxMcdoB5rl6c3E3/h3iqONonDg8bFtaCY01mj
 lekDIn4FmkO45K6rZsozdQuop87/uq0I5AcJF41ZXhc5sL9JyfpOqi2cSb22PqXqBpBa
 s8G0dS7gRt6ECC68GTaK2vS8QWyw1IlaMvfGipmGYrgHxdHB/cUle429FjBzH39QB8/c
 jK+6savNmOgK9ktEcS3rWXWpu7bixLigKTO+tJW6o3bbmX2zdT3FwdvwqcJ/4Ssi+Bgx
 NmPbCLj5Y8bzFXgL1lHMexO8vW3W8p3BhVzTj3XY3TWkxGlrnQXwmpxUwUVjFD5f2wmN 1g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewuqt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEMosUT007120;
        Wed, 14 Dec 2022 23:50:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqkkmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iV7b/lQaTH4maGnoCccJohnl+qzn3WDDtVqZj+3bovrTubPpqEPQ3Sjyq38WymbFJCCOKIjkxlP/h2MYyiWMCWJ7EyICR/JAb64Rh7ttLjs5O7GmIxokKsvuFDSl9Xa3kXuBDKDnriRjYpiC36EquV8flemk/Asu6UTimQg5f8JN+nmyaYsfCTd4hDoqUVmodejmN2tF64vcllUZNn3xbeBtvYX8s3ZaX/EIBSMuxU7ak0CGYSLMZGE14bPnHCVy33KsEzFucaNBXagQkdf/Zq3n02BVrU4Dxg1mkuX5Tv7TIoJ47bQzX4Js7yzy8B6g/oKRsQARD9ovBcU3vo7hSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Didlr3hOCl54gPWFPXYCkcabz0z8XfYqU051YAwPV+M=;
 b=PpURDFjR6EtFCoTLo1JXKYLyT6GCtmo8qInibV+4onIj6q2aXdDJLAeWSULmgEjvzYX36YG3O6VXMqJZmwXn4XeZWkDtoWaTnA+tmM8zQjr2sHiinloZeb3MM2buvtIaoQTKEdup+WMxu/rcIpKQFUvhDMfQS4LTP93o7nujGGy0mKd+5fC0daSZaBH/s3Y/kzqLhlMXWJfv40JrUXwGgknU7T0ChiBtADsL1evneAJzDJua7fhU58EN6rhWBYMl4NpaN+ymAgA1bTluEltcD/IjRIkrGM0srNLOZhov8X/2p+yRtzeWVHuy5XtUpYpsUWYo5BNtjbt8SKakdgmPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Didlr3hOCl54gPWFPXYCkcabz0z8XfYqU051YAwPV+M=;
 b=wioyO3kz0NZNufGaMJaePlJSBHMxRnUsM5cExU7XqhMZiH9opg3WjvqzPaWrDb87e7yhh83vMTtZLPisR6VLeyKSp8sR5Vs28kJBO2m8ra2xKms+fwTrypUWXwtIFyUx+QBM6TiKbbH4o03vUA2bdSyF8Cimidqq6gFVYIz47oY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 06/15] scsi: core: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:52 -0600
Message-Id: <20221214235001.57267-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:610:58::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: afce1f77-4ec4-4169-5e75-08dade2df1a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+iskyd0AwgBauZ5ZqkQgGFwItBVtQ9ctw5mK73hQ2Qt7xSGcE5TF71gWhAGtoA6eOSgYGhKtrB6lrp0v+/fGtEK7X1mLEslovbL2xB4AOHU95zeMsy7eoxR+A+fqVQ5oZpECZ5tMszSdKc0gX8TDhNyXI7F9cinh4atWdnZsUBCyZ8Rst8Bat4DVcJCyhTN4P5iTfLN6sunGjloE7SVlsn13wQOVri+qZzc/ftV2BhL9vLcXUTs/HRJ20k0SWV7o0H1TxXg5Sv1hymKdunUo/o6dZzHBZzk9NyLSOOEBPj2d8z86t7VsFr1VvSsaYTcD2CAWVDv+LNPhHP+DFS05gUavBF4VldEjYSXJf1zTwAWsWmOFmmp9k7u2SWhUuE2UZ4FwsBAwqHX0Wj9LDZJYOpujOwSi6SN1w40TBuJmg93prJWO2ao46OZWMMIq0qrJpKN9iI+8A9wwESP9eUVbjDcMAY3Om+WaOAYanxBrfQcQbjtRD3V9fFI2LHW4HxuE1KRfcErIyMIHIueQIk491JticG59Km1QRfGWXMfPDan+QzII58zawaQ5TqpmefyS4ddW4uEZsFHC9abX97kSWYZvnKb+8d0M/6Ur29U3qjPZkDTfq/dwX4OyLKAMZT2mABAMaoPXnX9XRcbDaoxoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mQw8YisxzLBTrTYGA0jc3D1vnLT2SOHMw0zkouJixEZnhkY73XE/SPQkENea?=
 =?us-ascii?Q?+hEWmIzVhwK2oLH4iL+0QO1iAUzc5wANMf7/kUPOx8ImsnHyWg03B59LZE0A?=
 =?us-ascii?Q?aMJguN80g5OdrAyXmBFz2iIncfwZM7iSIKn8uVWzHGfL3JsAL/YIPXRw4i4j?=
 =?us-ascii?Q?7GVfM7MXbBVJT8bGmUIeZc7uM8H8rgIF2NO1YcBxC7BQKQWSKysFT/WZxIff?=
 =?us-ascii?Q?a2UYT+wW9VKm6C83uznrUxiLKfUUpBOxUXkireaY/I5UddVDzAdpBQDxdkvY?=
 =?us-ascii?Q?S9sUy6cjBGS5fls7Hi+B24GKuv7z7Gc8Fz7aNM2dG340HgTRxiJpfB3Jmlm7?=
 =?us-ascii?Q?ASCt+fzxS3ebMzNqAOxeiNZOKCmc2v9ZwdkZpbHauB9+avBjA48VFfyN3pZj?=
 =?us-ascii?Q?m2IddjWgG2vDwcxzgKiJgbme9oW5513zWfnFYURx/yFy1a8cQLVgfvoHmhKn?=
 =?us-ascii?Q?yggH1V5D8JIP/59hqgB6pD5U6KCrhn8LJ7vaItsr2NSfM/Oi7Vq0goeULOsb?=
 =?us-ascii?Q?l+JEUbcdZhboSwFS/rLlZzROnO2kNPWVp0IsQnYdH5kYF+YtMufkWe8vEMRc?=
 =?us-ascii?Q?RSxIzo3CozRBcEaYyzQJOknr//+PXslRGuGMLBc525+i6ECL/3LnCXFrJtRu?=
 =?us-ascii?Q?dccNITeQFkpNcESZOjNNgKs0QMjbEMCRcDUxfckC2OaUsaewl+G8HlCxoBIQ?=
 =?us-ascii?Q?W3a/BgIh6rRRFX246tL/z6fc8vQFlePMAuTAWUFED8uiw/frGRI1Sad7Y7UR?=
 =?us-ascii?Q?J8aSckwXYCL7JiWtYEJFGFQQKF0PM0tVWZT8Aog9D28wi51fDo4UyLYHurV1?=
 =?us-ascii?Q?d7uPfLs28ZscR8hnF9QowiA39gWs4i5dvyd7xOwK1RWUReeMaW27//dc0bLa?=
 =?us-ascii?Q?9vcu/rfi8vNCOmmgCcEJQQQ9vaiVRLx3nHD7kcPK/N503XA+47O5mrl29Alg?=
 =?us-ascii?Q?OP7np45yWUMj5Snj6FelomA9La9xFUHuVR555uCqTQm0qCyBi+PnyM+TduZX?=
 =?us-ascii?Q?QjYZfEDOJMrxCN5edR+KEz01xkxXEJ1VuOtHE+kj/WkNUKfRZ+J7YHgiv+SE?=
 =?us-ascii?Q?2ntophtejnVtF9UysEnezbRg1TnzDtORDFPBrnWVQuleQfGySmGbj5etyzNw?=
 =?us-ascii?Q?5SQbGG1GM5a1Zhc5RK5t73SCfWnA/YXUT1UiMXixzd3VaBKhCxwLOntArlxv?=
 =?us-ascii?Q?gHgBsAodv01XxDHhcYZr25dceslAhc5j0jS3TplRG9brSLZSz3+2ickL5J4t?=
 =?us-ascii?Q?Tkssn71ebI1q/3Qll+pO0ZFhE6l4ki/YGS9fzey2C+qySy81XIHfoVRrR9S+?=
 =?us-ascii?Q?0wOaDwB+BYzXW0VW0Q5JfzNzozoeXPkUts+9ijff6TZyvIeou7kAzR17NdCo?=
 =?us-ascii?Q?a4yyOa+Wn6sdzb1NIKTi4xt7mSYKqp5kmFx6OY4UOIWosVurCTIcCMDmQ7dJ?=
 =?us-ascii?Q?H25GCMh4Rn2HylySDjD6Ll9B8mVfsJ4R5G5rzVykefrIZ9JKGXbamRgoRQLg?=
 =?us-ascii?Q?qxFrOL7j7VxVnEuiNfrLt35jf2qoCtjwRRAr41SSQfE0QHHSAiw0x8754qjy?=
 =?us-ascii?Q?2pfrIXaZwc83g/xovb6nxKlAvg61HP3/VpsMwfUXDh+QY9cVYMmLKUJQ7TKg?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afce1f77-4ec4-4169-5e75-08dade2df1a1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:13.6375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0d3tftCSazwG+yshKz1fJklSSGX+hFRVCaU/mKqHcLwJQQgptzxtNbZOVsnitoITJ9suwkhagijRkJwy8a2c07L1IFLdQ33txw4FSxpL+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-GUID: kKEMdGXKdMlSw9ceSX4Wqi0qxXNi7C9r
X-Proofpoint-ORIG-GUID: kKEMdGXKdMlSw9ceSX4Wqi0qxXNi7C9r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert scsi-ml to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 12 +++++++-----
 drivers/scsi/scsi_ioctl.c |  7 +++++--
 drivers/scsi/scsi_lib.c   | 26 +++++++++++++++++---------
 drivers/scsi/scsi_scan.c  | 26 ++++++++++++++++----------
 4 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..00ee47a04403 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,8 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer, len,
+				  30 * HZ, 3, NULL);
 	if (result)
 		return -EIO;
 
@@ -510,6 +510,9 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
 	int result, request_len;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
 		return -EINVAL;
@@ -531,9 +534,8 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
+				  request_len, 30 * HZ, 3, &exec_args);
 	if (result < 0)
 		return result;
 	if (result && scsi_sense_valid(&sshdr) &&
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 1126a265d5ee..e3b31d32b6a9 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -69,12 +69,15 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 {
 	int result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+				  retries, &exec_args);
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7baad7ec8887..9a8ca20dd015 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2084,6 +2084,9 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 {
 	unsigned char cmd[10];
 	unsigned char *real_buffer;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
 	int ret;
 
 	memset(cmd, 0, sizeof(cmd));
@@ -2133,8 +2136,8 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, real_buffer, len,
+			       timeout, retries, &exec_args);
 	kfree(real_buffer);
 	return ret;
 }
@@ -2165,6 +2168,10 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	int header_length;
 	int result, retry_count = retries;
 	struct scsi_sense_hdr my_sshdr;
+	const struct scsi_exec_args exec_args = {
+		/* caller might not be interested in sense, but we need it */
+		.sshdr = sshdr ? : &my_sshdr,
+	};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2173,9 +2180,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
 
-	/* caller might not be interested in sense, but we need it */
-	if (!sshdr)
-		sshdr = &my_sshdr;
+	sshdr = exec_args.sshdr;
 
  retry:
 	use_10_for_ms = sdev->use_10_for_ms || len > 255;
@@ -2198,8 +2203,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer, len,
+				  timeout, retries, &exec_args);
 	if (result < 0)
 		return result;
 
@@ -2279,12 +2284,15 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
 	int result;
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
+					  timeout, 1, &exec_args);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 920b145f80b7..844b3cb556ab 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,7 +210,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
+	scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, result, 0x2a,
 			 SCSI_TIMEOUT, 3, NULL);
 }
 
@@ -647,8 +647,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count, result;
+	int pass, count, result, resid;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.resid = &resid,
+	};
 
 	*bflags = 0;
 
@@ -666,18 +670,16 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
 	for (count = 0; count < 3; ++count) {
-		int resid;
-
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) try_inquiry_len;
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
+		result = scsi_execute_cmd(sdev,  scsi_cmd, REQ_OP_DRV_IN,
+					  inq_result, try_inquiry_len,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+					  &exec_args);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1403,6 +1405,9 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int ret = 0;
 
 	/*
@@ -1477,9 +1482,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					  lun_data, length,
+					  SCSI_REPORT_LUNS_TIMEOUT, 3,
+					  &exec_args);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

