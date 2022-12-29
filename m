Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7DEC46467
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiL2TCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiL2TC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:02:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84AED9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:02:26 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxO1H004154;
        Thu, 29 Dec 2022 19:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7/Eat9zbDffMIImjWBM5k5yQG4bj0AjQtRb737E+1n0=;
 b=jAXKYeJqpy7gntDUyno8jT+B2boMSDaJe2BxtB5kbucC/tl+FC1wUppZ4f1sbVEHf4Ff
 v2BBsS6MOztlncroWWQkIbYqkteKcX8TIvMVXmTIJd7Ty3jnovkB84c2x76Xd9D4cRyx
 3x6I5IpqC9pGo6QPAEbfWcq74guoY2T1B1tbE/FLgGyX9mTwb4z4o8qjv3gKoc2pM0qK
 D7pEyESnm+AALbYiquRNnCuMYryGutlqa8qDWaVCRUPXOxLntSUIZ426ldfwcUkiydSO
 3UcdnkZHuhpwc9IESiQj95BnHhTQDK2NXOv6JREJbj5rnCru3eErj9ivWDArVRtdXswF AA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnr11f9ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTFkewF034148;
        Thu, 29 Dec 2022 19:02:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv6s0k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDO0XzmUPN8gLhxaNwiLBx9/s77jj0C/gzeTLN1gbJ7frkW6QPODbE/hC0JdkPP6jRlupJq0zCQLYS+j3MBBnKV13lqI+ECTe3m6vz3owXyk44VMwFROv/D9rl4VXnEOtTy/banE1kbasRY4+jEe7Ggi5VpVklAj9Tz0lsIPE9FEoOfZqrvy3XLMDhhrcjs2o75kMspEkJ4ddlCukFUAzNvOBTzRxC3b0nVtPp3m4tvoUnhoSAimH2Qu1uXrDzdlpCzKSTWrN+GlMI6H19LVZ1+twsettAM7m+g0w6bKJtMceyVV4OFNomz65DZdoox/AYF4y1gGiEUbyUErQdHLiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/Eat9zbDffMIImjWBM5k5yQG4bj0AjQtRb737E+1n0=;
 b=m3k+FrO7/YcxBLrrfWDqR4FR/FUGub9jXVdyXgpYd5y7y6mc7BxA+hHf5mg7IbSDXU9z/6DfjtJ9rFPm9GetpJ+GpBarIhBWFoh7hv2fuSYISwdyw74FQNwk7NawtJD0N8VHrCH/y29o02YLu0PnfA9jv65F9yNH+zPYcrtvJ+yY+YtwiSD6+Rq3lyCeB9TeuZ2d+wmoogXL8afMRQEAknNr5A0q/fVMnnxAfTj8SQ1Q9bw5X1k/4TzZOpr0q/e7PGtmOneUTo0izkCBkPp4q/4HDeb8KusmMvBu4kLAAL49ChVnvzuTr29tor99C03Z0vG5DJUBWfdrqtsf0W7rzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/Eat9zbDffMIImjWBM5k5yQG4bj0AjQtRb737E+1n0=;
 b=KEALOuziOukcJrtX5OmwYlFMIfhxO0SudQY22jezYnXQ/D0LT22e4InTs0/KPCTZXIc43qUqgfzeBtSetV4XxPjSqhQ2SXqiDIXwTq+iE6AQlIy7XFvK3dbbskZ4gLWw0Q0X7on2aQpL1Z7leqQrqmB/54cErpheTae3SS9DMt8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 06/15] scsi: core: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:45 -0600
Message-Id: <20221229190154.7467-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0433.namprd03.prod.outlook.com
 (2603:10b6:610:10e::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: d2e67cf9-6cc7-40de-07f7-08dae9cf2e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzPiYIDQXCAmMDtVSAn6ZWeGvjsRfnWK/Xw9GaHlQEALe/lP4PGSP8AahL6SaqgIdFTXF6Yhuza3t6XmUAbXYxj5sFTqQ68+56BrS8KRnQpjwphy6wgeQ5UkxXe7MwwBdIoUbDwvA8a+nvm1JNkBIZRC1Oa543FjElwFKat8E0IZtMhrj+ONH4p1stodysgICVya8jWTAQbKqRlzQNQnmD41TLfYrZWRdlJb3HYh70/Rf4rUaq/ntNVr99MKAu6bCT87fQlHNcHeKnYUMPnOKs3GuLt671x5Vg6AvICXRscejbj+yY6X1PIFvfno2CJ+Kx0AEmY2peAKfPzPZPlVtSS/1zsMbXtPFlovSNKgaK4/9Rrl3VyDgc+EBfqQy+7b2MXU+l24zxEql1fD2TSBs6XtFdYN3s7VpYdwBS4/zRWu/n79vRZqYNu6qJLUajb5+mJVh/7exTVJtR4d7toIP+ZfRnnyVr0sVR4iiPi3gr+S5wypaHQ+4ytTi6FFenXzBkro1ya+AHwRv8/p9DN0PIz2wqtDuPGl+PxB9rDiEh+0TTS6TO2QldzWq+Nt+KMwQAVslCMKAtW00s6lCqzFrHGLC+WfwUVlFaUvoM3vRSzWunTEi5i+BHIs67Iocg2dX/3SdN0rH3ahsJwXrmh50A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ydl6F6DBeriuhR2s6SThvWa7RJfvc63oSCk+Wf2Rwmr8NXgcGnieL0TzCWE+?=
 =?us-ascii?Q?lcK0jqZlWLz2R2hE1O3GB+Jw50tIlVGqM+lJfGxM65D79/db3ouWXLF2t08n?=
 =?us-ascii?Q?ecnspapgUhkt7Eunu8pthgpbT41wu8xkUWmb/dnRlHKzonmm57U1dmMTjhvZ?=
 =?us-ascii?Q?aJpmdPbYZDoVN/3zS8cLEWvK8ZptSbc4g/P9+WuHXP4LSF+Vm0wSEGGdeLWe?=
 =?us-ascii?Q?CpLlCVJ1D+L6ANhfrv0xwCmPqfGViF3cWGU3VbHWx/qMMMBhwXTfL7E2S2Pk?=
 =?us-ascii?Q?ex0Z7tqEUJorfZfb2CUh40vqCOozJtENqfvtIJJkvAtysK18+a7kbqUSKfNT?=
 =?us-ascii?Q?idbdwcmJD08KkMtFsB0TmXCYNmL7iiMKa2DpYIm7FEBCCQ98KTQsQ79WrWhW?=
 =?us-ascii?Q?TTRRiM6Xj6XdZbgE0ATXo3GLHk38W0k85PA4uPWENM5mgL/AhwjlC302n5FA?=
 =?us-ascii?Q?94Be0+CWEn8vooG1ntYA6tDasBl1qqCfgWBGLgFbpzVqUr+/LXxszicqYKz/?=
 =?us-ascii?Q?vJPcBvvgoYaBH/4IZzljevBE0r6HQQsgWpyId+uX88nbI+5zqh4zw0N2LuRW?=
 =?us-ascii?Q?wN5UXOPcfG3BUuvH/PXA5la6sz5LMfAZLjaT9jqlWWA+9VE5fyneOwIs3oI2?=
 =?us-ascii?Q?3k4kX+uB7DMWtwtZJWs5hESWBQYm4/Rz1fCiTlEOR/8aTA3FaXrL9jQGQDDr?=
 =?us-ascii?Q?x6wgCVdVvewvduo0JgnqHiGG7Z+9sDPBgYpw8y4QaofmZAxExvr/PSwyk0JW?=
 =?us-ascii?Q?02nsXzC8yKcciMIXKCzC29fC1LW74rRYgU2NQnLnitDbfvgfmdz9jhmXAByH?=
 =?us-ascii?Q?caaZBLFrP7p4yjDZAyFvXF2URPo3mjqSh+ziVfVgZ2nmeC1VtNH4drzjzPus?=
 =?us-ascii?Q?mykjXUVyFjAPYjPABLrBmF8Jk1yAWuP1w0qIRGXBoTqgUVx/DwD9dsy9a5bP?=
 =?us-ascii?Q?w5jMqOajyX9YH35uc+PsnrjVyLxTSA3BEcVo0TF9ZJR+vEuG4IkIDwrOCItA?=
 =?us-ascii?Q?+3v2YSYtqOipUtlR9rTpWGFdc+UrIhMKOBH5XCyj9sFP8+6MLNbUNsvJ9Kzy?=
 =?us-ascii?Q?kjUbEzBcYRczgBJxZme2WgOnaEkGCG1AUvzLVIxDFoCqTNvpMoO7Dl4j35Va?=
 =?us-ascii?Q?7rPIDgl6eVJuq3eUIcz3ynz/8k2WSE4cKeReNfqhk1LQR1wsyRnZVIg4zHCs?=
 =?us-ascii?Q?S59vfMrrXBBSYin47em/vY+pKS+P3mg4dVgicpRHPPNCNcWd8rzSpBVH5/6l?=
 =?us-ascii?Q?HD8XU4AwtS+VK78LptgqU52W7sZ/HSAzwNh5JEXYppbSxSUut40k8FxzNctL?=
 =?us-ascii?Q?08u1lrvMQ/0qZHBKooLLJabFWbSsohxEHGuOU2DtDoCJOCWUH8+6mbFrLvuu?=
 =?us-ascii?Q?aRm1owR+TY/AaEuc3SgqgSDTk6+S5MGcuJHltcEMqugiJ79sMQg6SxV9RVT1?=
 =?us-ascii?Q?KKxWMEYc1mY+orlDPZDdKrNWDWHWXc/DxIRg/BY3kehTRKmtqa2jwl2WeH1O?=
 =?us-ascii?Q?aBIW3U88aucwEbSE1YLRA+olvAeU0aFXoGdFLxD1lalsgYKyBykB5+rbNO5t?=
 =?us-ascii?Q?U+YPlnNrLMk8VBQvzfUISso+vs0/byINpbZoZlET7Bnb+P+J0WEnvw7ULmLJ?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e67cf9-6cc7-40de-07f7-08dae9cf2e65
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:07.3627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1akzBPI1OWcN7bKhIeUZhZdicERprdXrdN98q3NF/6HT4EZhRPKMsvgc58gTBwCfomfr3gdaWo1Eh/jaWEOCeFi7ucI7/ENjK4j5DdWeqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-ORIG-GUID: bldlqqhh3q-s5EBeCZtZdj4-bDs0sX2P
X-Proofpoint-GUID: bldlqqhh3q-s5EBeCZtZdj4-bDs0sX2P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert scsi-ml to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 7d324db6b2f7..abe93ec8b7d0 100644
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
index 7a6904a3928e..a62925355c2c 100644
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
 
@@ -646,8 +646,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
 
@@ -665,18 +669,16 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
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
@@ -1402,6 +1404,9 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int ret = 0;
 
 	/*
@@ -1476,9 +1481,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
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

