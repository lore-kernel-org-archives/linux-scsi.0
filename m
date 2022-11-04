Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36736C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiKDXYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDXX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD65B85B
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj6h0013351;
        Fri, 4 Nov 2022 23:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=HYr9EPXTTPYrG7cqF2qW4pLjzWoSFKj3vUsiaa8kca8=;
 b=w60KV9ZM5xf7zor884rE+xxmrXv/a1d0rO/M2qKlUDF5BoezJXkyiZpLzFt3gC2JebGH
 aIoCqtpGXbKKX+rEwmHDfF6FsAJQ3CmR8DIcsLQjW9psdPy7env1Lt0Uljaja1jTk3IS
 6nd1xmWHPUPW2YfIvwDVCg9EhH589/Pjgc8HkOSITz51kVzUAGumm1Jvs+nAI2UfvkR7
 RuV37AKqSKy2wU0JyrKCN7oqgJGKmNkic0KySZf1FlXsCbtvYMlZBgBcm+JWu5sENPfp
 qsiGD2hgoUYDtvqAGL2p9W3wB5fbUer0i2VQdiV8Eij2Eujohh/zziQQTbIV/j+GrKsP lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N8CA5014069;
        Fri, 4 Nov 2022 23:21:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4t9rr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6CS3GPYBM1pKR6p0L/hw9ZMxG3OBUY1iXaGG8q9bqcgRgmywzAyizVz9si8HpCKfW5Dvk6heAtZ+VXUCv2NLrJHUKjuze91x4bXRpBPcC0M6vtrALRprtxqsJPMdTe6gaTKkudp7C6qmSVirVTRbqFD0+Ss7V+/rcmeZf1csJLMEnlDFNziFKEfgb82/WCdXSUlBQqxiE/vwDmxegJO8WC62BILOjM4Iidix1BpO+RWdBdtTKMpKVD91jWwIs86Rb+1ANyS/yyr+CANynF6KhVXRdmJG+KoZy4yHX/tC/draLZsQMOLlLbiPm64Hgs0nns+A6N0EHqmcl79dfLAOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYr9EPXTTPYrG7cqF2qW4pLjzWoSFKj3vUsiaa8kca8=;
 b=oD07qDUH4jDreHKNiSVOFgHsHWbVhCMAVJ3JvHPMY2dG58ruybSSywFDfbeET0di2UAx7StZyn3YDztN/MkbCxXb36ur8Y1ZgJEqJprOUqG0FJiuh1a8UqMqMmm9GvivuUBg3MFwqdY+5Sp7CR23mrGKtuJsCDbR4OooWB0D0TiF5i6nfc4vZN06TiNHWzLcu8qZbJqh9bb1ksbVPEQf/DSclyMk3FoilLRIgPT9opvW06HgM2L+3Nj/hFvGP1lvQozS2ljqP83jL2Mf0Xh3yP01Cxp9eSjBGkxYGA9e+mDjx/6ARN7ZBY9UeBeUVH9JzF/qgizO9+0swHe63bNkFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYr9EPXTTPYrG7cqF2qW4pLjzWoSFKj3vUsiaa8kca8=;
 b=adcMT3FF2Mk46vsqIQFWNCZHZlymAiaYMPDh3cPiReduAv8mvm9sRGmKEy1yZk1Sm3Zej3i7IjqOTwl/2+XcTf0L6B4ce8GTG1iJs4AGtATOxpUi+Vgrsn6XLdCmuJBqLhGwOtYdAyYHPjroDWdIHf8vMeMq0WO4qWZPWhve/G8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 09/35] scsi: core: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:01 -0500
Message-Id: <20221104231927.9613-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:610:cc::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: aa0a82d2-36e6-43aa-6b3e-08dabebb5277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilG1BLZwMkqopRxtVvT1u+Wp1lR45zwG1LFys1Gp7voDQaiFfnU+qQFSDewFD0Ku8M0HCtA1LCXvVTP7R5XYZWfZqpRZeyugK2n7ESOSbWkhj0k7ZX0MCMSvawDSkxBsuL9XspUcfsNt7W3iD/UeIBT/qmoBOd3U7PTP7CONiyfRPRe0LNoQRuZQnQdMMXJn55RWXpjZm2/Np0Xnf2J8Cwglz5z2H7/0CQCVrcCPxpBH2/52qwyaLen14iLsvOjGtYVao6naD0ts3blNGdDDm2fmF9aMQD7TvxDiL7/B5DldJh8jrgEOaMernBUehGvlgaxjEeg3g6rHChrKzyQgIS8Ve1ky+2SOL2L471poA/K+pWd+Ge0nARaQBsKgATWJalAJEIz6By60boaPqSRmw27QaAwL1+4E+ISICcw+YYnF19GQiKem3mr+oAM4RYlSuYFs3B5KssTxv15p99rXntW0wby1eyDbZS+NhGVFfqqaAE7Xu0edDbYgBvavnPlq3UnduKInX16yb+mFomYYKGDNIe489Y34hZiU5BT8GHIuuwnazFAHNfSVz0bYn+qEGOZUdDxQQkr64wDyDW7QMxBZ3Km6a+F7p8Zys5xISVwPxhIAIoZ3BoLcfAHa6mxGdY1M+5/WPvdcACIq+Sl/Yh7PHbBjPgnCxtoegCM9xTPaOrCtsyhMm+74V9oRwGhOTp5M1bWmtEsludpYSUmiuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gh0rXaycA5paCPy10oG7sKIGG61pgyWqx19RriH4B/ohwb1hLYfVvGrw2OMH?=
 =?us-ascii?Q?wTx1i8djMhU2cfs3ZBobxI9zgrAvEOTIInqeoy4/wy+W6hrDVXEQcjK2aZUm?=
 =?us-ascii?Q?dNHi/PpCPpH3wqT7mXN7ChTvIBH8xsRmJyL5FnFkUcrN074jubhn8acMdR7h?=
 =?us-ascii?Q?utifgU8G/NKPybcJcD0qNvLLuJ9x+LeAQ9IUUXIeuZ2Dao2ZRmvjvE46cw/F?=
 =?us-ascii?Q?MFaT7am1GqzrC9WOk/7O670hTzsElxiqwMl9nee+ejHFue1Dg/LvrlLibI+M?=
 =?us-ascii?Q?U1sBBxbzWB6M50/Es2P+QYO6nJAsiW1Ic31Av8hNsWpKNDdNp+MXMTkFkwyw?=
 =?us-ascii?Q?AEEbcnp8jiqJ5IVPpmx61jGN1nHjhKWg6LPvz9FlrnK0UL51QLtE2AL0tqF9?=
 =?us-ascii?Q?cLuUbwgQBGlrexafIvgwTbzuhnq2ILzGxqWJo2QuSgemhJMIumsoqOCvxn96?=
 =?us-ascii?Q?zcONlpsAN9lZjBU9dUVU8RbmnXW2Py/53q2L+4xUEoAToUUENy16QbD/qSTv?=
 =?us-ascii?Q?gR8jO7ub0pubwEAy3oZLj3U9FOK19URERAqumrBO6xgtW4xEinc8/PfdDyxh?=
 =?us-ascii?Q?VFRynOlFkvxmTO7QgbkPY/k/I4EeVrYoLeAyaxaeIM2OA6n9zX6TglJGTxcl?=
 =?us-ascii?Q?7XFumgAPkaZS+HZV9Q6dwjJx4AtLd0qbiacCbCa+WegrIP5+IJ8sxstsNPEA?=
 =?us-ascii?Q?7XiNlahCIDdwJhhyLkUNTt/U1Tqg/E1PelQbgKMNIOApB5hGVh9T0WJMh6cI?=
 =?us-ascii?Q?RIZl/GZfFJqpAlVqvWBtDKRsKgrgiU+3VZBjYYi8VUNuXWzgBeApJxr4I3ev?=
 =?us-ascii?Q?0ZY9aM5rx/Pra6hr2N+pXuk3vAhXBIuQG3sXv6j1VXk79dMW8pVSgpyOGCmh?=
 =?us-ascii?Q?aBrCoHxsPLlWpvBO9U+qCUagg20wXREavB21IhJ5+CHWNzeiIx7dkSiYJk5k?=
 =?us-ascii?Q?qixwJ5NEA+795gJ52qMPjpX3rQhfFXOAolcAAvjwj0ftMLPy68BKISqX4X2+?=
 =?us-ascii?Q?X3A4D8LWMpiYk+VXlhaJj+D/XNIX1t8b5ui3G4QFR7bgeiQ1/gsDCstXRXwM?=
 =?us-ascii?Q?/1mA16Xf8El9GKPAoCVqzxpyzlPyYZmywzbyB1sE4Y8kr1Oi8Aewb2OLYPdC?=
 =?us-ascii?Q?Ae7OOqoKoIuTwgf0l8/EFFkBSTskPFQNcJPpsmEM4DBfL9rsM5crJto0DAmd?=
 =?us-ascii?Q?TSkL2leCvw7VYY27VjVrKGpeRkUuJOKNNMF9HhUoZKsrJDqMa3wj0FaFz101?=
 =?us-ascii?Q?dl6LuhjOEhB7Vhedm2lD8+sMBTEpK1YPjAsexG4O+lfGUxRivhGl2pCwudHN?=
 =?us-ascii?Q?tEQEuSRc4/EZOJT4wONcPJzfz4indo2TQ58l6A/U/P5Go3RpCO4esrBewVXJ?=
 =?us-ascii?Q?vKaawwvkGPLsVF2AALuMN7lg/6876cijkLA6NZxyXoHCzvRk/qBcSB7cVKo/?=
 =?us-ascii?Q?er8q9p04N/qK9f17iHDTQtXMOFaYhZW8sDPtlzV88pKLhpN4AW5HhQKQGE/C?=
 =?us-ascii?Q?6d3T7lN0jo7VdGBvNx1F0RU5o3FguzbeRXRlufvPwz9Zng1RHzQ3t8jHCmsF?=
 =?us-ascii?Q?2zkYknFPVtxiCiavAVkt3R8cWehrZzR5BL/WYRnzSVpCdpCHGBfQsoWWAXeR?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0a82d2-36e6-43aa-6b3e-08dabebb5277
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:37.9472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEu1xto6e4DlvAN+CZG0hife1NQE4VHJc3veh3LvnYPPeo6613VNkxymcwL1QLof+iWrFWnLKmPkdNmgqDZUwmLLLPUU1d4eihoeP7+HjL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: YtOVGPK86FWkCWVkmuU4vkAUS1-feHuu
X-Proofpoint-GUID: YtOVGPK86FWkCWVkmuU4vkAUS1-feHuu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 21 +++++++++++++++++----
 drivers/scsi/scsi_ioctl.c |  9 +++++++--
 drivers/scsi/scsi_lib.c   | 31 +++++++++++++++++++++++++------
 drivers/scsi/scsi_scan.c  | 37 ++++++++++++++++++++++++++++---------
 4 files changed, 77 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..e074e572d478 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,14 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 	if (result)
 		return -EIO;
 
@@ -531,8 +537,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = request_len,
+					.sshdr = &sshdr,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 
 	if (result < 0)
 		return result;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2d20da55fb64..67f291cb0042 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -73,8 +73,13 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9b6dc47bcdae..8b2a9388420c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2123,8 +2123,15 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = real_buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	kfree(real_buffer);
 	return ret;
 }
@@ -2188,8 +2195,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	if (result < 0)
 		return result;
 
@@ -2273,8 +2287,13 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = sshdr,
+						.timeout = timeout,
+						.retries = 1 }));
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..58edd5d641f8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,8 +210,14 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+	scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = scsi_cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = result,
+				.buf_len = 0x2a,
+				.timeout = SCSI_TIMEOUT,
+				.retries = 3 }));
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -674,10 +680,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
-					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = try_inquiry_len,
+						.sshdr = &sshdr,
+						.timeout = HZ / 2 +
+							HZ * scsi_inq_timeout,
+						.retries = 3,
+						.resid = &resid }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1477,9 +1490,15 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = lun_data,
+						.buf_len = length,
+						.sshdr = &sshdr,
+						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+						.retries = 3 }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

