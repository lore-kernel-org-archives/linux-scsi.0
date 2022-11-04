Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90903C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiKDXYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKDXY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2902E25EB2
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj6sE013842;
        Fri, 4 Nov 2022 23:22:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PcWhoyST+OnlaYBDH24JC1tHpddkmBrRH3kjDnVU9Ls=;
 b=3b7a6eEDGz/D5WMUZFxb6NyT3eubEfd/AD7PwYtAzL7miXyi8oBpF0KKTjjVqKYCwzeW
 tdI9/pA7TfxOMNsW3VlJ2jbJTGO7g5XkSOxqQ+bdDqB2IrmqSfZHtloRL5rNKlNqQRKo
 CzbKTa6dRPZpM/MNRU8N9Ysd2t6mTA3AhQBtvlpp4kySTby4aO1fsyMzCFbimanE7taU
 pHS+tbkWLavS+GXz3UTl4k5g3fFUsGFDvFd+5qyuHO2iFX+Jb50kG5IgW83DRBIxXVMe
 25tVSB53APfSAqFyzB+UNL8qqH69IHO5vplPgwr8eb3/5CnSNBzwZjPN2wQxVqRbR89Y Mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hgyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N2Amb033107;
        Fri, 4 Nov 2022 23:22:09 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmq86gdpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShlArXii9bAIMsHGOef/F1KcslSzcHXhJFIo/2jSjgz8u0c4lnHTn6HoX9iR9+kn6l+kzgBGECOI4Hlkqj9raV4YI3Kl8iiTAL4lAKPpL9Nv99wtKrNBTLzhAqlZa5CDGNCfXAOzeEgO0wVAQtgYgEcF1JGmgZ48cIlSAbJcavg8Dp9HegceMVq+gbXMwvyh2Ckni3iWExNtBoA3FRJnPeXomsUvB94x5pRNtM0RYd32B785wEwhftgB/6IqVQ65+E+ZQTXEDcDu4+J9N2axoniN1yxTrQuHPehvgX/yYck4nWVDZL4cpjC6gBjkj5dGIuaUjloG96AEgiHP9vhvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcWhoyST+OnlaYBDH24JC1tHpddkmBrRH3kjDnVU9Ls=;
 b=Ly4WaUD9Gb3ukDgEc6+bzEr2aZJbp9HXZXG+daWrPUJhJiBNdoTdomsDypzKkSuOfHb9ZO/CtEjB6UW4mfvOUR7AEungwu0fUu/bqN/Ct2tqI2A9vqb/2cRbyUgvqKnRsCTNtxoxAq+/r4x2IHNaTz/2yGU7Xlrg0qo/BOl/LvHa6vjTrG4lKA9oFmQOuTAEpRRMzh8bWqkRiMH0MsyNzpLCKb1/HkN2n9yDdrraCbicDqZ1n5rn5XyRBeSgDmORWQB4hK2RXKfxSuwE3kiX9oOA6P68b8xz5SiF5rcG854CyP565Opj80agWceJoTnPKZpYF2GZcvOAhKBTX68Usg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcWhoyST+OnlaYBDH24JC1tHpddkmBrRH3kjDnVU9Ls=;
 b=iM/Nxs5SNr2a3GFBFJAiQ9Mfa/GPwfA49L0DwVbIX+25Dkpg7nTo3DC4zFZl3QGLDn6jJB1d9O3/3qycX2h1MLoP6/UOP11tmczVtKXgeJI9KH7DPl+S4wKLQy63Z2TbJcX5EjfxiMLkf14PPANkKfD9IaxEfgKXePb4q0XUazU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 21/35] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Fri,  4 Nov 2022 18:19:13 -0500
Message-Id: <20221104231927.9613-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:610:75::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 94de0a79-f995-4572-7120-08dabebb5c75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+oFG83TES6oIlqHOh6oC2IW56Oq1APEAev5JGpbtAB+CxSjXPzP0elQ4gJfXZ/XoCNY5mVJ01sH+BzDCYqdj3rLdC7rSdH0krTkC1sz5fUbxCvlzCCVgGMONve4ybJ3BRtOZb5RpxaI6wcdBu/pnZZDSXUUbd/jCTBbBFimaGKuhND49h5/7XsLV0Z40lXUdvneQeJRiLphoJuXVJJBywzbOpHlcg1UZG/X48Kmr4tOCfmDhBRjPmZNi9N8hBTAeqnl/yCLoGrWOgIxO6OhFHRYbIGS/g6LdYdDDgcjcMfgm31wXeY7zn8Bw4uWBl2ciiFiXW7FbsDA/tyzUIY/pixPBYvUtnYSKkUZAERf8F5wVrU4bjgUhkyxnr7+ANxYj/1gNChaRLLg4K/x+kVzJMoZVdWZQzQHs4E6FqfkDqe0YecxGMWebUhWyPr/59sF5FP1Y6SuuCo4RdMZ0gIOzh7nvpnEA3g3dW8KU/VHiudfHfk+LbeDysGbvBl0a7g1vFtIzEVfXAUjZWhaAEEwZ1zprTXslbAmrBeotQyWRqhjRmVXX0x8dBivk2Q1PPaVRtZS6b+99WLjv+Gafhs3o5q2/Voa9n2PkgkANgc2yUac1ICopJDPStR653jxClt1TZ0ERX8C0FhMpObAUcdaayHBpEFsXSsstw794WGo3mQ/TKBtq8TxjBL+YR1zr2iHoD7gbKUqfaXChIbJyL2fvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5O1SRoGHiOCedx4BOn2Ats/sdDF9Gf9g9Mkf8OsmiBzUOSYyf9rWTbdTNQVv?=
 =?us-ascii?Q?e1EjLTtGXqm9QzT+1SKy3q7o9grA7XyqraMfS3IiwmICo2EObbnC8ezMJShw?=
 =?us-ascii?Q?RZMunPjfogBel06wPLFznSbpqYXlONvOwxVpOlWMLzlLbo8UYIvSgsLFO30y?=
 =?us-ascii?Q?Hnfk13iizSsjpPfXqspt5aJk7yPscV1Zqr7DG3A78U/CTyiLh2RFguzv0GBF?=
 =?us-ascii?Q?keVGYIC8y9/TwVpqKva/7/sK0plIYEmNlxCRNe3GkViHmobeigXZAsNHXx/M?=
 =?us-ascii?Q?C09QeHCfx2KSaxAgg1ghPPxvS2c0kJSebG8tThtq4FXmrsymT3wUKPnslOG3?=
 =?us-ascii?Q?QvSl0WJ7x9PQJCUKD5gCBuYHf7x6Gn1tmAaThgrs4nIod5ioGkr7lYUMIqsQ?=
 =?us-ascii?Q?jWTOB76R7ZMLGR9cqXgAv080Ay/xph/QXgUn6cv5pu10eT6CzqQqPwKXBL+c?=
 =?us-ascii?Q?AZmJOHDgje5xd1LbetvSyhxKJi0VmzfQP+086bIZMHYWqxkyVS3SLnxKDsNb?=
 =?us-ascii?Q?TuuHUGgQAu920eE4IryMx2XnHejbFJFd7GLSM1CZBz3z8b67rguRHEO2emSC?=
 =?us-ascii?Q?L+5jJIlNFgUr2ZvFaXfBY+t5L1OBHIxPvO9UzD+gSuDm+nmUBjuhxKvENcnT?=
 =?us-ascii?Q?NXMyYJMAYa0oZnpqYPqWgrYMB1W7zffokSbC+u3EcBOdnIioo1yX1FscUfGx?=
 =?us-ascii?Q?8foupOe/QFc8pih1oiss6hwA+Vqq/SD2Fw2OKKr9gwfBL2/jTWS5Q6fW8SVc?=
 =?us-ascii?Q?GvDxcNLNBmhRMzUDV8AP3xD3xhDqNcToeTqfY3hRQ2aiHWIYBm7p+Yt74sKd?=
 =?us-ascii?Q?6xKOsh5gfaNOyFrzDNimrCBzc4pQWdOo+uxEEAJc01cuHt/JkVwqo4iH4K+c?=
 =?us-ascii?Q?d+0jqHkp2tzTLxdMwuGvWLZt7nQtOR4Ll6HOQgUVidXLx8MLV8Y3d5/3TsVz?=
 =?us-ascii?Q?GQvDFyTQhixQ/717GD0sX1ixzgLEz1VKf8hwNiN7qCTjnR0RYb5vdJA1EhTd?=
 =?us-ascii?Q?loClvW4CDdwyoQmEFLwTnreKsHrnO2+0yGxeN9v2GipaejkWpjvcSdna/Elo?=
 =?us-ascii?Q?v6KYVKDp5lRhlwgzNWCx5nACvJHWGnGd/qqNsbQvwof2FgCnd4Hv0iCZ6rL8?=
 =?us-ascii?Q?eCOxh9YrdMSEGz5DObvYcb0Y3HIArJRYNKBSP+/4tNmB00fd/qnDRKlmRUZb?=
 =?us-ascii?Q?ERZrf7/BoMujVROhMHNqqTGy9pFX+tPJoeqRKfOxDaSVlAJbo+RR6qdyOsZL?=
 =?us-ascii?Q?k5rFmeUsF3/UcT7UsAkre1zMXQGHfOUPKqNIrr47bPk46NGRlGmFoElC06Q1?=
 =?us-ascii?Q?m0n08lrL9GNxFmah1qfgoEVgf7e9VJQwuuQ6aKiIxmEg2btKds4/hWBMB5VS?=
 =?us-ascii?Q?w6ouQe8Kldz0qey8MbSzPq69kwhU4ob0bt/dLI35CKng+2v7q0Z/5Qas2mg+?=
 =?us-ascii?Q?Jjbd/R3StA81CkDVwpfV0+pC/4u940Xvfb3XE63xfJTTbDPcW7iS9wR8yF56?=
 =?us-ascii?Q?ZiufI02bdOLJI8i3UiE3VPIaD0Ybztm8hJVxlsWag7wQktDQEWGzsKCsJhQh?=
 =?us-ascii?Q?NGOvF6yptfKITxWXTwJn+B1SP834DnKoF9EduocPQH+xA28D5VvKPF+F1Rke?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94de0a79-f995-4572-7120-08dabebb5c75
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:54.7427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjIXLt+UwWzfnKLBQpCWL/IDeN68h9khXGZtwRrOVC3QDKNugRmlmqr9HWF6r3lndUJY0OOfujeRVpshXzjdJK+9PA6tPwmB9W3BoVeci1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: aN-iuXuPE2RsGu0jryNyaxjYDHXqsuTB
X-Proofpoint-ORIG-GUID: aN-iuXuPE2RsGu0jryNyaxjYDHXqsuTB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 115 ++++++++++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37eafa968116..54e599529a3c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2279,59 +2279,94 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = RC16_LEN,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
+	memset(buffer, 0, RC16_LEN);
 
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = RC16_LEN,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

