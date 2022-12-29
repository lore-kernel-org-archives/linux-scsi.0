Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3052EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiL2TEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiL2TE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555BD1400E
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:27 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxlBS026477;
        Thu, 29 Dec 2022 19:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=eOjPBHj/Sn1oef3lbaZ8B5YOqX59BGSGW8yjUU7cum8=;
 b=03/ezF4PhbJJv++RpXJe6/t+drNGFnMthiTjz1RRShk6c4Bvl0DJOf0So4enuV+Eze9v
 /szsVJ/CQp+NYTNkxOMdHKst5ymgCD/t8wj+8Xr/qmJa+WJTko4V0rlu2bX8JQNicPES
 CF8LK44uJtn+UyuBPmE+WublXdoWeX6Q2568e+53+up46UzAcoJPJkgJEnWvDwVjCLwf
 2UuMP9Bnz/DSxRw13ROpxF9Oh15nsAiFGsXEASjagIxCY0gwITlL/41/pZjnVPraCvBH
 9I8CKpgyuvmiQUn8D+06133TfStTYz+ItgT0HXeLG6ujLOovi2TOpbp+VsKuOT4xj6iR Qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnrbb7aq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTHiiU9034234;
        Thu, 29 Dec 2022 19:02:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv6s0m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2PyG1sx/iJmHDGzD+d9eubdbRVzJuvs5T4Okwy32XgUS9jy+UfmGMTHg9IFfZlr7/14ZG+mxvbYjCORi/E0EmlwkOslwuisi4xztZ2c+kXlpX83+e1BbnCSlgUyHGMUW0z2t70APkidVZY3ErDZHeny/wbUJ2jORbi9NVJmWSFe/Cyc1/l7Jjf2sCehMOTBE+EVhUExji2Et/lQ+bU2abh2LKxBNbKAkQHwTShsW1tou5bj2yzZtdFuV0BPnJ+Sb1E//Zk3i9UGifRO1lOVeTOr8vQPkd2gqxTijzoHYkC/VcVSJtszcqN+Xe+xQNJf389V85MZxAmxu5Jr7xq0dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOjPBHj/Sn1oef3lbaZ8B5YOqX59BGSGW8yjUU7cum8=;
 b=P6gzkdb7u+BE4gnVwPWHwJjn6p9KppXnki+37Iayn7RxCPuyP5OqamWLkGQc3FSI011LeAK7TnA7tPl3YBPM4JC7yKVESJ/tmVNnVE/VL9XatFcs5yTNzKr368cPKbPYeViXC2PNYjucq/lg8LEhPWHQ3b7m4O6PregNWip1sKdV2xpnBrfXsg52dEOCnDC/dOvXeEYhuNQHd4QeE0rc9h4yK94OdYCoaBdJyeeunSn2pRiwiOjSDXe+cP5EEYnwYw01lQpVB6iCQtMcczeh59npz6NiKw0QX5sb/AKrcgS0qFoeNb3Q5a8nKFVGO7i0ePumS+XUErAgVEVGKb1gNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOjPBHj/Sn1oef3lbaZ8B5YOqX59BGSGW8yjUU7cum8=;
 b=D4WXsaOVpLDZQ/xeW7QBzCGe5JZKETFhxbvXmi55DqskhuvOe7WKzObm+rTQhLlxqb30QfiyBO+Q9hNNyEP+a1FyxOKY/Re+8FJO38VKLii2IFNuHZ1AHWqvO4armzvyHbbvATBBtiBOpSmhMOEgc/vli/ENBOLymLwbFBJDu+o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 08/15] scsi: sd: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:47 -0600
Message-Id: <20221229190154.7467-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0016.namprd20.prod.outlook.com
 (2603:10b6:610:58::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 4778ef92-05ce-46eb-aaff-08dae9cf3059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8rAUrGpH+26s8hHMySS2ieMOVjOrjWy2R/rccCdcZDvwVK8hMOBGnXHJDulZ45Cz6MdrY0qmlW+s26YiSVi7ER6giL1knHzz/OGZ5cudlc3q4jzWNq2aHYdPTMXf01UBEj7pCjyAmzqkoQgGhMm/pNG44bOS9dYi58qfBKDX1wZJtdPx64mzNy3BrPvoFjLycdptafmBuJGkN5gLBH1lB0qlzctbUFAWaOHXhGQrW234ZZNFtSS8W3oLZjh4v15pHgwcu+rfZlLSx44OQvi9FnIy9E8XFrOS2A/lcwLcw6q9vIkp58X3iCPaN0FqyuDNXr5UaAaw4YrhZuQKv7yssDxfazIkBAML/DdEOSfYUXWcQinEslbY1hv++nlnXO8jmUL+lYtJLivyaud8Tg4S1q9dtMP8um1NqTAilEEqEw5KQa4wBE2Vat7k/CXW3uEXTWn0hHzgq2v6zRL990wR2rEQLEUCsjsW4OzANefDmX8dqqzvYfdHZ90X1Fd5id9XulLEM9oOdoXa9KQ/FI4QjP7qUuzx3hcWaa1MP9bzHkD30rjC8jdZJlKX4kQKeJEc6MMST+cmTDVS2f5pPKteYqYDEcBtMe7v8lqRHTGYyYUkXLPl9/bu3nxfY/5lNro/jaiOiMAiIFvHAkxTV9p3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/eRS+bFBZpsjyj8XH4HGp9VQJ8zbf092VarG3XunpVDltjEA3wHThKy6p/bP?=
 =?us-ascii?Q?81HX9ZW0xWPPYU8z7++D10OJ8rD5P3CVW3fl+rRaUiCU6sZAaIIZWbgWIifX?=
 =?us-ascii?Q?XGrGTAjRDOuWIEprXDq0A0NRs6VVwJjrpQ55OZ35YJy+a4RWbujd2z2dW/0e?=
 =?us-ascii?Q?WiSb0Q9E1IN0gKFvy1g4nbsCXCCrH5iOqCBuBB2B+72G5dfhSffEBTyQ8hE0?=
 =?us-ascii?Q?kJjwTK+mAUn1hGP+nES1vrGX4DY9RgFpCcj9t6d5wfZwsZ1xc58tN5RBzsDC?=
 =?us-ascii?Q?mceUKfieblhDx2uSYDcWcWduhH5SCCqaugHjCADwsjoMMXwALq82ph38RBEj?=
 =?us-ascii?Q?66kPp2ZGoCm9WnJlu0EKy3vCZdogDfTnjBqYSa+K/4uq5cPFetKZZGsxzk8t?=
 =?us-ascii?Q?60QMjnc725GHeP5vAG+maAIXz0wsfKhNLlAvxKGb42x08CQL2WF39QSF2dgi?=
 =?us-ascii?Q?VJaELrtS2K3CUVKXV9MPctMZ1si6tedJsky8ypyvzQA4eNFiTqgO15gWRooC?=
 =?us-ascii?Q?jfom6s8PqJaTvdJUoQfYXJetrm2aK7sE1O9DCiyCNMyEsFPjuM2xzbOQlbKL?=
 =?us-ascii?Q?qBoXK+bTqeiz9FVcLq9fMTw64bNNh1mpM0IFxy7PKMl/8BHVcpLAeIA8ZFTq?=
 =?us-ascii?Q?Em2V0C+DXsjk+XgBFB0ADLvBhSjJ6khC0MkqMWD9GCkr4Xp7Gcx0aA6JAXa8?=
 =?us-ascii?Q?OoCX66vOe5oNicIp7Yx1/oFpsTahi6YgADVcTWzIOznPpeYs1t0/JvCtrg6l?=
 =?us-ascii?Q?WjwczWWr5a5Xs7J+cn3TvzrTfJDHPz3ZdaF17KDnURWKZRXeZLowS/lWKGwZ?=
 =?us-ascii?Q?vos7/hhthYdhJHUGZQEsCTFW2H3j16H9zFPDiT1dR0DQUGzSXxJihcm4z+Vz?=
 =?us-ascii?Q?Kz0zAN1IwhVnL6+9dwXlAbbOq13/XZ5KTIB9SjTB1Chkd4OcK6LTNGo5rHpI?=
 =?us-ascii?Q?NsnC5jjyK9o1vf9Q757BqYRn1IIfZjzJZi5l2dcZoUTBJoxe0phvMbYL+efZ?=
 =?us-ascii?Q?h6FVgZdKSxJOUVQelpp44xfA9H9WXfh+sWf7reSb0J6gDU2zw+Sg2QQbpNYK?=
 =?us-ascii?Q?77twHXDAQu+e6SC6A6VuOA2MDCZKXpZpoPCFrWdzZPBQnjxz5ypmlM2Pv3Nl?=
 =?us-ascii?Q?KpnTKsFzTYf/9XyY1KPBbea7MXiyfrGGBLHrQIBvBwzYfExoXcXmfmAG6XGe?=
 =?us-ascii?Q?DP8iZ74DNtR0LuYfF6htIhjNRX9a5PAKVJSGJBTObmHWBUlBUbvQnbMi/4Yf?=
 =?us-ascii?Q?2rizsBKysqR7gQ6zO6LxptintsJwyDZMeSJ13a1FouA6hu385cwkTuHqn5N0?=
 =?us-ascii?Q?1q1A7uU1tBBckdTB81CUDqwNg3rj/Qc1rwobHFFPfvMl9rhmvyQ0e17+YJAx?=
 =?us-ascii?Q?aoseWuId/bxWVnFhZ8bjDEgLctEhf7xlSoiAIwR2/ETS7M/nDIsrncXY5uc9?=
 =?us-ascii?Q?5oB/v5Okh5Nnur0oZMu3cAy5Ebgxgyjh04QQu49RDbb8awxEBQLES6uItn5K?=
 =?us-ascii?Q?fP3n/d3r/x6/LIa0l456rYRqwcOBE3G4tq7zLCf8+DZRxwVbT3MlFS78SgXr?=
 =?us-ascii?Q?Ya7vKjPj+6FqS50qu1hEi369nOUqzmmtJSVC419Q56FlAyMSz0zf4aqcZ7Ws?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4778ef92-05ce-46eb-aaff-08dae9cf3059
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:10.6281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ewz8ue5HnOJUtGzjW8PrJK1dEsZV4Lr2eaFHy7MZCChCDqnVkbK0r0Pp/9p2paWPeXRPAUXhmPgf/ppibKWoWsEBwRG3sLR15cwwYp0pjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-GUID: nqI4SwJVQdLdkGC3n3SI6aVYwUREx7f6
X-Proofpoint-ORIG-GUID: nqI4SwJVQdLdkGC3n3SI6aVYwUREx7f6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sd_mod to use
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 83 +++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..2aa3b0393b96 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -664,6 +664,9 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	struct scsi_disk *sdkp = data;
 	struct scsi_device *sdev = sdkp->device;
 	u8 cdb[12] = { 0, };
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 	int ret;
 
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
@@ -671,9 +674,9 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			       buffer, len, SD_TIMEOUT, sdkp->max_retries,
+			       &exec_args);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1583,13 +1586,16 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+		/* caller might not be interested in sense, but we need it */
+		.sshdr = sshdr ? : &my_sshdr,
+	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	/* caller might not be interested in sense, but we need it */
-	if (!sshdr)
-		sshdr = &my_sshdr;
+	sshdr = exec_args.sshdr;
 
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
@@ -1602,8 +1608,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				       timeout, sdkp->max_retries, &exec_args);
 		if (res == 0)
 			break;
 	}
@@ -1745,6 +1751,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
@@ -1758,8 +1767,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, &data,
+				  sizeof(data), SD_TIMEOUT, sdkp->max_retries,
+				  &exec_args);
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2088,6 +2098,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	int retries, spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 
 	spintime = 0;
@@ -2103,10 +2116,11 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_execute_cmd(sdkp->device, cmd,
+						      REQ_OP_DRV_IN, NULL, 0,
+						      SD_TIMEOUT,
+						      sdkp->max_retries,
+						      &exec_args);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2163,10 +2177,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
+				scsi_execute_cmd(sdkp->device, cmd,
+						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+						 &exec_args);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2296,6 +2310,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
@@ -2313,9 +2330,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC16_LEN, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2387,6 +2404,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
@@ -2398,9 +2418,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+					      8, SD_TIMEOUT, sdkp->max_retries,
+					      &exec_args);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3637,6 +3657,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
@@ -3649,8 +3673,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3790,10 +3814,13 @@ static int sd_resume_runtime(struct device *dev)
 	if (sdp->ignore_media_change) {
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
+		const struct scsi_exec_args exec_args = {
+			.req_flags = BLK_MQ_REQ_PM,
+		};
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		if (scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				     sdp->request_queue->rq_timeout, 1,
+				     &exec_args))
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

