Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90774CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbjIEXSF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbjIEXR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5F6D2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MZn0V004023;
        Tue, 5 Sep 2023 23:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=vDCrrL8MAoxgtZcSnNg21nV5IHjLXopdnb7bitjejp8=;
 b=wdf98Na7r27AW6mfX3XcLhp1EEX/F0maCwSqa+2CkuqlexBIKjfyRPp44T1DRPx8Dm6O
 f+jLgZ3fmaPIeaaZlXmp8GoGqsaR3PGvu+HWooCc/KzP6JmRWFDiTxGDdhQZPFMJ5bC3
 kMBlbf1vt7ETaAJmaVDGuOGCNhpGujry5vsPIy5uq6XmbvO6HLYgo/BPYoNqg+IPoBHD
 j3muNnlbxy898mzX0LwAZ83THCADzi1uwHFRO8Ed9nezDxM8IG7cmdD0p5uunXBE4Fcs
 PAyX6Lv5G8BnGZiUoiVFiwjsV5z09bNj/J3SbSQj5LfEF5wWrgzJeJiMi5uMMkBMlU6x gQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d8206-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MD1JP029122;
        Tue, 5 Sep 2023 23:16:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dy64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Di6nmLkGF+ctoDXBH/2bqFBiWFjj+Sht26iDWXw3wjhcZT3jIeyVvppY8mjJargmXimQpKDLs+aFJ8iuG6yAwBx/3dcn6zUaEde5s/iBodK2K+HnSwLTCSHVaCI8NT0WjxHmi8mEPAgw23h3yKWGphyadqLkwLEbQjH6Ji37TbUhrIqGD1aR+hwmmM2MVqiFEvA+eVIAK/tXFMhpxNTueulPwQY1fYleZ28Jf1295ehhSwh45qJlNycJczOsRPHD9KFwFDuoxPxoI6kwCDGKru79MI/uVivI0w8AlrP1P5QufcugK+fRukGsX4h0d8xypURtxW94tNW53rVBKcSlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDCrrL8MAoxgtZcSnNg21nV5IHjLXopdnb7bitjejp8=;
 b=LM3YY79ZHqxfb9LBYbljNnNmPpz8gDnH/WPlk24FwnHaqu7JVDs51QIxjKhKmwsengVSPAxsj4eK+cd/HzuUNoBy8Ly/ic78GezGInIfMY/ytgtehncVaNoxG0ghqZkU4xvidap9XEq+NCs1wp9gyK2WZPWCV01OfhVrSxrchvpU527oe2Wem38o+tRrnxNMnoDk7avBJ6fPyUnQ3Wn/AIj3CyBNeT9PJqIwL7//otMYvOnB3S+ya5W9qxquj97Gw1kref9j+I54Fu1Bq7MDUgLAbykeFo+nyBwnzuAXCj4+b3+886SqVJf2LVGI3BhOTeqOcsO9lQjLAev1GBWDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDCrrL8MAoxgtZcSnNg21nV5IHjLXopdnb7bitjejp8=;
 b=LvaFxkwqZsVaR77/Dv0R/15Slh/CwzC2BeAkrCw4Q2bI0tzr1ql2XQBDibplnze+b4jX1Z5LCxy/+7kSvmr4GNg7uBO+DV0pxcxFvKav9nKs350DB3+YHD+OBh2lWSH5mnNxdrRAjktWL24eZnUIKvUkVBLYuUI2oPgdpOA+WNU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB5287.namprd10.prod.outlook.com (2603:10b6:408:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 25/34] scsi: sd: Have pr commands retry UAs
Date:   Tue,  5 Sep 2023 18:15:38 -0500
Message-Id: <20230905231547.83945-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0307.namprd03.prod.outlook.com
 (2603:10b6:8:2b::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f593e50-9de5-402f-a5f3-08dbae66268a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ACGW7q6BbaM4aqlGAqxCXlxkge5pAUVsrDyMDKikl46+QLa9LtEUViSaFbNcIWu+vZsFEOyvi8Kta9E1dsd5Eoz0ckMVkAzhPt01039pngZIgHhXMH803WB9+85vlwDeCUrx7UxjQN2taqUtj+XLlivc9H+LWCR6IsBBeeOqIWqpBzzwIW8Cv0KvjnfZrSULb9Tziij5+iFsamjyWhJqw2D5rWLqGON3BMUAVkL4x7ckFo/kZ0OnftvnfM1eQm87fmOyePlB5P2ANTZiwB3adUBnSPePDmej49yGkYIwZN+BNDuQMr3i4GmevJNZjYCDfrAqK+DtItCdIXRB9F9V2gIRQ8pVRFBxiDXKpHkybt0H/EAaTgZRMNMZvDVtrrqBl1oILthXYMqcjFI8rMO0IKcJOeqGbgO517YlbAwufJBZc49a6l6fS3/nXZQC9IOxCctc/QhHvjmWvHJXUB8VwSj6gFhXUrIrEoeCt8BleIJabTMLtutND4INZRXcT9iv19M16CIj7+UDtgVRNqXjkFgtYIdcR+ofl3wYGU/dbiuxOU8prWtjV0MjdoOPCgJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(39860400002)(376002)(1800799009)(451199024)(186009)(5660300002)(8936002)(41300700001)(66556008)(66476007)(316002)(2906002)(66946007)(478600001)(6512007)(6486002)(6506007)(1076003)(107886003)(2616005)(4326008)(8676002)(26005)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iwSLXMk4N2Cx5H7bdfF7LFIa+I5KzO0pxr+aYsMpANp4FutQdTZg+GHpr+sY?=
 =?us-ascii?Q?DrZPffZYymQ3u3Y65cl0svIdEFlMRgngNnBSH5UdooqHhh1+82syJX//HnfU?=
 =?us-ascii?Q?movPUhJxgUsKr6nQUJddGEt4sZHFLme3o9qSJep0d54KhrhWv99Omt5dHTtv?=
 =?us-ascii?Q?9ivuxRaS74cyhvxqFMQLVPvNXl04g8Gz6NUe2P1ck0rSKycOjetCyZtM9so2?=
 =?us-ascii?Q?8DUNSxifb6Bo7TgkPtjoEAIb12PEWPkwGPcZxssQkahptuY6xBaZJvMVQiO5?=
 =?us-ascii?Q?s3I5ktjAVPBsU6qBMhtxe/a1Kvl0iE/Qxt7QHI5To07OLVrQ+qEzzmRA9izo?=
 =?us-ascii?Q?jyZK+YiOBMHkCQgdfNKq2rC66Zceli2fSrA7HV7isv4zxYkfCU6Gf3KdR1eP?=
 =?us-ascii?Q?gj20hx6LXKWaLlgQgcaOy+JoIargZDjvStVLfJsZb8ZRxZsRVQcoyn4r7AZE?=
 =?us-ascii?Q?x+Wb11AyTM1+ly+lBI5mKC0mFPTppZ3kCvzyPC2AXglMAl1xXZhug9lFMwh3?=
 =?us-ascii?Q?mOSOmVE0zs9J30Q1K9NlY9RaoOA0qV+VMY/4zkuSbO2AQoYdV6SqdNofNC42?=
 =?us-ascii?Q?c+okj2dXoSVhSej7GWixQG/LxcA7m1lSy8irKr6zQ92qzSBl7abGA4SalL7m?=
 =?us-ascii?Q?aa8OAHBsdJ19DKK2hoXYLQjC72GuPuBhOeksKhQ9DenrKydbefM46cKL5tL0?=
 =?us-ascii?Q?iocv+hH3nDPDG0o6EyiuV0iwBMnK+WZNKutEB3XNW/GyHqzLp36Wvo6Js2RZ?=
 =?us-ascii?Q?CwhhPDhw7gSjLMVma1WXZPKvy+mShxjPSj1lMgLXvIIKruNDDzKJcUZQDfk8?=
 =?us-ascii?Q?UU7SK1uw6KisP4P03Ybm7JS+CA5AnONqMssWynuFRzDLvPnlIC9e501mFKbT?=
 =?us-ascii?Q?i7UpODbx7N4HBXatHu5/ijHsucFZGWFb34jOuvwOtWu4EGb3RqQpbYiUe1iy?=
 =?us-ascii?Q?bW7A1md84rt3pPwEA3sZv2iqI4WmovpIDy5sQyY5m5lG0G6hto1mXthjxSnL?=
 =?us-ascii?Q?HvXjdmewr1BqfJQyUEnFvb1OmIMqD48ul4yK1i4P0fpawZ8o6iIRkcWAh0b/?=
 =?us-ascii?Q?GoqTsjm86zK4CiJCcv47blgEolkxysb+nKnZwCAIX5tbRkHnaJlqKzmweZug?=
 =?us-ascii?Q?j/uf4Nmx8+kHRAAUoIyCoOO0r+TuT4Ap0oPNcWV9bm/IQXCdvITHS0OrtTMu?=
 =?us-ascii?Q?VcgBjN0OZRvN3mwNApUsDn+Mzyxk++XJXOrY/ifXZcEuP5b9fFbP5BpnmdGN?=
 =?us-ascii?Q?mTdKYRBGmjkxJio8NpzGZdkRta3GCozPo79huoW5q347HaNMtuj/eHQmLOXu?=
 =?us-ascii?Q?4C6A4IuD66nO6HVDde5uudXuPog0O6bL3YiBJN6jbV1v3a+yZIUv2R9sO8Cx?=
 =?us-ascii?Q?9Fj54HdSv33orHm2xzYDBiwzN0iGLl/kUvOxRne/s3HrUYSkHBvnTYf9BCJl?=
 =?us-ascii?Q?5HKC091rgzapLeoaIm7EuTQdj8bD/MIvcUYZGXwNIz273wIc1OrLswuA170I?=
 =?us-ascii?Q?BSaxgBCABOvyz4kclr6MyYSndcfKQB+fv0UEnh6viFgWp8jYk+89bCQhV833?=
 =?us-ascii?Q?ulKrRc7tOOWPKuAvl9ScqpUiPSGJz3pIvfEfMOAZiRcMQTmjZSzRKt0hsjnh?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hZHpIMqb5zxv1WKQS4/HmRrdyszpXSYbVg5a6o7/ikG4OELux7T4nZcI970hw/k3WMdQf8//IGDwN1hwShIhd8zPJi7Ygn6qZFku01H2x9nPDcs3PCfJohvQMFVqD0QIw8ja+W7mdBJWhqef4EZD2XFAuq+JIChmrXDZqhtOZlUR2E7YnYFHmCVwOqS0O39HQBe1TbPwUYcgUBAe+IPn5JZ3pzwj83Mpi2tuY8YtxuQNabW5yxfvMtdrRCwfPNApsSYlw294f4tw1ctBkyq6bjy6w3Hcx39GifbqluBx0oo58kPpb2cG6Wqv8BrbrsItiWLrxTThnIoefdix062ZjiBQDQa79P4YRvYLNP6CHW9DiEcl6EnGyzXwPbCOHMEIcc8Zce7Oro5IzHL40ceLX9BQ6ecbUepTpM3UA8fWMgzxARtgPDkmqdXVRUKhlBUXPJI+yzfQc7QkbQoeWai+yj/rhMosw4/qLarOhvnak/XpSC9WEjST8qenety8c132kE91hC0EC5Ctt8lKFtOhrMv2FVz2MK6vJI67mr6M6dr5aNYyUnwGhynn78jvyvi0K/MLk0y7RJHmCqwNxbWLcbkxv7EbRxA5tLn+sY/XMQwOwNyur8/OqpAze2vYCKwJLy7i752AdmAu/DOlt5ZuUqnT7DS5+vCnFgSz2kxShO//4NztiOavZNZA3c2ablexS/m7EWJDftH2A2/fMCO7auAkKDGj6O1yMY1SXIYZRUAkCw9pWJD4GJuBAnRpbAu2wTfLXvfAe0tQEXUKTfK8U4Wpv7Xt8ZeKDVU3LyvXZUIKJnnlXPG2A8DVI1Yv82Cr91qBrJZMnzkUdr47nYc6SDqKEs64NMA7xDeTsJYM2N3IOWF21G7WWCUByWQyRAVK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f593e50-9de5-402f-a5f3-08dbae66268a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:36.0591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PnYVFeWYpCwkRbeYhnIO2vS6S8nQ8nQl80xDWexsh+25FJBXYKAotK0+7Bvj+fd2ThrhH8HWTdMn20Gb1l2c9IxwmeGaLJ9tBcWUVWAU4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: edbjNXl4TNz6SKteLgu-_O3iveqMKcgO
X-Proofpoint-ORIG-GUID: edbjNXl4TNz6SKteLgu-_O3iveqMKcgO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6dd2dde75354..5b80f1df4cd9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1718,8 +1718,19 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 
@@ -1806,8 +1817,19 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 	u8 cmd[16] = { 0, };
-- 
2.34.1

